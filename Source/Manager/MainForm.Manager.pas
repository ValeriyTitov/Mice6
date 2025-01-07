unit MainForm.Manager;

 // IMAGE_FILE_LARGE_ADDRESS_AWARE = $0020;
 // If the application has the IMAGE_FILE_LARGE_ADDRESS_AWARE
 // flag set in the image header, each 32-bit application receives 4 GB
 // of virtual address space in the WOW64 environment

  {$SetPEFlags $0020}

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, dxStatusBar, cxCustomData,  cxContainer, cxEdit, cxStyles, cxTL, cxMaskEdit, cxTLdxBarBuiltInMenu,
  Vcl.StdCtrls, dxBar, cxClasses, cxInplaceContainer, cxDBTL, cxTLData,
  cxDataControllerConditionalFormattingRulesManagerDialog,dxScrollbarAnnotations,
  System.IOUtils,
  cxTextEdit, Vcl.ExtCtrls,Data.DB,
  CustomControl.MiceAction,
  CustomControl.MiceActionList,
  CustomControl.TreeGrid,
  Common.ResourceStrings,
  Common.StringUtils,
  DAC.History.Form,
  MainForm.Actions,
  MainForm.TreeRefresher,
  Manager.WindowManager,
  DAC.XParams,
  DAC.XDataSet,
  StaticDialog.DBNameSelector,
  Dialog.MShowMessage,
  Dialog.ShowDataSet,
  ImportExport.Entity,
  ImportExport.Manager,
  Common.DateUtils,
  Common.Registry, cxFilter;

type
  TcxDBTreeList = class(TMiceTreeGrid)
  end;

  TManagerMainForm = class(TForm)
    StatusBar: TdxStatusBar;
    pnPath: TPanel;
    edPath: TcxTextEdit;
    MainBar: TdxBarManager;
    PopupMenu: TdxBarPopupMenu;
    bnNewFolder: TdxBarButton;
    bnNewSubMenu: TdxBarSubItem;
    bnNewPlugin: TdxBarButton;
    bnNewCommandGroup: TdxBarButton;
    bnNewFilterGroup: TdxBarButton;
    MainTree: TcxDBTreeList;
    colName: TcxDBTreeListColumn;
    bnEdit: TdxBarButton;
    bnRenameItem: TdxBarButton;
    pmNew: TdxBarPopupMenu;
    MainMenuBar: TdxBar;
    SideToolBar: TdxBar;
    bnDelete: TdxBarButton;
    pmAddRef: TdxBarPopupMenu;
    bnAddPluginRef: TdxBarButton;
    bnAddDialogRef: TdxBarButton;
    bnAddRef: TdxBarSubItem;
    bnAddCommonCommand: TdxBarSubItem;
    bnNewCustomCommand: TdxBarButton;
    bnNewCustomFilter: TdxBarButton;
    bnNewDialog: TdxBarButton;
    bnNewLayout: TdxBarButton;
    bnAddObject: TdxBarSubItem;
    bnNewSQLScript: TdxBarButton;
    bnNewPascalScript: TdxBarButton;
    bnNewCSharpScript: TdxBarButton;
    bnNewJson: TdxBarButton;
    bnNewXml: TdxBarButton;
    bnNewExternalFile: TdxBarButton;
    bnNewdfClass: TdxBarButton;
    bnNewdfTypes: TdxBarButton;
    bnNewExportTemplate: TdxBarButton;
    bnNewAppDataSet: TdxBarButton;
    Button1: TButton;
    bnChangeImageIndex: TdxBarButton;
    bnRefresh: TdxBarButton;
    bnCommonCommands: TdxBarButton;
    colAppMainTreeId: TcxDBTreeListColumn;
    colObjectId: TcxDBTreeListColumn;
    colIType: TcxDBTreeListColumn;
    colParentId: TcxDBTreeListColumn;
    colImageIndex: TcxDBTreeListColumn;
    colOrderId: TcxDBTreeListColumn;
    colDBName: TcxDBTreeListColumn;
    bnUseOnMainTree: TdxBarButton;
    mnFile: TdxBarSubItem;
    bnExit: TdxBarButton;
    mnSearchMenu: TdxBarSubItem;
    bnFind: TdxBarButton;
    bnFindNext: TdxBarButton;
    bnImport: TdxBarButton;
    bnExportMenu: TdxBarSubItem;
    bnExportAll: TdxBarButton;
    bnExportCurrent: TdxBarButton;
    ImportDialog: TOpenDialog;
    mnTools: TdxBarSubItem;
    procedure edPathKeyPress(Sender: TObject; var Key: Char);
    procedure MainTreeFocusedNodeChanged(Sender: TcxCustomTreeList; APrevFocusedNode, AFocusedNode: TcxTreeListNode);
    procedure MainTreeDblClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure bnAddCommonCommandPopup(Sender: TObject);
    procedure PopupMenuPopup(Sender: TObject);
    procedure StatusBarMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure bnExitClick(Sender: TObject);
    procedure bnImportClick(Sender: TObject);
    procedure bnExportAllClick(Sender: TObject);
    procedure bnExportCurrentClick(Sender: TObject);

  strict private
    FFindNext:TMiceAction;
    FRefresher:TMainFormTreeRefresher;
    FMainFormActions:TMainFormActions;
    function NodeHasItype(Node: TcxTreeListNode; iType:Integer):Boolean;
    procedure UpdatePath;
    procedure UpdateStatusBar(DataSet:TDataSet);
    procedure FindItemActionExecute(Sender:TObject);
    procedure FindNextActionExecute(Sender:TObject);
    procedure CreateActions;
    procedure LoadState;
    procedure SaveState;
  public
    constructor Create(AOwner:TComponent); override;
    destructor Destroy;override;
    procedure Initialize;
  end;

