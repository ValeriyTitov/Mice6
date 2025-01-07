unit CustomControl.MiceEditableGridFrame;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, cxStyles, cxCustomData, cxFilter,
  cxData, cxDataStorage, cxEdit, cxNavigator, dxDateRanges,
  cxDataControllerConditionalFormattingRulesManagerDialog, Data.DB, cxDBData,
  cxGridLevel, cxClasses, cxGridCustomView, cxGridCustomTableView,
  cxGridTableView, cxGridDBTableView, cxGrid,cxGridBandedTableView,
  System.Generics.Collections,
  CustomControl.Interfaces,
  CustomControl.AppObject,
  Mice.Script,
  DAC.XDataSet,
  DAC.XParams,
  DAC.DataSetList,
  Common.ResourceStrings,
  Common.Images,
  CustomControl.MiceGrid,
  CustomControl.MiceGrid.ColorBuilder,
  CustomControl.MiceGrid.ColumnBuilder,
  cxGridDBBandedTableView, Vcl.Menus,
  CustomControl.MiceActionList,
  CustomControl.MiceAction;


type
  TcxGrid = class(TMiceGrid)

  end;

  TMiceEditableGridFrame = class(TFrame, ICanInitFromJson, IHaveScriptSupport, IAmLazyControl, IHaveColumns, IMayDependOnDialog, ICanHaveExternalDataSource)
    EditableGridLevel1: TcxGridLevel;
    EditableGrid: TcxGrid;
    MainView: TcxGridDBBandedTableView;
    PopupMenu1: TPopupMenu;
    miAdd: TMenuItem;
    miDelete: TMenuItem;
    miClone: TMenuItem;
    miRefresh: TMenuItem;
    procedure MainViewCustomDrawCell(Sender: TcxCustomGridTableView; ACanvas: TcxCanvas; AViewInfo: TcxGridTableDataCellViewInfo; var ADone: Boolean);
    procedure PopupMenu1Popup(Sender: TObject);
  private
    FLazyInit:Boolean;
    FDataSet:TxDataSet;
    FScript:TMiceScripter;
    FDataSourceName: string;
    FDetailsDataSets: TDataSetList;
    FDBName: string;
    FColumnsInitialized:Boolean;
    FAppDialogControlsId: Integer;
    FActionList:TMiceActionList;
    FParentObject: IInheritableAppObject;
    procedure InitFromParams(Params:TxParams);
    procedure InternalBuildColumns;
    procedure OnDeleteItemExecute(Sender:TObject);
    procedure OnAddItemExecute(Sender:TObject);
    procedure OnCloneItemExecute(Sender:TObject);
    procedure OnItemRefreshExecute(Sender:TObject);
    procedure NotifyDialogChanged;
    procedure SetDataSetList(DataSetList:TDataSetList);
    function GetDataSet:TxDataSet;
  public
    constructor Create(AOwner:TComponent); override;
    destructor Destroy; override;
    procedure InitFromJson(const Json:string);
    procedure RegisterScripter(Scripter:TMiceScripter);
    procedure LazyInit(ParentObject: IInheritableAppObject);
    procedure BuildColumns(const AppDialogControlsId:Integer;BuildRightNow:Boolean);
    procedure RefreshDataSet;
    class function DevDescription:string;
 published
    property DBName:string read FDBName write FDBName;
    property AppDialogControlsId:Integer read FAppDialogControlsId write FAppDialogControlsId;
    property DataSourceName:string read FDataSourceName write FDataSourceName;
    property DetailsDataSets:TDataSetList read FDetailsDataSets write FDetailsDataSets;
 end;

implementation

{$R *.dfm}

{ TMiceEditableGridFrame }

procedure TMiceEditableGridFrame.BuildColumns(const AppDialogControlsId:Integer;BuildRightNow:Boolean);
begin
 Self.AppDialogControlsId:=AppDialogControlsId;
 if (FColumnsInitialized=False) and (BuildRightNow) then
  InternalBuildColumns;
end;


constructor TMiceEditableGridFrame.Create(AOwner: TComponent);
var
 Action:TMiceAction;
begin
  inherited;
  FColumnsInitialized:=False;
  FLazyInit:=False;
  FActionList:=TMiceActionList.Create;

  Action:=FActionList.CreateAction('Delete',S_COMMON_DELETE,S_COMMON_DELETE_RECORD,IMAGEINDEX_ACTION_DELETE,False,OnDeleteItemExecute);
  Action.ActivityCondition.EnabledWhenNoRecords:=False;
  Action.ActivityCondition.EnabledWhenReadOnly:=False;
  miDelete.Action:=Action;

  Action:=FActionList.CreateAction('Add',S_COMMON_ADD,S_COMMON_ADD_HINT,IMAGEINDEX_ACTION_ADD,True,OnAddItemExecute);
  Action.ActivityCondition.AlwaysEnabled:=False;
  Action.ActivityCondition.EnabledWhenNoRecords:=True;
  Action.ActivityCondition.EnabledWhenReadOnly:=False;
  miAdd.Action:=Action;

  Action:=FActionList.CreateAction('Clone',S_COMMON_CLONE,S_COMMON_CLONE_HINT,IMAGEINDEX_ACTION_CLONE,False,OnCloneItemExecute);
  Action.ActivityCondition.AlwaysEnabled:=False;
  Action.ActivityCondition.EnabledWhenNoRecords:=False;
  Action.ActivityCondition.EnabledWhenReadOnly:=False;
  miClone.Action:=Action;

  Action:=FActionList.CreateAction('Refresh',S_COMMON_REFRESH,S_COMMON_REFRESH_HINT,IMAGEINDEX_ACTION_REFRESH,True,OnItemRefreshExecute);
  Action.ActivityCondition.AlwaysEnabled:=True;
  Action.ActivityCondition.EnabledWhenReadOnly:=True;
  miRefresh.Action:=Action;

