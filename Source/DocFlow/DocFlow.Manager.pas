unit DocFlow.Manager;

interface
 uses
  System.SysUtils, System.Variants, System.Classes, Dialogs,
  DocFlow.Manager.Helper,
  DocFlow.Schema.Form,
  CustomControl.MiceAction,
  CustomControl.MiceActionList,
  Dialog.Adaptive,
  DocFlow.NewDocument.SelectionDialog,
  Common.Images,
  Common.ResourceStrings,
  Plugin.Properties,
  Mice.Script,
  dxBar, Data.DB,
  DAC.XDataSet;


type
 TOnCreateDialogEvent = procedure(Dlg:TAdaptiveDialog) of object;

 TDocFlowManager = class
  private
    FScript:TMiceScripter;
    FActions:TMiceActionList;
    FHelper:TDocFlowManagerHelper;
    FPushButton:TdxBarLargeButton;
    FRollbackButton: TdxBarLargeButton;
    FDBName: string;
    FFlowButton: TdxBarLargeButton;
    FProperties : TPluginProperties;
    FRefresh:TMiceAction;
    FDataSet:TxDataSet;
    FDefaultPushButton:TdxBarButton;
    FDefaultRollBackButton:TdxBarButton;
    FOnCreateDialog: TOnCreateDialogEvent;
    procedure DoShowErrorLog(Sender:TObject);
    procedure DoShowWorkFlowSchema(Sender:TObject);
    procedure DoShowTransForm(Sender:TObject);
    procedure DoDefaultPush(Sender:TObject);
    procedure DoDefaultRollBack(Sender:TObject);
    procedure OnPushMethodClick(Sender:TObject);
    procedure OnRollbackMethodClick(Sender:TObject);
    procedure DoOnPushButtonOpen(Sender:TObject);
    procedure DoOnRollbackButtonOpen(Sender:TObject);
    procedure AddRecordExecuteDocFlow(Sender:TObject);
    procedure EditRecordExecuteDocFlow(Sender:TObject);
    procedure DeleteRecordExecuteDocFlow(Sender:TObject);
    procedure ShowDocumentSchema(dfTypesId, DfPathFoldersId: Integer);
    procedure ClearItems(ItemLinks:TdxBarItemLinks);
    procedure SetPushButton(const Value: TdxBarLargeButton);
    procedure SetRollbackButton(const Value: TdxBarLargeButton);
    procedure SetFlowButton(const Value: TdxBarLargeButton);
    procedure SetDBName(const Value: string);
    procedure PopulatePushMethods(DocumentsId, dfTypesId, DfPathFoldersId: Integer);
    procedure PopulateRollBackMethods(DocumentsId, dfTypesId, DfPathFoldersId: Integer);
    procedure DoRefresh;
    procedure OverrideActions;
    function NewDocument(dfTypesId, dfPathFoldersId, AppLayoutsId:Integer):Boolean;
    function EditDocument:Boolean;
    function CreateDialog:TAdaptiveDialog;
    function CreateMethodButton(Item: TdxBarLargeButton; DataSet:TDataSet; Event:TNotifyEvent; IsRollBack:Boolean):TdxBarButton;
  public
    constructor Create(AActionList:TMiceActionList; Properties:TPluginProperties; DataSet:TxDataSet;Script:TMiceScripter);
    destructor Destroy; override;
    procedure PopulateFlowButton;
    procedure CreateDocFlowMethods;
    procedure InitDocFlowDialog(Dlg:TAdaptiveDialog);
    procedure EnableDocFlow;
    property PushButton:TdxBarLargeButton read FPushButton write SetPushButton;
    property RollbackButton:TdxBarLargeButton read FRollbackButton write SetRollbackButton;
    property FlowButton:TdxBarLargeButton read FFlowButton write SetFlowButton;
    property DBName:string read FDBName write SetDBName;
    property OnCreateDialog : TOnCreateDialogEvent read FOnCreateDialog write FOnCreateDialog;
 end;

