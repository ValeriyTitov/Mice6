unit ManagerEditor.AppDialog;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, ManagerEditor.Common, cxGraphics,
  cxLookAndFeels, cxLookAndFeelPainters, Vcl.Menus, cxControls, Data.DB,
  cxClasses, dxLayoutContainer, dxLayoutControl, Vcl.StdCtrls, cxButtons,
  Vcl.ExtCtrls,dxLayoutControlAdapters, cxContainer, cxEdit, dxLayoutcxEditAdapters, cxMemo, cxDBEdit,
  cxTextEdit, cxMaskEdit, cxButtonEdit, cxStyles, cxCustomData, cxFilter,
  cxData, cxDataStorage, cxNavigator, cxDBData, cxCheckBox, cxDropDownEdit,
  cxImageComboBox, cxGridLevel, cxGridCustomTableView, cxGridTableView,
  cxGridBandedTableView, cxGridDBBandedTableView, cxGridCustomView, cxGrid,
  Manager.WindowManager,
  DAC.DatabaseUtils,
  DAC.xDataSet,
  DAC.ConnectionMngr,
  Common.Images,
  Common.ResourceStrings,
  CustomControl.MiceGrid,
  CustomControl.MiceAction,
  CustomControl.MiceActionList,
  ControlEditor.Common,
  Dialog.Layout.ControlList,
  StaticDialog.CheckBoxItemSelector,
  Dialog.Layout.ControlList.SelectorDialog,
  ManagerEditor.AppDialog.DetailDataSetProperties,
  StaticDialog.AppObjectSelector,
  cxDataControllerConditionalFormattingRulesManagerDialog, dxDateRanges,
  Vcl.Buttons, dxScrollbarAnnotations;

