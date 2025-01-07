unit MainForm.Actions;

interface

uses System.Classes, System.SysUtils, System.Variants, Data.DB, Dialogs, dxBar,
     CustomControl.MiceAction,
     CustomControl.MiceActionList,
     Common.VariantComparator,
     Common.ResourceStrings,
     Common.ResourceStrings.Manager,
     Common.Images.SelectDialog,
     Common.DBFile,
     Common.Images,
     DAC.XDataSet,
     DAC.DatabaseUtils,
     StaticDialog.DBNameSelector,
     StaticDialog.MiceInputBox,
     ManagerDialog.ExternalFile,
     ManagerEditor.Common,
     ManagerEditor.Command,
     Manager.WindowManager,
     Manager.CommonCommandsList,
     ManagerEditor.AppDataSet,
     ManagerEditor.AppTemplate,
     ManagerEditor.Script.PascalScript,
     ManagerEditor.Plugin,
     MainForm.CaptionUpdater,
     MainForm.TreeRefresher,
     MainForm.ItemDelete;


type

 TMainFormActions = class
 strict private
    FWindowManager:TWindowManager;
    FActionList:TMiceActionList;
    FDataSet:TDataSet;
    FCommonCommands:TCommonCommands;
    procedure CreateActions;
    procedure InternalUpdateMainTreeDBName(AppMainTreeId:Integer; const DBName:string);
 private
    procedure NewFolderActionExecute(Sender:TObject);
    procedure NewCommandGroupActionExecute(Sender:TObject);
    procedure NewPluginActionExecute(Sender:TObject);

    procedure NewCommandActionExecute(Sender:TObject);
    procedure NewFilterActionExecute(Sender:TObject);
    procedure NewDialogActionExecute(Sender:TObject);
    procedure NewDialogLayoutActionExecute(Sender:TObject);
    procedure NewDfClassActionExecute(Sender:TObject);
    procedure NewDfTypesActionExecute(Sender:TObject);
    procedure CommandScriptActionExecute(Sender:TObject);
    procedure PluginScriptActionExecute(Sender:TObject);
    procedure ToggleUseOnMainTreeActionExecute(Sender:TObject);
    procedure UpdateMainTreeDBName(Sender:TObject);


    procedure NewSQLScriptActionExecute(Sender:TObject);
    procedure NewPascalScriptActionExecute(Sender:TObject);
    procedure NewCSharpScriptActionExecute(Sender:TObject);
    procedure NewXmlTextActionExecute(Sender:TObject);
    procedure NewJsonTextActionExecute(Sender:TObject);
    procedure NewExternalFileActionExecute(Sender:TObject);
    procedure NewAppTemplateActionExecute(Sender:TObject);
    procedure NewAppDataSetActionExecute(Sender:TObject);



    procedure EditItemActionExecute(Sender:TObject);
    procedure EditCommonAppCmdActionExecute(Sender:TObject);
    procedure EditDfSchemaActionExecute(Sender: TObject);

    procedure AddCommonAppCmdActionExecute(Sender:TObject);
    procedure AddCommonAppFilterActionExecute(Sender:TObject);

    procedure RenameItemActionExecute(Sender:TObject);
    procedure DeleteItemActionExecute(Sender:TObject);
    procedure ChangeImageIndexExecute(Sender:TObject);
    procedure RefreshMainTreeActionExecute(Sender:TObject);
    procedure CommonCommandsActionExecute(Sender:TObject);
    procedure AddNewCommonCommandClick(Sender:TObject);

    procedure InternalEditCommand(ID:Integer);
    procedure InternalEditCommonCommand(ID:Integer);
    procedure InternalEditPlugin(Id, AppMainTreeId, ImageIndex:Integer);
    procedure InternalEditPascalScript(ID:Integer);
    procedure ShowCommonCommandList;
    procedure FillCommonCommandMenuFromDataSet(DataSet:TDataSet; Item:TdxBarSubItem; AppPluginsId, AppMainTreeId:Integer);
    function InternalGetFileName(ID:Integer; var AName:string):Boolean;
    function InsertCommonAppCmd(AppPluginsId, AppCmdId, AppMainTreeId:Integer):Integer;

 public
    constructor Create(DataSource:TDataSource);
    destructor Destroy; override;
    function CurrentImageIndex:Integer;
    function CurrentiType:Integer;
    function CurrentParentId:Integer;
    function CurrentKeyValue:Integer;
    function CurrentObjectId:Integer;
    function CurrentDBname:string;
    function CurrentOwnerObjectId:Integer;
    function ActionByName(const AName:string):TMiceAction;
    procedure NewFolderDlg(const ParentId:Integer);
    procedure NewExternalFileDlg(const ParentId:Integer);
    procedure NewCommandGroup(const ParentId:Integer; AppPluginsId:Integer);
    procedure FillCommonCommandMenu(AppMainTreeId, AppPluginsId:Integer; Item:TdxBarSubItem);
 end;