implementation

{ TDocFlowMethodBuilder }

procedure TDocFlowManager.AddRecordExecuteDocFlow(Sender: TObject);
var
 Dlg:TDocFlowNewDocDialog;
begin
  Dlg:=TDocFlowNewDocDialog.Create(nil);
  try
   Dlg.DfClassesId:=FHelper.DfClassesId;
   Dlg.DBName:=Self.DBName;
   if Dlg.Execute then
    NewDocument(Dlg.DfTypesId ,Dlg.DfPathFoldersId, Dlg.AppDialogsLayoutId);
  finally
   Dlg.Free;
  end;
end;


procedure TDocFlowManager.DeleteRecordExecuteDocFlow(Sender: TObject);
begin

end;


procedure TDocFlowManager.EditRecordExecuteDocFlow(Sender: TObject);
begin
  EditDocument;
end;

function TDocFlowManager.EditDocument: Boolean;
var
 Dlg:TAdaptiveDialog;
begin
 Dlg:=CreateDialog;
 try
  Dlg.DocFlow:=True;
  Dlg.SetParameter('AppDialogsId',FHelper.AppDialogsId);
  Dlg.SetParameter('dfClassesId',FDataSet.FieldByName('dfClassesId').AsInteger);
  Dlg.SetParameter('dfTypesId',FDataSet.FieldByName('dfTypesId').AsInteger);
  Dlg.SetParameter('dfPathFoldersId',FDataSet.FieldByName('dfPathFoldersId').AsInteger);
  Dlg.ID:=FDataSet.FieldByName(FProperties.KeyField).AsInteger;
  Result:=Dlg.Execute;
  if Result then
   DoRefresh;
 finally
  Dlg.Free;
 end;
end;


procedure TDocFlowManager.EnableDocFlow;
begin
 OverrideActions;
 DBName:=FProperties.DBName;
 FHelper.DfClassesId:=FProperties.DfClassesId;
 FHelper.GetClassProperties;
end;

procedure TDocFlowManager.InitDocFlowDialog(Dlg: TAdaptiveDialog);
begin

end;

function TDocFlowManager.NewDocument(dfTypesId, dfPathFoldersId, AppLayoutsId: Integer): Boolean;
var
 Dlg:TAdaptiveDialog;
begin
 Dlg:=CreateDialog;
 try
  Dlg.DocFlow:=True;
  Dlg.SetParameter('AppDialogsId',FHelper.AppDialogsId);
  Dlg.SetParameter('dfClassesId', FHelper.DfClassesId);
  Dlg.SetParameter('dfTypesId',dfTypesId);
  Dlg.SetParameter('dfPathFoldersId',dfPathFoldersId);
  Dlg.SetParameter('dfEventsId',0);
  Dlg.AppLayoutsID:=AppLayoutsId;
  Dlg.LogProviderName:=Self.FHelper.LogProviderName;
  Dlg.ID:=-1;
  Result:=Dlg.Execute;
  if Result then
   DoRefresh;
 finally
  Dlg.Free;
 end;
end;

procedure TDocFlowManager.OverrideActions;
var
 Action:TMiceAction;
begin
 Action:=FActions.ActionByName(ACTION_NAME_ADD_RECORD);
 Action.OnExecute:=AddRecordExecuteDocFlow;

 Action:=FActions.ActionByName(ACTION_NAME_EDIT_RECORD);
 Action.OnExecute:=EditRecordExecuteDocFlow;

 FRefresh:=FActions.ActionByName(ACTION_NAME_REFRESHDATA);
end;

procedure TDocFlowManager.ClearItems(ItemLinks: TdxBarItemLinks);
var
 x:Integer;
begin
 for x:=ItemLinks.Count-1 downto 0 do
  ItemLinks.Items[x].Item.Free;
 ItemLinks.Clear;
end;

