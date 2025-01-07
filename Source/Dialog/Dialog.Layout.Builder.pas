unit Dialog.Layout.Builder;

interface

uses
 System.SysUtils, System.Variants, System.Classes, cxControls, Data.DB,
  cxClasses, dxLayoutContainer, dxLayoutControl, Vcl.Controls, cxButtons,
  System.Generics.Collections, System.Generics.Defaults,
  cxContainer, dxLayoutcxEditAdapters, cxDbEdit,
  Dialog.Layout.ControlList,
  Mice.Script,
  DAC.XDataSet,
  DAC.DataSetList,
  Common.StringUtils,
  CustomControl.Interfaces,
  CustomControl.MiceLayout,
  CustomControl.MiceButton,
  CustomControl.MiceCheckBox,
  CustomControl.MiceRadioGroup;

type
 TLayoutType = (ltWork, ltDesigner);


 TDialogLayoutBuilder = class
 strict private
    FLayoutType: TLayoutType;
    FHasMissingItems: Boolean;
    FControlList:TList<TControl>;
    FLayoutItems: TDictionary<TControl, TdxLayoutItem>;
    FControlsOnLayout:TList<TControl>;
    FDependedControls:TList<TControl>;
    FAppDialogsLayoutId: Integer;
    FAppDialogsId: Integer;
    FLayout: TMiceLayoutControl;
    FCaptions: TList<string>;
    FOwnerDataSetList: TDataSetList;
    FOwnerDataSource: TDataSource;
    FScripter: TMiceScripter;
    FDataControlsList: TObjectDictionary<string, TList<TControl>>;
    FDataFields: TStringList;
    procedure RedirectClickToCheckBox(Sender:TObject);
    procedure TryLoadInitString(Control:TControl; const JsonString:string);
    procedure TryRegisterScript(Control:TControl);
    procedure TryRegisterDataBinding(Control:TControl; DataSet:TDataSet);
    procedure TryInitGrid(Control:TControl; DataSet:TDataSet);
    procedure TryRegisterDependencies(Control:TControl);
    procedure LoadDialogControls;
    procedure LoadControl(DataSet:TDataSet);
    procedure AssignControlsToLayout;
    procedure FindEmptyItems(List:TList<TdxLayoutItem>);
    procedure DataBind(const FieldName, ControlName:string; Binding:IHaveDataBinding);
    procedure SetControlForExistingItem(Item:TMiceLayoutItem;Control:TControl; const Caption:string);
    procedure SetDataControl(const DataField:string; Control:TControl);
    procedure SetItemCaption(Item:TMiceLayoutItem; const Caption:string);
    function DeleteEmptyItems:Boolean;
    function FindItem(const AName:string):TMiceLayoutItem;
    function CreateNewLayoutItemForControl(Control: TControl; const Name, Caption:string):TMiceLayoutItem;
 public
    constructor Create(ALayout:TMiceLayoutControl);
    destructor Destroy; override;
    property ControlList:TList<TControl> read FControlList;
    property ControlsOnLayout:TList<TControl> read FControlsOnLayout;
    property DataControlsList: TObjectDictionary<string, TList<TControl>> read  FDataControlsList;
    property AppDialogsId:Integer read FAppDialogsId write FAppDialogsId;
    property AppDialogsLayoutId:Integer read FAppDialogsLayoutId write FAppDialogsLayoutId;
    property Layout: TMiceLayoutControl read FLayout;
    property OwnerDataSource:TDataSource read FOwnerDataSource write FOwnerDataSource;
    property OwnerDataSetList:TDataSetList read FOwnerDataSetList write FOwnerDataSetList;
    property Scripter:TMiceScripter read FScripter write FScripter;
    property DataFields:TStringList read FDataFields;
    property HasMissingItems:Boolean read FHasMissingItems;
    property LayoutItems:TDictionary<TControl, TdxLayoutItem> read FLayoutItems;
    property LayoutType:TLayoutType read FLayoutType write FLayoutType;
    property DependedControls:TList<TControl> read FDependedControls;
    procedure Build;
    procedure FreeUnusedItems;
    function FindControl(const Name:string):TControl;
    class function FindDefaultDialogLayout(AppDialogsId:Integer):Integer;
    class function FindDocFlowLayout(AppDialogsId:Integer):Integer;
 end;

