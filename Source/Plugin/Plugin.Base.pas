unit Plugin.Base;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  System.Generics.Collections, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Data.DB,Vcl.ExtCtrls,Vcl.StdCtrls,cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxSplitter, cxTl, cxClasses, dxBar, Vcl.Menus,
  DAC.XDataSet,
  DAC.XParams,
  DAC.XParams.Mapper,
  Mice.Report,
  Mice.Script,
  Plugin.Properties,
  Plugin.Container,
  Plugin.SideTreeFilter,
  Plugin.SaveLoad,
  Plugin.InfoDialog,
  Plugin.Action.OpenFile,
  Common.Images,
  Common.ResourceStrings,
  Common.StringUtils,
  AppTemplate.Builder,
  CustomControl.MiceBalloons,
  CustomControl.Interfaces,
  CustomControl.MiceAction,
  CustomControl.MiceActionList,
  Common.VariantComparator,
  Dialog.Adaptive,
  Dialog.Embedded,
  DocFlow.Manager;


type
  TBasePlugin = class(TFrame, IInheritableAppObject)
    DataSource: TDataSource;
    SideTreePanel: TPanel;
    TreeSplitter: TcxSplitter;
    SideTreeFilterFrame: TSideTreeFilter;
    PopupBarManager: TdxBarManager;
    GridPopupMenu: TdxBarPopupMenu;
    miColumns: TdxBarSubItem;
    procedure NodeChanged(Sender: TcxCustomTreeList; APrevFocusedNode,   AFocusedNode: TcxTreeListNode);
  private
    FDataSet:TXDataSet;
    FActions: TMiceActionList;
    FFilterField:string;
    FFilterValue:string;
    FUseLike:Boolean;
    FFilterHadError:Boolean;
    FProperties: TPluginProperties;
    FParams: TxParams;
    FContainer: TPluginContainer;
    FBeforeDestroy: TNotifyEvent;
    FParamsMapper:TParamsMapper;
    FPluginSaveLoad:TPluginSaveLoad;
    FEmbeddedDialog:TEmbeddedDialog;
    FInitialized:Boolean;
    FDialogPanel:TPanel;
    FDialogPanelSplitter:TcxSplitter;
    FItteration:Integer;
    FAbortForEach: Boolean;
    FParentObject: IInheritableAppObject;
    FDocFlowManager:TDocFlowManager;
    FScripter:TMiceScripter;
    procedure InternalFilterRecord(DataSet:TDataSet; var Accept:Boolean);
    procedure FilterRecord(DataSet:TDataSet; var Accept:Boolean);
    procedure InternalDeleteRecord(const Ids:string);
    procedure UncheckDialogButtons(AAction:TMiceAction);
    procedure SetSideTreeFilterVisible(const Value: Boolean);
    procedure SetBottomPlacement;
    procedure SetRightPlacement;
    procedure SetDBName(const Value: string);
    function GetSideTreeFilterVisible: Boolean;
    function GetParentObject: IInheritableAppObject;
    function GetDBName: string;
    function GetParamsMapper: TParamsMapper;
  protected
    function CreateDialog:TAdaptiveDialog;
    function AddRecord:Boolean; virtual;
    function EditRecord(AReadOnly:Boolean):Boolean; virtual;
    procedure DoAfterScroll(DataSet:TDataSet); virtual;
    procedure CheckKeyField;virtual;
    procedure OnCreateDialogEvent(Dlg:TAdaptiveDialog);
    procedure DeleteRecord; virtual;
    procedure AddRecordExecute(Sender:TObject);
    procedure EditRecordExecute(Sender:TObject);
    procedure PluginInfoActionExecute(Sender:TObject);
    procedure ViewRecordExecute(Sender:TObject);
    procedure DeleteRecordExecute(Sender: TObject);
    procedure ForceRefreshExecute(Sender:TObject);
    procedure RefreshExecute(Sender:TObject);
    procedure SelectionChanged(RecordsSelected:Integer); virtual;
    procedure Build;virtual;
    procedure DoBeforeDestroy;
    procedure CreatePluginMethods; virtual;
    procedure InternalExecuteEmbeddedDialog(AAction:TMiceAction);
    procedure InternalExecuteModalDialog(AAction:TMiceAction);
    procedure InternalExecuteStoredProc(DataSet:TDataSet);
    procedure UpdateActionsActivity;
    procedure CreateEmbeddedDialog(AAction:TMiceAction);
    procedure DoExecuteAppTemplate(AppTemplatesId:Integer);
    procedure ExecuteAppTemplateOnLine(DataSet:TDataSet);
    procedure ExecuteAppCmdScript(AppScriptsId:Integer);
    procedure ExecuteAppReport(AppReportsId:Integer);
    procedure OnUpdatePageTitle(Sender:TObject);
    property AbortForEach:Boolean read FAbortForEach write FAbortForEach;
    procedure LoadSideTreeFilter;
    procedure RefreshWithLocate;
  public
    property PluginSaveLoad:TPluginSaveLoad read FPluginSaveLoad;
    procedure LoadState; virtual;
    procedure SaveState; virtual;
    procedure MethodPrintReport(Sender:TObject);
    procedure MethodOpenFile(Sender:TObject);
    procedure MethodExecuteScript(Sender:TObject);
    procedure MethodExecuteDialog(Sender:TObject);
    procedure MethodExecuteStoredProc(Sender:TObject);
    procedure MethodExecuteAppTemplate(Sender:TObject);
    procedure Initialize;
    procedure UpdateCaption;
    procedure PopulateParams;
    constructor Create(AOwner:TComponent); override;
    destructor Destroy; override;
  published
    procedure ForEachSelectedRowDo(OnSelectedRow: TDataSetNotifyEvent); virtual;abstract;
    procedure FilterDataSet(FieldName,FilterValue:string;UseLike:Boolean);
    procedure ForceRefreshDataSet; virtual;
    procedure RefreshDataSet; virtual;
    function KeyFieldValue:Integer; virtual;
    function GetSelectedIDs:string;virtual;
    function SelectedCount:Integer;virtual;abstract;

    property DataSet: TxDataSet read FDataSet;
    property Properties:TPluginProperties read FProperties;
    property Actions:TMiceActionList read FActions;
    property Container:TPluginContainer read FContainer;
    property Initialized:Boolean read FInitialized;
    property SideTreeFilterVisible:Boolean read GetSideTreeFilterVisible write SetSideTreeFilterVisible;
    property BeforeDestroy:TNotifyEvent read FBeforeDestroy write FBeforeDestroy;
    property Params:TxParams read FParams;
    property ParentObject:IInheritableAppObject read GetParentObject write FParentObject;
    property DBName:string read GetDBName write SetDBName;
    property ParamsMapper:TParamsMapper read GetParamsMapper;
    property DocFlowManager:TDocFlowManager read FDocFlowManager;

  end;

  TBasePluginClass = class of TBasePlugin;

