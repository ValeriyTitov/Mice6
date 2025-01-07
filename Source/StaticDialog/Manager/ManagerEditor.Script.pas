unit ManagerEditor.Script;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, ManagerEditor.Common, cxGraphics,
  cxLookAndFeels, cxLookAndFeelPainters, Vcl.Menus, cxControls, Data.DB,
  cxClasses, dxLayoutContainer, dxLayoutControl, Vcl.StdCtrls, cxButtons,
  Vcl.ExtCtrls,  dxBarBuiltInMenu, cxPC, dxBar,
  System.Generics.Collections, System.Generics.Defaults,
  DAC.XDataSet,
  CustomControl.MiceSyntaxEdit,
  ManagerEditor.Script.SyntaxFrame,
  ManagerEditor.Script.Runner,
  Common.ResourceStrings,
  MainForm.TreeRefresher, Vcl.Buttons;


type
  TManagerEditorScript = class(TCommonManagerDialog)
    MainBar: TdxBarManager;
    MainMenuBar: TdxBar;
    bnRun: TdxBarButton;
    bnSave: TdxBarButton;
    pgMain: TcxPageControl;
    bnCloseCurrentPage: TdxBarButton;
    bnSaveAsFile: TdxBarButton;
    SaveDialog: TSaveDialog;
    bnFormat: TdxBarButton;
    procedure pgMainChange(Sender: TObject);
    procedure bnRunClick(Sender: TObject);
    procedure bnSaveClick(Sender: TObject);
    procedure bnCloseCurrentPageClick(Sender: TObject);
    procedure bnSaveAsFileClick(Sender: TObject);
    procedure bnFormatClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
  strict private
    FFramesDict:TDictionary<Integer, TSyntaxFrame>;
    FScriptRunnerClass: TCustomScriptRunnerClass;
    FLastTab:Boolean;
    function CreatePage(ID:Integer; const PageName:string):TcxTabSheet;
    function CreateNewPage(ID:Integer; const PageName:string): TcxTabSheet;
    procedure ActiveFrameChanged(NewFrame:TSyntaxFrame);
    procedure SetScriptRunnerClass(const Value: TCustomScriptRunnerClass);
    function GetActiveFrame: TSyntaxFrame;
  protected
    FActiveFrame: TSyntaxFrame;
    procedure OnInsertNewItem(Sender:TObject); virtual;
    procedure DoOnNewFrame(Frame:TSyntaxFrame); virtual;
    procedure SaveAndClose(Frame:TSyntaxFrame; Page:TcxTabSheet);
    procedure ClosePage(Page:TcxTabSheet);
    function ClosePageDialog(Page:TcxTabSheet):Boolean;
  public
    procedure Initialize; override;
    procedure SaveActiveScriptToFile;
    constructor Create(AOwner:TComponent);override;
    procedure EditID(ID:Integer;const PageName:string); override;
    property ActiveFrame:TSyntaxFrame read GetActiveFrame;
    property ScriptRunnerClass:TCustomScriptRunnerClass read FScriptRunnerClass write SetScriptRunnerClass;
    destructor Destroy; override;
  end;

implementation

{$R *.dfm}

{ TManagerEditorSQLScript }

procedure TManagerEditorScript.ActiveFrameChanged(NewFrame: TSyntaxFrame);
begin
 FActiveFrame:=NewFrame;
 if Assigned(FActiveFrame.Editor) then
   FActiveFrame.Editor.SetFocus;
end;

procedure TManagerEditorScript.bnCloseCurrentPageClick(Sender: TObject);
begin
  inherited;
  ClosePageDialog(pgMain.ActivePage);
end;

procedure TManagerEditorScript.bnFormatClick(Sender: TObject);
begin
 ActiveFrame.FormatCurrentText;
end;

procedure TManagerEditorScript.bnRunClick(Sender: TObject);
begin
  inherited;
  ActiveFrame.Execute;
end;

procedure TManagerEditorScript.bnSaveAsFileClick(Sender: TObject);
begin
 SaveActiveScriptToFile;
end;

procedure TManagerEditorScript.bnSaveClick(Sender: TObject);
begin
  inherited;
  ActiveFrame.Save;
end;


procedure TManagerEditorScript.ClosePage(Page: TcxTabSheet);
begin
  FLastTab:=pgMain.TabCount=1;
  pgMain.CloseTab(Page.PageIndex);
  if pgMain.TabCount=0 then
    Close;
end;

function TManagerEditorScript.ClosePageDialog(Page:TcxTabSheet):Boolean;
var
 AFrame:TSyntaxFrame;
 AResult:Integer;
begin
 Result:=True;
 AFrame:=Page.Controls[0] as TSyntaxFrame;
  if AFrame.WasChanged then
     begin
      AResult:=MessageBox(Handle, PChar(S_COMMON_SAVECHANGES_Q),PChar(S_COMMON_CONFIRMATION),MB_YESNOCANCEL+MB_ICONQUESTION);
        case AResult of
         ID_YES: SaveAndClose(AFrame,Page);
         ID_NO: ClosePage(Page);
         ID_CANCEL:Result:=False;
        end;
     end
      else
    ClosePage(Page);
end;

