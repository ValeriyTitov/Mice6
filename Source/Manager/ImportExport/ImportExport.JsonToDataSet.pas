unit ImportExport.JsonToDataSet;

interface

uses
 System.SysUtils, System.Variants, Data.DB,
 System.NetEncoding,  System.Generics.Collections,
 System.Generics.Defaults, System.Classes, System.JSON,
 System.IOUtils,
 Dialog.MShowMessage,
 Common.VariantUtils,
 Common.FormatSettings,
 DAC.Data.Convert;


type
 TJsonToDataSetConverter = class
  private
    FDataSet: TDataSet;
    FJsonDataSet: TJsonArray;
    FKeyField: string;
    FCurrentChangeCount:Integer;
    FAfterInsert: TDataSetNotifyEvent;
    FAfterUpdate: TDataSetNotifyEvent;
    FInsertedCount: Integer;
    FDeletedCount: Integer;
    FChangeCount:Integer;
    FTotalChangeCount: Integer;
    FJJsonKeyFieldList:TList<Integer>;
    FDeleteMissingKeyFields: Boolean;
    procedure SetRowData(jDataRow:TJsonObject);
    procedure LocateTo(KeyFieldValue:Integer);
    procedure SetFieldData(Field:TField; jValue:TJsonValue);
    procedure DoDeleteMissingKeyFields;
    procedure DoDeleteRow(DataSet:TDataSet);
    function LoadObjectValue(jValue:TJsonValue):string;
    function LoadFromFile(const FileName:string):string;
    function jValueToVariant(jValue:TJsonValue):Variant;
    function SameValue(Field:TField; const Value:Variant):Boolean;
 protected
    procedure DoAfterInsert(DataSet:TDataSet);
    procedure DoAfterUpdate(DataSet:TDataSet);
 public
    property JsonDataSet:TJsonArray read FJsonDataSet write FJsonDataSet;
    property DataSet:TDataSet read FDataSet write FDataSet;
    property KeyField:string read FKeyField write FKeyField;
    property ChangeCount:Integer read FChangeCount;
    property TotalChangeCount: Integer read FTotalChangeCount;
    property InsertedCount:Integer read FInsertedCount;
    property DeletedCount:Integer read FDeletedCount;
    property AfterInsert:TDataSetNotifyEvent read FAfterInsert write FAfterInsert;
    property AfterUpdate:TDataSetNotifyEvent read FAfterUpdate write FAfterUpdate;
    property DeleteMissingKeyFields:Boolean read FDeleteMissingKeyFields write FDeleteMissingKeyFields;
    procedure Fill;
    constructor Create; virtual;
    destructor Destroy; override;
 end;



implementation

{ TJsonToDataSetConverter }

constructor TJsonToDataSetConverter.Create;
begin
 FInsertedCount:=0;
 FDeletedCount:=0;
 FChangeCount:=0;
 FJJsonKeyFieldList:=TList<Integer>.Create;
 DeleteMissingKeyFields:=False;
end;

procedure TJsonToDataSetConverter.DoDeleteMissingKeyFields;
begin
 DataSet.First;
 while not DataSet.Eof do
  begin
   if not FJJsonKeyFieldList.Contains(DataSet.FieldByName(KeyField).AsInteger) then
    DoDeleteRow(DataSet);
   DataSet.Next;
  end;
end;

procedure TJsonToDataSetConverter.DoDeleteRow(DataSet: TDataSet);
begin
 if Assigned(DataSet.BeforeDelete) then
  DataSet.BeforeDelete(DataSet)
   else
  DataSet.Delete;

  Inc(FDeletedCount);
  Inc(FTotalChangeCount);
end;

destructor TJsonToDataSetConverter.Destroy;
begin
   FJJsonKeyFieldList.Free;
  inherited;
end;

procedure TJsonToDataSetConverter.DoAfterInsert(DataSet: TDataSet);
begin
 if Assigned(Self.AfterInsert) then
  AfterInsert(DataSet);
end;

