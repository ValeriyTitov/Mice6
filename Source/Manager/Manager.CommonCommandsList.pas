unit Manager.CommonCommandsList;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, cxStyles, cxCustomData, cxFilter,
  cxData, cxDataStorage, cxEdit, cxNavigator, cxDBData, dxBar, cxGridLevel,
  cxClasses, cxGridCustomView, cxGridCustomTableView, cxGridTableView,
  cxGridDBTableView, cxGrid,
  Common.Images,
  Common.ResourceStrings,
  CustomControl.MiceAction,
  CustomControl.MiceActionList,

  DAC.XDataSet, cxImageComboBox,
  cxDataControllerConditionalFormattingRulesManagerDialog;

type
  TCommonCommands = class(TForm)
    DataSource: TDataSource;
    gridCommandsDBTableView1: TcxGridDBTableView;
    gridCommandsLevel1: TcxGridLevel;
    gridCommands: TcxGrid;
    dxBarManager: TdxBarManager;
    dxBarManagerBar1: TdxBar;
    bnNewCommand: TdxBarButton;
    bnEdit: TdxBarButton;
    bnDelete: TdxBarButton;
    bnRefresh: TdxBarButton;
    bnActivity: TdxBarButton;
    dxBarPopupMenu: TdxBarPopupMenu;
    colAppCmdId: TcxGridDBColumn;
    colType: TcxGridDBColumn;
    colCaption: TcxGridDBColumn;
    colName: TcxGridDBColumn;
    colLocation: TcxGridDBColumn;
    colAction: TcxGridDBColumn;
    colImageIndex: TcxGridDBColumn;
    colActive: TcxGridDBColumn;
    bnNewItem: TdxBarSubItem;
    bnNewFilter: TdxBarButton;
    procedure bnRefreshClick(Sender: TObject);
    procedure gridCommandsDBTableView1CustomDrawCell(
      Sender: TcxCustomGridTableView; ACanvas: TcxCanvas;
      AViewInfo: TcxGridTableDataCellViewInfo; var ADone: Boolean);
    procedure gridCommandsDBTableView1DblClick(Sender: TObject);

  private
    FDataSet:TxDataSet;
    FActions:TMiceActionList;
    procedure DeleteAppCmdActionExecute(Sender:TObject);
    procedure ChangeActivityCmdActionExecute(Sender:TObject);
  public
    constructor Create(AOwner:TComponent); override;
    destructor Destroy; override;
    procedure Initialize;
    procedure DeleteAppCmdDlg(AppCmdId:Integer);
    procedure ChangeActivity(AppCmdId:Integer; Active:Boolean);
    procedure Requery(Sender:TObject);
  end;

implementation

{$R *.dfm}

{ TCommonCommands }

procedure TCommonCommands.bnRefreshClick(Sender: TObject);
begin
 Requery(Sender);
end;

procedure TCommonCommands.ChangeActivity(AppCmdId: Integer; Active: Boolean);
var
 DataSet:TxDataSet;
begin
 DataSet:=TxDataSet.Create(nil);
 try
  DataSet.ProviderName:='spui_AppChangeAppCmdActivity';
  DataSet.SetParameter('AppCmdId',AppCmdId);
  DataSet.SetParameter('Active',Active);
  DataSet.Execute;
  Requery(nil);
 finally
  DataSet.Free;
 end;
end;

procedure TCommonCommands.ChangeActivityCmdActionExecute(Sender: TObject);
begin
 ChangeActivity(FDataSet.FieldByName('AppCmdId').AsInteger, not FDataSet.FieldByName('Active').AsBoolean);
end;

constructor TCommonCommands.Create(AOwner: TComponent);
begin
  inherited;
  FDataSet:=TxDataSet.Create(Self);
  FDataSet.ProviderName:='spui_AppCommonCommandsList';
  DataSource.DataSet:=FDataSet;
  FActions:=TMiceActionList.Create;
  FActions.DataSource:=DataSource;
  bnDelete.Action:=FActions.CreateAction('Delete',S_COMMON_DELETE,'',IMAGEINDEX_ACTION_DELETE,False,DeleteAppCmdActionExecute,'AppCmdId is not null');
  bnActivity.Action:=FActions.CreateAction('Activity','Activity','',124,False,ChangeActivityCmdActionExecute,'AppCmdId is not null');
  bnEdit.Action:=FActions.CreateAction('Edit',S_COMMON_EDIT,'',IMAGEINDEX_ACTION_EDIT,False,nil,'AppCmdId is not null');
//  bnNewCommand.Action:=FActions.CreateAction('New',S_COMMON_NEW,'',IMAGEINDEX_ACTION_NEW,False,nil,'');
end;

procedure TCommonCommands.DeleteAppCmdActionExecute(Sender: TObject);
begin
 if MessageBox(Handle,PChar(S_COMMON_DELETE_RECORD),PChar(S_COMMON_DELETE_RECORD_CONFIRMATION),MB_YESNO+MB_ICONQUESTION)=ID_YES then
  DeleteAppCmdDlg(FDataSet.FieldByName('AppCmdId').AsInteger);
end;

procedure TCommonCommands.DeleteAppCmdDlg(AppCmdId: Integer);
var
 DataSet:TxDataSet;
begin
 DataSet:=TxDataSet.Create(nil);
 try
  DataSet.ProviderName:='spui_AppDeleteAppCmd';
  DataSet.SetParameter('AppCmdId',AppCmdId);
  DataSet.Execute;
  Requery(nil);
 finally
  DataSet.Free;
 end;
end;

destructor TCommonCommands.Destroy;
begin
  FActions.Free;
  inherited;
end;

procedure TCommonCommands.gridCommandsDBTableView1CustomDrawCell(
  Sender: TcxCustomGridTableView; ACanvas: TcxCanvas;
  AViewInfo: TcxGridTableDataCellViewInfo; var ADone: Boolean);
begin
  ACanvas.Brush.Color:=clWindow;

   if AViewInfo.GridRecord.Selected then
    begin
      ACanvas.Font.Color:=clBlack;
      ACanvas.Brush.Color:=$E5E5E5;
    end;

    if AViewInfo.GridRecord.Values[colActive.Index]=True then
      ACanvas.Font.Color:=clBlack
       else
      ACanvas.Font.Color:=clGray;

   if AViewInfo.Focused and AViewInfo.GridRecord.Focused then
      ACanvas.Brush.Color:=clSilver;

end;

procedure TCommonCommands.gridCommandsDBTableView1DblClick(Sender: TObject);
begin
 if Assigned(gridCommandsDBTableView1.Controller.FocusedRecord) then
  bnEdit.Action.Execute;
end;

procedure TCommonCommands.Initialize;
begin
 gridCommandsDBTableView1.BeginUpdate;
 ImageContainer.PopulateImages((colImageIndex.Properties as TcxCustomImageComboBoxProperties).Items);
 gridCommandsDBTableView1.EndUpdate;

 FDataSet.Open;

end;

procedure TCommonCommands.Requery(Sender:TObject);
begin
 FDataSet.ReQuery;
 FActions.RefreshActions;
end;

end.