implementation

{ TMainFormActions }

type
 TdxAppCmdBarButton = class(TdxBarButton)
  private
    FAppCmdId: Integer;
    FAppPluginsId: Integer;
    FiType: Integer;
    FParentId: Integer;
  public
    property AppCmdId:Integer read FAppCmdId write FAppCmdId;
    property AppPluginsId:Integer read FAppPluginsId write FAppPluginsId;
    property iType:Integer read FiType write FiType;
    property ParentId:Integer read FParentId write FParentId;
 end;


function TMainFormActions.ActionByName(const AName: string): TMiceAction;
begin
 Result:=Self.FActionList.ActionByName(AName);
end;

procedure TMainFormActions.AddCommonAppCmdActionExecute(Sender: TObject);
begin
 FWindowManager.NewCommonItem(iTypeCommonCommand,-1,-1,-1, FCommonCommands.Requery);
end;

procedure TMainFormActions.AddCommonAppFilterActionExecute(Sender: TObject);
begin
 FWindowManager.NewCommonItem(iTypeCommonFilter,-1,-1,-1, FCommonCommands.Requery);
end;


procedure TMainFormActions.ChangeImageIndexExecute(Sender: TObject);
var
 ImageIndex:Integer;
 AppMainTreeId:Integer;
 ParentId:Integer;
 Desc:string;
begin
 AppMainTreeId:=CurrentKeyValue;
 ImageIndex:=CurrentImageIndex;
 ParentId:=CurrentParentId;
 Desc:=Self.FDataSet.FieldByName('Description').AsString;
 if TSelectImageDialog.Execute(ImageIndex) then
  begin
   TCaptionUpdater.UpdateTreeItemImageIndex(AppMainTreeId, ImageIndex);
   TMainFormTreeRefresher.DefaultInstance.ItemUpdated(AppMainTreeId,ParentId,Desc,ImageIndex);
  end;
end;

procedure TMainFormActions.CommonCommandsActionExecute(Sender: TObject);
begin
 ShowCommonCommandList;
end;

constructor TMainFormActions.Create(DataSource:TDataSource);
begin
 FActionList:=TMiceActionList.Create;
 FActionList.DataSource:=DataSource;
 FDataSet:=DataSource.DataSet;
 FWindowManager:=TWindowManager.Create;
 CreateActions;
end;

procedure TMainFormActions.CreateActions;
var
 Action:TMiceAction;
