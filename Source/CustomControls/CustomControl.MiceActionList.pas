unit CustomControl.MiceActionList;

interface
 uses Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
      Vcl.ActnList, System.Generics.Collections, System.Generics.Defaults,DB, DBCtrls, Vcl.Menus,
      Common.ActivityCondition,
      Common.StringUtils,
      Common.Images,
      Common.VariantComparator,
      CustomControl.MiceAction,
      Common.ResourceStrings;

type
 TMiceActionList = class (TObjectDictionary<string,TMiceAction>)
  private
    FDataLink:TFieldDataLink;
    function GetDataSource: TDataSource;
    procedure OnDataChange(Sender: TObject);
    procedure SetDataSource(const Value: TDataSource);
  public
    property DataSource:TDataSource read GetDataSource write SetDataSource;

    function CreateDeleteAction(const KeyField:string; Event:TNotifyEvent):TMiceAction;
    function CreateEditAction(const KeyField:string; Event:TNotifyEvent):TMiceAction;
    function CreateChangeActivityAction(const KeyField:string; Event:TNotifyEvent):TMiceAction;
    function CreateNewAction(Event:TNotifyEvent):TMiceAction;
    function CreateAddAction(Event:TNotifyEvent):TMiceAction;
    function CreateRefreshDataAction(Event:TNotifyEvent):TMiceAction;
    function CreateSaveDataAction(Event:TNotifyEvent):TMiceAction;

    function ActionByName(const AName:string):TMiceAction;
    function ActionByID(AppCmdId:Integer):TMiceAction;
    function FindAction(const AName:string):TMiceAction;
    function CreateAction(const AName, ACaption, Hint:string; const AImageIndex:Integer; const AEnabled:Boolean; Event:TNotifyEvent; const ActivityCondition:string):TMiceAction; overload;
    function CreateAction(const AName, ACaption, Hint:string; const AImageIndex:Integer; const AEnabled:Boolean; Event:TNotifyEvent):TMiceAction; overload;
    function CreateAction(const AName:string):TMiceAction; overload;
    function CreateAction(const AName:string; Item:TMenuItem; OnExecute:TNotifyEvent):TMiceAction; overload;
    function CreateAction(DataSet:TDataSet):TMiceAction; overload;

    procedure RefreshActions;
    procedure DisableHotkeys;
    procedure EnableHotKeys;

    constructor Create;
    destructor Destroy; override;

 end;

const
 ACTION_NAME_CHANGE_ACTIVITY='ChangeActivity';
 ACTION_NAME_NEW_RECORD='NewRecord';
 ACTION_NAME_NEW_GROUP='NewGroup';
 ACTION_NAME_ADD_RECORD='AddRecord';
 ACTION_NAME_EDIT_RECORD='EditRecord';
 ACTION_NAME_VIEW_RECORD='ViewRecord';
 ACTION_NAME_DELETE_RECORD='DelRecord';
 ACTION_NAME_DF_PUSH_DOCUMENT='PushDocument';
 ACTION_NAME_DF_ROLLBACK_DOCUMENT='RollBackDocument';
 ACTION_NAME_DF_SHOW_SCHEMA='ShowDfSchema';
 ACTION_NAME_DF_SHOW_TRANS='ShowDfTrans';
 ACTION_NAME_DF_SHOW_ERRORS='ShowDfErrors';

 ACTION_NAME_FORCEREFRESH='ForceRefresh';
 ACTION_NAME_REFRESHDATA='RefreshData';
 ACTION_NAME_SAVEDATA='SaveData';
 ACTION_NAME_SAVEDATA_AS='SaveDataAs';
 ACTION_NAME_EXECUTE_DIALOG='ExecuteDialog';
 ACTION_NAME_EXECUTE_SCRIPT='ExecuteScript';
 ACTION_NAME_EXECUTE_STOREDPROC='ExecuteStoredProc';
 ACTION_NAME_TOGGLE_SIDETREEFILTER='ToggleSideTreeFilter';
 ACTION_NAME_PLUGIN_INFORMATION='PluginInformation';

implementation

{ TMiceActionList }

function TMiceActionList.ActionByID(AppCmdId: Integer): TMiceAction;
var
 Action:TMiceAction;
begin
 for Action in Values do
  if Action.ID=AppCmdId then
   Exit(Action);
 Result:=nil;
end;

function TMiceActionList.ActionByName(const AName: String): TMiceAction;
resourcestring
 S_UNABLE_TO_FIND_ACTION = 'Unable to find action %s';
begin
 Result:=FindAction(AName);
 if not Assigned(Result) then
  raise Exception.CreateFmt(S_UNABLE_TO_FIND_ACTION, [QuotedStr(AName)]);
end;

constructor TMiceActionList.Create;
begin
  inherited Create([doOwnsValues],TIStringComparer.Ordinal);
  FDataLink:=TFieldDataLink.Create;
  FDataLink.OnDataChange:=OnDataChange;
  FDataLink.OnActiveChange:=OnDataChange;
end;

function TMiceActionList.CreateAction(const AName, ACaption, Hint: String;
  const AImageIndex: Integer; const AEnabled: Boolean; Event: TNotifyEvent;
  const ActivityCondition: string): TMiceAction;
begin
 Result:=CreateAction(AName, ACaption, Hint, AImageIndex,AEnabled,Event);
 if not ActivityCondition.IsEmpty then
  Result.ActivityCondition.AsString:=ActivityCondition;
end;

