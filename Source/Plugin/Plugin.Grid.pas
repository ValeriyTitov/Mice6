unit Plugin.Grid;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, cxStyles, cxCustomData, cxFilter,
  cxData, cxDataStorage, cxEdit, cxNavigator, Data.DB, cxDBData, cxGridLevel,
  cxClasses, cxGridCustomView, cxGridCustomTableView,cxGridTableView,
  cxGridDBTableView, cxGrid,  System.Actions,  Vcl.ActnList,  cxGridDBDataDefinitions,
  cxGridBandedTableView, cxGridDBBandedTableView,
  CustomControl.MiceGrid.Helper,
  Common.Images,
  Plugin.Base,
  CustomControl.MiceGrid.ColumnBuilder,
  CustomControl.MiceGrid.ColorBuilder,
  CustomControl.MiceGrid.MenuBuilder,
  CustomControl.MiceGrid,
  Common.StringUtils,
  Common.LookAndFeel,
  dxDateRanges,
  cxDataControllerConditionalFormattingRulesManagerDialog, cxSplitter,
  Plugin.SideTreeFilter, Vcl.ExtCtrls, Vcl.Menus, dxBar, dxScrollbarAnnotations;


type
  TcxGrid = class(TMiceGrid)

  end;

  TGridPlugin = class(TBasePlugin)
    MainGrid: TcxGrid;
    MainLevel: TcxGridLevel;
    MainView: TcxGridDBBandedTableView;
    procedure MainViewCustomDrawCell(Sender: TcxCustomGridTableView;
      ACanvas: TcxCanvas; AViewInfo: TcxGridTableDataCellViewInfo;
      var ADone: Boolean);
    procedure DataSourceDataChange(Sender: TObject; Field: TField);
    procedure MainViewSelectionChanged(Sender: TcxCustomGridTableView);
    procedure MainViewCellDblClick(Sender: TcxCustomGridTableView;
      ACellViewInfo: TcxGridTableDataCellViewInfo; AButton: TMouseButton;
      AShift: TShiftState; var AHandled: Boolean);
  private
    FBuilder: TMiceGridColumnBuilder;
    FMenuBuilder: TMiceGridColumnMenuBuilder;
    FSelectedIDs:TStringList;
    procedure UpdateSelected;
    procedure AddRowID(DataSet:TDataSet);
  protected
    procedure Build; override;
  public
    procedure ForEachSelectedRowDo(OnSelectedRow: TDataSetNotifyEvent);override;
    function GetSelectedIDs:string;override;
    function SelectedCount:Integer;override;
    procedure RefreshDataSet;override;
    constructor Create(AOwner:TComponent); override;
    destructor Destroy; override;
  end;

implementation

{$R *.dfm}

procedure TGridPlugin.AddRowID(DataSet:TDataSet);
begin
 FSelectedIDs.Add(KeyFieldValue.ToString+',');
end;

procedure TGridPlugin.Build;
begin
  inherited;
  FBuilder.ParentDBName:=Properties.DBName;
  FBuilder.LoadPluginColumns(Properties.AppPluginsId);
  MainView.OptionsView.ColumnAutoWidth:=Properties.AutoWidth;
  MainView.OptionsView.GroupByBox:=Properties.GroupByPanel;
  MainView.OptionsCustomize.ColumnSorting:=Properties.Sorting;
  MainView.OptionsCustomize.ColumnFiltering:=Properties.Filtering;
  MainGrid.Align:=alClient;
  MainGrid.MiceGridColors.LoadForPlugin(Properties.AppPluginsId);

  MainView.DataController.KeyFieldNames:=Properties.KeyField;
//  MainView.OptionsView.HeaderAutoHeight:=True;
//  MainView.OptionsView.CellAutoHeight:=True;
  UpdateActionsActivity;
//  MainGrid.MiceGridColors.MapGridItems(MainView); //Тут нельзя, т.к. создаются далеко не все колонки.
end;


constructor TGridPlugin.Create(AOwner: TComponent);
begin
  inherited;
  FSelectedIDs:=TStringList.Create;
  FSelectedIDs.LineBreak:='';
  FBuilder:=TMiceGridColumnBuilder.Create(MainView);
  FMenuBuilder:=TMiceGridColumnMenuBuilder.Create(MainView,miColumns);