implementation


{ TDialogLayoutBuilder }

procedure TDialogLayoutBuilder.AssignControlsToLayout;
var
 x:Integer;
 Item:TMiceLayoutItem;
 Control:TControl;
 AName:string;
begin
for x:=0 to ControlList.Count-1 do
 begin
  Control:=ControlList[x];
  AName:='Item_'+Control.Name;
  Item:=FindItem(AName);
  if Assigned(Item) then
   SetControlForExistingItem(Item, Control, FCaptions[x])
    else
   Item:=CreateNewLayoutItemForControl(Control, AName, FCaptions[x]);
  Self.LayoutItems.Add(Control,Item);
 end;
end;

procedure TDialogLayoutBuilder.Build;
begin
 Layout.BeginUpdate;
  try
   LoadDialogControls;
   AssignControlsToLayout;
   FHasMissingItems:=DeleteEmptyItems;
  finally
   Layout.EndUpdate;
 end;
end;



constructor TDialogLayoutBuilder.Create(ALayout:TMiceLayoutControl);
begin
 FLayout:=ALayout;
 FControlList:=TList<TControl>.Create;
 FControlsOnLayout:=TList<TControl>.Create;
 FCaptions:=TList<string>.Create;
 FDataControlsList:=TObjectDictionary<string, TList<TControl>>.Create([doOwnsValues],TIStringComparer.Ordinal);
 FDataFields:=TStringList.Create;
 FLayoutItems:=TDictionary<TControl, TdxLayoutItem>.Create;
 FDependedControls:=TList<TControl>.Create;
end;





procedure TDialogLayoutBuilder.DataBind(const FieldName, ControlName: string;Binding: IHaveDataBinding);
var
 SourceName:string;
 DataField:string;
resourcestring
 S_CANNOT_FIND_PROPER_DATASOURCE_FMT = 'Cannot find datasource "%s" for control "%s"';
begin
 SourceName:=TStringUtils.LeftFromDot(FieldName,'');
 DataField:=TStringUtils.RightFromDot(FieldName,FieldName);
 Binding.IDataField:=DataField;

 if SourceName.IsEmpty then
  Binding.IDataSource:=OwnerDataSource
   else
  begin
   if OwnerDataSetList.ContainsKey(SourceName) then
    Binding.IDataSource:=OwnerDataSetList[SourceName]
     else
    raise Exception.CreateFmt(S_CANNOT_FIND_PROPER_DATASOURCE_FMT,[SourceName, ControlName]);
   end;
end;


function TDialogLayoutBuilder.DeleteEmptyItems: Boolean;
var
 List: TObjectList<TdxLayoutItem>;
begin
 List:=TObjectList<TdxLayoutItem>.Create(True);
 try
  FindEmptyItems(List);
  Result:=List.Count>0;
  if Result then
   List.Clear;
 finally
  List.Free;
 end;
end;


destructor TDialogLayoutBuilder.Destroy;
begin
  FDependedControls.Free;
  FControlList.Free;
  FControlsOnLayout.Free;
  FCaptions.Free;
  FDataControlsList.Free;
  FDataFields.Free;
  FLayoutItems.Free;
  inherited;
end;

function TDialogLayoutBuilder.FindControl(const Name: string): TControl;
var
 Control:TControl;
begin
 for Control in Self.ControlList do
  if Control.Name=Name then
   Exit(Control);
 Result:=nil;
end;

