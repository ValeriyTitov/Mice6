unit ManagerEditor.dfPathFolder;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, ManagerEditor.Common, cxGraphics,
  cxLookAndFeels, cxLookAndFeelPainters, Vcl.Menus, cxControls, Data.DB,
  cxClasses, dxLayoutContainer, dxLayoutControl, Vcl.StdCtrls, cxButtons,
  Vcl.ExtCtrls,  dxLayoutcxEditAdapters, cxContainer, cxEdit,
  cxTextEdit, cxDBEdit, dxCore, cxCheckBox, cxMaskEdit, cxDropDownEdit,
  dxColorEdit, dxDBColorEdit, dxLayoutControlAdapters, Vcl.Buttons, Vcl.DBCtrls,
  cxImageComboBox, cxMemo,cxButtonEdit,
  Manager.WindowManager,
  DAC.DatabaseUtils,
  DAC.ConnectionMngr,
  DAC.xDataSet,
  Common.Images,
  Common.ResourceStrings,
  Common.Images.SelectDialog,
  CustomControl.MiceValuePicker,
  CustomControl.MiceFlowChart.FlowObjects,
  ManagerEditor.dfPathFolder.RulesFrame,
  ManagerEditor.dfPathFolder.InitFrame,
  ManagerEditor.dfPathFolder.ActionsFrame,
  ManagerEditor.dfPathFolder.DecisionFrame,
  CustomControl.MiceFlowChart.Shapes,
  Permissions.Frame, System.ImageList, Vcl.ImgList, cxImageList,
  CustomControl.MiceFlowChart.PropertiesFrame;

