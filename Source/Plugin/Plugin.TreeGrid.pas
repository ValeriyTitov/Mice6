unit Plugin.TreeGrid;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics,  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Plugin.Base, Vcl.ComCtrls,
  Data.DB, cxGraphics, cxControls, cxLookAndFeels, cxLookAndFeelPainters,
  cxCustomData, cxStyles, cxTL, cxTLdxBarBuiltInMenu, cxInplaceContainer,
  cxTLData, cxDBTL,Vcl.ExtCtrls, cxMaskEdit, cxTextEdit,
  cxSplitter,
  Common.LookAndFeel,
  CustomControl.TreeGrid,
  CustomControl.MiceGrid.ColorBuilder,
  CustomControl.MiceTreeGrid.ColumnBuilder,
  Plugin.SideTreeFilter, cxDataControllerConditionalFormattingRulesManagerDialog;

type
  TcxDBTreeList = class(TMiceTreeGrid);

  TTreeGridPlugin = class(TBasePlugin)
    TreeGrid: TcxDBTreeList;
    procedure TreeGridFocusedNodeChanged(Sender: TcxCustomTreeList;  APrevFocusedNode, AFocusedNode: TcxTreeListNode);
    procedure TreeGridCustomDrawDataCell(Sender: TcxCustomTreeList;  ACanvas: TcxCanvas; AViewInfo: TcxTreeListEditCellViewInfo; var ADone: Boolean);
    procedure TreeGridDblClick(Sender: TObject);
  private
    FBuilder: TMiceTreeGridColumnBuilder;
    procedure CheckParentKeyField;
  protected
    procedure Build; override;
  public
    function SelectedCount:Integer;override;
    procedure ForEachSelectedRowDo(OnSelectedRow: TDataSetNotifyEvent); override;
    procedure RefreshDataSet; override;
    constructor Create(AOwner:TComponent); override;
    destructor Destroy; override;
  end;

implementation

{$R *.dfm}

{ TBasicTreeGridFrame }

procedure TTreeGridPlugin.Build;
begin
  inherited;
  CheckParentKeyField;
  TreeGrid.DataController.ParentField:=Self.Properties.ParentIdField;
  TreeGrid.DataController.ImageIndexField:=Self.Properties.ImageIndexField;
  FBuilder.LoadPluginColumns(Properties.AppPluginsId);
  TreeGrid.MiceGridColors.LoadForPlugin(Properties.AppPluginsId);
  TreeGrid.DataController.KeyField:=Properties.KeyField;
  TreeGrid.OptionsSelection.MultiSelect:=True;
  UpdateActionsActivity;
end;

procedure TTreeGridPlugin.CheckParentKeyField;
resourcestring
 S_PARENT_KEYFIELD_NOT_DEFINED = 'Parent key field not defined. TreeGrid requires Parent field';
begin
 if Properties.ParentIdField.Trim.IsEmpty then
  raise Exception.Create(S_PARENT_KEYFIELD_NOT_DEFINED);
end;

constructor TTreeGridPlugin.Create(AOwner: TComponent);
begin
  inherited;
  TreeGrid.DataSource.DataSet:=DataSet;
  FBuilder:=TMiceTreeGridColumnBuilder.Create(TreeGrid);
end;

destructor TTreeGridPlugin.Destroy;
begin
  FBuilder.Free;
  inherited;
end;

procedure TTreeGridPlugin.ForEachSelectedRowDo(OnSelectedRow: TDataSetNotifyEvent);
var
 x: integer;
 KeyValue:Variant;
 Col:TcxDBTreeListColumn;
begin
 Col:=TreeGrid.GetColumnByFieldName(Properties.KeyField);
 if not Assigned(OnSelectedRow) or not Assigned(Col) then
  Exit;

 AbortForEach:=False;
 try
  DataSet.DisableControls;
   for x:=0 to SelectedCount-1 do
    begin
     KeyValue:=TreeGrid.Selections[x].Values[Col.ItemIndex];
     if (DataSet.Locate(Properties.KeyField,KeyValue,[loCaseInsensitive]))  then
      OnSelectedRow(DataSet);
     if AbortForEach then
      Exit;
    end;
 finally
  DataSet.EnableControls;
 end;
end;

procedure TTreeGridPlugin.RefreshDataSet;
begin
  inherited;
  if Self.Properties.MissingItemsCreated=False then
   begin
     Self.Properties.MissingItemsCreated:=True;
     Self.FBuilder.CreateMissingColumns;
     Self.TreeGrid.MiceGridColors.MapTreeGridItems(TreeGrid);
   end;
end;



function TTreeGridPlugin.SelectedCount: Integer;
begin
 Result:=TreeGrid.SelectionCount;
end;

procedure TTreeGridPlugin.TreeGridCustomDrawDataCell(Sender: TcxCustomTreeList;  ACanvas: TcxCanvas; AViewInfo: TcxTreeListEditCellViewInfo; var ADone: Boolean);

begin
 ACanvas.Brush.Color:=clWindow;
 if Properties.StaleData then
  ACanvas.Brush.Color:=DefaultLookAndFeel.StaleDataCellColor;

 TreeGrid.MiceGridColors.DrawTreeColorCell(Sender,ACanvas,AViewInfo,ADone);
 TMiceGridColors.DefaultDrawTreeCell(Sender, ACanvas, AViewInfo,ADone);
end;

procedure TTreeGridPlugin.TreeGridDblClick(Sender: TObject);
begin
if (TreeGrid.SelectionCount>=1) and Assigned(Properties.DoubleClickAction) then
 Properties.DoubleClickAction.Execute;
end;

procedure TTreeGridPlugin.TreeGridFocusedNodeChanged(Sender: TcxCustomTreeList; APrevFocusedNode, AFocusedNode: TcxTreeListNode);
begin
 SelectionChanged(TreeGrid.SelectionCount);
end;

end.
