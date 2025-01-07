unit ManagerEditor.Command;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, ManagerEditor.Common, cxGraphics,
  cxLookAndFeels, cxLookAndFeelPainters, Vcl.Menus, cxControls, Data.DB,
  cxClasses, dxLayoutContainer, dxLayoutControl, Vcl.StdCtrls, cxButtons,
  Vcl.ExtCtrls,dxLayoutcxEditAdapters, cxContainer, cxEdit,
  cxTextEdit, cxDBEdit, cxMemo, cxMaskEdit, cxDropDownEdit, cxImageComboBox,
  cxCheckBox, dxBarBuiltInMenu, cxPC, cxButtonEdit,dxLayoutControlAdapters,
  Common.Images,
  Common.Images.SelectDialog,
  Common.ResourceStrings,
  DAC.XDataSet,
  DAC.DataBaseUtils,
  DAC.ConnectionMngr,
  CustomControl.Interfaces,
  StaticDialog.AppObjectSelector,
  Manager.WindowManager,
  CustomControl.MiceValuePicker,
  Params.SourceSelectorFrame, Vcl.Buttons, Vcl.DBCtrls;

type
  TcxPageControl = class(CxPC.TcxPageControl, IAmLazyControl)
   procedure LazyInit(ParentObject: IInheritableAppObject);
   procedure RefreshDataSet;
  end;
{
  TcxDBButtonEdit = class(TMiceValuePicker)

  end;
 }
  TManagerEditorCommand = class(TCommonManagerDialog)
    Tab0: TdxLayoutGroup;
    Label1: TLabel;
    dxLayoutItem1: TdxLayoutItem;
    Image1: TImage;
    Image1_Item: TdxLayoutItem;
    edAppCmdId: TcxDBTextEdit;
    edAppCmdId_item: TdxLayoutItem;
    dxLayoutAutoCreatedGroup2: TdxLayoutAutoCreatedGroup;
    dxLayoutSeparatorItem1: TdxLayoutSeparatorItem;
    edName: TcxDBTextEdit;
    edName_Item: TdxLayoutItem;
    edLocation: TcxDBTextEdit;
    edLocation_Item: TdxLayoutItem;
    Tab1: TdxLayoutGroup;
    memoDescr: TcxDBMemo;
    memoDescr_Item: TdxLayoutItem;
    edHint: TcxDBTextEdit;
    edHint_Item: TdxLayoutItem;
    edCreateOrder: TcxDBTextEdit;
    edCreateOrder_Item: TdxLayoutItem;
    dxLayoutGroup1: TdxLayoutGroup;
    dxLayoutGroup2: TdxLayoutGroup;
    edEnabledFieldName: TcxDBTextEdit;
    edEnabledFieldName_Item: TdxLayoutItem;
    edEnabledValue: TcxDBTextEdit;
    edEnabledValue_Item: TdxLayoutItem;
    edEnabledSign: TcxDBImageComboBox;
    edEnabledSign_Item: TdxLayoutItem;
    edCaption: TcxDBTextEdit;
    edCaption_Item: TdxLayoutItem;
    chboxAlwaysEnabled: TcxDBCheckBox;
    chboxAlwaysEnabled_Item: TdxLayoutItem;
    dxLayoutAutoCreatedGroup7: TdxLayoutAutoCreatedGroup;
    ddExecuteAction: TcxDBImageComboBox;
    item_ddExecuteAction: TdxLayoutItem;
    Image2: TImage;
    dxLayoutItem3: TdxLayoutItem;
    dxLayoutSeparatorItem2: TdxLayoutSeparatorItem;
    Tab2: TdxLayoutGroup;
    dxLayoutGroup3: TdxLayoutGroup;
    pgActionType: TcxPageControl;
    pgActionType_Item: TdxLayoutItem;
    ATab0: TcxTabSheet;
    ATab1: TcxTabSheet;
    ATab2: TcxTabSheet;
    ATab3: TcxTabSheet;
    ATab4: TcxTabSheet;
    ATab5: TcxTabSheet;
    cbEnabledWhenNoRecords: TcxDBCheckBox;
    dxLayoutItem2: TdxLayoutItem;
    bnEditScript: TcxButton;
    pnDialog: TPanel;
    Label2: TLabel;
    edDialogID: TcxDBButtonEdit;
    ddDialogPlacement: TcxDBImageComboBox;
    Label4: TLabel;
    pnPlugin: TPanel;
    edPluginID: TcxDBButtonEdit;
    Label5: TLabel;
    Panel3: TPanel;
    Panel4: TPanel;
    AParams1: TCommandPropertiesFrame;
    Label9: TLabel;
    bnImageIndex: TcxButton;
    dxLayoutItem4: TdxLayoutItem;
    edWidth: TcxDBTextEdit;
    item_Width: TdxLayoutItem;
    dxLayoutAutoCreatedGroup8: TdxLayoutAutoCreatedGroup;
    dxLayoutAutoCreatedGroup3: TdxLayoutAutoCreatedGroup;
    item_ddStyle: TdxLayoutItem;
    ddStyle: TcxImageComboBox;
    ATab6: TcxTabSheet;
    pnAppTemplate: TPanel;
    edTemplatesID: TcxDBButtonEdit;
    Label10: TLabel;
    Panel6: TPanel;
    Panel7: TPanel;
    Label11: TLabel;
    AParams2: TCommandPropertiesFrame;
    pnPluginMethod: TPanel;
    ddPluginMethod: TcxDBImageComboBox;
    Label7: TLabel;
    Panel9: TPanel;
    Panel10: TPanel;
    Label12: TLabel;
    AParams3: TCommandPropertiesFrame;
    Panel11: TPanel;
    pnStoredProcedure: TPanel;
    edStoredProc: TcxDBButtonEdit;
    Label8: TLabel;
    cbAutoRefresh: TcxDBCheckBox;
    item_cbAutoRefresh: TdxLayoutItem;
    Other: TdxLayoutGroup;
    dxLayoutAutoCreatedGroup5: TdxLayoutAutoCreatedGroup;
    edShortCut: TcxDBTextEdit;
    edShortCut_Item: TdxLayoutItem;
    ATab7: TcxTabSheet;
    Label14: TLabel;
    cbValidateFile: TCheckBox;
    Label17: TLabel;
    Label18: TLabel;
    Label19: TLabel;
    ddMultiSelect: TcxDBImageComboBox;
    item_MultiSelect: TdxLayoutItem;
    cbContinueOnError: TDBCheckBox;
    dxLayoutItem5: TdxLayoutItem;
    GroupActionOptions: TdxLayoutGroup;
    dxLayoutAutoCreatedGroup1: TdxLayoutAutoCreatedGroup;
    dxLayoutAutoCreatedGroup6: TdxLayoutAutoCreatedGroup;
    dxLayoutAutoCreatedGroup4: TdxLayoutAutoCreatedGroup;
    edOpenFileCmdProviderName: TcxDBButtonEdit;
    cbOpenFileDBName: TcxDBComboBox;
    edspDBName: TcxDBComboBox;
    Label21: TLabel;
    edOpenFileParamName: TcxDBTextEdit;
    cbFilter: TcxDBComboBox;
    ddOpenFileBehavior: TcxImageComboBox;
    Label22: TLabel;
    dxLayoutAutoCreatedGroup9: TdxLayoutAutoCreatedGroup;
    ddDialogBehavior: TcxDBImageComboBox;
    ddEncoding: TcxImageComboBox;
    Label23: TLabel;
    ATab8: TcxTabSheet;
    Panel14: TPanel;
    Panel12: TPanel;
    Label3: TLabel;
    Label6: TLabel;
    edAppReportsId: TcxDBButtonEdit;
    memoInfoTemplate: TcxMemo;
    Panel2: TPanel;
    Panel5: TPanel;
    Label15: TLabel;
    AParams5: TCommandPropertiesFrame;
    Panel1: TPanel;
    Panel8: TPanel;
    Label13: TLabel;
    AParams4: TCommandPropertiesFrame;
    Panel13: TPanel;
    Panel15: TPanel;
    Label16: TLabel;
    AParams6: TCommandPropertiesFrame;
    ddAppearsOn: TcxDBImageComboBox;
    Item_ddAppearsOn: TdxLayoutItem;
    dxLayoutAutoCreatedGroup10: TdxLayoutAutoCreatedGroup;
    procedure ddExecuteActionPropertiesChange(Sender: TObject);
    procedure chboxAlwaysEnabledClick(Sender: TObject);
    procedure edStoredProcPropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
    procedure edEnabledSignPropertiesChange(Sender: TObject);
    procedure edDialogIDPropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
    procedure edPluginIDPropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
    procedure bnImageIndexClick(Sender: TObject);
    procedure edTemplatesIDPropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
    procedure pgActionTypePageChanging(Sender: TObject; NewPage: TcxTabSheet;
      var AllowChange: Boolean);
    procedure ErrorClick(Sender: TObject);
    procedure bnEditScriptClick(Sender: TObject);
    procedure ddMultiSelectPropertiesChange(Sender: TObject);
    procedure edAppReportsIdPropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
  private
    FCmdParams:TxDataSet;
    FCmdParamsDs:TDataSource;
    FOpening:Boolean;
    FContinueOnError: Boolean;
    FAppPluginsId: Variant;
    FOnEditScript: TNotifyEvent;
    procedure UpdateActivityCondition(Value:Boolean);
    procedure UpdateSign(Value:Integer);
    procedure LoadInitString;
    procedure SaveInitString;
    procedure SetAppScriptsId(const Value: Integer);
    procedure PopulateCommonFilters;
    function MultiSelectAllowed:Boolean;
    function GetAppScriptsId: Integer;
  protected
    procedure EnterInsertingState; override;
    procedure EnterEditingState; override;
    procedure DoEditScript; virtual;
  public
    property AppPluginsId:Variant read FAppPluginsId write FAppPluginsId;
    property AppScriptsId:Integer read GetAppScriptsId write SetAppScriptsId;
    property OnEditScript:TNotifyEvent read FOnEditScript write FOnEditScript;
    procedure Initialize; override;
    procedure SaveChanges; override;
    constructor Create(AOwner:TComponent);override;
    destructor Destroy; override;
  end;

  TManagerEditorCommonCommand = class(TManagerEditorCommand)
  protected
   procedure EnterInsertingState; override;
   procedure SynchronizeTree(ItemInserted:Boolean); override;
  public
   procedure Initialize; override;
   constructor Create(AOwner:TComponent);override;
  end;