begin
 Action:=FActionList.CreateAction('NewFolder',S_NEW_FOLDER,S_NEW_FOLDER_HINT,IMAGEINDEX_FOLDER,False,NewFolderActionExecute,'iType in (NULL,0, 1)');
 Action.ActivityCondition.EnabledWhenNoRecords:=True;
 Action.Hotkey:='Insert';
 Action:=FActionList.CreateAction('Edit',S_COMMON_EDIT,'',IMAGEINDEX_ACTION_EDIT,False,EditItemActionExecute,'iType is not null');
 Action.Hotkey:='Enter';
 Action:=FActionList.CreateAction('RenameItem',S_RENAME_ITEM,S_RENAME_ITEM_HINT,IMAGEINDEX_ACTION_RENAME,False,RenameItemActionExecute,'iType in (0,1,2,3,7,9,10,11,12,13,14,15,16,17,18)');
 Action.Hotkey:='F2';
 Action:=FActionList.CreateAction('ChangeImageIndex',S_CHANGE_IMAGEINDEX,S_CHANGE_IMAGEINDEX_HINT,379,False,ChangeImageIndexExecute,'iType in (1,2,3,7,9)');
 Action.Hotkey:='F4';
 Action:=FActionList.CreateAction('Refresh',S_COMMON_REFRESH,S_REFRESH_MAINTREE_HINT,IMAGEINDEX_ACTION_REFRESH,True,RefreshMainTreeActionExecute,'');
 Action.Hotkey:='F5';
 Action:=FActionList.CreateAction('Delete',S_COMMON_DELETE,'',IMAGEINDEX_ACTION_DELETE,False,DeleteItemActionExecute,ItemDeleteFilter);
 Action.Hotkey:='DEL';


 FActionList.CreateAction('NewSQLScript',S_NEW_SQL_SCRIPT,S_NEW_SQL_SCRIPT_HINT,IMAGEINDEX_ITYPE_SCRIPT_SQL,False,NewSQLScriptActionExecute,'iType in (0,1,2,11)');
 FActionList.CreateAction('NewPascalScript',S_NEW_PASCAL_SCRIPT,S_NEW_PASCAL_SCRIPT_HINT,IMAGEINDEX_ITYPE_SCRIPT_PASCAL,False,NewPascalScriptActionExecute,'iType in (1,2,3)');
 FActionList.CreateAction('NewCSharpScript',S_NEW_CSHARP_SCRIPT,S_NEW_CSHARP_SCRIPT_HINT,IMAGEINDEX_ITYPE_SCRIPT_CSHARP,False,NewCSharpScriptActionExecute,'iType in (0,1,2,11)');
 FActionList.CreateAction('NewXml',S_NEW_XML_TEXT,S_NEW_XML_TEXT_HINT,IMAGEINDEX_MIME_XML,False,NewXmlTextActionExecute,'iType in (0,1)');
 FActionList.CreateAction('NewJson',S_NEW_JSON_TEXT,S_NEW_JSON_TEXT_HINT,IMAGEINDEX_MIME_JSON,False,NewJsonTextActionExecute,'iType in (0,1)');
 FActionList.CreateAction('NewExternalFile',S_NEW_EXTERNAL_FILE,S_NEW_EXTERNAL_FILE_HINT,IMAGEINDEX_EXTERNAL_FILE,False,NewExternalFileActionExecute,'iType=0');
 FActionList.CreateAction('NewAppTemplate',S_NEW_APP_TEMPLATE,S_NEW_APP_TEMPLATE_HINT,IMAGEINDEX_ITYPE_APP_TEMPLATE,False,NewAppTemplateActionExecute,'iType IN (0,1)');
 FActionList.CreateAction('NewAppDataSet',S_NEW_DATASET,S_NEW_DATASET_HINT,IMAGEINDEX_ITYPE_APP_DATASET,False,NewAppDataSetActionExecute,'iType IN (0,1)');
 FActionList.CreateAction('NewDfClass',S_NEW_DFCLASS,S_NEW_DFCLASS_HINT,IMAGEINDEX_ITYPE_DFCLASS,False,NewDfClassActionExecute,'iType = 1');
 FActionList.CreateAction('NewDfTypes',S_NEW_DFTYPES,S_NEW_DFTYPES_HINT,IMAGEINDEX_ITYPE_DFTYPES,False,NewDfTypesActionExecute,'iType = 19');

 FActionList.CreateAction('EditDFScheme',S_EDIT_DFSCHEME,S_EDIT_DFSCHEME_HINT,IMAGEINDEX_ITYPE_DFSCHEME,False,EditDfSchemaActionExecute,'iType = 20');

 FActionList.CreateAction('NewPlugin',S_NEW_PLUGIN,S_NEW_PLUGIN_HINT,IMAGEINDEX_ITYPE_PLUGIN,False,NewPluginActionExecute,'iType in (0,1)');
 FActionList.CreateAction('NewAppDialog',S_NEW_DIALOG,S_NEW_DIALOG_HINT,IMAGEINDEX_ITYPE_DIALOG,False,NewDialogActionExecute,'iType=1');
 FActionList.CreateAction('NewAppDialogLayout',S_NEW_DIALOG_LAYOUT,S_NEW_DIALOG_LAYOUT_HINT,IMAGEINDEX_ITYPE_LAYOUT,False,NewDialogLayoutActionExecute,'iType=2');
 FActionList.CreateAction('NewCommand',S_NEW_COMMAND,S_NEW_COMMAND_HINT,IMAGEINDEX_COMMAND,False,NewCommandActionExecute,'iType=10');
 FActionList.CreateAction('NewFilter',S_NEW_FILTER,S_NEW_FILTER_HINT,IMAGEINDEX_FILTER,False,NewFilterActionExecute,'iType=10');
 FActionList.CreateAction('NewCommandGroup',S_NEW_COMMAND_GROUP,S_NEW_COMMAND_GROUP_HINT,IMAGEINDEX_COMMANDGROUP,False,NewCommandGroupActionExecute,'iType=1');

 FActionList.CreateAction('AddRefPlugin',S_NEW_PLUGIN_REF,S_NEW_PLUGIN_REF_HINT,IMAGEINDEX_ITYPE_PLUGIN,False,nil,'iType in (0,1)');
 FActionList.CreateAction('AddRefDialog',S_NEW_DIALOG_REF,S_NEW_DIALOG_REF_HINT,IMAGEINDEX_ITYPE_DIALOG,False,nil,'iType in (0,1)');

 FActionList.CreateAction('CommonCommands',S_COMMON_COMMANDS,S_COMMON_COMMANDS_HINT,382,True,CommonCommandsActionExecute);


 Action:=FActionList.CreateAction('UseOnMainTree', S_CHANGE_USE_ON_MAINTREE,S_CHANGE_USE_ON_MAINTREE_HINT,73,False,ToggleUseOnMainTreeActionExecute,'iType in (0,1)');
 Action.HotKey:='F6';

 Action:= FActionList.CreateAction('Find',S_COMMMON_ACTION_FIND,S_COMMMON_ACTION_FIND_HINT,IMAGEINDEX_ACTION_FIND,True,nil);
 Action.HotKey:='CTRL+F';

 Action:= FActionList.CreateAction('FindNext',S_COMMMON_ACTION_FIND_NEXT,S_COMMMON_ACTION_FIND_NEXT_HINT,IMAGEINDEX_ACTION_FIND_NEXT,False,nil);
 Action.HotKey:='F3';