constructor TDocFlowManager.Create(AActionList:TMiceActionList; Properties:TPluginProperties;DataSet:TxDataSet; Script:TMiceScripter);
begin
 FScript:=Script;
 FHelper:=TDocFlowManagerHelper.Create(FScript);
 FActions:=AActionList;
 FProperties:=Properties;
 FDataSet:=DataSet;
end;

function TDocFlowManager.CreateDialog: TAdaptiveDialog;
begin
 Result:=TAdaptiveDialog.Create(nil);
 Result.DBName:=Self.DBName;
 if Assigned(OnCreateDialog) then
  OnCreateDialog(Result);
end;

procedure TDocFlowManager.CreateDocFlowMethods;
var
 Action:TMiceAction;
begin
 Action:=FActions.CreateAction(ACTION_NAME_DF_PUSH_DOCUMENT);
 Action.ActivityCondition.AlwaysEnabled:=False;
 Action.ActivityCondition.EnabledWhenNoRecords:=False;
 Action.OnExecute:=OnPushMethodClick;
 Action.ActionType:=atExecutePluginMethod;


 Action:=FActions.CreateAction(ACTION_NAME_DF_ROLLBACK_DOCUMENT);
 Action.ActivityCondition.AlwaysEnabled:=False;
 Action.ActivityCondition.EnabledWhenNoRecords:=False;
 Action.OnExecute:=OnRollbackMethodClick;
 Action.ActionType:=atExecutePluginMethod;


 Action:=FActions.CreateAction(ACTION_NAME_DF_SHOW_SCHEMA);
 Action.ActivityCondition.AlwaysEnabled:=False;
 Action.ActivityCondition.EnabledWhenNoRecords:=False;
 Action.OnExecute:=DoShowWorkFlowSchema;
 Action.ActionType:=atExecutePluginMethod;
 Action.Caption:=S_DOCFLOW_SCHEMA;
 Action.Hint:=S_DOCFLOW_SCHEMA_HINT;
 Action.ImageIndex:=IMAGEINDEX_ACTION_DOCFLOW_SCHEMA;


 Action:=FActions.CreateAction(ACTION_NAME_DF_SHOW_TRANS);
 Action.ActivityCondition.AlwaysEnabled:=False;
 Action.ActivityCondition.EnabledWhenNoRecords:=False;
 Action.OnExecute:=DoShowTransForm;
 Action.ActionType:=atExecutePluginMethod;
 Action.Caption:=S_DOCFLOW_TRANS;
 Action.Hint:=S_DOCFLOW_TRANS_HINT;
 Action.ImageIndex:=IMAGEINDEX_ACTION_DOCFLOW_TRANS;


 Action:=FActions.CreateAction(ACTION_NAME_DF_SHOW_ERRORS);
 Action.ActivityCondition.AlwaysEnabled:=False;
 Action.ActivityCondition.EnabledWhenNoRecords:=False;
 Action.OnExecute:=DoShowErrorLog;
 Action.ActionType:=atExecutePluginMethod;
 Action.Caption:=S_DOCFLOW_ERRORLOG;
 Action.Hint:=S_DOCFLOW_ERRORLOG_HINT;
 Action.ImageIndex:=IMAGEINDEX_ACTION_DOCFLOW_ERRORLOG;
end;

function TDocFlowManager.CreateMethodButton(Item: TdxBarLargeButton; DataSet: TDataSet; Event:TNotifyEvent; IsRollBack:Boolean):TdxBarButton;
var
 Link: TdxBarItemLink;
resourcestring
 S_ROLLBACK_TO_PREFIX_FMT = 'Back to "%s"';