implementation

{$R *.dfm}
constructor TManagerEditorCommand.Create(AOwner: TComponent);
resourcestring
 S_EDIT_COMMAND_DIALOG_CAPTION = 'Edit command';
begin
  inherited;
  Self.pgActionType.Properties.HideTabs:=True;
  FOpening:=True;
  TableName:='AppCmd';
  KeyField:='AppCmdId';
  ImageIndex:= IMAGEINDEX_COMMAND;
  iType:=iTypeCommand;
  AppMainTreeDescriptionField:='Caption';
  TImageContainer.LoadToImage(Image1,IMAGEINDEX_COMMAND);
  TImageContainer.LoadToImage(Image2,26);
  FCmdParamsDs:=DetailDataSets.CreateDataSource('AppCmdParams','','','TManagerEditorCommand.CommandParams', sq_AppCmdParams,SeqDb);
  (FCmdParamsDs.DataSet as TxDataSet).SequenceDBName:=ConnectionManager.SequenceServer;
  AParams1.MainView.DataController.DataSource:=FCmdParamsDs;
  AParams2.MainView.DataController.DataSource:=FCmdParamsDs;
  AParams3.MainView.DataController.DataSource:=FCmdParamsDs;
  AParams4.MainView.DataController.DataSource:=FCmdParamsDs;
  AParams5.MainView.DataController.DataSource:=FCmdParamsDs;
  AParams5.MainView.DataController.DataSource:=FCmdParamsDs;
  AParams6.MainView.DataController.DataSource:=FCmdParamsDs;

  FCmdParams:=FCmdParamsDs.DataSet as TxDataSet;
  DialogCaption:=S_EDIT_COMMAND_DIALOG_CAPTION;

  PopulateCommonFilters;


