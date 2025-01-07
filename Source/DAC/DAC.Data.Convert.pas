unit DAC.Data.Convert;

interface

uses
 System.SysUtils, System.Variants, Data.DB,
 System.NetEncoding,  System.Generics.Collections,
 System.Generics.Defaults, System.Classes, System.JSON,
 Common.VariantUtils,
 Common.FormatSettings;

type
 TJsonDataConvert = class
 strict private
   class function ConvertToDateTime(const Value: string): TDateTime;
   class function ConvertToBool(const Value: string): Boolean;
   class function CreateFieldJsonValue(Field:TField):TJsonValue;
   class function JsonText(Field:TField):TJsonValue;
 public
   class procedure SetFieldValue(Field:TField; const Value:Variant);
   class procedure SetBlobData(const s:string; Field:TBlobField);
   class function FindType(const s:string; AutoInc:Boolean; Size:Integer):TFieldType;
   class function BlobToBase64(Field:TBlobField):string;
   class function DataSetToJsonObjectWebApi(DataSet:TDataSet):TJsonArray;
   class function DataSetToJsonStringWebApi(DataSet:TDataSet):string;
   class function FieldValueComparable(Field:TField):Boolean;
 end;

const
 S_FIELD_CONTAINTS_JSON_TEXT = 'FieldContainsJsonText';

implementation
var
  FDataTypeList : TDictionary<string,TFieldType>;


{ TJsonDataConvert }

class function TJsonDataConvert.BlobToBase64(Field: TBlobField): string;
var
 M1:TStringStream;
 M2:TMemoryStream;
begin
 M1:=TStringStream.Create('');
  try
   M2:=TMemoryStream.Create;
    try
     Field.SaveToStream(M2);
     M2.Seek(0,0);
     TNetEncoding.Base64.Encode(M2,M1);
     Result:=M1.DataString;
    finally
     M2.Free;
    end;
  finally
   M1.Free;
  end;
end;


class function TJsonDataConvert.ConvertToBool(const Value: string): Boolean;
begin
 Result:= not((Value='0') or (Value='false'));
end;

class function TJsonDataConvert.ConvertToDateTime(const Value: string): TDateTime;
begin
 Result:=StrToDateTime(Value ,MiceFormatSettings);
end;

class function TJsonDataConvert.CreateFieldJsonValue(Field: TField): TJsonValue;
begin
if Field.IsNull then
 Result:=TJsonNull.Create
  else
if Field.EditMask=S_FIELD_CONTAINTS_JSON_TEXT then
 Result:=JsonText(Field)
  else
 case Field.DataType of
   ftString, ftFixedChar, ftFixedWideChar, ftWideMemo, ftWideString, ftSmallint, ftMemo: Result:=TJsonString.Create(Field.AsString);
   ftAutoInc, ftInteger, ftWord,  ftLargeint, ftLongWord, ftShortint, ftByte: Result:=TJsonNumber.Create(Field.AsInteger);
   ftBoolean: Result:=TJsonBool.Create(Field.AsBoolean);
   ftFloat, ftCurrency, ftExtended, ftSingle, ftBCD:Result:=TJsonNumber.Create(Field.AsFloat);
   ftDate,  ftDateTime: Result:=TJsonString.Create(Field.ToString);
   ftBlob: Result:=TJsonString.Create(BlobToBase64(Field as TBlobField));
    else
   Result:=TJsonString.Create(Field.AsString);
 end;
end;

class function TJsonDataConvert.FieldValueComparable(Field: TField): Boolean;
begin
 case Field.DataType of
   ftBlob: Result:=False;
    else
   Result:=True;
 end;
end;

class function TJsonDataConvert.FindType(const s: string; AutoInc: Boolean; Size:Integer): TFieldType;
resourcestring
 S_UNKNOWN_FIELD_TYPE ='Unknow field type: %s';
begin
 if FDataTypeList.ContainsKey(s) then
  Result:=FDataTypeList[s]
   else
  raise Exception.CreateFmt(S_UNKNOWN_FIELD_TYPE,[s]);

 case Result of
  ftInteger,ftLargeint,ftSmallint: if AutoInc then Result:=ftAutoInc;
  ftString : if Size>8192 then Result:=ftMemo;
 end;

end;


