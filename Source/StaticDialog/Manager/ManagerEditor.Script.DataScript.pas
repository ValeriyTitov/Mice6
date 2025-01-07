unit ManagerEditor.Script.DataScript;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, ManagerEditor.Script, cxGraphics,
  cxLookAndFeels, cxLookAndFeelPainters, Vcl.Menus, cxControls,
  dxBarBuiltInMenu, dxBar, cxClasses, Data.DB, cxPC, dxLayoutContainer,
  dxLayoutControl, Vcl.StdCtrls, cxButtons,
  Vcl.ExtCtrls,
  Manager.WindowManager,
  ManagerEditor.Script.Runner.CSharp,
  Common.ResourceStrings,
  Common.Images,
  DataScript.InputBox,
  DAC.XDataSet,
  ManagerEditor.Script.SyntaxFrame,
  cxCheckBox, cxBarEditItem, Vcl.Buttons;


type
  TManagerEditorCSharpScript = class(TManagerEditorScript)
    bnPublish: TdxBarButton;
    bnParams: TdxBarButton;
    memoTemplate: TMemo;
    procedure bnPublishClick(Sender: TObject);
    procedure bnParamsClick(Sender: TObject);
    procedure pgMainChange(Sender: TObject);
  private
    procedure PublishDataScript;
  protected
   procedure DoOnNewFrame(Frame:TSyntaxFrame); override;
  public
   constructor Create(AOwner:TComponent);override;
  end;


implementation

{$R *.dfm}


{ TManagerEditorCSharpScript }

procedure TManagerEditorCSharpScript.bnParamsClick(Sender: TObject);
begin
 ActiveFrame.ParamsPanelVisible:=bnParams.Down;
end;

procedure TManagerEditorCSharpScript.bnPublishClick(Sender: TObject);
resourcestring
 S_PUBLISH_DATASCRIPT_CONF = 'Save and publish current datascript ?';
begin
 if MessageBox(Handle,PChar(S_PUBLISH_DATASCRIPT_CONF),PChar(S_COMMON_CONFIRMATION),MB_YESNO+MB_ICONQUESTION)=ID_YES then
  PublishDataScript;
end;

constructor TManagerEditorCSharpScript.Create(AOwner: TComponent);
begin
  inherited;
  iType:=iTypeCSharpScript;
  ImageIndex:=IMAGEINDEX_ITYPE_SCRIPT_CSHARP;
  ScriptRunnerClass:=TCSharpScriptRunner;
end;


procedure TManagerEditorCSharpScript.DoOnNewFrame(Frame: TSyntaxFrame);
var
 Template:string;
begin
  inherited;
  if Frame.ID<0 then
   begin
    Template:=memoTemplate.Text;
    Frame.DataSet.FieldByName('Script').AsString:=Template.Replace('%s',Frame.ScriptName);
   end;
end;

procedure TManagerEditorCSharpScript.pgMainChange(Sender: TObject);
begin
  inherited;
  if Assigned(FActiveFrame) then
   bnParams.Down:=FActiveFrame.ParamsPanelVisible;
end;

procedure TManagerEditorCSharpScript.PublishDataScript;
var
 ScriptRunner:TCSharpScriptRunner;
begin
 ActiveFrame.Save;
 ActiveFrame.PrepareToExecute;
 ScriptRunner:=ActiveFrame.ScriptRunner as TCSharpScriptRunner;
 ScriptRunner.PublishDataScript;
end;

initialization
 TWindowManager.RegisterEditor(iTypeCSharpScript,TDataScriptInputBox,TManagerEditorCSharpScript, True);

end.
