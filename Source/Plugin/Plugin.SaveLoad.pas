unit Plugin.SaveLoad;

interface
 uses Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
      System.Classes, Data.DB,
      Common.Registry,
      Plugin.Properties,
      Plugin.Container,
      Plugin.SideTreeFilter,
      CustomControl.Interfaces,
      Vcl.ExtCtrls,
      DAC.XParams,
      DAC.XDataSet;

 type
   TPluginSaveLoad = class
    private
     FProperties:TPluginProperties;
     FContainer:TPluginContainer;
     FSideTreeFilter: TSideTreeFilter;
     FParams: TxParams;
     FSalt: string;
     FRightPanelSize: Integer;
     FBottomPanelSize: Integer;
     procedure SaveFilters;
     procedure LoadFilters;
     procedure WriteRegistry;
     procedure ReadRegistry;
     function GetRegistryPath: string;
    public
     constructor Create(Properties:TPluginProperties);
     destructor Destroy; override;
     property Container:TPluginContainer read FContainer write FContainer;
     property RightPanelSize:Integer read FRightPanelSize write FRightPanelSize;
     property BottomPanelSize:Integer read FBottomPanelSize write FBottomPanelSize;
     property Salt:string read FSalt write FSalt;
     property RegistryPath:string read GetRegistryPath;
     procedure SaveDialogPanel(Panel:TPanel);
     procedure LoadState;
     procedure SaveState;
   end;
implementation

const
 DEFAULT_SIDETREE_WIDTH = 185;
 DEFAULT_PANEL_RIGHT_SIZE = 250;
 DEFAULT_PANEL_BOTTOM_SIZE = 250;

constructor TPluginSaveLoad.Create(Properties: TPluginProperties);
begin
 FProperties:=Properties;
 FSideTreeFilter:=Properties.TreeFilter;
 FParams:=TxParams.Create;
 RightPanelSize:=DEFAULT_PANEL_RIGHT_SIZE;
 BottomPanelSize:=DEFAULT_PANEL_BOTTOM_SIZE;
end;

destructor TPluginSaveLoad.Destroy;
begin
  FParams.Free;
  inherited;
end;

function TPluginSaveLoad.GetRegistryPath: string;
begin
 Result:= RegistryPathPlugins+FProperties.Title+'@AppPluginsId='+FProperties.AppPluginsId.ToString+Salt;
end;

procedure TPluginSaveLoad.LoadFilters;
var
 x:Integer;
begin
 for x:=0 to FContainer.FilterControls.Count-1 do
   if Supports(FContainer.FilterControls[x],ICanSaveLoadState) then
    (FContainer.FilterControls[x] as ICanSaveLoadState).LoadState(FParams);
end;

procedure TPluginSaveLoad.LoadState;
var
 AWidth:Integer;
begin
 ReadRegistry;
 LoadFilters;
 if FProperties.SideTreeEnabled then
  begin
   (FSideTreeFilter as ICanSaveLoadState).LoadState(FParams);
   AWidth:=TProjectRegistry.DefaultInstance.ReadIntDef(RegistryPath,'SideTreeWidth', FSideTreeFilter.Width);
   if (AWidth<100) or (AWidth>1400) then
    AWidth:=DEFAULT_SIDETREE_WIDTH;

   FSideTreeFilter.Parent.Width:=AWidth;
  end;

//  RightPanelSize:=TProjectRegistry.DefaultInstance.ReadIntDef(RegistryPath,'RightPanelSize', DEFAULT_PANEL_RIGHT_SIZE);
//  BottomPanelSize:=TProjectRegistry.DefaultInstance.ReadIntDef(RegistryPath,'BottomPanelSize', DEFAULT_PANEL_BOTTOM_SIZE);
end;

procedure TPluginSaveLoad.ReadRegistry;
begin
 FParams.AsJson:=TProjectRegistry.DefaultInstance.ReadStringDef(RegistryPath,'Params','');
end;

procedure TPluginSaveLoad.SaveDialogPanel(Panel: TPanel);
begin
 if Assigned(Panel) then
  begin
   RightPanelSize:=Panel.Width;
   BottomPanelSize:=Panel.Height;
  end;
end;

procedure TPluginSaveLoad.SaveFilters;
var
 x:Integer;
begin
 for x:=0 to FContainer.FilterControls.Count-1 do
  if Supports(FContainer.FilterControls[x],ICanSaveLoadState) then
    (FContainer.FilterControls[x] as ICanSaveLoadState).SaveState(FParams);

 (FSideTreeFilter as ICanSaveLoadState).SaveState(FParams);
end;


procedure TPluginSaveLoad.SaveState;
begin
 SaveFilters;
 WriteRegistry;
end;

procedure TPluginSaveLoad.WriteRegistry;
begin
 if FParams.Count>0 then
  TProjectRegistry.DefaultInstance.WriteString(RegistryPath,'Params',FParams.AsJson);

 if FProperties.SideTreeEnabled then
  TProjectRegistry.DefaultInstance.WriteInt(RegistryPath,'SideTreeWidth', FSideTreeFilter.Width);

 if RightPanelSize<> DEFAULT_PANEL_RIGHT_SIZE then
  TProjectRegistry.DefaultInstance.WriteInt(RegistryPath,'RightPanelSize', RightPanelSize);

 if BottomPanelSize<>DEFAULT_PANEL_BOTTOM_SIZE then
  TProjectRegistry.DefaultInstance.WriteInt(RegistryPath,'BottomPanelSize', BottomPanelSize);

end;

end.