type
  TcxGrid = class (TMiceGrid)

  end;
  TManagerEditorAppDialog = class(TCommonManagerDialog)
    Tab0: TdxLayoutGroup;
    Tab1: TdxLayoutGroup;
    Tab2: TdxLayoutGroup;
    Tab3: TdxLayoutGroup;
    edCaption: TcxDBTextEdit;
    dxLayoutItem2: TdxLayoutItem;
    dxLayoutGroup1: TdxLayoutGroup;
    edKeyfield: TcxDBTextEdit;
    dxLayoutItem4: TdxLayoutItem;
    memDescription: TcxDBMemo;
    dxLayoutItem7: TdxLayoutItem;
    Image1: TImage;
    dxLayoutItem8: TdxLayoutItem;
    Label1: TLabel;
    dxLayoutItem9: TdxLayoutItem;
    dxLayoutAutoCreatedGroup1: TdxLayoutAutoCreatedGroup;
    gridDetails: TcxGrid;
    DetailsView: TcxGridDBBandedTableView;
    gridDetailsLevel1: TcxGridLevel;
    dxLayoutItem6: TdxLayoutItem;
    dxLayoutGroup2: TdxLayoutGroup;
    edTableName: TcxDBButtonEdit;
    dxLayoutItem3: TdxLayoutItem;
    edValidateSP: TcxDBButtonEdit;
    dxLayoutItem5: TdxLayoutItem;
    edUpdateSP: TcxDBButtonEdit;
    dxLayoutItem11: TdxLayoutItem;
    colDetailsTableName: TcxGridDBBandedColumn;
    colDetailsProviderName: TcxGridDBBandedColumn;
    colDetailsReadOnly: TcxGridDBBandedColumn;
    edAppDialogsId: TcxDBTextEdit;
    gridControls: TcxGrid;
    ControlsView: TcxGridDBBandedTableView;
    colClassName: TcxGridDBBandedColumn;
    colName: TcxGridDBBandedColumn;
    colCaption: TcxGridDBBandedColumn;
    cxGridLevel1: TcxGridLevel;
    dxLayoutItem12: TdxLayoutItem;
    dxLayoutSeparatorItem1: TdxLayoutSeparatorItem;
    colDetailsDBName: TcxGridDBBandedColumn;
    dxLayoutGroup3: TdxLayoutGroup;
    Image2: TImage;
    dxLayoutItem14: TdxLayoutItem;
    Label2: TLabel;
    dxLayoutItem15: TdxLayoutItem;
    dxLayoutAutoCreatedGroup3: TdxLayoutAutoCreatedGroup;
    bnControlAdd: TcxButton;
    dxLayoutItem16: TdxLayoutItem;
    bnControlEdit: TcxButton;
    dxLayoutItem13: TdxLayoutItem;
    bnControlDelete: TcxButton;
    dxLayoutItem17: TdxLayoutItem;
    bnControlChangeType: TcxButton;
    dxLayoutItem18: TdxLayoutItem;
    bnAutoFill: TcxButton;
    dxLayoutItem19: TdxLayoutItem;
    cbDBName: TcxDBComboBox;
    dxLayoutItem20: TdxLayoutItem;
    dxLayoutAutoCreatedGroup4: TdxLayoutAutoCreatedGroup;
    Tab4: TdxLayoutGroup;
    PopupMenu1: TPopupMenu;
    Add1: TMenuItem;
    Delete1: TMenuItem;
    colDataField: TcxGridDBBandedColumn;
    edSequenceName: TcxDBButtonEdit;
    item_Sequence: TdxLayoutItem;
    colDetailsSequence: TcxGridDBBandedColumn;
    item_edAppDialogsId: TdxLayoutItem;
    colMore: TcxGridDBBandedColumn;
    cbSeqenceDBName: TcxDBComboBox;
    dxLayoutItem10: TdxLayoutItem;
    dxLayoutAutoCreatedGroup5: TdxLayoutAutoCreatedGroup;
    dxLayoutAutoCreatedGroup6: TdxLayoutAutoCreatedGroup;
    procedure bnAutoFillClick(Sender: TObject);
    procedure ControlsViewCustomDrawCell(Sender: TcxCustomGridTableView;
      ACanvas: TcxCanvas; AViewInfo: TcxGridTableDataCellViewInfo;
      var ADone: Boolean);
    procedure edTableNameExit(Sender: TObject);
    procedure edValidateSPPropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
    procedure edUpdateSPPropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
    procedure edTableNamePropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
    procedure ControlsViewDblClick(Sender: TObject);
    procedure PopupMenu1Popup(Sender: TObject);
    procedure Add1Click(Sender: TObject);
    procedure DetailsViewColumn1PropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
    procedure Delete1Click(Sender: TObject);
    procedure miCopyFromClick(Sender: TObject);
    procedure edSequenceNamePropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
    procedure ButtonEdit(Sender: TObject;
      AButtonIndex: Integer);
    procedure colMorePropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
  strict private
    FActions:TMiceActionList;
    FControlsDataSet:TxDataSet;
    FDetailTables:TxDataSet;
    procedure CreateActions;
    procedure AddControlActionExecute(Sender:TObject);
    procedure EditControlActionExecute(Sender:TObject);
    procedure DeleteControlActionExecute(Sender:TObject);
    procedure ChangeControlTypeActionExecute(Sender:TObject);
    procedure UpdateKeyField(ForceUpdate:Boolean);
    function CheckChanges:Boolean;
    function FindDetailTableDBName(const TableName:string) :string;
    function EditItem(AppDialogControlsId:Integer;const AClassName:string):Boolean;
  private
    procedure SetDialogDBName(const Value: string);
    function GetDialogDBName: string;
  protected
    procedure EnterInsertingState; override;
    procedure EnterEditingState; override;
    procedure AutoFill;
    procedure AutoMultiFill;
    procedure RefreshControlDetails;
  public
    property DialogDBName:string read GetDialogDBName write SetDialogDBName;
    procedure Initialize; override;
    constructor Create(AOwner:TComponent);override;
    destructor Destroy; override;
  end;

implementation

{$R *.dfm}

procedure TManagerEditorAppDialog.Add1Click(Sender: TObject);
begin
if (DataSet.Active) then
 begin
  FDetailTables.Append;
//  FDetailTables.FieldByName('AppDialogDetailTablesId').AsInteger:=TDataBaseUtils.NewAppObjectId(sq_AppDialogDetailTables);
  FDetailTables.FieldByName('ReadOnly').AsBoolean:=False;
 end;

end;

procedure TManagerEditorAppDialog.AddControlActionExecute(Sender: TObject);
var
 s:string;
begin
 if TNewControlSelectorDialog.ExecuteDlg(s) then
  if EditItem(-1,s) then
   RefreshControlDetails;
end;

procedure TManagerEditorAppDialog.AutoFill;
var
 ATableName:string;
 ADBName:string;
begin
 ATableName:=DataSet.FieldByName('TableName').AsString;
 ADBName:=DataSet.FieldByName('DBName').AsString;
 TDialogLayoutControlList.DefaultInstance.FindControlsForTable(ATableName, ADBName, FControlsDataSet, False);
end;

procedure TManagerEditorAppDialog.AutoMultiFill;
var
 List:TStringList;
 ATableName:string;
 ADBName:string;
 x:Integer;
 B:TBookMark;