implementation

{$R *.dfm}

{ TBasicFrame }

function TBasePlugin.EditRecord(AReadOnly:Boolean):Boolean;
var
 Dlg:TAdaptiveDialog;
begin
  Dlg:=CreateDialog;
  try
   Dlg.ID:=KeyFieldValue;
   if Properties.CustomAppDialogsIdField.IsEmpty then
    Dlg.AppDialogsId:=Properties.AppDialogID
     else
    Dlg.AppDialogsId:=DataSet.FieldByName(Properties.CustomAppDialogsIdField).AsInteger;

   if AReadOnly=True then
    Dlg.ReadOnly:=True;
   Result:=Dlg.Execute;
  finally
   Dlg.Free;
  end;
end;

function TBasePlugin.AddRecord:Boolean;
var
 Dlg:TAdaptiveDialog;
begin
// Здесь не надо смотреть в CusomAppDialog field
// Иначе будет создаваться НОВЫЙ диалог, в зависимости от выбранной записи)
 Dlg:=CreateDialog;
  try
   Dlg.ID:=-1;
   Dlg.AppDialogsId:=Properties.AppDialogID;
   Dlg.ParentObject:=Self;
   Result:=Dlg.Execute;
  finally
   Dlg.Free;
  end;
end;


procedure TBasePlugin.AddRecordExecute(Sender: TObject);
var
 Action:TMiceAction;
