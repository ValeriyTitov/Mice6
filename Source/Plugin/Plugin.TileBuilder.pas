unit Plugin.TileBuilder;

interface
uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  cxControls, cxLookAndFeels, cxLookAndFeelPainters,dxCustomTileControl, dxTileControl,
  cxClasses, Vcl.Menus, Vcl.StdCtrls,
  Vcl.ExtCtrls,
  CustomControl.MiceAction,
  Dialogs,
  VCL.Controls,
  Data.DB,
  DAC.XDataSet,

  Plugin.Base,
  Plugin.Grid,
  Plugin.TreeGrid,
  Plugin.PivotGrid,
  Plugin.MultiPagePlugin,
  Plugin.Page,
  MiceTile.ContentFrame,

  Plugin.List,
  Plugin.TileCommandBuilder,
  DAC.XParams,
  DAC.XParams.Mapper,
  Common.VariantComparator,
  CustomControl.Interfaces;

type
 TPluginTileBuilder = class
  strict private
    FTile:TdxTileControl;
    FPluginList:TPluginList;
    FCommandBuilder:TPluginTileCommandBuilder;
    function NewPlugin(AppPluginsId:Integer):TBasePlugin;
    function InternalCreatePlugin(const AppPluginsId:Integer; const MakeActive:Boolean):TBasePlugin;
    function CreatePluginContainer(Plugin:TBasePlugin):TdxTileControlItem;
    procedure BeforePluginDestroy(Sender:TObject);
  private
    function GetActivePlugin: TBasePlugin;
    function GetPluginType(const PluginType:Integer): TBasePluginClass;
    procedure ExecuteOpenPlugin(Sender: TObject);
  public
    constructor Create(Tile:TdxTileControl);
    destructor Destroy; override;
    function CreatePluginById(const AppPluginsId:Integer):TBasePlugin;
    function CreatePluginByIdLazy(const PluginID:Integer):TBasePlugin;
    procedure DeleteActivePlugin;
    procedure InitializePlugin(Plugin:TBasePlugin);
    procedure DeletePluginByIndex(const Index:Integer);
    property ActivePlugin:TBasePlugin read GetActivePlugin;
 end;

implementation

{ TPluginBuilder }

procedure TPluginTileBuilder.BeforePluginDestroy(Sender: TObject);
var
 x:Integer;
 Plugin:TBasePlugin;
begin
 Plugin:=Sender as TBasePlugin;
 Plugin.SaveState;
 for x:=0 to FPluginList.Count-1 do
  begin
    if FPluginList[x].ParentObject=(Plugin as IInheritableAppObject) then
     FPluginList[x].ParentObject:=nil;
  end;

 FPluginList.Extract(Plugin);
end;


constructor TPluginTileBuilder.Create(Tile:TdxTileControl);
begin
  FTile:=Tile;
  FPluginList:=TPluginList.Create;
  FCommandBuilder:=TPluginTileCommandBuilder.Create;
  FCommandBuilder.OnCreatePluginActionExecute:=ExecuteOpenPlugin;
end;


procedure TPluginTileBuilder.InitializePlugin(Plugin: TBasePlugin);
begin
 if not Plugin.Initialized then
  begin
    Plugin.Initialize;
    FCommandBuilder.LoadForPlugin(Plugin);
  end;
end;

function TPluginTileBuilder.InternalCreatePlugin(const AppPluginsId:Integer; const MakeActive:Boolean): TBasePlugin;
var
 Item:TdxTileControlItem;
begin
 Result:=Self.NewPlugin(AppPluginsId);
 Item:=CreatePluginContainer(Result);

 if MakeActive then
 begin
   InitializePlugin(Result);
   Result.Actions.EnableHotKeys;
   Item.ActivateDetail;
 end;
end;

function TPluginTileBuilder.NewPlugin(AppPluginsId: Integer): TBasePlugin;
var
 AClass: TBasePluginClass;
 Tmp:TxDataSet;
resourcestring
 S_PLUGING_NOT_FOUND_FMT = 'Plugin not found %d';
begin
 Tmp:=TxDataSet.Create(nil);
 try
  Tmp.ProviderName:='spui_AppGetPlugin';
  Tmp.Source:='TPluginBuilder.NewPlugin';
  Tmp.SetParameter('AppPluginsId',AppPluginsId);
  Tmp.Open;
  if Tmp.RecordCount<=0 then
   raise Exception.CreateFmt(S_PLUGING_NOT_FOUND_FMT,[AppPluginsId]);
  AClass:=GetPluginType(Tmp.FieldByName('PluginType').AsInteger);
  Result:=AClass.Create(nil);

  if Result is TMultiPagePlugin then
   (Result as  TMultiPagePlugin).OnGetPluginClass:=GetPluginType;
  FPluginList.Add(Result);
  Result.Properties.LoadFromDataSet(Tmp);
 finally
  Tmp.Free;
 end;
