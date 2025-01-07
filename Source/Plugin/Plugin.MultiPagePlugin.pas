unit Plugin.MultiPagePlugin;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Plugin.Base, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, dxBarBuiltInMenu, cxPC, Data.DB,
  System.Generics.Collections, System.Generics.Defaults,
  cxSplitter, Plugin.SideTreeFilter, Vcl.ExtCtrls,CustomControl.MiceActionList,
  DAC.XDataSet, cxCustomData, cxStyles, cxTL, cxMaskEdit, cxTextEdit,
  cxTLdxBarBuiltInMenu, cxInplaceContainer, cxTLData, cxDBTL,
  Common.LookAndFeel, dxBar, cxClasses;

type

  TOnGetPluginClassEvent = function (const PluginType: Integer):TBasePluginClass of object;

  TMultiPagePlugin = class(TBasePlugin)
    pgMain: TcxPageControl;
    NullPage: TcxTabSheet;
    procedure NodeChanged(Sender: TcxCustomTreeList; APrevFocusedNode, AFocusedNode: TcxTreeListNode);
  private
    FCurrentPlugin:TBasePlugin;
    FPageList:TDictionary<string,TBasePlugin>;
    FOnGetPluginClass: TOnGetPluginClassEvent;
    FLoading:Boolean;
    function CreateNewPage(const Key: string; AppPluginsId:Integer; const Caption:string):TBasePlugin;
    function InternalCreatePlugin(Sheet:TcxTabSheet;AppPluginsId:Integer):TBasePlugin;
    procedure SetCurrentPlugin(Plugin:TBasePlugin);
    procedure SetZeroPlugin;
  protected
    function GetPluginType(const PluginType:Integer): TBasePluginClass;
    procedure CheckKeyField;override;
    procedure ChangePage;
  public
    procedure ForceRefreshDataSet; override;
    procedure LoadState; override;
    procedure SaveState; override;
    function GetSelectedIDs:string;override;
    constructor Create(AOwner:TComponent); override;
    destructor Destroy; override;
  published
    property OnGetPluginClass:TOnGetPluginClassEvent read FOnGetPluginClass write FOnGetPluginClass;
    function KeyFieldValue:Integer; override;
  end;


implementation

{$R *.dfm}

{ TMultiPagePlugin }

procedure TMultiPagePlugin.ChangePage;
var
 ACaption:string;
 AAppPluginsId:Integer;
 APlugin:TBasePlugin;
 AKey:string;
begin
 ACaption:=SideTreeFilterFrame.TreeFilter.DataSet.FieldByName(SideTreeFilterFrame.CaptionField).AsString;
 AAppPluginsId:=SideTreeFilterFrame.TreeFilter.DataSet.FieldByName('AppPluginsId').AsInteger;
 AKey:=VarToStr(SideTreeFilterFrame.KeyFieldValue);
 if AAppPluginsId<=0 then
  AKey:='';

 if not FPageList.ContainsKey(AKey) then
  APlugin:=CreateNewPage(AKey, AAppPluginsId, ACaption)
   else
  APlugin:=Self.FPageList[AKey];

 if Assigned(APlugin) then
  SetCurrentPlugin(APlugin)
   else
  SetZeroPlugin;
end;

procedure TMultiPagePlugin.CheckKeyField;
begin
 //Dont have keyfield
end;

constructor TMultiPagePlugin.Create(AOwner: TComponent);
begin
  inherited;
  FLoading:=False;
  FPageList:=TDictionary<string,TBasePlugin>.Create;
  pgMain.HideTabs:=True;
  pgMain.Color:=DefaultLookAndFeel.WindowColor;
  NullPage.Color:=DefaultLookAndFeel.WindowColor;
  FPageList.Add('', nil); //default empty page
end;

function TMultiPagePlugin.CreateNewPage(const Key: string; AppPluginsId:Integer; const Caption:string): TBasePlugin;
var
 Tab:TcxTabSheet;
begin
 Tab:=TcxTabSheet.Create(pgMain);
 Tab.PageControl:=pgMain;
 Tab.Caption:=Caption;
 if AppPluginsId>0 then
  Result:=InternalCreatePlugin(Tab,AppPluginsId)
   else
  Result:=nil; 

 FPageList.Add(Key, Result);

end;

destructor TMultiPagePlugin.Destroy;
begin
 FPageList.Free;
 inherited;
end;

