unit DAC.DataSetView;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxStyles, cxCustomData, cxFilter, cxData,
  cxDataStorage, cxEdit, cxNavigator, Data.DB, cxDBData, cxGridLevel, cxClasses,
  cxGridCustomView, cxGridCustomTableView, cxGridTableView, cxGridDBTableView,
  cxGrid, dxmdaset, Vcl.StdCtrls, Vcl.ExtCtrls, cxCheckComboBox, cxCalendar,
  Vcl.Menus, cxGridExportLink, Vcl.Buttons, System.ImageList, Vcl.ImgList,
  cxButtons, cxContainer, cxTextEdit, Vcl.ComCtrls,
  Common.Images,
  Common.Resourcestrings;

type
  TViewDataSet = class(TForm)
    MainView: TcxGridDBTableView;
    MainGridLevel1: TcxGridLevel;
    MainGrid: TcxGrid;
    DataSource: TDataSource;
    Panel1: TPanel;
    cbAutoWidth: TCheckBox;
    SaveDialog1: TSaveDialog;
    PopupMenu1: TPopupMenu;
    Excel1: TMenuItem;
    StatusBar: TStatusBar;
    procedure MainViewCustomDrawCell(Sender: TcxCustomGridTableView;
      ACanvas: TcxCanvas; AViewInfo: TcxGridTableDataCellViewInfo;
      var ADone: Boolean);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure cbAutoWidthClick(Sender: TObject);
    procedure Excel1Click(Sender: TObject);
  private
   procedure UpdateWidth;
   procedure Open(DataSet:TDataSet);
  public

   class procedure ShowDataSet(DataSet:TDataSet);
  end;

var
  ViewDataSet: TViewDataSet;

implementation

{$R *.dfm}

procedure TViewDataSet.cbAutoWidthClick(Sender: TObject);
begin
 Self.MainView.OptionsView.ColumnAutoWidth:=cbAutoWidth.Checked;
end;

procedure TViewDataSet.Excel1Click(Sender: TObject);
begin
 if Self.SaveDialog1.Execute then
 ExportGridToExcel(SaveDialog1.FileName,Self.MainGrid);
end;

procedure TViewDataSet.FormClose(Sender: TObject; var Action: TCloseAction);
begin
 Action:=TCloseAction.caFree;
end;

procedure TViewDataSet.MainViewCustomDrawCell(Sender: TcxCustomGridTableView;
  ACanvas: TcxCanvas; AViewInfo: TcxGridTableDataCellViewInfo;
  var ADone: Boolean);
begin
 if AViewInfo.GridRecord.Selected then
  begin
    ACanvas.Font.Color:=clBlack;
    ACanvas.Brush.Color:=$E5E5E5;
  end;
 if AViewInfo.Focused and AViewInfo.GridRecord.Focused then
    ACanvas.Brush.Color:=clSilver;
end;

procedure TViewDataSet.Open(DataSet:TDataSet);
begin
 MainView.BeginUpdate();
 DataSource.DataSet:=DataSet;
 MainView.DataController.CreateAllItems(True);
 UpdateWidth;
 MainView.EndUpdate;
 if Assigned(DataSet) then
  begin
    StatusBar.Panels[0].Text:=Format(S_ROWS_FMT,[DataSet.RecordCount]);
    StatusBar.Panels[1].Text:=Format(S_COLUMNS_FMT,[DataSet.FieldCount]);
  end
   else
    Self.MainView.OptionsView.NoDataToDisplayInfoText:='Data set is NIL'
end;

class procedure TViewDataSet.ShowDataSet(DataSet: TDataSet);
var
 Dlg:TViewDataSet;
begin
 Dlg:=TViewDataSet.Create(nil);
 try
  Dlg.Open(DataSet);
  Dlg.ShowModal;
 finally
  Dlg.Free;
 end;

end;

procedure TViewDataSet.UpdateWidth;
var
 x:integer;
begin
 for x:=0 to MainView.ColumnCount-1 do
   begin
    if x=0 then
       MainView.Columns[x].Visible:=False;

    MainView.Columns[x].PropertiesClass:=TcxTextEditProperties;
    MainView.Columns[x].Properties.ReadOnly:=True;

    if Assigned(MainView.Columns[x].DataBinding.Field) then
     begin
     if (MainView.Columns[x].DataBinding.Field.DataType=ftBoolean) then
      begin
       MainView.Columns[x].Width:=20;
//       MainView.Columns[x].PropertiesClass:= TcxCheckComboBoxProperties;
      end;

     if (MainView.Columns[x].DataBinding.Field.DataType=ftDateTime) then
      begin
       MainView.Columns[x].Width:=60;
       MainView.Columns[x].PropertiesClass:= TcxDateEditProperties;
      end;

     if (MainView.Columns[x].DataBinding.Field.Size<21)and (MainView.Columns[x].DataBinding.Field.DataType=ftString) then
      MainView.Columns[x].Width:=(MainView.Columns[x].DataBinding.Field.Size)*3;
     end;

      if MainView.Columns[x].Width>100 then
       MainView.Columns[x].Width:=100;

   end;
end;

end.
