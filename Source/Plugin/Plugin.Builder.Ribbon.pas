unit Plugin.Builder.Ribbon;

interface
uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  cxControls, cxLookAndFeels, cxLookAndFeelPainters, dxRibbonSkins,  dxBar,
  cxClasses, dxRibbon, dxStatusBar,Vcl.Menus, Vcl.StdCtrls, cxButtons,
  dxBarBuiltInMenu, cxPC,Vcl.ExtCtrls, dxRibbonStatusBar,
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

  Plugin.List,
  Plugin.CommandBuilder.Ribbon,
  DAC.XParams,
  DAC.XParams.Mapper,
  Common.VariantComparator,
  CustomControl.Interfaces;

type
 TPluginBuilder = class
  strict private
    FRibbon: TdxRibbon;
    FPageControl: TcxPageControl;
    FPluginList:TPluginList;
    FCommandBuilder:TPluginCommandBuilder;
    function NewPlugin(AppPluginsId:Integer):TBasePlugin;
    function InternalCreatePlugin(const AppPluginsId:Integer; const MakeActive:Boolean):TBasePlugin;
    procedure CreatePluginContainer(Plugin:TBasePlugin);
    procedure BeforePluginDestroy(Sender:TObject);
  private
    function GetActivePlugin: TBasePlugin;
    function GetPluginType(const PluginType:Integer): TBasePluginClass;
    procedure ExecuteOpenPlugin(Sender: TObject);
  public
    constructor Create(Ribbon:TdxRibbon; PageControl:TcxPageControl);
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

procedure TPluginBuilder.BeforePluginDestroy(Sender: TObject);
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


constructor TPluginBuilder.Create(Ribbon: TdxRibbon; PageControl: TcxPageControl);
begin
  FRibbon:=Ribbon;
  FPageControl:=PageControl;
  FPluginList:=TPluginList.Create;
  FCommandBuilder:=TPluginCommandBuilder.Create;
  FCommandBuilder.OnCreatePluginActionExecute:=ExecuteOpenPlugin;
end;


procedure TPluginBuilder.InitializePlugin(Plugin: TBasePlugin);
begin
 if not Plugin.Initialized then
  begin
    Plugin.Initialize;
    FCommandBuilder.GridPopupMenu:=Plugin.GridPopupMenu;
    FCommandBuilder.LoadForPlugin(Plugin);
    //Plugin.LoadState;
  end;
end;

function TPluginBuilder.InternalCreatePlugin(const AppPluginsId:Integer; const MakeActive:Boolean): TBasePlugin;
begin
 Result:=Self.NewPlugin(AppPluginsId);
 CreatePluginContainer(Result);
 Result.Container.Tab.Caption:=Result.Properties.PageTitle;

 if MakeActive then
 begin
   InitializePlugin(Result);
   Result.Actions.EnableHotKeys;
   FRibbon.ActiveTab:=Result.Container.Tab;
 end;
end;

function TPluginBuilder.NewPlugin(AppPluginsId: Integer): TBasePlugin;
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

function TPluginBuilder.CreatePluginById(const AppPluginsId:Integer): TBasePlugin;
begin
 if FPluginList.PluginExists(AppPluginsId) then
  begin
   FRibbon.ActiveTab:=FPluginList.PluginByID(AppPluginsId).Container.Tab;
   Result:=ActivePlugin;
  end
   else
  Result:=InternalCreatePlugin(AppPluginsId, True);
end;


function TPluginBuilder.CreatePluginByIdLazy(const PluginID:Integer): TBasePlugin;
begin
 if FPluginList.PluginExists(PluginID) then
   Result:=FPluginList.PluginByID(PluginID)
    else
   Result:=InternalCreatePlugin(PluginID, FPluginList.Count=0);
end;

procedure TPluginBuilder.CreatePluginContainer(Plugin:TBasePlugin);
var
 RibbonEvent:TdxRibbonEvent;
 PageEvent:TNotifyEvent;
 Tab:TdxRibbonTab;
begin
 RibbonEvent:=FRibbon.OnTabChanged;
 PageEvent:=FPageControl.OnChange;
 FPageControl.OnChange:=nil;
 FRibbon.OnTabChanged:=nil;
  try
   Tab:=FRibbon.Tabs.Add;
   Plugin.Container.Tab:=Tab;
   Plugin.Container.Tab.Tag:=NativeInt(Plugin);
   Plugin.Container.Sheet:=TcxTabSheet.Create(Plugin);
   Plugin.Container.Sheet.PageControl:=FPageControl;
   Plugin.Container.Sheet.Tag:=NativeInt(Plugin);
   Plugin.Parent:=Plugin.Container.Sheet;
   Plugin.Align:=alClient;
   Plugin.BeforeDestroy:=BeforePluginDestroy;
  finally
   FRibbon.OnTabChanged:=RibbonEvent;
   FPageControl.OnChange:=PageEvent;
  end;
end;

procedure TPluginBuilder.DeleteActivePlugin;
begin
 if Assigned(ActivePlugin) then
  FPluginList.Delete(FPluginList.IndexOf(ActivePlugin));
end;

procedure TPluginBuilder.DeletePluginByIndex(const Index: Integer);
begin
 FPluginList.Delete(Index);
end;

destructor TPluginBuilder.Destroy;
begin
  FCommandBuilder.Free;
  FPluginList.Free;
  inherited;
end;


function TPluginBuilder.GetActivePlugin: TBasePlugin;
begin
 if Assigned(FRibbon.ActiveTab) then
  Result:=TBasePlugin(FRibbon.ActiveTab.Tag)
   else
  Result:=nil;
end;

function TPluginBuilder.GetPluginType(const PluginType: Integer): TBasePluginClass;
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


procedure TPluginBuilder.ExecuteOpenPlugin(Sender:TObject);
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