function TMiceActionList.CreateAction(DataSet: TDataSet): TMiceAction;
begin
 Result:=TMiceAction.Create(nil);
 Result.Name:=DataSet.FieldByName('Name').AsString;
 Result.ActivityCondition.LoadFromDataSet(DataSet);
 Add(Result.Name,Result);
end;

function TMiceActionList.CreateAction(const AName: string; Item: TMenuItem; OnExecute: TNotifyEvent): TMiceAction;
begin
 Result:=CreateAction(AName);
 Result.ImageIndex:=Item.ImageIndex;
 Result.Hint:=Item.Hint;
 Result.Caption:=Item.Caption;
 Result.OnExecute:=OnExecute;
 Result.Tag:=Item.Tag;
 Result.Enabled:=Item.Enabled;
 Result.ActivityCondition.AlwaysEnabled:=True;
 Item.Action:=Result;
end;

function TMiceActionList.CreateAddAction(Event: TNotifyEvent): TMiceAction;
begin
 Result:=CreateAction(ACTION_NAME_ADD_RECORD,S_COMMON_ADD,S_COMMON_ADD_HINT,IMAGEINDEX_ACTION_ADD, True, Event);
end;

function TMiceActionList.CreateChangeActivityAction(const KeyField: string; Event: TNotifyEvent): TMiceAction;
begin
 Result:=CreateAction(ACTION_NAME_CHANGE_ACTIVITY,S_COMMON_ACTIVITY,S_COMMON_ACTIVITY,IMAGEINDEX_ACTION_ACTIVITY,False, Event);
 Result.ActivityCondition.FieldName:=KeyField;
 Result.ActivityCondition.Equation:=veNotIsNull;
end;


function TMiceActionList.CreateDeleteAction(const KeyField: string; Event: TNotifyEvent): TMiceAction;
begin
 Result:=CreateAction(ACTION_NAME_DELETE_RECORD,S_COMMON_DELETE,S_COMMON_DELETE_HINT,IMAGEINDEX_ACTION_DELETE,False, Event);
 Result.ActivityCondition.FieldName:=KeyField;
 Result.ActivityCondition.Equation:=veNotIsNull;
end;

function TMiceActionList.CreateEditAction(const KeyField: string; Event: TNotifyEvent): TMiceAction;
begin
 Result:=CreateAction(ACTION_NAME_EDIT_RECORD,S_COMMON_EDIT,S_COMMON_EDIT_HINT,IMAGEINDEX_ACTION_EDIT, False, Event);
 Result.ActivityCondition.FieldName:=KeyField;
 Result.ActivityCondition.Equation:=veNotIsNull;
end;

function TMiceActionList.CreateNewAction(Event: TNotifyEvent): TMiceAction;
begin
 Result:=CreateAction(ACTION_NAME_NEW_RECORD,S_COMMON_NEW,S_COMMON_NEW_HINT,IMAGEINDEX_ACTION_NEW, True, Event);
end;

function TMiceActionList.CreateRefreshDataAction(Event: TNotifyEvent): TMiceAction;
begin
 Result:=CreateAction(ACTION_NAME_REFRESHDATA,S_COMMON_REFRESH,S_COMMON_REFRESH_HINT,IMAGEINDEX_ACTION_REFRESH, True, Event);
end;

function TMiceActionList.CreateSaveDataAction(Event: TNotifyEvent): TMiceAction;
begin
 Result:=CreateAction(ACTION_NAME_SAVEDATA,S_COMMON_SAVE,S_COMMON_SAVE_HINT,IMAGEINDEX_ACTION_SAVE, True, Event);
end;

function TMiceActionList.CreateAction(const AName:string): TMiceAction;
begin
 Result:=TMiceAction.Create(nil);
 Result.Name:=AName;
 Add(Result.Name, Result)
end;

procedure TMiceActionList.SetDataSource(const Value: TDataSource);
begin
  FDataLink.DataSource := Value;
end;

function TMiceActionList.GetDataSource: TDataSource;
begin
 Result:=FDataLink.DataSource;
end;

function TMiceActionList.CreateAction(const AName, ACaption, Hint: string;  const AImageIndex: Integer; const AEnabled: Boolean;  Event: TNotifyEvent): TMiceAction;
begin
 Result:=TMiceAction.Create(nil);
 Result.Name:=AName;
 Result.Caption:=ACaption;
 Result.ImageIndex:=AImageIndex;
 Result.Enabled:=AEnabled;
 Result.ActivityCondition.AlwaysEnabled:=AEnabled;
 Result.OnExecute:=Event;
 Result.Hint:=Hint;
 Add(Result.Name,Result)
end;

destructor TMiceActionList.Destroy;
begin
  FDataLink.Free;
  inherited;
end;

procedure TMiceActionList.DisableHotkeys;
var
 AAction:TMiceAction;
begin
 for AAction in Values do
  AAction.HotKey:='';
end;

procedure TMiceActionList.EnableHotKeys;
var
 AAction:TMiceAction;
begin
 for AAction in Values do
  AAction.HotKey:=AAction.OriginalHotKey;
end;

function TMiceActionList.FindAction(const AName: string): TMiceAction;
begin
if ContainsKey(AName) then
 Result:=Items[AName]
  else
 Result:=nil;
end;


procedure TMiceActionList.OnDataChange(Sender: TObject);
var
 Action:TMiceAction;
begin
 for Action in Values do
   Action.Enabled:=Action.ActivityCondition.EnabledForDataSet(FDataLink.DataSet) and Assigned(Action.OnExecute);
end;



procedure TMiceActionList.RefreshActions;
begin
 OnDataChange(FDataLink);
end;

end.
