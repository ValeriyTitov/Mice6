unit ManagerEditor.AppTemplate;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, ManagerEditor.Common, cxGraphics,
  cxLookAndFeels, cxLookAndFeelPainters, Vcl.Menus, cxControls, Data.DB,
  cxClasses, dxLayoutContainer, dxLayoutControl, Vcl.StdCtrls, cxButtons,
  Vcl.ExtCtrls,dxorgchr, dxdborgc, dxorgced, cxStyles, cxEdit,dxBar,
  cxDataControllerConditionalFormattingRulesManagerDialog, cxInplaceContainer,
  cxVGrid, cxDBVGrid, dxLayoutcxEditAdapters, cxContainer, cxMemo, cxDBEdit,
  cxTextEdit,cxMaskEdit, cxDropDownEdit, cxImageComboBox,cxCheckBox, dxLayoutControlAdapters,
  System.Generics.Collections, System.Generics.Defaults,
  Manager.WindowManager,
  DAC.DatabaseUtils,
  DAC.XDataSet,
  DAC.XParams,
  CustomControl.MiceAction,
  CustomControl.MiceActionList,
  Common.Images,
  Common.ResourceStrings,
  StaticDialog.MiceInputBox,
  AppTemplate.FileImport,
  AppTemplate.FileImport.Xbrl,
  AppTemplate.FileImport.Xsd,
  AppTemplate.FileImport.Xml,
  AppTemplate.FileImport.Json,
  AppTemplate.FileImport.DBObject,
  Common.Registry,
  ManagerEditor.AppTemplate.DataSourceListDlg,
  ManagerEditor.AppTemplate.ParamsSelectionDlg,
  StaticDialog.AppObjectSelector,
  AppTemplate.Builder,
  cxBarEditItem, dxmdaset, Vcl.Buttons, dxScrollbarAnnotations;

