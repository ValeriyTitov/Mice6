unit ManagerEditor.Plugin;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, cxGraphics,
  cxLookAndFeels, cxLookAndFeelPainters, Vcl.Menus, Data.DB, Vcl.StdCtrls,
  cxButtons, Vcl.ExtCtrls, cxControls, cxClasses, dxLayoutContainer,
  dxLayoutControl, dxLayoutLookAndFeels,cxContainer, cxEdit, dxLayoutcxEditAdapters,
  cxTextEdit, cxMemo, cxDBEdit, cxMaskEdit, cxDropDownEdit, cxImageComboBox,
  cxButtonEdit, cxCheckBox,
  Manager.WindowManager,
  DAC.DataBaseUtils,
  DAC.XDataSet,
  DAC.ConnectionMngr,
  Common.Images,
  Common.LookAndFeel,
  ManagerEditor.Common,
  StaticDialog.AppObjectSelector,
  CustomControl.MiceGrid.ColumnEditor,
  CustomControl.MiceGrid.ColorEditor,
  CustomControl.MiceValuePicker,
  cxSpinEdit, Vcl.Buttons, dxLayoutControlAdapters;

type
  TcxButtonEdit = class (TMiceValuePicker)

  end;

  TManagerEditorPlugin = class(TCommonManagerDialog)
    edPluginName: TcxDBTextEdit;
    dxLayoutItem1: TdxLayoutItem;
    memoDescription: TcxDBMemo;
    dxLayoutItem3: TdxLayoutItem;
    cbPluginType: TcxDBImageComboBox;
    dxLayoutItem2: TdxLayoutItem;
    edAppPluginsId: TcxDBTextEdit;
    item_edAppPluginsId: TdxLayoutItem;
    Tab0: TdxLayoutGroup;
    item_Providers: TdxLayoutGroup;
    Tab1: TdxLayoutGroup;
    dxLayoutGroup4: TdxLayoutGroup;
    cbDialogIdField: TcxDBComboBox;
    dxLayoutItem6: TdxLayoutItem;
    edKeyField: TcxDBTextEdit;
    dxLayoutItem7: TdxLayoutItem;
    item_DataFields: TdxLayoutGroup;
    edImageIndexField: TcxDBTextEdit;
    dxLayoutItem8: TdxLayoutItem;
    edSummuryField: TcxDBTextEdit;
    dxLayoutItem10: TdxLayoutItem;
    Tab2: TdxLayoutGroup;
    edProviderName: TcxDBButtonEdit;
    dxLayoutItem11: TdxLayoutItem;
    edDelProviderName: TcxDBButtonEdit;
    dxLayoutItem12: TdxLayoutItem;
    edBGColorField: TcxDBComboBox;
    dxLayoutItem14: TdxLayoutItem;
    edFontColorField: TcxDBComboBox;
    dxLayoutItem15: TdxLayoutItem;
    edFontStyleField: TcxDBComboBox;
    dxLayoutItem16: TdxLayoutItem;
    dxLayoutGroup7: TdxLayoutGroup;
    cbAutoWidth: TcxDBCheckBox;
    dxLayoutItem18: TdxLayoutItem;
    cbSorting: TcxDBCheckBox;
    dxLayoutItem19: TdxLayoutItem;
    cbGroupByPanel: TcxDBCheckBox;
    dxLayoutItem20: TdxLayoutItem;
    dxLayoutGroup8: TdxLayoutGroup;
    Tab3: TdxLayoutGroup;
    Image1: TImage;
    dxLayoutItem22: TdxLayoutItem;
    dxLayoutSeparatorItem1: TdxLayoutSeparatorItem;
    dxLayoutAutoCreatedGroup2: TdxLayoutAutoCreatedGroup;
    Label2: TLabel;
    dxLayoutItem23: TdxLayoutItem;
    dxLayoutGroup1: TdxLayoutGroup;
    cbShowDocClasses: TcxDBCheckBox;
    dxLayoutItem17: TdxLayoutItem;
    cbDocFlow: TcxDBCheckBox;
    dxLayoutItem25: TdxLayoutItem;
    cbShowDocFolders: TcxDBCheckBox;
    dxLayoutItem26: TdxLayoutItem;
    dxLayoutItem21: TdxLayoutItem;
    ColumnEditor: TColumnEditorFrame;
    dsDialogs: TDataSource;
    edParentIdField: TcxDBTextEdit;
    edParentIdField_Item: TdxLayoutItem;
    dxLayoutAutoCreatedGroup1: TdxLayoutAutoCreatedGroup;
    cbPluginDBName: TcxDBComboBox;
    item_DBName: TdxLayoutItem;
    Tab4: TdxLayoutGroup;
    cbSideTreeEnabled: TcxDBCheckBox;
    dxLayoutItem9: TdxLayoutItem;
    edTreeKeyField: TcxDBTextEdit;
    edTreeKeyField_Item: TdxLayoutItem;
    edTreeProviderName: TcxDBButtonEdit;
    edTreeProviderName_Item: TdxLayoutItem;
    edFilterParamName: TcxDBTextEdit;
    dxLayoutItem28: TdxLayoutItem;
    edTreeParentIdField: TcxDBTextEdit;
    edTreeParentIdField_Item: TdxLayoutItem;
    dxLayoutItem13: TdxLayoutItem;
    ColorsEditor: TMiceGridColorEditorFrame;
    spinSideTreeExpandLevel: TcxDBSpinEdit;
    item_SideTreeExpandLevel: TdxLayoutItem;
    dxLayoutGroup6: TdxLayoutGroup;
    bnDefAppCmdId: TcxButtonEdit;
    dxLayoutItem27: TdxLayoutItem;
    edCustomDialogId: TcxButtonEdit;
    dxLayoutItem5: TdxLayoutItem;
    edAppPluginsIdPage: TcxTextEdit;
    item_SideTreeAppPluginsId: TdxLayoutItem;
    edSideTreeCaptionField: TcxDBTextEdit;
    item_SideTreeCaptionField: TdxLayoutItem;
    cbRefreshAfterCreate: TcxDBCheckBox;
    dxLayoutItem29: TdxLayoutItem;
    edCustomLayoutsIdField: TcxDBTextEdit;
    dxLayoutItem30: TdxLayoutItem;
    Group_SideTree: TdxLayoutGroup;
    Tab5: TdxLayoutGroup;
    bnEditScript: TcxButton;
    item_bnEditScript: TdxLayoutItem;
    eddfClassesId: TcxDBTextEdit;
    item_eddfClassesId: TdxLayoutItem;
    dxLayoutAutoCreatedGroup4: TdxLayoutAutoCreatedGroup;
    procedure edCustomDialogIDPropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
    procedure edProviderNamePropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
    procedure edDelProviderNamePropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
    procedure cbDocFlowClick(Sender: TObject);
    procedure cbSideTreeEnabledClick(Sender: TObject);
    procedure edTreeProviderNamePropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
    procedure cbPluginTypePropertiesChange(Sender: TObject);
    procedure miCopyFromClick(Sender: TObject);
    procedure bnEditScriptClick(Sender: TObject);
  private
    FDialogsDataSet:TxDataSet;
    FSideTreeEnabled: Boolean;
    FOnEditScript: TNotifyEvent;
    function GetPluginDBName: string;
    function GetAppScriptsId: Integer;
    procedure SetPluginDBName(const Value: string);
    procedure SetSideTreeEnabled(const Value: Boolean);
    procedure DoEditScript;
    procedure SetAppScriptsId(const Value: Integer);
  protected
    procedure FieldChanged(Field:TField);
    procedure DoAfterOpen(DataSet:TDataSet);override;
    procedure AssignFieldChange(DataSet:TDataSet);
    procedure EnterInsertingState; override;
    procedure EnterEditingState; override;
    procedure UpdateDocFlowControls(Value:Boolean);
    procedure SetMultiPluginVisibility;
    procedure SetStandartPluginVisibility;
    procedure SetPagePluginVisibility;
  public
    property PluginDBName:string read GetPluginDBName write SetPluginDBName;
    property SideTreeEnabled:Boolean read FSideTreeEnabled write SetSideTreeEnabled;
    property OnEditScript:TNotifyEvent read FOnEditScript write FOnEditScript;
    property AppScriptsId:Integer read GetAppScriptsId write SetAppScriptsId;
    procedure Initialize; override;
    constructor Create(AOwner:TComponent); override;
  end;

