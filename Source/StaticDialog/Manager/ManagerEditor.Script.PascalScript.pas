unit ManagerEditor.Script.PascalScript;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, ManagerEditor.Script, cxGraphics,
  cxLookAndFeels, cxLookAndFeelPainters, Vcl.Menus, cxControls,
  dxBarBuiltInMenu, dxBar, cxClasses, Data.DB, cxPC, dxLayoutContainer,
  dxLayoutControl, Vcl.StdCtrls, cxButtons, Vcl.ExtCtrls, cxTreeView, Vcl.ComCtrls,
  CustomControl.MiceSyntaxEdit,
  DAC.XDataSet,
  Manager.WindowManager,
  Common.ResourceStrings,
  Common.Images,
  ManagerEditor.Script.SyntaxFrame,
  ManagerEditor.Script.Runner.Pascal,
  ManagerEditor.Script.PascalScript.DataTreeBuilder, Vcl.Buttons;


type
  TManagerEditorPascalScript = class(TManagerEditorScript)
    bnDataTree: TdxBarButton;
    procedure bnDataTreeClick(Sender: TObject);
    procedure pgMainChange(Sender: TObject);
    procedure bnSaveClick(Sender: TObject);
  private
    procedure UpdateAppPlugin(AppPluginsId, AppScriptsId: Integer);
    procedure UpdateAppDialog(AppDialogsId, AppScriptsId:Integer);
    procedure UpdateAppCmd(AppCmdId, AppScriptsId:Integer);
  protected
    procedure OnInsertNewItem(Sender:TObject); override;
    procedure DoOnNewFrame(Frame:TSyntaxFrame); override;
    procedure PopulateTree(Frame: TSyntaxFrame);
  public
    constructor Create(AOwner:TComponent);override;
    procedure EditID(ID:Integer;const PageName:string); override;
    destructor Destroy; override;
  end;


implementation

{$R *.dfm}


const
FLAG_RUNNING_FROM_MAIN_TREE = 0;
FLAG_RUNNING_FROM_PLUGIN_COMMAND = 1;


{ TManagerEditorPascalScript }


procedure TManagerEditorPascalScript.bnDataTreeClick(Sender: TObject);
begin
 ActiveFrame.DataTreeVisible:=bnDataTree.Down;
end;

procedure TManagerEditorPascalScript.bnSaveClick(Sender: TObject);
begin
// if (ActiveFrame.ScriptRunner as TPascalScriptRunner).Compile(ActiveFrame.Editor.Lines) then
  inherited;
end;

constructor TManagerEditorPascalScript.Create(AOwner: TComponent);
begin
  inherited;
  iType:=iTypePascalScript;
  ImageIndex:=IMAGEINDEX_ITYPE_SCRIPT_PASCAL;
  ScriptRunnerClass:=TPascalScriptRunner;
end;

destructor TManagerEditorPascalScript.Destroy;
begin
  inherited;
end;

procedure TManagerEditorPascalScript.DoOnNewFrame(Frame: TSyntaxFrame);
begin
  inherited;
  PopulateTree(Frame);
  if Frame.ID<0 then
   Frame.DataSet.FieldByName('Script').AsString:='begin'#13'end.';
  //ReplaceEditor(Frame);
end;

procedure TManagerEditorPascalScript.EditID(ID: Integer; const PageName: string);
begin
  inherited;
  ActiveFrame.pnBottom.Height:=ActiveFrame.pnHelp.Height;
  ActiveFrame.pnBottom.Visible:=True;
  ActiveFrame.pgOutput.Visible:=False;
end;

procedure TManagerEditorPascalScript.OnInsertNewItem(Sender: TObject);
var
 AppScriptsId:integer;
 Frame:TSyntaxFrame;
const
 SkipInsertToMainTree = 10;
begin
  inherited;

  Frame:=(Sender as TSyntaxFrame);
  AppScriptsId:=Frame.ID;

  case Frame.Flags of
   0:UpdateAppDialog(OwnerObjectId, AppScriptsId);
   1:UpdateAppCmd(OwnerObjectId, AppScriptsId);
   10:UpdateAppCmd(OwnerObjectId, AppScriptsId);
   1000:UpdateAppPlugin(OwnerObjectId, AppScriptsId)
  end;
end;


procedure TManagerEditorPascalScript.pgMainChange(Sender: TObject);
begin
  inherited;
  if Assigned(FActiveFrame) then
   bnDataTree.Down:=FActiveFrame.DataTreeVisible;
end;

procedure TManagerEditorPascalScript.PopulateTree(Frame: TSyntaxFrame);
var
 Builder:TDataTreeBuilder;
 iType:Integer;
begin
  Builder:=TDataTreeBuilder.Create(Frame.DataTree);
  try
   iType:=Self.Params.ParamByNameDef('iType', 0);
   case iType of
     iTypeDialog:Builder.PopulateTreeForDialog(OwnerObjectId);
     iTypePlugin:Builder.PopulateTreeForPlugin(OwnerObjectId);
     iTypeCommand:Builder.PopulateTreeForCommand(OwnerObjectId);
   end;
  finally
   Builder.Free;
  end;

end;


procedure TManagerEditorPascalScript.UpdateAppCmd(AppCmdId,  AppScriptsId: Integer);
var
 DataSet:TxDataSet;
begin
  DataSet:=TxDataSet.Create(nil);
  try
   DataSet.ProviderName:='spui_AppCmdUpdateScriptID';
   DataSet.SetParameter('AppCmdId', AppCmdId);
   DataSet.SetParameter('RunAppScriptsId', AppScriptsId);
   DataSet.Execute;
  finally
    DataSet.Free;
  end;
end;

procedure TManagerEditorPascalScript.UpdateAppPlugin(AppPluginsId,  AppScriptsId: Integer);
var
 DataSet:TxDataSet;
begin
  DataSet:=TxDataSet.Create(nil);
  try
   DataSet.ProviderName:='spui_AppPluginUpdateScriptID';
   DataSet.SetParameter('AppPluginsId', AppPluginsId);
   DataSet.SetParameter('AppScriptsId', AppScriptsId);
   DataSet.Execute;
  finally
    DataSet.Free;
  end;
end;


procedure TManagerEditorPascalScript.UpdateAppDialog(AppDialogsId,  AppScriptsId: Integer);
var
 DataSet:TxDataSet;
begin
  DataSet:=TxDataSet.Create(nil);
  try
   DataSet.ProviderName:='spui_AppDialogUpdateAppScriptsId';
   DataSet.SetParameter('AppDialogsId', AppDialogsId);
   DataSet.SetParameter('AppScriptsId', AppScriptsId);
   DataSet.Execute;
  finally
    DataSet.Free;
  end;
end;


initialization
  TWindowManager.RegisterEditor(iTypePascalScript,nil,TManagerEditorPascalScript, True);

finalization

end.
