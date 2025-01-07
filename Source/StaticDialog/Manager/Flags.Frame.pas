unit Flags.Frame;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, cxStyles, cxCustomData, cxFilter,
  cxData, cxDataStorage, cxEdit, cxNavigator, dxDateRanges,
  cxDataControllerConditionalFormattingRulesManagerDialog, Data.DB, cxDBData,
  cxImageComboBox, cxGridLevel, cxGridCustomTableView, cxGridTableView,
  cxGridDBTableView, cxClasses, cxGridCustomView, cxGrid, Vcl.Menus,
  cxDropDownEdit,
  DAC.DatabaseUtils,
  Common.Images,
  CustomControl.MiceGrid.ColorBuilder,
  CustomControl.Interfaces;



type
  TFlagsFrame = class(TFrame, IAmLazyControl)
    EuqtionGrid: TcxGrid;
    MainView: TcxGridDBTableView;
    colFieldName: TcxGridDBColumn;
    colSign: TcxGridDBColumn;
    colValue: TcxGridDBColumn;
    EuqtionGridLevel1: TcxGridLevel;
    PopupMenu1: TPopupMenu;
    Add1: TMenuItem;
    Delete1: TMenuItem;
    colItemName: TcxGridDBColumn;
    colName: TcxGridDBColumn;
    colType: TcxGridDBColumn;
    procedure Add1Click(Sender: TObject);
    procedure MainViewCustomDrawCell(Sender: TcxCustomGridTableView;
      ACanvas: TcxCanvas; AViewInfo: TcxGridTableDataCellViewInfo;
      var ADone: Boolean);
    procedure PopupMenu1Popup(Sender: TObject);
    procedure Delete1Click(Sender: TObject);
  private
    function GetControlNames: TStrings;
    function GetFieldNames: TStrings;
    procedure RefreshDataSet;
  public
    procedure LazyInit(ParentObject: IInheritableAppObject);
    property FieldNames:TStrings read GetFieldNames;
    property ControlNames:TStrings read GetControlNames;
  end;

implementation

{$R *.dfm}

procedure TFlagsFrame.Add1Click(Sender: TObject);
var
 DataSet:TDataSet;
begin
DataSet:=MainView.DataController.DataSet;
if Assigned(DataSet) then
 begin
  DataSet.Append;
  DataSet.FieldByName('AppDialogsLayoutFlagsId').AsInteger:=TDataBaseUtils.NewAppObjectId(sq_AppDialogsLayoutFlags);
  DataSet.FieldByName('Equation').AsInteger:=1;
  DataSet.FieldByName('FlagType').AsInteger:=1;
  DataSet.FieldByName('Name').AsString:='Condition'+ DataSet.RecordCount.ToString;
  DataSet.Post;
 end;
end;


procedure TFlagsFrame.Delete1Click(Sender: TObject);
var
 DataSet:TDataSet;
begin
DataSet:=MainView.DataController.DataSet;
if Assigned(DataSet) then
  DataSet.Delete;
end;

function TFlagsFrame.GetControlNames: TStrings;
begin
 Result:=(colItemName.Properties as TcxComboBoxProperties).Items;
end;

function TFlagsFrame.GetFieldNames: TStrings;
begin
 Result:=(colFieldName.Properties as TcxComboBoxProperties).Items;
end;

procedure TFlagsFrame.LazyInit(ParentObject: IInheritableAppObject);
begin
 if Assigned(MainView.DataController.DataSource) and Assigned(MainView.DataController.DataSource.DataSet) then
  MainView.DataController.DataSource.DataSet.Open;
end;

procedure TFlagsFrame.MainViewCustomDrawCell(Sender: TcxCustomGridTableView;  ACanvas: TcxCanvas; AViewInfo: TcxGridTableDataCellViewInfo;  var ADone: Boolean);
begin
 TMiceGridColors.DefaultDrawGridCell(Sender,ACanvas,AViewInfo,ADone);
end;

procedure TFlagsFrame.PopupMenu1Popup(Sender: TObject);
begin
 Self.Delete1.Enabled:=Self.MainView.Controller.SelectedRowCount>0;
end;

procedure TFlagsFrame.RefreshDataSet;
begin

end;

end.
