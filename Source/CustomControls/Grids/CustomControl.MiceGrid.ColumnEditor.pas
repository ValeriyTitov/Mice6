unit CustomControl.MiceGrid.ColumnEditor;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, cxStyles, cxCustomData, cxFilter,
  cxData, cxDataStorage, cxEdit, cxNavigator, Data.DB, cxDBData, cxGridLevel,
  cxClasses, cxGridCustomView, cxGridCustomTableView, cxGridTableView,
  cxGridDBTableView, cxGrid, cxGridBandedTableView,
  CustomControl.MiceGrid, cxGridDBBandedTableView, cxButtonEdit,
  cxDropDownEdit, cxCheckBox, cxImageComboBox, Vcl.Menus,
  DAC.XDataSet,
  DAC.DatabaseUtils,
  DAC.Provider.Columns.Finder,
  CustomControl.MiceActionList,
  CustomControl.MiceAction,
  StaticDialog.AppObjectSelector,
  Common.Images,
  Common.ResourceStrings,
  CustomControl.Interfaces,
  CustomControl.MiceGrid.ColumnEditor.ColumnDialog,
  CustomControl.MiceGrid.ColumnEditor.BandDialog,
  CustomControl.MiceGrid.ColumnEditor.AutoFill,
  dxDateRanges, dxScrollbarAnnotations;

type
  TcxGrid = class (TMiceGrid)

  end;

  TColumnEditorFrame = class(TFrame, IAmLazyControl)
    gridColumnsLevel1: TcxGridLevel;
    gridColumns: TcxGrid;
    MainView: TcxGridDBBandedTableView;
    colFieldName: TcxGridDBBandedColumn;
    colOrderId: TcxGridDBBandedColumn;
    colCaption: TcxGridDBBandedColumn;
    colWidth: TcxGridDBBandedColumn;
    colVisible: TcxGridDBBandedColumn;
    colSizing: TcxGridDBBandedColumn;
    colFilter: TcxGridDBBandedColumn;
    colAlign: TcxGridDBBandedColumn;
    colHdr: TcxGridDBBandedColumn;
    PopupMenu: TPopupMenu;
    miNew: TMenuItem;
    miDelete: TMenuItem;
    colMore: TcxGridDBBandedColumn;
    miAutoFill: TMenuItem;
    miCopyFromPlugin: TMenuItem;
    miCopyFromGrid: TMenuItem;
    miClear: TMenuItem;
    N1: TMenuItem;
    miRearrage: TMenuItem;
    procedure MainViewCustomDrawCell(Sender: TcxCustomGridTableView;
      ACanvas: TcxCanvas; AViewInfo: TcxGridTableDataCellViewInfo;
      var ADone: Boolean);
    procedure colMorePropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
    procedure MainViewFocusedItemChanged(Sender: TcxCustomGridTableView;
      APrevFocusedItem, AFocusedItem: TcxCustomGridTableItem);
    procedure miCopyFromPluginClick(Sender: TObject);
    procedure miCopyFromGridClick(Sender: TObject);
    procedure OnClearActionExecute(Sender: TObject);
  strict private
    FDefaultReadOnlyState: Boolean;
    FProviderName: string;
    FDBName: string;
    FAutoFilling:Boolean;
    FActionList:TMiceActionList;
    procedure SetDataSource(const Value: TDataSource);
    function GetDataSource: TDataSource;
    procedure InitializeColumn(DataSet:TDataSet);
    procedure OnNewColumnActionExecute(Sender:TObject);
    procedure OnDeleteColumnExecute(Sender:TObject);
    procedure OnAutoFillActionExecute(Sender:TObject);
    procedure OnReArrageActionExecute(Sender:TObject);
    procedure FindProviderFields;
    procedure FindFieldCaption;
    procedure RefreshDataSet;
    function DataAvaible:Boolean;
  private
    procedure LoadFromDataSet(DataSet:TDataSet);
    procedure LoadPluginColumns(AppPluginsId:Integer);
    procedure LoadControlColumns(AppDialogControlsId:Integer);
  public
    property ProviderName:string read FProviderName write FProviderName;
    property DBName:string read FDBName write FDBName;
    procedure LazyInit(ParentObject: IInheritableAppObject);
    property DataSource:TDataSource read GetDataSource write SetDataSource;
    property DefaultReadOnlyState:Boolean read FDefaultReadOnlyState write FDefaultReadOnlyState;
    constructor Create(AOwner:TComponent); override;
    destructor Destroy; override;
  end;

implementation

resourcestring
  S_CREATE_NEW_COLUMN = 'Create new column';
  S_PROVIDERNAME_IS_EMPTY = 'Providername is empty';
{$R *.dfm}

{ TColumnEditorFrame }

procedure TColumnEditorFrame.OnClearActionExecute(Sender: TObject);
var
 DataSet:TDataSet;
begin
 DataSet:=DataSource.DataSet;
 DataSet.First;
 while not DataSet.Eof do
    DataSet.Delete;
end;

