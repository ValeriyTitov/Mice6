unit ManagerEditor.Script.SQL;

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
  DAC.ConnectionMngr,
  DAC.DatabaseUtils,
  DAC.BaseDataSet,
  DAC.XDataSet,
  Dialog.MShowMessage,
  Dialog.ShowDataSet,
  ManagerEditor.Script.Runner.SQL.ObjectDetails,
  ManagerEditor.Script.Runner.SQL, cxDropDownEdit, cxBarEditItem, Vcl.Buttons,
  dxmdaset;

type
  TManagerEditorSQLScript = class(TManagerEditorScript)
    cbDBName: TdxBarCombo;
    dxBarSubItem1: TdxBarSubItem;
    bnImportSqlObject: TdxBarButton;
    bnObjectDetails: TdxBarButton;
    procedure cbDBNameChange(Sender: TObject);
    procedure pgMainChange(Sender: TObject);
    procedure bnImportSqlObjectClick(Sender: TObject);
  public
    constructor Create(AOwner:TComponent);override;
    procedure EditID(ID:Integer;const PageName:string); override;
  end;


implementation

{$R *.dfm}

{ TManagerEditorSQLScript }

constructor TManagerEditorSQLScript.Create(AOwner: TComponent);
begin
  inherited;
  iType:=iTypeSQLScript;
  ImageIndex:=IMAGEINDEX_ITYPE_SCRIPT_SQL;
  ScriptRunnerClass:=TSQLScriptRunner;
  TConnectionManager.DefaultInstance.PopulateDBNames(cbDBName.Items);
end;

procedure TManagerEditorSQLScript.EditID(ID: Integer; const PageName: string);
begin
  try
    cbDBName.OnChange:=nil;
    inherited;
    cbDBName.Text:=ActiveFrame.DBName;
    ActiveFrame.StatusBar.Visible:=True;
    ActiveFrame.pnBottom.Visible:=True;
  finally
    cbDBName.OnChange:=cbDBNameChange;
  end;
end;



procedure TManagerEditorSQLScript.pgMainChange(Sender: TObject);
begin
  inherited;
  if Assigned(FActiveFrame) then
    try
      cbDBName.OnChange:=nil;
      cbDBName.Text:=ActiveFrame.DBName;
    finally
      cbDBName.OnChange:=cbDBNameChange;
    end;
end;

procedure TManagerEditorSQLScript.bnImportSqlObjectClick(Sender: TObject);
begin
 raise Exception.Create('Not implemented');
end;

procedure TManagerEditorSQLScript.cbDBNameChange(Sender: TObject);
begin
 ActiveFrame.DBName:=cbDBName.Text;
 ActiveFrame.WasChanged:=True;
end;

initialization
  TWindowManager.RegisterEditor(iTypeSQLScript,nil,TManagerEditorSQLScript, True);

finalization


end.