implementation

{$R *.dfm}

const
 PluginTypeGrid=0;
 PluginTypeTreeGrid=1;
 PluginTypePivotGrid=2;
 PluginTypeChart=3;
 PluginTypeMultiPage=4;
 PluginTypePage=5;

{ TTManagerPluginEditor }

procedure TManagerEditorPlugin.AssignFieldChange(DataSet: TDataSet);
begin
 DataSet.FieldByName('ProviderName').OnChange:=FieldChanged;
 DataSet.FieldByName('DBName').OnChange:=FieldChanged;
 FieldChanged(DataSet.FieldByName('ProviderName'));
end;

procedure TManagerEditorPlugin.bnEditScriptClick(Sender: TObject);
begin
 DoEditScript;
end;

procedure TManagerEditorPlugin.cbDocFlowClick(Sender: TObject);
begin
 UpdateDocFlowControls(cbDocFlow.Checked);
end;

procedure TManagerEditorPlugin.cbPluginTypePropertiesChange(Sender: TObject);
var
 AValue:Integer;
begin
 AValue:=cbPluginType.EditValue;
 case AValue of
   PluginTypeGrid:SetStandartPluginVisibility; //0
   PluginTypeTreeGrid:SetStandartPluginVisibility; //1
   PluginTypeMultiPage: SetMultiPluginVisibility; //4
   PluginTypePage: SetPagePluginVisibility;       //5
    else
     SetStandartPluginVisibility;
 end;
