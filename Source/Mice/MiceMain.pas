unit MiceMain;


 // IMAGE_FILE_LARGE_ADDRESS_AWARE = $0020;
 // If the application has the IMAGE_FILE_LARGE_ADDRESS_AWARE
 // flag set in the image header, each 32-bit application receives 4 GB
 // of virtual address space in the WOW64 environment

  {$SetPEFlags $0020}

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Menus, Vcl.StdCtrls, cxButtons,
  cxPC,Vcl.ExtCtrls, dxRibbonStatusBar,  System.Actions,  Vcl.ActnList, Data.DB,
  cxGraphics, cxControls, dxBar, cxClasses, dxRibbon, dxStatusBar, cxLookAndFeels,
  cxLookAndFeelPainters, dxRibbonSkins, dxRibbonCustomizationForm,
  dxBarBuiltInMenu,
  DAC.XParams.Utils,
  DAC.XDataSet,
  DAC.XParams,
  DAC.History.Form,
  DAC.ConnectionMngr,
  DAC.ObjectModels.MiceUser,
  Common.Images,
  Common.StringUtils,
  Common.DateUtils,
  Common.ResourceStrings,
  Common.Config.ApplicationSettings,
  Plugin.Base,
  Plugin.Builder.Ribbon,
  Plugin.List,
  Mice.Report,
  Mice.ReportService,
  Common.Registry,
  Common.GlobalSettings,
  CustomControl.PluginTree, dxCore;



type
  TMiceMainForm = class(TForm)
    BarManager: TdxBarManager;
    TabAreaToolBar: TdxBar;
    bnClosePlugin: TdxBarButton;
    QuickAccessToolbar: TdxBar;
    Ribbon: TdxRibbon;
    StatusBar: TdxRibbonStatusBar;
    pgMain: TcxPageControl;
    ActionList: TActionList;
    acCloseActivePlugin: TAction;
    bnAbout: TdxBarButton;
    acAbout: TAction;
    dxBarSubItem1: TdxBarSubItem;
    bn2007Style: TdxBarButton;
    bn2013Style: TdxBarButton;
    bn2016Style: TdxBarButton;
    bn2010Style: TdxBarButton;
    procedure RibbonTabChanged(Sender: TdxCustomRibbon);
    procedure pgMainChange(Sender: TObject);
    procedure RibbonApplicationMenuClick(Sender: TdxCustomRibbon; var AHandled: Boolean);
    procedure BarManagerHandleKey(Sender: TObject; AKey: Word;  AShift: TShiftState; var AHandled: Boolean);
    procedure acCloseActivePluginExecute(Sender: TObject);
    procedure bn2007StyleClick(Sender: TObject);
    procedure bn2010StyleClick(Sender: TObject);
    procedure bn2013StyleClick(Sender: TObject);
    procedure bn2016StyleClick(Sender: TObject);
    procedure StatusBarMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure RibbonTabChanging(Sender: TdxCustomRibbon; ANewTab: TdxRibbonTab;
      var Allow: Boolean);
    procedure bnAboutClick(Sender: TObject);
  strict private
    FPluginBuilder:TPluginBuilder;
    FPluginTree:TPluginTree;
    FDestroyingPlugin:Boolean;
    function GetActivePlugin: TBasePlugin;
    procedure UpdateStatusBar;
    procedure UpdateTitle;
    procedure UpdateButtons;
    procedure UpdateAll;
    procedure OnPluginTreeDblClick(DataSet:TDataSet);
    procedure SaveState;
    procedure LoadState;
  protected
    procedure TryActivateTab(const TabIndex:Integer;var Handled:Boolean);
    procedure SelectNextTab(AForward:Boolean);
  public
    property ActivePlugin:TBasePlugin read GetActivePlugin;
    procedure ShowPluginTree;
    constructor Create(AOwner:TComponent); override;
    destructor Destroy; override;
  end;

var
  MiceMainForm: TMiceMainForm;

implementation

{$R *.dfm}

{ TMiceMainForm }

const
 ProviderName = 'spui_test @CurrentAppDialogsId=<AppDialogsId>, @AppCmdId=<d.id>';


procedure TMiceMainForm.acCloseActivePluginExecute(Sender: TObject);
begin
try
 Ribbon.BeginUpdate;
 try
  FDestroyingPlugin:=True;
  ActivePlugin.Free;
 finally
  FDestroyingPlugin:=False;
  UpdateAll;
  Ribbon.EndUpdate;
 end;
