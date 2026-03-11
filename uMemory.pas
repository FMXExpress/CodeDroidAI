unit uMemory;

interface

uses
  System.SysUtils, System.Classes, System.Generics.Collections,
  System.JSON, System.IOUtils;

const
  MEMORY_FILE = 'cdai_memory.json';

type
  TMemoryFact = record
    Key: string;
    Value: string;
    Category: string;  // 'user', 'project', 'style', 'technical'
    UpdatedAt: TDateTime;
  end;

  TMemoryManager = class
  private
    FFacts: TList<TMemoryFact>;
    function IndexOf(const AKey: string): Integer;
  public
    constructor Create;
    destructor Destroy; override;

    procedure Load(const APath: string);
    procedure Save(const APath: string);

    procedure SetFact(const AKey, AValue, ACategory: string);
    function GetFact(const AKey: string): string;
    procedure DeleteFact(const AKey: string);
    procedure Clear;

    // Returns all facts as a formatted block for system prompt injection
    function ToSystemPromptContext: string;

    // JSON serialization
    function ToJSON: string;
    procedure FromJSON(const AJSON: string);

    function Count: Integer;
    function GetFactByIndex(AIndex: Integer): TMemoryFact;
  end;

implementation

constructor TMemoryManager.Create;
begin
  inherited;
  FFacts := TList<TMemoryFact>.Create;
end;

destructor TMemoryManager.Destroy;
begin
  FFacts.Free;
  inherited;
end;

function TMemoryManager.IndexOf(const AKey: string): Integer;
var
  I: Integer;
begin
  Result := -1;
  for I := 0 to FFacts.Count - 1 do
    if SameText(FFacts[I].Key, AKey) then
    begin
      Result := I;
      Exit;
    end;
end;

procedure TMemoryManager.SetFact(const AKey, AValue, ACategory: string);
var
  LFact: TMemoryFact;
  LIdx: Integer;
begin
  LFact.Key := AKey;
  LFact.Value := AValue;
  LFact.Category := ACategory;
  LFact.UpdatedAt := Now;

  LIdx := IndexOf(AKey);
  if LIdx >= 0 then
    FFacts[LIdx] := LFact
  else
    FFacts.Add(LFact);
end;

function TMemoryManager.GetFact(const AKey: string): string;
var
  LIdx: Integer;
begin
  Result := '';
  LIdx := IndexOf(AKey);
  if LIdx >= 0 then
    Result := FFacts[LIdx].Value;
end;

procedure TMemoryManager.DeleteFact(const AKey: string);
var
  LIdx: Integer;
begin
  LIdx := IndexOf(AKey);
  if LIdx >= 0 then
    FFacts.Delete(LIdx);
end;

procedure TMemoryManager.Clear;
begin
  FFacts.Clear;
end;

function TMemoryManager.Count: Integer;
begin
  Result := FFacts.Count;
end;

function TMemoryManager.GetFactByIndex(AIndex: Integer): TMemoryFact;
begin
  Result := FFacts[AIndex];
end;

function TMemoryManager.ToSystemPromptContext: string;
var
  SB: TStringBuilder;
  I: Integer;
  LFact: TMemoryFact;
  LCategory: string;
  LCategories: TArray<string>;
  LHasCategory: Boolean;

  function HasFactsForCategory(const ACat: string): Boolean;
  var
    J: Integer;
  begin
    Result := False;
    for J := 0 to FFacts.Count - 1 do
      if SameText(FFacts[J].Category, ACat) then
      begin
        Result := True;
        Exit;
      end;
  end;

begin
  if FFacts.Count = 0 then
  begin
    Result := '';
    Exit;
  end;

  SB := TStringBuilder.Create;
  try
    SB.AppendLine('## Agent Memory');
    SB.AppendLine('The following facts are remembered from previous sessions:');
    SB.AppendLine;

    LCategories := ['user', 'project', 'style', 'technical'];
    for LCategory in LCategories do
    begin
      LHasCategory := HasFactsForCategory(LCategory);
      if LHasCategory then
      begin
        SB.AppendLine('### ' + UpperCase(LCategory[1]) + Copy(LCategory, 2, MaxInt));
        for I := 0 to FFacts.Count - 1 do
        begin
          LFact := FFacts[I];
          if SameText(LFact.Category, LCategory) then
            SB.AppendLine(Format('- %s: %s', [LFact.Key, LFact.Value]));
        end;
        SB.AppendLine;
      end;
    end;

    // Any facts with unrecognized categories
    for I := 0 to FFacts.Count - 1 do
    begin
      LFact := FFacts[I];
      if not (SameText(LFact.Category, 'user') or SameText(LFact.Category, 'project') or
              SameText(LFact.Category, 'style') or SameText(LFact.Category, 'technical')) then
        SB.AppendLine(Format('- %s: %s', [LFact.Key, LFact.Value]));
    end;

    Result := Trim(SB.ToString);
  finally
    SB.Free;
  end;
end;

function TMemoryManager.ToJSON: string;
var
  RootArray: TJSONArray;
  FactObj: TJSONObject;
  I: Integer;
  LFact: TMemoryFact;
begin
  RootArray := TJSONArray.Create;
  try
    for I := 0 to FFacts.Count - 1 do
    begin
      LFact := FFacts[I];
      FactObj := TJSONObject.Create;
      FactObj.AddPair('key', LFact.Key);
      FactObj.AddPair('value', LFact.Value);
      FactObj.AddPair('category', LFact.Category);
      FactObj.AddPair('updated_at', FloatToStr(LFact.UpdatedAt));
      RootArray.AddElement(FactObj);
    end;
    Result := RootArray.Format(2);
  finally
    RootArray.Free;
  end;
end;

procedure TMemoryManager.FromJSON(const AJSON: string);
var
  RootArray: TJSONArray;
  FactObj: TJSONObject;
  LFact: TMemoryFact;
  I: Integer;
begin
  FFacts.Clear;
  if AJSON = '' then Exit;

  RootArray := TJSONObject.ParseJSONValue(AJSON) as TJSONArray;
  if RootArray = nil then Exit;
  try
    for I := 0 to RootArray.Count - 1 do
    begin
      FactObj := RootArray.Items[I] as TJSONObject;
      LFact.Key := FactObj.GetValue<string>('key');
      LFact.Value := FactObj.GetValue<string>('value');
      LFact.Category := FactObj.GetValue<string>('category');
      LFact.UpdatedAt := StrToFloatDef(FactObj.GetValue<string>('updated_at'), 0);
      FFacts.Add(LFact);
    end;
  finally
    RootArray.Free;
  end;
end;

procedure TMemoryManager.Load(const APath: string);
begin
  if TFile.Exists(APath) then
    FromJSON(TFile.ReadAllText(APath, TEncoding.UTF8));
end;

procedure TMemoryManager.Save(const APath: string);
begin
  TFile.WriteAllText(APath, ToJSON, TEncoding.UTF8);
end;

end.
