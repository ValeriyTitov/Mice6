unit CustomControl.MiceTreeGridFrame;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  CustomControl.AppObject,
  Common.ResourceStrings,
  Common.Images,
  Data.DB,
  DAC.XDataSet,
  DAC.XParams,
  DAC.DataSetList,
  Mice.Script,
  CustomControl.Interfaces, Vcl.StdCtrls, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, cxCustomData, cxStyles, cxTL,
  cxTLdxBarBuiltInMenu, cxInplaceContainer, cxTLData, cxDBTL,
  CustomControl.TreeGrid,
  CustomControl.MiceTreeGrid.ColumnBuilder,
  CustomControl.MiceGrid.ColorBuilder,
  Mice.Script.ClassTree;


type
  TcxDBTreeList = class(TMiceTreeGrid)

  end;

  TMiceTreeGridFrame = class(TFrame, IHaveScriptSupport, ICanInitFromJson, IAmLazyControl, IHaveColumns, IMayDependOnDialog)
    TreeGrid: TcxDBTreeList;
    procedure TreeGridCustomDrawDataCell(Sender: TcxCustomTreeList;
      ACanvas: TcxCanvas; AViewInfo: TcxTreeListEditCellViewInfo;
      var ADone: Boolean);
    procedure TreeGridClick(Sender: TObject);
    procedure TreeGridDblClick(Sender: TObject);
    procedure TreeGridFocusedNodeChanged(Sender: TcxCustomTreeList; APrevFocusedNode, AFocusedNode: TcxTreeListNode);
  private
    FScript:TMiceScripter;
    FAppDialogControlsId: Integer;
    FInitialized:Boolean;
    FParentObject: IInheritableAppObject;
    procedure InternalBuildColumns;
    procedure SetDBName(const Value: string);
    procedure BeforeOpenDataSet(DataSet:TDataSet);
    procedure NotifyDialogChanged;
    procedure RefreshDataSet;
    function GetDBName: string;
    function GetDataSet: TxDataSet;
  public
    procedure RefreshDataSetActionExecute(Sender:TObject);
    procedure InitFromJson(const Json:string);
    procedure InitFromParams(Params:TxParams);
    procedure RegisterScripter(Scripter:TMiceScripter);
    procedure LazyInit(ParentObject: IInheritableAppObject);
    procedure BuildColumns(const AppDialogControlsId:Integer;BuildRightNow:Boolean);
    constructor Create(AOwner:TComponent); override;
    class function DevDescription:string;
  published
    property AppDialogControlsId:Integer read FAppDialogControlsId write FAppDialogControlsId;
    property DBName:string read GetDBName write SetDBName;
    property DataSet:TxDataSet read GetDataSet;
  end;

implementation

{$R *.dfm}

{ TMiceTreeGridFrame }

procedure TMiceTreeGridFrame.BeforeOpenDataSet(DataSet: TDataSet);
begin
 if Assigned(FParentObject) and Assigned(FParentObject.ParamsMapper) then
  FParentObject.ParamsMapper.MapDataSet(Self.DataSet);
end;

procedure TMiceTreeGridFrame.BuildColumns(const AppDialogControlsId:Integer;BuildRightNow:Boolean);
begin
//BuildRightNow - Что бы колонки строились в манагере при редактировании лейаута
//Self.AppDialogControlsId - обязательно Self.
 Self.AppDialogControlsId:=AppDialogControlsId;

 if (FInitialized=False) and (BuildRightNow) then
  InternalBuildColumns;
end;

constructor TMiceTreeGridFrame.Create(AOwner: TComponent);
begin
  inherited;
  FInitialized:=False;
  DataSet.BeforeOpen:=Self.BeforeOpenDataSet
end;

class function TMiceTreeGridFrame.DevDescription: string;
resourcestring
 S_DevDescription_TMiceTreeGridFrame = 'Read only tree-based grid. Id/ParentId structure required. Repopulates automatically if any of provider-depended fields changed.';
begin
 Result:= S_DevDescription_TMiceTreeGridFrame;
end;

function TMiceTreeGridFrame.GetDataSet: TxDataSet;
begin
 Result:=TreeGrid.DataSet;
end;

function TMiceTreeGridFrame.GetDBName: string;
begin
 Result:=Self.TreeGrid.DataSet.DBName;
end;

procedure TMiceTreeGridFrame.InitFromJson(const Json: string);
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

procedure TMiceTreeGridFrame.InitFromParams(Params: TxParams);
begin
 TreeGrid.OptionsBehavior.Sorting:=Params.ParamByNameDef('Sorting',False);
 TreeGrid.OptionsView.ColumnAutoWidth:=Params.ParamByNameDef('AutoWidth',False);
 TreeGrid.DataController.KeyField:=Params.ParamByNameDef('KeyField','');
 TreeGrid.DataController.ParentField:=Params.ParamByNameDef('ParentIdField','');
 TreeGrid.DataController.ImageIndexField:=Params.ParamByNameDef('ImageIndexField','');
 TreeGrid.DataSet.ProviderNamePattern:=Params.ParamByNameDef('ProviderName','');
 TreeGrid.DataSet.DBName:=Params.ParamByNameDef('DBName','');
