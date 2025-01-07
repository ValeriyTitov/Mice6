unit DAC.XParams;

interface
uses
 Data.DB, System.SysUtils, System.Classes, FireDAC.Stan.Param,
 System.Generics.Collections, System.Variants, System.Json,
 Common.StringUtils,
 Common.JsonUtils,
 DAC.XParams.Utils,
 Common.FormatSettings;

type
 TXParams = class(TParams)
  private
    FIgnoreList:TStringList;
    function GetAsQueryString: string;
    function IgnoringParam(const AParamName:string):Boolean;
    procedure SetAsQueryString(const Value: string);
    function GetIgnoreList: string;
    procedure SetIgnoreList(const Value: string);
    procedure SplitString(const Value:string; ADelimiter:Char);
    function GetAsString: string;
    procedure SetAsString(const Value: string);
    function GetAsJson: string;
    procedure SetAsJson(const Value: string);
  public
    procedure SetParameter(const ParamName:string; const ParamValue:Variant);
    procedure SetParameterNoDefault(const ParamName:string; const ParamValue, DefaultValue:Variant);
    procedure LoadFromDataSet(DataSet:TDataSet);
    procedure LoadFromDataSetList(DataSet:TDataSet; const NameField,ValueField:string);
    procedure LoadFromParams(Params:TParams);
    procedure TryApplyToDataSet(DataSet:TDataSet);
    function ToString:string; override;
    function ParamByNameDef(const ParamName:string; const Default:Variant):Variant;
    function AsDateTimeDef(const ParamName:string; const DefaultValue:TDateTime):TDateTime;
    function AsDateDef(const ParamName:string; const DefaultValue:TDate):TDate;
    function AsIntegerDef(const ParamName:string; DefaultValue:Integer):Integer;
    function AsBooleanDef(const ParamName:string; DefaultValue:Boolean):Boolean;
    procedure ToJsonObject(Obj:TJsonObject);
    procedure FromJsonObject(Obj:TJsonObject);
  published
    constructor Create;
    destructor Destroy; override;
    property AsQueryString:string read GetAsQueryString write SetAsQueryString;
    property AsString:string read GetAsString write SetAsString;
    property AsJson:string read GetAsJson write SetAsJson;
    property IgnoreList:string read GetIgnoreList write SetIgnoreList;
 end;

implementation

{ TXParams }

function TXParams.AsBooleanDef(const ParamName: string;  DefaultValue: Boolean): Boolean;
var
 P:TParam;
begin
 P:=FindParam(TParamUtils.NormalizeParamName(ParamName));
 if not Assigned(P) then
    Exit(DefaultValue);
 if not TryStrToBool(P.AsString,Result) then
  Result:=DefaultValue;
end;

function TXParams.AsDateDef(const ParamName: string;  const DefaultValue: TDate): TDate;
var
 P:TParam;
 s:string;
 AResult:TDateTime;
begin
 P:=FindParam(TParamUtils.NormalizeParamName(ParamName));
 if not Assigned(P) then
  Exit(DefaultValue);
 s:=VarToStr(P.Value);

 if TryStrToDate(s, AResult) or TryStrToDate(s, AResult, MiceFormatSettings) then
  Result:=AResult
   else
  Result:=DefaultValue;
end;

function TXParams.AsDateTimeDef(const ParamName: string;  const DefaultValue: TDateTime): TDateTime;
var
 P:TParam;
 s:string;
begin
 P:=FindParam(TParamUtils.NormalizeParamName(ParamName));
 if not Assigned(P) then
  Exit(DefaultValue);
 s:=VarToStr(P.Value);

 if not TryStrToDateTime(s, Result, MiceFormatSettings) then
  Result:=DefaultValue;
end;


function TXParams.AsIntegerDef(const ParamName: string;   DefaultValue: Integer): Integer;
var
 P:TParam;
begin
 P:=FindParam(TParamUtils.NormalizeParamName(ParamName));
 if not Assigned(P) then
  Exit(DefaultValue);
 if not Integer.TryParse(P.AsString, Result) then
  Result:=DefaultValue;
end;

constructor TXParams.Create;
begin
  inherited Create;
  FIgnoreList:=TStringList.Create;
  FIgnoreList.StrictDelimiter:=True;
  FIgnoreList.Delimiter:=';';
  FIgnoreList.CaseSensitive:=False;
  IgnoreList:='AppPluginsId;AppDialogsId'
end;
{
function TXParams.CreateJsonValue(P: TParam): TJsonValue;
begin
 if P.IsNull then
  Result:=TJsonNull.Create
  else
   case P.DataType  of
     ftSmallint: Result:=TJsonNumber.Create(P.Value);
     ftInteger: Result:=TJsonNumber.Create(P.Value);
     ftWord: Result:=TJsonNumber.Create(P.Value);
     ftBoolean: Result:=TJsonBool.Create(P.Value);
     ftLargeint: Result:=TJsonNumber.Create(P.Value);
     ftLongWord: Result:=TJsonNumber.Create(P.Value);
     else
      Result:=TJsonString.Create(P.AsString);
   end;
end;
 }
destructor TXParams.Destroy;
begin
  FIgnoreList.Free;
  inherited;
end;

procedure TXParams.FromJsonObject(Obj: TJsonObject);
var
 x:Integer;