end;

function TPluginTileBuilder.CreatePluginById(const AppPluginsId:Integer): TBasePlugin;
begin
 if FPluginList.PluginExists(AppPluginsId) then
  begin
//   FRibbon.ActiveTab:=FPluginList.PluginByID(AppPluginsId).Container.Tab;
   Result:=ActivePlugin;
  end
   else
  Result:=InternalCreatePlugin(AppPluginsId, True);
end;


function TPluginTileBuilder.CreatePluginByIdLazy(const PluginID:Integer): TBasePlugin;
begin
 if FPluginList.PluginExists(PluginID) then
   Result:=FPluginList.PluginByID(PluginID)
    else
   Result:=InternalCreatePlugin(PluginID, FPluginList.Count=0);
end;

function TPluginTileBuilder.CreatePluginContainer(Plugin:TBasePlugin):TdxTileControlItem;
var
 Frame:TTileContentFrame;
begin
 Result:=FTile.Items.Add;
 Frame:=TTileContentFrame.Create(Plugin);
 Result.Group:=FTile.Groups[0];
 Result.DetailOptions.ShowTab:=False;
 Result.DetailOptions.DetailControl:=Frame;
 Result.DetailOptions.Caption:=Plugin.Properties.Title;
 Result.Text1.Value:=Plugin.Properties.Title;
 Result.DetailOptions.ShowTab:=True;
 Plugin.Parent:=Frame;
 Plugin.Container.Bar:=Frame.BarManager;
 Plugin.Container.TileItem:=Result;
 Plugin.Align:=alClient;
 Plugin.BeforeDestroy:=BeforePluginDestroy;
end;

procedure TPluginTileBuilder.DeleteActivePlugin;
begin
 if Assigned(ActivePlugin) then
  FPluginList.Delete(FPluginList.IndexOf(ActivePlugin));
end;

procedure TPluginTileBuilder.DeletePluginByIndex(const Index: Integer);
begin
 FPluginList.Delete(Index);
end;

destructor TPluginTileBuilder.Destroy;
begin
  FCommandBuilder.Free;
  FPluginList.Free;
  inherited;
end;


function TPluginTileBuilder.GetActivePlugin: TBasePlugin;
begin
// if Assigned(FRibbon.ActiveTab) then
//  Result:=TBasePlugin(FRibbon.ActiveTab.Tag)
//   else
  Result:=nil;
end;

function TPluginTileBuilder.GetPluginType(const PluginType: Integer): TBasePluginClass;
resourcestring
 E_UNKNOWN_PLUGIN_TYPE_FMT = 'Unknown plugin type : %d';
begin
 case PluginType of
  0: Result:=TGridPlugin;
  1: Result:=TTreeGridPlugin;
  2: Result:=TPivotPlugin;
//  3: Result:=TChartsPlugin;
  4: Result:=TMultiPagePlugin;
  5: Result:=TPagePlugin;
   else
  raise Exception.CreateFmt(E_UNKNOWN_PLUGIN_TYPE_FMT, [PluginType]);

 end;
end;


procedure TPluginTileBuilder.ExecuteOpenPlugin(Sender:TObject);
var
 Action:TMiceAction;
 Plugin:TBasePlugin;
 Params:TxParams;
 CurrentPlugin:TBasePlugin;
begin
 Action:= Sender as TMiceAction;
 Params:=TxParams.Create;
  try
   CurrentPlugin:=ActivePlugin;
   Plugin:=CreatePluginById(Action.RunAppPluginsId);
   if Assigned(CurrentPlugin) then
    begin
     Plugin.ParentObject:=CurrentPlugin;
     CurrentPlugin.ParamsMapper.MapParamsAppCmd(Params,Action.ID);
    end;
   Plugin.Params.LoadFromParams(Params);
   Plugin.LoadState;
   Plugin.UpdateCaption;

   if (Plugin.Properties.RefreshAfterCreate) and (Plugin is TMultiPagePlugin=False) then
     Plugin.RefreshDataSet;
 finally
   Params.Free;
 end;
end;

end.