begin
   Result:=TdxBarButton.Create(Item);
   Result.Tag:=DataSet.FieldByName('dfMethodsId').AsInteger;
   if IsRollBack then
   Result.Caption:=Format(S_ROLLBACK_TO_PREFIX_FMT,[DataSet.FieldByName('dfPathFoldersCaption').AsString])
    else
   Result.Caption:=DataSet.FieldByName('Caption').AsString;
   Result.Hint:=DataSet.FieldByName('Info').AsString;
   Result.ImageIndex:=DataSet.FieldByName('ImageIndex').AsInteger;
   Result.PaintStyle:=psCaptionGlyph;
   Result.OnClick:=Event;

   Link:=Item.DropDownMenu.ItemLinks.Add;
   Link.Item := Result;
   Link.Item.Category:=0;
end;


destructor TDocFlowManager.Destroy;
begin
  FHelper.Free;
  inherited;
end;

procedure TDocFlowManager.DoDefaultPush(Sender: TObject);
resourcestring
 E_DF_DEFAULT_METHOD_NOT_FOUND='Default push method not found for this state';
begin
 DoOnPushButtonOpen(PushButton);
 if Assigned(FDefaultPushButton) then
 FDefaultPushButton.OnClick(FDefaultPushButton)
  else
 raise Exception.Create(E_DF_DEFAULT_METHOD_NOT_FOUND);
end;

procedure TDocFlowManager.DoDefaultRollBack(Sender: TObject);
resourcestring
 E_DF_DEFAULT_ROLLBACK_METHOD_NOT_FOUND='Default rollback method not found for this state';
begin
 DoOnRollbackButtonOpen(RollbackButton);
 if Assigned(FDefaultRollBackButton) then
  FDefaultRollBackButton.OnClick(FDefaultRollBackButton)
   else
  raise Exception.Create(E_DF_DEFAULT_ROLLBACK_METHOD_NOT_FOUND);
end;

procedure TDocFlowManager.DoOnPushButtonOpen(Sender: TObject);
begin
 FHelper.CheckValidDocFlowDataSet(FDataSet, False);
 PopulatePushMethods(FDataSet.KeyFieldValue ,FDataSet.FieldByName('dfTypesId').AsInteger , FDataSet.FieldByName('dfPathFoldersId').AsInteger);
end;

procedure TDocFlowManager.OnPushMethodClick(Sender: TObject);
var
 dfEventsId:Integer;
 dfMethodsId:Integer;
 F:TField;
 DocumentsId:Integer;
 dfPathFoldersIdSource:Integer;
 Params:Variant;
begin
 dfMethodsId:=(Sender as TdxBarButton).Tag;
 dfPathFoldersIdSource:=FDataSet.FieldByName('dfPathFoldersId').AsInteger;
 DocumentsId:=FDataSet.KeyFieldValue;

 F:=FDataSet.FindField('dfEvents');
 if Assigned(F) then
  dfEventsId:=F.AsInteger
   else
  dfEventsId:=-1;

  Params:=VarArrayOf([True, Integer(FDataSet), DocumentsId,dfPathFoldersIdSource,dfMethodsId,dfEventsId]);
  FScript.CallFunction1('BeforePushDocument',Params);
  if (VarIsNull(Params)=False) and (Params[0]=True) then
   begin
    FHelper.PushDocument(DocumentsId,dfPathFoldersIdSource,dfMethodsId,dfEventsId);
    DoRefresh;
    dfPathFoldersIdSource:=FDataSet.FieldByName('dfPathFoldersId').AsInteger;
    Params:=VarArrayOf([Integer(FDataSet), DocumentsId,dfPathFoldersIdSource]);
    FScript.CallFunction1('AfterPushDocument',Params);
   end;
end;

procedure TDocFlowManager.DoOnRollbackButtonOpen(Sender: TObject);
begin
 FHelper.CheckValidDocFlowDataSet(FDataSet, False);
 PopulateRollBackMethods(FDataSet.KeyFieldValue ,FDataSet.FieldByName('dfTypesId').AsInteger , FDataSet.FieldByName('dfPathFoldersId').AsInteger);
end;

