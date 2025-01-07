unit CustomControl.PluginTree;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Db, Variants, Vcl.ExtCtrls, cxClasses,
  CustomControl.TreeGrid,
  DAC.XDataSet, cxGraphics, cxControls, cxLookAndFeels, cxLookAndFeelPainters,
  cxCustomData, cxStyles, cxTL, cxTLdxBarBuiltInMenu, cxInplaceContainer,
  cxTLData, cxDBTL, cxMaskEdit, cxContainer, cxEdit, cxTextEdit,
  cxDataControllerConditionalFormattingRulesManagerDialog, Vcl.Menus,
  Common.Images,
  CustomControl.MiceTreeGrid.ColumnBuilder,
  CustomControl.HidingModalForm;

type
  TcxDBTreeList = class(TMiceTreeGrid)

  end;
  TPluginTree = class(THidingModalForm)
    MainPanel: TPanel;
    PluginTreeList: TcxDBTreeList;
    colName: TcxDBTreeListColumn;
    pnPath: TPanel;
    edPath: TcxTextEdit;
    PopupMenu: TPopupMenu;
    miRefresh: TMenuItem;
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure PluginTreeListFocusedNodeChanged(Sender: TcxCustomTreeList;
      APrevFocusedNode, AFocusedNode: TcxTreeListNode);
    procedure edPathKeyPress(Sender: TObject; var Key: Char);
    procedure PluginTreeListDblClick(Sender: TObject);
    procedure miRefreshClick(Sender: TObject);
  strict private
    FOnDblClick: TDataSetNotifyEvent;
    procedure UpdatePathText;
  protected
    procedure DoOnDblClick;
  public
    constructor Create(AOwner:TComponent);override;
    property OnDblClick:TDataSetNotifyEvent read FOnDblClick write FOnDblClick;
    procedure UpdateTree;
  end;

implementation

{$R *.DFM}


procedure TPluginTree.miRefreshClick(Sender: TObject);
begin
 UpdateTree;
end;

procedure TPluginTree.PluginTreeListDblClick(Sender: TObject);
begin
 DoOnDblClick;
// ShowMessage(PluginTreeList.DataSet.FieldByName('AppPluginsId').AsString);
end;

procedure TPluginTree.PluginTreeListFocusedNodeChanged(Sender: TcxCustomTreeList; APrevFocusedNode, AFocusedNode: TcxTreeListNode);
begin
 UpdatePathText;
end;


procedure TPluginTree.UpdatePathText;
begin
 edPath.Text:=Self.PluginTreeList.Path;
end;

procedure TPluginTree.UpdateTree;
begin
  PluginTreeList.DataSet.Close;
  PluginTreeList.DataSet.ProviderName:='spui_AppMainTreeMice';
  PluginTreeList.DataSet.Source:='CustomControl.PluginTree';
  PluginTreeList.DataSet.Open;
  PluginTreeLIst.ExpandByLevel(1);
//  PluginTreeList.DataSet.Locate('AppPluginsId',100058, []);
end;

constructor TPluginTree.Create(AOwner:TComponent);
begin
  inherited Create(AOwner);
  Self.LeftOffset:=8;
  Self.TopOffset:=90;
  PluginTreeList.PathColumn:=colName;
  TMiceTreeGridColumnBuilder.SetStyles(PluginTreeList);
end;

procedure TPluginTree.DoOnDblClick;
begin
 if Assigned(OnDblClick) and (PluginTreeList.DataSet.Active) and (not PluginTreeList.DataSet.FieldByName('AppPluginsId').IsNull) then
  try
   OnDblClick(PluginTreeList.DataSet);
  finally
   ModalResult:=mrOK;
 end;
end;

procedure TPluginTree.edPathKeyPress(Sender: TObject; var Key: Char);
begin
 if Key=#13 then
  begin
   Key:=#0;
   PluginTreeList.Path:=edPath.Text;
   ActiveControl:= PluginTreeList;
  end;
end;


procedure TPluginTree.FormKeyDown(Sender: TObject; var Key: Word;  Shift: TShiftState);
begin
 if (Key = VK_ESCAPE) or ((Key=Ord('F')) and (ssAlt in Shift)) then
  begin
    ModalResult := mrCancel;
    Key:=0;
  end
  else
  if Key = VK_RETURN then
   begin
    if (ActiveControl=PluginTreeList) and (PluginTreeList.DataSet.FieldByName('AppPluginsId').AsInteger>0) then
     begin
      ModalResult:=mrOK;
      OnDblClick(PluginTreeList.DataSet);
     end;
   end
end;


end.