procedure TJsonToDataSetConverter.DoAfterUpdate(DataSet: TDataSet);
begin
 Inc(FChangeCount);
 if Assigned(AfterUpdate) then
  AfterUpdate(DataSet);
end;

procedure TJsonToDataSetConverter.Fill;
var
 jDataRow:TJsonValue;
 KeyFieldValue:Integer;
begin
 FChangeCount:=0;
 for jDataRow in JsonDataSet do
  begin
   KeyFieldValue:=(jDataRow as TJsonObject).GetValue<Integer>(KeyField);
   FJJsonKeyFieldList.Add(KeyFieldValue);
   LocateTo(KeyFieldValue);
   SetRowData(jDataRow as TJsonObject);
  end;
 if DeleteMissingKeyFields then
  DoDeleteMissingKeyFields;
end;


function TJsonToDataSetConverter.LoadFromFile(const FileName: string): string;
begin
 Result:=TFile.ReadAllText(FileName, TEncoding.UTF8);
end;

function TJsonToDataSetConverter.LoadObjectValue(jValue: TJsonValue): string;
var
 ASource:string;
 jObject:TJsonObject;
 APath:string;
resourcestring
 E_UNKNOWN_JSON_DATASOURCE_FMT = 'Unkown data source in json value: %s';
 E_UNKNOWN_JSONTYPE = 'Unkown json type';
begin
 if jValue is TJsonArray then
  Result:=jValue.Format
 else
 if jValue is TJsonObject then
  begin
   jObject:=jValue as TJsonObject;
   ASource:=jObject.Pairs[0].JsonString.Value;
   APath:=jObject.Pairs[0].JsonValue.Value;
   if ASource='!Utf8File' then
    Result:=LoadFromFile(APath)
     else
    Result:=jObject.Format;
  end
   else
   raise Exception.Create(E_UNKNOWN_JSONTYPE);
end;

procedure TJsonToDataSetConverter.LocateTo(KeyFieldValue: Integer);
begin
 if DataSet.Locate(Self.KeyField,KeyFieldValue,[]) then
   DataSet.Edit
   else
  begin
   DataSet.Append;
   Inc(FInsertedCount);
  end;
end;

procedure TJsonToDataSetConverter.SetRowData(jDataRow: TJsonObject);
var
 jPair:TJsonPair;
 FieldName:string;
 FAppending:Boolean;
begin
 FCurrentChangeCount:=0;
 for jPair in jDataRow do
  begin
    FieldName:=jPair.JsonString.Value;
    SetFieldData(DataSet.FieldByName(FieldName), jPair.JsonValue);
  end;

  if FCurrentChangeCount>0 then
   begin
    FAppending:=DataSet.State in [dsInsert];
    DataSet.Post;
    if FAppending then
     DoAfterInsert(DataSet)
      else
     DoAfterUpdate(DataSet);
   end;
end;

function TJsonToDataSetConverter.jValueToVariant(jValue: TJsonValue): Variant;
begin
 if jValue is TJsonNull then
  Result:=Null
   else
  if (jValue is TJsonObject) or (jValue is TJsonArray) then
   Result:=LoadObjectValue(jValue)
    else
   Result:=jValue.Value;
end;

function TJsonToDataSetConverter.SameValue(Field: TField; const Value: Variant): Boolean;
begin
 if TJsonDataConvert.FieldValueComparable(Field) then
  Result:=Field.Value=Value
   else
 if (Field.DataType=ftBlob) then
  Result:=TJsonDataConvert.BlobToBase64(Field as TBlobField)=VarToStr(Value)
   else
  Result:=False;
end;

procedure TJsonToDataSetConverter.SetFieldData(Field: TField;  jValue: TJsonValue);
var
 Value:Variant;
begin
 Value:=jValueToVariant(jValue);
 if not SameValue(Field,Value) then
  begin
   TJsonDataConvert.SetFieldValue(Field,Value);
   Inc(FCurrentChangeCount);
   Inc(FTotalChangeCount);
//   SameValue(Field,Value);
  end;
end;


end.
