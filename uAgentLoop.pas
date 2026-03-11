unit uAgentLoop;

{
  TAgentLoop - Agentic loop for CodeDroidAI
  ==========================================
  Inspired by the openclaw (claw0) agent architecture.

  Pattern:
    1. User sends initial prompt
    2. Loop (up to MaxIterations):
       a. Call OpenAI API with tools array
       b. If stop_reason = "end_turn"   → done, fire OnComplete
       c. If stop_reason = "tool_calls" → dispatch each tool, append results, continue
       d. If stop_reason = "length"     → fire OnError (context limit)
    3. Session messages are preserved across loop iterations

  Tools available to the agent:
    - compile_code(code)        : write code to ConsoleProgram.dpr and compile it
    - get_compile_errors        : return current build error log
    - update_output(code)       : set the final code in the output panel
    - read_file(path)           : read a file and return its content
    - write_file(path, content) : write content to a file
}

interface

uses
  System.SysUtils, System.Classes, System.JSON, System.Generics.Collections,
  System.Threading, System.IOUtils,
  REST.Types, REST.Client,
  uMemory;

const
  AGENT_MAX_ITERATIONS = 10;

  // OpenAI stop reasons
  SR_END_TURN   = 'stop';
  SR_TOOL_CALLS = 'tool_calls';
  SR_LENGTH     = 'length';

type
  TAgentToolCallProc   = procedure(const AToolName, AInput, AOutput: string) of object;
  TAgentMessageProc    = procedure(const ARole, AContent: string) of object;
  TAgentCompleteProc   = procedure(const AFinalOutput: string) of object;
  TAgentErrorProc      = procedure(const AError: string) of object;

  TToolCall = record
    Id: string;
    Name: string;
    InputJSON: string;
  end;

  TAgentMessage = record
    Role: string;        // 'system', 'user', 'assistant', 'tool'
    Content: string;
    ToolCallId: string;  // for role='tool' messages
    ToolCalls: TArray<TToolCall>;  // for role='assistant' messages with tool calls
  end;

  // Callbacks for file I/O and compile operations — implemented in uMainForm
  TCompileCodeFunc   = function(const ACode: string): string of object;
  TGetErrorLogFunc   = function: string of object;
  TSetOutputProc     = procedure(const ACode: string) of object;
  TGetOutputFunc     = function: string of object;

  TAgentSession = class
  private
    FMessages: TList<TAgentMessage>;
  public
    constructor Create;
    destructor Destroy; override;

    procedure Clear;
    procedure AppendSystem(const AContent: string);
    procedure AppendUser(const AContent: string);
    procedure AppendAssistant(const AContent: string; const AToolCalls: TArray<TToolCall>);
    procedure AppendToolResult(const AToolCallId, AContent: string);

    // Serializes message history to OpenAI messages JSON array string
    function BuildMessagesJSON: string;

    function Count: Integer;
  end;

  TAgentLoop = class
  private
    FSession: TAgentSession;
    FMemory: TMemoryManager;
    FCancel: Boolean;
    FRunning: Boolean;
    FModel: string;
    FAPIKey: string;
    FBaseURL: string;

    // Host callbacks — set before calling Run
    FOnToolCall: TAgentToolCallProc;
    FOnMessage:  TAgentMessageProc;
    FOnComplete: TAgentCompleteProc;
    FOnError:    TAgentErrorProc;

    // External operation callbacks
    FCompileCode: TCompileCodeFunc;
    FGetErrorLog: TGetErrorLogFunc;
    FSetOutput:   TSetOutputProc;
    FGetOutput:   TGetOutputFunc;

    function BuildToolsJSON: string;
    function BuildRequestJSON(const AMessagesJSON: string): string;
    function CallAPI(const ARequestJSON: string): string;
    function DispatchTool(const AToolCall: TToolCall): string;
    procedure ParseAndDispatchResponse(const AResponseJSON: string; out AStopReason: string; out ATextContent: string; out AToolCalls: TArray<TToolCall>);
    procedure FireOnMessage(const ARole, AContent: string);
    procedure FireOnToolCall(const AName, AInput, AOutput: string);
    procedure FireOnComplete(const AOutput: string);
    procedure FireOnError(const AError: string);
  public
    MaxIterations: Integer;
    SystemPrompt: string;

    constructor Create;
    destructor Destroy; override;

    // Start the agent loop asynchronously (TTask)
    procedure Run(const AInitialPrompt: string);
    procedure Cancel;

    function IsRunning: Boolean;

    property Session: TAgentSession read FSession;
    property Memory: TMemoryManager read FMemory write FMemory;
    property Model: string read FModel write FModel;
    property APIKey: string read FAPIKey write FAPIKey;
    property BaseURL: string read FBaseURL write FBaseURL;

    property OnToolCall: TAgentToolCallProc read FOnToolCall write FOnToolCall;
    property OnMessage:  TAgentMessageProc  read FOnMessage  write FOnMessage;
    property OnComplete: TAgentCompleteProc read FOnComplete write FOnComplete;
    property OnError:    TAgentErrorProc    read FOnError    write FOnError;

    property CompileCode: TCompileCodeFunc read FCompileCode write FCompileCode;
    property GetErrorLog: TGetErrorLogFunc read FGetErrorLog write FGetErrorLog;
    property SetOutput:   TSetOutputProc   read FSetOutput   write FSetOutput;
    property GetOutput:   TGetOutputFunc   read FGetOutput   write FGetOutput;
  end;

