unit ManagerEditor.dfPathFolder.InitFrame;

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
  CustomControl.Interfaces;

type
  TdfPathFoldersInitFrame = class(TFrame, IAmLazyControl)
    GridInits: TcxGrid;
    MainView: TcxGridDBBandedTableView;
    colOrderId: TcxGridDBBandedColumn;
    colCaption: TcxGridDBBandedColumn;
    GridInitsLevel1: TcxGridLevel;
    PopupMenu: TPopupMenu;
    miNew: TMenuItem;
    miDelete: TMenuItem;
    miEdit: TMenuItem;
    miActivity: TMenuItem;
    procedure MainViewCustomDrawCell(Sender: TcxCustomGridTableView;
      ACanvas: TcxCanvas; AViewInfo: TcxGridTableDataCellViewInfo;
      var ADone: Boolean);
  private
    FActionList:TMiceActionList;
    FDataSet:TDataSet;
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
    property DataSource:TDataSource read GetDataSource write SetDataSource;
    constructor Create(AOwner:TComponent); override;
    destructor Destroy; override;
  end;

implementation

{$R *.dfm}

{ TdfPathFoldersIncomingRulesFrame }

constructor TdfPathFoldersInitFrame.Create(AOwner: TComponent);
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

function TdfPathFoldersInitFrame.DataAvaible: Boolean;
begin
 Result:=Assigned(DataSource) and Assigned(DataSource.DataSet);
end;

destructor TdfPathFoldersInitFrame.Destroy;
begin
  FActionList.Free;
  inherited;
end;

function TdfPathFoldersInitFrame.GetDataSource: TDataSource;
begin
   Result:=MainView.DataController.DataSource;
end;

procedure TdfPathFoldersInitFrame.LazyInit( ParentObject: IInheritableAppObject);
begin
  if DataAvaible then
   DataSource.DataSet.Open;
end;

procedure TdfPathFoldersInitFrame.MainViewCustomDrawCell(Sender: TcxCustomGridTableView; ACanvas: TcxCanvas;  AViewInfo: TcxGridTableDataCellViewInfo; var ADone: Boolean);
begin
 TMiceGridColors.DefaultDrawGridCell(Sender,ACanvas,AViewInfo,ADone);
end;


procedure TdfPathFoldersInitFrame.OnNewExecute(Sender: TObject);
begin
end;

procedure TdfPathFoldersInitFrame.RefreshDataSet;
begin

end;

procedure TdfPathFoldersInitFrame.OnChangeActivityExecute(Sender: TObject);
begin
 FDataSet.FieldByName('Active').AsBoolean:=not FDataSet.FieldByName('Active').AsBoolean;
end;

procedure TdfPathFoldersInitFrame.OnDeleteColumnExecute(Sender: TObject);
begin
if MessageBox(Handle,PChar(S_COMMON_DELETE_ITEM_CONFIRMATION),PChar(S_COMMON_DELETE_RECORD_CAPTION),MB_YESNO+MB_ICONQUESTION)=ID_YES then
 FDataSet.Delete;
end;

procedure TdfPathFoldersInitFrame.OnEditExecute(Sender: TObject);
begin

end;

procedure TdfPathFoldersInitFrame.SetDataSource(const Value: TDataSource);
begin
 MainView.DataController.DataSource:=Value;
 FDataSet:=Value.DataSet;
 FActionList.DataSource:=Value;
end;

end.
