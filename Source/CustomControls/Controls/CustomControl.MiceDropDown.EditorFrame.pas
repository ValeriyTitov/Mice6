unit CustomControl.MiceDropDown.EditorFrame;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  cxGraphics, cxControls,  cxLookAndFeels, cxLookAndFeelPainters, cxContainer, cxEdit,
  dxLayoutcxEditAdapters, dxLayoutContainer, cxCheckBox, cxTextEdit, cxClasses,
  dxLayoutControl, cxCustomData, cxStyles, cxTL, cxTLdxBarBuiltInMenu,
  cxInplaceContainer, cxMaskEdit, cxDropDownEdit, cxButtonEdit,Vcl.Menus, cxImageComboBox,
  System.JSON,
  Common.JsonUtils,
  Common.Images,
  Common.LookAndFeel,
  Common.ResourceStrings,
  Common.Images.SelectDialog,
  CustomControl.MiceAction,
  CustomControl.MiceActionList,
  StaticDialog.AppObjectSelector,
  CustomControl.AppObject,
  CustomControl.MiceDropDown.ObjectModel,
  cxDataControllerConditionalFormattingRulesManagerDialog, cxFilter,
  dxScrollbarAnnotations;

type
  TDropDownEditorFrame = class(TFrame)
    ddLayoutGroup_Root: TdxLayoutGroup;
    ddLayout: TdxLayoutControl;
    edAllValue: TcxTextEdit;
    item_edAllValue: TdxLayoutItem;
    edNoneValue: TcxTextEdit;
    item_edNoneValue: TdxLayoutItem;
    cbAddAll: TcxCheckBox;
    item_cbAddAll: TdxLayoutItem;
    cbAddNone: TcxCheckBox;
    item_cbAddNone: TdxLayoutItem;
    item_gridItems: TdxLayoutItem;
    gridItems: TcxTreeList;
    colImageIndex: TcxTreeListColumn;
    colValue: TcxTreeListColumn;
    colDescription: TcxTreeListColumn;
    colTag: TcxTreeListColumn;
    cbDBName: TcxComboBox;
    item_ddDBName: TdxLayoutItem;
    edDDProviderName: TcxButtonEdit;
    item_edDDProviderName: TdxLayoutItem;
    PopupMenu1: TPopupMenu;
    miAdd: TMenuItem;
    miDelete: TMenuItem;
    FrmGrpBottom: TdxLayoutGroup;
    dxLayoutAutoCreatedGroup1: TdxLayoutAutoCreatedGroup;
    dxLayoutAutoCreatedGroup3: TdxLayoutAutoCreatedGroup;
    dxLayoutAutoCreatedGroup4: TdxLayoutAutoCreatedGroup;
    gridItemsColumn5: TcxTreeListColumn;
    procedure cbAddAllClick(Sender: TObject);
    procedure cbAddNoneClick(Sender: TObject);
    procedure edDDProviderNamePropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
    procedure PopupMenu1Popup(Sender: TObject);
    procedure gridItemsColumn5PropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
  private
    FActionList:TMiceActionList;
    FDeleteAction:TMiceAction;
    procedure CreateActions;
    procedure LoadItems(MiceAppObject: TMiceAppObject);
    procedure SaveItems(MiceAppObject:TMiceAppObject);
    procedure AddGridItem(Item:TDropDownItem);
    procedure SetAsJson(const Value: string);
    procedure AddActionExecute(Sender:TObject);
    procedure DeleteActionExecute(Sender:TObject);
    procedure PopulateImages;
    function GetAsJson: string;
    procedure SetTargetDBName(const Value: string);
    function GetTargetDBName: string;
  public
    procedure LoadFromMiceAppObject(MiceAppObject:TMiceAppObject);
    procedure SaveToMiceMiceAppObject(MiceAppObject:TMiceAppObject);

    property AsJson:string read GetAsJson write SetAsJson;
    property TargetDBName:string read GetTargetDBName write SetTargetDBName;
    constructor Create(AOwner:TComponent);override;
    destructor Destroy; override;
  end;

implementation

{$R *.dfm}


procedure TDropDownEditorFrame.AddActionExecute(Sender: TObject);
var
  Node: TcxTreeListNode;
  AValue:Integer;
begin
 AValue:=Self.gridItems.Count+1;
 Node:=gridItems.Add;
 Node.Values[1]:=AValue;
 Node.Values[2]:=AValue;
 Node.Values[3]:='Caption'+AValue.ToString;
 Node.Values[4]:='0';
end;

procedure TDropDownEditorFrame.AddGridItem(Item: TDropDownItem);
var
  Node: TcxTreeListNode;
begin
 Node:=gridItems.Add;
 Node.Values[1]:=Item.ImageIndex;
 Node.Values[2]:=Item.Value;
 Node.Values[3]:=Item.Caption;
 Node.Values[4]:=Item.Tag;
end;

procedure TDropDownEditorFrame.cbAddAllClick(Sender: TObject);
begin
 edAllValue.Enabled:=cbAddAll.Checked;
end;

procedure TDropDownEditorFrame.cbAddNoneClick(Sender: TObject);
begin
 edNoneValue.Enabled:=cbAddNone.Checked;