begin
 List:=TStringList.Create;
 B:=FDetailTables.Bookmark;
 FDetailTables.DisableControls;
 try
  ATableName:=DataSet.FieldByName('TableName').AsString;
  if (TCheckBoxItemSelector.ExecuteTableSelectDlg(FDetailTables, List, ATableName, Self)) and (List.Count>0) then
   for x:=0 to List.Count-1 do
    begin
     ATableName:=List[x];
     ADBName:=FindDetailTableDBName(ATableName);
     TDialogLayoutControlList.DefaultInstance.FindControlsForTable(ATableName, ADBName, FControlsDataSet,ATableName<>DataSet.FieldByName('TableName').AsString);
    end;
 finally
  List.Free;
  FDetailTables.Bookmark:=B;
  FDetailTables.EnableControls;
 end;
end;

procedure TManagerEditorAppDialog.bnAutoFillClick(Sender: TObject);
begin
if (FDetailTables.Active=False) or (FDetailTables.RecordCount=0) then
 AutoFill
  else
 AutoMultiFill;
end;

procedure TManagerEditorAppDialog.ChangeControlTypeActionExecute(Sender: TObject);
var
 s:string;
begin
 if TNewControlSelectorDialog.ExecuteDlg(s) then
  begin
   FControlsDataSet.Edit;
   FControlsDataSet.FieldByName('ClassName').AsString:=s;
   FControlsDataSet.FieldByName('ControlName').AsString:=TDialogLayoutControlList.CreateControlName(FControlsDataSet.FieldByName('Datafield').AsString,s);
   FControlsDataSet.Post;
  end;
end;


function TManagerEditorAppDialog.CheckChanges: Boolean;
var
 DataSet:TxDataSet;
begin
 DataSet:=FControlsDataSet as TxDataSet;
 Result:=(DataSet.ChangeCount<=0);
 if (Result=False) then
  begin
   Result:=(MessageBox(Handle, PChar(S_COMMON_SAVECHANGES_Q),PChar(S_COMMON_CHANGES_MUST_BE_SAVED), MB_YESNO+MB_ICONQUESTION)=ID_YES);
    if Result then
     DetailDataSets.ApplyUpdates('AppDialogControls');
  end;
end;

procedure TManagerEditorAppDialog.colMorePropertiesButtonClick(Sender: TObject; AButtonIndex: Integer);
begin
 TDetailsDataSetPropertiesDlg.ClassExecute(FDetailTables);
end;

procedure TManagerEditorAppDialog.ControlsViewCustomDrawCell(
  Sender: TcxCustomGridTableView; ACanvas: TcxCanvas;
  AViewInfo: TcxGridTableDataCellViewInfo; var ADone: Boolean);
begin
  if AViewInfo.GridRecord.Selected then
    begin
      ACanvas.Font.Color:=clBlack;
      ACanvas.Brush.Color:=$E5E5E5;
    end;
   if AViewInfo.Focused and AViewInfo.GridRecord.Focused then
      ACanvas.Brush.Color:=clSilver;
end;

procedure TManagerEditorAppDialog.ControlsViewDblClick(Sender: TObject);
begin
 if ControlsView.Controller.SelectedRecordCount>0 then
  bnControlEdit.Action.Execute;
end;

constructor TManagerEditorAppDialog.Create(AOwner: TComponent);
begin
  inherited;
  FActions:=TMiceActionList.Create;
  TImageContainer.LoadToImage(Image1,IMAGEINDEX_ITYPE_DIALOG);
  TImageContainer.LoadToImage(Image2,612);
  TableName:='AppDialogs';
  KeyField:='AppDialogsId';
  AppMainTreeDescriptionField:='Caption';
  ImageIndex:= IMAGEINDEX_ITYPE_DIALOG;
  iType:=iTypeDialog;
  DetailsView.DataController.DataSource:=AddDetailTable('AppDialogDetailTables','','',ClassName+'.DetailTablesGrid',sq_AppDialogDetailTables,'');
  FDetailTables:=DetailsView.DataController.DataSource.DataSet as TxDataSet;
  ControlsView.DataController.DataSource:=AddDetailTable('AppDialogControls','','',ClassName+'.ControlTablesGrid',sq_AppDialogControls,'');
  FControlsDataSet:=ControlsView.DataController.DataSource.DataSet as TxDataSet;

  FDetailTables.SequenceDBName:=ConnectionManager.SequenceServer;
  FControlsDataSet.SequenceDBName:=ConnectionManager.SequenceServer;


  FActions.DataSource:=ControlsView.DataController.DataSource;
  CreateActions;
  ConnectionManager.PopulateDBNames(cbDBName.Properties.Items);
  ConnectionManager.PopulateDBNames(cbSeqenceDBName.Properties.Items);
  ConnectionManager.PopulateDBNames((colDetailsDBName.Properties as TcxComboBoxProperties).Items);