begin
 Action:=Sender as TMiceAction;
 if (AddRecord) and Action.AutoRefresh then
  RefreshDataSet;
end;

procedure TBasePlugin.DoAfterScroll(DataSet: TDataSet);
begin
 if Assigned(FEmbeddedDialog) then
  begin
   if (DataSet.Active) and (DataSet.RecordCount>0) then
    FEmbeddedDialog.RefreshID(KeyFieldValue)
     else
    FEmbeddedDialog.CloseAll;
  end;
end;

procedure TBasePlugin.Build;
begin
 SideTreeFilterVisible:=Properties.SideTreeEnabled;
 if SideTreeFilterVisible then
   LoadSideTreeFilter;
 if Properties.DocFlow then
   FDocFlowManager.EnableDocFlow;
 Actions.RefreshActions;
 if Properties.AppScriptsId<>0 then
  begin
   FScripter.AppScriptsId:=Properties.AppScriptsId;
   FScripter.AddObject('ActivePlugin', Self);
   FScripter.AddObject('Self', Self);
   FScripter.Load;
   FScripter.CallProcedure('AfterBuild');
  end;

end;


procedure TBasePlugin.CheckKeyField;
begin
 if Properties.KeyField.Trim.IsEmpty then
  Properties.RaiseKeyFieldException;
end;


constructor TBasePlugin.Create(AOwner: TComponent);
begin
  inherited;
  FInitialized:=False;
  FDataSet:=TXDataSet.Create(Self);
  FDataSet.OnFilterRecord:=FilterRecord;
  FDataSet.Source:='Plugin.Base';
  FDataSet.AfterScroll:=DoAfterScroll;
  DataSource.DataSet:=FDataSet;
  FActions:=TMiceActionList.Create;
  FActions.DataSource:=DataSource;
  FContainer:=TPluginContainer.Create;
  FParams:=TxParams.Create;
  FProperties:=TPluginProperties.Create(Params, SideTreeFilterFrame);
  Properties.StaleData:=True;
  Properties.RefreshLocked:=False;
  Properties.OnUpdateTitle:=Self.OnUpdatePageTitle;
  FParamsMapper:=TParamsMapper.Create;
  FParamsMapper.AddSource(DataSet,'');
  FParamsMapper.AddSource(Params,'');

  FPluginSaveLoad:=TPluginSaveLoad.Create(Properties);
  FPluginSaveLoad.Container:=Self.Container;
  SideTreeFilterFrame.InheritableAppObject:=Self;
  FScripter:=TMiceScripter.Create(Self);
  FDocFlowManager:=TDocFlowManager.Create(FActions, Properties, DataSet, FScripter);
  FDocFlowManager.OnCreateDialog:=OnCreateDialogEvent;
  CreatePluginMethods;
end;

function TBasePlugin.CreateDialog: TAdaptiveDialog;
begin
  if Properties.DocFlow=False then
   Properties.CheckAppDialog;
  Result:=TAdaptiveDialog.Create(nil);
  OnCreateDialogEvent(Result);
end;

procedure TBasePlugin.CreateEmbeddedDialog(AAction:TMiceAction);
begin
 if Assigned(FEmbeddedDialog) and (FEmbeddedDialog.AppDialogsId=AAction.RunAppDialogsId ) then
  Exit;

  FreeAndNil(FEmbeddedDialog);
  FEmbeddedDialog:=TEmbeddedDialog.Create(Self.FDialogPanel);
  FEmbeddedDialog.AppDialogsId:=AAction.RunAppDialogsId;
  OnCreateDialogEvent(FEmbeddedDialog);
  FEmbeddedDialog.ReadOnly:=True;
  ParamsMapper.MapParamsAppCmd(FEmbeddedDialog.Params, AAction.ID);
  FEmbeddedDialog.ID:=KeyFieldValue;
  FEmbeddedDialog.Initialize;
  FEmbeddedDialog.Merge(FDialogPanel);
end;