end;

procedure TManagerEditorPlugin.cbSideTreeEnabledClick(Sender: TObject);
begin
 SideTreeEnabled:=cbSideTreeEnabled.Checked;
end;

constructor TManagerEditorPlugin.Create(AOwner: TComponent);
begin
  inherited;
  TImageContainer.LoadToImage(Image1,IMAGEINDEX_HOME);
  TableName:='AppPlugins';
  KeyField:='AppPluginsId';
  ImageIndex:= IMAGEINDEX_ITYPE_PLUGIN;
  iType:=iTypePlugin;
  ColumnEditor.DataSource:=AddDetailTable('AppColumns','','',ClassName+'.ColumnEditor',sq_AppColumns,SeqDb);
  ColorsEditor.DataSource:=AddDetailTable('AppGridColors','','',ClassName+'.ColorsEditor',sq_AppGridColors, SeqDb);

  (ColumnEditor.DataSource.DataSet as TxDataSet).SequenceDBName:=ConnectionManager.SequenceServer;
  (ColorsEditor.DataSource.DataSet as TxDataSet).SequenceDBName:=ConnectionManager.SequenceServer;


  AppMainTreeDescriptionField:='Name';
  FDialogsDataSet:=TxDataSet.Create(Self);
  FDialogsDataSet.ProviderName:='spui_AppObjectList';
  FDialogsDataSet.SetParameter('iType',3);



  dsDialogs.DataSet:=FDialogsDataSet;
  ColorsEditor.MainView.OnCustomDrawCell:=ColorsEditor.MainViewCustomDrawCell;

  bnDefAppCmdId.DataSource:=Self.MainSource;
  bnDefAppCmdId.DataField:='DefaultAppCmdId';
  bnDefAppCmdId.AppObject.Properties.ProviderName:='spui_AppGetPluginCommandsMngr @AppPluginsId=<AppPluginsId>, @AppCmdId=<DefaultAppCmdId>';
  bnDefAppCmdId.Settings.DialogProviderName:='spui_AppGetPluginCommandsMngr @AppPluginsId=<AppPluginsId>, @AppCmdId=NULL';
  bnDefAppCmdId.Settings.KeyField:='AppCmdId';
  bnDefAppCmdId.ClearButtonEnabled:=True;
  bnDefAppCmdId.Settings.DialogType:=1;


  edCustomDialogID.DataSource:=Self.MainSource;
  edCustomDialogID.DataField:='AppDialogsId';
  edCustomDialogID.AppObject.Properties.ProviderName:='spui_AppDialogGetProperties @AppDialogsId=<AppDialogsId>';
  edCustomDialogID.Settings.KeyField:='AppDialogsId';
  edCustomDialogID.Settings.CaptionField:='Caption';
  edCustomDialogID.ClearButtonEnabled:=True;
{
  edDfClassesId.DataSource:=MainSource;
  edDfClassesId.Settings.DialogType:=1;
  edDfClassesId.DataField:='DfClassesId';
  edDfClassesId.AppObject.Properties.ProviderName:='spui_dfClassInfo @DfClassesId=<dfClassesId>';
  edDfClassesId.Settings.DialogProviderName:='spui_AppdfClassList';
  edDfClassesId.Settings.KeyField:='dfClassesId';
  edDfClassesId.Settings.CaptionField:='Caption';
  edDfClassesId.ClearButtonEnabled:=False;
}

  ConnectionManager.PopulateDBNames(cbPluginDBName.Properties.Items);
