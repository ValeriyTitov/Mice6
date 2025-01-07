unit Plugin.CommandBuilder.Ribbon;

interface
 uses Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  cxControls, cxLookAndFeels, cxLookAndFeelPainters, dxBar,
  cxClasses, dxRibbon, dxStatusBar,Vcl.Menus, Vcl.StdCtrls, cxButtons,
  dxBarBuiltInMenu, cxPC,Vcl.ExtCtrls,  dxBarExtItems, cxRadioGroup,
  cxBarEditItem, cxDateUtils,cxCalendar, Data.DB,
  Dialogs,
  Plugin.Base,
  DAC.XDataSet,
  DAC.XDataSetHelper,
  DAC.XParams.Utils,
  Common.Images,
  Common.ResourceStrings,
  Common.VariantComparator,

  CustomControl.MiceActionList,
  CustomControl.Interfaces,
  CustomControl.MiceAction,
  CustomControl.Bar.MiceTextEdit,
  CustomControl.Bar.MiceDateEdit,
  CustomControl.Bar.MiceDateRangeEdit,
  CustomControl.Bar.MiceLargeButton,
  CustomControl.Bar.MiceButton,
  CustomControl.Bar.MiceCheckBoxButton,
  CustomControl.Bar.MiceDropDown,
  CustomControl.Bar.MiceClientEditor,
  CustomControl.Bar.MiceSubAccountEditor,
  CustomControl.Bar.MiceValuePicker,
  CustomControl.Bar.MiceOptionBox,
  CustomControl.Bar.MiceStatic,
  CustomControl.Bar.MiceTreeViewCombo,
  CustomControl.MiceBalloons,
  CustomControl.Bar.MiceFileButton;


type
 TPluginCommandBuilder = class
   private
    FDataSet:TDataSet;
    FPlugin:TBasePlugin;
    FItem:TdxBarItem;
    FOnCreatePluginActionExecute: TNotifyEvent;
    FGridPopupMenu: TdxBarPopupMenu;
    procedure UpdateButtonStyle;
    procedure InternalCreateFilter;
    procedure InternalCreateCommand;
    procedure ProcessDataSet;
    procedure FindGroupAndCaption(var AGroupName, ASubMenuName: string; const Location:string);
    procedure CreateAction(const ACaption:string);
    procedure CreateNewAction(const ACaption:string);
    procedure SetPluginMethod(const AName:string);
    procedure CreateOnLocation(Group: TdxRibbonTabGroup; const ASubMenuName:string);
    procedure CreateItemLink(const Location,Caption:string; IsAction:Boolean);
    procedure CreateDocFlow;
    procedure FindDblClickAction;
    procedure EnabledPluginInformationDialog;
    procedure CreateMenuItem;
    function FindSubMenu(Group: TdxRibbonTabGroup; const ASubMenuName:string):TdxBarSubItem;
    function CreateDocFlowMainButton(ButtonType:Integer; ItemLinks:TdxBarItemLinks):TMiceBarLargeButton;
   public
    procedure LoadFromDataSet(DataSet:TDataSet; Plugin:TBasePlugin);
    procedure LoadForPlugin(Plugin:TBasePlugin);
    property OnCreatePluginActionExecute:TNotifyEvent read FOnCreatePluginActionExecute write FOnCreatePluginActionExecute;
    property GridPopupMenu:TdxBarPopupMenu read FGridPopupMenu write FGridPopupMenu;
 end;

implementation

const
  iTypeCommonCommand   = 6;
  iTypeCommand         = 7;
  iTypeCommonFilter    = 8;
  iTypeFilter          = 9;

  DOCFLOW_BUTTON_PUSH = 0;
  DOCFLOW_BUTTON_ROLLBACK = 1;
  DOCFLOW_BUTTON_FLOW = 2;



{ TCommandBuilder }



procedure TPluginCommandBuilder.CreateNewAction( const ACaption:string);
var
 Action:TMiceAction;
