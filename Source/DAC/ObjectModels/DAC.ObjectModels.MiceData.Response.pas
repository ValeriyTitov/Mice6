unit DAC.ObjectModels.MiceData.Response;

interface
uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  FireDAC.Comp.Client, FireDAC.Stan.Option, FireDAC.Stan.Intf, Data.DB,
  System.Generics.Collections, System.Generics.Defaults,System.JSON, Rest.Json,
  Common.StringUtils,
  DAC.Data.Convert,
  DAC.ObjectModels.ExecutionContext,
  DAC.ObjectModels.Exception,
  Common.JsonUtils;

type
 TMiceDataResponse = class
  strict private
    FQueryToken: string;
    FDataSet:TFDMemTable;
    FControlsDisabled:Boolean;
    FReadOnly:Boolean;
    FExecutionContext: TMiceExecutionContext;
    FAfterOpen:TDataSetNotifyEvent;
    FAfterPost:TDataSetNotifyEvent;
    FBeforePost:TDataSetNotifyEvent;
    FBeforeEdit:TDataSetNotifyEvent;
    FAfterEdit:TDataSetNotifyEvent;
    FAfterInsert:TDataSetNotifyEvent;
    FBeforeOpen:TDataSetNotifyEvent;
    procedure CreateColumn(const ColumnName:string; const AFieldType:TFieldType; const ASize:Integer;AllowDBNull, AutoInc:Boolean);
    procedure CreateColumns(Columns: TJsonArray);
    procedure CreateRow(DataRow: TJsonArray);
    procedure CreateRows(Rows:TJsonArray);
    procedure CreateExecutionContext(Context:TJsonObject);
    procedure ClearDataSet;
    procedure SaveState;
    procedure RestoreState;
    procedure InternalCreateDataSet(jValue: TJsonValue);
    procedure FindReadOnlyFields;
   public
    procedure FromJsonString(const Json:string); overload;
    procedure FromJson(jValue:TJsonValue);
    property DataSet:TFDMemTable read FDataSet write FDataSet;
    property ExecutionContext:TMiceExecutionContext read FExecutionContext write FExecutionContext;
    property QueryToken:string read FQueryToken write FQueryToken;
    class procedure SerializeObjects(jValue:TJsonValue; DataSet:TFDMemTable; Context:TMiceExecutionContext);
 end;


implementation

{ TxDataSetSerializer }


procedure TMiceDataResponse.ClearDataSet;
begin
  DataSet.Fields.Clear;
  DataSet.FieldDefs.Clear;
  DataSet.LogChanges:=False;
end;

procedure TMiceDataResponse.FromJsonString(const Json:string);
var
  JSONValue:TJsonValue;
begin
 JSONValue := TJsonUtils.TryCreateJson(Json);
  try
   FromJson(JSONValue);
  finally
   JSONValue.Free;
  end;
end;

procedure TMiceDataResponse.InternalCreateDataSet(jValue:TJsonValue);
var
 jColumns:TJsonArray;
 jRows: TJsonArray;
begin
  try
    DataSet.Close;
    ClearDataSet;
    SaveState;

    if jValue.TryGetValue('Columns',jColumns) then
     CreateColumns(jColumns);

    if jValue.TryGetValue('Rows',jRows)  then
     CreateRows(jRows);

    FindReadOnlyFields;

    FDataSet.LogChanges:=True;

  finally
    RestoreState;
  end;
end;


procedure TMiceDataResponse.RestoreState;
begin
 if (FControlsDisabled=False) then
  DataSet.EnableControls;
 DataSet.ReadOnly:=Self.FReadOnly;
 DataSet.AfterOpen:=Self.FAfterOpen;
 DataSet.AfterPost:=Self.FAfterPost;
 DataSet.AfterInsert:=Self.FAfterInsert;
 DataSet.AfterEdit:=Self.FAfterEdit;
 DataSet.BeforePost:=Self.FBeforePost;
 DataSet.BeforeEdit:=Self.FBeforeEdit;
 DataSet.BeforeOpen:=Self.FBeforeOpen;
end;