class function TJsonDataConvert.JsonText(Field: TField): TJsonValue;
begin
if Field.AsString='' then
 Result:=TJsonNull.Create
  else
 Result:=TJsonValue.ParseJSONValue(Field.AsString);

 if not Assigned(Result) then
  Result:=TJsonNull.Create;
end;

class procedure TJsonDataConvert.SetBlobData(const s: string; Field: TBlobField);
var
 M1:TStringStream;
 M2:TMemoryStream;
begin
 M1:=TStringStream.Create(s);
  try
   M2:=TMemoryStream.Create;
    try
     TNetEncoding.Base64.Decode(M1,M2);
     M2.Seek(0,0);
     Field.LoadFromStream(M2);
    finally
     M2.Free;
    end;
  finally
   M1.Free;
  end;
end;

class procedure TJsonDataConvert.SetFieldValue(Field: TField;  const Value: Variant);
begin
 if not TVariantUtils.VarIsNullStr(Value) then
  case Field.DataType of
       ftFloat: Field.Value:=StrToFloat(Value,MiceFormatSettings);
       ftCurrency: Field.Value:=StrToFloat(Value,MiceFormatSettings);
       ftDate: Field.Value:=ConvertToDateTime(Value);
       ftTime: Field.Value:=ConvertToDateTime(Value);
       ftDateTime: Field.Value:=ConvertToDateTime(Value);
       ftBoolean: Field.Value:=ConvertToBool(Value);
       ftBlob: SetBlobData(Value,Field as TBlobField);
       //ftBCD: Self.SetBCDData(Value, Field as TBCDField);
        else
       Field.Value:=Value;
    end
  else
   Field.Clear;
end;

class function TJsonDataConvert.DataSetToJsonObjectWebApi(DataSet: TDataSet): TJsonArray;
var
 Field:TField;
 Row:TJsonObject;
begin
 Result:=TJsonArray.Create;
 while not DataSet.Eof do
  begin
   Row:=TJsonObject.Create;
    for Field in DataSet.Fields do
     Row.AddPair(Field.FieldName, CreateFieldJsonValue(Field));

    Result.Add(Row);
    DataSet.Next;
  end;
end;

class function TJsonDataConvert.DataSetToJsonStringWebApi(DataSet: TDataSet): string;
var
 jObject:TJsonArray;
begin
  jObject:=DataSetToJsonObjectWebApi(DataSet);
   try
    if Assigned(jObject) then
     Result:=jObject.Format
      else
     Result:='[]';
   finally
     jObject.Free;
   end;
end;



initialization

//https://docs.microsoft.com/en-us/dotnet/framework/data/adonet/sql-server-data-type-mappings

 FDataTypeList:=TDictionary<string,TFieldType>.Create(TIStringComparer.Ordinal);
 FDataTypeList.Add('Int16',ftInteger);
 FDataTypeList.Add('Int16?',ftInteger);
 FDataTypeList.Add('Int32',ftInteger);
 FDataTypeList.Add('Int32?',ftInteger);
 FDataTypeList.Add('Int64',ftLargeint);
 FDataTypeList.Add('Int64?',ftLargeint);
 FDataTypeList.Add('String',ftString);
 FDataTypeList.Add('String?',ftString);
 FDataTypeList.Add('Decimal',ftFloat);
 FDataTypeList.Add('Decimal?',ftFloat);
 FDataTypeList.Add('DateTime',ftDateTime);
 FDataTypeList.Add('DateTime?',ftDateTime);
 FDataTypeList.Add('Bool',ftBoolean);
 FDataTypeList.Add('Bool?',ftBoolean);
 FDataTypeList.Add('Boolean',ftBoolean);
 FDataTypeList.Add('Boolean?',ftBoolean);
 FDataTypeList.Add('Short',ftInteger);
 FDataTypeList.Add('Short?',ftInteger);
 FDataTypeList.Add('Byte[]',ftBlob);
 FDataTypeList.Add('Byte[]?',ftBlob);
 FDataTypeList.Add('Byte',ftBlob);
 FDataTypeList.Add('Byte?',ftBlob);
 FDataTypeList.Add('Char[]',ftWideString);
 FDataTypeList.Add('Char[]?',ftWideString);
 FDataTypeList.Add('Guid',ftGuid);
 FDataTypeList.Add('Double',ftFloat);
 FDataTypeList.Add('Double?',ftFloat);

finalization
 FDataTypeList.Free;
end.