end;

destructor TMiceEditableGridFrame.Destroy;
begin
  FActionList.Free;
  inherited;
end;

class function TMiceEditableGridFrame.DevDescription: string;
resourcestring
 S_DevDescription_TMiceEditableGridFrame = 'Grid which allows user to edit records with inplace-editor mode.';
begin
 Result:= S_DevDescription_TMiceEditableGridFrame;
end;

function TMiceEditableGridFrame.GetDataSet: TxDataSet;
begin
 Result:=FDataSet;
end;

procedure TMiceEditableGridFrame.InitFromJson(const Json: string);
var
 App:TMiceAppObject;
begin
 App:=TMiceAppObject.Create;
 try
  App.AsJson:=Json;
  InitFromParams(App.Params);
 finally
  App.Free;
 end;
end;

procedure TMiceEditableGridFrame.InitFromParams(Params: TxParams);
begin
 DataSourceName:=Params.ParamByNameDef('DataSourceName','');
 DBName:=Params.ParamByNameDef('DBName','');
 MainView.OptionsView.GroupByBox:=Params.ParamByNameDef('GroupByBox',False);
 MainView.OptionsCustomize.ColumnSorting:=Params.ParamByNameDef('Sorting',False);
 MainView.OptionsView.ColumnAutoWidth:=Params.ParamByNameDef('AutoWidth',False);
end;

procedure TMiceEditableGridFrame.InternalBuildColumns;
var
 Builder:TMiceGridColumnBuilder;
begin
 Builder:=TMiceGridColumnBuilder.Create(Self.MainView);
 try
  EditableGrid.ClearColumns(MainView);
  Builder.LoadGridColumns(AppDialogControlsId);
  EditableGrid.MiceGridColors.LoadForControl(AppDialogControlsId);
  EditableGrid.MiceGridColors.MapGridItems(MainView);

  FColumnsInitialized:=True;
 finally
  Builder.Free;
 end;
end;


procedure TMiceEditableGridFrame.LazyInit(ParentObject: IInheritableAppObject);
begin
if FLazyInit=False then
 begin
   FParentObject:=ParentObject;
   if Assigned(FParentObject) and (DBName.IsEmpty) then
     DBName:=FParentObject.DBName;

   if FColumnsInitialized=False then
    InternalBuildColumns;

    FDataSet.DBName:=DBName;
    FDataSet.Open;
   FLazyInit:=True;
 end;
end;

procedure TMiceEditableGridFrame.MainViewCustomDrawCell(Sender: TcxCustomGridTableView; ACanvas: TcxCanvas;  AViewInfo: TcxGridTableDataCellViewInfo; var ADone: Boolean);
begin
 EditableGrid.MiceGridColors.DrawGridColorCell(Sender,ACanvas, AViewInfo, ADone);
 TMiceGridColors.DefaultDrawGridCell(Sender,ACanvas,AViewInfo,ADone);
end;

procedure TMiceEditableGridFrame.NotifyDialogChanged;
begin
 if FLazyInit then
  RefreshDataSet;
end;

procedure TMiceEditableGridFrame.OnAddItemExecute(Sender: TObject);
begin
 FDataSet.Append;
end;

procedure TMiceEditableGridFrame.OnCloneItemExecute(Sender: TObject);
begin
 TxDataSet.CloneRow(Self.MainView.DataController.DataSet);
end;

procedure TMiceEditableGridFrame.OnDeleteItemExecute(Sender: TObject);
begin
 FDataSet.Delete;
end;

procedure TMiceEditableGridFrame.OnItemRefreshExecute(Sender: TObject);
begin
 RefreshDataSet;
end;

procedure TMiceEditableGridFrame.PopupMenu1Popup(Sender: TObject);
begin
 FActionList.RefreshActions;
end;

procedure TMiceEditableGridFrame.RefreshDataSet;
var
 Event:TDataChangeEvent;
 ADataSource:TDataSource;
begin
 ADataSource:=MainView.DataController.DataSource;
 Event:=ADataSource.OnDataChange;
 ADataSource.OnDataChange:=nil;
 FDataSet.DisableControls;
  try
   FDataSet.ReQuery;
  finally
   FDataSet.EnableControls;
   ADataSource.OnDataChange:=Event;
   if Assigned(Event) then
    Event(ADataSource,nil);
  end;
end;

procedure TMiceEditableGridFrame.RegisterScripter(Scripter: TMiceScripter);
begin
 FScript:=Scripter;
end;


procedure TMiceEditableGridFrame.SetDataSetList(DataSetList: TDataSetList);
begin
 if Assigned(DataSetList) then
  begin
   DetailsDataSets:=DataSetList;
   MainView.DataController.DataSource:=DetailsDataSets[DataSourceName];
   FDataSet:=MainView.DataController.DataSet as TxDataSet;
   FActionList.DataSource:=MainView.DataController.DataSource;
  end;
end;

end.