procedure TBasePlugin.CreatePluginMethods;
var
 Action:TMiceAction;
begin
 Action:=Actions.CreateAction(ACTION_NAME_REFRESHDATA);
 Action.OnExecute:=RefreshExecute;
 Action.ActivityCondition.AlwaysEnabled:=False;
 Action.ActivityCondition.EnabledWhenNoRecords:=True;
 Action.ActionType:=atExecutePluginMethod;

 Action:=Actions.CreateAction(ACTION_NAME_ADD_RECORD);
 Action.OnExecute:=AddRecordExecute;
 Action.ActivityCondition.AlwaysEnabled:=False;
 Action.ActivityCondition.EnabledWhenNoRecords:=True;
 Action.ActionType:=atExecutePluginMethod;

 Action:=Actions.CreateAction(ACTION_NAME_EDIT_RECORD);
 Action.ActivityCondition.AlwaysEnabled:=False;
 Action.ActivityCondition.EnabledWhenNoRecords:=False;
 Action.OnExecute:=EditRecordExecute;
 Action.ActionType:=atExecutePluginMethod;

 Action:=Actions.CreateAction(ACTION_NAME_VIEW_RECORD);
 Action.ActivityCondition.AlwaysEnabled:=False;
 Action.ActivityCondition.EnabledWhenNoRecords:=False;
 Action.OnExecute:=ViewRecordExecute;
 Action.ActionType:=atExecutePluginMethod;


 Action:=Actions.CreateAction(ACTION_NAME_PLUGIN_INFORMATION);
 Action.ActivityCondition.AlwaysEnabled:=True;
 Action.ActivityCondition.EnabledWhenNoRecords:=True;
 Action.OnExecute:=PluginInfoActionExecute;
 Action.HotKey:='CTRL+I';
 Action.OriginalHotKey:='CTRL+I';
 Action.Enabled:=True;
 Action.ActionType:=atExecutePluginMethod;
 Action.ImageIndex:=43;


 Action:=Actions.CreateAction(ACTION_NAME_DELETE_RECORD);
 Action.OnExecute:=DeleteRecordExecute;
 Action.ActionType:=atExecutePluginMethod;

 FDocFlowManager.CreateDocFlowMethods;
end;

procedure TBasePlugin.DeleteRecord;
begin
 Properties.CheckDeleteProvider;
 if MessageBox(Handle,PChar(S_COMMON_DELETE_RECORD_CONFIRMATION),PChar(S_COMMON_DELETE_RECORD_CAPTION),MB_YESNO+MB_ICONASTERISK)=ID_YES then
  InternalDeleteRecord(GetSelectedIDs);
end;

procedure TBasePlugin.DeleteRecordExecute(Sender: TObject);
begin
  DeleteRecord;
end;

destructor TBasePlugin.Destroy;
begin
  DoBeforeDestroy;
  FParamsMapper.Free;
  FParams.Free;
  FActions.Free;
  FProperties.Free;
  FContainer.Free;
  FPluginSaveLoad.Free;
  FScripter.Free;
  FDocFlowManager.Free;
  inherited;
end;

procedure TBasePlugin.MethodExecuteAppTemplate(Sender: TObject);
begin
 FItteration:=0;
 Properties.CurrentAction:=Sender as TMiceAction;
 try
  if Properties.CurrentAction.MultiSelectBehavior=TMultiSelectBehavior.msbStandart then
   ForEachSelectedRowDo(ExecuteAppTemplateOnLine)
    else
   DoExecuteAppTemplate(Properties.CurrentAction.RunAppTemlatesID);
 finally
  Properties.CurrentAction:=nil;
 end;
end;

procedure TBasePlugin.MethodExecuteDialog(Sender: TObject);
const
 ModalDialog=0;
begin
 Properties.CurrentAction:=Sender as TMiceAction;
 try
  if Properties.CurrentAction.DialogPlacement=ModalDialog then
    InternalExecuteModalDialog(Properties.CurrentAction)
     else
    InternalExecuteEmbeddedDialog(Properties.CurrentAction);
 finally
  Properties.CurrentAction:=nil;
 end;
end;