end;

function TMainFormActions.CurrentDBname: string;
begin
 Result:= FDataSet.FieldByName('DBName').AsString;
end;

function TMainFormActions.CurrentImageIndex: Integer;
begin
 Result:=FDataSet.FieldByName('ImageIndex').AsInteger;
end;

function TMainFormActions.CurrentiType: Integer;
begin
 Result:=FDataSet.FieldByName('iType').AsInteger;
end;

function TMainFormActions.CurrentKeyValue: Integer;
begin
 Result:=FDataSet.FieldByName('AppMainTreeId').AsInteger;
end;

function TMainFormActions.CurrentObjectId: Integer;
begin
  Result:=FDataSet.FieldByName('ObjectId').AsInteger;
end;

function TMainFormActions.CurrentParentId: Integer;
begin
 Result:=FDataSet.FieldByName('ParentId').AsInteger;
end;

function TMainFormActions.CurrentOwnerObjectId: Integer;
begin
 Result:=TMainFormTreeRefresher.DefaultInstance.MainTree.FocusedNode.Parent.Values[4];
end;

procedure TMainFormActions.DeleteItemActionExecute(Sender: TObject);
var
 ItemDelete:TMainFormItemDelete;
begin
 ItemDelete:=TMainFormItemDelete.Create;
  try
   ItemDelete.AppMainTreeId:=Self.CurrentKeyValue;
   ItemDelete.ObjectId:=Self.CurrentObjectId;
   ItemDelete.iType:=Self.CurrentiType;
   ItemDelete.DBName:=Self.CurrentDBname;
   ItemDelete.Node:=TMainFormTreeRefresher.DefaultInstance.MainTree.FocusedNode;
   if (ItemDelete.Execute) then
    TMainFormTreeRefresher.DefaultInstance.ItemDeleted(ItemDelete.AppMainTreeId);
  finally
    ItemDelete.Free;
  end;
end;

destructor TMainFormActions.Destroy;
begin
  FActionList.Free;
  FWindowManager.Free;
  FCommonCommands.Free;
  inherited;
end;

procedure TMainFormActions.EditCommonAppCmdActionExecute(Sender: TObject);
var
 DataSet:TDataSet;
 iType:Integer;
 AppCmdId:Integer;
begin
 DataSet:=FCommonCommands.DataSource.DataSet;
 iType:=DataSet.FieldByName('iType').AsInteger;
 AppCmdId:=DataSet.FieldByName('AppCmdId').AsInteger;

 case iType of
  iTypeCommonCommand: InternalEditCommonCommand(AppCmdId);
  iTypeCommonFilter: FWindowManager.EditCommonItem(iType,AppCmdId,-1,-1,-1,-1, FCommonCommands.Requery);
 end;


end;

procedure TMainFormActions.EditItemActionExecute(Sender: TObject);
begin
 case CurrentiType of
  iTypeFolder: RenameItemActionExecute(Sender);
  iTypeCommandGroup:;
  iTypeExternalFile:TExternalFileDlg.ShowDialog(CurrentObjectId);
  iTypeCommand:InternalEditCommand(CurrentObjectId);
  iTypePlugin:InternalEditPlugin(CurrentObjectId, CurrentKeyValue, CurrentImageIndex );
  iTypePascalScript:InternalEditPascalScript(CurrentObjectId);
 else
  FWindowManager.EditItem(CurrentiType,CurrentObjectId, CurrentKeyValue, CurrentImageIndex, CurrentParentId, CurrentOwnerObjectId, nil, CurrentDBname);
 end;

end;


procedure TMainFormActions.InternalEditCommand(ID:Integer);
var
 Editor:TCommonManagerDialog;
begin
 if ID<0 then
  Editor:=FWindowManager.FindOrCreateNewEditor(iTypeCommand,CurrentKeyValue, CurrentOwnerObjectId , IMAGEINDEX_COMMAND)
   else
  Editor:=FWindowManager.FindOrCreateEditor(iTypeCommand,ID, CurrentKeyValue, CurrentImageIndex, CurrentParentId, CurrentOwnerObjectId);
 (Editor as TManagerEditorCommand).OnEditScript:=CommandScriptActionExecute;
 Editor.SetParameter('iType', iTypeCommand);
 FWindowManager.ShowEditor(Editor, ID );
end;