type
  TcxButtonEdit = class (TMiceValuePicker)

  end;

  TManagerEditorDfPathFolder = class(TCommonManagerDialog)
    Label2: TLabel;
    item_Label1: TdxLayoutItem;
    Image1: TImage;
    item_Image: TdxLayoutItem;
    dxLayoutSeparatorItem1: TdxLayoutSeparatorItem;
    edCaption: TcxDBTextEdit;
    edCaption_Item: TdxLayoutItem;
    ceFontColor: TdxDBColorEdit;
    item_FontColor: TdxLayoutItem;
    ceBGColor: TdxDBColorEdit;
    Item_BackgroundColor: TdxLayoutItem;
    bnImageIndex: TcxButton;
    dxLayoutItem4: TdxLayoutItem;
    Tab0: TdxLayoutGroup;
    Tab2: TdxLayoutGroup;
    Tab3: TdxLayoutGroup;
    Tab1: TdxLayoutGroup;
    CommonGroup: TdxLayoutGroup;
    cbActive: TDBCheckBox;
    Item_Active: TdxLayoutItem;
    cbAllowEdit: TDBCheckBox;
    dxLayoutItem6: TdxLayoutItem;
    Tab4: TdxLayoutGroup;
    ddFolderType: TcxDBImageComboBox;
    item_FolderType: TdxLayoutItem;
    cbAllowDelete: TDBCheckBox;
    cbAllowDelete_Item: TdxLayoutItem;
    ddCodeName: TcxDBComboBox;
    item_cbStateName: TdxLayoutItem;
    cbAllowDesktop: TDBCheckBox;
    dxLayoutItem7: TdxLayoutItem;
    dxLayoutAutoCreatedGroup3: TdxLayoutAutoCreatedGroup;
    cbAutoRoute: TDBCheckBox;
    item_AutoRoute: TdxLayoutItem;
    cbEnableMethodSelection: TDBCheckBox;
    item_cbEnableMethodSelection: TdxLayoutItem;
    Tab6: TdxLayoutGroup;
    LineGroup: TdxLayoutGroup;
    dxLayoutAutoCreatedGroup5: TdxLayoutAutoCreatedGroup;
    Schema: TdxLayoutGroup;
    Dialogs: TdxLayoutGroup;
    cbShowForEach: TDBCheckBox;
    item_cbShowForEach: TdxLayoutItem;
    ddApplyMethod: TcxDBImageComboBox;
    item_ddApplyMethod: TdxLayoutItem;
    memoUserInformation: TcxDBMemo;
    item_MemInfo: TdxLayoutItem;
    Tab5: TdxLayoutGroup;
    cbItalic: TCheckBox;
    dxLayoutItem1: TdxLayoutItem;
    cbUnderLined: TCheckBox;
    dxLayoutItem2: TdxLayoutItem;
    cbBold: TCheckBox;
    dxLayoutItem3: TdxLayoutItem;
    dxLayoutAutoCreatedGroup2: TdxLayoutAutoCreatedGroup;
    item_dfRules: TdxLayoutItem;
    RulesFrame: TdfPathFoldersIncomingRulesFrame;
    item_dfInit: TdxLayoutItem;
    dfPathFoldersInitFrame1: TdfPathFoldersInitFrame;
    DecisionOptionsGroup: TdxLayoutGroup;
    item_dfActions: TdxLayoutItem;
    ActionsFrame: TdfPathFoldersActionsFrame;
    dxLayoutItem5: TdxLayoutItem;
    dfPathFoldersDecisionFrame1: TdfPathFoldersDecisionFrame;
    item_Permissions: TdxLayoutItem;
    PermissionsFrame1: TPermissionsFrame;
    vpick_ActiveLayout: TcxButtonEdit;
    item_ActiveLayout: TdxLayoutItem;
    vpick_AppDialogsLayoutIdApply: TcxButtonEdit;
    item_AppDialogsLayoutIdApply: TdxLayoutItem;
    Group_All: TdxLayoutGroup;
    dxLayoutAutoCreatedGroup1: TdxLayoutAutoCreatedGroup;
    grp_User: TdxLayoutGroup;
    dxLayoutAutoCreatedGroup4: TdxLayoutAutoCreatedGroup;
    memoDesc: TcxMemo;
    item_Desc: TdxLayoutItem;
    dxLayoutItem8: TdxLayoutItem;
    ShapeFrame: TShapePropertiesFrame;
    procedure ddFolderTypePropertiesChange(Sender: TObject);
    procedure bnImageIndexClick(Sender: TObject);
    procedure cbAllowEditClick(Sender: TObject);
    procedure cbActiveClick(Sender: TObject);
    procedure ddCodeNamePropertiesChange(Sender: TObject);
  private
    FdfActionsDataSets:TxDataSet;
    FRulesDataSet:TxDataSet;
    FDfClasses:TxDataSet;
    FFolder: TMiceFlowObject;
    FDfClassesId: Integer;
    function IsddApplyEnabled:Boolean;
    function IsTab4Enabled:Boolean;
    procedure SetFolder(const Value: TMiceFlowObject);
    procedure SetActivity(Value:Boolean);
    procedure FolderTypeChanged(FolderType:Integer);
  protected
    procedure DoApplyUpdates; override;
    function GetFolderFontStyle:TFontStyles;
    function SetFolderFontStyle(IntStyle:Integer):TFontStyle;
  public
    procedure PopulateShapeFrame;
    procedure SaveFolder;
    procedure SynchronizeTree(ItemInserted:Boolean); override;
    procedure Initialize; override;
    property Folder:TMiceFlowObject read FFolder write SetFolder;
    property DfClassesId:Integer read FDfClassesId write FDfClassesId;
    constructor Create(AOwner:TComponent);override;
    destructor Destroy; override;
  end;


implementation

{$R *.dfm}

{ TManagerEditorDpPathFolder }

procedure TManagerEditorDfPathFolder.bnImageIndexClick(Sender: TObject);
var
 AIndex:Integer;
begin
 AIndex:=DataSet.FieldByName('ImageIndex').AsInteger;
 if TSelectImageDialog.Execute(AIndex) then
  begin
   DataSet.FieldByName('ImageIndex').AsInteger:=AIndex;
   bnImageIndex.OptionsImage.ImageIndex:=AIndex;
  end;
end;

procedure TManagerEditorDfPathFolder.cbActiveClick(Sender: TObject);
begin
 SetActivity(cbActive.Checked);
end;