end;

procedure TManagerEditorAppDialog.CreateActions;
var
 Action:TMiceAction;
begin
 Action:=FActions.CreateAction('AddControl',S_COMMON_ADD,'',IMAGEINDEX_ACTION_ADD,True,AddControlActionExecute,'');
 Action.ActivityCondition.AlwaysEnabled:=True;
 Action.HotKey:='INS';
 bnControlAdd.Action:=Action;

 Action:=FActions.CreateAction('EditControl',S_COMMON_EDIT,'',IMAGEINDEX_ACTION_EDIT,False,EditControlActionExecute,'AppDialogControlsId IS NOT NULL');
 Action.HotKey:='ENTER';
 bnControlEdit.Action:=Action;

 Action:=FActions.CreateAction('DeleteControl',S_COMMON_DELETE,'',IMAGEINDEX_ACTION_DELETE,False,DeleteControlActionExecute,'AppDialogControlsId IS NOT NULL');
 Action.HotKey:='DELETE';
 bnControlDelete.Action:=Action;

 Action:=FActions.CreateAction('ChangeControlType',S_COMMON_CHANGE_TYPE,'',IMAGEINDEX_ACTION_ADD,False,ChangeControlTypeActionExecute,'AppDialogControlsId IS NOT NULL');
 Action.HotKey:='F2';
 bnControlChangeType.Action:=Action;

end;

procedure TManagerEditorAppDialog.Delete1Click(Sender: TObject);
begin
if FDetailTables.Active then
  FDetailTables.Delete;
end;

procedure TManagerEditorAppDialog.DeleteControlActionExecute(Sender: TObject);
begin
 FControlsDataSet.Delete;
end;

destructor TManagerEditorAppDialog.Destroy;
begin
  FActions.Free;
  inherited;
end;

procedure TManagerEditorAppDialog.DetailsViewColumn1PropertiesButtonClick(Sender: TObject; AButtonIndex: Integer);
var
 ID:integer;
 s:string;
begin
 if TSysObjectSelectionDialog.ExecuteDialog(iTypeTableOrViews,ID,s, DialogDBName) then
  begin
   FDetailTables.Edit;
   FDetailTables.FieldByName('TableName').AsString:=s;
  end;
end;

procedure TManagerEditorAppDialog.ButtonEdit(  Sender: TObject; AButtonIndex: Integer);
var
 ID:integer;
 s:string;
begin
 if TSysObjectSelectionDialog.ExecuteDialog(iTypeSequence,ID,s, FDetailTables.FieldByName('DBName').AsString) then
  begin
   FDetailTables.Edit;
   FDetailTables.FieldByName('SequenceName').AsString:=s;
  end;
end;

procedure TManagerEditorAppDialog.EditControlActionExecute(Sender: TObject);
begin
 try
//  FControlsDataSet.DisableControls;
  ControlsView.BeginUpdate;
  if CheckChanges then
   begin
    if EditItem(FControlsDataSet.FieldByName('AppDialogControlsId').AsInteger, FControlsDataSet.FieldByName('ClassName').AsString) then
     RefreshControlDetails;
   end;
 finally
  ControlsView.EndUpdate;
  FControlsDataSet.EnableControls;

 end;
end;

procedure TManagerEditorAppDialog.EnterEditingState;
begin
  inherited;
  edAppDialogsId.Enabled:=False;
end;

procedure TManagerEditorAppDialog.EnterInsertingState;
begin
  inherited;
  DataSet.FieldByName('AppDialogsId').AsInteger:=TDataBaseUtils.NewAppObjectId(sq_AppDialogs);
  DataSet.FieldByName('Caption').AsString:='New dialog'+' '+DataSet.FieldByName('AppDialogsId').AsString;
  Tab1.Visible:=False;
  Tab2.Visible:=False;
  Tab3.Visible:=False;
  Tab4.Visible:=False;
end;

function TManagerEditorAppDialog.FindDetailTableDBName(const TableName: string): string;

