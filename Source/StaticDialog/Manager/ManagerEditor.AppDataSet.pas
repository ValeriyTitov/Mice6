unit ManagerEditor.AppDataSet;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, ManagerEditor.Common, cxGraphics,
  cxLookAndFeels, cxLookAndFeelPainters, Vcl.Menus, cxControls, Data.DB,
  cxClasses, dxLayoutContainer, dxLayoutControl, Vcl.StdCtrls, cxButtons,
  Vcl.ExtCtrls, cxStyles, cxCustomData, cxFilter, cxData,
  cxDataStorage, cxEdit, cxNavigator, cxDBData, cxGridLevel, cxGridCustomView,
  cxGridCustomTableView, cxGridTableView, cxGridDBTableView, cxGrid,
  dxLayoutControlAdapters,  dxLayoutcxEditAdapters, cxContainer, cxMemo, cxDBEdit,
  cxTextEdit, cxMaskEdit, cxDropDownEdit, System.Generics.Defaults, System.Generics.Collections,
  Common.Images,
  Manager.WindowManager,
  DAC.XDataSet,
  CustomControl.MiceGrid.ColorBuilder,
  DAC.DatabaseUtils, cxDataControllerConditionalFormattingRulesManagerDialog,
  dxDateRanges, Vcl.Buttons, dxScrollbarAnnotations, Vcl.DBCtrls,
  CustomControl.MiceSyntaxEdit, Vcl.StdActns, System.Actions, Vcl.ActnList,
  Vcl.PlatformDefaultStyleActnCtrls, Vcl.ActnMan;

type
  TDBMemo = class(TMiceSyntaxEdit)

  end;

  TManagerDialogAppDataSet = class(TCommonManagerDialog)
    TableGridView: TcxGridDBTableView;
    TableGridLevel1: TcxGridLevel;
    TableGrid: TcxGrid;
    item_TableGrid: TdxLayoutItem;
    dsGrid: TDataSource;
    item_TopGroup: TdxLayoutGroup;
    cbTableName: TcxDBComboBox;
    item_cbTableName: TdxLayoutItem;
    memoDescription: TcxDBMemo;
    item_memoDescription: TdxLayoutItem;
    cbDBName: TcxDBComboBox;
    item_cbDBName: TdxLayoutItem;
    PopupMenu1: TPopupMenu;
    miDelete: TMenuItem;
    miClone: TMenuItem;
    dxLayoutAutoCreatedGroup1: TdxLayoutAutoCreatedGroup;
    miAdd: TMenuItem;
    memoProviderName: TDBMemo;
    item_ProviderName: TdxLayoutItem;
    ActionManager1: TActionManager;
    EditCut1: TEditCut;
    EditCopy1: TEditCopy;
    EditPaste1: TEditPaste;
    EditDelete1: TEditDelete;
    EditSelectAll1: TEditSelectAll;
    PopupMenu2: TPopupMenu;
    Copy1: TMenuItem;
    Copy2: TMenuItem;
    Delete1: TMenuItem;
    Paste1: TMenuItem;
    SelectAll1: TMenuItem;
    procedure miDeleteClick(Sender: TObject);
    procedure miCloneClick(Sender: TObject);
    procedure PopupMenu1Popup(Sender: TObject);
    procedure cbDBNameExit(Sender: TObject);
    procedure TableGridViewCustomDrawCell(Sender: TcxCustomGridTableView;
      ACanvas: TcxCanvas; AViewInfo: TcxGridTableDataCellViewInfo;
      var ADone: Boolean);
    procedure miAddClick(Sender: TObject);
    procedure cbTableNamePropertiesChange(Sender: TObject);
  private
    FGridDataSet:TxDataSet;
  protected
    procedure UpdateColumnWidth;
    procedure PopulateTables;
    procedure OpenAppTable(TopRows:Integer);
    procedure SetRenameLayout;
    procedure SetEditingLayout;
    procedure EnterInsertingState; override;
  public
    constructor Create(AOwner:TComponent); override;
    procedure Initialize; override;
    procedure SaveChanges; override;
    class function ExecuteRenameDialog(ID, AppMainTreeId:Integer; var AName:string):Boolean;
  end;

implementation

const
 TOP_ROWS_COUNT = 1000;
 F_DEFAULT_APP_TABLE_STATEMENT = 'SELECT TOP (%d) * FROM [%s] WITH (NOLOCK)';
{$R *.dfm}
{ TManagerDialogAppDataSet }

procedure TManagerDialogAppDataSet.cbDBNameExit(Sender: TObject);
begin
 PopulateTables;
end;

procedure TManagerDialogAppDataSet.cbTableNamePropertiesChange(Sender: TObject);
var
 s:string;
begin
 if Self.DataSet.State in [dsInsert,dsEdit] then
  begin
   FGridDataSet.TableName:=Self.cbTableName.Text;
   s:=Format(F_DEFAULT_APP_TABLE_STATEMENT,[TOP_ROWS_COUNT, FGridDataSet.TableName]);
   DataSet.FieldByName('ProviderName').AsString:=s;
  end;
end;