{
  edTemplatesID.AppObject.Properties.ProviderName:='spui_AppTemplatesInfo @AppTemplatesId=<RunAppTemplatesId>';
   edTemplatesID.KeyField:='AppTemplatesId';
  edTemplatesID.CaptionField:='Name';
  //edTemplatesID.ClearButtonEnabled:=True;
 }

//  DetailDataSets.CreateDataSource()
end;

procedure TManagerEditorCommand.bnEditScriptClick(Sender: TObject);
begin
 DoEditScript;
end;

procedure TManagerEditorCommand.bnImageIndexClick(Sender: TObject);
var
 AImageIndex:Integer;
begin
 AImageIndex:=DataSet.FieldByName('ImageIndex').AsInteger;
 if TSelectImageDialog.Execute(AImageIndex) then
  begin
   bnImageIndex.OptionsImage.ImageIndex:=AImageIndex;
   DataSet.FieldByName('ImageIndex').AsInteger:=AImageIndex;
   ImageIndex:=AImageIndex;
  end;
end;

procedure TManagerEditorCommand.ErrorClick(Sender: TObject);
begin
 FContinueOnError:=(Sender as TCheckBox).Checked;
end;

function TManagerEditorCommand.GetAppScriptsId: Integer;
begin
 Result:=Self.DataSet.FieldByName('RunAppScriptsId').AsInteger;
