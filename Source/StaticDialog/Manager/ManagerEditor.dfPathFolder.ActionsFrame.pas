unit ManagerEditor.dfPathFolder.ActionsFrame;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, cxGraphics, cxControls,
  Data.DB, Vcl.StdCtrls, cxLookAndFeels, cxLookAndFeelPainters,
  cxStyles, cxCustomData, cxFilter, cxData, cxDataStorage, cxEdit, cxNavigator,
  dxDateRanges, cxDBData, cxTextEdit, cxClasses,  Vcl.Menus, cxButtonEdit, cxTL, cxMaskEdit, cxTLdxBarBuiltInMenu,
  cxInplaceContainer, cxDBTL, cxTLData, System.UITypes,

  CustomControl.MiceActionList,
  CustomControl.MiceAction,
  Common.Images,
  Common.ResourceStrings,
  Common.VariantUtils,
  CustomControl.MiceGrid.ColorBuilder,
  CustomControl.Interfaces,
  ManagerEditor.dfPathFolder.ActionsFrame.CommonDialog,
  CustomControl.MiceGrid,
  DAC.DatabaseUtils,
  DAC.XDataSet, cxGridCustomView, cxGridCustomTableView, cxGridTableView,
  cxGridBandedTableView, cxGridDBBandedTableView, cxGridLevel, cxGrid;

type
  TdfPathFoldersActionsFrame = class(TFrame, IAmLazyControl)
    PopupMenu: TPopupMenu;
    miDelete: TMenuItem;
    miEdit: TMenuItem;
    miActivity: TMenuItem;
    Newstandartaction1: TMenuItem;
    Newextendedaction1: TMenuItem;
    miExecStoredProc: TMenuItem;
    miInsertRecord: TMenuItem;
    miSendMessage: TMenuItem;
    miHttpRequest: TMenuItem;
    Document1: TMenuItem;
    miDfPushdocument: TMenuItem;
    miDfRollbackDocument: TMenuItem;
    miDfCreateNewDocument: TMenuItem;
    Webservices1: TMenuItem;
    miSoapRequest: TMenuItem;
    ChangeType1: TMenuItem;
    MainGridLevel1: TcxGridLevel;
    MainGrid: TcxGrid;
    MainView: TcxGridDBBandedTableView;
    colID: TcxGridDBBandedColumn;
    colImageIndex: TcxGridDBBandedColumn;
    colCaption: TcxGridDBBandedColumn;
    colOrderId: TcxGridDBBandedColumn;
    colActive: TcxGridDBBandedColumn;
    colRequiresTransaction: TcxGridDBBandedColumn;
    colActionType: TcxGridDBBandedColumn;
    procedure MainViewCustomDrawCell(Sender: TcxCustomGridTableView;
      ACanvas: TcxCanvas; AViewInfo: TcxGridTableDataCellViewInfo;
      var ADone: Boolean);
    procedure MainViewDblClick(Sender: TObject);
  private
    FActionList:TMiceActionList;
    FDataSet:TxDataSet;
    FdfPathFoldersId: Integer;
    FDBName: string;
    function GetDataSource: TDataSource;
    procedure SetDataSource(const Value: TDataSource);
    procedure OnDeleteColumnExecute(Sender:TObject);
    procedure OnNewActionExecute(Sender:TObject);
    procedure OnEditExecute(Sender:TObject);
    procedure OnChangeActivityExecute(Sender:TObject);
    procedure EditAction(Id:Integer;AClass:TCommonDfActionsDialogType);
    procedure DoEditAction(ActionType:Integer);
    procedure RefreshDataSet;
  public
    function DataAvaible:Boolean;
    procedure LazyInit(ParentObject: IInheritableAppObject);
    property DataSource:TDataSource read GetDataSource write SetDataSource;
    property dfPathFoldersId:Integer read FdfPathFoldersId write FdfPathFoldersId;
    property DBName:string read FDBName write FDBName;
    constructor Create(AOwner:TComponent); override;
    destructor Destroy; override;
  end;

implementation

{$R *.dfm}

constructor TdfPathFoldersActionsFrame.Create(AOwner: TComponent);
const
 AKeyField = '';
begin
  inherited;
  FActionList:=TMiceActionList.Create;

  miSendMessage.Tag:=ACTION_TYPE_SEND_MAIL;
  miExecStoredProc.Tag :=ACTION_TYPE_SEND_STOREDPROC;

  FActionList.CreateAction('SendMessage',miSendMessage, OnNewActionExecute);
  FActionList.CreateAction('ExecStoredProc',miExecStoredProc, OnNewActionExecute);



  miDelete.Action:=FActionList.CreateDeleteAction(AKeyField,OnDeleteColumnExecute);
  miEdit.Action:=FActionList.CreateEditAction(AKeyField,OnEditExecute);
  miActivity.Action:=FActionList.CreateChangeActivityAction(AKeyField,OnChangeActivityExecute);
