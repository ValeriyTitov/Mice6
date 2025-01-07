unit CustomControl.MiceDropDown.ObjectModel;

interface
 uses Rest.JSON, System.JSON, System.Classes, System.SysUtils,
      System.Generics.Collections, System.Generics.Defaults,
      DAC.XDataSet,
      Common.JsonUtils,
      System.Variants;

type
 TDropDownItem  = class
  strict private
    FCaption: string;
    FTag: Integer;
    FValue: Variant;
    FImageIndex: Integer;
  public
    property ImageIndex:Integer read FImageIndex write FImageIndex;
    property Value:Variant read FValue write FValue;
    property Caption:string read FCaption write FCaption;
    property Tag:Integer read FTag write FTag;
    procedure ToJsonArray(AJson:TJsonArray);
    procedure FromJsonObject(AJson:TJsonObject);
    constructor Create(AJson:TJsonObject); overload;
    constructor Create; overload;
 end;

 TMiceDropDownItems = class
  private
    FItems: TObjectList<TDropDownItem>;
    FAllValue: Variant;
    FNoneValue: Variant;
    FAddAll: Boolean;
    FAddNone: Boolean;
    procedure InternalAddItems(jOwner:TJsonObject);
    procedure InternalAddAll(jOwner:TJsonObject);
    procedure InternalAddNone(jOwner:TJsonObject);
  protected
    procedure LoadItems(AJson:TJsonArray);
  public
    property Items: TObjectList<TDropDownItem> read FItems;
    property AddNone:Boolean read FAddNone write FAddNone;
    property AddAll:Boolean read FAddAll write FAddAll;
    property NoneValue:Variant read FNoneValue write FNoneValue;
    property AllValue:Variant read FAllValue write FAllValue;
    constructor Create;
    destructor Destroy; override;
    procedure SaveToJsonObject(jOwner:TJsonObject);
    procedure LoadFromJsonObject(jOwner:TJsonObject);
    procedure Clear;
    procedure AddItem(const Caption:string; const Value:Variant; ImageIndex, Tag:Integer);
 end;

implementation

{ TAppObjectModel }

procedure TMiceDropDownItems.AddItem(const Caption: string; const Value: Variant;  ImageIndex, Tag: Integer);
var
 Item:TDropDownItem;
begin
 Item:=TDropDownItem.Create;
 Item.Caption:=Caption;
 Item.Value:=Value;
 Item.ImageIndex:=ImageIndex;
 Item.Tag:=Tag;
 FItems.Add(Item);
end;

procedure TMiceDropDownItems.Clear;
begin
 Self.Items.Clear;
 Self.AllValue:=NULL;
 Self.NoneValue:=NULL;
 Self.AddNone:=False;
 Self.AddAll:=False;
end;

constructor TMiceDropDownItems.Create;
begin
 FItems:=TObjectList<TDropDownItem>.Create;
end;

destructor TMiceDropDownItems.Destroy;
begin
  FItems.Free;
  inherited;
end;


procedure TMiceDropDownItems.LoadFromJsonObject(jOwner: TJsonObject);
var
 jItems:TJsonValue;
begin
 AllValue:=TJsonUtils.FindValueDef(jOwner,'AllValue',NULL);
 NoneValue:=TJsonUtils.FindValueDef(jOwner,'NoneValue',NULL);
 AddNone:=jOwner.GetValue<Boolean>('AddNone',False);
 AddAll:=jOwner.GetValue<Boolean>('AddAll',False);

 jItems:=jOwner.Values['Items'];
 if Assigned(jItems) and (jItems is TJsonArray) then
  LoadItems(jItems as TJsonArray);
end;



procedure TMiceDropDownItems.InternalAddAll(jOwner: TJsonObject);
begin
 jOwner.AddPair('AddAll',TJsonBool.Create(AddAll));
 jOwner.AddPair('AllValue',TJsonUtils.VariantToJson(AllValue));
end;

procedure TMiceDropDownItems.InternalAddItems(jOwner: TJsonObject);
var
 Item:TDropDownItem;
 jItems:TJsonArray;
begin
 jItems:=TJsonArray.Create;
 for Item in FItems do
   Item.ToJsonArray(jItems);
 jOwner.AddPair('Items',jItems);
end;

procedure TMiceDropDownItems.InternalAddNone(jOwner: TJsonObject);
begin
 jOwner.AddPair('AddNone',TJsonBool.Create(AddNone));
 jOwner.AddPair('NoneValue',TJsonUtils.VariantToJson(NoneValue));
end;

procedure TMiceDropDownItems.LoadItems(AJson: TJsonArray);
var
 jItem:TJsonObject;
 x:Integer;
 Item:TDropDownItem;
begin
 for x:=0 to AJson.Count-1 do
  begin
   jItem:=AJson.Items[x] as TJsonObject;
   Item:=TDropDownItem.Create(jItem);
   Items.Add(Item);
  end;
end;


procedure TMiceDropDownItems.SaveToJsonObject(jOwner: TJsonObject);
begin
 if AddNone then
  InternalAddNone(jOwner);

 if AddAll then
  InternalAddAll(jOwner);

 if Items.Count>0 then
  InternalAddItems(jOwner);
end;


{ TDropDownItem }


constructor TDropDownItem.Create(AJson: TJsonObject);
begin
 inherited Create;
 FromJsonObject(AJson);
end;

constructor TDropDownItem.Create;
begin
 inherited Create;
end;

procedure TDropDownItem.FromJsonObject(AJson: TJsonObject);
begin
 Caption:=AJson.GetValue<string>('Caption','');
 Value:=TJsonUtils.FindValueDef(AJson,'Value',NULL);
 ImageIndex:=AJson.GetValue<Integer>('ImageIndex',0);
 Tag:=AJson.GetValue<Integer>('Tag',0);
end;

procedure TDropDownItem.ToJsonArray(AJson: TJsonArray);
var
 jItem:TJsonObject;
begin
 jItem:=TJsonObject.Create;
 jItem.AddPair('Caption',Caption);
 jItem.AddPair('Value',VarToStr(Value));
 jItem.AddPair('ImageIndex',TJsonNumber.Create(ImageIndex));
 jItem.AddPair('Tag',TJsonNumber.Create(Tag));
 AJson.Add(jItem);
end;


end.
