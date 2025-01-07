unit ManagerEditor.dfPathFolder.RulesFrame;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, cxGraphics, cxControls,
  Data.DB, Vcl.StdCtrls, cxLookAndFeels, cxLookAndFeelPainters,
  cxStyles, cxCustomData, cxFilter, cxData, cxDataStorage, cxEdit, cxNavigator,
  dxDateRanges, cxDBData, cxTextEdit, cxClasses, cxGridLevel, cxGridCustomTableView,
  cxGridTableView, cxGridBandedTableView, cxGridDBBandedTableView,
  cxGridCustomView, cxGrid,  Vcl.Menus, cxButtonEdit,
  CustomControl.MiceActionList,
  CustomControl.MiceAction,
  Common.Images,
  Common.ResourceStrings,
  Common.VariantUtils,
  CustomControl.MiceGrid.ColorBuilder,
  CustomControl.Interfaces,
  DAC.DatabaseUtils, cxCheckBox,
  ManagerEditor.dfPathFolder.RulesFrame.Dialog;

type
  TdfPathFoldersIncomingRulesFrame = class(TFrame, IAmLazyControl)
    GridRules: TcxGrid;
    MainView: TcxGridDBBandedTableView;
    colOrderId: TcxGridDBBandedColumn;
    colCaption: TcxGridDBBandedColumn;
    GridRulesLevel1: TcxGridLevel;
    PopupMenu: TPopupMenu;
    miNew: TMenuItem;
    miDelete: TMenuItem;
    miEdit: TMenuItem;
    miActivity: TMenuItem;
    colActive: TcxGridDBBandedColumn;
    procedure MainViewCustomDrawCell(Sender: TcxCustomGridTableView;
      ACanvas: TcxCanvas; AViewInfo: TcxGridTableDataCellViewInfo;
      var ADone: Boolean);
    procedure MainViewDblClick(Sender: TObject);
  private
    FActionList:TMiceActionList;
    FDataSet:TDataSet;
    FDBName: string;
    function GetDataSource: TDataSource;
    procedure SetDataSource(const Value: TDataSource);
    procedure OnDeleteColumnExecute(Sender:TObject);
    procedure OnNewExecute(Sender:TObject);
    procedure OnEditExecute(Sender:TObject);
    procedure OnChangeActivityExecute(Sender:TObject);
    procedure RefreshDataSet;
  public
    function DataAvaible:Boolean;
    procedure LazyInit(ParentObject: IInheritableAppObject);
    property DBName:string read FDBName write FDBName;
    property DataSource:TDataSource read GetDataSource write SetDataSource;
    constructor Create(AOwner:TComponent); override;
    destructor Destroy; override;
  end;

implementation

{$R *.dfm}

{ TdfPathFoldersIncomingRulesFrame }

constructor TdfPathFoldersIncomingRulesFrame.Create(AOwner: TComponent);
const
 AKeyField = '';
begin
  inherited;
  FActionList:=TMiceActionList.Create;

  miDelete.Action:=FActionList.CreateDeleteAction(AKeyField,OnDeleteColumnExecute);
  miEdit.Action:=FActionList.CreateEditAction(AKeyField,OnEditExecute);
  miNew.Action:=FActionList.CreateNewAction(OnNewExecute);
  miActivity.Action:=FActionList.CreateChangeActivityAction(AKeyField,OnChangeActivityExecute);
end;

function TdfPathFoldersIncomingRulesFrame.DataAvaible: Boolean;
begin
 Result:=Assigned(DataSource) and Assigned(DataSource.DataSet);
end;

destructor TdfPathFoldersIncomingRulesFrame.Destroy;
begin
  FActionList.Free;
  inherited;
end;

function TdfPathFoldersIncomingRulesFrame.GetDataSource: TDataSource;
begin
   Result:=MainView.DataController.DataSource;
end;

procedure TdfPathFoldersIncomingRulesFrame.LazyInit( ParentObject: IInheritableAppObject);
begin
  if DataAvaible then
    DataSource.DataSet.Open;
end;

procedure TdfPathFoldersIncomingRulesFrame.MainViewCustomDrawCell(Sender: TcxCustomGridTableView; ACanvas: TcxCanvas;  AViewInfo: TcxGridTableDataCellViewInfo; var ADone: Boolean);
begin
 TMiceGridColors.DefaultDrawGridCell(Sender,ACanvas,AViewInfo,ADone);
 if AViewInfo.GridRecord.Values[colActive.Index]=False then
  ACanvas.Font.Color:=clSilver;
end;


procedure TdfPathFoldersIncomingRulesFrame.MainViewDblClick(Sender: TObject);
begin
 if MainView.Controller.SelectedRowCount>0 then
  TPathFolderRuleDialog.ExecuteDialog(Self.MainView.DataController.DataSource.DataSet,'Table1','KeyField');
end;

procedure TdfPathFoldersIncomingRulesFrame.OnNewExecute(Sender: TObject);
resourcestring
 S_NEW_RULE_CAPTION_FMT = 'New rule %d';
 S_NEW_RULE_MESSAGE = 'Invalid value for field';
const
  iTypeDfRule  = 24;
begin
 FDataSet.Append;
 FDataSet.FieldByName('dfPathFolderRulesId').AsInteger:=TDataBaseUtils.NewAppObjectId(sq_dfPathFolderRules);
 FDataSet.FieldByName('Caption').AsString:=Format(S_NEW_RULE_CAPTION_FMT,[FDataSet.RecordCount+1]);
 FDataSet.FieldByName('UserMessage').AsString:=S_NEW_RULE_MESSAGE;
 FDataSet.FieldByName('Expression').AsString:='(1=2)';
 FDataSet.FieldByName('OrderId').AsInteger:=(FDataSet.RecordCount+1)*10;
 FDataSet.FieldByName('Active').AsBoolean:=True;
 FDataSet.FieldByName('VisibleToUser').AsBoolean:=True;
 FDataSet.Post;
end;

procedure TdfPathFoldersIncomingRulesFrame.RefreshDataSet;
begin

end;

procedure TdfPathFoldersIncomingRulesFrame.OnChangeActivityExecute(Sender: TObject);
begin
 FDataSet.Edit;
 FDataSet.FieldByName('Active').AsBoolean:=not FDataSet.FieldByName('Active').AsBoolean;
end;

procedure TdfPathFoldersIncomingRulesFrame.OnDeleteColumnExecute(Sender: TObject);
begin
if MessageBox(Handle,PChar(S_COMMON_DELETE_ITEM_CONFIRMATION),PChar(S_COMMON_DELETE_RECORD_CAPTION),MB_YESNO+MB_ICONQUESTION)=ID_YES then
 FDataSet.Delete;
end;

procedure TdfPathFoldersIncomingRulesFrame.OnEditExecute(Sender: TObject);
begin

end;

procedure TdfPathFoldersIncomingRulesFrame.SetDataSource(const Value: TDataSource);
begin
 MainView.DataController.DataSource:=Value;
 FDataSet:=Value.DataSet;
 FActionList.DataSource:=Value;
end;


end.