begin
 Action:=FPlugin.Actions.CreateAction(FDataSet.FieldByName('Name').AsString);
 Action.LoadFromDataSet(FDataSet);
 Action.ActivityCondition.LoadFromDataSet(FDataSet);
 Action.Caption:=ACaption;
 Action.Enabled:=Action.ActivityCondition.AlwaysEnabled;
 if (Action.ActionType=atExecuteDialog) and (Action.DialogPlacement>0) then
  Action.AutoCheck:=True;

 case Action.ActionType of
  atNone:                Action.OnExecute:=nil;
  atExecuteDialog:       Action.OnExecute:=FPlugin.MethodExecuteDialog;
  atExecuteScript:       Action.OnExecute:=FPlugin.MethodExecuteScript;
  atExecuteOpenPlugin:   Action.OnExecute:=OnCreatePluginActionExecute;
  atExecutePluginMethod: ;
  atExecuteStoredProc:   Action.OnExecute:=FPlugin.MethodExecuteStoredProc;
  atExecuteAppTemplate:  Action.OnExecute:=FPlugin.MethodExecuteAppTemplate;
  atExecuteOpenFile:     Action.OnExecute:=FPlugin.MethodOpenFile;
  atPrintReport:         Action.OnExecute:=FPlugin.MethodPrintReport;
   else
  Action.ActivityCondition.AlwaysEnabled:=False;
 end;

 FPlugin.Container.CommandControls.Add(FItem);

 FItem.Action:=Action;
end;


procedure TPluginCommandBuilder.CreateAction(const ACaption: string);
const
 atPluginMethod=4;
begin
 if (FDataSet.FieldByName('ActionType').AsInteger=atPluginMethod) then
  SetPluginMethod(FDataSet.FieldByName('PluginMethod').AsString)
   else
  CreateNewAction(ACaption);
end;

procedure TPluginCommandBuilder.CreateDocFlow;
var
 RibbonGroup: TdxRibbonTabGroup;
begin
 RibbonGroup:=FPlugin.Container.CreateRibbonGroup(S_DOCFLOW_GROUP_NAME);

 FPlugin.DocFlowManager.RollBackButton:=CreateDocFlowMainButton(DOCFLOW_BUTTON_ROLLBACK, RibbonGroup.ToolBar.ItemLinks);
 FPlugin.DocFlowManager.PushButton:=CreateDocFlowMainButton(DOCFLOW_BUTTON_PUSH, RibbonGroup.ToolBar.ItemLinks);
 FPlugin.DocFlowManager.FlowButton:=CreateDocFlowMainButton(DOCFLOW_BUTTON_FLOW, RibbonGroup.ToolBar.ItemLinks);
 FPlugin.DocFlowManager.PopulateFlowButton;
end;

function TPluginCommandBuilder.CreateDocFlowMainButton(ButtonType: Integer; ItemLinks:TdxBarItemLinks): TMiceBarLargeButton;
var
 Link: TdxBarItemLink;
begin
 Result:=TMiceBarLargeButton.Create(FPlugin);
 Result.Plugin:= FPlugin;
 Result.UpdateStyle(TdxBarButtonStyle.bsDropDown);
 Result.Loading:=False;
 Result.PaintStyle:=psCaptionGlyph;
 Result.Width:=64;
 Result.AutoRefresh:=True;
 Result.DropDownEnabled:=True;
 Result.PaintStyle:=psCaptionGlyph;
 Result.DropDownMenu:=TdxBarPopupMenu.Create(Result);
 Link := ItemLinks.Add;
 Link.Item := Result;
 Link.Item.Category:=0;


 if ButtonType=DOCFLOW_BUTTON_PUSH then
  begin
   Result.ImageIndex:=IMAGEINDEX_ACTION_DOCFLOW_PUSH;
   Result.LargeImageIndex:=IMAGEINDEX_ACTION_DOCFLOW_PUSH;
   Result.Caption:=S_DOCFLOW_PUSH_BUTTON_CAPTION;
   Result.Hint:=S_DOCFLOW_PUSH_BUTTON_HINT;
   Result.Name:='bnDocFlowPush';
  end
  else
 if ButtonType=DOCFLOW_BUTTON_ROLLBACK then
  begin
   Result.ImageIndex:=IMAGEINDEX_ACTION_DOCFLOW_ROLLBACK;
   Result.LargeImageIndex:=IMAGEINDEX_ACTION_DOCFLOW_ROLLBACK;
   Result.Caption:=S_DOCFLOW_ROLLBACK_BUTTON_CAPTION;
   Result.Hint:=S_DOCFLOW_ROLLBACK_BUTTON_HINT;
   Result.Name:='bnDocFlowRollBack';
  end
  else
 if ButtonType=DOCFLOW_BUTTON_FLOW then
  begin
   Result.ImageIndex:=IMAGEINDEX_ACTION_DOCFLOW_FLOW;
   Result.LargeImageIndex:=IMAGEINDEX_ACTION_DOCFLOW_FLOW;
   Result.Caption:=S_DOCFLOW_PROPERTIES_BUTTON_CAPTION;
   Result.Hint:=S_DOCFLOW_PROPERTIES_BUTTON_HINT;
   Result.Name:='bnDocFlowFlow';
  end;
