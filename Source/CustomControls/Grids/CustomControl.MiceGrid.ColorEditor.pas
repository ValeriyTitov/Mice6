unit CustomControl.MiceGrid.ColorEditor;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, cxStyles, cxCustomData, cxFilter,
  cxData, cxDataStorage, cxEdit, cxNavigator, dxDateRanges,
  cxDataControllerConditionalFormattingRulesManagerDialog, Data.DB, cxDBData,
  cxCheckBox, cxDropDownEdit, cxGridLevel, cxGridCustomTableView,
  cxGridTableView, cxGridBandedTableView, cxGridDBBandedTableView, cxClasses,
  cxGridCustomView, cxGrid, cxImageComboBox, cxTextEdit,Vcl.Menus, cxButtonEdit,
  CustomControl.MiceActionList,
  CustomControl.MiceAction,
  Common.Images,
  Common.ResourceStrings,
  Common.VariantUtils,
  DAC.DatabaseUtils,
  CustomControl.Interfaces, dxColorEdit, cxColorComboBox, Vcl.StdCtrls,
  dxScrollbarAnnotations;

type
  TMiceGridColorEditorFrame = class(TFrame, IAmLazyControl)
    gridColumns: TcxGrid;
    MainView: TcxGridDBBandedTableView;
    colOrderId: TcxGridDBBandedColumn;
    colFieldName: TcxGridDBBandedColumn;
    gridColumnsLevel1: TcxGridLevel;
    colSign: TcxGridDBBandedColumn;
    colValue: TcxGridDBBandedColumn;
    colColor: TcxGridDBBandedColumn;
    colBgColor: TcxGridDBBandedColumn;
    colWholeLine: TcxGridDBBandedColumn;
    colBold: TcxGridDBBandedColumn;
    colItalic: TcxGridDBBandedColumn;
    PopupMenu: TPopupMenu;
    miNew: TMenuItem;
    miDelete: TMenuItem;
    miCopyFromPlugin: TMenuItem;
    miCopyFromGrid: TMenuItem;
    ColorDialog1: TColorDialog;
    procedure colBgColorPropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
    procedure MainViewCustomDrawCell(Sender: TcxCustomGridTableView;
      ACanvas: TcxCanvas; AViewInfo: TcxGridTableDataCellViewInfo;
      var ADone: Boolean);
    procedure colColorPropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
  private
    FActionList:TMiceActionList;
    FDataSet:TDataSet;
    function GetDataSource: TDataSource;
    procedure SetDataSource(const Value: TDataSource);
    procedure OnDeleteColumnExecute(Sender:TObject);
    procedure OnAddExecute(Sender:TObject);
    procedure RefreshDataSet;
  public
    function DataAvaible:Boolean;
    procedure LazyInit(ParentObject: IInheritableAppObject);
    property DataSource:TDataSource read GetDataSource write SetDataSource;
    constructor Create(AOwner:TComponent); override;
    destructor Destroy; override;
  end;

implementation


resourcestring
  S_ADD_NEW_CONDITION = 'Add new condition';

{$R *.dfm}

{ TMiceGridColorEditorFrame }

procedure TMiceGridColorEditorFrame.colBgColorPropertiesButtonClick(Sender: TObject; AButtonIndex: Integer);
begin
 FDataSet.Edit;
 ColorDialog1.Color:=FDataSet.FieldByName('bgColor').AsInteger;
 if ColorDialog1.Execute(Handle) then
  begin
   if  ColorDialog1.Color=0 then
   FDataSet.FieldByName('bgColor').Clear
    else
   FDataSet.FieldByName('bgColor').AsInteger:=ColorDialog1.Color;
  end;
end;

procedure TMiceGridColorEditorFrame.colColorPropertiesButtonClick(Sender: TObject; AButtonIndex: Integer);
begin
 FDataSet.Edit;
 ColorDialog1.Color:=FDataSet.FieldByName('Color').AsInteger;
 if ColorDialog1.Execute(Handle) then
  begin
   if  ColorDialog1.Color=0 then
    FDataSet.FieldByName('Color').Clear
     else
    FDataSet.FieldByName('Color').AsInteger:=ColorDialog1.Color;
  end;
end;

constructor TMiceGridColorEditorFrame.Create(AOwner: TComponent);
var
 Action:TMiceAction;