end;


procedure TManagerEditorCommand.chboxAlwaysEnabledClick(Sender: TObject);
begin
 UpdateActivityCondition(not chboxAlwaysEnabled.Checked);
end;

procedure TManagerEditorCommand.ddExecuteActionPropertiesChange(Sender: TObject);
begin
 pgActionType.ActivePageIndex:=Self.ddExecuteAction.ItemIndex;
 ddMultiSelect.Enabled:=MultiSelectAllowed;
 cbContinueOnError.Enabled:=ddMultiSelect.Enabled and (ddMultiSelect.ItemIndex<>0);
end;

procedure TManagerEditorCommand.ddMultiSelectPropertiesChange(Sender: TObject);
begin
  inherited;
  cbContinueOnError.Enabled:=(MultiSelectAllowed) and (ddMultiSelect.ItemIndex<>0);
end;

destructor TManagerEditorCommand.Destroy;
begin

  inherited;
end;


procedure TManagerEditorCommand.DoEditScript;
begin
 if Assigned(OnEditScript) then
  OnEditScript(Self);
end;

procedure TManagerEditorCommand.edAppReportsIdPropertiesButtonClick(Sender: TObject; AButtonIndex: Integer);
var
 x:Integer;
 s:string;
begin
 if TAppObjectSelectionDialog.ExecuteDialog(iTypeAppReport,x,s) then
  DataSet.FieldByName('RunAppReportsId').AsInteger:=x;
end;


procedure TManagerEditorCommand.edDialogIDPropertiesButtonClick(Sender: TObject; AButtonIndex: Integer);
var
 x:Integer;
 s:string;
begin
 if TAppObjectSelectionDialog.ExecuteDialog(iTypeDialog,x,s) then
  DataSet.FieldByName('RunAppDialogsId').AsInteger:=x;
end;

procedure TManagerEditorCommand.edEnabledSignPropertiesChange(Sender: TObject);
begin
 UpdateSign(edEnabledSign.ItemIndex);
end;

procedure TManagerEditorCommand.edPluginIDPropertiesButtonClick(Sender: TObject; AButtonIndex: Integer);
var
 x:Integer;
 s:string;
begin
 if TAppObjectSelectionDialog.ExecuteDialog(iTypePlugin,x,s) then
  DataSet.FieldByName('RunAppPluginsId').AsInteger:=x;
end;

procedure TManagerEditorCommand.edStoredProcPropertiesButtonClick(Sender: TObject; AButtonIndex: Integer);
var
 x:Integer;
 s:string;
begin
 if TSysObjectSelectionDialog.ExecuteDialog(iTypeStoredProc,x,s,'') then
  DataSet.FieldByName('SPValue').AsString:=s;
end;

procedure TManagerEditorCommand.edTemplatesIDPropertiesButtonClick(Sender: TObject; AButtonIndex: Integer);
var
 x:Integer;
 s:String;
begin
 if TAppObjectSelectionDialog.ExecuteDialog(iTypeAppTemplate,x,s) then
  DataSet.FieldByName('RunAppTemplatesId').AsInteger:=x;