end;

procedure TPluginCommandBuilder.CreateItemLink(const Location,Caption:string; IsAction:Boolean);
var
 RibbonGroup: TdxRibbonTabGroup;
 AGroupName:string;
 ASubMenuName:string;
begin
  FindGroupAndCaption(AGroupName, ASubMenuName, Location);
  FItem.Caption:=Caption;
  RibbonGroup:=FPlugin.Container.CreateRibbonGroup(AGroupName);
  CreateOnLocation(RibbonGroup,ASubMenuName);

  if IsAction then
   CreateAction(Caption)
    else
   FPlugin.Container.FilterControls.Add(FItem);
end;


procedure TPluginCommandBuilder.CreateMenuItem;
var
 Button:TMiceBarButton;
begin
 Button:=TMiceBarButton.Create(GridPopupMenu);
 Button.Action:=FItem.Action;
 Button.Caption:=FItem.Caption;
// Button.ButtonStyle:=bsChecked;
// Button.CloseSubMenuOnClick:=False;
// Button.Down:=Column.Visible;
// Button.OnClick:=ToggleColumnVisible;

 GridPopupMenu.ItemLinks.Add(Button);
end;

procedure TPluginCommandBuilder.CreateOnLocation(Group: TdxRibbonTabGroup; const ASubMenuName: string);
var
 Link: TdxBarItemLink;
 ASubMenu:TdxBarSubItem;
begin
  Link := Group.ToolBar.ItemLinks.Add;
  if (ASubMenuName.Trim.IsEmpty=False) then
   begin
    ASubMenu:=FindSubMenu(Group,ASubMenuName);
    if not Assigned(ASubMenu) then
     begin
      ASubMenu:=TdxBarSubItem.Create(FPlugin);
      ASubMenu.Caption:=ASubMenuName;
      ASubMenu.ImageIndex:=FDataSet.FieldByName('ImageIndex').AsInteger;
      Link.Item:=ASubMenu;
     end;

    Link:=ASubMenu.ItemLinks.Add;
   end;
  Link.Item := FItem;
  Link.Item.Category:=0;
end;


procedure TPluginCommandBuilder.EnabledPluginInformationDialog;
var
 InfoButton:TMiceBarLargeButton;
 Link: TdxBarItemLink;
begin
 if FPlugin.Container.Tab.Groups.Count>0  then
  begin
   Link:=FPlugin.Container.Tab.Groups[0].ToolBar.ItemLinks.Add;
   InfoButton:=TMiceBarLargeButton.Create(FPlugin);
   InfoButton.Plugin:= FPlugin;
   InfoButton.UpdateStyle(bsDefault);
   InfoButton.Loading:=False;
   InfoButton.AutoGrayScale:=False;
   InfoButton.Action:=FPlugin.Actions.ActionByName(ACTION_NAME_PLUGIN_INFORMATION);
   Link.Item:=InfoButton;
   Link.Visible:=False;
 end;
end;


procedure TPluginCommandBuilder.SetPluginMethod(const AName:string);
var
 Action:TMiceAction;
 ImageIndex:Integer;