procedure TBasePlugin.MethodExecuteScript(Sender: TObject);
var
 Action:TMiceAction;
begin
 Action:= Sender as TMiceAction;
 ExecuteAppCmdScript(Action.RunAppScriptsId);
end;

procedure TBasePlugin.MethodExecuteStoredProc(Sender: TObject);
begin
 Properties.CurrentAction:=Sender as TMiceAction;
 try
  if Properties.CurrentAction.MultiSelectBehavior=TMultiSelectBehavior.msbStandart then
   ForEachSelectedRowDo(InternalExecuteStoredProc)
    else
   InternalExecuteStoredProc(DataSet);
  if Properties.CurrentAction.AutoRefresh then
   RefreshDataSet;
 finally
  Properties.CurrentAction:=nil;
 end;
end;

procedure TBasePlugin.MethodOpenFile(Sender: TObject);
var
 PluginAction:TPluginActionOpenFile;
begin
 Properties.CurrentAction:=Sender as TMiceAction;
 PluginAction:=TPluginActionOpenFile.Create(Self, Properties);
 try
  if PluginAction.Execute and Properties.CurrentAction.AutoRefresh then
   RefreshDataSet;
 finally
  PluginAction.Free;
  Properties.CurrentAction:=nil;
 end;
end;

procedure TBasePlugin.MethodPrintReport(Sender: TObject);
begin
 Properties.CurrentAction:=Sender as TMiceAction;
 try
  ExecuteAppReport(Properties.CurrentAction.RunAppReportsId)
 finally
  Properties.CurrentAction:=nil;
 end;
end;

procedure TBasePlugin.NodeChanged(Sender: TcxCustomTreeList; APrevFocusedNode,  AFocusedNode: TcxTreeListNode);
begin
if Initialized then
  RefreshDataSet;
end;

procedure TBasePlugin.PluginInfoActionExecute(Sender: TObject);
var
 Dlg:TPluginInfoDialog;
begin
 Dlg:=TPluginInfoDialog.Create(nil);
 try
  Dlg.Load(Self.Properties);
  Dlg.LoadItems(Container);
  Dlg.Execute;
 finally
  Dlg.Free;
 end;
end;


procedure TBasePlugin.PopulateParams;
var
 x:Integer;
begin
 for x:=0 to FContainer.FilterControls.Count-1 do
  if Supports(FContainer.FilterControls[x],ICanManageParams) then
    (FContainer.FilterControls[x] as ICanManageParams).SetParamsTo(Self.Params);

  if Assigned(SideTreeFilterFrame) then
    (SideTreeFilterFrame as ICanManageParams).SetParamsTo(Self.Params);
end;

procedure TBasePlugin.DoBeforeDestroy;
begin
 if Assigned(BeforeDestroy) then
  BeforeDestroy(Self);
end;

procedure TBasePlugin.DoExecuteAppTemplate(AppTemplatesId: Integer);
var
 Builder:TAppTemplateBuilder;
 Canceled:Boolean;
 Errors:Boolean;
begin
  FItteration:=FItteration+1;
  Builder:=TAppTemplateBuilder.Create(nil);
  try
   Builder.AppTemplatesId:=AppTemplatesId;
   Builder.DBName:=Self.DBName;
   ParamsMapper.MapParamsAppCmd(Builder.Params,Properties.CurrentAction.ID);
   Builder.AutoClose:=(FItteration<>SelectedCount);
   Canceled:=not Builder.Execute;
   Errors:= (Builder.HadError=True) and (Properties.CurrentAction.ContinueOnError=False);
   AbortForEach:=Canceled or Errors or Builder.UserAbort;
  finally
   Builder.Free;
  end;

end;


procedure TBasePlugin.EditRecordExecute(Sender: TObject);
var
 Action:TMiceAction;
begin
 Action:=Sender as TMiceAction;
 if (EditRecord(False)) and Action.AutoRefresh then
  RefreshDataSet;
end;

procedure TBasePlugin.ExecuteAppCmdScript(AppScriptsId: Integer);
var
 Scripter:TMiceScripter;