end;


procedure TManagerEditorCommand.EnterEditingState;
begin
  inherited;
  AppPluginsId:=Self.DataSet.FieldByName('AppPluginsId').Value;
  LoadInitString;
  edAppCmdId.Enabled:=False;
  UpdateActivityCondition(not chboxAlwaysEnabled.Checked);
  UpdateSign(edEnabledSign.ItemIndex);
end;

procedure TManagerEditorCommand.EnterInsertingState;
resourcestring
 S_DEFAULT_NEWCOMMAND_CAPTION_FMT = 'New command %d';
begin
  inherited;
  AppPluginsId:=OwnerObjectId;
  DataSet.FieldByName('AppCmdId').AsInteger:=TDataBaseUtils.NewAppObjectId(sq_AppCmd);
  DataSet.FieldByName('CommandType').AsInteger:=0;
  DataSet.FieldByName('AppPluginsId').Value:=AppPluginsId;
  DataSet.FieldByName('ImageIndex').AsInteger:=ImageIndex;
  DataSet.FieldByName('iType').AsInteger:=iTypeCommand;
  DataSet.FieldByName('ActionType').AsInteger:=0;
  DataSet.FieldByName('Location').AsString:=S_DEFAULT_APPCOMMAND_LOCATION;
  DataSet.FieldByName('AlwaysEnabled').AsBoolean:=True;
  DataSet.FieldByName('Name').AsString:='bnNewCommand'+DataSet.FieldByName('AppCmdId').AsString;
  DataSet.FieldByName('Caption').AsString:=Format(S_DEFAULT_NEWCOMMAND_CAPTION_FMT,[DataSet.FieldByName('AppCmdId').AsInteger]);
//  DataSet.FieldByName('Group').AsInteger:=0;
  DataSet.FieldByName('AppearsOn').AsInteger:=0;
  DataSet.FieldByName('CreateOrder').AsInteger:=100;
  DataSet.FieldByName('EnabledSign').AsInteger:=0;
  DataSet.FieldByName('EnabledNoRecords').AsBoolean:=False;
  DataSet.FieldByName('FullAccess').AsBoolean:=True;
  DataSet.FieldByName('Autorefresh').AsBoolean:=True;
  DataSet.FieldByName('Active').AsBoolean:=True;
  DataSet.FieldByName('RunAppDialogPlacement').AsInteger:=0;
  DataSet.FieldByName('ContinueOnError').AsBoolean:=False;
  DataSet.FieldByName('MultiSelectBehavior').AsInteger:=0;
  DataSet.FieldByName('AppDialogShowBehavior').AsInteger:=0;

  bnEditScript.Enabled:=False;

 // DataSet.FieldByName('Name').AsString:='NewCommand'+' '+DataSet.FieldByName('AppCmdId').AsString;
end;

procedure TManagerEditorCommand.Initialize;
begin
 FOpening:=True;
 inherited;
 bnImageIndex.OptionsImage.ImageIndex:=DataSet.FieldByName('ImageIndex').AsInteger;
 FOpening:=False;
 FCmdParams.Open;
end;

procedure TManagerEditorCommand.LoadInitString;
begin
  if (DataSet.FieldByName('InitString').AsString.Trim.IsEmpty=False) then
   begin
    MiceAppObject.AsJson:=DataSet.FieldByName('InitString').AsString;
    ddStyle.ItemIndex:=MiceAppObject.Properties.Style;
    ddOpenFileBehavior.ItemIndex:=MiceAppObject.Properties.OpenFileBehavior;
    cbValidateFile.Checked:=MiceAppObject.Properties.ValidateBeforeOpen;
    ddEncoding.ItemIndex:=MiceAppObject.Properties.FileEncoding;
   end;
end;

function TManagerEditorCommand.MultiSelectAllowed: Boolean;
var
 x:Integer;
begin
 x:=ddExecuteAction.ItemIndex;
 Result:=(x=5) or (x=6) or (x=7);
end;

procedure TManagerEditorCommand.pgActionTypePageChanging(Sender: TObject;  NewPage: TcxTabSheet; var AllowChange: Boolean);
var
 Control:TControl;
 x:Integer;