procedure TColumnEditorFrame.colMorePropertiesButtonClick(Sender: TObject;  AButtonIndex: Integer);
var
 DataSet:TDataSet;
begin
 DataSet:=DataSource.DataSet;
 if DataSet.State in [dsInsert, dsEdit] then
  DataSet.Post;

 if DataSet.FieldByName('IsBand').AsBoolean=True then
  begin
   If TBandPropetiesDlg.ClassExecute(DataSource.DataSet) and (DataSet.State in [dsInsert, dsEdit]) then
    DataSource.DataSet.Post
     else
    DataSource.DataSet.Cancel;
  end
   else
  begin
   If TColumnPropetiesDlg.ClassExecute(DataSource.DataSet) and (DataSet.State in [dsInsert, dsEdit]) then
    DataSource.DataSet.Post
     else
    DataSource.DataSet.Cancel;
  end;
end;



procedure TColumnEditorFrame.LoadControlColumns(AppDialogControlsId: Integer);
var
 Tmp:TxDataSet;
begin
 Tmp:=TxDataSet.Create(nil);
 try
   Tmp.ProviderName:='spui_AppGetDialogGridColumns';
   Tmp.SetParameter('AppDialogControlsId',AppDialogControlsId);
   Tmp.Source:='TMiceGridColumnBuilder.LoadGridColumns';
   Tmp.Open;
   Self.LoadFromDataSet(Tmp);
 finally
   Tmp.Free;
 end;
end;


procedure TColumnEditorFrame.LoadPluginColumns(AppPluginsId: Integer);
var
 Tmp:TxDataSet;
begin
 Tmp:=TxDataSet.Create(nil);
 try
   Tmp.ProviderName:='spui_AppGetPluginColumns';
   Tmp.SetParameter('AppPluginsId',AppPluginsId);
   Tmp.Source:='TMiceGridColumnBuilder.LoadPluginColumns';
   Tmp.Open;
   LoadFromDataSet(Tmp);
 finally
   Tmp.Free;
 end;
end;

procedure TColumnEditorFrame.LoadFromDataSet(DataSet: TDataSet);
var
 Dest:TxDataSet;
begin
 Dest:=DataSource.DataSet as TxDataSet;
 DataSet.First;
 while not DataSet.Eof do
  begin
   Dest.Append;
   Dest.CopyRecord(DataSet);
   DataSet.Next;
  end;
end;


constructor TColumnEditorFrame.Create(AOwner: TComponent);
var
 Action:TMiceAction;
begin
  inherited;
  FAutoFilling:=False;
  FDefaultReadOnlyState:=True;
  FActionList:=TMiceActionList.Create;
  Action:=FActionList.CreateAction('DeleteColumn',S_COMMON_DELETE,S_COMMON_DELETE_RECORD,IMAGEINDEX_ACTION_DELETE,False,OnDeleteColumnExecute);
  Action.ActivityCondition.EnabledWhenNoRecords:=False;
  miDelete.Action:=Action;
  Action:=FActionList.CreateAction('NewColumn',S_COMMON_ADD,S_CREATE_NEW_COLUMN,IMAGEINDEX_ACTION_NEW,True,OnNewColumnActionExecute);
  Action.ActivityCondition.AlwaysEnabled:=True;
  miNew.Action:=Action;
  Action:=FActionList.CreateAction('AutoFill',S_COMMON_AUTOFILL,'',431,True,OnAutoFillActionExecute);
  Action.ActivityCondition.AlwaysEnabled:=True;
  miAutoFill.Action:=Action;

  Action:=FActionList.CreateAction('ReArrage',S_COMMON_REARRAGE,'',342,False,OnReArrageActionExecute);
  Action.ActivityCondition.AlwaysEnabled:=False;
  Action.ActivityCondition.EnabledWhenNoRecords:=False;
  miRearrage.Action:=Action;

  Action:=FActionList.CreateAction('Clear',S_COMMON_CLEAR,S_COMMON_CLEAR_ALL_RECORDS,IMAGEINDEX_ACTION_CLEAR,False,OnClearActionExecute);
  Action.ActivityCondition.AlwaysEnabled:=False;
  Action.ActivityCondition.EnabledWhenNoRecords:=False;
  miClear.Action:=Action;
end;


function TColumnEditorFrame.DataAvaible: Boolean;
begin
 Result:=Assigned(DataSource) and Assigned(DataSource.DataSet);
end;

destructor TColumnEditorFrame.Destroy;
begin
  FActionList.Free;
  inherited;
end;

procedure TColumnEditorFrame.FindFieldCaption;
var
 List:TStrings;
 AFieldName:string;
begin
 List:=(colCaption.Properties as TcxComboBoxProperties).Items;
 if DataAvaible then
  begin
   AFieldName:=DataSource.DataSet.FieldByName('FieldName').AsString;
   List.Clear;
   TDataBaseUtils.FindCommonCaptionList(AFieldName,List);
   List.Add(AFieldName);
  end;
end;

