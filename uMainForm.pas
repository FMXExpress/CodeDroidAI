unit uMainForm;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.StorageBin, FMX.Memo.Types, FMX.Controls.Presentation,
  FMX.ScrollBox, FMX.Memo, FMX.ListBox, FMX.StdCtrls, FMX.Layouts, Data.DB,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, System.Rtti,
  System.Bindings.Outputs, Fmx.Bind.Editors, Data.Bind.EngExt,
  Fmx.Bind.DBEngExt, Data.Bind.Components, Data.Bind.DBScope, REST.Types,
  FMX.Edit, FMX.Effects, REST.Response.Adapter, REST.Client,
  Data.Bind.ObjectScope, FMX.ListView.Types, FMX.ListView.Appearances,
  FMX.ListView.Adapters.Base, FMX.EditBox, FMX.ComboTrackBar, FMX.ComboEdit,
  FMX.ListView, FMX.TabControl, System.Threading
  {$IFDEF MSWINDOWS}
  , WinApi.Windows, FMX.MultiView, FMX.Grid.Style, Fmx.Bind.Grid,
  Data.Bind.Controls, Fmx.Bind.Navigator, Data.Bind.Grid, FMX.Grid, FMX.Objects,
  uItemFrame, FMX.BufferedLayout
  {$ENDIF}
  ;