constructor TManagerDialogAppDataSet.Create(AOwner: TComponent);
begin
  inherited;
  TableName:='AppDataSets';
  KeyField:='AppDataSetsID';
  iType:=iTypeAppDataSet;
  FGridDataSet:=TxDataSet.Create(Self);
  dsGrid.DataSet:=FGridDataSet;
  AppMainTreeDescriptionField:='TableName';
  ImageIndex:=86;
  memoProviderName.Syntax:='SQL';
end;

procedure TManagerDialogAppDataSet.EnterInsertingState;
begin
  inherited;
  DataSet.FieldByName('AppDataSetsId').AsInteger:=TDataBaseUtils.NewAppObjectId(sq_AppDataSets);
end;

class function TManagerDialogAppDataSet.ExecuteRenameDialog(ID, AppMainTreeId: Integer; var AName:string): Boolean;
var
 Dlg:TManagerDialogAppDataSet;
begin
 Dlg:=TManagerDialogAppDataSet.Create(nil);
 try
  Dlg.ID:=ID;
  Dlg.AppMainTreeId:=AppMainTreeId;
  Dlg.SetParameter('Editing',True);
  Dlg.bnOK.OnClick:=nil;
  Dlg.bnOK.ModalResult:=mrOK;
  Dlg.bnCancel.ModalResult:=mrCancel;
  Result:=Dlg.Execute;
  if Result then
   begin
    Dlg.SaveChanges;
    AName:=Dlg.DataSet.FieldByName('TableName').AsString;
   end;
 finally
  Dlg.Free;
 end;

end;

procedure TManagerDialogAppDataSet.Initialize;
begin
  inherited;
  if Assigned(Params.FindParam('Editing')) or (ID<0) then
   SetRenameLayout
    else
   SetEditingLayout;
end;


procedure TManagerDialogAppDataSet.miDeleteClick(Sender: TObject);
begin
 FGridDataSet.Delete;
end;

procedure TManagerDialogAppDataSet.miAddClick(Sender: TObject);
begin
 FGridDataSet.Append;
end;

procedure TManagerDialogAppDataSet.miCloneClick(Sender: TObject);
begin
 TxDataSet.CloneRow(FGridDataSet);
end;

procedure TManagerDialogAppDataSet.OpenAppTable(TopRows:Integer);

resourcestring
 S_EDIT_APP_DATASET_CAPTION = 'Edit Dataset (%s)';
begin
  FGridDataSet.Source:='TManagerDialogAppDataSet.TableGrid';
  FGridDataSet.TableName:=DataSet.FieldByName('TableName').AsString;
  FGridDataSet.DBName:=DataSet.FieldByName('DBName').AsString;
  FGridDataSet.ProviderName:=Self.DataSet.FieldByName('ProviderName').AsString;

  Caption:=string.Format(S_EDIT_APP_DATASET_CAPTION,[FGridDataSet.TableName]);
  FGridDataSet.Open;
end;

procedure TManagerDialogAppDataSet.PopulateTables;
begin
 cbTableName.Properties.Items.Clear;
 TDataBaseUtils.GetTableList(cbDBName.Text, cbTableName.Properties.Items);
end;

procedure TManagerDialogAppDataSet.PopupMenu1Popup(Sender: TObject);
var
 AEnabled:Boolean;
begin
  inherited;
  AEnabled:=Assigned(TableGridView.Controller.FocusedRow);
  miDelete.Enabled:=AEnabled;
  miClone.Enabled:=AEnabled;
end;

procedure TManagerDialogAppDataSet.SaveChanges;
begin
  OpenAppTable(TOP_ROWS_COUNT);
  FGridDataSet.ApplyUpdatesIfChanged;
  inherited;
end;

procedure TManagerDialogAppDataSet.SetEditingLayout;
begin
  item_TopGroup.Visible:=False;
  OpenAppTable(TOP_ROWS_COUNT);
  TableGridView.DataController.CreateAllItems(True);
  UpdateColumnWidth;
end;

procedure TManagerDialogAppDataSet.SetRenameLayout;
begin
 item_TableGrid.Visible:=False;
 Constraints.MinHeight:=200;
 Constraints.MinWidth:=300;
 Height:=480;
 Width:=600;
 PopulateTables;
end;

procedure TManagerDialogAppDataSet.TableGridViewCustomDrawCell(
  Sender: TcxCustomGridTableView; ACanvas: TcxCanvas;
  AViewInfo: TcxGridTableDataCellViewInfo; var ADone: Boolean);
begin
 TMiceGridColors.DefaultDrawGridCell(Sender, ACanvas, AViewInfo, ADone);
end;

procedure TManagerDialogAppDataSet.UpdateColumnWidth;
var
 x:Integer;
 Column:TcxGridDBColumn;
begin
 for x:=0 to TableGridView.ColumnCount-1 do
  begin
    Column:=TableGridView.Columns[x];
{    if Assigned(Column.DataBinding.Field) and (Column.DataBinding.Field.DataType=ftBoolean) then
    Column.Width:=20
     else}
    Column.Width:=90;
  end;

  TableGridView.OptionsView.ColumnAutoWidth:=TableGridView.ColumnCount<16;
end;

initialization
  TWindowManager.RegisterEditor(iTypeAppDataSet,nil,TManagerDialogAppDataSet, False);
finalization


end.