end;



procedure TManagerEditorPlugin.DoAfterOpen(DataSet: TDataSet);
begin
  inherited;
  Self.AssignFieldChange(DataSet);
end;

procedure TManagerEditorPlugin.DoEditScript;
begin
 if Assigned(OnEditScript) then
  OnEditScript(Self);
end;

procedure TManagerEditorPlugin.edCustomDialogIDPropertiesButtonClick(Sender: TObject; AButtonIndex: Integer);
var
 ID:integer;
 s:string;
begin
if AbuttonIndex=0 then
 begin
  if TAppObjectSelectionDialog.ExecuteDialog(iTypeDialog,ID,s) then
   DataSet.FieldByName('AppDialogsId').AsInteger:=ID;
 end
  else
   edCustomDialogID.ClearField;
end;

procedure TManagerEditorPlugin.edDelProviderNamePropertiesButtonClick(Sender: TObject; AButtonIndex: Integer);
var
 ID:integer;
 s:string;
begin
 if TSysObjectSelectionDialog.ExecuteDialog(iTypeStoredProc,ID,s, PluginDBName) then
  DataSet.FieldByName('DelProviderName').AsString:=s;
end;

procedure TManagerEditorPlugin.edProviderNamePropertiesButtonClick(Sender: TObject; AButtonIndex: Integer);
var
 ID:integer;
 s:string;
begin
 if TSysObjectSelectionDialog.ExecuteDialog(iTypeStoredProc,ID,s, PluginDBName) then
  DataSet.FieldByName('ProviderName').AsString:=s;
end;

procedure TManagerEditorPlugin.edTreeProviderNamePropertiesButtonClick(Sender: TObject; AButtonIndex: Integer);
var
 ID:integer;
 s:string;
begin
 if TSysObjectSelectionDialog.ExecuteDialog(iTypeStoredProc,ID,s, PluginDBName) then
  DataSet.FieldByName('SideTreeProviderName').AsString:=s;
end;

procedure TManagerEditorPlugin.EnterEditingState;
begin
  inherited;
  edAppPluginsId.Enabled:=False;
  UpdateDocFlowControls( cbDocFlow.Checked);
  SideTreeEnabled:=cbSideTreeEnabled.Checked;
end;