begin
if FOpening=False then
 for x:=0 to NewPage.ControlCount-1 do
  begin
   Control:=NewPage.Controls[x];
   if Supports(Control,IAmLazyControl) then
   (Control as IAmLazyControl).LazyInit(nil);
  end;
end;

procedure TManagerEditorCommand.PopulateCommonFilters;
begin
 cbFilter.Properties.Items.Add(S_OPEN_FILE_FILTER_ALL);
 cbFilter.Properties.Items.Add(S_OPEN_FILE_FILTER_JSON);
 cbFilter.Properties.Items.Add(S_OPEN_FILE_FILTER_XML_ONLY);
 cbFilter.Properties.Items.Add(S_OPEN_FILE_FILTER_EXCEL);
 cbFilter.Properties.Items.Add(S_OPEN_FILE_FILTER_PDF);
 cbFilter.Properties.Items.Add(S_OPEN_FILE_FILTER_XML_COMMON);
 cbFilter.Properties.Items.Add(S_OPEN_FILE_FILTER_WORD);
 cbFilter.Properties.Items.Add(S_OPEN_FILE_FILTER_IMAGES_COMMON);
end;

procedure TManagerEditorCommand.SaveChanges;
begin
  SaveInitString;
  inherited;
end;

procedure TManagerEditorCommand.SaveInitString;
begin
 MiceAppObject.Properties.Style:=ddStyle.ItemIndex;
 MiceAppObject.Properties.OpenFileBehavior:=ddOpenFileBehavior.ItemIndex;
 MiceAppObject.Properties.ValidateBeforeOpen:=cbValidateFile.Checked;
 MiceAppObject.Properties.FileEncoding:=ddEncoding.ItemIndex;
 MiceAppObject.WriteNullIfEmpty(DataSet.FieldByName('InitString'));
end;



procedure TManagerEditorCommand.SetAppScriptsId(const Value: Integer);
begin
 DataSet.FieldByName('RunAppScriptsId').AsInteger:=Value;
end;

procedure TManagerEditorCommand.UpdateActivityCondition(Value: Boolean);
begin
 edEnabledFieldName.Enabled:=Value;
 edEnabledSign.Enabled:=Value;
 edEnabledValue.Enabled:=Value;
 cbEnabledWhenNoRecords.Enabled:=Value;
 UpdateSign(edEnabledSign.ItemIndex)
end;

procedure TManagerEditorCommand.UpdateSign(Value: Integer);
begin
 edEnabledValue.Enabled:=(not chboxAlwaysEnabled.Checked) and ((Value<>6) and (Value<>7)) ;
end;

{ TcxPageControl }

procedure TcxPageControl.LazyInit(ParentObject: IInheritableAppObject);
var
 Allow:Boolean;
begin
 if Assigned(OnPageChanging) and Assigned(ActivePage) then
  begin
   Allow:=True;
   OnPageChanging(Self,ActivePage, Allow);
  end;
end;

procedure TcxPageControl.RefreshDataSet;
begin

end;

{ TManagerEditorCommonCommand }

constructor TManagerEditorCommonCommand.Create(AOwner: TComponent);
begin
  inherited;
  iType:=iTypeCommonCommand;
  ReadOnly:=True;
end;

procedure TManagerEditorCommonCommand.EnterInsertingState;
begin
  inherited;
  DataSet.FieldByName('iType').AsInteger:=iTypeCommonCommand;
  DataSet.FieldByName('AppPluginsId').Clear;
end;

procedure TManagerEditorCommonCommand.Initialize;
begin
  inherited;
  if ReadOnly then
   begin
    Label1.Caption:=Label1.Caption+S_COMMON_READONLY_BRACKETS;
    bnImageIndex.Enabled:=False;
    ddStyle.Enabled:=False;
    bnEditScript.Enabled:=False;
   end;
end;

procedure TManagerEditorCommonCommand.SynchronizeTree(ItemInserted: Boolean);
begin
 //Do nothing instead of inherited;
end;

initialization
  TWindowManager.RegisterEditor(iTypeCommand,nil,TManagerEditorCommand, False);
  TWindowManager.RegisterEditor(iTypeCommonCommand,nil,TManagerEditorCommonCommand, False);
finalization

end.
