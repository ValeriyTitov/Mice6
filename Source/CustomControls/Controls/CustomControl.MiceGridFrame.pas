unit CustomControl.MiceGridFrame;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  cxGraphics, cxLookAndFeels, cxLookAndFeelPainters,
  Vcl.Menus, cxButtons, cxControls, cxStyles, cxCustomData, cxFilter, cxData,
  cxDataStorage, cxEdit, cxNavigator, dxDateRanges, Data.DB, cxDBData,
  cxGridLevel, cxClasses, cxGridCustomView, cxGridCustomTableView,
  cxGridTableView, cxGridDBTableView, cxGrid, cxGridBandedTableView,  cxGridDBBandedTableView,
  CustomControl.AppObject,
  Common.ResourceStrings,
  Common.Images,
  DAC.XParams,
  DAC.XDataSet,
  DAC.DataSetList,
  Mice.Script,
  CustomControl.Interfaces,
  CustomControl.MiceGrid,
  CustomControl.MiceGrid.ColorBuilder,
  CustomControl.MiceGrid.ColumnBuilder,
  CustomControl.MiceActionList;



type
  TcxGrid = class(TMiceGrid)

  end;


  TMiceGridFrame = class(TFrame, IHaveScriptSupport, ICanInitFromJson, IAmLazyControl, IHaveColumns, IMayDependOnDialog)
    pnButtons: TPanel;
    bnAdd: TcxButton;
    bnOpen: TcxButton;
    bnDelete: TcxButton;
    MainGridLevel1: TcxGridLevel;
    MainGrid: TcxGrid;
    MainView: TcxGridDBBandedTableView;
    DataSource: TDataSource;
    PopupMenu1: TPopupMenu;
    miAdd: TMenuItem;
    miDelete: TMenuItem;
    miRefresh: TMenuItem;
    miEdit: TMenuItem;
    procedure MainViewCustomDrawCell(Sender: TcxCustomGridTableView;
      ACanvas: TcxCanvas; AViewInfo: TcxGridTableDataCellViewInfo;
      var ADone: Boolean);
  private
    FScript:TMiceScripter;
    FParentDBName: string;
    FAppDialogControlsId: Integer;
    FInitialized:Boolean;
    FAppDialogsId: Integer;
    FAppDialogLayoutsIdFieldName: string;
    FDataSet: TxDataSet;
    FActionList:TMiceActionList;
    FKeyField: string;
    FParentObject:IInheritableAppObject;
    procedure SetShowButtons(const Value: Boolean);
    procedure InternalBuildColumns;
    procedure SetKeyField(const Value: string);
    procedure SetDBName(const Value: string);
    procedure BeforeOpenDataSet(DataSet:TDataSet);
    procedure NotifyDialogChanged;
    procedure RefreshDataSet;
    function GetDataSet:TxDataSet;
    function GetShowButtons: Boolean;
    function GetDBName: string;
  public
    procedure InitFromJson(const Json:string);
    procedure InitFromParams(Params:TxParams);
    procedure RegisterScripter(Scripter:TMiceScripter);
    procedure LazyInit(ParentObject: IInheritableAppObject);

    procedure RefreshDataSetActionExecute(Sender:TObject);
    procedure AddActionExecute(Sender:TObject);
    procedure EditActionExecute(Sender:TObject);
    procedure DeleteActionExecute(Sender:TObject);

    constructor Create(AOwner:TComponent); override;
    destructor Destroy; override;
    procedure BuildColumns(const AppDialogControlsId:Integer;BuildRightNow:Boolean);
    procedure CreateActions;
    class function DevDescription:string;
  published
    property AppDialogControlsId:Integer read FAppDialogControlsId write FAppDialogControlsId;
    property AppDialogsId:Integer read FAppDialogsId write FAppDialogsId;
    property AppDialogLayoutsIdFieldName:string read FAppDialogLayoutsIdFieldName write FAppDialogLayoutsIdFieldName;
    property DataSet:TxDataSet read FDataSet;
    property KeyField:string read FKeyField write SetKeyField;
    property DBName:string read GetDBName write SetDBName;

    property ParentDBName:string read FParentDBName write FParentDBName;
    property ShowButtons:Boolean read GetShowButtons write SetShowButtons;
  end;

implementation

{$R *.dfm}

{ TMiceGridFrame }

procedure TMiceGridFrame.AddActionExecute(Sender: TObject);
begin
 raise Exception.Create('Error Message: AddActionExecute');
end;

procedure TMiceGridFrame.BeforeOpenDataSet(DataSet: TDataSet);
begin
 if Assigned(FParentObject) and Assigned(FParentObject.ParamsMapper) then
   FParentObject.ParamsMapper.MapDataSet(Self.DataSet);
end;

procedure TMiceGridFrame.BuildColumns(const AppDialogControlsId:Integer;BuildRightNow:Boolean);
begin
 Self.AppDialogControlsId:=AppDialogControlsId;
 if (FInitialized=False) and (BuildRightNow) then
  InternalBuildColumns;
end;

constructor TMiceGridFrame.Create(AOwner: TComponent);
begin
  inherited;
  FInitialized:=False;
  ShowButtons:=False;
  FDataSet:=TxDataSet.Create(Self);
  FDataSet.BeforeOpen:=BeforeOpenDataSet;
  DataSource.DataSet:=DataSet;
  FActionList:=TMiceActionList.Create;
  FActionList.DataSource:=Self.DataSource;