procedure TMiceDataResponse.SaveState;
begin
 FControlsDisabled:=DataSet.ControlsDisabled;
 if not FControlsDisabled then
  DataSet.DisableControls;
 Self.FReadOnly:=DataSet.ReadOnly;
 Self.FAfterOpen:=DataSet.AfterOpen;
 Self.FAfterPost:=DataSet.AfterPost;
 Self.FAfterInsert:=DataSet.AfterInsert;
 Self.FAfterEdit:=DataSet.AfterEdit;
 Self.FBeforePost:=DataSet.BeforePost;
 Self.FBeforeEdit:=DataSet.BeforeEdit;
 Self.FBeforeOpen:=DataSet.BeforeOpen;
 DataSet.BeforeOpen:=nil;
 DataSet.AfterOpen:=nil;
 DataSet.AfterPost:=nil;
 DataSet.AfterInsert:=nil;
 DataSet.AfterEdit:=nil;
 DataSet.BeforePost:=nil;
 DataSet.BeforeEdit:=nil;
 DataSet.ReadOnly:=False;
end;

class procedure TMiceDataResponse.SerializeObjects(jValue: TJsonValue;  DataSet: TFDMemTable; Context: TMiceExecutionContext);
var
 Serializer: TMiceDataResponse;
begin
 Serializer:=TMiceDataResponse.Create;
 try
  Serializer.ExecutionContext:=Context;
  Serializer.DataSet:=DataSet;
  Serializer.FromJson(jValue);
 finally
  Serializer.Free;
 end;
end;

procedure TMiceDataResponse.FindReadOnlyFields;
var
 Field:TField;
begin
 for Field in DataSet.Fields do
  if (Field.DataType=ftAutoInc) then
   Field.ReadOnly:=True;
end;

procedure TMiceDataResponse.FromJson(jValue: TJsonValue);
var
  jContext:TJsonObject;
  jQueryToken:TJsonObject;
begin
 EDACException.CheckForExceptionWithMessages(jValue, ExecutionContext.Messages);

 if jValue.TryGetValue('ExecutionContext', jContext) then
    CreateExecutionContext(jContext);

 if jValue.TryGetValue('QueryToken', jQueryToken) then
     QueryToken:=jQueryToken.Value;

 if Assigned(FDataSet) then
    InternalCreateDataSet(jValue);
end;


procedure TMiceDataResponse.CreateColumn(const ColumnName: string;  const AFieldType: TFieldType; const ASize: Integer; AllowDBNull, AutoInc:Boolean);
var
  Def:TFieldDef;
begin
  Def:=FDataSet.FieldDefs.AddFieldDef;
  Def.Name:=ColumnName;
  Def.DataType:=AFieldType;
  if (Def.DataType=ftString) and (ASize>0) then
   Def.Size:=ASize
  else
   if (Def.DataType=ftGuid) and (ASize=-1) then
   Def.Size:=16;


  Def.CreateField(FDataSet);
end;

procedure TMiceDataResponse.CreateColumns(Columns: TJsonArray);
var
 x:Integer;
 ColumnName:string;
 ColDataType:string;
 ADataType:TFieldType;
 Size:Integer;
 AutoInc:Boolean;
 AllowDBNull:Boolean;
begin
 for x:=0 to Columns.Count-1 do
  begin
   ColumnName:=Columns.Items[x].GetValue<string>('Name');
   ColDataType:=Columns.Items[x].GetValue<string>('DataType');
   Size:=Columns.Items[x].GetValue<Integer>('Size',-1);
   AllowDBNull:=Columns.Items[x].GetValue<Boolean>('AllowDBNull', True);
   AutoInc:=Columns.Items[x].GetValue<Boolean>('AutoInc', False);
   ADataType:=TJsonDataConvert.FindType(ColDataType, AutoInc, Size);
   CreateColumn(ColumnName,ADataType, Size, AllowDBNull, AutoInc);
  end;
end;

procedure TMiceDataResponse.CreateExecutionContext(Context: TJsonObject);
begin
 if Assigned(ExecutionContext) then
  ExecutionContext.FromJsonObject(Context);
end;

procedure TMiceDataResponse.CreateRow(DataRow: TJsonArray);
var
 x:Integer;
begin
 FDataSet.Append;
  for x:=0 to DataRow.Count-1 do
   TJsonDataConvert.SetFieldValue(FDataSet.Fields[x],DataRow.Items[x].Value);
 FDataSet.Post;
end;


procedure TMiceDataResponse.CreateRows(Rows: TJsonArray);
var
 x:Integer;
begin
  FDataSet.OpenOrExecute;
  for x:=0 to Rows.Count-1 do
   CreateRow(Rows.Items[x] as TJsonArray);
  if FDataSet.Active then
   FDataSet.First;
end;


end.