procedure TMainFormActions.InternalEditCommonCommand(ID: Integer);
var
 Editor:TCommonManagerDialog;
begin
 if ID<0 then
  Editor:=FWindowManager.FindOrCreateNewEditor(iTypeCommonCommand,-1, -1 , -1)
   else
    begin
     Editor:=FWindowManager.FindOrCreateEditor(iTypeCommonCommand,ID, -1, -1, -1, -1);
     Editor.ReadOnly:=False;
     Editor.CloseEvent:=FCommonCommands.Requery;
    (Editor as TManagerEditorCommonCommand).OnEditScript:=CommandScriptActionExecute;
    end;
 FWindowManager.ShowEditor(Editor, ID );
end;

procedure TMainFormActions.InternalEditPascalScript(ID: Integer);
var
 Editor:TCommonManagerDialog;
 IType:Integer;
 PageName:string;
begin
 if ID<0 then
  begin
   Editor:=FWindowManager.FindOrCreateNewEditor(iTypePascalScript,CurrentKeyValue, CurrentObjectId, IMAGEINDEX_ITYPE_SCRIPT_PASCAL);
   IType:=CurrentIType;
   PageName:='Script.pas'
  end
   else
  begin
   Editor:=FWindowManager.FindOrCreateEditor(iTypePascalScript,ID, CurrentKeyValue, CurrentImageIndex, CurrentParentId, CurrentOwnerObjectId);
   IType:=TMainFormTreeRefresher.DefaultInstance.MainTree.FocusedNode.Parent.Values[5];
   PageName:='';
  end;


 Editor.SetParameter('iType',IType);

 FWindowManager.ShowEditor(Editor, ID, PageName );
end;

procedure TMainFormActions.InternalEditPlugin(Id, AppMainTreeId, ImageIndex: Integer);
var
 Editor:TCommonManagerDialog;
begin
 if ID<0 then
  Editor:=FWindowManager.FindOrCreateNewEditor(iTypePlugin,-1, -1 , -1)
   else
  Editor:=FWindowManager.FindOrCreateEditor(iTypePlugin,ID, AppMainTreeId, ImageIndex, -1, -1);

 (Editor as TManagerEditorPlugin).OnEditScript:=PluginScriptActionExecute;
 FWindowManager.ShowEditor(Editor, ID );
end;

function TMainFormActions.InternalGetFileName(ID: Integer; var AName:string):Boolean;
var
 AUser:string;
 ADescription:string;
 ADate:TDateTime;
 ASize:Int64;
begin
 AName:=TDBFile.GetAppBinaryFileDetails(ID,Self.CurrentDBname, ASize,AUser, ADescription,ADate);
 Result:=TCaptionUpdater.ExecuteDlg(CurrentKeyValue,CurrentObjectId, CurrentiType, AName, CurrentDBname)
end;

procedure TMainFormActions.InternalUpdateMainTreeDBName(AppMainTreeId: Integer; const DBName: string);
var
 Tmp:TxDataSet;
begin
 Tmp:=TxDataSet.Create(nil);
 try
  Tmp.ProviderName:='spui_AppUpdateMainTreeDbName';
  Tmp.SetParameter('AppMainTreeId',AppMainTreeId);
  Tmp.SetParameter('DBName',DBName);
  Tmp.Execute;
  TMainFormTreeRefresher.DefaultInstance.CompleteRefresh;
 finally
  Tmp.Free;
 end;
end;

procedure TMainFormActions.RefreshMainTreeActionExecute(Sender: TObject);
begin
 TMainFormTreeRefresher.DefaultInstance.CompleteRefresh;
end;

procedure TMainFormActions.RenameItemActionExecute(Sender: TObject);
var
 ACaption:string;
 AResult:Boolean;
begin
 ACaption:=FDataSet.FieldByName('Description').AsString;

 case CurrentiType of
  iTypeAppDataSet: AResult:=TManagerDialogAppDataSet.ExecuteRenameDialog(CurrentObjectId,CurrentKeyValue, ACaption);
  iTypeAppTemplate: AResult:=TManagerEditorAppTemplate.ExecuteRenameDialog(CurrentObjectId, CurrentKeyValue, ACaption);
  iTypeExternalFile : AResult:=InternalGetFileName(CurrentObjectId,ACaption);
   else
  AResult:=TCaptionUpdater.ExecuteDlg(CurrentKeyValue,CurrentObjectId, CurrentiType, ACaption, CurrentDBname)
 end;

 if AResult then
  TMainFormTreeRefresher.DefaultInstance.ItemUpdated(CurrentKeyValue,CurrentParentId, ACaption, FDataSet.FieldByName('ImageIndex').AsInteger);
end;