end;

constructor TDropDownEditorFrame.Create(AOwner: TComponent);
begin
  inherited;
  Self.Color:=DefaultLookAndFeel.WindowColor;
  Self.ddLayout.LookAndFeel:=DefaultLookAndFeel.ManagerDialog;
  FActionList:=TMiceActionList.Create;
  CreateActions;
  PopulateImages;
end;

procedure TDropDownEditorFrame.CreateActions;
begin
 miAdd.Action:=FActionList.CreateAction('Add', S_COMMON_ADD,'',IMAGEINDEX_ACTION_ADD,True,AddActionExecute);
 FDeleteAction:=FActionList.CreateAction('Delete', S_COMMON_DELETE,'',IMAGEINDEX_ACTION_DELETE,False,DeleteActionExecute);
 miDelete.Action:=FDeleteAction;
end;

procedure TDropDownEditorFrame.DeleteActionExecute(Sender: TObject);
begin
  gridItems.DeleteSelection;
end;

destructor TDropDownEditorFrame.Destroy;
begin
 FActionList.Free;
 inherited;
end;

procedure TDropDownEditorFrame.edDDProviderNamePropertiesButtonClick(Sender: TObject; AButtonIndex: Integer);
var
 ID:Integer;
 s:string;
begin
 if TSysObjectSelectionDialog.ExecuteDialog(-2,ID,s, TargetDBName) then
      edDDProviderName.Text:=s;
end;

function TDropDownEditorFrame.GetAsJson: string;
var
 jObj:TJsonObject;
begin
 jObj:=TJsonObject.Create;
 try
  Result:=TJsonUtils.Format(jObj)
 finally
  jObj.Free;
 end;
end;

function TDropDownEditorFrame.GetTargetDBName: string;
begin
 Result:=cbDBName.Text;
end;

procedure TDropDownEditorFrame.gridItemsColumn5PropertiesButtonClick(Sender: TObject; AButtonIndex: Integer);
var
 ImageIndex:Integer;
begin
 if Assigned(gridItems.FocusedNode) then
  begin
   if VarIsNull(GridItems.FocusedNode.Values[1]) then
    ImageIndex:=0
     else
    ImageIndex:=GridItems.FocusedNode.Values[1];
   if TSelectImageDialog.Execute(ImageIndex) then
    GridItems.FocusedNode.Values[1]:=ImageIndex;
  end;
end;

procedure TDropDownEditorFrame.LoadFromMiceAppObject(MiceAppObject: TMiceAppObject);
begin
 cbAddAll.Checked:=MiceAppObject.DropDownItems.AddAll;
 cbAddNone.Checked:=MiceAppObject.DropDownItems.AddNone;
 edAllValue.Text:=VarToStr(MiceAppObject.DropDownItems.AllValue);
 edNoneValue.Text:=VarToStr(MiceAppObject.DropDownItems.NoneValue);
 cbDBName.Text:=MiceAppObject.Properties.DBName;
 edDDProviderName.Text:=MiceAppObject.Properties.ProviderName;
 gridItems.Clear;
 LoadItems(MiceAppObject);
end;

procedure TDropDownEditorFrame.LoadItems(MiceAppObject: TMiceAppObject);
var
 Item:TDropDownItem;
begin
 for Item in MiceAppObject.DropDownItems.Items do
   AddGridItem(Item);
end;

procedure TDropDownEditorFrame.PopulateImages;
begin
 ImageContainer.PopulateImages((colImageIndex.Properties as TcxCustomImageComboBoxProperties).Items);
end;

procedure TDropDownEditorFrame.PopupMenu1Popup(Sender: TObject);
begin
 FDeleteAction.Enabled:=Assigned(gridItems.FocusedNode);
end;


procedure TDropDownEditorFrame.SaveItems(MiceAppObject:TMiceAppObject);
var
 x:Integer;
 Node:TcxTreeListNode;
begin
 MiceAppObject.DropDownItems.Items.Clear;
 for x:=0 to gridItems.Count-1 do
  begin
   Node:=gridItems.Items[x];
   MiceAppObject.DropDownItems.AddItem(Node.Values[3],Node.Values[2],Node.Values[1],Node.Values[4]);
  end;
end;


procedure TDropDownEditorFrame.SaveToMiceMiceAppObject(MiceAppObject: TMiceAppObject);
begin
 MiceAppObject.DropDownItems.AllValue:=edAllValue.Text;
 MiceAppObject.DropDownItems.NoneValue:=edNoneValue.Text;
 MiceAppObject.DropDownItems.AddAll:=cbAddAll.Checked;
 MiceAppObject.DropDownItems.AddNone:=cbAddNone.Checked;
 MiceAppObject.Properties.ProviderName:=edDDProviderName.Text;
 MiceAppObject.Properties.DBName:=TargetDBName;
 SaveItems(MiceAppObject);
end;

procedure TDropDownEditorFrame.SetAsJson(const Value: string);
begin
end;


procedure TDropDownEditorFrame.SetTargetDBName(const Value: string);
begin
  cbDBName.Text:=Value;
end;


end.
