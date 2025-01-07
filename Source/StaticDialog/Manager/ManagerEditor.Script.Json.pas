unit ManagerEditor.Script.Json;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, ManagerEditor.Script, cxGraphics,
  cxLookAndFeels, cxLookAndFeelPainters, Vcl.Menus, cxControls,
  dxBarBuiltInMenu, dxBar, cxClasses, Data.DB, cxPC, dxLayoutContainer,
  dxLayoutControl, Vcl.StdCtrls, cxButtons, Vcl.ExtCtrls,
  Manager.WindowManager,
  Common.ResourceStrings,
  Common.Images,
  ManagerEditor.Script.SyntaxFrame,
  ManagerEditor.Script.Runner.Json, Vcl.Buttons;

type
  TManagerEditorJson = class(TManagerEditorScript)
  public
    constructor Create(AOwner:TComponent);override;
  end;

implementation

{$R *.dfm}

{ TManagerEditorJson }

constructor TManagerEditorJson.Create(AOwner: TComponent);
begin
  inherited;
  iType:=iTypeJsonText;
  ImageIndex:=IMAGEINDEX_MIME_JSON;
  ScriptRunnerClass:=TJsonScriptRunner;
  bnRun.Caption:=S_COMMON_VALIDATE;
end;


initialization
  TWindowManager.RegisterEditor(iTypeJsonText,nil,TManagerEditorJson, True);
finalization


end.
