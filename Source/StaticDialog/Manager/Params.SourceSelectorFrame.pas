unit Params.SourceSelectorFrame;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, cxStyles, cxCustomData, cxFilter,
  cxData, cxDataStorage, cxEdit, cxNavigator, Data.DB, cxDBData, cxGridLevel,
  cxClasses, cxGridCustomView, cxGridCustomTableView, cxGridTableView,
  cxGridDBTableView, cxGrid, cxImageComboBox,
  Common.Images,
  DAC.DatabaseUtils,
  CustomControl.Interfaces,
  DAC.XDataSet, Vcl.Menus,
  cxDataControllerConditionalFormattingRulesManagerDialog, dxDateRanges,
  dxScrollbarAnnotations;

type
  TCommandPropertiesFrame = class(TFrame, IAmLazyControl)
    MainView: TcxGridDBTableView;
    ParamGridLevel1: TcxGridLevel;
    ParamGrid: TcxGrid;
    colName: TcxGridDBColumn;
    colSource: TcxGridDBColumn;
    colValue: TcxGridDBColumn;
    PopupMenu1: TPopupMenu;
    Add1: TMenuItem;
    Delete1: TMenuItem;
    procedure MainViewCustomDrawCell(
      Sender: TcxCustomGridTableView; ACanvas: TcxCanvas;
      AViewInfo: TcxGridTableDataCellViewInfo; var ADone: Boolean);
    procedure Add1Click(Sender: TObject);
    procedure Delete1Click(Sender: TObject);
    procedure PopupMenu1Popup(Sender: TObject);
    procedure RefreshDataSet;
  private
  public
    constructor Create(AOwner:TComponent); override;
    destructor Destroy; override;
    procedure LazyInit(ParentObject: IInheritableAppObject);
  end;

implementation

{$R *.dfm}

procedure TCommandPropertiesFrame.Add1Click(Sender: TObject);
var
 DataSet:TDataSet;
begin
DataSet:=MainView.DataController.DataSet;
if Assigned(DataSet) then
 begin
  DataSet.Append;
  {
    Этот фрейм используется в нескольких местах, и в них разные ключи.
    По этому надо искать ключевое поле
    if Assigned(DataSet.FindField(<KeyField>)) then
  }
  if Assigned(DataSet.FindField('AppScriptsParamsId')) then
   DataSet.FieldByName('AppScriptsParamsId').AsInteger:=TDataBaseUtils.NewAppObjectId(sq_AppScriptsParams);

  //if Assigned(DataSet.FindField('AppCmdId')) then
//  DataSet.FieldByName('AppCmdId').AsInteger:=TDataBaseUtils.NewAppObjectId(sq_AppCmdParams);

  DataSet.FieldByName('Name').AsString:='Param'+ DataSet.RecordCount.ToString;
  if Assigned(DataSet.FindField('ParamType')) then
   DataSet.FieldByName('ParamType').AsInteger:=0;
 end;
end;

procedure TCommandPropertiesFrame.Delete1Click(Sender: TObject);
begin
if Assigned(MainView.DataController.DataSet) then
  MainView.DataController.DataSet.Delete;
end;

constructor TCommandPropertiesFrame.Create(AOwner: TComponent);
begin
  inherited;
end;


destructor TCommandPropertiesFrame.Destroy;
begin

  inherited;
end;

procedure TCommandPropertiesFrame.LazyInit(ParentObject: IInheritableAppObject);
begin
// ShowMessage('IamLazy');
 if Assigned(MainView.DataController.DataSource) and Assigned(MainView.DataController.DataSource.DataSet) then
  MainView.DataController.DataSource.DataSet.Open;
end;

procedure TCommandPropertiesFrame.MainViewCustomDrawCell(
  Sender: TcxCustomGridTableView; ACanvas: TcxCanvas;
  AViewInfo: TcxGridTableDataCellViewInfo; var ADone: Boolean);
begin
 ACanvas.Brush.Color:=clWindow;
  if AViewInfo.GridRecord.Selected then
  begin
    ACanvas.Font.Color:=clBlack;
    ACanvas.Brush.Color:=$E5E5E5;
  end;

 if AViewInfo.Focused and AViewInfo.GridRecord.Focused then
    ACanvas.Brush.Color:=clSilver; ;

end;

procedure TCommandPropertiesFrame.PopupMenu1Popup(Sender: TObject);
begin
 Self.Delete1.Enabled:=Self.MainView.Controller.SelectedRowCount>0;
end;

procedure TCommandPropertiesFrame.RefreshDataSet;
begin
 if Assigned(MainView.DataController.DataSource) and Assigned(MainView.DataController.DataSource.DataSet) then
  begin
   MainView.DataController.DataSource.DataSet.Close;
   MainView.DataController.DataSource.DataSet.Open;
  end;
end;

end.