procedure TManagerEditorDfPathFolder.cbAllowEditClick(Sender: TObject);
begin
 item_ddApplyMethod.Enabled:=cbAllowEdit.Checked;
end;

constructor TManagerEditorDfPathFolder.Create(AOwner: TComponent);
begin
  inherited;
  TableName:='dfPathFolders';
  KeyField:='dfPathFoldersId';
  AppMainTreeDescriptionField:='Caption';
  ImageIndex:= IMAGEINDEX_ITYPE_DFPATHFOLDER;
  iType:=iTypeDfPathFolder;
  ImageContainer.LoadToImage(Image1, ImageIndex);

  RulesFrame.DataSource:=AddDetailTable('dfPathFolderRules','','','TManagerEditorDfPathFolder.Create',sq_dfPathFolderRules,SeqDb);
  FRulesDataSet:=(RulesFrame.DataSource.DataSet as TxDataSet);
  FRulesDataSet.SequenceDBName:=ConnectionManager.SequenceServer;

//  ActionsFrame.DataSource:=AddDetailTable('dfPathFoldersActions','spui_dfPathFoldersActionList @dfPathFoldersId=<dfPathFoldersId>','','TManagerEditorDfPathFolder.Create','','');
  ActionsFrame.DataSource:=AddDetailTable('dfPathFolderActions','','','TManagerEditorDfPathFolder.Create',sq_dfPathFolderActions,SeqDb);

  FdfActionsDataSets:=ActionsFrame.DataSource.DataSet as TxDataSet;

  FDfClasses:=AddDetailTable('dfClasses','spui_dfClassInfo @dfClassesId=<dfClassesId>','','TManagerEditorDfPathFolder.Create','','').DataSet as TxDataSet;

  ParamsMapper.AddSource(ActionsFrame.DataSource.DataSet,'dfPathFoldersActions');
  ParamsMapper.AddSource(FDfClasses,'dfClasses');

  vpick_ActiveLayout.DataSource:=MainSource;
  vpick_ActiveLayout.DataField:='AppDialogsLayoutIdEdit';
  vpick_ActiveLayout.AppObject.Properties.ProviderName:='spui_AppDialogLayoutList @AppDialogsId=<dfClasses.AppDialogsId>';
  vpick_ActiveLayout.Settings.DialogProviderName:='spui_AppDialogLayoutList @AppDialogsId=<dfClasses.AppDialogsId>, @AppDialogsLayoutId=NULL';
  vpick_ActiveLayout.Settings.DialogType:=1;
  vpick_ActiveLayout.Settings.CaptionField:='Description';
  vpick_ActiveLayout.Settings.KeyField:='AppDialogsLayoutId';
  vpick_ActiveLayout.ClearButtonEnabled:=True;


  vpick_AppDialogsLayoutIdApply.DataSource:=MainSource;
  vpick_AppDialogsLayoutIdApply.DataField:='AppDialogsLayoutIdApply';
  vpick_AppDialogsLayoutIdApply.AppObject.Properties.ProviderName:='spui_AppDialogLayoutList @AppDialogsId=<dfClasses.AppDialogsId>';
  vpick_AppDialogsLayoutIdApply.Settings.DialogProviderName:='spui_AppDialogLayoutList @AppDialogsId=<dfClasses.AppDialogsId>, @AppDialogsLayoutId=NULL';
  vpick_AppDialogsLayoutIdApply.Settings.DialogType:=1;
  vpick_AppDialogsLayoutIdApply.Settings.CaptionField:='Description';
  vpick_AppDialogsLayoutIdApply.Settings.KeyField:='AppDialogsLayoutId';
  vpick_AppDialogsLayoutIdApply.ClearButtonEnabled:=True;
end;

procedure TManagerEditorDfPathFolder.ddCodeNamePropertiesChange(Sender: TObject);
begin
 Folder.CodeName:=ddCodeName.Text;
end;

procedure TManagerEditorDfPathFolder.ddFolderTypePropertiesChange(Sender: TObject);
begin
 Tab4.Enabled:=IsTab4Enabled;
 memoDesc.Text:=TMiceShapesGalleryCollection.DefaultInstance[ddFolderType.EditValue].DevDescription;
 if Initialized then
  FolderTypeChanged(ddFolderType.EditValue)