// Build the tools JSON array to pass to OpenAI
function BuildAgentToolsJSON: string;

implementation

uses
  System.NetEncoding;

// ---------------------------------------------------------------------------
// Tool schema definitions
// ---------------------------------------------------------------------------
function BuildAgentToolsJSON: string;
begin
  Result :=
    '[' +
      '{' +
        '"type":"function",' +
        '"function":{' +
          '"name":"compile_code",' +
          '"description":"Save the given Delphi Object Pascal source code to ConsoleProgram.dpr and compile it using MSBuild. Returns the build result: either \"Build succeeded.\" or a list of compiler errors.",' +
          '"parameters":{' +
            '"type":"object",' +
            '"properties":{' +
              '"code":{"type":"string","description":"Complete Delphi source code to compile"}' +
            '},' +
            '"required":["code"]' +
          '}' +
        '}' +
      '},' +
      '{' +
        '"type":"function",' +
        '"function":{' +
          '"name":"get_compile_errors",' +
          '"description":"Return the current compiler error log from the last compile_code call.",' +
          '"parameters":{' +
            '"type":"object",' +
            '"properties":{},' +
            '"required":[]' +
          '}' +
        '}' +
      '},' +
      '{' +
        '"type":"function",' +
        '"function":{' +
          '"name":"update_output",' +
          '"description":"Set the final generated code in the output panel. Call this when the code is complete and correct.",' +
          '"parameters":{' +
            '"type":"object",' +
            '"properties":{' +
              '"code":{"type":"string","description":"The final, complete source code to display as output"}' +
            '},' +
            '"required":["code"]' +
          '}' +
        '}' +
      '},' +
      '{' +
        '"type":"function",' +
        '"function":{' +
          '"name":"read_file",' +
          '"description":"Read a file from disk and return its contents as a string.",' +
          '"parameters":{' +
            '"type":"object",' +
            '"properties":{' +
              '"path":{"type":"string","description":"Absolute or relative path to the file to read"}' +
            '},' +
            '"required":["path"]' +
          '}' +
        '}' +
      '},' +
      '{' +
        '"type":"function",' +
        '"function":{' +
          '"name":"write_file",' +
          '"description":"Write text content to a file on disk.",' +
          '"parameters":{' +
            '"type":"object",' +
            '"properties":{' +
              '"path":{"type":"string","description":"Absolute or relative path to write the file"},' +
              '"content":{"type":"string","description":"Text content to write to the file"}' +
            '},' +
            '"required":["path","content"]' +
          '}' +
        '}' +
      '}' +
    ']';
end;

// ---------------------------------------------------------------------------
// TAgentSession
// ---------------------------------------------------------------------------
constructor TAgentSession.Create;
begin
  inherited;
  FMessages := TList<TAgentMessage>.Create;
end;

destructor TAgentSession.Destroy;
begin
  FMessages.Free;
  inherited;
end;