class function TDialogLayoutBuilder.FindDefaultDialogLayout(AppDialogsId: Integer): Integer;
begin
 raise Exception.Create('Not implemented');
end;


class function TDialogLayoutBuilder.FindDocFlowLayout(AppDialogsId: Integer): Integer;
begin
 raise Exception.Create('Not implemented');
end;

procedure TDialogLayoutBuilder.FindEmptyItems(List: TList<TdxLayoutItem>);
var
 x: Integer;
 Item:TdxLayoutItem;
begin
 for x:=0 to Layout.AbsoluteItemCount-1 do
  if (Layout.AbsoluteItems[x] is TdxLayoutItem) then
   begin
    Item:=Layout.AbsoluteItems[x] as TdxLayoutItem;
    if not Assigned(Item.Control) then
     List.Add(Item);
   end;
end;


function TDialogLayoutBuilder.FindItem(const AName: string): TMiceLayoutItem;
var
 C:TComponent;
begin
C:=Layout.Owner.FindComponent(AName);
 if Assigned(C) and (C is TMiceLayoutItem) then
  Result:=C as TMiceLayoutItem
   else
  Result:=nil;
end;


procedure TDialogLayoutBuilder.FreeUnusedItems;
var
 x:Integer;
begin
 for x:=Layout.Container.AvailableItemCount-1 downto 0 do
 if Layout.Container.AvailableItems[x] is TMiceLayoutItem then
  begin
   if Assigned((Layout.Container.AvailableItems[x] as TMiceLayoutItem).Control) then
    Layout.Container.AvailableItems[x].Free;
  end;
end;

procedure TDialogLayoutBuilder.LoadControl(DataSet: TDataSet);
var
 Item:TDialogLayoutControl;
 AClassName:string;
 AControl:TControl;
begin
 AClassName:=DataSet.FieldByName('ClassName').AsString;
 Item:=TDialogLayoutControlList.DefaultInstance[AClassName];
 AControl:=Item.ControlClass.Create(Layout);
 AControl.Name:=DataSet.FieldByName('ControlName').AsString;
 FCaptions.Add(DataSet.FieldByName('Caption').AsString);

 TryRegisterDataBinding(AControl, DataSet);
 TryLoadInitString(AControl, DataSet.FieldByName('InitString').AsString);
 TryInitGrid(AControl, DataSet);
 TryRegisterScript(AControl);


 ControlList.Add(AControl);
end;

procedure TDialogLayoutBuilder.LoadDialogControls;
var
 Tmp:TxDataSet;
begin
 Tmp:=TxDataSet.Create(nil);
 try
  Tmp.ProviderName:='spui_AppDialogControlList';
  Tmp.SetParameter('AppDialogsId',AppDialogsId);
  Tmp.Source:='TDialogLayoutBuilder.LoadDialogControls';
  Tmp.Open;
   while not Tmp.Eof do
    begin
     LoadControl(Tmp);
     Tmp.Next;
    end;
 finally
   Tmp.Free;
 end;
end;

procedure TDialogLayoutBuilder.RedirectClickToCheckBox(Sender: TObject);
var
 CheckBox:TMiceCheckBox;
begin
 CheckBox:=(Sender as TdxLayoutItem).Control as TMiceCheckBox;
 if (CheckBox.DataBinding.DataSource.DataSet as TxDataSet).ReadOnly=False then
  CheckBox.Checked:=not CheckBox.Checked;
end;

procedure TDialogLayoutBuilder.SetControlForExistingItem(Item:TMiceLayoutItem;Control:TControl; const Caption:string);
begin
 Item.Control:=Control;
 Item.ControlClassName:=Control.ClassName;
 Item.ControlName:=Control.Name;
 if Supports(Control,IHaveDataBinding) then
  Item.DataField:=(Control as IHaveDataBinding).IDataField;

 SetItemCaption(Item, Caption);
 ControlsOnLayout.Add(Control);
 TryRegisterDependencies(Control)
