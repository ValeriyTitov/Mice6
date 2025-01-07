{$M+} // RTTI

unit Plugin.Properties;

interface

uses System.SysUtils, Data.DB, System.Classes,
     CustomControl.MiceAction,
     CustomControl.AppObject,
     Plugin.SideTreeFilter,
     DAC.XDataSet,
     DAC.XParams;

type
 TPluginProperties = class
  private
    FParams:TxParams;
    FDeleteProviderName: string;
    FProviderName: string;
    FDBName: string;
    FCalcSummaryField: string;
    FCustomAppDialogsIdField: string;
    FOrderBy: String;
    FAppDialogID: Integer;
    FReadOnly: Boolean;
    FFullExpand: Boolean;
    FDocFlow: Boolean;
    FExpandLevel: integer;
    FStaleData: Boolean;
    FRefreshLocked: Boolean;
    FKeyField: string;
    FAutoWidth: Boolean;
    FImageIndexField: string;
    FGroupByPanel: boolean;
    FSorting: Boolean;
    FFiltering: Boolean;
    FRefreshAfterCreate: Boolean;
    FDoubleClickAction: TMiceAction;
    FMiceAppObject: TMiceAppObject;
    FCurrentAction: TMiceAction;
    FSideTreeEnabled: Boolean;
    FTreeFilter: TSideTreeFilter;
    FParentIdField: string;
    FMissingItemsCreated: Boolean;
    FOnUpdateTitle: TNotifyEvent;
    FTitle: string;
    FDefaultDoubleClickActionAppCmdId: Integer;
    FDescription: string;
    FDfClassesId: Integer;
    FAppScriptsId: Integer;
    procedure SetSideTreeParamName(const Value: string);
    procedure SetSideTreeProviderName(const Value: string);
    procedure SetSideTreeKeyField(const Value: string);
    procedure SetSideTreeParentField(const Value: string);
    function GetSideTreeKeyField: string;
    function GetSideTreeParamName: string;
    function GetSideTreeParentField: string;
    function GetSideTreeProviderName: string;
    procedure SetMissingItemsCreated(const Value: Boolean);
    procedure SetSideTreeExpandLevel(const Value: Integer);
    function GetSideTreeExpandLevel: Integer;
    procedure SetDetailTitle(const Value: string);
    function GetDetailTitle: string;
    procedure SetTitle(const Value: string);
    procedure SetSideTreeCaptionField(const Value: string);
    function GetSideTreeCaptionField: string;
    function GetAppPluginsId: Integer;
    procedure SetAppPluginsId(const Value: Integer);
  protected
    procedure DoUpdateTitle;

  public
    property TreeFilter:TSideTreeFilter read FTreeFilter;
    property MissingItemsCreated:Boolean read FMissingItemsCreated write SetMissingItemsCreated;
    procedure LoadFromDataSet(DataSet:TDataSet);
    procedure LoadMultiPluginProperties(Properties:TPluginProperties);
    procedure ClearMultiPluginProperties;
    procedure CheckAppDialog;
    procedure CheckDeleteProvider;
    procedure RaiseKeyFieldException;
    function GetPageTitle:string;
    constructor Create(Params:TxParams; TreeFilter:TSideTreeFilter);
    destructor Destroy; override;


  published
    property MiceAppObject:TMiceAppObject read FMiceAppObject;
    property AppDialogID: Integer read FAppDialogID write FAppDialogID;
    property DfClassesId: Integer read FDfClassesId write FDfClassesId;
    property CustomAppDialogsIdField:string read FCustomAppDialogsIdField write FCustomAppDialogsIdField;
    property DocFlow: Boolean read FDocFlow write FDocFlow;
    property Title:string read FTitle write SetTitle;
    property Description:string read FDescription write FDescription;
    property DetailTitle:string read GetDetailTitle write SetDetailTitle;
    property DeleteProviderName:string read FDeleteProviderName write FDeleteProviderName;
    property ProviderName:string read FProviderName write FProviderName;
    property DBName:string read FDBName write FDBName;
    property OrderBy: String read FOrderBy write FOrderBy;
    property CalcSummaryField: string read FCalcSummaryField write FCalcSummaryField;
    property FullExpand: Boolean read FFullExpand write FFullExpand;
    property ExpandLevel: Integer read FExpandLevel write FExpandLevel;
    property ReadOnly: Boolean read FReadOnly write FReadOnly;
    property AppPluginsId:Integer read GetAppPluginsId write SetAppPluginsId;
    property AppScriptsId:Integer read FAppScriptsId write FAppScriptsId;

    property SideTreeEnabled:Boolean read FSideTreeEnabled write FSideTreeEnabled;
    property SideTreeKeyField:string read GetSideTreeKeyField write SetSideTreeKeyField;
    property SideTreeParentField:string read GetSideTreeParentField write SetSideTreeParentField;
    property SideTreeProviderName:string read GetSideTreeProviderName write SetSideTreeProviderName;
    property SideTreeParamName:string read GetSideTreeParamName write SetSideTreeParamName;
    property SideTreeExpandLevel:Integer read GetSideTreeExpandLevel write SetSideTreeExpandLevel;
    property SideTreeCaptionField:string read GetSideTreeCaptionField write SetSideTreeCaptionField;


    property StaleData:Boolean read FStaleData write FStaleData;
    property RefreshLocked:Boolean read FRefreshLocked write FRefreshLocked;
    property RefreshAfterCreate:Boolean read FRefreshAfterCreate write FRefreshAfterCreate;
    property KeyField:string read FKeyField write FKeyField;
    property ParentIdField:string read FParentIdField write FParentIdField;
    property AutoWidth:Boolean read FAutoWidth write FAutoWidth;
    property ImageIndexField:string read FImageIndexField write FImageIndexField;
    property GroupByPanel: boolean read FGroupByPanel write FGroupByPanel;
    property Sorting:Boolean read FSorting write FSorting;
    property Filtering:Boolean read FFiltering write FFiltering;
    property DoubleClickAction: TMiceAction read FDoubleClickAction write FDoubleClickAction;
    property DefaultDoubleClickActionAppCmdId: Integer read FDefaultDoubleClickActionAppCmdId write FDefaultDoubleClickActionAppCmdId;
    property CurrentAction:TMiceAction read FCurrentAction write FCurrentAction;
    property OnUpdateTitle:TNotifyEvent read FOnUpdateTitle write FOnUpdateTitle;
    property Params:TxParams read FParams;
    property PageTitle:string read GetPageTitle;


 end;