procedure TAgentSession.Clear;
begin
  FMessages.Clear;
end;

procedure TAgentSession.AppendSystem(const AContent: string);
var
  LMsg: TAgentMessage;
begin
  LMsg.Role := 'system';
  LMsg.Content := AContent;
  LMsg.ToolCallId := '';
  SetLength(LMsg.ToolCalls, 0);
  FMessages.Add(LMsg);
end;

procedure TAgentSession.AppendUser(const AContent: string);
var
  LMsg: TAgentMessage;
begin
  LMsg.Role := 'user';
  LMsg.Content := AContent;
  LMsg.ToolCallId := '';
  SetLength(LMsg.ToolCalls, 0);
  FMessages.Add(LMsg);
end;

procedure TAgentSession.AppendAssistant(const AContent: string; const AToolCalls: TArray<TToolCall>);
var
  LMsg: TAgentMessage;
begin
  LMsg.Role := 'assistant';
  LMsg.Content := AContent;
  LMsg.ToolCallId := '';
  LMsg.ToolCalls := AToolCalls;
  FMessages.Add(LMsg);
end;

procedure TAgentSession.AppendToolResult(const AToolCallId, AContent: string);
var
  LMsg: TAgentMessage;
begin
  LMsg.Role := 'tool';
  LMsg.Content := AContent;
  LMsg.ToolCallId := AToolCallId;
  SetLength(LMsg.ToolCalls, 0);
  FMessages.Add(LMsg);
end;

function TAgentSession.Count: Integer;
begin
  Result := FMessages.Count;
end;

function EscapeJSONString(const S: string): string;
var
  I: Integer;
  C: Char;
  SB: TStringBuilder;
begin
  SB := TStringBuilder.Create;
  try
    for I := 1 to Length(S) do
    begin
      C := S[I];
      case C of
        '"':  SB.Append('\"');
        '\':  SB.Append('\\');
        #8:   SB.Append('\b');
        #9:   SB.Append('\t');
        #10:  SB.Append('\n');
        #12:  SB.Append('\f');
        #13:  SB.Append('\r');
      else
        if Ord(C) < 32 then
          SB.AppendFormat('\u%4.4x', [Ord(C)])
        else
          SB.Append(C);
      end;
    end;
    Result := SB.ToString;
  finally
    SB.Free;
  end;
end;

function TAgentSession.BuildMessagesJSON: string;
var
  SB: TStringBuilder;
  I, J: Integer;
  LMsg: TAgentMessage;
  LTC: TToolCall;
begin
  SB := TStringBuilder.Create;
  try
    SB.Append('[');
    for I := 0 to FMessages.Count - 1 do
    begin
      LMsg := FMessages[I];
      if I > 0 then SB.Append(',');
      SB.Append('{');
      SB.AppendFormat('"role":"%s"', [LMsg.Role]);

      if LMsg.Role = 'tool' then
      begin
        // Tool result message
        SB.AppendFormat(',"tool_call_id":"%s"', [EscapeJSONString(LMsg.ToolCallId)]);
        SB.AppendFormat(',"content":"%s"', [EscapeJSONString(LMsg.Content)]);
      end
      else if (LMsg.Role = 'assistant') and (Length(LMsg.ToolCalls) > 0) then
      begin
        // Assistant message with tool calls
        if LMsg.Content <> '' then
          SB.AppendFormat(',"content":"%s"', [EscapeJSONString(LMsg.Content)])
        else
          SB.Append(',"content":null');

        SB.Append(',"tool_calls":[');
        for J := 0 to High(LMsg.ToolCalls) do
        begin
          LTC := LMsg.ToolCalls[J];
          if J > 0 then SB.Append(',');
          SB.Append('{');
          SB.AppendFormat('"id":"%s"', [EscapeJSONString(LTC.Id)]);
          SB.Append(',"type":"function"');
          SB.Append(',"function":{');
          SB.AppendFormat('"name":"%s"', [EscapeJSONString(LTC.Name)]);
          SB.AppendFormat(',"arguments":"%s"', [EscapeJSONString(LTC.InputJSON)]);
          SB.Append('}');
          SB.Append('}');
        end;
        SB.Append(']');
      end
      else
      begin
        SB.AppendFormat(',"content":"%s"', [EscapeJSONString(LMsg.Content)]);
      end;

      SB.Append('}');
    end;
    SB.Append(']');
    Result := SB.ToString;
  finally
    SB.Free;
  end;