constructor TManagerEditorScript.Create(AOwner: TComponent);
begin
  inherited;
  CanEditMultiplyIDs:=True;
  FFramesDict:=TDictionary<Integer, TSyntaxFrame>.Create;
  ScriptRunnerClass:=nil;
end;

function TManagerEditorScript.CreateNewPage(ID: Integer; const PageName: string): TcxTabSheet;
var
 Frame:TSyntaxFrame;
begin
 Result:=TcxTabSheet.Create(Self);
 Result.PageControl:=pgMain;
 Frame:=TSyntaxFrame.Create(Result);
 Frame.Parent:=Result;
 if Assigned(Params.FindParam('Flags')) then
  begin
   Frame.Flags:=Params.ParamByName('Flags').AsInteger;
   Params.ParamByName('Flags').AsInteger:=0;
  end;
 Frame.Open(ID);
 Frame.Align:=TAlign.alClient;
 if ID<0 then
  Frame.ScriptName:=PageName;
 Frame.CreateScriptRunner(ScriptRunnerClass);
 Frame.OnInsertNewItem:=Self.OnInsertNewItem;

 Frame.ParentId:=ParentId;
 Frame.WasChanged:=False;
 Result.Caption:=Frame.ScriptName;
 DoOnNewFrame(Frame);
 FFramesDict.Add(ID,Frame);
 ActiveFrameChanged(Frame);
end;

function TManagerEditorScript.CreatePage(ID:Integer; const PageName:string): TcxTabSheet;

resourcestring
 S_NO_SCRIPTRUNNER_ASSIGNED_FOR_CLASS = 'Script runner not assigned for class %s';
begin
if FFramesDict.ContainsKey(ID) then
 Result:=(FFramesDict[ID].Parent as TcxTabSheet)
  else
   begin
     if FScriptRunnerClass=nil then
      raise Exception.CreateFmt(S_NO_SCRIPTRUNNER_ASSIGNED_FOR_CLASS, [ClassName]);
     Result:=CreateNewPage(Id,PageName);
   end;
end;

destructor TManagerEditorScript.Destroy;
begin
  FFramesDict.Free;
  inherited;
end;

procedure TManagerEditorScript.EditID(ID: Integer;const PageName:string);
var
 Page:TcxTabSheet;
begin
  Page:=CreatePage(ID, PageName);
  pgMain.ActivePage:=Page;
end;

procedure TManagerEditorScript.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
var
 Page:TcxTabSheet;
 x:Integer;
begin
 for x:=pgMain.PageCount-1 downto 0 do
  begin
   Page:=pgMain.Pages[x];
   CanClose:=ClosePageDialog(Page);
   if (CanClose=False) then
    Exit;
  end;

end;

function TManagerEditorScript.GetActiveFrame: TSyntaxFrame;
resourcestring
 S_NO_ACTIVE_SCRIPT = 'No active script';
begin
 if not Assigned(FActiveFrame) then
  raise Exception.Create(S_NO_ACTIVE_SCRIPT);
 Result:=FActiveFrame;
end;

procedure TManagerEditorScript.Initialize;
begin
// EditID(ID);
end;

procedure TManagerEditorScript.OnInsertNewItem(Sender: TObject);
var
 Frame:TSyntaxFrame;
const
 SkipInsertToMainTree = 10;
 SkipInsertToMainTreePlugin = 1000;
begin
 Frame:=(Sender as TSyntaxFrame);
 if (Frame.Flags<>SkipInsertToMainTree) and (Frame.Flags<>SkipInsertToMainTreePlugin) then
  begin
   NewTreeItem(Frame.ScriptName,Frame.ParentId,iType,Frame.ID,ImageIndex);
   pgMain.ActivePage.Caption:=Frame.ScriptName;
   TMainFormTreeRefresher.DefaultInstance.ItemInserted(Frame.ID, Frame.ParentId, Frame.ScriptName, iType, Frame.ID, ImageIndex);
  end;
end;

procedure TManagerEditorScript.DoOnNewFrame(Frame: TSyntaxFrame);
begin

end;

procedure TManagerEditorScript.pgMainChange(Sender: TObject);
begin
  inherited;
  if (FLastTab=False) and (pgMain.ActivePage.ControlCount>0) and (pgMain.ActivePage.Controls[0] is TSyntaxFrame)then
   ActiveFrameChanged(pgMain.ActivePage.Controls[0] as TSyntaxFrame)
    else
   FActiveFrame:=nil;
end;


procedure TManagerEditorScript.SaveActiveScriptToFile;
var
 AName:string;
begin
 AName:=ActiveFrame.ScriptName;
 if AName.ToLower.EndsWith(ActiveFrame.ScriptRunner.DefaultExtension.ToLower) then
  SaveDialog.FileName:=AName
   else
  SaveDialog.FileName:=AName+ActiveFrame.ScriptRunner.DefaultExtension;
 if SaveDialog.Execute then
  ActiveFrame.Editor.Lines.SaveToFile(SaveDialog.FileName);
end;



procedure TManagerEditorScript.SaveAndClose(Frame: TSyntaxFrame;  Page: TcxTabSheet);
begin
 Frame.Save;
 ClosePage(Page);
end;

procedure TManagerEditorScript.SetScriptRunnerClass(const Value: TCustomScriptRunnerClass);
begin
  FScriptRunnerClass := Value;
  bnRun.Enabled:=Value<>nil;
end;


end.