end;

procedure TMiceGridFrame.CreateActions;
begin
 bnAdd.Action:=FActionList.CreateAddAction(AddActionExecute);
 bnDelete.Action:=FActionList.CreateDeleteAction(KeyField,DeleteActionExecute);
 bnOpen.Action:=FActionList.CreateEditAction(KeyField, Self.EditActionExecute);

 miAdd.Action:=bnAdd.Action;
 miDelete.Action:=bnDelete.Action;
 miEdit.Action:=bnOpen.Action;
 miRefresh.Action:= FActionList.CreateRefreshDataAction(RefreshDataSetActionExecute);
end;

procedure TMiceGridFrame.DeleteActionExecute(Sender: TObject);
begin
 raise Exception.Create('Not implemented : DeleteActionExecute');
end;

destructor TMiceGridFrame.Destroy;
begin
  FActionList.Free;
  inherited;
end;

class function TMiceGridFrame.DevDescription: string;
resourcestring
 S_DevDescription_TMiceGridFrame = 'Read only grid, which records can only be added with external adaptive dialog. Can show Add/Edit/Delete buttons. Repopulates automatically if any of provider-depended fields changed.';
begin
 Result:= S_DevDescription_TMiceGridFrame;
end;

procedure TMiceGridFrame.EditActionExecute(Sender: TObject);
begin
 raise Exception.Create('Not implemented : EditActionExecute');
end;

function TMiceGridFrame.GetDataSet: TxDataSet;
begin
 Result:=Self.DataSet;
end;

function TMiceGridFrame.GetDBName: string;
begin
 Result:=Self.DataSet.DBName;
end;

function TMiceGridFrame.GetShowButtons: Boolean;
begin
 Result:=pnButtons.Visible;
end;

procedure TMiceGridFrame.InitFromJson(const Json: string);
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

procedure TMiceGridFrame.InitFromParams(Params: TxParams);
begin
 MainView.OptionsView.GroupByBox:=Params.ParamByNameDef('GroupByBox',False);
 MainView.OptionsCustomize.ColumnSorting:=Params.ParamByNameDef('Sorting',False);
 MainView.OptionsView.ColumnAutoWidth:=Params.ParamByNameDef('AutoWidth',False);

 ShowButtons:=Params.ParamByNameDef('ShowButtons',False);
 AppDialogsId:=Params.ParamByNameDef('AppDialogsId',0);
 AppDialogLayoutsIdFieldName:=Params.ParamByNameDef('AppDialogLayoutsIdFieldName','');
 DataSet.DBName:=Params.ParamByNameDef('DBName','');
 DataSet.Source:=Self.ClassName+'.'+Self.Name;
 DataSet.ProviderNamePattern:=Params.ParamByNameDef('ProviderName','');
end;

procedure TMiceGridFrame.InternalBuildColumns;
var
 Builder:TMiceGridColumnBuilder;
begin
 Builder:=TMiceGridColumnBuilder.Create(MainView);
 try
  MainGrid.ClearColumns(MainView);
  Builder.LoadGridColumns(AppDialogControlsId);
  MainGrid.MiceGridColors.LoadForControl(AppDialogControlsId);
  MainGrid.MiceGridColors.MapGridItems(MainView);

  FInitialized:=True;
 finally
  Builder.Free;
 end;
end;

procedure TMiceGridFrame.LazyInit(ParentObject: IInheritableAppObject);
begin
 if FInitialized=False then
  begin
   FParentObject:=ParentObject;
   if Assigned(FParentObject) and (DBName.IsEmpty) then
    DBName:=FParentObject.DBName;

   InternalBuildColumns;
   CreateActions;
   FInitialized:=True;
   RefreshDataSetActionExecute(nil);
  end;
end;

procedure TMiceGridFrame.MainViewCustomDrawCell(Sender: TcxCustomGridTableView;  ACanvas: TcxCanvas; AViewInfo: TcxGridTableDataCellViewInfo;  var ADone: Boolean);
begin
 MainGrid.MiceGridColors.DrawGridColorCell(Sender,ACanvas, AViewInfo, ADone);
 TMiceGridColors.DefaultDrawGridCell(Sender,ACanvas,AViewInfo,ADone);
end;

procedure TMiceGridFrame.NotifyDialogChanged;
begin
 if FInitialized then
  RefreshDataSet;
end;

procedure TMiceGridFrame.RefreshDataSet;
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

procedure TMiceGridFrame.RefreshDataSetActionExecute(Sender:TObject);
begin
 RefreshDataSet;
end;

procedure TMiceGridFrame.RegisterScripter(Scripter: TMiceScripter);
begin
 FScript:=Scripter;
end;



procedure TMiceGridFrame.SetDBName(const Value: string);
begin
 DataSet.DBName:=Value;
end;

procedure TMiceGridFrame.SetKeyField(const Value: string);
begin
 FKeyField := Value;
 DataSet.KeyField:=Value;
 MainView.DataController.KeyFieldNames:=Value;
end;

procedure TMiceGridFrame.SetShowButtons(const Value: Boolean);
begin
  pnButtons.Visible:=Value;
end;

end.