end;


function TDialogLayoutBuilder.CreateNewLayoutItemForControl(Control: TControl; const Name, Caption:string):TMiceLayoutItem;
begin
 Result:=Layout.Container.CreateItem(TMiceLayoutItem) as TMiceLayoutItem;
 Result.Control:=Control;
 if Supports(Control,IHaveDataBinding) then
  Result.DataField:=(Control as IHaveDataBinding).IDataField;
 Result.Name:=Name;
 Result.Caption:=Caption;
 Result.ControlClassName:=Control.ClassName;
 Result.ControlName:=Control.Name;
 Result.ShowCaption:=True;
 SetItemCaption(Result, Caption);
end;

procedure TDialogLayoutBuilder.SetItemCaption(Item: TMiceLayoutItem; const Caption: string);
begin
 if Item.Control is TMiceCheckBox then
  begin
   Item.OnCaptionClick:=RedirectClickToCheckBox;
   (Item.Control as TMiceCheckBox).Caption:=''
  end
  else
 if (Item.Control is TMiceButton) then
  (Item.Control as TMiceButton).Caption:=Caption
 else
 if (Item.Control is TMiceRadioGroup) then
  (Item.Control as TMiceRadioGroup).Caption:=Caption;
end;



procedure TDialogLayoutBuilder.SetDataControl(const DataField: string;  Control: TControl);
var
 List:TList<TControl>;
begin
 if not FDataControlsList.ContainsKey(DataField) then
  FDataControlsList.Add(DataField, TList<TControl>.Create);

  List:=FDataControlsList[DataField];

  if not List.Contains(Control) then
   List.Add(Control);
end;


procedure TDialogLayoutBuilder.TryInitGrid(Control: TControl; DataSet:TDataSet);
var
 Id:Integer;
 BuildIfDesigner:Boolean;
begin
 Id:=DataSet.FieldByName('AppDialogControlsId').AsInteger;
 BuildIfDesigner:=LayoutType=ltDesigner;
 if Supports(Control,IHaveColumns) then
  (Control as IHaveColumns).BuildColumns(Id,BuildIfDesigner);

 if Supports(Control,ICanHaveExternalDataSource) then
  (Control as ICanHaveExternalDataSource).SetDataSetList(OwnerDataSetList)

end;

procedure TDialogLayoutBuilder.TryLoadInitString(Control: TControl;  const JsonString: string);
begin
 if Supports(Control, ICanInitFromJson) then
  (Control as ICanInitFromJson).InitFromJson(JsonString);
end;

procedure TDialogLayoutBuilder.TryRegisterDataBinding(Control: TControl; DataSet: TDataSet);
var
 DataField:string;
begin
 DataField:=DataSet.FieldByName('DataField').AsString;
 if (not DataField.IsEmpty) and (DataFields.IndexOf(DataField)<0) then
  DataFields.Add(DataField);

 if Supports(Control,IHaveDataBinding) then
  begin
   SetDataControl(DataField, Control);
   (Control as IHaveDataBinding).AppDialogControlsId:=DataSet.FieldByName('AppDialogControlsId').AsInteger;
   if Assigned(OwnerDataSource) and Assigned(OwnerDataSetList) then
    DataBind(DataField, Control.Name, Control as IHaveDataBinding)
     else
   (Control as IHaveDataBinding).IDataField:=DataField; //Для манагера
  end;
end;

procedure TDialogLayoutBuilder.TryRegisterDependencies(Control: TControl);
begin
 if Supports(Control, IMayDependOnDialog) and (not DependedControls.Contains(Control)) then
  DependedControls.Add(Control);
end;

procedure TDialogLayoutBuilder.TryRegisterScript(Control: TControl);
begin
 if Supports(Control,IHaveScriptSupport) then
  (Control as IHaveScriptSupport).RegisterScripter(Scripter);
end;

end.