end;

function TdfPathFoldersActionsFrame.DataAvaible: Boolean;
begin
 Result:=Assigned(DataSource) and Assigned(DataSource.DataSet);
end;

destructor TdfPathFoldersActionsFrame.Destroy;
begin
  FActionList.Free;
  inherited;
end;

procedure TdfPathFoldersActionsFrame.DoEditAction(ActionType: Integer);
var
 EditId:Integer;
 AClass:TCommonDfActionsDialogType;
begin
 AClass:=TCommonDfActionsDialog.ActionEditorClass(ActionType);
 EditId:=FDataSet.FieldByName('dfPathFolderActionsid').AsInteger;
 EditAction(EditId, AClass);
end;

procedure TdfPathFoldersActionsFrame.EditAction(Id: Integer; AClass:TCommonDfActionsDialogType);
var
 Dlg:TCommonDfActionsDialog;
begin
 Dlg:=AClass.Create(nil);
 try
  MainView.BeginUpdate;
  Dlg.Id:=Id;
  Dlg.DBName:=Self.DBName;
  Dlg.dfPathFoldersId:=Self.dfPathFoldersId;
  Dlg.DefaultOrderId:=FDataSet.RecordCount+1;
  if Dlg.Execute then
   FDataSet.ReQuery;
 finally
  MainView.EndUpdate;
  Dlg.Free;
 end;
end;

function TdfPathFoldersActionsFrame.GetDataSource: TDataSource;
begin
   Result:=MainView.DataController.DataSource;
end;

procedure TdfPathFoldersActionsFrame.LazyInit( ParentObject: IInheritableAppObject);
begin
  if DataAvaible then
   DataSource.DataSet.Open;
end;

procedure TdfPathFoldersActionsFrame.MainViewCustomDrawCell(
  Sender: TcxCustomGridTableView; ACanvas: TcxCanvas;
  AViewInfo: TcxGridTableDataCellViewInfo; var ADone: Boolean);
var
 ItemEnabled:Boolean;
begin
 TMiceGridColors.DefaultDrawGridCell(Sender, ACanvas, AViewInfo,ADone);

 ItemEnabled:=AViewInfo.GridRecord.Values[ColActive.Index];
 if (not ItemEnabled) then
   ACanvas.Font.Color:=clSilver;

 if (not ItemEnabled) and (AViewInfo.Selected or AViewInfo.Focused) then
   ACanvas.Font.Color:=clDkGray;
end;

procedure TdfPathFoldersActionsFrame.MainViewDblClick(Sender: TObject);
begin
if (MainView.Controller.SelectedRowCount=1) then
  DoEditAction(FDataSet.FieldByName('ActionType').AsInteger);
end;

procedure TdfPathFoldersActionsFrame.OnNewActionExecute(Sender: TObject);
var
 AClass:TCommonDfActionsDialogType;
begin
 AClass:=TCommonDfActionsDialog.ActionEditorClass((Sender as TComponent).Tag);
 EditAction(-1,AClass);
end;

procedure TdfPathFoldersActionsFrame.RefreshDataSet;
begin

end;


procedure TdfPathFoldersActionsFrame.OnChangeActivityExecute(Sender: TObject);
begin
 FDataSet.Edit;
 FDataSet.FieldByName('Active').AsBoolean:=not FDataSet.FieldByName('Active').AsBoolean;
 FDataSet.Post;
end;

procedure TdfPathFoldersActionsFrame.OnDeleteColumnExecute(Sender: TObject);
begin
if MessageBox(Handle,PChar(S_COMMON_DELETE_ITEM_CONFIRMATION),PChar(S_COMMON_DELETE_RECORD_CAPTION),MB_YESNO+MB_ICONQUESTION)=ID_YES then
 FDataSet.Delete;
end;

procedure TdfPathFoldersActionsFrame.OnEditExecute(Sender: TObject);
begin
 DoEditAction((Sender as TComponent).Tag)
end;

procedure TdfPathFoldersActionsFrame.SetDataSource(const Value: TDataSource);
begin
 MainView.DataController.DataSource:=Value;
 FDataSet:=Value.DataSet as TxDataSet;
 FActionList.DataSource:=Value;
end;



end.
