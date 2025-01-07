unit CustomControl.MiceValuePicker.SelectGridDlg;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Dialog.Basic, cxGraphics,
  cxLookAndFeels, cxLookAndFeelPainters, Vcl.Menus, Vcl.StdCtrls, cxButtons,
  Vcl.ExtCtrls, cxControls, cxStyles, cxCustomData, cxFilter, cxData,
  cxDataStorage, cxEdit, cxNavigator, dxDateRanges, Data.DB, cxDBData,
  cxGridLevel, cxClasses, cxGridCustomView, cxGridCustomTableView,
  cxGridTableView, cxGridDBTableView, cxGrid,
  cxGridBandedTableView, cxGridDBBandedTableView,
  CustomControl.MiceGrid,
  CustomControl.MiceGrid.ColorBuilder,
  CustomControl.MiceGrid.ColumnBuilder,
  CustomControl.MiceValuePicker.Settings,
  Common.Registry,
  DAC.XDataSet;

type
  TcxGrid = class (TMiceGrid)

  end;

  TVPickSelectGridDialog = class(TBasicDialog)
    MainSource: TDataSource;
    MainGrid: TcxGrid;
    MainView: TcxGridDBBandedTableView;
    MainGridLevel1: TcxGridLevel;
    procedure MainViewCustomDrawCell(Sender: TcxCustomGridTableView;
      ACanvas: TcxCanvas; AViewInfo: TcxGridTableDataCellViewInfo;
      var ADone: Boolean);
    procedure MainViewDblClick(Sender: TObject);
  private
    FAppDialogControlsId: Integer;
    FEnabledField: string;
    FEnabledValue: Variant;
    FDataSet: TxDataSet;
    FKeyField: string;
    FAppDialogControlsIdTargetGrid: Integer;
    FKeyFieldValue: Variant;
    procedure SetEnabledField(const Value: string);
    procedure InternalBuildColumns;
    procedure SetKeyField(const Value: string);
  protected
    function DialogSaveName:string; override;
    procedure TryEnabledOkButton(DataSet:TDataSet);
  public
    property AppDialogControlsId: Integer read FAppDialogControlsId write FAppDialogControlsId;
    property AppDialogControlsIdTargetGrid: Integer read FAppDialogControlsIdTargetGrid write FAppDialogControlsIdTargetGrid;
    property EnabledField:string read FEnabledField write SetEnabledField;
    property EnabledValue:Variant read FEnabledValue write FEnabledValue;
    property KeyField:string read FKeyField write SetKeyField;

    property DataSet:TxDataSet read FDataSet;
    property KeyFieldValue:Variant read FKeyFieldValue write FKeyFieldValue;

    constructor Create(AOwner:TComponent); override;
    destructor Destroy; override;
    function Execute:Boolean; override;
  end;

implementation

{$R *.dfm}

{ TVPickSelectGridDialog }


constructor TVPickSelectGridDialog.Create(AOwner: TComponent);
begin
  inherited;
  FDataSet:=TxDataSet.Create(Self);
  FDataSet.AfterScroll:=TryEnabledOkButton;
  MainSource.DataSet:=FDataSet;
end;

destructor TVPickSelectGridDialog.Destroy;
begin

  inherited;
end;

function TVPickSelectGridDialog.DialogSaveName: string;
begin
 Result:='MiceValuePicker\AppDialogControlsId='+AppDialogControlsId.ToString;
end;

function TVPickSelectGridDialog.Execute: Boolean;
begin
 InternalBuildColumns;
 DataSet.Open;
 if not VarIsNull(KeyFieldValue) then
  DataSet.Locate(KeyField,KeyFieldValue,[]);

 TProjectRegistry.DefaultInstance.LoadForm(DialogSaveName,True,True,Self);
 Result:=ShowModal=mrOK;
 if Result then
  begin
   TProjectRegistry.DefaultInstance.SaveForm(DialogSaveName,Self);
   FKeyFieldValue:=DataSet.FieldByName(KeyField).Value;
  end;
end;

procedure TVPickSelectGridDialog.InternalBuildColumns;
var
 Builder:TMiceGridColumnBuilder;
begin
 Builder:=TMiceGridColumnBuilder.Create(MainView);
 try
  MainGrid.ClearColumns(MainView);
  Builder.LoadGridColumns(AppDialogControlsIdTargetGrid);
  MainGrid.MiceGridColors.LoadForControl(AppDialogControlsIdTargetGrid);
  MainGrid.MiceGridColors.MapGridItems(MainView);
 finally
  Builder.Free;
 end;
end;

procedure TVPickSelectGridDialog.MainViewCustomDrawCell( Sender: TcxCustomGridTableView; ACanvas: TcxCanvas;AViewInfo: TcxGridTableDataCellViewInfo; var ADone: Boolean);
begin
 MainGrid.MiceGridColors.DrawGridColorCell(Sender,ACanvas, AViewInfo, ADone);
 TMiceGridColors.DefaultDrawGridCell(Sender,ACanvas,AViewInfo,ADone);
end;

procedure TVPickSelectGridDialog.MainViewDblClick(Sender: TObject);
begin
 if bnOK.Enabled then
  bnOk.Click;
end;

procedure TVPickSelectGridDialog.SetEnabledField(const Value: string);
begin
  FEnabledField := Value;
  bnOK.Enabled:=Value='';
end;

procedure TVPickSelectGridDialog.SetKeyField(const Value: string);
begin
  FKeyField := Value;
  MainView.DataController.KeyFieldNames:=Value;
end;


procedure TVPickSelectGridDialog.TryEnabledOkButton(DataSet: TDataSet);
var
 F:TField;
begin
 F:=DataSet.FindField(EnabledField);
 if Assigned(F) then
  bnOK.Enabled:=F.Value=EnabledValue;
end;

end.