implementation

{ TPluginProperties }

procedure TPluginProperties.CheckAppDialog;
resourcestring
 E_DIALOG_NOT_DEFINED_FMT = 'AppDialogsId not defined in "%s", AppPluginsId %d';
begin
 if AppDialogID<=0 then
  raise Exception.CreateFmt(E_DIALOG_NOT_DEFINED_FMT, [Title, AppPluginsId]);
end;

procedure TPluginProperties.CheckDeleteProvider;
resourcestring
 S_DELETE_PROVIDER_NOT_DEFINED = 'Delete script is not defined in plugin properties';
begin
 if DeleteProviderName.IsEmpty then
  raise Exception.Create(S_DELETE_PROVIDER_NOT_DEFINED);
end;

constructor TPluginProperties.Create(Params:TxParams; TreeFilter:TSideTreeFilter);
begin
 FParams:=Params;
 FTreeFilter:=TreeFilter;
 FMiceAppObject:=TMiceAppObject.Create;
 MissingItemsCreated:=False;
 DefaultDoubleClickActionAppCmdId:=-1;
end;


destructor TPluginProperties.Destroy;
begin
  FMiceAppObject.Free;
  inherited;
end;


procedure TPluginProperties.DoUpdateTitle;
begin
 if Assigned(Self.OnUpdateTitle) then
  OnUpdateTitle(Self);
end;

function TPluginProperties.GetSideTreeKeyField: string;
begin
 Result:=TreeFilter.TreeFilter.DataController.KeyField;
end;

function TPluginProperties.GetSideTreeParamName: string;
begin
 Result:=TreeFilter.ParamName;
end;

function TPluginProperties.GetSideTreeParentField: string;
begin
 Result:=TreeFilter.TreeFilter.DataController.KeyField;
end;

function TPluginProperties.GetSideTreeProviderName: string;
begin
 Result:=TreeFilter.TreeFilter.DataSet.ProviderName;
end;

function TPluginProperties.GetSideTreeCaptionField: string;
begin
 Result:=Self.TreeFilter.CaptionField;
end;

function TPluginProperties.GetSideTreeExpandLevel: Integer;
begin
 Result:=Self.TreeFilter.ExpandLevel;
end;


procedure TPluginProperties.LoadFromDataSet(DataSet: TDataSet);
resourcestring
 E_DF_DOCFLOW_CLASS_NOT_SPECIFIED = 'DocFlow is enabled for plugin, but DocFlow class not specified in settings.';