except on e:Exception do
 MessageBox(Handle,PChar('Неизвестная ошибка при закрытии плагина, которую я никак не могу поймать.'+#13+E.Message), PChar(S_COMMON_ERROR), MB_OK+MB_ICONERROR);
end;
end;

procedure TMiceMainForm.BarManagerHandleKey(Sender: TObject; AKey: Word; AShift: TShiftState; var AHandled: Boolean);
begin
 if ssCtrl in AShift then
   case AKey of
    VK_DOWN: ShowPluginTree;
    VK_TAB:SelectNextTab(ssShift in AShift);
    VK_F12: if (ssCtrl in AShift) then  TSQLHistoryForm.ShowHistory;
   end;
 if ssAlt in AShift then
 case AKey of
  49..57: TryActivateTab(AKey-49, AHandled);
 end;
end;

constructor TMiceMainForm.Create(AOwner: TComponent);
begin
  inherited;
  FPluginBuilder:=TPluginBuilder.Create(Self.Ribbon, Self.pgMain);
  FPluginTree:=TPluginTree.Create(Self);
  FPluginTree.OnDblClick:=OnPluginTreeDblClick;
  try
   FPluginTree.UpdateTree;
  except On E:Exception do
   MessageBox(Handle, PChar('PluginTree: '+E.Message),PChar(S_COMMON_ERROR),MB_OK+MB_ICONERROR);
  end;
  UpdateAll;
  Ribbon.ApplicationButton.Text:=S_COMMON_MAIN_MENU;
  FDestroyingPlugin:=False;
  LoadState;
end;

destructor TMiceMainForm.Destroy;
begin
  SaveState;
  FPluginBuilder.Free;
  inherited;
end;



procedure TMiceMainForm.bn2007StyleClick(Sender: TObject);
begin
 Ribbon.Style:=rs2007;
 pgMain.Properties.Style:=8;
end;

procedure TMiceMainForm.bn2010StyleClick(Sender: TObject);
begin
 Ribbon.Style:=rs2010;
 pgMain.Properties.Style:=8
end;

procedure TMiceMainForm.bn2013StyleClick(Sender: TObject);
begin
Ribbon.Style:=rs2013;
pgMain.Properties.Style:=0;
end;

procedure TMiceMainForm.bn2016StyleClick(Sender: TObject);
begin
 Ribbon.Style:=rs2016;
 pgMain.Properties.Style:=0;
end;


procedure TMiceMainForm.bnAboutClick(Sender: TObject);
begin
// ShowMessage(TStringUtils.StringCount('xexexe','xex',True).ToString);
end;

function TMiceMainForm.GetActivePlugin: TBasePlugin;
begin
  Result:=FPluginBuilder.ActivePlugin;
end;


procedure TMiceMainForm.OnPluginTreeDblClick(DataSet: TDataSet);
var
 AppPluginsId:Integer;
 Plugin:TBasePlugin;
begin
 try
  AppPluginsId:=DataSet.FieldByName('AppPluginsId').AsInteger;
  if GetKeyState(VK_SHIFT)>=0 then
   begin
    Plugin:=FPluginBuilder.CreatePluginById(AppPluginsId);
    Plugin.LoadState;
    if Plugin.Properties.RefreshAfterCreate then
      Plugin.RefreshDataSet;
   end
    else
   FPluginBuilder.CreatePluginByIdLazy(AppPluginsId).LoadState;

 finally
  UpdateAll;
 end;
end;

procedure TMiceMainForm.pgMainChange(Sender: TObject);
var
 Event:TdxRibbonEvent;
begin
if Assigned(pgMain.ActivePage) then
 begin
  Event:=Ribbon.OnTabChanged;
  Ribbon.OnTabChanged:=nil;
  Ribbon.ActiveTab:=FPluginBuilder.ActivePlugin.Container.Tab;
  Ribbon.OnTabChanged:=Event;
  UpdateAll;
 end;
end;

procedure TMiceMainForm.RibbonApplicationMenuClick(Sender: TdxCustomRibbon; var AHandled: Boolean);
begin
 AHandled:=True;
 ShowPluginTree;
end;

procedure TMiceMainForm.RibbonTabChanged(Sender: TdxCustomRibbon);
var
 Event:TNotifyEvent;
begin
if Assigned(Ribbon.ActiveTab) then
 begin
  Event:=pgMain.OnChange;
  pgMain.OnChange:=nil;
  pgMain.ActivePage:=FPluginBuilder.ActivePlugin.Container.Sheet;
  FPluginBuilder.InitializePlugin(ActivePlugin);
  pgMain.OnChange:=Event;
  UpdateAll;
  if Assigned(ActivePlugin) then
    ActivePlugin.Actions.EnableHotKeys;
 end;
end;

procedure TMiceMainForm.RibbonTabChanging(Sender: TdxCustomRibbon;  ANewTab: TdxRibbonTab; var Allow: Boolean);
begin
 if Assigned(ActivePlugin) and (FDestroyingPlugin=False) then
  ActivePlugin.Actions.DisableHotkeys;
end;

procedure TMiceMainForm.SaveState;
begin
 TProjectRegistry.DefaultInstance.WriteString(TProjectRegistry.DefaultInstance.DialogPath(ClassName),RegKeyLastPath,FPluginTree.PluginTreeList.Path);
 TProjectRegistry.DefaultInstance.SaveForm(ClassName, Self);
end;

procedure TMiceMainForm.LoadState;
begin
 TProjectRegistry.DefaultInstance.LoadForm(ClassName,False, True, Self);
 FPluginTree.PluginTreeList.Path:=TProjectRegistry.DefaultInstance.ReadStringDef(TProjectRegistry.DefaultInstance.DialogPath(ClassName),RegKeyLastPath,'');
end;


procedure TMiceMainForm.SelectNextTab(AForward: Boolean);
var
 NextIndex:Integer;
begin
 if Assigned(Ribbon.ActiveTab) then
  begin
   if not AForward then
    begin
     NextIndex:=Ribbon.ActiveTab.Index+1;
     if NextIndex<=Ribbon.Tabs.Count-1 then
      Ribbon.ActiveTab:=Ribbon.Tabs[NextIndex]
       else
      Ribbon.ActiveTab:=Ribbon.Tabs[0];
    end
   else
    begin
     NextIndex:=Ribbon.ActiveTab.Index-1;
     if NextIndex>=0 then
      Ribbon.ActiveTab:=Ribbon.Tabs[NextIndex]
       else
      Ribbon.ActiveTab:=Ribbon.Tabs[Ribbon.TabCount-1]
    end;
  end;
end;

procedure TMiceMainForm.ShowPluginTree;
begin
 FPluginTree.ShowModal;
end;


procedure TMiceMainForm.StatusBarMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
if ssCtrl in Shift then
 TSQLHistoryForm.ShowHistory;
end;

procedure TMiceMainForm.TryActivateTab(const TabIndex: Integer; var Handled:Boolean);
begin
 Handled:=TabIndex<Ribbon.TabCount;
 if Handled then
  Ribbon.ActiveTab:=Ribbon.Tabs[TabIndex];
end;

procedure TMiceMainForm.UpdateAll;
begin
 UpdateStatusBar;
 UpdateTitle;
 UpdateButtons;
 StatusBar.Panels[1].Text:='Bar items count: '+BarManager.ItemCount.ToString;
end;

procedure TMiceMainForm.UpdateButtons;
begin
 acCloseActivePlugin.Enabled:=Ribbon.TabCount>0;
end;

procedure TMiceMainForm.UpdateStatusBar;
begin
if Assigned(ActivePlugin) then
  StatusBar.Panels[0].Text:=Format(S_ROWS_FMT,[ActivePlugin.DataSet.RecordCount])
   else
  StatusBar.Panels[0].Text:='';
end;

procedure TMiceMainForm.UpdateTitle;
begin
 if Assigned(ActivePlugin) then
  begin
   Ribbon.DocumentName:=ApplicationSettings.ProjectName +' - '+ActivePlugin.Properties.PageTitle + ' ('+TMiceUser.CurrentUser.FullName+')';
   Application.Title:=Ribbon.DocumentName;
   Caption:=Ribbon.DocumentName;
  end
   else
  begin
   Ribbon.DocumentName:= ApplicationSettings.ProjectName+' ('+TMiceUser.CurrentUser.FullName+')';
   Application.Title:=Ribbon.DocumentName;
   Caption:=Ribbon.DocumentName;
  end;

end;

end.
