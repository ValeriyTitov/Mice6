unit DAC.XDataSet.Data.Serializer;

interface
uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  FireDAC.Comp.Client, FireDAC.Stan.Option, FireDAC.Stan.Intf, Data.DB,
  System.Generics.Collections, System.Generics.Defaults,System.JSON, Rest.Json,
  Common.StringUtils,
  DAC.XDataSet.Data.Convert,
  DAC.ObjectModels.ExecutionContext,
  DAC.ObjectModels.Exception,
  Common.JsonUtils;

type
 TxDataSetSerializer = class
  strict private
    FDataSet:TFDMemTable;
    FExecutionContext: TMiceExecutionContext;
    procedure CreateColumn(const ColumnName:string; const AFieldType:TFieldType; const ASize:Integer;AllowDBNull, AutoInc:Boolean);
    procedure CreateColumns(Columns: TJsonArray);
    procedure CreateRow(DataRow: TJsonArray);
    procedure CreateRows(Rows:TJsonArray);
    procedure CreateExecutionContext(Context:TJsonObject);
    procedure ClearDataSet;
   public
    procedure Convert(const Json:string); overload;
    procedure ConvertObject(JSONValue:TJsonValue);
    procedure ConvertFile(const FileName:string);
    property DataSet:TFDMemTable read FDataSet write FDataSet;
    property ExecutionContext:TMiceExecutionContext read FExecutionContext write FExecutionContext;
    class procedure Serialize(const Json:string; DataSet:TFDMemTable; Context:TMiceExecutionContext);
    class procedure SerializeObject(jObject:TJsonValue; DataSet:TFDMemTable; Context:TMiceExecutionContext);
 end;


implementation

{ TxDataSetSerializer }


procedure TxDataSetSerializer.ClearDataSet;
begin
  DataSet.Close;
  DataSet.Fields.Clear;
  DataSet.FieldDefs.Clear;
  DataSet.LogChanges:=False;
end;

procedure TxDataSetSerializer.Convert(const Json:string);
var
  JSONValue:TJsonValue;
begin
 JSONValue := TJsonUtils.TryCreateJson(Json);
  try
   ConvertObject(JSONValue);
  finally
   JSONValue.Free;
  end;
end;

procedure TxDataSetSerializer.ConvertFile(const FileName: string);
var
 List:TStringList;
begin
 List:=TStringList.Create;
 try
  List.LoadFromFile(FileName);
  Convert(List.Text);
 finally
  List.Free;
 end;

end;


procedure TxDataSetSerializer.ConvertObject(JSONValue: TJsonValue);
var
  jColumns:TJsonArray;
  jRows: TJsonArray;
  jContext:TJsonObject;
begin
    EDACException.CheckForException(JSONValue);

    if JSONValue.TryGetValue('ExecutionContext', jContext) then
     CreateExecutionContext(jContext);

 if Assigned(FDataSet) then
   try
    ClearDataSet;
    FDataSet.DisableControls;

    if JsonValue.TryGetValue('Columns',jColumns) then
     CreateColumns(jColumns);

    if JsonValue.TryGetValue('Rows',jRows)  then
     CreateRows(jRows);

    FDataSet.LogChanges:=True;

  finally
      FDataSet.EnableControls;
  end;

 end;
procedure TxDataSetSerializer.CreateColumn(const ColumnName: string;  const AFieldType: TFieldType; const ASize: Integer; AllowDBNull, AutoInc:Boolean);
var
  Def:TFieldDef;
begin
  Def:=FDataSet.FieldDefs.AddFieldDef;
  Def.Name:=ColumnName;
  Def.DataType:=AFieldType;
  if (Def.DataType=ftString) and (ASize>0) then
   Def.Size:=ASize;

  Def.CreateField(FDataSet);
end;

procedure TxDataSetSerializer.CreateColumns(Columns: TJsonArray);
var
 x:Integer;
 ColumnName:string;
 ColDataType:string;
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
   CreateColumn(ColumnName,TJsonDataConvert.FindType(ColDataType, AutoInc), Size, AllowDBNull, AutoInc);
  end;
end;

procedure TxDataSetSerializer.CreateExecutionContext(Context: TJsonObject);
begin
 if Assigned(ExecutionContext) then
  ExecutionContext.FromJsonObject(Context);
end;

procedure TxDataSetSerializer.CreateRow(DataRow: TJsonArray);
var
 x:Integer;
begin
 FDataSet.Append;
  for x:=0 to DataRow.Count-1 do
   TJsonDataConvert.SetFieldValue(FDataSet.Fields[x],DataRow.Items[x].Value);

 FDataSet.Post;
end;


procedure TxDataSetSerializer.CreateRows(Rows: TJsonArray);
var
 x:Integer;
begin
  FDataSet.Open;
  for x:=0 to Rows.Count-1 do
   CreateRow(Rows.Items[x] as TJsonArray);
  FDataSet.First;
end;


class procedure TxDataSetSerializer.SerializeObject(jObject: TJsonValue; DataSet: TFDMemTable; Context: TMiceExecutionContext);
var
 Serializer: TxDataSetSerializer;
begin
 Serializer:=TxDataSetSerializer.Create;
 try
  Serializer.ExecutionContext:=Context;
  Serializer.DataSet:=DataSet;
  Serializer.ConvertObject(jObject);
 finally
  Serializer.Free;
 end;

end;

class procedure TxDataSetSerializer.Serialize(const Json: string;  DataSet: TFDMemTable; Context: TMiceExecutionContext);
var
 Serializer: TxDataSetSerializer;
begin
 Serializer:=TxDataSetSerializer.Create;
 try
  Serializer.ExecutionContext:=Context;
  Serializer.DataSet:=DataSet;
  Serializer.Convert(Json);
 finally
  Serializer.Free;
 end;

end;



end.
