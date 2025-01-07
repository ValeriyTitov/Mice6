unit CustomControl.MiceDropDown.Builder;

interface
 uses
 DAC.XDataSet, DB, Classes, SysUtils, cxDBEdit, cxImageComboBox, Variants,
 Common.ResourceStrings,
 CustomControl.AppObject,
 CustomControl.MiceDropDown.ObjectModel;

 type
   TMiceDropDownBuilder=class
    public
  private
     FDataSet: TxDataSet;
     FItems: TcxImageComboBoxItems;
     procedure AddDropDownItem(const ImageIndex:Integer; const Description:string; const Value:Variant);
     procedure AddItem(Item:TDropDownItem);
     procedure LoadListItems(DropDownItems:TMiceDropDownItems); overload;
     procedure TryAddCommonItems(DropDownItems:TMiceDropDownItems);
     function GetDataSet: TxDataSet;
    public
     property DataSet:TxDataSet read GetDataSet;
     property Items:TcxImageComboBoxItems read FItems write FItems;
     procedure LoadFromJsonString(const Json:string);
     procedure LoadFromAppObject(AppObject:TMiceAppObject);
     procedure LoadFromDataSet(DataSet:TDataSet);
     procedure Build;
     constructor Create;
     destructor Destroy; override;
   end;

implementation

{ TDropDownFiller }

procedure TMiceDropDownBuilder.LoadListItems(DropDownItems: TMiceDropDownItems);
var
 Item: TDropDownItem;
begin
 TryAddCommonItems(DropDownItems);
 for Item in DropDownItems.Items do
  AddItem(Item);
end;

procedure TMiceDropDownBuilder.LoadFromAppObject(AppObject: TMiceAppObject);
begin
 if AppObject.Properties.ProviderName.Trim<>'' then
  begin
    if DataSet.ProviderName.IsEmpty then
     DataSet.ProviderName:=AppObject.Properties.ProviderName;
    if DataSet.DBName.IsEmpty then
     DataSet.DBName:=AppObject.Properties.DBName;
    TryAddCommonItems(AppObject.DropDownItems);
    Build;
  end
   else
    LoadListItems(AppObject.DropDownItems);
end;

procedure TMiceDropDownBuilder.LoadFromDataSet(DataSet: TDataSet);
var
 Item:TcxImageComboBoxItem;
 F1,F2,F3,F4:TField;
resourcestring
 S_DD_INVALID_FIELD_COUNT ='Dataset have invalid field count. At least 3 fields are required: "Value","Description","ImageIndex",["Tag"]';
begin
 if DataSet.FieldCount<2 then
  raise Exception.Create(S_DD_INVALID_FIELD_COUNT);

 F1:=DataSet.Fields[0];
 F2:=DataSet.Fields[1];
 F3:=DataSet.FindField('ImageIndex');
 F4:=DataSet.FindField('Tag');


 while not DataSet.Eof do
  begin
    Item:=Items.Add;
    Item.Value:=F1.Value;
    Item.Description:=F2.AsString;

    if Assigned(F3) then
     Item.ImageIndex:=F3.AsInteger
      else
     Item.ImageIndex:=0;

    if Assigned(F4) then
     Item.Tag:=F4.AsInteger;
    DataSet.Next;
  end;
end;


procedure TMiceDropDownBuilder.LoadFromJsonString(const Json: string);
var
 App:TMiceAppObject;
begin
 App:=TMiceAppObject.Create;
 try
   App.AsJson:=Json;
   LoadFromAppObject(App);
 finally
  App.Free;
 end;
end;

procedure TMiceDropDownBuilder.AddDropDownItem(const ImageIndex: Integer;  const Description: string; const Value: Variant);
var
 Item:TcxImageComboBoxItem;
begin
  Item:=Items.Add;
  Item.ImageIndex:=ImageIndex;
  Item.Value:=Value;
  Item.Description:=Description;
end;

procedure TMiceDropDownBuilder.AddItem(Item: TDropDownItem);
var
 AItem: TcxImageComboBoxItem;
begin
 AItem:=Items.Add;
 AItem.Value:=Item.Value;
 AItem.Description:=Item.Caption;
 AItem.ImageIndex:=Item.ImageIndex;
 AItem.Tag:=Item.Tag;
end;


constructor TMiceDropDownBuilder.Create;
begin

end;

destructor TMiceDropDownBuilder.Destroy;
begin
  FDataSet.Free;
  inherited;
end;

procedure TMiceDropDownBuilder.TryAddCommonItems(DropDownItems: TMiceDropDownItems);
begin
 if DropDownItems.AddAll then
  AddDropDownItem(0,S_COMMON_ALL_BRAKET,DropDownItems.AllValue);
 if DropDownItems.AddNone then
  AddDropDownItem(0,S_COMMON_NONE_BRAKET,DropDownItems.NoneValue);
end;

procedure TMiceDropDownBuilder.Build;
begin
 DataSet.DisableControls;
 DataSet.Open;
 LoadFromDataSet(DataSet);
end;

function TMiceDropDownBuilder.GetDataSet: TxDataSet;
begin
 if not Assigned(Self.FDataSet) then
  begin
   FDataSet:=TxDataSet.Create(nil);
   FDataSet.Source:='TDropDownFiller.GetDataSet';
  end;
  Result:=FDataSet;
end;

end.
