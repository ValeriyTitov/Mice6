unit CustomControl.AppObject;

interface

uses  Rest.JSON, System.JSON, System.Classes, System.SysUtils,
      System.Generics.Collections, System.Generics.Defaults,
      Data.DB,
      DAC.XDataSet,
      DAC.XParams,
      Common.JsonUtils,
      CustomControl.MiceDropDown.ObjectModel,
      CustomControl.AppObject.Properties,
      System.Variants;
type
 TMiceAppObject = class
  private
    FDropDownItems: TMiceDropDownItems;
    FParams: TxParams;
    FProperties: TAppObjectProperties;
    function GetAsJson: string;
    function NeedAddDropDownItems:Boolean;
    procedure SetAsJson(const Value: string);
    procedure InternalSaveDropDownItems(jOwner:TJsonObject);
    procedure InternalSaveParams(jOwner:TJsonObject);
    function GetDropDownItems: TMiceDropDownItems;
  public
    function IsEmpty:Boolean;
    procedure SaveToJsonObject(jOwner:TJsonObject);
    procedure LoadFromJsonObject(jOwner:TJsonObject);
    procedure WriteNullIfEmpty(Field:TField);
    procedure Clear;

    property DropDownItems:TMiceDropDownItems read GetDropDownItems;
    property Properties:TAppObjectProperties read FProperties;
    property Params:TxParams read FParams;


    property AsJson:string read GetAsJson write SetAsJson;

    constructor Create;
    destructor Destroy; override;

  end;

implementation

{ TMiceAppObject }

procedure TMiceAppObject.Clear;
begin
 Properties.Clear;
 if Assigned(FDropDownItems) then
  DropDownItems.Clear;
end;

constructor TMiceAppObject.Create;
begin
  FProperties:=TAppObjectProperties.Create;
  FParams:=TxParams.Create;
end;

destructor TMiceAppObject.Destroy;
begin
  FProperties.Free;
  FParams.Free;
  FDropDownItems.Free;
  inherited;
end;


procedure TMiceAppObject.LoadFromJsonObject(jOwner: TJsonObject);
var
 jDropDown:TJsonValue;
 jParams:TJsonValue;
begin
 Clear;
 jParams:=jOwner.Values['Params'];
  if Assigned(jParams) and (jParams is TJsonObject) then
   Params.FromJsonObject(jParams as TJsonObject);

 Properties.LoadFromParams(Params);

 jDropDown:=jOwner.Values['DropDown'];
  if Assigned(jDropDown) and (jDropDown is TJsonObject) then
   DropDownItems.LoadFromJsonObject(jDropDown as TJsonObject);
end;


procedure TMiceAppObject.InternalSaveDropDownItems(jOwner: TJsonObject);
var
 jItems:TJsonObject;
begin
 jItems:=TJsonObject.Create;
 DropDownItems.SaveToJsonObject(jItems);
 jOwner.AddPair('DropDown',jItems)
end;


procedure TMiceAppObject.InternalSaveParams(jOwner: TJsonObject);
var
 jParams:TJsonObject;
begin
 jParams:=TJsonObject.Create;
 Params.ToJsonObject(jParams);
 jOwner.AddPair('Params',jParams)
end;

function TMiceAppObject.NeedAddDropDownItems: Boolean;
begin
 Result:=(DropDownItems.Items.Count>0) or DropDownItems.AddNone or (DropDownItems.AddAll);
end;

procedure TMiceAppObject.SaveToJsonObject(jOwner: TJsonObject);
begin
 Properties.SaveToParams(Params);
 if Params.Count>0 then
  InternalSaveParams(jOwner);

 if NeedAddDropDownItems then
  InternalSaveDropDownItems(jOwner);
end;

procedure TMiceAppObject.SetAsJson(const Value: string);
var
 jObj:TJsonObject;
begin
if Value.Trim='' then
Clear
 else
   begin
    jObj:=TJSONObject.ParseJSONValue(Value) as TJsonObject;
     try
      LoadFromJsonObject(jObj);
     finally
      jObj.Free;
    end;
   end;
end;


procedure TMiceAppObject.WriteNullIfEmpty(Field: TField);
begin
 if IsEmpty then
  Field.Clear
   else
  Field.AsString:=AsJson;
end;

function TMiceAppObject.GetAsJson: string;
var
 jObj:TJsonObject;
begin
 jObj:=TJsonObject.Create;
 try
  SaveToJsonObject(jObj);
  Result:=TJsonUtils.Format(jObj);
 finally
  jObj.Free;
 end;
end;


function TMiceAppObject.GetDropDownItems: TMiceDropDownItems;
begin
 if not Assigned(FDropDownItems) then
   FDropDownItems:=TMiceDropDownItems.Create;
 Result:=FDropDownItems;
end;

function TMiceAppObject.IsEmpty: Boolean;
var
 jObject:TJsonObject;
begin
 jObject:=TJsonObject.Create;
 try
  SaveToJsonObject(jObject);
  Result:=jObject.Count<=0;
 finally
  jObject.Free;
 end;

end;

end.