type
  TManagerEditorAppTemplate = class(TCommonManagerDialog)
    groupHeader: TdxLayoutGroup;
    groupSchema: TdxLayoutGroup;
    gridProps: TcxDBVerticalGrid;
    item_Properties: TdxLayoutItem;
    edName: TcxDBTextEdit;
    item_edName: TdxLayoutItem;
    memoDescription: TcxDBMemo;
    item_memoDescription: TdxLayoutItem;
    ddTemplateType: TcxDBImageComboBox;
    item_ddTemplateType: TdxLayoutItem;
    dxLayoutAutoCreatedGroup1: TdxLayoutAutoCreatedGroup;
    cbActive: TcxDBCheckBox;
    item_cbActive: TdxLayoutItem;
    cbFormatAfterCreate: TcxDBCheckBox;
    item_FormatAfterCreate: TdxLayoutItem;
    groupSettings: TdxLayoutGroup;
    edDefaultDateTimeFormat: TcxDBTextEdit;
    item_edDefaultDateTimeFormat: TdxLayoutItem;
    groupCommon: TdxLayoutGroup;
    groupSchemaEditors: TdxLayoutGroup;
    Schema: TdxDbOrgChart;
    item_Schema: TdxLayoutItem;
    colAppTemplatesDataId: TcxDBEditorRow;
    colParentId: TcxDBEditorRow;
    colTagName: TcxDBEditorRow;
    colDescription: TcxDBEditorRow;
    colTagType: TcxDBEditorRow;
    colValue: TcxDBEditorRow;
    colFilter: TcxDBEditorRow;
    colSign: TcxDBEditorRow;
    colCompareValue: TcxDBEditorRow;
    colGroupCreateConditions: TcxCategoryRow;
    colGroupOther: TcxCategoryRow;
    colDefaultValue: TcxDBEditorRow;
    colFormat: TcxDBEditorRow;
    colActive: TcxDBEditorRow;
    colGroupValueProperties: TcxCategoryRow;
    colDataSetName: TcxDBEditorRow;
    colValueSource: TcxDBEditorRow;
    dxBarManager: TdxBarManager;
    topMenu: TdxBar;
    bnNewRootItem: TdxBarButton;
    bnDelete: TdxBarButton;
    bnRefresh: TdxBarButton;
    bnActivity: TdxBarButton;
    bnNewItemGroup: TdxBarSubItem;
    bnNewItem: TdxBarButton;
    bnSave: TdxBarButton;
    bnProps: TdxBarSubItem;
    bnImpotGroup: TdxBarSubItem;
    bnDataSetList: TdxBarButton;
    bnImportXml: TdxBarButton;
    bnImportXbrl: TdxBarButton;
    bnImportDatabaseObject: TdxBarButton;
    bnImportJson: TdxBarButton;
    cbImportToRoot: TcxBarEditItem;
    bnNodeList: TdxBarSubItem;
    bnCollapseAll: TdxBarButton;
    bnExpandAll: TdxBarButton;
    dxBarButton1: TdxBarButton;
    bnMore: TdxBarSubItem;
    bnGoto: TdxBarButton;
    bnFind: TdxBarButton;
    bnInsertDataSet: TdxBarButton;
    bnRun: TdxBarButton;
    Splitter: TdxLayoutSplitterItem;
    DataSetParams: TdxMemData;
    DataSetParamsParamName: TStringField;
    DataSetParamsParamValue: TStringField;
    dsParams: TDataSource;
    bnParams: TdxBarButton;
    bnRise: TdxBarButton;
    bnLower: TdxBarButton;
    bnApplyToChildren: TdxBarButton;
    bnImportTemplate: TdxBarButton;
    colValueType: TcxDBEditorRow;
    procedure SchemaCreateNode(Sender: TObject; Node: TdxOcNode);
    procedure bnImportXmlClick(Sender: TObject);
    procedure bnImportJsonClick(Sender: TObject);
    procedure bnImportXbrlClick(Sender: TObject);
    procedure bnImportDatabaseObjectClick(Sender: TObject);
    procedure bnDataSetListClick(Sender: TObject);
    procedure cbImportToRootChange(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure bnCollapseAllClick(Sender: TObject);
    procedure bnExpandAllClick(Sender: TObject);
    procedure gridPropsItemChanged(Sender: TObject; AOldRow: TcxCustomRow;
      AOldCellIndex: Integer);
    procedure colValueSourceEditPropertiesChange(Sender: TObject);
    procedure colDataSetNameEditPropertiesChange(Sender: TObject);
    procedure colSignEditPropertiesChange(Sender: TObject);
    procedure bnParamsClick(Sender: TObject);
    procedure SchemaDeletion(Sender: TObject; Node: TdxOcNode);
    procedure bnApplyToChildrenClick(Sender: TObject);
    procedure SchemaKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure bnImportTemplateClick(Sender: TObject);
    procedure cbActiveClick(Sender: TObject);
  private
    FSchemaDS:TDataSource;
    DataSetListDS:TDataSource;
    FDataSet:TxDataSet;
    FActions:TMiceActionList;
    FImportID:Variant;
    FPopulated:Boolean;
    FRunParamsPopulated:Boolean;
    FRunParams:TxParams;
    FNewKeys:TDictionary<Int64,Int64>;
    procedure CreateNewKeys(DataSet:TDataSet);
    procedure OnCopyDataSet(Source, Dest:TDataSet);
    procedure DisableControls;
    procedure EnableControls;
    procedure ImportAppTemplates(ID:Integer);
    function FindFirstDataSetName:string;
    function ExecuteParamsDlg:Boolean;
    procedure InsertDataSetNode;
    procedure FindItem(const FieldName:string);
    procedure NewItemActionExecute(Sender:TObject);
    procedure GotoToIDActionExecute(Sender:TObject);
    procedure FindItemActionExecute(Sender:TObject);
    procedure NewRootItemActionExecute(Sender:TObject);
    procedure RunActionExecute(Sender:TObject);
    procedure DeleteItemActionExecute(Sender:TObject);
    procedure InsertDataSetNodeActionExecute(Sender:TObject);
    procedure SaveActionExecute(Sender:TObject);
    procedure RefreshActionExecute(Sender:TObject);
    procedure ChangeActivityActionExecute(Sender:TObject);
    procedure SetTemplateLayout;
    procedure SetCommonLayout;
    procedure SetNodeProperties(Node:TdxOcNode);
    procedure UpdateNodeAfterPost(DataSet:TDataSet);
    procedure CreateActions;
    procedure PopulateDataSetCombo;
    procedure TryPopulate(Sender:TObject);
    procedure PopulateRunParams;
    procedure Run;
    procedure InternalRun;
    function InvalidData(DataSet:TDataSet):Boolean;
    function KeyPressed:Boolean;
    procedure InternalApplyToAllChildren(const FieldName:string);
    procedure ApplyToAllChildred(const FieldName:string);
    procedure SetAllRows(AppTemplatesDataId:Integer; const FieldName:string; const Value:Variant);
    procedure UpdateActivity;
  protected
    procedure EnterInsertingState; override;
    procedure EnterEditingState; override;
  public
    procedure SaveState; override;
    procedure LoadState(LoadPosition, LoadSize:Boolean);override;
    property SchemaDataSet:TxDataSet read FDataSet;

    procedure Initialize; override;
    constructor Create(AOwner:TComponent);override;
    destructor Destroy; override;
    class function ExecuteRenameDialog(ID, AppMainTreeId:Integer; var AName:string):Boolean;
  end;


implementation


resourcestring
 S_NEW_TEMPLATE_NODE = 'NewNode';

{$R *.dfm}

{ TManagerEditorExportTemplate }

procedure TManagerEditorAppTemplate.ApplyToAllChildred(const FieldName: string);
begin
 if KeyPressed then
  begin
  try
   if (DataSet.State in [dsEdit]) then
    FDataSet.Post;
  except

  end;
   InternalApplyToAllChildren(FieldName);
  end;
end;

procedure TManagerEditorAppTemplate.bnApplyToChildrenClick(Sender: TObject);
resourcestring
 S_APPLY_TO_CHILD_CONFIRMATION_FMT = 'Apply %s to all node childs ?';
begin
if Assigned(gridProps.FocusedRow) and (MessageBox(Handle,PChar(Format(S_APPLY_TO_CHILD_CONFIRMATION_FMT,[(GridProps.FocusedRow as TcxDBEditorRow).Properties.Caption])), PChar(S_COMMON_CONFIRMATION), MB_YESNO+MB_ICONQUESTION)=ID_YES)   then
  InternalApplyToAllChildren((GridProps.FocusedRow as TcxDBEditorRow).Properties.DataBinding.FieldName);
end;

procedure TManagerEditorAppTemplate.bnCollapseAllClick(Sender: TObject);
begin
 Schema.FullCollapse;
end;

procedure TManagerEditorAppTemplate.bnDataSetListClick(Sender: TObject);
begin
if TDataSourceListDlg.ExecuteDialog(DataSetListDS) then
 PopulateDataSetCombo;
end;

procedure TManagerEditorAppTemplate.bnExpandAllClick(Sender: TObject);
begin
 Schema.FullExpand;
end;

procedure TManagerEditorAppTemplate.bnImportDatabaseObjectClick(Sender: TObject);
var
 Importer:TAbstractTemplateImport;
begin
Importer:=TDBObjectTemplateImport.Create(FDataSet);
 try
  DisableControls;
  Importer.Exec(FImportID);
 finally
  Importer.Free;
  EnableControls;
 end;
end;

procedure TManagerEditorAppTemplate.bnImportJsonClick(Sender: TObject);
var
 Importer:TAbstractTemplateImport;
begin
Importer:=TJsonTemplateImport.Create(FDataSet);
 try
 Importer.OpenDialog.Filter:=S_OPEN_FILE_FILTER_JSON;
  DisableControls;
  Importer.Exec(FImportID);
 finally
  Importer.Free;
  EnableControls;
 end;
end;

procedure TManagerEditorAppTemplate.bnImportXbrlClick(Sender: TObject);
var
 Importer:TAbstractTemplateImport;
begin
 Importer:=TXbrlTemplateImport.Create(FDataSet);
// Importer:=TJsonTemplateImport.Create(FDataSet);
 try
  DisableControls;
  Importer.Exec(FImportID);
 finally
  Importer.Free;
  EnableControls;
 end;
end;


procedure TManagerEditorAppTemplate.bnImportXmlClick(Sender: TObject);
var
 Importer:TAbstractTemplateImport;
begin
 Importer:=TXmlTemplateImport.Create(FDataSet);
 try
  DisableControls;
  Importer.OpenDialog.Filter:=S_OPEN_FILE_FILTER_XML_COMMON;
  Importer.Exec(FImportID);
 finally
  Importer.Free;
  EnableControls;
 end;
end;

procedure TManagerEditorAppTemplate.cbActiveClick(Sender: TObject);
begin
  inherited;
  UpdateActivity;
end;

procedure TManagerEditorAppTemplate.cbImportToRootChange(Sender: TObject);
begin
// This call back is actually set in constructor
 if cbImportToRoot.CurEditValue=(cbImportToRoot.Properties as TcxCheckBoxProperties).ValueChecked then
  begin
   cbImportToRoot.EditValue:=True;
   FImportID:=NULL
  end
   else
   begin
    cbImportToRoot.EditValue:=False;
    FImportID:=FDataSet.FieldByName('AppTemplatesDataId').Value
   end;
end;

procedure TManagerEditorAppTemplate.ChangeActivityActionExecute(  Sender: TObject);
begin
 FDataSet.Edit;
 FDataSet.FieldByName('Active').AsBoolean:=not FDataSet.FieldByName('Active').AsBoolean;
 FDataSet.Post;
 FDataSet.Edit;
end;


procedure TManagerEditorAppTemplate.colDataSetNameEditPropertiesChange(Sender: TObject);
begin
 ApplyToAllChildred('DatasetName');
end;

procedure TManagerEditorAppTemplate.colSignEditPropertiesChange( Sender: TObject);
begin
 ApplyToAllChildred('CreateCondition');
end;

procedure TManagerEditorAppTemplate.colValueSourceEditPropertiesChange(Sender: TObject);
begin
 ApplyToAllChildred('ValueSource');
end;

constructor TManagerEditorAppTemplate.Create(AOwner: TComponent);
begin
  inherited;
  TableName:='AppTemplates';
  KeyField:='AppTemplatesId';
  AppMainTreeDescriptionField:='Name';
  ImageIndex:= IMAGEINDEX_ITYPE_APP_TEMPLATE;
  iType:=iTypeAppTemplate;
  FPopulated:=False;
  FRunParams:=TxParams.Create;
  FRunParamsPopulated:=False;

  FSchemaDS:=DetailDataSets.CreateDataSource('AppTemplatesData','','','TemplateEditor.Schema','','');
  DataSetListDS:=DetailDataSets.CreateDataSource('AppTemplatesDataSets','','','TemplateEditor.DataSets','','');
  Schema.DataSource:=FSchemaDS;
  gridProps.DataController.DataSource:=FSchemaDS;
  FDataSet:=FSchemaDs.DataSet as TxDataSet;
  FDataSet.AfterPost:=UpdateNodeAfterPost;
  FActions:=TMiceActionList.Create;
  FActions.DataSource:=FSchemaDs;
  (cbImportToRoot.Properties as TcxCheckBoxProperties).OnChange:=Self.cbImportToRootChange;
  cbImportToRoot.EditValue:=(cbImportToRoot.Properties as TcxCheckBoxProperties).ValueChecked;

//  (colDataSetName.Properties.EditProperties as TcxComboBoxProperties).OnInitPopup:=TryPopulate;
  CreateActions;
  FNewKeys:=TDictionary<Int64,Int64>.Create;
  SchemaDataSet.OnCopyDataSet:=Self.OnCopyDataSet;
end;


procedure TManagerEditorAppTemplate.CreateActions;
resourcestring
 S_GOTO_TO_ID_COMMAND = 'Goto AppTemplatesDataId...';
 S_FIND_TAG_COMMAND = 'Find tag...';
var
 FAction:TMiceAction;
begin
FAction:=FActions.CreateDeleteAction('AppTemplatesDataId',DeleteItemActionExecute);
//FAction.HotKey:='DEL';
bnDelete.Action:=FAction;

FAction:=FActions.CreateRefreshDataAction(RefreshActionExecute);
FAction.HotKey:='F5';
bnRefresh.Action:= FAction;

FAction:=FActions.CreateAction('Run',bnRun.Caption, bnRun.Hint, bnRun.ImageIndex,True, RunActionExecute, '');
FAction.HotKey:='F9';
bnRun.Action:= FAction;


FAction:=FActions.CreateSaveDataAction(SaveActionExecute);
FAction.HotKey:='CTRL+S';
bnSave.Action:=FAction;

FAction:=FActions.CreateAction('NewItem',bnNewItem.Caption, bnNewItem.Hint, bnNewItem.ImageIndex,False, NewItemActionExecute, 'AppTemplatesDataId is not null');
FAction.HotKey:='INS';
bnNewItem.Action:=FAction;

bnNewRootItem.Action:=FActions.CreateAction('NewRootItem',bnNewRootItem.Caption, bnNewRootItem.Hint, bnNewRootItem.ImageIndex,True,NewRootItemActionExecute);

bnActivity.Action:=FActions.CreateChangeActivityAction('AppTemplatesDataId',ChangeActivityActionExecute);


FAction:=FActions.CreateAction('goto',S_GOTO_TO_ID_COMMAND,'',341,True,Self.GotoToIDActionExecute);
FAction.HotKey:='CTRL+G';
bnGoto.Action:=FAction;

FAction:=FActions.CreateAction('Find',S_FIND_TAG_COMMAND,'',237,True,Self.FindItemActionExecute);
FAction.HotKey:='CTRL+F';
bnFind.Action:=FAction;


FAction:=FActions.CreateAction('InsertDataSet',bnInsertDataSet.Caption, bnInsertDataSet.Hint, bnInsertDataSet.ImageIndex,False, InsertDataSetNodeActionExecute , 'AppTemplatesDataId is not null');
//FAction.HotKey:='INS';
bnInsertDataSet.Action:=FAction;

end;

procedure TManagerEditorAppTemplate.CreateNewKeys(DataSet: TDataSet);
var
 NewId:Int64;
 OldId:Int64;
 F:TField;
begin
 DataSet.DisableControls;
 DataSet.First;
 F:=DataSet.FieldByName('AppTemplatesDataId');
 while not DataSet.Eof do
  begin
   NewId:=TAbstractTemplateImport.NewID;
   OldId:=F.AsInteger;
   FNewKeys.Add(OldId, NewId);
   DataSet.Next;
  end;
end;

procedure TManagerEditorAppTemplate.DeleteItemActionExecute(Sender: TObject);
begin
 DisableControls;
  try
   Schema.Delete(Schema.Selected);
  finally
    EnableControls;
  end;
end;

destructor TManagerEditorAppTemplate.Destroy;
begin
  FActions.Free;
  FRunParams.Free;
  FNewKeys.Free;
  inherited;
end;

procedure TManagerEditorAppTemplate.DisableControls;
begin
  Schema.BeginUpdate;
  gridProps.BeginUpdate;
  FDataSet.DisableControls;
  FDataSet.AfterPost:=nil;
end;

procedure TManagerEditorAppTemplate.bnImportTemplateClick(Sender: TObject);
var
 x:Integer;
 s:String;
begin
 if TAppObjectSelectionDialog.ExecuteDialog(iTypeAppTemplate,x,s) then
 try
  DisableControls;
  ImportAppTemplates(x)
 finally
   EnableControls;
 end;
end;

procedure TManagerEditorAppTemplate.bnParamsClick(Sender: TObject);
begin
  ExecuteParamsDlg;
end;

procedure TManagerEditorAppTemplate.EnableControls;
begin
  Schema.EndUpdate;
  gridProps.EndUpdate;
  FDataSet.EnableControls;
  FDataSet.AfterPost:=UpdateNodeAfterPost;
end;

procedure TManagerEditorAppTemplate.EnterEditingState;
begin
  inherited;
  FDataSet.Open;
  UpdateActivity;
end;

procedure TManagerEditorAppTemplate.EnterInsertingState;
resourcestring
 S_NEW_APPTEMPLATE_FMT = 'New template %d';
var
 NewId:Integer;
begin
  inherited;
  NewId:=TDataBaseUtils.NewAppObjectId(sq_AppTemplates);
  DataSet.FieldByName('AppTemplatesId').AsInteger:=NewId;
  DataSet.FieldByName('Name').AsString:=Format(S_NEW_APPTEMPLATE_FMT,[NewId]);
  DataSet.FieldByName('Active').AsBoolean:=True;
  DataSet.FieldByName('TemplateType').AsInteger:=0;
end;

function TManagerEditorAppTemplate.ExecuteParamsDlg: Boolean;
begin
PopulateRunParams;

Result:= TParamSourceDlg.ExecuteDialog(Self.dsParams);
if Result then
   begin
    FRunParams.Clear;
    FRunParams.LoadFromDataSetList(DataSetParams, 'Name','Value');
   end;
end;

class function TManagerEditorAppTemplate.ExecuteRenameDialog(ID, AppMainTreeId: Integer; var AName: string): Boolean;
var
 Dlg: TManagerEditorAppTemplate;
begin
 Dlg:=TManagerEditorAppTemplate.Create(nil);
 try
  Dlg.ID:=ID;
  Dlg.AppMainTreeId:=AppMainTreeId;
  Dlg.SetParameter('Editing',True);
  Dlg.bnOK.OnClick:=nil;
  Dlg.bnOK.ModalResult:=mrOK;
  Dlg.bnCancel.ModalResult:=mrCancel;
  Result:=Dlg.Execute;
  if Result then
   begin
    Dlg.SaveChanges;
    AName:=Dlg.DataSet.FieldByName('Name').AsString;
   end;
 finally
  Dlg.Free;
 end;

end;



function TManagerEditorAppTemplate.FindFirstDataSetName: string;
var
 Items:TStrings;
begin
 TryPopulate(nil);
 Items:=(colDataSetName.Properties.EditProperties as TcxComboBoxProperties).Items;
 if Items.Count<=0 then
  Result:=''
   else
  Result:=Items[0];
end;

procedure TManagerEditorAppTemplate.FindItem(const FieldName: string);
var
 s:string;
begin
 s:='';
 if TMiceInputBox.Execute(237,s) then
  begin
   if FDataSet.Locate(FieldName,s)=False then
    ShowMessage(Format(E_CANNOT_FIND_ITEM_FMT, [FieldName+'='+s]));
  end;
end;

procedure TManagerEditorAppTemplate.FindItemActionExecute(Sender: TObject);
begin
 FindItem('TagName');
end;

procedure TManagerEditorAppTemplate.FormCloseQuery(Sender: TObject;  var CanClose: Boolean);
begin
 if (pnBottomButtons.Visible=False) then
  begin
   if (DetailDataSets.Modified) or (DataSet.Modified) then
    case MessageBox(Handle, PChar(S_COMMON_SAVECHANGES_BEFORE_EXIT), PChar(S_COMMON_INFORMATION),MB_YESNOCANCEL+MB_ICONQUESTION) of
      ID_YES: SaveActionExecute(nil);
      ID_NO : CanClose:=True;
      ID_CANCEL : CanClose:=False;
    end;
   end;
end;

procedure TManagerEditorAppTemplate.GotoToIDActionExecute(Sender: TObject);
begin
 FindItem('AppTemplatesDataId');
end;

procedure TManagerEditorAppTemplate.gridPropsItemChanged(Sender: TObject; AOldRow: TcxCustomRow; AOldCellIndex: Integer);
begin
  inherited;
  if gridProps.FocusedRow=colDataSetName then
   TryPopulate(nil);

if AOldRow = colDefaultValue then
 ApplyToAllChildred('DefaultValue') else
if AOldRow = colFormat then
 ApplyToAllChildred('Format');
if AOldRow = colCompareValue then
 ApplyToAllChildred('CreateConditionValue') else
if AOldRow = colDataSetName then
 ApplyToAllChildred('DataSetName') else
if AOldRow = colSign then
 ApplyToAllChildred('CreateCondition') else
if AOldRow = colValueSource then
 ApplyToAllChildred('ValueSource');

end;

procedure TManagerEditorAppTemplate.ImportAppTemplates(ID: Integer);
var
 Dlg:TManagerEditorAppTemplate;
begin
 Dlg:=TManagerEditorAppTemplate.Create(nil);
  try
   FNewKeys.Clear;
   LazyInitAll;
   SchemaDataSet.Open;
   DataSetParams.Open;
   DataSetListDS.DataSet.Open;

   Dlg.ID:=ID;
   Dlg.Initialize;
   Dlg.SchemaDataSet.Open;
   Dlg.DataSetParams.Open;
   Dlg.DataSetListDS.DataSet.Open;
   CreateNewKeys(Dlg.SchemaDataSet);
   DetailDataSets.CopyFrom(Dlg.DetailDataSets);
//      CopyFrom(Dlg, True);
  finally
   Dlg.Free;
  end;
end;

procedure TManagerEditorAppTemplate.Initialize;
begin
  inherited;
  if Assigned(Params.FindParam('Editing')) or (ID<0) then
   SetCommonLayout
    else
   SetTemplateLayout;
end;

procedure TManagerEditorAppTemplate.InsertDataSetNode;
var
 CurrentID:Variant;
 CurrentParentId:Variant;
 NewID:Integer;
 Items:TList<Variant>;

begin
 Items:=TList<Variant>.Create;
  try
    FDataSet.DisableControls;
    try
      FDataSet.SaveToList(Items);
      CurrentID:=FDataSet.FieldByName('AppTemplatesDataId').Value;
      CurrentParentId:=FDataSet.FieldByName('ParentId').Value;
      NewID:=TAbstractTemplateImport.NewID;

      FDataSet.Edit;
      FDataSet.FieldByName('ParentId').Value:=NewID;
      FDataSet.FieldByName('TagType').AsInteger:=TagTypeListThroughDataSet;
      FDataSet.FieldByName('DataSetName').AsString:=FindFirstDataSetName;
      FDataSet.Edit;
      FDataSet.Append;
      FDataSet.LoadFromList(Items);
      FDataSet.FieldByName('AppTemplatesDataId').AsInteger:=NewID;
      FDataSet.FieldByName('ParentId').Value:=CurrentParentId;
      FDataSet.Post;

    finally
     FDataSet.EnableControls;
    end;

  finally
   Items.Free;
  end;
end;

procedure TManagerEditorAppTemplate.InsertDataSetNodeActionExecute(Sender: TObject);
begin
 InsertDataSetNode;
end;

procedure TManagerEditorAppTemplate.InternalApplyToAllChildren( const FieldName: string);
begin
   SetAllRows(FDataSet.FieldByName('AppTemplatesDataId').AsInteger, FieldName,FDataSet.FieldByName(FieldName).Value);
end;

procedure TManagerEditorAppTemplate.InternalRun;
begin
 if ExecuteParamsDlg then
  Run;
end;

function TManagerEditorAppTemplate.InvalidData(DataSet: TDataSet): Boolean;
var
 InvalidDataField:Boolean;
 InvalidDataSet:Boolean;
 InvalidParams:Boolean;
 InvalidGlobalSetting:Boolean;
begin
 InvalidDataSet:=(DataSet.FieldByName('TagType').AsInteger=TagTypeListThroughDataSet) and (DataSet.FieldByName('DataSetName').AsString.Trim.IsEmpty);

 InvalidDataField:=(DataSet.FieldByName('ValueSource').AsInteger=ValueSourceDataField)
               and (DataSet.FieldByName('TagType').AsInteger<>TagTypeListThroughDataSet)
               and (DataSet.FieldByName('Value').AsString.Trim.IsEmpty or DataSet.FieldByName('DataSetName').AsString.Trim.IsEmpty);
 InvalidParams:=(DataSet.FieldByName('ValueSource').AsInteger=ValueSourceParameter) and DataSet.FieldByName('Value').AsString.Trim.IsEmpty;
 InvalidGlobalSetting:=(DataSet.FieldByName('ValueSource').AsInteger=ValueSourceGlobalSetting) and DataSet.FieldByName('Value').AsString.Trim.IsEmpty;

 Result:=InvalidDataSet or InvalidDataField or InvalidParams or InvalidGlobalSetting;
end;


function TManagerEditorAppTemplate.KeyPressed: Boolean;
begin
 Result:=(GetKeyState(VK_CONTROL) and 128) = 128;
end;


procedure TManagerEditorAppTemplate.PopulateDataSetCombo;
var
 DataSet:TDataSet;
 Items:TStrings;
begin
 Items:=(colDataSetName.Properties.EditProperties as TcxComboBoxProperties).Items;
 Items.Clear;
 DataSet:=DataSetListDS.DataSet;
 if DataSet.Active then
  begin
    DataSet.First;
    while not DataSet.Eof do
     begin
       Items.Add(DataSet.FieldByName('DataSetName').AsString);
       DataSet.Next;
     end;
    DataSet.First;
  end;
end;


procedure TManagerEditorAppTemplate.PopulateRunParams;
var
 P:TParam;
 x:Integer;
 AExt:string;
begin
 if FRunParamsPopulated=False then
  begin
   if DataSet.FieldByName('TemplateType').AsInteger=2 then
    AExt:='.json'
     else
    AExt:='.xml';

   FRunParams.SetParameter('FileName','C:\'+AppMainTreeDescription+AExt);
   FRunParams.SetParameter('DefaultFileName','C:\'+AppMainTreeDescription+AExt);
   FRunParamsPopulated:=True;
  end;

DataSetParams.Close;
DataSetParams.Open;
DataSetParams.Edit;


for x:=0 to  FRunParams.Count-1 do
 begin
   P:=FRunParams[x];
   DataSetParams.Append;
   DataSetParams.FieldByName('Name').AsString:=P.Name;
   DataSetParams.FieldByName('Value').AsString:=P.Value;
   DataSetParams.Post;
 end;
end;

procedure TManagerEditorAppTemplate.NewItemActionExecute(Sender: TObject);
begin
 TAbstractTemplateImport.NewItem(FDataSet, TAbstractTemplateImport.NewID, FDataSet.FieldByName('AppTemplatesDataId').Value,0,S_NEW_TEMPLATE_NODE,'', ValueTypeJsonString);
// FDataSet.Post;
end;

procedure TManagerEditorAppTemplate.NewRootItemActionExecute(Sender: TObject);
begin
 TAbstractTemplateImport.NewItem(FDataSet, TAbstractTemplateImport.NewID,NULL,0,S_NEW_TEMPLATE_NODE,'', ValueTypeJsonString);
// FDataSet.Post;
end;

procedure TManagerEditorAppTemplate.OnCopyDataSet(Source, Dest: TDataSet);
var
 OldId:Int64;
 OldParentId:Int64;
begin
 OldId:=Source.FieldByName('AppTemplatesDataId').AsInteger;
 OldParentId:=Source.FieldByName('ParentId').AsInteger;

 Dest.FieldByName('AppTemplatesDataId').AsInteger:=FNewKeys[OldId];
 if FNewKeys.ContainsKey(OldParentId) then
  Dest.FieldByName('ParentId').AsInteger:=FNewKeys[OldParentId]
   else
  Dest.FieldByName('ParentId').Clear;
end;

procedure TManagerEditorAppTemplate.RefreshActionExecute(Sender: TObject);
begin
 FDataSet.Close;
 FDataSet.ReQuery;
end;

procedure TManagerEditorAppTemplate.Run;
var
 Builder:TAppTemplateBuilder;
begin
  Builder:=TAppTemplateBuilder.Create(nil);
  try
   Builder.Params.Assign(FRunParams);
   Builder.AppTemplatesId:=Self.ID;
   Builder.AutoClose:=False;
   Builder.Execute;
  finally
   Builder.Free;
  end;
end;

procedure TManagerEditorAppTemplate.RunActionExecute(Sender: TObject);
begin
 if (DetailDataSets.Modified) or (DataSet.Modified) then
  begin
   if MessageBox(Handle, PChar(S_COMMON_SAVECHANGES_Q), PChar(S_COMMON_INFORMATION),MB_YESNO+MB_ICONQUESTION)=ID_YES then
    begin
      SaveActionExecute(nil);
      InternalRun;
    end;
  end
   else
    InternalRun;

end;

procedure TManagerEditorAppTemplate.SaveActionExecute(Sender: TObject);
begin
 DetailDataSets.ApplyUpdatesAll;
 FDataSet.Edit;
end;

procedure TManagerEditorAppTemplate.SaveState;
begin
//  inherited;
end;

procedure TManagerEditorAppTemplate.LoadState(LoadPosition, LoadSize: Boolean);
begin
//  inherited;
end;


procedure TManagerEditorAppTemplate.SchemaCreateNode(Sender: TObject;  Node: TdxOcNode);
begin
 SetNodeProperties(Node);
end;

procedure TManagerEditorAppTemplate.SchemaDeletion(Sender: TObject;  Node: TdxOcNode);
begin
;
end;

procedure TManagerEditorAppTemplate.SchemaKeyDown(Sender: TObject;  var Key: Word; Shift: TShiftState);
begin
 if Key=VK_DELETE then
  bnDelete.Action.Execute;
end;

procedure TManagerEditorAppTemplate.SetAllRows(AppTemplatesDataId: Integer;  const FieldName: string; const Value:Variant);
var
 ID:Variant;
begin
 ID:=FDataSet.FieldByName('AppTemplatesDataId').Value;
 try
  FDataSet.Filtered:=False;
  FDataSet.Filter:='ParentId='+AppTemplatesDataId.ToString;
  FDataSet.Filtered:=True;
  FDataSet.SetAllRows(FDataSet.FieldByName(FieldName),Value);
 finally
  FDataSet.Filter:='';
  FDataSet.Filtered:=False;
  FDataSet.Locate('AppTemplatesDataId', ID);
 end;

end;

procedure TManagerEditorAppTemplate.SetCommonLayout;
begin
 Height:=450;
 Width:=550;
 groupSchema.Visible:=False;
 TopMenu.Visible:=False;
end;

procedure TManagerEditorAppTemplate.SetNodeProperties(Node: TdxOcNode);
var
 TagType:Integer;
 ValueSource:Integer;
begin
  TagType:=FDataSet.FieldByName('TagType').AsInteger;
  ValueSource:=FDataSet.FieldByName('ValueSource').AsInteger;

  case TagType of
   TagTypeXmlAttrib:;//DoNothing;
   TagTypeJsonItem:Node.Shape:=TdxOcShape.shRectangle;
   TagTypeListThroughDataSet:Node.ImageIndex:=29;
   TagTypeGroup:Node.Color:=$00DDEAB6;
    else
   Node.Shape:=TdxOcShape.shRoundRect;
  end;

  if TagType<>TagTypeGroup then
  case ValueSource of
   0:if TagType=TagTypeXmlAttrib then Node.Color:=$CDCDCD else Node.Color:=$f2f2f2;  //const - soft gray
   1:Node.Color:=$ccffdc;  //DataField - soft green
   2:Node.Color:=$e6f5ff;  //Params - soft yellow
   3:Node.Color:=$00FDEAC6;  //Global Setting - soft blue
  end;

  if (FDataSet.FieldByName('Active').AsBoolean=False) then
    Node.Color:=$7C6C5C;

  if InvalidData(FDataSet) then
   Node.Color:=clRed;


  Node.Width:=150;
  Node.Height:=22;
end;

procedure TManagerEditorAppTemplate.SetTemplateLayout;
begin
 groupCommon.Visible:=False;
 pnBottomButtons.Visible:=False;
 PopulateDataSetCombo;
end;


procedure TManagerEditorAppTemplate.TryPopulate(Sender: TObject);
begin
 if not FPopulated then
  begin
   DataSetListDS.DataSet.Open;
   PopulateDataSetCombo;
   FPopulated:=True;
  end;
end;

procedure TManagerEditorAppTemplate.UpdateActivity;
begin
  groupCommon.Enabled:=cbActive.Checked;
end;

procedure TManagerEditorAppTemplate.UpdateNodeAfterPost(DataSet: TDataSet);
begin
if Assigned(Schema.Selected) then
 SetNodeProperties(Schema.Selected);
end;

initialization
  TWindowManager.RegisterEditor(iTypeAppTemplate,nil,TManagerEditorAppTemplate, False);
finalization

end.