procedure TMainFormActions.ShowCommonCommandList;
begin
 if not Assigned(FCommonCommands) then
  begin
   FCommonCommands:=TCommonCommands.Create(nil);
   FCommonCommands.bnEdit.Action.OnExecute:=EditCommonAppCmdActionExecute;
   FCommonCommands.bnNewCommand.OnClick:=AddCommonAppCmdActionExecute;
   FCommonCommands.bnNewFilter.OnClick:=AddCommonAppFilterActionExecute;
   FCommonCommands.Initialize;
  end;

 FCommonCommands.Show;
end;

procedure TMainFormActions.ToggleUseOnMainTreeActionExecute(Sender: TObject);
var
 AppMainTreeId:Integer;
 UseOn:Boolean;
begin
 UseOn:=FDataSet.FieldByName('UseOnMainTree').AsBoolean;
 AppMainTreeId:=FDataSet.FieldByName('AppMainTreeId').AsInteger;
 TCaptionUpdater.UpdateAppMainTreeUseOn(AppMainTreeId, not UseOn);
 TMainFormTreeRefresher.DefaultInstance.CompleteRefresh;
end;

procedure TMainFormActions.UpdateMainTreeDBName(Sender: TObject);
var
 Editor:TCommonManagerDialog;
begin
 Editor:=Sender as TCommonManagerDialog;
 if Editor.DBName<>'' then
  InternalUpdateMainTreeDBName(Editor.AppMainTreeId, Editor.DBName)
end;

procedure TMainFormActions.NewAppDataSetActionExecute(Sender: TObject);
begin
 FWindowManager.NewItem(iTypeAppDataSet,CurrentKeyValue, CurrentObjectId, IMAGEINDEX_ITYPE_APP_DATASET, nil,'');
end;

procedure TMainFormActions.NewCommandActionExecute(Sender: TObject);
begin
 Self.InternalEditCommand(-1);
end;

procedure TMainFormActions.CommandScriptActionExecute(Sender: TObject);
var
 Dlg: TManagerEditorCommand;
 Editor:TCommonManagerDialog;
 ID:Integer;
const
 SkipInsertToMainTree = 10;
begin
 Dlg:=Sender as TManagerEditorCommand;
 if Dlg.AppScriptsId<=0 then
  ID:=-1
   else
  ID:=Dlg.AppScriptsId;

  if ID<0 then
  Editor:=FWindowManager.FindOrCreateNewEditor(iTypePascalScript,Dlg.AppMainTreeId, Dlg.ID, IMAGEINDEX_ITYPE_SCRIPT_PASCAL)
   else
  Editor:=FWindowManager.FindOrCreateEditor(iTypePascalScript,Dlg.AppScriptsId, Dlg.AppMainTreeId, IMAGEINDEX_ITYPE_SCRIPT_PASCAL, Dlg.AppMainTreeId,Dlg.OwnerObjectId);

  Editor.SetParameter('Flags',SkipInsertToMainTree);

  Editor.SetParameter('iType',iTypeCommand);
  FWindowManager.ShowEditor(Editor,ID, Dlg.AppMainTreeDescription+'.pas');
end;


procedure TMainFormActions.NewCommandGroup(const ParentId: Integer; AppPluginsId:Integer);
var
 NewId:Integer;
begin
 NewId:=TDataBaseUtils.NewTreeItem('Commands',ParentId,iTypeCommandGroup,AppPluginsId,IMAGEINDEX_COMMANDGROUP);
 TMainFormTreeRefresher.DefaultInstance.ItemInserted(NewID,ParentId,'Commands',iTypeCommandGroup,NewID,IMAGEINDEX_COMMANDGROUP);
end;

procedure TMainFormActions.NewCommandGroupActionExecute(Sender: TObject);
begin
 NewCommandGroup(CurrentKeyValue, CurrentObjectId);
end;

procedure TMainFormActions.NewCSharpScriptActionExecute(Sender: TObject);
begin
  FWindowManager.NewItem(iTypeCSharpScript,CurrentKeyValue, CurrentObjectId, IMAGEINDEX_ITYPE_SCRIPT_CSHARP, nil,'');
end;

procedure TMainFormActions.NewDfClassActionExecute(Sender: TObject);
var
 s:string;
begin
 s:='';
 if TDBNameSelectorDialog.Execute(s) then
  FWindowManager.NewItem(iTypeDFClass,CurrentKeyValue,CurrentObjectId,IMAGEINDEX_ITYPE_DFCLASS, UpdateMainTreeDBName ,s);
end;

procedure TMainFormActions.EditDfSchemaActionExecute(Sender: TObject);
begin
 FWindowManager.EditItem(iTypeDfScheme,CurrentObjectId, CurrentKeyValue, CurrentImageIndex, CurrentParentId, CurrentOwnerObjectId, nil, CurrentDBName);
end;