procedure TDocFlowManager.OnRollbackMethodClick(Sender: TObject);
var
 dfEventsId:Integer;
 dfMethodsId:Integer;
 F:TField;
 Params:Variant;
 DocumentsId:Integer;
 dfPathFoldersIdSource:Integer;
begin
 dfMethodsId:=(Sender as TdxBarButton).Tag;
 DocumentsId:=FDataSet.KeyFieldValue;
 dfPathFoldersIdSource:=FDataSet.FieldByName('dfPathFoldersId').AsInteger;

 F:=FDataSet.FindField('dfEvents');
 if Assigned(F) then
  dfEventsId:=F.AsInteger
   else
  dfEventsId:=-1;

  Params:=VarArrayOf([True, Integer(FDataSet), DocumentsId,dfPathFoldersIdSource,dfMethodsId,dfEventsId]);
  FScript.CallFunction1('BeforeRollbackDocument',Params);
  if (VarIsNull(Params)=False) and (Params[0]=True) then
   begin
    FHelper.RollBackDocument(DocumentsId,dfPathFoldersIdSource,dfMethodsId,dfEventsId);
    DoRefresh;
    dfPathFoldersIdSource:=FDataSet.FieldByName('dfPathFoldersId').AsInteger;
    Params:=VarArrayOf([Integer(FDataSet), DocumentsId,dfPathFoldersIdSource]);
    FScript.CallFunction1('AfterRollbackDocument',Params);
   end;
end;

procedure TDocFlowManager.DoRefresh;
begin
 FDefaultPushButton:=nil;
 FDefaultRollBackButton:=nil;
 FRefresh.Execute;
end;

procedure TDocFlowManager.DoShowErrorLog(Sender: TObject);
begin
 raise Exception.Create('Error log is not implemented');
end;

procedure TDocFlowManager.DoShowTransForm(Sender: TObject);
begin
 raise Exception.Create('Transaction history not implemented');
end;

procedure TDocFlowManager.DoShowWorkFlowSchema(Sender: TObject);
begin
 FHelper.CheckValidDocFlowDataSet(FDataSet, False);
 ShowDocumentSchema(FDataSet.FieldByName('dfTypesId').AsInteger , FDataSet.FieldByName('dfPathFoldersId').AsInteger);
end;

procedure TDocFlowManager.PopulateFlowButton;
var
 Button:TdxBarButton;
 Link: TdxBarItemLink;
begin
   Button:=TdxBarButton.Create(FlowButton);
   Button.PaintStyle:=psCaptionGlyph;
   Button.Action:=FActions.ActionByName(ACTION_NAME_DF_SHOW_SCHEMA);
   Link:=FlowButton.DropDownMenu.ItemLinks.Add;
   Link.Item := Button;
   Link.Item.Category:=0;

   Button:=TdxBarButton.Create(FlowButton);
   Button.PaintStyle:=psCaptionGlyph;
   Button.Action:=FActions.ActionByName(ACTION_NAME_DF_SHOW_TRANS);
   Link:=FlowButton.DropDownMenu.ItemLinks.Add;
   Link.Item := Button;
   Link.Item.Category:=0;

   Button:=TdxBarButton.Create(FlowButton);
   Button.PaintStyle:=psCaptionGlyph;
   Button.OnClick:=DoShowWorkFlowSchema;
   Button.Action:=FActions.ActionByName(ACTION_NAME_DF_SHOW_ERRORS);
   Link:=FlowButton.DropDownMenu.ItemLinks.Add;
   Link.Item := Button;
   Link.Item.Category:=0;
end;

procedure TDocFlowManager.PopulatePushMethods(DocumentsId, dfTypesId,  DfPathFoldersId: Integer);
var
 Tmp:TxDataSet;
 B: TdxBarButton;