end;

procedure TMiceTreeGridFrame.InternalBuildColumns;
var
 FBuilder: TMiceTreeGridColumnBuilder;
begin
  FBuilder:=TMiceTreeGridColumnBuilder.Create(TreeGrid);
  try
   TreeGrid.ClearColumns;
   FBuilder.LoadGridColumns(AppDialogControlsId);
   TreeGrid.MiceGridColors.LoadForControl(AppDialogControlsId);
   TreeGrid.MiceGridColors.MapTreeGridItems(TreeGrid);
   FInitialized:=True;
  finally
    FBuilder.Free;
  end;
end;

procedure TMiceTreeGridFrame.LazyInit(ParentObject: IInheritableAppObject);
begin
 if FInitialized=False then
  begin
   FParentObject:=ParentObject;
   if Assigned(FParentObject) and (DBName.IsEmpty) then
    DBName:=FParentObject.DBName;
   InternalBuildColumns;
   DataSet.Source:=Self.Name+'.'+'DataSet';
   RefreshDataSet;
  end;
end;

procedure TMiceTreeGridFrame.NotifyDialogChanged;
begin
 if FInitialized then
  RefreshDataSet;
end;

procedure TMiceTreeGridFrame.RefreshDataSet;
var
 Event:TDataChangeEvent;
 ADataSource:TDataSource;
begin
 ADataSource:=Self.TreeGrid.DataSource;
 Event:=ADataSource.OnDataChange;
 ADataSource.OnDataChange:=nil;
 DataSet.DisableControls;
  try
   DataSet.ReQuery;
  finally
   DataSet.EnableControls;
   ADataSource.OnDataChange:=Event;
   if Assigned(Event) then
    Event(ADataSource,nil);
  end;
end;


procedure TMiceTreeGridFrame.RefreshDataSetActionExecute(Sender: TObject);
begin
  RefreshDataSet;
end;

procedure TMiceTreeGridFrame.RegisterScripter(Scripter: TMiceScripter);
begin
 FScript:=Scripter;
end;

procedure TMiceTreeGridFrame.SetDBName(const Value: string);
begin
 TreeGrid.DataSet.DBName:=Value;
end;

procedure TMiceTreeGridFrame.TreeGridCustomDrawDataCell( Sender: TcxCustomTreeList; ACanvas: TcxCanvas;  AViewInfo: TcxTreeListEditCellViewInfo; var ADone: Boolean);
begin
 TreeGrid.MiceGridColors.DrawTreeColorCell(Sender,ACanvas,AViewInfo,ADone);
 TMiceGridColors.DefaultDrawTreeCell(Sender, ACanvas, AViewInfo,ADone);
end;

procedure TMiceTreeGridFrame.TreeGridDblClick(Sender: TObject);
begin
 if Assigned(FScript) and Assigned(TreeGrid.FocusedNode) then
  FScript.CallOnDblClick(TreeGrid);
end;

procedure TMiceTreeGridFrame.TreeGridFocusedNodeChanged(Sender: TcxCustomTreeList; APrevFocusedNode, AFocusedNode: TcxTreeListNode);
begin
 if Assigned(FScript) then
  FScript.CallOnChange(TreeGrid);
end;

procedure TMiceTreeGridFrame.TreeGridClick(Sender: TObject);
begin
 if Assigned(FScript) then
  FScript.CallOnClick(TreeGrid);
end;

resourcestring
S_PROP_DESC_MICETREEGRIDFRAME_DATASET= 'Grid dataset';

initialization
 TMiceScripter.RegisterClassEventOnClick(TMiceTreeGridFrame.ClassName);
 TMiceScripter.RegisterClassEventOnDblClick(TMiceTreeGridFrame.ClassName);
 TMiceScripter.RegisterClassEventOnChange(TMiceTreeGridFrame.ClassName);


 TClassEventsTree.DefaultInstance.RegisterClassProperty(TMiceTreeGridFrame.ClassName,'DataSet', 'TxDataSet',S_PROP_DESC_MICETREEGRIDFRAME_DATASET);
// TClassEventsTree.DefaultInstance.RegisterItem(TMiceTreeGrid.ClassName,'DataSet', S_PROP_DESC_MICETREEGRIDFRAME_DATASET,'TxDataSet',TEntryType.etProperty);
// TClassEventsTree.DefaultInstance.RegisterItem(TMiceTreeGrid.ClassName,'DataSet', S_PROP_DESC_MICETREEGRIDFRAME_DATASET,'TxDataSet',TEntryType.etProperty);

end.