procedure TMainFormActions.NewDfTypesActionExecute(Sender: TObject);
begin
 FWindowManager.NewItem(iTypeDfTypes,CurrentKeyValue,CurrentObjectId,IMAGEINDEX_ITYPE_DFTYPES, UpdateMainTreeDBName,CurrentDBName);
end;

procedure TMainFormActions.NewDialogActionExecute(Sender: TObject);
begin
 FWindowManager.NewItem(iTypeDialog,CurrentKeyValue,CurrentObjectId,IMAGEINDEX_ITYPE_DIALOG, nil,'');
end;

procedure TMainFormActions.NewDialogLayoutActionExecute(Sender: TObject);
begin
  FWindowManager.NewItem(iTypeAppDialogLayout,CurrentKeyValue,CurrentObjectId,IMAGEINDEX_ITYPE_LAYOUT, nil, '');
end;

procedure TMainFormActions.NewAppTemplateActionExecute(Sender: TObject);
begin
 FWindowManager.NewItem(iTypeAppTemplate,CurrentKeyValue,CurrentObjectId,IMAGEINDEX_ITYPE_APP_TEMPLATE, nil, '');
end;

procedure TMainFormActions.NewExternalFileActionExecute(Sender: TObject);
begin
  NewExternalFileDlg(CurrentKeyValue);
end;

procedure TMainFormActions.NewExternalFileDlg(const ParentId: Integer);
var
 FileName:string;
 ID:Integer;
 AImageIndex:Integer;
begin
 ID:=-1;
 if TExternalFileDlg.NewFileDlg(FileName, ID, CurrentDBName) then
  begin
   AImageIndex:=TImageContainer.FileExtToImageIndex(FileName);
   TDataBaseUtils.NewTreeItem(FileName,ParentId,iTypeExternalFile,ID,AImageIndex);
   TMainFormTreeRefresher.DefaultInstance.CompleteRefresh;
  end;
end;

procedure TMainFormActions.NewXmlTextActionExecute(Sender: TObject);
begin
 FWindowManager.NewItem(iTypeXmlText,CurrentKeyValue, CurrentObjectId, IMAGEINDEX_MIME_XML,nil, '');
end;

procedure TMainFormActions.PluginScriptActionExecute(Sender: TObject);
var
 Dlg: TManagerEditorPlugin;
 Editor:TCommonManagerDialog;
 ID:Integer;
const
 UpdatePluginFlag = 1000;
begin
 Dlg:=Sender as TManagerEditorPlugin;
 if Dlg.AppScriptsId<=0 then
  ID:=-1
   else
  ID:=Dlg.AppScriptsId;

  if ID<0 then
  Editor:=FWindowManager.FindOrCreateNewEditor(iTypePascalScript,Dlg.AppMainTreeId, Dlg.ID, IMAGEINDEX_ITYPE_SCRIPT_PASCAL)
   else
  Editor:=FWindowManager.FindOrCreateEditor(iTypePascalScript,Dlg.AppScriptsId, Dlg.AppMainTreeId, IMAGEINDEX_ITYPE_SCRIPT_PASCAL, Dlg.AppMainTreeId,Dlg.OwnerObjectId);

  Editor.SetParameter('Flags',UpdatePluginFlag);
  Editor.SetParameter('iType', iTypePlugin);

 FWindowManager.ShowEditor(Editor,ID, Dlg.AppMainTreeDescription+'.pas');
end;

procedure TMainFormActions.NewJsonTextActionExecute(Sender: TObject);
begin
 FWindowManager.NewItem(iTypeJsonText,CurrentKeyValue, CurrentObjectId, IMAGEINDEX_MIME_JSON, nil, '');
end;

procedure TMainFormActions.NewPascalScriptActionExecute(Sender: TObject);
begin
 Self.InternalEditPascalScript(-1);
/// FWindowManager.NewItem(iTypePascalScript,CurrentKeyValue, CurrentObjectId, IMAGEINDEX_SCRIPT_PASCAL, nil);
end;

procedure TMainFormActions.NewPluginActionExecute(Sender: TObject);
begin
 FWindowManager.NewItem(iTypePlugin,CurrentKeyValue, CurrentObjectId, IMAGEINDEX_ITYPE_PLUGIN, nil, '');
end;

procedure TMainFormActions.NewSQLScriptActionExecute(Sender: TObject);
begin
 FWindowManager.NewItem(iTypeSQLScript,CurrentKeyValue, CurrentObjectId, IMAGEINDEX_ITYPE_SCRIPT_SQL, nil,'');
end;

procedure TMainFormActions.NewFilterActionExecute(Sender: TObject);
begin
 FWindowManager.NewItem(iTypeFilter,CurrentKeyValue,CurrentObjectId,IMAGEINDEX_FILTER, nil, '');
end;

procedure TMainFormActions.NewFolderActionExecute(Sender: TObject);
begin
 NewFolderDlg(CurrentKeyValue);