begin
 Tmp:=TxDataSet.Create(nil);
 try
  Tmp.ProviderName:='spui_dfMethodsListForPush';
  Tmp.Source:='TDocFlowMethodBuilder.PopulatePushMethods';
  Tmp.DBName:=DBName;
  Tmp.SetParameter('DocumentsId',DocumentsId);
  Tmp.SetParameter('dfTypesId',dfTypesId);
  Tmp.SetParameter('DfPathFoldersId',DfPathFoldersId);
  Tmp.SetParameter('AllowDesktop',1);
  Tmp.Open;
  ClearItems(FPushButton.DropDownMenu.ItemLinks);
  FDefaultPushButton:=nil;
  while not Tmp.Eof do
   begin
    B:=CreateMethodButton(FPushButton, Tmp, OnPushMethodClick, False);
    if (Tmp.RecordCount=1) or (Tmp.FieldByName('IsDefault').AsBoolean) then
     FDefaultPushButton:=B;
    Tmp.Next;
   end;
 finally
  Tmp.Free;
 end;
end;


procedure TDocFlowManager.PopulateRollBackMethods(DocumentsId, dfTypesId,  DfPathFoldersId: Integer);
var
 Tmp:TxDataSet;
 B: TdxBarButton;
begin
 Tmp:=TxDataSet.Create(nil);
 try
  Tmp.ProviderName:='spui_dfMethodsListForRollback';
  Tmp.Source:='TDocFlowMethodBuilder.PopulateRollBackMethods';
  Tmp.DBName:=DBName;
  Tmp.SetParameter('DocumentsId',DocumentsId);
  Tmp.SetParameter('dfTypesId',dfTypesId);
  Tmp.SetParameter('DfPathFoldersId',DfPathFoldersId);
  Tmp.SetParameter('AllowDesktop',1);
  Tmp.Open;
  ClearItems(FRollbackButton.DropDownMenu.ItemLinks);
  FDefaultRollBackButton:=nil;
  while not Tmp.Eof do
   begin
    B:=CreateMethodButton(FRollbackButton, Tmp, OnRollbackMethodClick, True);
    if (Tmp.RecordCount=1) or (Tmp.FieldByName('IsDefault').AsBoolean) then
     FDefaultRollBackButton:=B;
    Tmp.Next;
   end;

 finally
  Tmp.Free;
 end;
end;

procedure TDocFlowManager.SetDBName(const Value: string);
begin
  FDBName := Value;
  FHelper.DBName:=Value;
end;

procedure TDocFlowManager.SetFlowButton(const Value: TdxBarLargeButton);
begin
  FFlowButton := Value;
  FFlowButton.OnClick:=DoShowWorkFlowSchema;
end;


procedure TDocFlowManager.SetPushButton(const Value: TdxBarLargeButton);
begin
  FPushButton := Value;
  FPushButton.DropDownMenu.OnPopup:=DoOnPushButtonOpen;
  FPushButton.OnClick:=DoDefaultPush;
end;

procedure TDocFlowManager.SetRollbackButton(const Value: TdxBarLargeButton);
begin
  FRollbackButton := Value;
  FRollbackButton.DropDownMenu.OnPopup:=DoOnRollbackButtonOpen;
  FRollbackButton.OnClick:=DoDefaultRollBack;
end;

procedure TDocFlowManager.ShowDocumentSchema(dfTypesId,  DfPathFoldersId: Integer);
var
 Tmp:TxDataSet;
begin
 Tmp:=TxDataSet.Create(nil);
 try
  Tmp.ProviderName:='spui_dfGetDocumentSchema';
  Tmp.Source:='TDocFlowManager.ShowDocumentSchema';
  Tmp.DBName:=DBName;
  Tmp.SetParameter('dfTypesId',dfTypesId);
  Tmp.SetParameter('dfPathFoldersId',DfPathFoldersId);
  Tmp.SetParameter('DocumentsId', FDataSet.FieldByName(FProperties.KeyField).AsInteger);
  Tmp.Open;
  TDocFlowSchemaForm.ShowSchema (Tmp, DfPathFoldersId);
 finally
  Tmp.Free;
 end;
end;

end.