begin
 Scripter:=TMiceScripter.Create(nil);
 try
  Scripter.AppScriptsId:=AppScriptsId;
  Scripter.RegisterAllFields(DataSet);
  Scripter.AddObject('ActivePlugin',Self);
  Scripter.Load;
  Scripter.CallProcedure('Execute');
 finally
  Scripter.Free;
 end;
end;

procedure TBasePlugin.ExecuteAppReport(AppReportsId: Integer);
var
 Report:TMiceReport;
begin
 Report:=TMiceReport.Create(nil);
 try
  Report.AppReportsId:=AppReportsId;
  ParamsMapper.MapParamsAppCmd(Report.Params,Properties.CurrentAction.ID);
  Report.Execute;
 finally
  Report.Free;
 end;
end;

procedure TBasePlugin.ExecuteAppTemplateOnLine(DataSet: TDataSet);
begin
 if Properties.CurrentAction.ActivityCondition.EnabledForDataSet(DataSet) then
  DoExecuteAppTemplate(Properties.CurrentAction.RunAppTemlatesID);
end;

procedure TBasePlugin.InternalExecuteEmbeddedDialog(AAction:TMiceAction);
begin
 UncheckDialogButtons(Properties.CurrentAction);
 if not Assigned(FDialogPanel) then
  begin
    FDialogPanel:=TPanel.Create(Self);
    FDialogPanel.Width:=FPluginSaveLoad.RightPanelSize;
    FDialogPanel.Height:=FPluginSaveLoad.BottomPanelSize;
    FDialogPanel.Parent:=Self;
    FDialogPanelSplitter:=TcxSplitter.Create(FDialogPanel);
    FDialogPanelSplitter.Parent:=Self;
    FDialogPanelSplitter.Visible:=False;
    FDialogPanelSplitter.Visible:=True;
  end;

 CreateEmbeddedDialog(Properties.CurrentAction);

 case AAction.DialogPlacement of
  1: SetBottomPlacement;
  2: SetRightPlacement;
 end;

 FDialogPanel.Visible:=AAction.Checked;
 FDialogPanelSplitter.Visible:=AAction.Checked;

end;


procedure TBasePlugin.SetBottomPlacement;
begin
// FDialogPanel.Height:=FPluginSaveLoad.BottomPanelSize;
 FDialogPanel.Align:=alBottom;
 FEmbeddedDialog.Align:=TAlign.alClient;
 FDialogPanelSplitter.AlignSplitter:=salBottom;
end;

procedure TBasePlugin.SetRightPlacement;
begin
// FDialogPanel.Width:=FPluginSaveLoad.RightPanelSize;
 FDialogPanel.Align:=alRight;
 FEmbeddedDialog.Align:=TAlign.alClient;
 FDialogPanelSplitter.AlignSplitter:=salRight
end;


procedure TBasePlugin.InternalExecuteModalDialog(AAction:TMiceAction);
var
 Dlg:TAdaptiveDialog;
begin
 Dlg:=TAdaptiveDialog.Create(nil);
 try
  Dlg.AppDialogsId:=AAction.RunAppDialogsId;
  OnCreateDialogEvent(Dlg);
  ParamsMapper.MapParamsAppCmd(Dlg.Params, AAction.ID);
  if (Dlg.Execute) and (AAction.AutoRefresh) then
   RefreshDataSet;
 finally
  Dlg.Free;
 end;
end;

procedure TBasePlugin.InternalExecuteStoredProc(DataSet:TDataSet);
var
 Tmp:TxDataSet;
 P:TParam;
begin
 Tmp:=TxDataSet.Create(nil);
 try
   Tmp.Source:='TBasePlugin.InternalExecuteStoredProc';
   Tmp.ProviderName:=Properties.CurrentAction.ProviderName;
   Tmp.Params.LoadFromDataSet(DataSet);
   Tmp.DBName:=Properties.DBName;
   ParamsMapper.MapParamsAppCmd(Tmp.Params, Properties.CurrentAction.ID);
   P:=Tmp.Params.FindParam('ProviderName');
   if Assigned(P) then
    Tmp.ProviderName:=P.AsString;
  try
   Tmp.OpenOrExecute;
  except
   if (Properties.CurrentAction.ContinueOnError=False) then
    raise;
  end;
 finally
   Tmp.Free;
 end;

