unit ManagerEditor.Script.Xml;

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
  ManagerEditor.Script.Runner.Xml;

type
  TManagerEditorXml = class(TManagerEditorScript)
  public
    constructor Create(AOwner:TComponent);override;
  end;

implementation

{$R *.dfm}

{ TManagerEditorXml }

constructor TManagerEditorXml.Create(AOwner: TComponent);
begin
  inherited;
  iType:=iTypeXMLText;
  ImageIndex:=IMAGEINDEX_MIME_XML;
  bnRun.Caption:=S_COMMON_VALIDATE;
  ScriptRunnerClass:=TXmlScriptRunner;
end;


initialization
  TWindowManager.RegisterEditor(iTypeXMLText,nil,TManagerEditorXml, True);
finalization



end.
