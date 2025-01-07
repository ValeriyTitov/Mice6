unit Dialog.Layout.CustomizationForm;

interface
{
   Этот файл надо проверять при обновлении DevExpress
}
uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, cxGraphics,
  cxControls, cxLookAndFeels, cxLookAndFeelPainters, Vcl.ComCtrls, Vcl.Menus,
  cxContainer, cxEdit, dxLayoutControlAdapters, dxLayoutContainer,
  dxLayoutcxEditAdapters, System.ImageList, Vcl.ImgList, System.Actions,
  Vcl.ActnList, cxClasses, cxCheckBox, Vcl.StdCtrls, cxButtons, cxTreeView,
  dxLayoutControl,  cxTextEdit,  cxImageList, dxTreeView,

  dxLayoutCustomizeForm, //Сначала надо открыть dxLayoutCustomizeForm, а потом уже Dialog.Layout.CustomizationForm
  Common.ResourceStrings,
  Common.Images,
  CustomControl.MiceLayout,
  Common.Images.SelectDialog,
  StaticDialog.MiceInputBox;

type
  TMiceLayoutEditForm = class(TdxLayoutControlCustomizeForm)
    lbClassName: TdxLayoutItem;
    dxLayoutGroup1: TdxLayoutGroup;
    edDatafield: TcxTextEdit;
    edDatafield_Item: TdxLayoutItem;
    edControlName: TcxTextEdit;
    edControlName_Item: TdxLayoutItem;
    Width1: TMenuItem;
    Changeheight1: TMenuItem;
    miImageIndex: TMenuItem;
    miRenameItem: TMenuItem;
    procedure FormShow(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure Width1Click(Sender: TObject);
    procedure Changeheight1Click(Sender: TObject);
    procedure miImageIndexClick(Sender: TObject);
    procedure pmTreeViewActionsPopup(Sender: TObject);
    procedure miRenameItemClick(Sender: TObject);
    procedure tvAvailableItemsFocusedNodeChanged(Sender: TObject);
  private
    procedure ShowNodeDetails(Node: TdxTreeViewNode);
    procedure ChangeSelectedItemWidth;
    procedure ChangeSelectedItemHeight;
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

procedure TMiceLayoutEditForm.Changeheight1Click(Sender: TObject);
begin
 ChangeSelectedItemHeight;
end;

procedure TMiceLayoutEditForm.ChangeSelectedItemHeight;
var
 Item:TdxCustomLayoutItem;
 AHeight:string;
begin
 if Assigned(tvVisibleItems.Selected) and (tvVisibleItems.Selected.Data<>nil) then
  begin
   Item:=TdxCustomLayoutItem(tvVisibleItems.Selected.Data);
   AHeight:=Item.Height.ToString;
    if TMiceInputBox.Execute(12,AHeight) then
     Item.Height:=AHeight.ToInteger;
  end;
end;

procedure TMiceLayoutEditForm.ChangeSelectedItemWidth;
var
 Item:TdxCustomLayoutItem;
 AWidth:string;
begin
 if Assigned(tvVisibleItems.Selected) and (tvVisibleItems.Selected.Data<>nil) then
  begin
   Item:=TdxCustomLayoutItem(tvVisibleItems.Selected.Data);
   AWidth:=Item.Width.ToString;
    if TMiceInputBox.Execute(12,AWidth) then
     Item.Width:=AWidth.ToInteger;
  end;
end;

procedure TMiceLayoutEditForm.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  inherited;
  CanClose:=False;
end;

procedure TMiceLayoutEditForm.FormShow(Sender: TObject);
begin
 Left:=(Screen.Width - Self.Width);
 Top:=50;
// Top:=(Screen.Height);// - (Height div 2);
end;

procedure TMiceLayoutEditForm.miImageIndexClick(Sender: TObject);
var
 Item:TdxCustomLayoutItem;
 Group:TdxLayoutGroup;
 AImageIndex:Integer;
 LayouItem:TMiceLayoutItem;
begin
 if Assigned(tvVisibleItems.Selected) and (tvVisibleItems.Selected.Data<>nil) then
  begin
   Item:=TdxCustomLayoutItem(tvVisibleItems.Selected.Data);
    if Item is TdxLayoutGroup  then
     begin
      Group:=Item as TdxLayoutGroup;
      AImageIndex:=Group.CaptionOptions.ImageIndex;
      if TSelectImageDialog.ExecuteWithClear(AImageIndex) then
       Group.CaptionOptions.ImageIndex:=AImageIndex
     end
     else
     if Item is TdxLayoutItem  then
     begin
      LayouItem:=Item as TMiceLayoutItem;
      AImageIndex:=LayouItem.CaptionOptions.ImageIndex;
      if TSelectImageDialog.ExecuteWithClear(AImageIndex) then
       LayouItem.CaptionOptions.ImageIndex:=AImageIndex
     end;
  end;
end;

procedure TMiceLayoutEditForm.miRenameItemClick(Sender: TObject);
var
 Item:TdxCustomLayoutItem;
 ANewName:string;
begin
 if Assigned(tvVisibleItems.Selected) and (tvVisibleItems.Selected.Data<>nil) then
  begin
   Item:=TdxCustomLayoutItem(tvVisibleItems.Selected.Data);
   ANewName:=Item.Name;
    if TMiceInputBox.Execute(12,ANewName) then
     begin
      Item.Name:=ANewName;
      edControlName.Text:=ANewName;
     end;
  end;
end;


procedure TMiceLayoutEditForm.pmTreeViewActionsPopup(Sender: TObject);
var
 Item:TdxCustomLayoutItem;
begin
 inherited;
// miImageIndex.Enabled:=False;
 miRenameItem.Enabled:=False;
 if Assigned(tvVisibleItems.Selected) and (tvVisibleItems.Selected.Data<>nil) then
  begin
   Item:=TdxCustomLayoutItem(tvVisibleItems.Selected.Data);
   if Item is TdxLayoutGroup  then
    begin
//     miImageIndex.Enabled:=True;
     miRenameItem.Enabled:=True;
    end;
  end;
end;

procedure TMiceLayoutEditForm.ShowNodeDetails(Node: TdxTreeViewNode);
var
 Item:TdxCustomLayoutItem;
 MiceItem:TMiceLayoutItem;
resourcestring
 S_ITEM_CLASSNAME_FMT='Class: %s';
begin
 if Assigned(Node) and (Node.Data<>nil) then
  begin
   Item:=TdxCustomLayoutItem(Node.Data);
   if Item is TMiceLayoutItem then
    begin
      MiceItem:=Item as TMiceLayoutItem;
      lbClassName.Caption:=string.Format(S_ITEM_CLASSNAME_FMT, [MiceItem.ControlClassName]);
      edDatafield.Text:=MiceItem.DataField;
      edControlName.Text:=MiceItem.ControlName;
    end
     else
      begin
      lbClassName.Caption:=string.Format(S_ITEM_CLASSNAME_FMT, [Item.ClassName]);
      edDataField.Text:=S_COMMON_NONE_BRAKET;
      edControlName.Text:=Item.Name;
      end;
  end;

end;

procedure TMiceLayoutEditForm.tvAvailableItemsFocusedNodeChanged(  Sender: TObject);
var
 AControl:TdxTreeViewControl;
begin
  inherited;
  AControl:=Sender as TdxTreeViewControl;
  ShowNodeDetails(AControl.FocusedNode);
end;

procedure TMiceLayoutEditForm.Width1Click(Sender: TObject);
begin
 ChangeSelectedItemWidth;
end;

end.