end;

// ---------------------------------------------------------------------------
// TAgentLoop
// ---------------------------------------------------------------------------
constructor TAgentLoop.Create;
begin
  inherited;
  FSession := TAgentSession.Create;
  MaxIterations := AGENT_MAX_ITERATIONS;
  FModel := 'gpt-4o';
  FBaseURL := 'https://api.openai.com';
  FCancel := False;
  FRunning := False;
  SystemPrompt := 'You are the best and most experienced 10x programmer in all programming languages. ' +
    'You have access to tools that let you compile Delphi code and read/write files. ' +
    'Use the compile_code tool to verify your code compiles, fix any errors, and call update_output ' +
    'with the final working code when you are done.';
end;

destructor TAgentLoop.Destroy;
begin
  FSession.Free;
  inherited;
end;

procedure TAgentLoop.Cancel;
begin
  FCancel := True;
end;

function TAgentLoop.IsRunning: Boolean;
begin
  Result := FRunning;
end;

function TAgentLoop.BuildToolsJSON: string;
begin
  Result := BuildAgentToolsJSON;
end;

function TAgentLoop.BuildRequestJSON(const AMessagesJSON: string): string;
var
  SB: TStringBuilder;
begin
  SB := TStringBuilder.Create;
  try
    SB.Append('{');
    SB.AppendFormat('"model":"%s"', [FModel]);
    SB.AppendFormat(',"messages":%s', [AMessagesJSON]);
    SB.AppendFormat(',"tools":%s', [BuildToolsJSON]);
    SB.Append(',"tool_choice":"auto"');
    SB.Append('}');
    Result := SB.ToString;
  finally
    SB.Free;
  end;
end;

function TAgentLoop.CallAPI(const ARequestJSON: string): string;
var
  LClient: TRESTClient;
  LRequest: TRESTRequest;
  LResponse: TRESTResponse;
begin
  Result := '';
  LClient := TRESTClient.Create(nil);
  LRequest := TRESTRequest.Create(nil);
  LResponse := TRESTResponse.Create(nil);
  try
    LClient.BaseURL := FBaseURL;
    LRequest.Client := LClient;
    LRequest.Response := LResponse;
    LRequest.Method := TRESTRequestMethod.rmPOST;
    LRequest.Resource := '/v1/chat/completions';

    LRequest.Params.Clear;
    LRequest.AddAuthParameter('Authorization', 'Bearer ' + FAPIKey,
      TRESTRequestParameterKind.pkHTTPHEADER, [TRESTRequestParameterOption.poDoNotEncode]);
    LRequest.AddParameter('Content-Type', 'application/json',
      TRESTRequestParameterKind.pkHTTPHEADER, [TRESTRequestParameterOption.poDoNotEncode]);
    LRequest.AddBody(ARequestJSON, TRESTContentType.ctAPPLICATION_JSON);

    LRequest.Execute;
    Result := LResponse.Content;
  finally
    LClient.Free;
    LRequest.Free;
    LResponse.Free;
  end;
end;

procedure TAgentLoop.ParseAndDispatchResponse(const AResponseJSON: string;
  out AStopReason: string; out ATextContent: string; out AToolCalls: TArray<TToolCall>);
var
  RootObj, ChoiceObj, MessageObj, FuncObj: TJSONObject;
  ChoicesArr, ToolCallsArr: TJSONArray;
  ToolCallObj: TJSONObject;
  LTC: TToolCall;
  I: Integer;
  LArgumentsRaw: string;