procedure TManagerEditorPlugin.EnterInsertingState;
begin
 inherited;
 DataSet.FieldByName('AppPluginsId').AsInteger:=TDataBaseUtils.NewAppObjectId(sq_AppPlugins);
 DataSet.FieldByName('PluginType').AsInteger:=0;
 DataSet.FieldByName('Name').AsString:='New plugin'+' '+DataSet.FieldByName('AppPluginsId').AsString;
 DataSet.FieldByName('DocFlow').AsBoolean:=False;
 DataSet.FieldByName('Sorting').AsBoolean:=True;
 DataSet.FieldByName('GroupByPanel').AsBoolean:=False;
 DataSet.FieldByName('AutoWidth').AsBoolean:=True;
 DataSet.FieldByName('SideTreeEnabled').AsBoolean:=False;
 DataSet.FieldByName('RefreshAfterCreate').AsBoolean:=True;
 SideTreeEnabled:=cbSideTreeEnabled.Checked;

 cbDocFlow.Checked:=False;
 bnEditScript.Enabled:=False;
end;

procedure TManagerEditorPlugin.FieldChanged(Field: TField);
begin
 ColumnEditor.ProviderName:=DataSet.FieldByName('ProviderName').AsString;
 ColumnEditor.DBName:=DataSet.FieldByName('DBName').AsString;
end;

function TManagerEditorPlugin.GetAppScriptsId:Integer;
begin
 Result:=DataSet.FieldByName('AppScriptsId').AsInteger;
end;

function TManagerEditorPlugin.GetPluginDBName: string;
begin
 Result:=cbPluginDBName.Text;
end;

procedure TManagerEditorPlugin.Initialize;
begin
  inherited;
end;

procedure TManagerEditorPlugin.miCopyFromClick(Sender: TObject);
var
 x:Integer;
 s:string;
 Dlg:TManagerEditorPlugin;
begin
 if TAppObjectSelectionDialog.ExecuteDialog(iTypePlugin,x,s) then
  begin
   Dlg:=TManagerEditorPlugin.Create(nil);
    try
     LazyInitAll;
     Dlg.ID:=x;
     Dlg.Initialize;
     Dlg.LazyInitAll;
     CopyFrom(Dlg, True);
    finally
     Dlg.Free;
   end;
  end;
end;

procedure TManagerEditorPlugin.SetPluginDBName(const Value: string);
begin
 cbPluginDBName.Text:=Value;
end;

procedure TManagerEditorPlugin.SetSideTreeEnabled(const Value: Boolean);
begin
  FSideTreeEnabled := Value;
  Self.Group_SideTree.Enabled:=Value;
end;

procedure TManagerEditorPlugin.SetStandartPluginVisibility;
begin
 Tab1.Enabled:=True;
 Tab2.Enabled:=True;
 Tab3.Enabled:=True;
 Tab4.Enabled:=True;
 item_SideTreeAppPluginsId.Visible:=False;
end;


procedure TManagerEditorPlugin.SetAppScriptsId(const Value: Integer);
begin
 DataSet.FieldByName('RunAppScriptsId').AsInteger:=Value;
end;

procedure TManagerEditorPlugin.SetMultiPluginVisibility;
begin
 Tab1.Enabled:=False;
 Tab2.Enabled:=False;
 Tab3.Enabled:=False;
 Tab4.Enabled:=True;
 item_SideTreeAppPluginsId.Visible:=True;
end;

procedure TManagerEditorPlugin.SetPagePluginVisibility;
begin
 Tab1.Enabled:=True;
 Tab2.Enabled:=False;
 Tab3.Enabled:=False;
 Tab4.Enabled:=False;
end;



procedure TManagerEditorPlugin.UpdateDocFlowControls(Value: Boolean);
begin
 cbShowDocClasses.Enabled:=Value;
 cbShowDocFolders.Enabled:=Value;
 edDfClassesId.Enabled:=Value;
end;

initialization
  TWindowManager.RegisterEditor(iTypePlugin,nil,TManagerEditorPlugin, False);
finalization

end.
