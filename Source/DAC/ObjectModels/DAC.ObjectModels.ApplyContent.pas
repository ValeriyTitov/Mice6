unit DAC.ObjectModels.ApplyContent;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  FireDAC.Comp.Client, FireDAC.Stan.Option, FireDAC.Stan.Intf, Data.DB,
  System.Generics.Collections, System.Generics.Defaults,System.JSON, Rest.Json,
  DAC.Data.Convert,
  Common.JsonUtils,
  Common.StringUtils,
  Dialogs;

type

  TDataSetRowValue = class
   FieldName:string;
   Value:string;
   procedure ToJsonObject(Obj:TJsonObject);
  end;

  TDataSetRow = class(TObjectList<TDataSetRowValue>)
  strict private
    FUpdateRequest: TFDUpdateRequest;
    FKeyFieldValue: string;
    FKeyField: string;
    procedure AddDeleteObject(Obj: TJsonArray);
    procedure AddUpdateObject(Obj:TJsonArray);
    procedure AddInsertObject(Obj:TJsonArray);
    function CreateDefaultJson:TJsonObject;
    function FieldChanged(Field:TField):Boolean;
  public
    property KeyField:string read FKeyField write FKeyField;
    property KeyFieldValue:string read FKeyFieldValue write FKeyFieldValue;
    property UpdateRequest: TFDUpdateRequest read FUpdateRequest write FUpdateRequest;
    procedure LoadFromDataSet(DataSet:TDataSet);
    procedure ToJsonArray(Obj:TJsonArray);
    class function RequestToStr(Request:TFDUpdateRequest):string;
  end;


  TMiceApllyContent = class(TObjectList<TDataSetRow>)
  public
   procedure ToJsonObject(jObject:TJsonObject);
   procedure ToNewJsonObject(jOwner:TJsonObject);
   function ToJsonString:string;
  end;


implementation


{ TDataSetRow }

procedure TDataSetRow.AddDeleteObject(Obj: TJsonArray);
var
 Current:TJsonObject;
begin
 Current:=CreateDefaultJson;
 Obj.AddElement(Current);
end;


procedure TDataSetRow.AddInsertObject(Obj: TJsonArray);
var
 Current:TJsonObject;
 FieldValues:TJsonObject;
 AValue:TDataSetRowValue;
begin
 Current:=CreateDefaultJson;
 FieldValues:=TJsonObject.Create;
 for AValue in Self do
  AValue.ToJsonObject(FieldValues);
 Current.AddPair('Values',FieldValues);
 Obj.AddElement(Current);
end;


procedure TDataSetRow.ToJsonArray(Obj: TJsonArray);
begin
  case UpdateRequest of
   arInsert: AddInsertObject(Obj);
   arUpdate: AddUpdateObject(Obj);
   arDelete: AddDeleteObject(Obj);
//    else raise Exception.CreateFmt('Dataset update type is unknown: %d',[Ord(Request)]);
  end;
end;

procedure TDataSetRow.AddUpdateObject(Obj: TJsonArray);
var
 Current:TJsonObject;
 FieldValues:TJsonObject;
 AValue:TDataSetRowValue;
begin
 Current:=CreateDefaultJson;
 FieldValues:=TJsonObject.Create;
 for AValue in Self do
  AValue.ToJsonObject(FieldValues);

 Current.AddPair('Values',FieldValues);
 Obj.AddElement(Current);
end;


function TDataSetRow.CreateDefaultJson: TJsonObject;
begin
if KeyField.IsEmpty or KeyFieldValue.IsEmpty then
 raise Exception.Create('Dataset error: Keyfield not properly set');

 Result:=TJsonObject.Create;
 Result.AddPair('KeyField',KeyField);
 Result.AddPair('KeyFieldValue',KeyFieldValue);
 Result.AddPair('UpdateRequest',RequestToStr(UpdateRequest));
end;

function TDataSetRow.FieldChanged(Field: TField): Boolean;
begin
 if (Field.DataType in [ftBlob, ftGraphic]) then
  Result:=True
   else
  Result:=Field.OldValue<>Field.Value;
end;

procedure TDataSetRow.LoadFromDataSet(DataSet: TDataSet);
var
 Field:TField;
 Values:TDataSetRowValue;
begin
 for Field in DataSet.Fields do
  if FieldChanged(Field) then
    begin
     Values:=TDataSetRowValue.Create;
     Add(Values);
     Values.FieldName:=Field.FieldName;
     if (Field.DataType in [ftBlob, ftGraphic]) then
//      raise Exception.Create('Updating blobs is not supported yet.');
      Values.Value:=TJsonDataConvert.BlobToBase64(Field as TBlobField)
       else
      Values.Value:=VarToStr(Field.Value)



    end;
end;


class function TDataSetRow.RequestToStr(Request: TFDUpdateRequest): string;
begin
 case Request of
   arInsert: Result:='Insert';
   arUpdate: Result:='Update';
   arDelete: Result:='Delete';
   arLock: Result:='Lock';
   arUnlock: Result:='Unlock';
   arFetchRow: Result:='FetchRow';
   arUpdateHBlobs: Result:='UpdateHBlobs';
   arDeleteAll: Result:='DeleteAll';
   arFetchGenerators: Result:='FetchGenerators';
    else
     Result:='Unknown';
 end;
end;

{ TFieldValues }

procedure TDataSetRowValue.ToJsonObject(Obj: TJsonObject);
begin
 if Value.Trim.IsEmpty then
  Obj.AddPair(FieldName,TJsonNull.Create)
   else
  Obj.AddPair(FieldName,TStringUtils.NullIfEmpty(Value))
end;

{ TRowUpdateList }

procedure TMiceApllyContent.ToJsonObject(jObject: TJsonObject);
var
 F:TDataSetRow;
 jArray:TJsonArray;
begin
 jArray:=TJsonArray.Create;
  for F in Self do
   F.ToJsonArray(jArray);

  jObject.AddPair('Rows',jArray);
end;

function TMiceApllyContent.ToJsonString: string;
var
 Obj:TJsonObject;
begin
Obj:=TJsonObject.Create;
  try
   Self.ToJsonObject(Obj);
   Result:=Obj.ToJSON;
  finally
    Obj.Free;
  end;
end;

procedure TMiceApllyContent.ToNewJsonObject(jOwner: TJsonObject);
var
 jApplyContent:TJsonObject;
begin
 jApplyContent:=TJsonObject.Create;
 ToJsonObject(jApplyContent);
 jOwner.AddPair('ApplyContext',jApplyContent)
end;


end.