procedure TColumnEditorFrame.FindProviderFields;
var
 List:TStrings;
begin
 List:=(colFieldName.Properties as TcxComboBoxProperties).Items;
 if (ProviderName<>'') and (List.Count=0) then
   TProviderColumnsFinder.ToList(List, Self.ProviderName, Self.DBName);
end;

function TColumnEditorFrame.GetDataSource: TDataSource;
begin
 Result:=MainView.DataController.DataSource;
end;

procedure TColumnEditorFrame.InitializeColumn(DataSet: TDataSet);
begin
 if not FAutoFilling then
  TMiceGridAutoFiller.CreateDefaultColumn(DataSet,nil, True);
end;

procedure TColumnEditorFrame.LazyInit(ParentObject: IInheritableAppObject);
begin
 if DataAvaible then
   DataSource.DataSet.Open;
// FindProviderFields;
end;

procedure TColumnEditorFrame.MainViewCustomDrawCell(
  Sender: TcxCustomGridTableView; ACanvas: TcxCanvas;
  AViewInfo: TcxGridTableDataCellViewInfo; var ADone: Boolean);
begin
  ACanvas.Brush.Color:=clWindow;

   if AViewInfo.GridRecord.Selected then
    begin
      ACanvas.Font.Color:=clBlack;
      ACanvas.Brush.Color:=$E5E5E5;
    end;


    if AViewInfo.GridRecord.Values[colHdr.Index]=True then
    begin
      ACanvas.Font.Color:=clBlack;
      ACanvas.Brush.Color:=clYellow;
    end;

    if AViewInfo.GridRecord.Values[colVisible.Index]=False then
     ACanvas.Font.Color:=clSilver;

    if AViewInfo.Focused and AViewInfo.GridRecord.Focused then
     ACanvas.Brush.Color:=clSilver; ;
end;

procedure TColumnEditorFrame.MainViewFocusedItemChanged(
  Sender: TcxCustomGridTableView; APrevFocusedItem,
  AFocusedItem: TcxCustomGridTableItem);
begin
 if AFocusedItem=colFieldName then
  FindProviderFields else
 if AFocusedItem=colCaption then
  FindFieldCaption;
end;

procedure TColumnEditorFrame.miCopyFromGridClick(Sender: TObject);
var
 Id:integer;
 s:string;
const
 iTypeControlColumns  =-6;
begin
 if TAppObjectSelectionDialog.ExecuteDialog(iTypeControlColumns,Id,s) then
  Self.LoadControlColumns(Id);
end;

procedure TColumnEditorFrame.miCopyFromPluginClick(Sender: TObject);
var
 Id:integer;
 s:string;
const
 iTypePluginColumms=-5;
begin
 if TAppObjectSelectionDialog.ExecuteDialog(iTypePluginColumms,Id,s) then
  Self.LoadPluginColumns(Id)
end;

procedure TColumnEditorFrame.OnAutoFillActionExecute(Sender: TObject);
begin
if ProviderName.IsEmpty then
 MessageBox(Handle,PChar(S_PROVIDERNAME_IS_EMPTY),PChar(S_COMMON_INFORMATION),MB_OK+ MB_ICONINFORMATION)
  else
  begin
   Self.MainView.BeginUpdate;
   TMiceGridAutoFiller.AutoFill(DataSource.DataSet as TxDataSet, Self.ProviderName, Self.DBName, DefaultReadOnlyState);
   DataSource.DataSet.First;
   Self.MainView.EndUpdate;
  end;
// ShowMessage(DataSource.DataSet.RecordCount.ToString);
end;


procedure TColumnEditorFrame.OnDeleteColumnExecute(Sender: TObject);
begin
 DataSource.DataSet.Delete;
end;

procedure TColumnEditorFrame.OnNewColumnActionExecute(Sender: TObject);
begin
 if DataAvaible then
  DataSource.DataSet.Append;
end;

procedure TColumnEditorFrame.OnReArrageActionExecute(Sender: TObject);
var
 DataSet:TDataSet;
 x:Integer;
 AValue:Variant;
begin
 DataSet:=DataSource.DataSet;
 try
   DataSet.DisableControls;
   MainView.BeginUpdate;
   DataSet.First;

   for x:=0 to MainView.ViewData.RowCount-1 do
    begin
     AValue:=MainView.ViewData.Rows[x].Values[0];
     DataSet.Locate('CreateOrder', AValue,[] );
     DataSet.Edit;
     DataSet.FieldByName('CreateOrder').AsInteger:=(x+1)*10;
     DataSet.Post;
    end;
 finally
  DataSet.EnableControls;
  MainView.EndUpdate;
 end;
end;

procedure TColumnEditorFrame.RefreshDataSet;
begin

end;

procedure TColumnEditorFrame.SetDataSource(const Value: TDataSource);
begin
 MainView.DataController.DataSource:=Value;
 FActionList.DataSource:=Value;
 if Assigned(Value) and Assigned(Value.DataSet) then
  Value.DataSet.AfterInsert:=InitializeColumn;
end;

end.