begin
 if TableName=DataSet.FieldByName('TableName').AsString then
  Result:=DataSet.FieldByName('DBName').AsString
   else
    begin
     FDetailTables.First;
      if FDetailTables.Locate('TableName',TableName,[loCaseInsensitive]) then
       Result:=FDetailTables.FieldByName('DBName').AsString
        else
       Result:=DataSet.FieldByName('DBName').AsString;
    end;
end;

function TManagerEditorAppDialog.GetDialogDBName: string;
begin
 Result:=cbDBName.Text;
end;

procedure TManagerEditorAppDialog.Initialize;
begin
  inherited;
end;


procedure TManagerEditorAppDialog.miCopyFromClick(Sender: TObject);
var
 x:Integer;
 s:string;
 Dlg:TManagerEditorAppDialog;
begin
 if TAppObjectSelectionDialog.ExecuteDialog(iTypeDialog,x,s) then
  begin
   Dlg:=TManagerEditorAppDialog.Create(nil);
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

procedure TManagerEditorAppDialog.PopupMenu1Popup(Sender: TObject);
begin
 Delete1.Enabled:=Self.DetailsView.Controller.SelectedRowCount>0;
end;

function TManagerEditorAppDialog.EditItem(AppDialogControlsId: Integer; const AClassName:string):Boolean;
var
 Dlg:TControlEditorBase;
begin
 Dlg:=TControlEditorClassList.GetEditorClass(AClassName).Create(Self);
 try
  Dlg.AppDialogsId:=ID;
  //Dlg.TargetDBName:=DialogDBName;
  Dlg.ParentDBName:=DialogDBName;
  FDetailTables.First;
  Dlg.AppDialogDetailTables.LoadFromDataSet(FDetailTables);
  Dlg.ID:=AppDialogControlsId;
  Dlg.ParentDataSet:=FControlsDataSet;
  Dlg.DialogMainTable:=DataSet.FieldByName('TableName').AsString;
  Dlg.LoadState(True, True);
  Result:=Dlg.Execute;
  Dlg.SaveState;
 finally
  Dlg.Free;
 end;
end;

procedure TManagerEditorAppDialog.edSequenceNamePropertiesButtonClick(Sender: TObject; AButtonIndex: Integer);
var
 ID:integer;
 s:string;
 ADBName:string;
begin
 ADBName:=DataSet.FieldByName('SequenceDBName').AsString;
 if ADBName.IsEmpty then
  ADBName:=DialogDBName;
 if TSysObjectSelectionDialog.ExecuteDialog(iTypeSequence,ID,s, ADBName) then
  DataSet.FieldByName('SequenceName').AsString:=s;
end;

procedure TManagerEditorAppDialog.edTableNameExit(Sender: TObject);
begin
 UpdateKeyField(True);
end;

procedure TManagerEditorAppDialog.edTableNamePropertiesButtonClick( Sender: TObject; AButtonIndex: Integer);
var
 ID:integer;
 s:string;
begin
 if TSysObjectSelectionDialog.ExecuteDialog(iTypeTableOrViews,ID,s, DialogDBName) then
  DataSet.FieldByName('TableName').AsString:=s;
end;

procedure TManagerEditorAppDialog.edUpdateSPPropertiesButtonClick(Sender: TObject; AButtonIndex: Integer);
var
 ID:integer;
 s:string;
begin
 if TSysObjectSelectionDialog.ExecuteDialog(iTypeStoredProc,ID,s, DialogDBName) then
  DataSet.FieldByName('UpdateSPName').AsString:=s;
end;

procedure TManagerEditorAppDialog.edValidateSPPropertiesButtonClick(Sender: TObject; AButtonIndex: Integer);
var
 ID:integer;
 s:string;
begin
 if TSysObjectSelectionDialog.ExecuteDialog(iTypeStoredProc,ID,s, DialogDBName) then
  DataSet.FieldByName('CheckSPName').AsString:=s;
end;

procedure TManagerEditorAppDialog.RefreshControlDetails;
begin
 (FControlsDataSet as TxDataSet).ReQuery;
end;

procedure TManagerEditorAppDialog.SetDialogDBName(const Value: string);
begin
  Self.cbDBName.Text:=Value;
end;

procedure TManagerEditorAppDialog.UpdateKeyField(ForceUpdate:Boolean);
begin
if (DataSet.FieldByName('Keyfield').AsString='') or ForceUpdate then
    DataSet.FieldByName('Keyfield').AsString:=DataSet.FieldByName('TableName').AsString+'Id';
end;

initialization
  TWindowManager.RegisterEditor(iTypeDialog,nil,TManagerEditorAppDialog, False);
finalization


end.
