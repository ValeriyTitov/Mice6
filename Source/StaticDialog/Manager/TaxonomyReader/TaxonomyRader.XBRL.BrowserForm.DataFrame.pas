unit TaxonomyRader.XBRL.BrowserForm.DataFrame;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, cxStyles, cxCustomData, cxFilter,
  cxData, cxDataStorage, cxEdit, cxNavigator,
  cxDataControllerConditionalFormattingRulesManagerDialog, Data.DB, cxDBData,
  cxGridLevel, cxClasses, cxGridCustomView, cxGridCustomTableView,
  cxGridTableView, cxGridDBTableView, cxGrid, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, cxContainer, cxTextEdit, cxMemo, dxDateRanges;

type
  TDataFrame = class(TFrame)
    gridView: TcxGridDBTableView;
    GridLevel1: TcxGridLevel;
    Grid: TcxGrid;
    DataSource: TDataSource;
    DataSet: TFDMemTable;
    gridViewColumn1: TcxGridDBColumn;
    gridViewColumn2: TcxGridDBColumn;
    gridViewColumn3: TcxGridDBColumn;
    gridViewColumn4: TcxGridDBColumn;
    gridViewColumn5: TcxGridDBColumn;
    procedure gridViewCustomDrawCell(Sender: TcxCustomGridTableView;
      ACanvas: TcxCanvas; AViewInfo: TcxGridTableDataCellViewInfo;
      var ADone: Boolean);
  private
    procedure CreateColumn(const ColumnName:string; const AFieldType:TFieldType; const ASize:Integer;AllowDBNull, AutoInc:Boolean);
  public
   constructor Create(AOwner:TComponent); override;
  end;

implementation

{$R *.dfm}

constructor TDataFrame.Create(AOwner: TComponent);
begin
  inherited;
  CreateColumn('Name',ftString,200,True,False);
  CreateColumn('Label',ftString,2000,True,False);
  CreateColumn('Type',ftString,200,True,False);
  CreateColumn('Enumeration',ftString,200,True,False);
  CreateColumn('Nillable',ftString,200,True,False);
end;

procedure TDataFrame.CreateColumn(const ColumnName: string; const AFieldType: TFieldType; const ASize: Integer; AllowDBNull, AutoInc: Boolean);
var
  Def:TFieldDef;
begin
  Def:=DataSet.FieldDefs.AddFieldDef;
  Def.Name:=ColumnName;
  Def.DataType:=AFieldType;
  if (Def.DataType=ftString) and (ASize>0) then
   Def.Size:=ASize;
  Def.CreateField(DataSet);
end;

procedure TDataFrame.gridViewCustomDrawCell(Sender: TcxCustomGridTableView;  ACanvas: TcxCanvas; AViewInfo: TcxGridTableDataCellViewInfo;  var ADone: Boolean);
begin

if AViewInfo.GridRecord.Selected then
  begin
   ACanvas.Font.Color:=clBlack;
   ACanvas.Brush.Color:=$E5E5E5;
  end;
 if AViewInfo.Focused and AViewInfo.GridRecord.Focused then
  ACanvas.Brush.Color:=clSilver;

end;

end.