end;

procedure TBasePlugin.FilterDataSet(FieldName, FilterValue: String;  UseLike: Boolean);
begin
  DataSet.Filtered:=False;
  FFilterField:=FieldName;
  FFilterValue:=AnsiLowerCase(FilterValue);
  FUseLike:=UseLike;
  FFilterHadError:=False;
  DataSet.Filtered:=(FieldName<>'') and (FilterValue<>'');
end;


procedure TBasePlugin.InternalFilterRecord(DataSet: TDataSet;  var Accept: Boolean);
var
 S:String;
begin
 S:=AnsiLowerCase(DataSet.FieldByName(FFilterField).AsString);
 if FUseLike then
  Accept:=Pos(FFilterValue,S)>=1
   else
  Accept:=S=FFilterValue;
end;

procedure TBasePlugin.FilterRecord(DataSet: TDataSet; var Accept: Boolean);
begin
if FFilterHadError=false then
 try
  InternalFilterRecord(DataSet,Accept);
 except
   FFilterHadError:=True;
   raise;
 end;
end;


function TBasePlugin.GetDBName: string;
begin
 Result:=Properties.DBName;
end;

function TBasePlugin.GetParamsMapper: TParamsMapper;
begin
 Result:=FParamsMapper;
end;

function TBasePlugin.GetParentObject: IInheritableAppObject;
begin
  Result := FParentObject;
end;

function TBasePlugin.GetSelectedIDs: string;
begin
 Result:=KeyFieldValue.ToString;
end;

function TBasePlugin.GetSideTreeFilterVisible: Boolean;
begin
 Result:=Properties.SideTreeEnabled;
end;

procedure TBasePlugin.Initialize;
begin
 If FInitialized=False then
  try
   Build;
  finally
   FInitialized:=True;
  end;
end;

procedure TBasePlugin.InternalDeleteRecord(const Ids: string);
var
 Tmp:TXDataSet;
begin
 Tmp:=TXDataSet.Create(nil);
  try
   Tmp.ProviderName:=Properties.DeleteProviderName;
   Tmp.SetParameter('@IDs',IDs);
   Tmp.Execute;
   RefreshDataSet;
  finally
    Tmp.Free;
  end;
end;


function TBasePlugin.KeyFieldValue: Integer;
begin
  Result:=DataSet.FieldByName(Properties.KeyField).AsInteger;
end;


procedure TBasePlugin.LoadSideTreeFilter;
begin

// Self.Params.SetParameter('@ItemId',44);
 SideTreeFilterFrame.TreeFilter.DataController.ImageIndexField:='ImageIndex';
 SideTreeFilterFrame.TreeFilter.DataSet.ProviderNamePattern:=Properties.SideTreeProviderName;
 SideTreeFilterFrame.CaptionField:=Properties.SideTreeCaptionField;
 SideTreeFilterFrame.TreeFilter.DataSet.Params.Assign(Self.Params);
 SideTreeFilterFrame.DoRefreshTree;
 SideTreeFilterFrame.Initialize;

  {
 B1.DataBinding.DataSource:=SideTreeFilterFrame.TreeFilter.DataSource;
 B1.DataBinding.ImageIndexField:='ImageIndex';
 B1.DataBinding.NameField:=Properties.SideTreeCaptionField;
 B1.DataBinding.KeyField:=SideTreeFilterFrame.TreeFilter.DataController.KeyField;
 B1.DataBinding.ParentKeyField:=SideTreeFilterFrame.TreeFilter.DataController.ParentField;
 }

 // SideTreeFilterFrame.TreeFilter.OnFocusedNodeChanged:=Self.NodeChanged;
 SideTreeFilterFrame.AfterCustomRefresh:=RefreshExecute;
end;


procedure TBasePlugin.RefreshDataSet;
begin
 CheckKeyField;
 if Properties.RefreshLocked then
     Properties.StaleData:=True
      else
     ForceRefreshDataSet;
