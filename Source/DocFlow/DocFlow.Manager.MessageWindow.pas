unit DocFlow.Manager.MessageWindow;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Dialog.Basic, cxGraphics,
  cxLookAndFeels, cxLookAndFeelPainters, Vcl.Menus, Vcl.StdCtrls, cxButtons,
  Vcl.ExtCtrls, Data.DB,
  Common.Images,
  Common.ResourceStrings, cxControls, cxStyles, cxCustomData, cxFilter, cxData,
  cxDataStorage, cxEdit, cxNavigator, dxDateRanges, cxDBData, cxGridLevel,
  cxClasses, cxGridCustomView, cxGridCustomTableView, cxGridTableView,
  cxGridDBTableView, cxGrid, cxImageComboBox,

  CustomControl.MiceGrid.Helper,
  CustomControl.MiceGrid.ColorBuilder;

type
  TDocFlowMessageWindow = class(TBasicDialog)
    DataSource1: TDataSource;
    View: TcxGridDBTableView;
    Grid1Level1: TcxGridLevel;
    Grid1: TcxGrid;
    colMessage: TcxGridDBColumn;
    colImageIndex: TcxGridDBColumn;
    ViewColumn1: TcxGridDBColumn;
    procedure FormCreate(Sender: TObject);
    procedure ViewCustomDrawCell(Sender: TcxCustomGridTableView;
      ACanvas: TcxCanvas; AViewInfo: TcxGridTableDataCellViewInfo;
      var ADone: Boolean);
  public
    class procedure ShowDocFlowMessages(DataSet:TDataSet);
  end;

implementation

{$R *.dfm}

procedure TDocFlowMessageWindow.FormCreate(Sender: TObject);
begin
  inherited;
  ReadOnly:=True;
end;

class procedure TDocFlowMessageWindow.ShowDocFlowMessages(DataSet: TDataSet);
var
 Dlg:TDocFlowMessageWindow;
begin
  Dlg:=TDocFlowMessageWindow.Create(nil);
  try
   Dlg.DataSource1.DataSet:=DataSet;
   Dlg.ShowModal;
  finally
   Dlg.Free;
  end;
end;

procedure TDocFlowMessageWindow.ViewCustomDrawCell(
  Sender: TcxCustomGridTableView; ACanvas: TcxCanvas;
  AViewInfo: TcxGridTableDataCellViewInfo; var ADone: Boolean);
begin
 TMiceGridColors.DefaultDrawGridCell(Sender,ACanvas,AViewInfo,ADone);
 ADone:=TMiceGridHelper.DrawIcon(ACanvas, AViewInfo,View.Images,colImageIndex);
end;

end.
