unit ManagerEditor.AppTemplate.DataSourceListDlg;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Dialog.Basic, cxGraphics,
  cxLookAndFeels, cxLookAndFeelPainters, Vcl.Menus, Vcl.StdCtrls, cxButtons,
  Vcl.ExtCtrls, cxControls, cxStyles, cxCustomData, cxFilter, cxData,
  cxDataStorage, cxEdit, cxNavigator,
  cxDataControllerConditionalFormattingRulesManagerDialog, Data.DB, cxDBData,
  cxGridLevel, cxGridCustomTableView, cxGridTableView, cxGridBandedTableView,
  cxGridDBBandedTableView, cxClasses, cxGridCustomView, cxGrid,
  Common.Images,
  DAC.DatabaseUtils,
  StaticDialog.AppObjectSelector,
  cxButtonEdit,
  dxDateRanges;

type
  TDataSourceListDlg = class(TBasicDialog)
    gridDataSets: TcxGrid;
    DataSetsView: TcxGridDBBandedTableView;
    colName: TcxGridDBBandedColumn;
    colDBName: TcxGridDBBandedColumn;
    colProviderName: TcxGridDBBandedColumn;
    cxGridLevel1: TcxGridLevel;
    PopupMenu1: TPopupMenu;
    Delete1: TMenuItem;
    Insert1: TMenuItem;
    procedure DataSetsViewCustomDrawCell(Sender: TcxCustomGridTableView;
      ACanvas: TcxCanvas; AViewInfo: TcxGridTableDataCellViewInfo;
      var ADone: Boolean);
    procedure PopupMenu1Popup(Sender: TObject);
    procedure Insert1Click(Sender: TObject);
    procedure Delete1Click(Sender: TObject);
    procedure colProviderNamePropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
  private
    FDBName: string;
    procedure SetDBName(const Value: string);
    { Private declarations }
  public
   property DBName:string read FDBName write SetDBName;
   class function ExecuteDialog(DataSource: TDataSource):Boolean;
  end;


implementation

{$R *.dfm}

procedure TDataSourceListDlg.colProviderNamePropertiesButtonClick(Sender: TObject; AButtonIndex: Integer);
var
 s:string;
 ID:Integer;
 ADBName:string;
 DataSet:TDataSet;
begin
 DataSet:=DataSetsView.DataController.DataSource.DataSet;
 s:=DataSet.FieldByName('ProviderName').AsString;
 ADBName:=DataSet.FieldByName('DBName').AsString;
 if TSysObjectSelectionDialog.ExecuteDialog(-2,ID,S, ADBName) then
  begin
   DataSet.FieldByName('DataSetName').AsString:=S;
   DataSet.FieldByName('ProviderName').AsString:=S;
  end
end;

procedure TDataSourceListDlg.DataSetsViewCustomDrawCell( Sender: TcxCustomGridTableView; ACanvas: TcxCanvas;  AViewInfo: TcxGridTableDataCellViewInfo; var ADone: Boolean);
begin
  if AViewInfo.GridRecord.Selected then
    begin
      ACanvas.Font.Color:=clBlack;
      ACanvas.Brush.Color:=$E5E5E5;
    end;
   if AViewInfo.Focused and AViewInfo.GridRecord.Focused then
      ACanvas.Brush.Color:=clSilver;
end;

procedure TDataSourceListDlg.Delete1Click(Sender: TObject);
begin
 DataSetsView.DataController.DataSource.DataSet.Delete;
end;

class function TDataSourceListDlg.ExecuteDialog(DataSource: TDataSource): Boolean;
var
 Dlg:TDataSourceListDlg;
begin
  Dlg:=TDataSourceListDlg.Create(nil);
  try
   Dlg.DataSetsView.DataController.DataSource:=DataSource;
   DataSource.DataSet.Open;
   DataSource.DataSet.Edit;
   Result:=Dlg.Execute;
   if Result and (DataSource.DataSet.State in [dsInsert, dsEdit]) then
     DataSource.DataSet.Post;
  finally
    Dlg.Free;
  end;
end;

procedure TDataSourceListDlg.Insert1Click(Sender: TObject);
var
 ADataSet:TDataSet;
begin
 ADataSet:= DataSetsView.DataController.DataSource.DataSet;
 ADataSet.Append;
 ADataSet.FieldByName('AppTemplatesDataSetsId').AsInteger:=TDataBaseUtils.NewAppObjectId(sq_AppTemplatesDataSets);
end;

procedure TDataSourceListDlg.PopupMenu1Popup(Sender: TObject);
begin
 Delete1.Enabled:=DataSetsView.Controller.SelectedRowCount>0;
end;

procedure TDataSourceListDlg.SetDBName(const Value: string);
begin
  FDBName := Value;
end;

end.