//  TMiceBalloons.Show('Parameters',Self.DataSet.ProviderName+' '+FDataSet.Params.ToString());
end;

procedure TBasePlugin.RefreshExecute(Sender: TObject);
begin
 RefreshDataSet;
end;

procedure TBasePlugin.RefreshWithLocate;
var
 ID:Integer;
resourcestring
 E_KEYFIELD_NOT_EXISTS_FMT = 'Keyfield %s does not exists in DataSet[%s]';
begin
 if DataSet.Active then
  ID:=KeyFieldValue
   else
  ID:=-1;
 DataSet.Close;
 DataSet.AfterScroll:=nil;
 DataSet.Open;
 if not Assigned(DataSet.FindField(FProperties.KeyField)) then
  raise Exception.CreateFmt(E_KEYFIELD_NOT_EXISTS_FMT, [FProperties.KeyField, DataSet.ProviderName]);

 Properties.StaleData:=False;
 if DataSet.Active then
  DataSet.Locate(FProperties.KeyField,ID,[]);
 DataSet.AfterScroll:=Self.DoAfterScroll;
 DoAfterScroll(DataSet);
end;

procedure TBasePlugin.ForceRefreshDataSet;
begin
 Screen.Cursor:=crHourGlass;
 try
   PopulateParams;
   FScripter.CallProcedure('BeforeOpen');
   DataSet.Params.Clear;
   DataSet.Params.Assign(Self.Params);
   DataSet.ProviderName:=Properties.ProviderName;
   DataSet.DBName:=Properties.DBName;
   RefreshWithLocate;
   FScripter.CallProcedure('AfterOpen');
 finally
  Screen.Cursor:=crDefault;
  Actions.RefreshActions;
 end;
end;

procedure TBasePlugin.ForceRefreshExecute(Sender: TObject);
begin
 ForceRefreshDataSet;
end;

procedure TBasePlugin.SelectionChanged(RecordsSelected: Integer);
begin
end;

procedure TBasePlugin.SetDBName(const Value: string);
begin
 Properties.DBName:=Value;
end;

procedure TBasePlugin.SetSideTreeFilterVisible(const Value: Boolean);
begin
 Properties.SideTreeEnabled:=Value;
 SideTreePanel.Visible:=Value;
 TreeSplitter.Visible:=Value;
 SideTreeFilterFrame.Active:=Value;
end;



procedure TBasePlugin.UncheckDialogButtons(AAction:TMiceAction);
var
 Action:TMiceAction;
begin
for Action in Actions.Values do
 if (Action.ActionType=atExecuteDialog) and (Action<>AAction) then
  Action.Checked:=False;
end;

procedure TBasePlugin.UpdateActionsActivity;
begin
 Actions.ActionByName(ACTION_NAME_EDIT_RECORD).ActivityCondition.EnabledWhenNoRecords:=False;
 Actions.ActionByName(ACTION_NAME_DELETE_RECORD).ActivityCondition.EnabledWhenNoRecords:=False;;
end;

procedure TBasePlugin.UpdateCaption;
begin
 Container.Caption:=Properties.GetPageTitle;
end;

procedure TBasePlugin.OnCreateDialogEvent(Dlg: TAdaptiveDialog);
begin
 Dlg.Script.AddObject('ActivePlugin', Self);
 Dlg.Script.AddObject('Self', Self);
 Dlg.ParentObject:=Self;
end;

procedure TBasePlugin.OnUpdatePageTitle(Sender: TObject);
begin
 if Assigned(Container.Tab) then
  Container.Tab.Caption:=Self.Properties.PageTitle;
end;

procedure TBasePlugin.ViewRecordExecute(Sender: TObject);
var
 Action:TMiceAction;
begin
 Action:=Sender as TMiceAction;
 if (EditRecord(True)) and Action.AutoRefresh then
  RefreshDataSet;
end;


procedure TBasePlugin.LoadState;
begin
 FPluginSaveLoad.LoadState;
end;

procedure TBasePlugin.SaveState;
begin
 FPluginSaveLoad.SaveDialogPanel(FDialogPanel);
 FPluginSaveLoad.SaveState;
end;


end.