begin
  AStopReason := SR_END_TURN;
  ATextContent := '';
  SetLength(AToolCalls, 0);

  RootObj := TJSONObject.ParseJSONValue(AResponseJSON) as TJSONObject;
  if RootObj = nil then
  begin
    AStopReason := 'error';
    ATextContent := 'Failed to parse API response: ' + AResponseJSON;
    Exit;
  end;
  try
    // Check for API-level error
    if RootObj.FindValue('error') <> nil then
    begin
      AStopReason := 'error';
      ATextContent := (RootObj.GetValue('error') as TJSONObject).GetValue<string>('message');
      Exit;
    end;

    ChoicesArr := RootObj.GetValue('choices') as TJSONArray;
    if (ChoicesArr = nil) or (ChoicesArr.Count = 0) then
    begin
      AStopReason := 'error';
      ATextContent := 'No choices in response';
      Exit;
    end;

    ChoiceObj := ChoicesArr.Items[0] as TJSONObject;
    AStopReason := ChoiceObj.GetValue<string>('finish_reason');
    MessageObj := ChoiceObj.GetValue('message') as TJSONObject;

    // Extract text content (may be null when there are tool calls)
    if MessageObj.FindValue('content') <> nil then
    begin
      var LContentVal := MessageObj.FindValue('content');
      if not (LContentVal is TJSONNull) then
        ATextContent := LContentVal.Value;
    end;

    // Extract tool calls if present
    if MessageObj.FindValue('tool_calls') <> nil then
    begin
      ToolCallsArr := MessageObj.GetValue('tool_calls') as TJSONArray;
      if ToolCallsArr <> nil then
      begin
        SetLength(AToolCalls, ToolCallsArr.Count);
        for I := 0 to ToolCallsArr.Count - 1 do
        begin
          ToolCallObj := ToolCallsArr.Items[I] as TJSONObject;
          LTC.Id := ToolCallObj.GetValue<string>('id');
          FuncObj := ToolCallObj.GetValue('function') as TJSONObject;
          LTC.Name := FuncObj.GetValue<string>('name');
          // arguments is a JSON string inside the function object
          LArgumentsRaw := FuncObj.GetValue<string>('arguments');
          LTC.InputJSON := LArgumentsRaw;
          AToolCalls[I] := LTC;
        end;
      end;
    end;
  finally
    RootObj.Free;
  end;
end;

function TAgentLoop.DispatchTool(const AToolCall: TToolCall): string;
var
  ArgsObj: TJSONObject;
  LCode, LPath, LContent: string;
begin
  Result := '';
  ArgsObj := TJSONObject.ParseJSONValue(AToolCall.InputJSON) as TJSONObject;
  try
    if SameText(AToolCall.Name, 'compile_code') then
    begin
      if Assigned(FCompileCode) then
      begin
        LCode := '';
        if ArgsObj <> nil then
          LCode := ArgsObj.GetValue<string>('code');
        Result := FCompileCode(LCode);
      end
      else
        Result := 'compile_code handler not available';
    end

    else if SameText(AToolCall.Name, 'get_compile_errors') then
    begin
      if Assigned(FGetErrorLog) then
        Result := FGetErrorLog
      else
        Result := '';
      if Result = '' then
        Result := '(no errors)';
    end

    else if SameText(AToolCall.Name, 'update_output') then
    begin
      if Assigned(FSetOutput) then
      begin
        LCode := '';
        if ArgsObj <> nil then
          LCode := ArgsObj.GetValue<string>('code');
        TThread.Synchronize(nil, procedure begin
          FSetOutput(LCode);
        end);
        Result := 'Output updated.';
      end
      else
        Result := 'update_output handler not available';
    end

    else if SameText(AToolCall.Name, 'read_file') then
    begin
      LPath := '';
      if ArgsObj <> nil then
        LPath := ArgsObj.GetValue<string>('path');
      if TFile.Exists(LPath) then
        Result := TFile.ReadAllText(LPath, TEncoding.UTF8)
      else
        Result := 'Error: file not found: ' + LPath;
    end

    else if SameText(AToolCall.Name, 'write_file') then
    begin
      LPath := '';
      LContent := '';
      if ArgsObj <> nil then
      begin
        LPath := ArgsObj.GetValue<string>('path');
        LContent := ArgsObj.GetValue<string>('content');
      end;
      try
        TFile.WriteAllText(LPath, LContent, TEncoding.UTF8);
        Result := 'File written: ' + LPath;
      except
        on E: Exception do
          Result := 'Error writing file: ' + E.Message;
      end;
    end

    else
      Result := 'Unknown tool: ' + AToolCall.Name;
  finally
    ArgsObj.Free;
  end;