begin
 for x:=0 to Obj.Count-1 do
  if (Obj.Pairs[x].JsonValue.ClassType<>TJsonObject) and (Obj.Pairs[x].JsonValue.ClassType<>TJsonArray) then
   SetParameter(Obj.Pairs[x].JsonString.Value ,Obj.Pairs[x].JsonValue.Value);
end;

function TXParams.GetIgnoreList: string;
begin
 Result:=FIgnoreList.Text;
end;

function TXParams.GetAsQueryString: string;
var
 x:integer;
begin
if Count=0 then
 Result:=''
  else
 for x:=0 to Count-1 do
  Result:=Result+'&'+TParamUtils.ParamToQueryStr(Items[x]);
end;

function TXParams.GetAsJson: string;
var
 Obj:TJsonObject;
begin
 Obj:=TJsonObject.Create;
 try
  ToJsonObject(Obj);
  Result:=TJsonUtils.Format(Obj.ToJSON);
 finally
  Obj.Free;
 end;

end;

function TXParams.GetAsString: string;
begin
 Result:=TParamUtils.ParamsToStr(Self);
end;

function TXParams.IgnoringParam(const AParamName: string): Boolean;
begin
 Result:=FIgnoreList.IndexOf(TParamUtils.NormalizeParamName(AParamName))>=0;
end;

procedure TXParams.LoadFromDataSet(DataSet: TDataSet);
begin
 if Assigned(DataSet) then
  TParamUtils.DataSetToParams(DataSet,Self);
end;

procedure TXParams.LoadFromDataSetList(DataSet: TDataSet; const NameField,  ValueField: string);
var
 AParamName:string;
 AParamValue:Variant;
begin
 DataSet.First;
 while not DataSet.Eof do
  begin
   AParamName:=DataSet.FieldByName(NameField).AsString;
   AParamValue:=DataSet.FieldByName(ValueField).Value;
   SetParameter(AParamName, AParamValue);
   DataSet.Next;
  end;
end;

procedure TXParams.LoadFromParams(Params: TParams);
var
 x:Integer;
begin
 for x:=0 to Params.Count-1 do
  SetParameter(Params[x].Name, Params[x].Value);
end;

function TXParams.ParamByNameDef(const ParamName: string;  const Default: Variant): Variant;
var
 P:TParam;
begin
 P:=FindParam(TParamUtils.NormalizeParamName(ParamName));
 if Assigned(P) then
  Result:=P.Value
   else
  Result:=Default;
end;

procedure TXParams.SetIgnoreList(const Value: string);
begin
 FIgnoreList.DelimitedText:=Value.Replace('@','');
end;

procedure TXParams.SetParameter(const ParamName: string;  const ParamValue: Variant);
begin
 TParamUtils.SetParamEx(Self,ParamName,ParamValue);
end;


procedure TXParams.SetParameterNoDefault(const ParamName: string;  const ParamValue, DefaultValue: Variant);
var
 P:TParam;
begin
 if ParamValue<>DefaultValue then
  SetParameter(ParamName,ParamValue)
   else
    begin
      P:=FindParam(ParamName);
      if Assigned(P) then
       Delete(P.Index);
    end
end;

procedure TXParams.SetAsQueryString(const Value: string);
begin
 Self.SplitString(Value,'&');
end;

procedure TXParams.SetAsJson(const Value: string);
var
 Obj:TJsonValue;
begin
 Clear;
  try
   Obj:=TJsonObject.ParseJSONValue(Value);
   if Assigned(Obj) then
    try
     FromJsonObject(Obj as TJsonObject);
    finally
      Obj.Free;
    end;
  except
   TJsonUtils.RaiseParseError;
  end;
end;

procedure TXParams.SetAsString(const Value: string);
begin
 Self.SplitString(Value,',');
end;

procedure TXParams.SplitString(const Value: string; ADelimiter: Char);
var
 List:TStringList;
 x:Integer;
begin
 List:=TStringList.Create;
 try
  List.Delimiter:=ADelimiter;
  List.StrictDelimiter:=True;
  if Value.StartsWith('?') then
   List.DelimitedText:=Value.Substring(1)
    else
   List.DelimitedText:=Value;
  for x:=0 to List.Count-1 do
   if not IgnoringParam(List.Names[x]) then
    SetParameter(List.Names[x],List.ValueFromIndex[x]);
 finally
  List.Free;
 end;
end;


procedure TXParams.ToJsonObject(Obj: TJsonObject);
var
 Param:TParam;
 X:Integer;
begin
 for x:=0 to Self.Count-1 do
  begin
   Param:=Self[x];
   if Param.IsNull then
   Obj.AddPair(Param.Name,TJsonNull.Create)
    else
   Obj.AddPair(Param.Name,AnsiDequotedStr(TParamUtils.ParamValueToStr(Param), DelphiQuoteChar));
  end;
end;

function TXParams.ToString: string;
begin
 Result:=Self.AsString;
end;

procedure TXParams.TryApplyToDataSet(DataSet: TDataSet);
var
 x:Integer;
 F:TField;
 P:TParam;
begin
 for x:=0 to Self.Count-1 do
  begin
    P:=Self[x];
    F:=DataSet.FindField(P.Name);
    if Assigned(F) and (not F.ReadOnly) then
     F.Value:=P.Value;
  end;

end;

end.