begin
 Action:=FPlugin.Actions.FindAction(AName);
 if Assigned(Action) then
  begin
   ImageIndex:=Action.ImageIndex;
   FItem.Action:=Action;
   Action.LoadFromDataSet(FDataSet);
   if ImageIndex>0 then
    Action.ImageIndex:=ImageIndex;

   FPlugin.Container.MethodControls.Add(FItem);
 end
  else
   TMiceBalloons.ShowBalloon('Failed','Plugin method not found: '+AName,0);
end;


procedure TPluginCommandBuilder.UpdateButtonStyle;
var
 AAction:TMiceAction;
begin
 if (FItem is TdxBarCustomButton) and (FItem.Action is TMiceAction) then
  begin
   AAction:=FItem.Action as TMiceAction;
   if (AAction.ActionType=atExecuteDialog) and (AAction.DialogPlacement>0) then
    (FItem as TdxBarCustomButton).ButtonStyle := TdxBarButtonStyle.bsChecked;
  end;
end;

procedure TPluginCommandBuilder.FindDblClickAction;
var
 Action:TMiceAction;
begin
if FPlugin.Properties.DefaultDoubleClickActionAppCmdId>0 then
 for Action in FPlugin.Actions.Values do
   if Action.ID=FPlugin.Properties.DefaultDoubleClickActionAppCmdId then
    begin
     FPlugin.Properties.DoubleClickAction:=Action;
     Exit;
    end;

if (FPlugin.Properties.DefaultDoubleClickActionAppCmdId>0) and not Assigned(FPlugin.Properties.DoubleClickAction) then
  TMiceBalloons.ShowBalloon('Failed',Format('Default action not found : %d',[FPlugin.Properties.DefaultDoubleClickActionAppCmdId]),0);


if not Assigned(FPlugin.Properties.DoubleClickAction) then
 for Action in FPlugin.Actions.Values do
  if (Action.ActionType=TActionType.atExecutePluginMethod) and (Action.PluginMethod=ACTION_NAME_EDIT_RECORD) then
   begin
    FPlugin.Properties.DoubleClickAction:=Action;
    Exit;
   end;

end;

procedure TPluginCommandBuilder.FindGroupAndCaption(var AGroupName, ASubMenuName: string; const Location:string);
var
 List:TStringList;
resourcestring
 S_DEFAULT_GROUP_NAME='Common';
begin
 List:=TStringList.Create;
 try
  List.StrictDelimiter:=True;
  List.Delimiter:='\';
  List.DelimitedText:=Location;
  if List.Count=1 then
    AGroupName:=List[0]
     else
  if List.Count>=2 then
   begin
    AGroupName:=List[0];
    ASubMenuName:=List[1];
   end;
  if AGroupName.Trim ='' then
   AGroupName:=S_DEFAULT_GROUP_NAME;
 finally
  List.Free;
 end;

end;


function TPluginCommandBuilder.FindSubMenu(Group: TdxRibbonTabGroup;  const ASubMenuName:string): TdxBarSubItem;
var
 x:Integer;
begin
 for x:=0 to Group.ToolBar.ItemLinks.Count-1 do
 if (Group.ToolBar.ItemLinks[x].Item is TdxBarSubItem) then
  begin
   Result:=Group.ToolBar.ItemLinks[x].Item as TdxBarSubItem;
   if (Result.Caption=ASubMenuName) then
    Exit(Result);
  end;
  Result:=nil;
end;

procedure TPluginCommandBuilder.InternalCreateCommand;
var
 Style:Integer;
const
 STYLE_STANDART_LARGE_BUTTON = 0;
begin
 Style:=TMiceBarCheckBoxButton.FindStyle(FDataSet.FieldByName('InitString').AsString);

 if Style =  STYLE_STANDART_LARGE_BUTTON then
  FItem:=TMiceBarLargeButton.CreateDefault(FPlugin,FDataSet,bsDefault)
   else
  FItem:=TMiceBarButton.CreateDefault(FPlugin,FDataSet,bsDefault);

 CreateItemLink(FDataSet.FieldByName('Location').AsString, FDataSet.FieldByName('Caption').AsString, True);

 UpdateButtonStyle;
 if (FDataSet.FieldByName('AppearsOn').AsInteger>0) and Assigned(GridPopupMenu) then
  CreateMenuItem;