begin
 Filtering:=True;
 if AppPluginsId=0 then
  AppPluginsId:=DataSet.FieldByName('AppPluginsId').AsInteger;
 if Title.IsEmpty then
  Title:=DataSet.FieldByName('Name').AsString;

  KeyField:=DataSet.FieldByName('KeyField').AsString;

  ProviderName:=DataSet.FieldByName('ProviderName').AsString;
  AppDialogID:=DataSet.FieldByName('AppDialogsId').AsInteger;
  CustomAppDialogsIdField:=DataSet.FieldByName('AppDialogsIdField').AsString;
  DocFlow:=DataSet.FieldByName('DocFlow').AsBoolean;
  if DocFlow and DataSet.FieldByName('dfClassesId').IsNull then
   raise Exception.Create(E_DF_DOCFLOW_CLASS_NOT_SPECIFIED);
  DfClassesId:=DataSet.FieldByName('dfClassesId').AsInteger;
  FDeleteProviderName:=DataSet.FieldByName('DelProviderName').AsString;
  DBName:=DataSet.FieldByName('DBName').AsString;
  AutoWidth:=DataSet.FieldByName('AutoWidth').AsBoolean;
  ImageIndexField:=Trim(DataSet.FieldByName('ImageIndexField').AsString);
  FullExpand:=DataSet.FieldByName('FullExpand').AsBoolean;
  ExpandLevel:=DataSet.FieldByName('ExpandLevel').AsInteger;
  ReadOnly:=DataSet.FieldByName('ReadOnly').AsBoolean;
  GroupByPanel:=DataSet.FieldByName('GroupByPanel').AsBoolean;
  Sorting:=DataSet.FieldByName('Sorting').AsBoolean;
  ParentIdField:=DataSet.FieldByName('ParentIdField').AsString;
  Description:=DataSet.FieldByName('Description').AsString;
  AppScriptsId:=DataSet.FieldByName('AppScriptsId').AsInteger;

  RefreshAfterCreate:=DataSet.FieldByName('RefreshAfterCreate').AsBoolean;

  MiceAppObject.AsJson:=DataSet.FieldByName('InitString').AsString;

  SideTreeEnabled:=DataSet.FieldByName('SideTreeEnabled').AsBoolean;
  SideTreeKeyField:=DataSet.FieldByName('SideTreeKeyField').AsString;
  SideTreeParentField:=DataSet.FieldByName('SideTreeParentField').AsString;
  SideTreeProviderName:=DataSet.FieldByName('SideTreeProviderName').AsString;
  SideTreeParamName:=DataSet.FieldByName('SideTreeParamName').AsString;
  SideTreeCaptionField:=DataSet.FieldByName('SideTreeCaptionField').AsString;

  SideTreeExpandLevel:=DataSet.FieldByName('SideTreeExpandLevel').AsInteger;

  DefaultDoubleClickActionAppCmdId:=DataSet.FieldByName('DefaultAppCmdId').AsInteger;
  //CalcSummaryField:=DataSet.FieldByName('SummuryField').AsString;
  //TreeKeyFieldValue:=DataSet.FieldByName('').AsInteger;
  //TreeParentIdField:=DataSet.FieldByName('').AsString;
end;




procedure TPluginProperties.LoadMultiPluginProperties(Properties: TPluginProperties);
begin
 AppDialogID:=Properties.AppDialogID;
 CustomAppDialogsIdField:=Properties.CustomAppDialogsIdField;
 DeleteProviderName:=Properties.DeleteProviderName;
end;


procedure TPluginProperties.RaiseKeyFieldException;
resourcestring
 S_KEYFIELD_IS_NOT_DEFINED = 'Key field is not defined!';
begin
 raise Exception.Create(S_KEYFIELD_IS_NOT_DEFINED);
end;

procedure TPluginProperties.ClearMultiPluginProperties;
begin
 AppDialogID:=0;
 CustomAppDialogsIdField:='';
 DeleteProviderName:='';
end;


function TPluginProperties.GetPageTitle: string;
begin
 if Self.DetailTitle.Trim.IsEmpty then
  Result:=Self.Title
   else
  Result:=Format('%s - %s',[Self.Title, Self.DetailTitle]);
end;


procedure TPluginProperties.SetAppPluginsId(const Value: Integer);
begin
 Params.SetParameter('AppPluginsId',Value)
end;

procedure TPluginProperties.SetDetailTitle(const Value: string);
begin
if DetailTitle<>Value then
 begin
  FParams.SetParameter('DetailTitle',Value);
  DoUpdateTitle;
 end;
end;

function TPluginProperties.GetAppPluginsId: Integer;
begin
 Result:=Params.ParamByNameDef('AppPluginsId',0);
end;

function TPluginProperties.GetDetailTitle: string;
begin
 Result:=Self.FParams.ParamByNameDef('DetailTitle','');
end;

procedure TPluginProperties.SetTitle(const Value: string);
begin
 if FTitle<>Value then
  begin
   FTitle:=Value;
   DoUpdateTitle;
  end;
end;

procedure TPluginProperties.SetMissingItemsCreated(const Value: Boolean);
begin
  FMissingItemsCreated := Value;
end;

procedure TPluginProperties.SetSideTreeKeyField(const Value: string);
begin
  TreeFilter.TreeFilter.DataController.KeyField:=Value;
end;

procedure TPluginProperties.SetSideTreeParamName(const Value: string);
begin
  TreeFilter.ParamName:=Value;
end;

procedure TPluginProperties.SetSideTreeParentField(const Value: string);
begin
  TreeFilter.TreeFilter.DataController.ParentField:=Value;
end;

procedure TPluginProperties.SetSideTreeProviderName(const Value: string);
begin
 TreeFilter.TreeFilter.DataSet.ProviderName:=Value;
end;


procedure TPluginProperties.SetSideTreeCaptionField(const Value: string);
begin
  TreeFilter.CaptionField := Value;
end;

procedure TPluginProperties.SetSideTreeExpandLevel(const Value: Integer);
begin
  Self.TreeFilter.ExpandLevel:=Value;
end;

end.