end;

procedure TGridPlugin.DataSourceDataChange(Sender: TObject; Field: TField);
begin
 UpdateSelected;
end;

destructor TGridPlugin.Destroy;
begin
  FBuilder.Free;
  FSelectedIDs.Free;
  FMenuBuilder.Free;
  inherited;
end;


procedure TGridPlugin.RefreshDataSet;
begin
 MainView.BeginUpdate(lsimImmediate);
 try
  inherited;
  if Self.Properties.MissingItemsCreated=False then
   begin
     Self.Properties.MissingItemsCreated:=True;
     Self.FBuilder.CreateMissingColumns;
     Self.MainGrid.MiceGridColors.MapGridItems(MainView);
     Self.FMenuBuilder.KeyField:=Self.Properties.KeyField;
     Self.FMenuBuilder.BuildMenu(DataSet);
   end;
 finally
   MainView.EndUpdate;
 end;
UpdateSelected;
end;

procedure TGridPlugin.ForEachSelectedRowDo(OnSelectedRow: TDataSetNotifyEvent);
var
 x: integer;
 Ctr: TcxGridDBDataController;
 RecID : Integer;
 RecIdx : Integer;
begin
 If not Assigned(OnSelectedRow) then
  Exit;
 AbortForEach:=False;
 Ctr:=Self.MainView.DataController;
 Ctr.DataSet.DisableControls;
  try
   for x:=0 to ctr.GetSelectedCount-1 do
     begin
       RecIdx:= Ctr.Controller.SelectedRecords[x].RecordIndex;
       RecID:= Ctr.GetRecordId(RecIdx);
        if (Ctr.DataSet.Locate(Ctr.KeyFieldNames,RecID,[loCaseInsensitive]))  then
         OnSelectedRow(Ctr.DataSet);
        if AbortForEach then
         Break;
     end;
  finally
   Ctr.DataSet.EnableControls;
  end;
end;


function TGridPlugin.GetSelectedIDs: string;
begin
  FSelectedIDs.Clear;
  ForEachSelectedRowDo(AddRowID);
  Result:=FSelectedIDs.Text;
end;

procedure TGridPlugin.MainViewCellDblClick(Sender: TcxCustomGridTableView;
  ACellViewInfo: TcxGridTableDataCellViewInfo; AButton: TMouseButton;
  AShift: TShiftState; var AHandled: Boolean);
begin
 if Assigned(MainView.Controller.FocusedRow) and Assigned(Properties.DoubleClickAction) then
  Properties.DoubleClickAction.Execute;
end;

procedure TGridPlugin.MainViewCustomDrawCell(Sender: TcxCustomGridTableView; ACanvas: TcxCanvas; AViewInfo: TcxGridTableDataCellViewInfo; var ADone: Boolean);
begin
  MainGrid.MiceGridColors.DrawGridColorCell(Sender, ACanvas, AViewInfo, ADone);

  if Properties.StaleData then
   ACanvas.Brush.Color:=DefaultLookAndFeel.StaleDataCellColor;

  TMiceGridColors.DefaultDrawGridCell(Sender, ACanvas, AViewInfo, ADone);

 if (Properties.ImageIndexField <> '') then
    ADone:=TMiceGridHelper.DrawIcon(ACanvas, AViewInfo,MainView.Images,MainView.GetColumnByFieldName(Properties.ImageIndexField));
end;

procedure TGridPlugin.MainViewSelectionChanged(Sender: TcxCustomGridTableView);
begin
// SelectionChanged(MainView.Controller.SelectedRowCount);
end;



function TGridPlugin.SelectedCount: Integer;
begin
 Result:=MainView.DataController.GetSelectedCount;
end;


procedure TGridPlugin.UpdateSelected;
var
 c:TcxGridBandedTableController;
begin
 C:=MainView.Controller;
 C.ClearSelection;
 if Assigned(C.FocusedRow) and (C.FocusedRecordIndex>=0)  then
   C.FocusedRow.Selected:=True;
end;

end.