end;

procedure TAgentLoop.FireOnMessage(const ARole, AContent: string);
begin
  if Assigned(FOnMessage) then
    TThread.Synchronize(nil, procedure begin
      FOnMessage(ARole, AContent);
    end);
end;

procedure TAgentLoop.FireOnToolCall(const AName, AInput, AOutput: string);
begin
  if Assigned(FOnToolCall) then
    TThread.Synchronize(nil, procedure begin
      FOnToolCall(AName, AInput, AOutput);
    end);
end;

procedure TAgentLoop.FireOnComplete(const AOutput: string);
begin
  if Assigned(FOnComplete) then
    TThread.Synchronize(nil, procedure begin
      FOnComplete(AOutput);
    end);
end;

procedure TAgentLoop.FireOnError(const AError: string);
begin
  if Assigned(FOnError) then
    TThread.Synchronize(nil, procedure begin
      FOnError(AError);
    end);
end;

procedure TAgentLoop.Run(const AInitialPrompt: string);
var
  LSystemPrompt: string;
begin
  if FRunning then Exit;
  FCancel := False;
  FRunning := True;

  FSession.Clear;

  // Build system message: base system prompt + memory context
  LSystemPrompt := SystemPrompt;
  if Assigned(FMemory) then
  begin
    var LMemCtx := FMemory.ToSystemPromptContext;
    if LMemCtx <> '' then
      LSystemPrompt := LSystemPrompt + #13#10#13#10 + LMemCtx;
  end;
  FSession.AppendSystem(LSystemPrompt);
  FSession.AppendUser(AInitialPrompt);

  TTask.Run(procedure
  var
    LIteration: Integer;
    LStopReason, LTextContent, LRequestJSON, LResponseJSON, LToolResult: string;
    LToolCalls: TArray<TToolCall>;
    LTC: TToolCall;
  begin
    try
      for LIteration := 1 to MaxIterations do
      begin
        if FCancel then
        begin
          FireOnError('Agent loop cancelled by user.');
          Break;
        end;

        FireOnMessage('status', Format('[Iteration %d/%d] Calling API...', [LIteration, MaxIterations]));

        LRequestJSON := BuildRequestJSON(FSession.BuildMessagesJSON);
        LResponseJSON := CallAPI(LRequestJSON);

        ParseAndDispatchResponse(LResponseJSON, LStopReason, LTextContent, LToolCalls);

        if LStopReason = 'error' then
        begin
          FireOnError('[API Error] ' + LTextContent);
          Break;
        end;

        if LTextContent <> '' then
          FireOnMessage('assistant', LTextContent);

        // End of agent turn — done
        if (LStopReason = SR_END_TURN) or (LStopReason = 'stop') then
        begin
          FSession.AppendAssistant(LTextContent, []);
          FireOnComplete(LTextContent);
          Break;
        end;

        // Tool calls — dispatch each tool and feed results back
        if (LStopReason = SR_TOOL_CALLS) or (Length(LToolCalls) > 0) then
        begin
          FSession.AppendAssistant(LTextContent, LToolCalls);

          for LTC in LToolCalls do
          begin
            if FCancel then Break;

            FireOnMessage('status', Format('[Tool] %s', [LTC.Name]));
            LToolResult := DispatchTool(LTC);
            FireOnToolCall(LTC.Name, LTC.InputJSON, LToolResult);
            FSession.AppendToolResult(LTC.Id, LToolResult);
          end;

          // Continue the loop with tool results appended
          Continue;
        end;

        // Context length exceeded
        if LStopReason = SR_LENGTH then
        begin
          FireOnError('Agent stopped: maximum context length reached. Try a simpler prompt or reduce MaxIterations.');
          Break;
        end;

        // Unexpected stop reason — treat as done
        FSession.AppendAssistant(LTextContent, []);
        FireOnComplete(LTextContent);
        Break;
      end;

      if LIteration > MaxIterations then
        FireOnError(Format('Agent stopped: reached maximum iterations (%d). Last output is in the output panel.', [MaxIterations]));

    except
      on E: Exception do
        FireOnError('[Exception] ' + E.Message);
    end;

    FRunning := False;
  end);
end;

end.