procedure TMultiPagePlugin.ForceRefreshDataSet;
begin
 Screen.Cursor:=crHourGlass;
 try
  if Assigned(FCurrentPlugin) then
   begin
    PopulateParams;
    FCurrentPlugin.Params.Assign(Self.Params);
    FCurrentPlugin.RefreshDataSet;
   end;
 finally
  Screen.Cursor:=crDefault;
 end;
end;

function TMultiPagePlugin.GetPluginType( const PluginType: Integer): TBasePluginClass;
resourcestring
 E_PLUGIN_EVENT_NOT_SET = 'Cannot detect plugin class, plugin type manager not set.';
begin
if not Assigned(FOnGetPluginClass) then
 raise Exception.Create(E_PLUGIN_EVENT_NOT_SET);

 Result:=FOnGetPluginClass(PluginType);
end;

function TMultiPagePlugin.GetSelectedIDs: string;
begin
 if Assigned(FCurrentPlugin) then
  Result:=FCurrentPlugin.GetSelectedIDs;
end;

function TMultiPagePlugin.InternalCreatePlugin(Sheet:TcxTabSheet; AppPluginsId: Integer): TBasePlugin;
var
 AClass: TBasePluginClass;
 Tmp:TxDataSet;
resourcestring
 E_CANNOT_CREATE_MULTIPAGE_PLUGIN_INSIDE_ITSELF = 'Cannot create Multipage plugin inside itself.';
begin
 Tmp:=TxDataSet.Create(nil);
 try
  Tmp.ProviderName:='spui_AppGetPlugin';
  Tmp.Source:='TMultiPagePlugin.InternalCreatePlugin';
  Tmp.SetParameter('AppPluginsId',AppPluginsId);
  Tmp.Open;
  AClass:=GetPluginType(Tmp.FieldByName('PluginType').AsInteger);
  if AClass = TMultiPagePlugin then
   raise Exception.Create(E_CANNOT_CREATE_MULTIPAGE_PLUGIN_INSIDE_ITSELF);

  Result:=AClass.Create(Sheet);
  Result.Parent:=Sheet;
  Result.Container.Sheet:=Sheet;
  Result.Properties.LoadFromDataSet(Tmp);
  Result.SideTreeFilterVisible:=False;
  Result.Align:=alClient;
  Result.Properties.DoubleClickAction:=Self.Properties.DoubleClickAction;
  Result.PluginSaveLoad.Salt:='@'+Properties.AppPluginsId.ToString;
  Result.Initialize;

 finally
  Tmp.Free;
 end;
end;


function TMultiPagePlugin.KeyFieldValue: Integer;
begin
 if Assigned(FCurrentPlugin) then
  Result:=FCurrentPlugin.KeyFieldValue
   else
  Result:=-1;
end;

procedure TMultiPagePlugin.LoadState;
begin
  inherited;
  try
   FLoading:=True;
   ChangePage;
  finally
    FLoading:=False;
  end;
end;

procedure TMultiPagePlugin.NodeChanged(Sender: TcxCustomTreeList; APrevFocusedNode, AFocusedNode: TcxTreeListNode);
begin
 ChangePage;
end;


procedure TMultiPagePlugin.SaveState;
begin
  inherited;

end;

procedure TMultiPagePlugin.SetCurrentPlugin(Plugin: TBasePlugin);
begin
 FCurrentPlugin:=Plugin;
 pgMain.ActivePage:=Plugin.Container.Sheet;
 Actions.DataSource:=Plugin.DataSource;


 Actions.ActionByName(ACTION_NAME_ADD_RECORD).OnExecute:=Plugin.Actions.ActionByName(ACTION_NAME_ADD_RECORD).OnExecute;

 Actions.RefreshActions;

 PopulateParams;
 Plugin.Params.Assign(Params);

 ParamsMapper.ClearSources;
 ParamsMapper.AddSource(Plugin.DataSet,'');
 ParamsMapper.AddSource(Plugin.Params,'');
 Properties.LoadMultiPluginProperties(Plugin.Properties);

 if (Plugin.DataSet.Active=False) and (Plugin.Properties.RefreshAfterCreate)  then //and (FLoading=False)
  Plugin.RefreshDataSet;
end;

procedure TMultiPagePlugin.SetZeroPlugin;
begin
  FCurrentPlugin:=nil;
  ParamsMapper.ClearSources;
  ParamsMapper.AddSource(Params,'');
  pgMain.ActivePage:=NullPage;
  Actions.DataSource:=nil;
  Actions.ActionByName(ACTION_NAME_REFRESHDATA).Enabled:=False;
  Actions.ActionByName(ACTION_NAME_ADD_RECORD).Enabled:=False;
end;

end.
