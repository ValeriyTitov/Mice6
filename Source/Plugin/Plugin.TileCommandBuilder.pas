unit Plugin.TileCommandBuilder;

interface
 uses Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  cxControls, cxLookAndFeels, cxLookAndFeelPainters, dxBar,
  cxClasses,  dxStatusBar,Vcl.Menus, Vcl.StdCtrls, cxButtons,
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
  Common.LookAndFeel,

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
 TPluginTileCommandBuilder = class
   private
    FDataSet:TDataSet;
    FPlugin:TBasePlugin;
    FOnCreatePluginActionExecute: TNotifyEvent;
    procedure UpdateButtonStyle(Item:TdxBarItem);
    procedure InternalCreateFilter;
    procedure InternalCreateCommand;
    procedure ProcessDataSet;
    procedure FindGroupAndCaption(var AGroupName, ASubMenuName: string; const Location:string);
    procedure CreateAction(Item:TdxBarItem; const ACaption:string);
    procedure CreateNewAction(Item:TdxBarItem; const ACaption:string);
    procedure SetPluginMethod(Item:TdxBarItem; const AName:string);
    procedure CreateOnLocation(Item:TdxBarItem; Group: TdxBar; const ASubMenuName:string);
    procedure CreateItemLink(Item:TdxBarItem; const Location,Caption:string; IsAction:Boolean);
    procedure CreateDocFlow;
    procedure FindDblClickAction;
    function FindSubMenu(Group: TdxBar; const ASubMenuName:string):TdxBarSubItem;
    function CreateDocFlowMainButton(ButtonType:Integer; ItemLinks:TdxBarItemLinks):TMiceBarLargeButton;
   public
    procedure LoadFromDataSet(DataSet:TDataSet; Plugin:TBasePlugin);
    procedure LoadForPlugin(Plugin:TBasePlugin);
    property OnCreatePluginActionExecute:TNotifyEvent read FOnCreatePluginActionExecute write FOnCreatePluginActionExecute;
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



procedure TPluginTileCommandBuilder.CreateNewAction(Item: TdxBarItem; const ACaption:string);
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

 FPlugin.Container.CommandControls.Add(Item);

 Item.Action:=Action;
end;


procedure TPluginTileCommandBuilder.CreateAction(Item: TdxBarItem; const ACaption: string);
const
 atPluginMethod=4;
begin
 if (FDataSet.FieldByName('ActionType').AsInteger=atPluginMethod) then
  SetPluginMethod(Item, FDataSet.FieldByName('PluginMethod').AsString)
   else
  CreateNewAction(Item, ACaption);
end;

procedure TPluginTileCommandBuilder.CreateDocFlow;
var
 Bar: TdxBar;
begin
 Bar:=FPlugin.Container.CreateToolBar(S_DOCFLOW_GROUP_NAME);

 FPlugin.DocFlowManager.RollBackButton:=CreateDocFlowMainButton(DOCFLOW_BUTTON_ROLLBACK, Bar.ItemLinks);
 FPlugin.DocFlowManager.PushButton:=CreateDocFlowMainButton(DOCFLOW_BUTTON_PUSH, Bar.ItemLinks);
 FPlugin.DocFlowManager.FlowButton:=CreateDocFlowMainButton(DOCFLOW_BUTTON_FLOW, Bar.ItemLinks);
 FPlugin.DocFlowManager.PopulateFlowButton;
end;

function TPluginTileCommandBuilder.CreateDocFlowMainButton(ButtonType: Integer; ItemLinks:TdxBarItemLinks): TMiceBarLargeButton;
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

  Result.AutoGrayScale:=False;
  Result.Style:=DefaultLookAndFeel.StyleBarItem;
end;

procedure TPluginTileCommandBuilder.CreateItemLink(Item:TdxBarItem; const Location,Caption:string; IsAction:Boolean);
var
 Bar: TdxBar;
 AGroupName:string;
 ASubMenuName:string;
begin
  FindGroupAndCaption(AGroupName, ASubMenuName, Location);
  Item.Caption:=Caption;
  Bar:=FPlugin.Container.CreateToolBar(AGroupName);
  CreateOnLocation(Item,Bar,ASubMenuName);

  if IsAction then
   CreateAction(Item, Caption)
    else
   FPlugin.Container.FilterControls.Add(Item);
end;



procedure TPluginTileCommandBuilder.CreateOnLocation(Item: TdxBarItem; Group: TdxBar; const ASubMenuName: string);
var
 Link: TdxBarItemLink;
 ASubMenu:TdxBarSubItem;
begin
  Link := Group.ItemLinks.Add;
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
  Link.Item := Item;
  Link.Item.Category:=0;
end;


procedure TPluginTileCommandBuilder.SetPluginMethod(Item: TdxBarItem; const AName:string);
var
 Action:TMiceAction;
 ImageIndex:Integer;
begin
 Action:=FPlugin.Actions.FindAction(AName);
 if Assigned(Action) then
  begin
   ImageIndex:=Action.ImageIndex;
   Item.Action:=Action;
   Action.LoadFromDataSet(FDataSet);
   if ImageIndex>0 then
    Action.ImageIndex:=ImageIndex;

   FPlugin.Container.MethodControls.Add(Item);
 end
  else
   TMiceBalloons.ShowBalloon('Failed','Plugin method not found: '+AName,0);