type
  TMainForm = class(TForm)
    LanguageMT: TFDMemTable;
    Layout1: TLayout;
    Layout2: TLayout;
    InputCB: TComboBox;
    InputMemo: TMemo;
    PromptMemo: TMemo;
    MaterialOxfordBlueSB: TStyleBook;
    OutputMemo: TMemo;
    BindSourceDB1: TBindSourceDB;
    BindingsList1: TBindingsList;
    LinkListControlToField1: TLinkListControlToField;
    ToolBar1: TToolBar;
    ShadowEffect4: TShadowEffect;
    Label1: TLabel;
    APIKeyButton: TButton;
    OAAPIKeyEdit: TEdit;
    StatusBar1: TStatusBar;
    GenerateButton: TButton;
    RESTClient1: TRESTClient;
    RESTRequest1: TRESTRequest;
    RESTResponse1: TRESTResponse;
    RESTResponseDataSetAdapter1: TRESTResponseDataSetAdapter;
    FDMemTable1: TFDMemTable;
    VerifyCodeButton: TButton;
    PlatformFDMemTable: TFDMemTable;
    ProjectsFDMemTable: TFDMemTable;
    RSVarsFDMemTable: TFDMemTable;
    TabControl1: TTabControl;
    TabItem1: TTabItem;
    ListView1: TListView;
    Layout3: TLayout;
    PathEdit: TEdit;
    SearchEditButton1: TSearchEditButton;
    ScanButton: TButton;
    BuildButton: TButton;
    TabItem2: TTabItem;
    VertScrollBox1: TVertScrollBox;
    Layout4: TLayout;
    ExecParamsEdit: TEdit;
    Label7: TLabel;
    Layout5: TLayout;
    PlatformComboEdit: TComboEdit;
    Label4: TLabel;
    Layout6: TLayout;
    RSVArsComboEdit: TComboEdit;
    Label5: TLabel;
    Layout7: TLayout;
    CPUTB: TComboTrackBar;
    Label6: TLabel;
    Layout9: TLayout;
    Layout10: TLayout;
    CleanSwitch: TSwitch;
    Label2: TLabel;
    TabItem3: TTabItem;
    ErrorLogMemo: TMemo;
    BindSourceDB2: TBindSourceDB;
    LinkFillControlToField: TLinkFillControlToField;
    BindSourceDB3: TBindSourceDB;
    LinkFillControlToField1: TLinkFillControlToField;
    BindSourceDB4: TBindSourceDB;
    LinkListControlToField2: TLinkListControlToField;
    StatusLabel: TLabel;
    OutputCB: TComboBox;
    LanguageMT2: TFDMemTable;
    BindSourceDB5: TBindSourceDB;
    LinkListControlToField3: TLinkListControlToField;
    TabControl: TTabControl;
    DroidTabItem: TTabItem;
    TabItem5: TTabItem;
    HistoryGrid: TStringGrid;
    HistoryMT: TFDMemTable;
    BindSourceDB6: TBindSourceDB;
    LinkGridToDataSourceBindSourceDB6: TLinkGridToDataSource;
    BindNavigator1: TBindNavigator;
    Layout8: TLayout;
    AutoVerifySwitch: TSwitch;
    Label3: TLabel;
    BindSourceDB7: TBindSourceDB;
    ProgressBar: TProgressBar;
    Timer: TTimer;
    Splitter1: TSplitter;
    Splitter2: TSplitter;
    LinkFillControlToField2: TLinkFillControlToField;
    TabItem6: TTabItem;
    FlowLayout: TFlowLayout;
    TemplatesMT: TFDMemTable;
    TabItem4: TTabItem;
    Label8: TLabel;
    IdEdit: TEdit;
    BindNavigator2: TBindNavigator;
    Label9: TLabel;
    EmojiEdit: TEdit;
    Label10: TLabel;
    TitleEdit: TEdit;
    Label11: TLabel;
    DescriptionEdit: TEdit;
    Label12: TLabel;
    PromptTemplateMemo: TMemo;
    Label13: TLabel;
    PromptHintMemo: TMemo;
    BindSourceDB8: TBindSourceDB;
    LinkControlToField1: TLinkControlToField;
    LinkControlToField2: TLinkControlToField;
    LinkControlToField3: TLinkControlToField;
    LinkControlToField4: TLinkControlToField;
    LinkControlToField5: TLinkControlToField;
    LinkControlToField6: TLinkControlToField;
    Button1: TButton;
    CardsVSB: TVertScrollBox;
    HintLabel: TLabel;
    APIKeyEdit: TEdit;
    FDMemTable2: TFDMemTable;
    FDMemTable3: TFDMemTable;
    RESTClient2: TRESTClient;
    RESTClient3: TRESTClient;
    RESTRequest2: TRESTRequest;
    RESTRequest3: TRESTRequest;
    RESTResponse2: TRESTResponse;
    RESTResponse3: TRESTResponse;
    RESTResponseDataSetAdapter2: TRESTResponseDataSetAdapter;
    RESTResponseDataSetAdapter3: TRESTResponseDataSetAdapter;
    ModelsMT: TFDMemTable;
    VersionEdit: TComboBox;
    BindSourceDB9: TBindSourceDB;
    LinkListControlToField4: TLinkListControlToField;
    Layout11: TLayout;
    CopyInputButton: TButton;
    ClearInputButton: TButton;
    Layout12: TLayout;
    CopyOutputButton: TButton;
    ClearOutputButton: TButton;
    Layout13: TLayout;
    CopyErrorButton: TButton;
    ClearErrorButton: TButton;
    Layout14: TLayout;
    Layout15: TLayout;
    procedure APIKeyButtonClick(Sender: TObject);
    procedure GenerateButtonClick(Sender: TObject);
    procedure BuildButtonClick(Sender: TObject);
    procedure ScanButtonClick(Sender: TObject);
    procedure VerifyCodeButtonClick(Sender: TObject);
    procedure SearchEditButton1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure OutputMemoChange(Sender: TObject);
    procedure OutputCBChange(Sender: TObject);
    procedure TimerTimer(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure InputMemoChangeTracking(Sender: TObject);
    procedure HistoryGridSelChanged(Sender: TObject);
    procedure ClearInputButtonClick(Sender: TObject);
    procedure ClearErrorButtonClick(Sender: TObject);
    procedure ClearOutputButtonClick(Sender: TObject);
    procedure CopyInputButtonClick(Sender: TObject);
    procedure CopyOutputButtonClick(Sender: TObject);
    procedure CopyErrorButtonClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
    FCard: Integer;
    FCancel: Boolean;
    function ProcessTask(const AId: Integer): ITask;
    procedure BuildProject(const AId: Integer; const APath: String);
    procedure BuildEnd;
    function CreateOpenAIChatJSON(const AModel, APrompt: string; AMaxTokens: Integer): string;
  public
    { Public declarations }
    function CreateReplicateJSON(const AVersion, APrompt: string): string;
    procedure LoadTemplate(TemplateId: Integer);
    procedure CopyToClipboard(const LText: String);
    {$IFDEF MSWINDOWS}
    function ExeAndWait(ExeNameAndParams: string; ncmdShow: Integer = SW_SHOWNORMAL): Integer;
    {$ENDIF}
    procedure Restore;
  end;
  const
    STS_READY = 'Ready';
    STS_BUILDING = 'Building...';
    STS_SUCCESS = 'Complete';
    STS_FAIL = 'Failed';
    HISTORY_FILE = 'cdai_history.fds';
    TEMPLATES_FILE = 'cdai_templates.fds';

var
  MainForm: TMainForm;

implementation

{$R *.fmx}

uses
  System.JSON, System.IOUtils, StrUtils, FMX.Platform;


procedure TMainForm.CopyErrorButtonClick(Sender: TObject);
begin
  CopyToClipboard(ErrorLogMemo.Lines.Text);
end;

procedure TMainForm.CopyInputButtonClick(Sender: TObject);
begin
  CopyToClipboard(InputMemo.Lines.Text);
end;

procedure TMainForm.CopyOutputButtonClick(Sender: TObject);
begin
  CopyToClipboard(OutputMemo.Lines.Text);
end;

procedure TMainForm.CopyToClipboard(const LText: String);
var
  clp: IFMXClipboardService;
begin
  if TPlatformServices.Current.SupportsPlatformService(IFMXClipboardService) then
  begin
    clp := IFMXClipboardService(TPlatformServices.Current.GetPlatformService(IFMXClipboardService));
    clp.SetClipboard(LText);
  end;
end;

procedure TMainForm.Restore;
var
  LCard: TFrameItem;
  LStream: TStream;
  LScene: TBufferedLayout;
begin

  TemplatesMT.First;
  while not TemplatesMT.Eof do
    begin

      LScene := TBufferedLayout.Create(Self);
      LCard := TFrameItem.Create(Self);
      LCard.Name := 'Card'+FCard.ToString;
      LCard.Align := TAlignLayout.Client;
//      LCard.Position.Y := 999999999;
      LCard.Tag := TemplatesMT.FieldByName('id').AsInteger;
      LCard.EmojiLabel.Text := TemplatesMT.FieldByName('emoji').AsWideString;
      LCard.TitleLabel.Text := TemplatesMT.FieldByName('title').AsWideString;
      LCard.DescriptionLabel.Text := TemplatesMT.FieldByName('description').AsWideString;
      LScene.Height := LCard.Height;
      LScene.Width := LCard.Width;
      LCard.Parent := LScene;
      //LScene.Align := TAlignLayout.Top;
      LScene.Parent := FlowLayout;

      Inc(FCard);

      TemplatesMT.Next;
    end;
end;

procedure TMainForm.LoadTemplate(TemplateId: Integer);
begin
  MainForm.TabControl.ActiveTab := MainForm.DroidTabItem;
  TemplatesMT.Locate('id', VarArrayOf([TemplateId]));
  PromptMemo.Lines.Text := TemplatesMT.FieldByName('prompt').AsWideString;
  HintLabel.Text := TemplatesMT.FieldByName('prompthint').AsWideString;
end;

procedure TMainForm.BuildButtonClick(Sender: TObject);
var
  LTasks: array of ITask;
  LThreadCount: Integer;
  LIndex: Integer;
begin
  case BuildButton.Tag of
   0: begin
      FCancel := False;

      ErrorLogMemo.Lines.Clear;

      while not ProjectsFDMemTable.EOF do
      begin
        ProjectsFDMemTable.Edit;
        ProjectsFDMemTable.FieldByName('Status').AsString := STS_READY;
        ProjectsFDMemTable.Post;
        ProjectsFDMemTable.Next;
      end;

      BuildButton.Tag := 1;
      BuildButton.Text := 'Cancel';

      StatusLabel.Text := '';

      LThreadCount := Trunc(CPUTB.Value);

      for LIndex := 1 to LThreadCount do
        begin
          LTasks := LTasks + [ProcessTask(LIndex)];
          LTasks[High(LTasks)].Start;
        end;

        TTask.Run(procedure begin
          TTask.WaitForAll(LTasks);
          TThread.Synchronize(nil,procedure begin
           BuildEnd;
          end);
        end);
   end;
   1: begin
     FCancel := True;
   end;
  end;

end;

procedure TMainForm.BuildProject(const AId: Integer; const APath: String);
var
  LCurrentFile: String;
  LReturnCode: integer;
  SL: TStringList;
  OutBat: TStringList;
  LAdditionalPath: String;
  LPlatform: String;
  LName: String;
begin

  SL := TStringList.Create;
  SL.LoadFromFile(RSVArsComboEdit.Text);

  LPlatform := 'Win32';
  LName := ExtractFileName(APath).Replace(ExtractFileExt(APath),'');

  OutBat := TStringList.Create;
  try
        LAdditionalPath := '';
        OutBat.Text := Trim(SL.Text);

        if APath.ToUpper.IndexOf('FLATBOX2D')>0 then
          LAdditionalPath := ';DCC_UnitSearchPath=$(DCC_UnitSearchPath)\FlatBox2d;$(DCC_UnitSearchPath)';

        OutBat.Append(Format(ExecParamsEdit.Text, [APAth, AId.ToString, PlatformComboEdit.Text, LAdditionalPath, CPUTB.Text]) + ' > ' + 'list'+AId.ToString + '.log');
        if CleanSwitch.IsChecked then OutBat.Append(Format('msbuild "%s" /t:Clean /p:Platform=%s ', [APath, PlatformComboEdit.Text]));
        OutBat.SaveToFile(ExtractFilePath(ParamStr(0)) + 'list'+AId.ToString + '.bat');
        LCurrentFile := 'cmd /c call '+ExtractFilePath(ParamStr(0))+'list'+AId.ToString+'.bat';
        {$IFDEF MSWINDOWS}
        LReturnCode := ExeAndWait(LCurrentFile, SW_HIDE);
        {$ENDIF}
        OutBat.LoadFromFile(ExtractFilePath(ParamStr(0)) + 'list'+AId.ToString + '.log');
        if OutBat.Text.IndexOf('Build succeeded.')>0 then
          begin
            TThread.Synchronize(nil,procedure begin
              if ProjectsFDMemTable.Locate('FullPath',VarArrayOf([APath]),[]) then
              begin
                ProjectsFDMemTable.Edit;
                ProjectsFDMemTable.FieldByName('Status').AsString := STS_SUCCESS;
                ProjectsFDMemTable.Post;
              end;
            end);
          end
        else
          begin
            TThread.Synchronize(nil,procedure begin
              if ProjectsFDMemTable.Locate('FullPath',VarArrayOf([APath]),[]) then
              begin
                ProjectsFDMemTable.Edit;
                ProjectsFDMemTable.FieldByName('Status').AsString := STS_FAIL;
                ProjectsFDMemTable.Post;
              end;
              ErrorLogMemo.Lines.Append(OutBat.Text);
              var LDeleteLine := False;
              for var I := ErrorLogMemo.Lines.Count-1 downto 0 do
              begin


                if ErrorLogMemo.Lines[I].Contains('_PasCoreCompile target') then
                  LDeleteLine := True
                else
                begin
                  if LDeleteLine=False then
                  begin
                    if ErrorLogMemo.Lines[I].Contains('error') then
                    begin
                      ErrorLogMemo.Lines[I] := Trim(LeftStr(ErrorLogMemo.Lines[I], Pos('[', ErrorLogMemo.Lines[I]) - 1));
                    end
                    else
                      ErrorLogMemo.Lines.Delete(I);
                  end;
                end;
                if LDeleteLine then
                  ErrorLogMemo.Lines.Delete(I);
              end;
            end);
          end;
        TThread.Synchronize(nil,procedure begin
          Application.ProcessMessages;
        end);


    finally
      OutBat.Free;
      SL.Free;
    end;

end;

procedure TMainForm.Button1Click(Sender: TObject);
begin
  TemplatesMT.SaveToFile(ExtractFilePath(ParamStr(0)) + TEMPLATES_FILE)
end;



procedure TMainForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  HistoryMT.SaveToFile(TPath.Combine(TPath.GetDocumentsPath,HISTORY_FILE));
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  PathEdit.Text := ExtractFilePath(ParamStr(0));
  ScanButtonClick(Sender);

  Restore;

  if TFile.Exists(ExtractFilePath(ParamStr(0)) + TEMPLATES_FILE) then
    TemplatesMT.LoadFromFile(ExtractFilePath(ParamStr(0)) + TEMPLATES_FILE);

  if TFile.Exists(TPath.Combine(TPath.GetDocumentsPath,HISTORY_FILE)) then
    HistoryMT.LoadFromFile(TPath.Combine(TPath.GetDocumentsPath,HISTORY_FILE));
end;

procedure TMainForm.HistoryGridSelChanged(Sender: TObject);
begin
  if HistoryMT.RecordCount>0 then
  begin
    MainForm.TabControl.ActiveTab := MainForm.DroidTabItem;
    PromptMemo.Lines.Text := HistoryMT.FieldByName('Prompt').AsWideString;
    LanguageMT.Locate('Language', HistoryMT.FieldByName('InputLang').AsWideString);
    InputMemo.Lines.Text := HistoryMT.FieldByName('InputText').AsWideString;
    LanguageMT2.Locate('Language', HistoryMT.FieldByName('OutputLang').AsWideString);
    OutputMemo.Lines.Text := HistoryMT.FieldByName('OutputText').AsWideString;
    ErrorLogMemo.Lines.Text := HistoryMT.FieldByName('CommentText').AsWideString;
    HintLabel.Text := TemplatesMT.FieldByName('prompthint').AsWideString;
  end;
end;

procedure TMainForm.InputMemoChangeTracking(Sender: TObject);
begin
  if InputMemo.Lines.Text='' then
    HintLabel.Visible := True
  else
    if HintLabel.Visible=True then HintLabel.Visible := False;
end;

procedure TMainForm.OutputCBChange(Sender: TObject);
begin
  OutputMemoChange(Sender);
end;

procedure TMainForm.OutputMemoChange(Sender: TObject);
begin
  if OutputMemo.Lines.Text<>'' then
  begin
    if ((OutputCB.Selected.Text='Delphi Object Pascal') OR (OutputCB.Selected.Text='C++')) then
      VerifyCodeButton.Enabled := True
    else
      VerifyCodeButton.Enabled := False;
    GenerateButton.Text := 'Refine Output Code';
  end
  else
  begin
    VerifyCodeButton.Enabled := False;
    GenerateButton.Text := 'Generate';
  end;
end;

function TMainForm.ProcessTask(const AId: Integer): ITask;
begin
  Result := TTask.Create(procedure var LIndex: Integer; LPath: String; begin
    for LIndex := 0 to ProjectsFDMemTable.RecordCount-1 do
    begin
      LPath := '';

      TThread.Synchronize(nil,procedure begin
        if ProjectsFDMemTable.Locate('Status',VarArrayOf([STS_READY]),[])=True then
          begin
            LPath := ProjectsFDMemTable.FieldByName('FullPath').AsString;
            ProjectsFDMemTable.Edit;
            ProjectsFDMemTable.FieldByName('Status').AsString := STS_BUILDING;
            ProjectsFDMemTable.Post;
          end;
      end);

      if LPath='' then Exit;

      BuildProject(AId, LPath);

      if FCancel then
        Break;
    end;
  end);
end;

procedure TMainForm.BuildEnd;
begin
  if FCancel=False then
    StatusLabel.Text := 'Complete!'
  else
    StatusLabel.Text := 'Canceled';

  if ErrorLogMemo.Lines.Count>0 then
    StatusLabel.Text := StatusLabel.Text + ' Errors detected!'
  else
    StatusLabel.Text := StatusLabel.Text + ' Code compiles!';

  BuildButton.Tag := 0;
  BuildButton.Text := BuildButton.Hint;

  FCancel := False;
end;

procedure TMainForm.VerifyCodeButtonClick(Sender: TObject);
begin
  OutPutMemo.Lines.SaveToFile(ExtractFilePath(ParamStr(0)) + 'ConsoleProgram.dpr');
  BuildButtonClick(Sender);
end;

procedure TMainForm.ScanButtonClick(Sender: TObject);
var
  LList: TStringDynArray;
  LSearchOption: TSearchOption;
  LItem: String;
begin
  LSearchOption := TSearchOption.soAllDirectories;
  LList := TDirectory.GetFiles(PathEdit.Text, '*.dproj', LSearchOption);
  LList := LList + TDirectory.GetFiles(PathEdit.Text, '*.cbproj', LSearchOption);
  ProjectsFDMemTable.EmptyDataSet;
  ProjectsFDMemTable.BeginBatch;
  for LItem in LList do
    begin
      ProjectsFDMemTable.Append;
      ProjectsFDMemTable.Edit;
      ProjectsFDMemTable.FieldByName('Filename').AsString := ExtractFileName(LItem);
      ProjectsFDMemTable.FieldByName('FullPath').AsString := LItem;
      ProjectsFDMemTable.FieldByName('Status').AsString := STS_READY;
      ProjectsFDMemTable.Post;
    end;
  ProjectsFDMemTable.EndBatch;
end;


procedure TMainForm.SearchEditButton1Click(Sender: TObject);
var
  LDirectory: String;
begin
  if SelectDirectory('Open Projects',ExtractFilePath(ParamStr(0)),LDirectory) then
  begin
    PathEdit.Text := LDirectory;
  end;
end;

procedure TMainForm.ClearErrorButtonClick(Sender: TObject);
begin
  ErrorLogMemo.Lines.Clear;
end;

procedure TMainForm.ClearInputButtonClick(Sender: TObject);
begin
  InputMemo.Lines.Clear;
end;

procedure TMainForm.ClearOutputButtonClick(Sender: TObject);
begin
  OutputMemo.Lines.Clear;
end;

function TMainForm.CreateOpenAIChatJSON(const AModel, APrompt: string; AMaxTokens: Integer): string;
var
  RootObj, SystemMessageObj, UserMessageObj: TJSONObject;
  MessagesArray: TJSONArray;
begin
  RootObj := TJSONObject.Create;
  try
    RootObj.AddPair('model', AModel);

    MessagesArray := TJSONArray.Create;
    try
      SystemMessageObj := TJSONObject.Create;
      SystemMessageObj.AddPair('role', 'system');
      SystemMessageObj.AddPair('content', 'You are the best and most experienced 10x programmer in all programming languages.');
      MessagesArray.AddElement(SystemMessageObj);

      if OutPutMemo.Lines.Text='' then
      begin
        UserMessageObj := TJSONObject.Create;
        UserMessageObj.AddPair('role', 'user');
        UserMessageObj.AddPair('content', APrompt);
        MessagesArray.AddElement(UserMessageObj);
      end;

      if OutPutMemo.Lines.Text<>'' then
      begin
        UserMessageObj := TJSONObject.Create;
        UserMessageObj.AddPair('role', 'assistant');
        UserMessageObj.AddPair('content', OutPutMemo.Lines.Text);
        MessagesArray.AddElement(UserMessageObj);
      end;

      if ErrorLogMemo.Lines.Text<>'' then
      begin
        UserMessageObj := TJSONObject.Create;
        UserMessageObj.AddPair('role', 'user');
        UserMessageObj.AddPair('content', 'Fix your mistakes. Only return code. Do not include \`\`\`. Tried to build. Got these errors: ' + ErrorLogMemo.Lines.Text);
        MessagesArray.AddElement(UserMessageObj);
      end;

      RootObj.AddPair('messages', MessagesArray);
    except
      MessagesArray.Free;
      raise;
    end;

  //  RootObj.AddPair('max_tokens', TJSONNumber.Create(AMaxTokens));

    Result := RootObj.Format(2); // The number 2 is to specify the formatting indent size
  finally
    RootObj.Free;
  end;
end;

procedure TMainForm.APIKeyButtonClick(Sender: TObject);
begin
  OAAPIKeyEdit.Visible := not OAAPIKeyEdit.Visible;
  APIKeyEdit.Visible := not APIKeyEdit.Visible;
end;

function GetMessageContent(const JSONArray: string): string;
var
  JSONData: TJSONArray;
  MessageObj: TJSONObject;
begin
  Result := '';
  JSONData := TJSONObject.ParseJSONValue(JSONArray) as TJSONArray;
  try
    MessageObj := (JSONData.Items[0] as TJSONObject).GetValue<TJSONObject>('message');
    Result := MessageObj.GetValue<string>('content');
  finally
    JSONData.Free;
  end;
end;

procedure TMainForm.TimerTimer(Sender: TObject);
begin
  if ProgressBar.Visible = False then
  begin
    Timer.Enabled := False;
  end
  else
  begin
    if ProgressBar.Value=ProgressBar.Max then
      ProgressBar.Value := ProgressBar.Min
    else
      ProgressBar.Value := ProgressBar.Value+5;
  end;
end;

function ConcatJSONStrings(const JSONArray: string): string;
var
  JSONData: TJSONArray;
  I: Integer;
begin
  if JSONArray[1]='[' then
  begin

  Result := '';
  JSONData := TJSONObject.ParseJSONValue(JSONArray) as TJSONArray;
  try
    for I := 0 to JSONData.Count - 1 do
      Result := Result + JSONData.Items[I].Value;
  finally
    JSONData.Free;
  end;
  end
  else
  Result := JSONArray;
end;


function TMainForm.CreateReplicateJSON(const AVersion, APrompt: string): string;
var
  RootObj, InputObj: TJSONObject;
begin
  RootObj := TJSONObject.Create;
  try
    RootObj.AddPair('version', AVersion);

    InputObj := TJSONObject.Create;
    try
     // var LPrompt := 'You are the best and most experienced 10x programmer in all programming languages. ';


     // LPrompt := LPrompt + APrompt;

      InputObj.AddPair('prompt', APrompt);
     // InputObj.AddPair('max_tokens', TJSONNumber.Create(AMaxTokens));

      RootObj.AddPair('input', InputObj);
    except
      InputObj.Free;
      raise;
    end;

    Result := RootObj.ToString;
  finally
    RootObj.Free;
  end;
end;

procedure TMainForm.GenerateButtonClick(Sender: TObject);
begin
  if ModelsMT.FieldByName('provider').AsWideString='openai' then
    if OAAPIKeyEdit.Text='' then
    begin
      ShowMessage('Enter an OpenAI API key.');
      Exit;
    end;

  if ModelsMT.FieldByName('provider').AsWideString='replicate' then
    if APIKeyEdit.Text='' then
    begin
      ShowMessage('Enter a Replicate.com API key.');
      Exit;
    end;


  GenerateButton.Enabled := False;
  ProgressBar.Visible := True;
  Timer.Enabled := True;

  TTask.Run(procedure begin
    if ModelsMT.FieldByName('provider').AsWideString='openai' then
    begin
      RESTRequest1.Params[0].Value := 'Bearer ' + OAAPIKeyEdit.Text;
      RESTRequest1.Params[1].Value := CreateOpenAIChatJSON(ModelsMT.FieldByName('model').AsWideString, PromptMemo.Lines.Text.Replace('%inputlang%',InputCB.Selected.Text)
      .Replace('%outputlang%',OutputCB.Selected.Text)
      .Replace('%prompt%',InputMemo.Lines.Text), 2000);
      RESTRequest1.Execute;

      if FDMemTable1.FindField('choices')<>nil then
      begin
        TThread.Synchronize(nil,procedure begin
          OutputMemo.Lines.Text :=  GetMessageContent(FDMemTable1.FieldByName('choices').AsWideString);
          StatusLabel.Text := FDMemTable1.FieldByName('usage').AsWideString;

          if AutoVerifySwitch.IsChecked=True then
          begin
            VerifyCodeButtonClick(Sender);
          end;

          HistoryMT.AppendRecord([Now, PromptMemo.Lines.Text, InputCB.Selected.Text, InputMemo.Lines.Text, OutputCB.Selected.Text, OutputMemo.Lines.Text, ErrorLogMemo.Lines.Text, HintLabel.Text]);
          HistoryMT.SaveToFile(TPath.Combine(TPath.GetDocumentsPath,HISTORY_FILE));
        end);
      end;

        TThread.Synchronize(nil,procedure begin
          GenerateButton.Enabled := True;
          ProgressBar.Visible := False;
        end);
    end
    else if ModelsMT.FieldByName('provider').AsWideString='replicate' then
    begin
      RESTRequest2.Params[0].Value := 'Token ' + APIKeyEdit.Text;
      RESTRequest2.Params[1].Value := CreateReplicateJSON(ModelsMT.FieldByName('model').AsWideString, PromptMemo.Lines.Text.Replace('%inputlang%',InputCB.Selected.Text)
      .Replace('%outputlang%',OutputCB.Selected.Text)
      .Replace('%prompt%',InputMemo.Lines.Text));
      RESTRequest2.Execute;

      if FDMemTable2.FindField('id')<>nil then
      begin
         var LStatus := 'started';
         while ((LStatus<>'succeeded') AND (LStatus<>'failed')) do
         begin
           RESTRequest3.Resource := FDMemTable2.FieldByName('id').AsWideString;
           RESTRequest3.Params[0].Value := 'Token ' + APIKeyEdit.Text;
           RESTRequest3.Execute;
           LStatus := FDMemTable3.FieldByName('status').AsWideString;

           if LStatus='succeeded' then
           begin
             var LOutput := ConcatJSONStrings(FDMemTable3.FieldByName('output').AsWideString);
             if LOutput<>'' then
             begin
                TThread.Synchronize(nil,procedure begin
                  OutputMemo.Lines.Text := LOutput;

                  if AutoVerifySwitch.IsChecked=True then
                  begin
                    VerifyCodeButtonClick(Sender);
                  end;

                  HistoryMT.AppendRecord([Now, PromptMemo.Lines.Text, InputCB.Selected.Text, InputMemo.Lines.Text, OutputCB.Selected.Text, OutputMemo.Lines.Text, ErrorLogMemo.Lines.Text, HintLabel.Text]);
                  HistoryMT.SaveToFile(TPath.Combine(TPath.GetDocumentsPath,HISTORY_FILE));
                end);

             end;

              TThread.Synchronize(nil,procedure begin
                StatusLabel.Text := LStatus;
                GenerateButton.Enabled := True;
                ProgressBar.Visible := False;
              end);

           end
           else
           begin
              TThread.Synchronize(nil,procedure begin
                 StatusLabel.Text := LStatus;
              end);
           end;

           Sleep(3000);

         end;
      end;

    end;

    TThread.Synchronize(nil,procedure begin
      GenerateButton.Enabled := True;
      ProgressBar.Visible := False;
    end);

  end);
end;


{$IFDEF MSWINDOWS}
function TMainForm.ExeAndWait(ExeNameAndParams: string; ncmdShow: Integer = SW_SHOWNORMAL): Integer;
var
    StartupInfo: TStartupInfo;
    ProcessInformation: TProcessInformation;
    Res: Bool;
    lpExitCode: DWORD;
begin
    with StartupInfo do //you can play with this structure
    begin
        cb := SizeOf(TStartupInfo);
        lpReserved := nil;
        lpDesktop := nil;
        lpTitle := nil;
        dwFlags := STARTF_USESHOWWINDOW;
        wShowWindow := ncmdShow;
        cbReserved2 := 0;
        lpReserved2 := nil;
    end;
    Res := CreateProcess(nil, PChar(ExeNameAndParams), nil, nil, True,
        CREATE_DEFAULT_ERROR_MODE
        or NORMAL_PRIORITY_CLASS, nil, nil, StartupInfo, ProcessInformation);
    while True do
    begin
        GetExitCodeProcess(ProcessInformation.hProcess, lpExitCode);
        if lpExitCode <> STILL_ACTIVE then
            Break;
        Application.ProcessMessages;
    end;
    Result := Integer(lpExitCode);
end;
{$ENDIF}


end.