end;

procedure TMainFormActions.NewFolderDlg(const ParentId: Integer);
var
 s:string;
 NewID:Integer;
begin
 if TMiceInputBox.Execute(IMAGEINDEX_ITYPE_NEW_FOLDER,s, S_FOLDER_NAME, S_INPUT_NEW_FOLDERNAME) then
  begin
   if ParentId=0 then
     NewID:=TDataBaseUtils.NewTreeItem(s,NULL,0,0,IMAGEINDEX_FOLDER)
      else
     NewId:=TDataBaseUtils.NewTreeItem(s,ParentId,0,0,IMAGEINDEX_FOLDER);

   TMainFormTreeRefresher.DefaultInstance.ItemInserted(NewID,ParentId,s,iTypeFolder,NewID,IMAGEINDEX_FOLDER);
  end;
end;


procedure TMainFormActions.FillCommonCommandMenu(AppMainTreeId,AppPluginsId: Integer; Item:TdxBarSubItem);
var
 DataSet:TxDataSet;
begin
  DataSet:=TxDataSet.Create(nil);
  try
   DataSet.ProviderName:='spui_AppGetPluginUnusedCommonCmd';
   DataSet.SetParameter('AppPluginsId',AppPluginsId);
   DataSet.Source:='TMainFormActions.FillCommonCommandMenu';
   DataSet.Open;
   FillCommonCommandMenuFromDataSet(DataSet,Item, AppPluginsId, AppMainTreeId);
  finally
    DataSet.Free;
  end;
end;

procedure TMainFormActions.AddNewCommonCommandClick(Sender: TObject);
var
 Button:TdxAppCmdBarButton;
 ScopeIdentity:Integer;
begin
 Button:=Sender as TdxAppCmdBarButton;
 ScopeIdentity:= TDataBaseUtils.NewTreeItem(Button.Caption,Button.ParentId,Button.iType,Button.AppCmdId, Button.ImageIndex);
 InsertCommonAppCmd(Button.AppPluginsId,Button.AppCmdId, ScopeIdentity);
 Button.Free; //Delete button after click without closing menu.

 TMainFormTreeRefresher.DefaultInstance.CompleteRefresh;
end;


procedure TMainFormActions.FillCommonCommandMenuFromDataSet(DataSet: TDataSet;  Item: TdxBarSubItem; AppPluginsId, AppMainTreeId:Integer);
var
  x: Integer;
  NewItem: TdxAppCmdBarButton;
begin
 for x:=Item.ItemLinks.Count-1 downto 0 do
    Item.ItemLinks[x].Item.Free;

 if DataSet.RecordCount > 0 then
   while not DataSet.EOF do
   begin
     NewItem:=TdxAppCmdBarButton.Create(Item);
     NewItem.AppCmdId:=DataSet.FieldByName('AppCmdId').AsInteger;
     NewItem.AppPluginsId:=AppPluginsId;
     NewItem.iType:=DataSet.FieldByName('iType').AsInteger;
     NewItem.ParentId:=AppMainTreeId;

     NewItem.Caption:=DataSet.FieldByName('Caption').AsString;
     NewItem.ImageIndex:=DataSet.FieldByName('ImageIndex').AsInteger;
     NewItem.CloseSubMenuOnClick:=False;

     NewItem.OnClick:=AddNewCommonCommandClick;
     Item.ItemLinks.Add.Item:=NewItem;
     DataSet.Next;
    end
  else
  begin
    NewItem:=TdxAppCmdBarButton.Create(Item);
    NewItem.Caption:= S_NO_AVAIBLE_COMMANDS;
    NewItem.Enabled:=False;
    Item.ItemLinks.Add.Item:=NewItem;
  end;
end;



function TMainFormActions.InsertCommonAppCmd(AppPluginsId, AppCmdId, AppMainTreeId: Integer):Integer;
var
 DataSet:TxDataSet;
begin
 DataSet:=TxDataSet.Create(nil);
  try
   Result:=TDataBaseUtils.NewAppObjectId(sq_AppPluginsCommonCmd);
   DataSet.Source:='TMainFormActions.InsertCommonAppCmd';
   DataSet.ProviderName:='spui_AppInsertCommonPluginCommand';
   DataSet.SetParameter('AppPluginsCommonCmdId',Result);
   DataSet.SetParameter('AppPluginsId',AppPluginsId);
   DataSet.SetParameter('AppCmdId',AppCmdId);
   DataSet.SetParameter('OrderId',100);
   DataSet.SetParameter('AppMainTreeId',AppMainTreeId);
   DataSet.Open;
  finally
   DataSet.Free;
  end;
end;


initialization
  dxBarRegisterItem(TdxAppCmdBarButton, TdxBarButtonControl, True );

end.