var
  ManagerMainForm: TManagerMainForm;

implementation

{$R *.dfm}



{ TManagerMainForm }


procedure TManagerMainForm.bnAddCommonCommandPopup(Sender: TObject);
begin
 FMainFormActions.FillCommonCommandMenu(MainTree.DataSet.FieldByName('AppMainTreeId').Value, MainTree.DataSet.FieldByName('ObjectId').Value, bnAddCommonCommand);
end;

procedure TManagerMainForm.bnExitClick(Sender: TObject);
begin
 Application.Terminate;
end;


procedure TManagerMainForm.bnExportAllClick(Sender: TObject);
begin
 TImportExportManager.ExecuteExport(MainTree, MainTree.FocusedNode);
end;

procedure TManagerMainForm.bnExportCurrentClick(Sender: TObject);
begin
 TImportExportManager.ExecuteExportCurrent(MainTree, MainTree.FocusedNode);
end;

procedure TManagerMainForm.bnImportClick(Sender: TObject);
begin
if ImportDialog.Execute(Handle) then
 TImportExportManager.ExecuteImport(ImportDialog.FileName,MainTree)
end;



procedure TManagerMainForm.Button1Click(Sender: TObject);
var
 List:TStringList;
begin
 List:=TStringList.Create;
 try
  List.Add('xexe');
  List.Add('xaxa');
  List.Add('xexexexexe');
  List.Add(TDateUtils.SecondsToTime(3610));
//  TShowDatasetDialog.ShowDataSetEx(Self.MainTree.DataSet,'xexe','xaxa',434);
  TMessageDialog.MShowMessageListEx(List,'xexe','xaxa',177);
 finally
  List.Free;
 end;
end;

constructor TManagerMainForm.Create(AOwner: TComponent);
begin
  inherited;
  FRefresher:=TMainFormTreeRefresher.Create(MainTree);
  FMainFormActions:=TMainFormActions.Create(MainTree.DataSource);

  CreateActions;
  Initialize;
end;

procedure TManagerMainForm.CreateActions;
begin
 bnNewFolder.Action:=FMainFormActions.ActionByName('NewFolder');
 bnNewPlugin.Action:=FMainFormActions.ActionByName('NewPlugin');

 bnEdit.Action:=FMainFormActions.ActionByName('Edit');
 bnDelete.Action:=FMainFormActions.ActionByName('Delete');
 bnRenameItem.Action:=FMainFormActions.ActionByName('RenameItem');

 bnAddPluginRef.Action:=FMainFormActions.ActionByName('AddRefPlugin');
 bnAddDialogRef.Action:=FMainFormActions.ActionByName('AddRefDialog');

 bnNewCommandGroup.Action:=FMainFormActions.ActionByName('NewCommandGroup');