end;

destructor TManagerEditorDfPathFolder.Destroy;
begin

  inherited;
end;

procedure TManagerEditorDfPathFolder.DoApplyUpdates;
begin
  inherited;
   Folder.Text:=DataSet.FieldByName('Caption').AsString;
   Folder.Caption:=DataSet.FieldByName('Caption').AsString;
   Folder.CodeName:=DataSet.FieldByName('CodeName').AsString;
end;

procedure TManagerEditorDfPathFolder.FolderTypeChanged(FolderType: Integer);
var
 Entry:TMiceGalleryShapeEntry;
begin
 Entry:=TMiceShapesGalleryCollection.DefaultInstance[FolderType];
 ShapeFrame.EntryChanged(Entry);
end;

function TManagerEditorDfPathFolder.GetFolderFontStyle: TFontStyles;
begin
 Result:=[];
// if cbBold.Checked then Result:=(Result+[fsBold]);
// if cbItalicFont.Checked then Result:=(Result + [fsItalic]);
// if cbUnderLined.Checked then Result:=(Result + [fsUnderline]);
end;

procedure TManagerEditorDfPathFolder.Initialize;
begin

  vpick_ActiveLayout.DBName:='Meta';
  vpick_AppDialogsLayoutIdApply.DBName:='Meta';
  FRulesDataSet.DBName:=Self.DBName;
  FDfClasses.DBName:=Self.DBName;
  FdfActionsDataSets.DBName:=Self.DBName;
  ActionsFrame.DBName:=Self.DBName;
  ActionsFrame.dfPathFoldersId:=ID;


  inherited;

  bnImageIndex.OptionsImage.ImageIndex:=DataSet.FieldByName('ImageIndex').AsInteger;
  SetFolderFontStyle(DataSet.FieldByName('FontStyle').AsInteger);
  SetActivity(DataSet.FieldByName('Active').AsBoolean);

  FDfClasses.Open;
end;


function TManagerEditorDfPathFolder.IsddApplyEnabled: Boolean;
begin
 Result:=self.cbAllowEdit.Checked;
end;

function TManagerEditorDfPathFolder.IsTab4Enabled: Boolean;
begin
 Result:=ddFolderType.EditingValue=FolderTypeDecision;
end;

procedure TManagerEditorDfPathFolder.PopulateShapeFrame;
begin
  ShapeFrame.PopulateForPathFolder;
  ShapeFrame.ddShapeStyle.Properties.Images:=Self.ddFolderType.Properties.Images;
end;

procedure TManagerEditorDfPathFolder.SaveFolder;
begin
 Self.ShapeFrame.SaveToMiceFlowObject(Folder);
end;

procedure TManagerEditorDfPathFolder.SetActivity(Value: Boolean);
begin
 Group_All.Enabled:=Value;
 Tab4.Enabled:=Value and IsTab4Enabled;
 item_ddApplyMethod.Enabled:=Value and IsddApplyEnabled;
end;

procedure TManagerEditorDfPathFolder.SetFolder(const Value: TMiceFlowObject);
begin
 if Value<>FFolder then
  begin
   FFolder := Value;
   ShapeFrame.LoadFromMiceFlowObject(Folder);
  end;
end;

function TManagerEditorDfPathFolder.SetFolderFontStyle(IntStyle: Integer): TFontStyle;
begin
  Result:=TFontStyle(IntStyle);
//  cbBold.Checked:= (Result in [fsBold]);
//  cbItalicFont.Checked :=(Result in [fsItalic]);
//  cbUnderLined.Checked:=(Result in [fsUnderline]);
end;

procedure TManagerEditorDfPathFolder.SynchronizeTree(ItemInserted: Boolean);
begin
 //DoNothing
end;

initialization
  TWindowManager.RegisterEditor(iTypeDfPathFolder,nil,TManagerEditorDfPathFolder, False);
finalization


end.