end;

procedure TPluginCommandBuilder.InternalCreateFilter;
begin
 case FDataSet.FieldByName('CommandType').AsInteger of
   0: FItem:=TMiceBarCheckBoxButton.CreateDefault(FPlugin,FDataSet);
   1: FItem:=TMiceBarTextEdit.CreateDefault(FPlugin,FDataSet);
   2: FItem:=TMiceBarDropDown.CreateDefault(FPlugin,FDataSet);
   3: FItem:=TMiceBarOptionBox.CreateDefault(FPlugin,FDataSet);
   4: FItem:=TMiceBarDateEdit.CreateDefault(FPlugin,FDataSet);
   5: FItem:=TMiceBarDateRangeEdit.CreateDefault(FPlugin,FDataSet);
   6: FItem:=TMiceBarStatic.CreateDefault(FPlugin,FDataSet);
   7: FItem:=TMiceBarTreeViewCombo.CreateDefault(FPlugin,FDataSet);
   8: FItem:=TMiceBarFileButton.CreateDefault(FPlugin,FDataSet);
{
   9: FItem:=TMiceBarSubAccountEditor.CreateDefault(FPlugin,FDataSet);
   10: FItem:=TMiceBarSubAccountEditor.CreateDefault(FPlugin,FDataSet);
   11: FItem:=TMiceBarClientEditor.CreateDefault(FPlugin,FDataSet);
   12: FItem:=CreateSubMenuOrCombo;
   13: FItem:=CreateSubMenuOrCombo;
   14: FItem:=TMiceBarValuePicker.CreateDefault(FPlugin,FDataSet);
   15: FItem:=TMiceBarSubAccountEditor.CreateDefault(FPlugin,FDataSet);
   16: FItem:=TMiceBarLargeButton.CreateDefault(FPlugin,FDataSet); //LargeButton
   }
    else
    FItem:=nil;
 end;

 if Assigned(FItem) then
   CreateItemLink(FDataSet.FieldByName('Location').AsString, FDataSet.FieldByName('Caption').AsString, False);
end;

procedure TPluginCommandBuilder.LoadForPlugin(Plugin:TBasePlugin);
var
 Tmp:TxDataSet;
begin
 Tmp:=TxDataSet.Create(nil);
 try
  Tmp.ProviderName:='spui_AppGetPluginCommands';
  Tmp.SetParameter('AppPluginsId',Plugin.Properties.AppPluginsId);
  Tmp.Source:='Plugin.CommandBuilder';
  Tmp.Open;
  LoadFromDataSet(Tmp, Plugin);
 finally
   Tmp.Free;
 end;
end;

procedure TPluginCommandBuilder.LoadFromDataSet(DataSet: TDataSet; Plugin:TBasePlugin);
begin
 FPlugin:=Plugin;
 FDataSet:=DataSet;
  try
   FPlugin.Container.Tab.Ribbon.BeginUpdate;
   FDataSet.DisableControls;
   FDataSet.First;
   ProcessDataSet;
   if FPlugin.Properties.DocFlow then
    CreateDocFlow;
   FindDblClickAction;
   EnabledPluginInformationDialog;
 finally
  FPlugin.Container.Tab.Ribbon.EndUpdate;
  FPlugin:=nil;
  FDataSet:=nil;
 end;
end;


procedure TPluginCommandBuilder.ProcessDataSet;
var
 iType:Integer;
begin
 while not FDataSet.Eof do
  begin
   try
    iType:=FDataSet.FieldByName('iType').AsInteger;
    if (iType=iTypeCommonFilter)or (iType=iTypeFilter) then
     InternalCreateFilter
      else
     InternalCreateCommand;
    FItem.Tag:=FDataSet.FieldByName('AppCmdId').AsInteger;
   except on E:Exception do
    MessageBox(FPlugin.Handle,PChar(E.Message), PChar(S_COMMON_ERROR), MB_OK+MB_ICONSTOP);
   end;
  FDataSet.Next;
 end;
end;


end.