// bnNewFilterGroup.Action:=FMainFormActions.ActionByName('NewFilterGroup');

 bnNewDialog.Action:=FMainFormActions.ActionByName('NewAppDialog');
 bnNewLayout.Action:=FMainFormActions.ActionByName('NewAppDialogLayout');

 bnNewCustomCommand.Action:=FMainFormActions.ActionByName('NewCommand');
 bnNewCustomFilter.Action:=FMainFormActions.ActionByName('NewFilter');

 bnChangeImageIndex.Action:=FMainFormActions.ActionByName('ChangeImageIndex');

 bnRefresh.Action:=FMainFormActions.ActionByName('Refresh');

 bnCommonCommands.Action:=FMainFormActions.ActionByName('CommonCommands');
 bnUseOnMainTree.Action:=FMainFormActions.ActionByName('UseOnMainTree');


 bnNewSQLScript.Action:=FMainFormActions.ActionByName('NewSQLScript');
 bnNewPascalScript.Action:=FMainFormActions.ActionByName('NewPascalScript');
 bnNewCSharpScript.Action:=FMainFormActions.ActionByName('NewCSharpScript');
 bnNewXml.Action:=FMainFormActions.ActionByName('NewXml');
 bnNewJson.Action:=FMainFormActions.ActionByName('NewJson');
 bnNewExternalFile.Action:=FMainFormActions.ActionByName('NewExternalFile');
 bnNewExportTemplate.Action:=FMainFormActions.ActionByName('NewAppTemplate');
 bnNewAppDataSet.Action:=FMainFormActions.ActionByName('NewAppDataSet');
 bnNewdfClass.Action:=FMainFormActions.ActionByName('NewDfClass');
 bnNewdfTypes.Action:=FMainFormActions.ActionByName('NewDfTypes');



 bnFind.Action:=FMainFormActions.ActionByName('Find');
 bnFind.Action.OnExecute:=FindItemActionExecute;

 FFindNext:=FMainFormActions.ActionByName('FindNext');
 FFindNext.OnExecute:=FindNextActionExecute;
 FFindNext.Enabled:=False;
 bnFindNext.Action:=FFindNext;


end;


destructor TManagerMainForm.Destroy;
begin
  FMainFormActions.Free;
  FRefresher.Free;
  inherited;
end;

procedure TManagerMainForm.edPathKeyPress(Sender: TObject; var Key: Char);
begin
 if Key=#13 then
  begin
   Key:=#0;
   MainTree.Path:=edPath.Text;
   ActiveControl:= MainTree;
  end;
end;

procedure TManagerMainForm.FindItemActionExecute(Sender: TObject);
begin
 MainTree.FindItem;
 FFindNext.Enabled:=True;
end;

procedure TManagerMainForm.FindNextActionExecute(Sender: TObject);
begin
 MainTree.FindNext;
end;

procedure TManagerMainForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
 SaveState;
end;

procedure TManagerMainForm.Initialize;
begin
  MainTree.DataSet.ProviderName:='spui_AppMainTreeManager';
  MainTree.DataSet.AfterOpen:=UpdateStatusBar;
  MainTree.DataSet.Open;
  MainTree.ExpandByLevel(1);
  MainTree.PathColumn:=colName;
  LoadState;
end;


procedure TManagerMainForm.MainTreeDblClick(Sender: TObject);
begin
 bnEdit.Action.Execute;
end;

procedure TManagerMainForm.MainTreeFocusedNodeChanged(Sender: TcxCustomTreeList; APrevFocusedNode, AFocusedNode: TcxTreeListNode);
begin
 UpdatePath;
end;


function TManagerMainForm.NodeHasItype(Node: TcxTreeListNode;  iType: Integer): Boolean;
var
 x:Integer;
begin
 if not Assigned(Node) then
  Exit(False);

 for x:=0 to Node.Count-1 do
  if Node.Items[x].Values[ColIndex_iType]=iType then
   Exit(True);

 Result:=False;
end;

procedure TManagerMainForm.PopupMenuPopup(Sender: TObject);
begin
 bnAddCommonCommand.Enabled:=(FMainFormActions.CurrentiType=iTypeCommandGroup);
 bnNewCommandGroup.Enabled:=not NodeHasItype(MainTree.FocusedNode,iTypeCommandGroup);
 bnExportMenu.Enabled:=Assigned(MainTree.FocusedNode);
end;

procedure TManagerMainForm.SaveState;
begin
 TProjectRegistry.DefaultInstance.WriteString(TProjectRegistry.DefaultInstance.DialogPath(ClassName),RegKeyLastPath,MainTree.Path);
 TProjectRegistry.DefaultInstance.SaveForm(ClassName, Self);
end;

procedure TManagerMainForm.LoadState;
begin
 TProjectRegistry.DefaultInstance.LoadForm(ClassName,True, True, Self);
 MainTree.Path:=TProjectRegistry.DefaultInstance.ReadStringDef(TProjectRegistry.DefaultInstance.DialogPath(ClassName),RegKeyLastPath,'');
end;

procedure TManagerMainForm.StatusBarMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
 if ssCtrl in Shift then
  TSQLHistoryForm.ShowHistory;
end;

procedure TManagerMainForm.UpdatePath;
begin
 edPath.Text:=MainTree.Path;
end;


procedure TManagerMainForm.UpdateStatusBar(DataSet: TDataSet);
begin
 StatusBar.Panels[0].Text:=Format(S_ROWS_FMT,[DataSet.RecordCount]);
end;

end.