end;


procedure TPluginTileCommandBuilder.UpdateButtonStyle(Item: TdxBarItem);
var
 AAction:TMiceAction;
begin
 if (Item is TdxBarCustomButton) and (Item.Action is TMiceAction) then
  begin
   AAction:=Item.Action as TMiceAction;
   if (AAction.ActionType=atExecuteDialog) and (AAction.DialogPlacement>0) then
    (Item as TdxBarCustomButton).ButtonStyle := TdxBarButtonStyle.bsChecked;
  end;
  Item.Style:=DefaultLookAndFeel.StyleBarItem;
end;

procedure TPluginTileCommandBuilder.FindDblClickAction;
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

procedure TPluginTileCommandBuilder.FindGroupAndCaption(var AGroupName, ASubMenuName: string; const Location:string);
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


function TPluginTileCommandBuilder.FindSubMenu(Group: TdxBar;  const ASubMenuName:string): TdxBarSubItem;
var
 x:Integer;
begin
 for x:=0 to Group.ItemLinks.Count-1 do
 if (Group.ItemLinks[x].Item is TdxBarSubItem) then
  begin
   Result:=Group.ItemLinks[x].Item as TdxBarSubItem;
   if (Result.Caption=ASubMenuName) then
    Exit(Result);
  end;
  Result:=nil;
end;

procedure TPluginTileCommandBuilder.InternalCreateCommand;
var
 Item:TdxBarItem;
 Style:Integer;
begin
 Style:=TMiceBarCheckBoxButton.FindStyle(FDataSet.FieldByName('InitString').AsString);
  case Style of
   0:Item:=TMiceBarLargeButton.CreateDefault(FPlugin,FDataSet,bsDefault);
      else
     Item:=TMiceBarButton.CreateDefault(FPlugin,FDataSet,bsDefault);
  end;

 CreateItemLink(Item, FDataSet.FieldByName('Location').AsString, FDataSet.FieldByName('Caption').AsString, True);
 UpdateButtonStyle(Item);
end;

procedure TPluginTileCommandBuilder.InternalCreateFilter;
var
 Item:TdxBarItem;
begin
 case FDataSet.FieldByName('CommandType').AsInteger of
 //  0: Item:=TMiceBarLargeButton.CreateDefault(FPlugin,FDataSet); //SmallButton
   0: Item:=TMiceBarCheckBoxButton.CreateDefault(FPlugin,FDataSet);
   1: Item:=TMiceBarTextEdit.CreateDefault(FPlugin,FDataSet);
   2: Item:=TMiceBarDropDown.CreateDefault(FPlugin,FDataSet);
   3: Item:=TMiceBarOptionBox.CreateDefault(FPlugin,FDataSet);
   4: Item:=TMiceBarDateEdit.CreateDefault(FPlugin,FDataSet);
   5: Item:=TMiceBarDateRangeEdit.CreateDefault(FPlugin,FDataSet);
   6: Item:=TMiceBarStatic.CreateDefault(FPlugin,FDataSet);
   7: Item:=TMiceBarTreeViewCombo.CreateDefault(FPlugin,FDataSet);
   8: Item:=TMiceBarFileButton.CreateDefault(FPlugin,FDataSet);
{
   9: Item:=TMiceBarSubAccountEditor.CreateDefault(FPlugin,FDataSet);
   10: Item:=TMiceBarSubAccountEditor.CreateDefault(FPlugin,FDataSet);
   11: Item:=TMiceBarClientEditor.CreateDefault(FPlugin,FDataSet);
   12: Item:=CreateSubMenuOrCombo;
   13: Item:=CreateSubMenuOrCombo;
   14: Item:=TMiceBarValuePicker.CreateDefault(FPlugin,FDataSet);
   15: Item:=TMiceBarSubAccountEditor.CreateDefault(FPlugin,FDataSet);
   16: Item:=TMiceBarLargeButton.CreateDefault(FPlugin,FDataSet); //LargeButton
   }
    else
    Item:=nil;
 end;

 if Assigned(Item) then
   CreateItemLink(Item, FDataSet.FieldByName('Location').AsString, FDataSet.FieldByName('Caption').AsString, False);
end;

procedure TPluginTileCommandBuilder.LoadForPlugin(Plugin:TBasePlugin);
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

procedure TPluginTileCommandBuilder.LoadFromDataSet(DataSet: TDataSet; Plugin:TBasePlugin);
begin
 FPlugin:=Plugin;
 FDataSet:=DataSet;
  try
   FPlugin.Container.Bar.BeginUpdate;
   FDataSet.DisableControls;
   FDataSet.First;
   ProcessDataSet;
   if FPlugin.Properties.DocFlow then
    CreateDocFlow;
   FindDblClickAction;
 finally
  FPlugin.Container.CreateToolBar('{61D787EA-8274-423A-989F-C482D0B6EFD0}');
  FPlugin.Container.Bar.EndUpdate;
  FPlugin:=nil;
  FDataSet:=nil;
 end;
end;


procedure TPluginTileCommandBuilder.ProcessDataSet;
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
    except on E:Exception do
     MessageBox(FPlugin.Handle,PChar(E.Message), PChar(S_COMMON_ERROR), MB_OK+MB_ICONSTOP);
    end;
    FDataSet.Next;
   end;
end;


end.
