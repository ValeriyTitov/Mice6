unit AppTemplate.FileImport.Json;

interface
uses
 System.Classes, System.SysUtils, System.Variants,
 Common.JsonUtils,
 Common.ResourceStrings,
 AppTemplate.FileImport,
 System.Json,
 Data.DB,
 System.IOUtils;

type
 TJsonTemplateImport = class(TAbstractTemplateImport)
   private
    FTotalArrays:Integer;
    FTotalObjects:Integer;
    procedure ImportJsonSingleItem(const ParentId:Variant;jValue:TJsonValue; AJsonType:Integer);
    procedure ImportJsonObject(const ParentId:Variant; jObject:TJsonObject; CreateItem:Boolean);
    procedure ImportJsonArray(const ParentId:Variant;jArray:TJsonArray; CreateItem:Boolean);
    procedure ImportJsonValue(const ParentId:Variant;jValue:TJsonValue);
    procedure ImportJsonPair(const ParentId: Variant; jPair: TJsonPair);
    function FindJsonType(AValue:TJSONValue):Integer;
   public
    procedure Import; override;
   end;

implementation

resourcestring
 S_NEW_JSON_ARRAY_ITEM_FMT = 'ArrayItem=%d';
 S_NEW_JSON_OBJECT_ITEM_FMT = 'Object=%d';

 S_NEW_JSON_ARRAY = 'Array';
 S_NEW_JSON_OBJECT = 'Object';


procedure TJsonTemplateImport.ImportJsonArray(const ParentId:Variant; jArray: TJsonArray; CreateItem:Boolean);
var
 jValue:TJsonValue;
 ID:Variant;
 TagDesc:string;
begin
 Inc(FTotalArrays);
 if CreateItem then
  begin
   ID:=NewID;
   TagDesc:=Format(S_NEW_JSON_OBJECT_ITEM_FMT,[FTotalArrays]);
   CreateNewItem(ID, ParentId,TagTypeJsonItem, S_NEW_JSON_ARRAY, '', ValueTypeJsonArray);
  end
   else
   ID:=ParentId;
  for jValue in jArray do
   ImportJsonValue(ID, jValue);
end;


procedure TJsonTemplateImport.ImportJsonPair(const ParentId:Variant;jPair: TJsonPair);
var
 AJsonType:Integer;
 NewParentId:Integer;
begin
 AJsonType:=FindJsonType(jPair.JsonValue);
 if (AJsonType=ValueTypeJsonArray) or (AJsonType=ValueTypeJsonObject) then
  begin
   NewParentId:=NewID;
   CreateNewItem(NewParentId, ParentId,TagTypeNameValue,jPair.JsonString.Value, jPair.JsonValue.Value,AJsonType);
  end
   else
    NewParentId:=ParentId;

  case AJsonType of
   ValueTypeJsonArray:  ImportJsonArray(NewParentId, jPair.JsonValue as TJsonArray, False);
   ValueTypeJsonObject: ImportJsonObject(NewParentId, jPair.JsonValue as TJsonObject, False);
   else
    CreateNewItem(NewID, NewParentId,TagTypeNameValue,jPair.JsonString.Value, jPair.JsonValue.Value,AJsonType);
  end;
end;


procedure TJsonTemplateImport.ImportJsonSingleItem(const ParentId: Variant; jValue: TJsonValue;AJsonType:Integer);
var
 ID:Integer;
begin
 ID:=NewID;
 CreateNewItem(ID, ParentId,TagTypeJsonItem,jValue.Value,jValue.Value, AJsonType);
end;

procedure TJsonTemplateImport.ImportJsonObject(const ParentId:Variant;jObject: TJsonObject; CreateItem:Boolean);
var
 jPair:TJsonPair;
 TagDesc:string;
 ID:Integer;
begin
 Inc(FTotalObjects);
 if CreateItem then
  begin
   ID:=NewId;
   TagDesc:=Format(S_NEW_JSON_OBJECT_ITEM_FMT,[FTotalObjects]);
   CreateNewItem(ID, ParentId,TagTypeJsonItem, S_NEW_JSON_OBJECT, '',  ValueTypeJsonObject);
  end
   else
   ID:=ParentID;

 for jPair in jObject do
  ImportJsonPair(ID,jPair);
end;

procedure TJsonTemplateImport.ImportJsonValue(const ParentId:Variant;jValue: TJsonValue);
var
 AJsonType:Integer;
begin
 AJsonType:=FindJsonType(jValue);
 case AJsonType of
  ValueTypeJsonObject: ImportJsonObject(ParentId, jValue as TJsonObject,True);
  ValueTypeJsonArray: ImportJsonArray(ParentId, jValue as TJsonArray,True);
   else
  ImportJsonSingleItem(ParentId,jValue, AJsonType);
 end;
end;

function TJsonTemplateImport.FindJsonType(AValue: TJSONValue): Integer;
begin
 if (AValue is TJsonNumber) then
  Result:=ValueTypeJsonNumber
   else
 if (AValue is TJsonString) then
  Result:=ValueTypeJsonString
   else
 if (AValue is TJSONBool) then
  Result:=ValueTypeJsonBool
   else
 if (AValue is TJsonNull) then
  Result:=ValueTypeJsonNull
   else
 if (AValue is TJsonArray) then
  Result:=ValueTypeJsonArray
   else
 if (AValue is TJsonObject) then
  Result:=ValueTypeJsonObject
   else
  Result:=ValueTypeJsonString;
end;

procedure TJsonTemplateImport.Import;
var
 jValue:TJsonValue;
begin
 FTotalArrays:=0;
 FTotalObjects:=0;
 jValue:=TJsonUtils.TryCreateJson(TFile.ReadAllText(FileName));
 try
  ImportJsonValue(RootParentId, jValue);
 finally
  jValue.Free;
 end;
end;

end.