begin
  inherited;
  FActionList:=TMiceActionList.Create;
  Action:=FActionList.CreateAction('Delete',S_COMMON_DELETE,S_COMMON_DELETE_RECORD,IMAGEINDEX_ACTION_DELETE,False,OnDeleteColumnExecute);
  Action.ActivityCondition.EnabledWhenNoRecords:=False;
  miDelete.Action:=Action;
  Action:=FActionList.CreateAction('Add',S_COMMON_ADD,S_ADD_NEW_CONDITION,IMAGEINDEX_ACTION_NEW,True,OnAddExecute);
  Action.ActivityCondition.AlwaysEnabled:=True;
  miNew.Action:=Action;
  Self.MainView.OnCustomDrawCell:=MainViewCustomDrawCell;
end;

function TMiceGridColorEditorFrame.DataAvaible: Boolean;
begin
 Result:=Assigned(DataSource) and Assigned(DataSource.DataSet);
end;

destructor TMiceGridColorEditorFrame.Destroy;
begin
  FActionList.Free;
  inherited;
end;

function TMiceGridColorEditorFrame.GetDataSource: TDataSource;
begin
   Result:=MainView.DataController.DataSource;
end;

procedure TMiceGridColorEditorFrame.LazyInit( ParentObject: IInheritableAppObject);
begin
  if DataAvaible then
   DataSource.DataSet.Open;

end;

procedure TMiceGridColorEditorFrame.MainViewCustomDrawCell(
  Sender: TcxCustomGridTableView; ACanvas: TcxCanvas;
  AViewInfo: TcxGridTableDataCellViewInfo; var ADone: Boolean);
var
 bgColor:TColor;
 AColor:TColor;
begin
  ACanvas.Brush.Color:=clWindow;

   if AViewInfo.GridRecord.Selected then
    begin
      ACanvas.Font.Color:=clBlack;
      ACanvas.Brush.Color:=$E5E5E5;
    end;

   AColor:=TVariantUtils.VarToIntDefNonZero(AViewInfo.GridRecord.Values[colColor.Index],clBlack);
   bgColor:=TVariantUtils.VarToIntDef(AViewInfo.GridRecord.Values[colBgColor.Index],clWhite);

    if AViewInfo.Item.Index=colColor.Index then
     ACanvas.Font.Color:=AColor;

    if AViewInfo.Item.Index=colbgColor.Index then
     begin
      ACanvas.Brush.Color:=bgColor;
      ACanvas.Font.Color:=AColor;
     end;

   if AViewInfo.Focused and AViewInfo.GridRecord.Focused then
      ACanvas.Brush.Color:=clSilver; ;
end;


procedure TMiceGridColorEditorFrame.OnAddExecute(Sender: TObject);
begin
 FDataSet:=DataSource.DataSet;
 FDataSet.Append;
 if FDataSet.FieldByName('AppGridColorsId').IsNull then
  FDataSet.FieldByName('AppGridColorsId').AsInteger:=TDataBaseUtils.NewAppObjectId(sq_AppGridColors);

 FDataSet.FieldByName('CreateOrder').AsInteger:=(FDataSet.RecordCount+1)*10;
 FDataSet.FieldByName('Sign').AsInteger:=0;
 FDataSet.FieldByName('FieldName').AsString:='FieldName';
 FDataSet.FieldByName('Color').AsInteger:=clBlack;
 FDataSet.FieldByName('bgColor').AsInteger:=clWhite;
 FDataSet.FieldByName('Value').Clear;
 FDataSet.FieldByName('Bold').AsBoolean:=False;
 FDataSet.FieldByName('Italic').AsBoolean:=False;
 FDataSet.FieldByName('WholeRow').AsBoolean:=True;
end;

procedure TMiceGridColorEditorFrame.OnDeleteColumnExecute(Sender: TObject);
begin
 DataSource.DataSet.Delete;
end;

procedure TMiceGridColorEditorFrame.RefreshDataSet;
begin

end;

procedure TMiceGridColorEditorFrame.SetDataSource(const Value: TDataSource);
begin
 MainView.DataController.DataSource:=Value;
 FDataSet:=Value.DataSet;
 FActionList.DataSource:=Value;
end;

end.
