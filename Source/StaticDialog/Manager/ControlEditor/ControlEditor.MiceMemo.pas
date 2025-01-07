unit ControlEditor.MiceMemo;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, ControlEditor.Common, cxGraphics,
  cxLookAndFeels, cxLookAndFeelPainters, Vcl.Menus, cxControls, cxContainer,
  cxEdit, dxLayoutcxEditAdapters, Data.DB, dxLayoutContainer, cxClasses,
  cxDropDownEdit, cxButtonEdit, cxDBEdit, cxCheckBox, cxImageComboBox,
  cxTextEdit, cxMaskEdit, dxLayoutControl, Vcl.StdCtrls, cxButtons, Vcl.ExtCtrls,
  CustomControl.MiceMemo;

type
  TControlEditorMiceMemo = class(TControlEditorBase)
    cbSpellCheck: TcxCheckBox;
    cbSpellCheck_Item: TdxLayoutItem;
    cbRemoveDualSpaces: TcxCheckBox;
    cbRemoveDualSpaces_Item: TdxLayoutItem;
    cbTrimOnPost: TcxCheckBox;
    cbTrimOnPost_Item: TdxLayoutItem;
    cbAcceptTabPaste: TcxCheckBox;
    dxLayoutItem1: TdxLayoutItem;
  private
  protected
    procedure Load; override;
    procedure Save; override;
  public
    constructor Create(AOwner:TComponent); override;
  end;

implementation

{$R *.dfm}

{ TControlEditorMiceMemo }

constructor TControlEditorMiceMemo.Create(AOwner: TComponent);
begin
  inherited;
  ControlClassName:=TMiceMemo.ClassName;
end;

procedure TControlEditorMiceMemo.Load;
begin
  inherited;
  cbSpellCheck.Checked:=ReadProperty('SpellCheck',False);
  cbRemoveDualSpaces.Checked:=ReadProperty('RemoveDualSpaces',True);
  cbTrimOnPost.Checked:=ReadProperty('StringTrim',True);
  cbAcceptTabPaste.Checked:=ReadProperty('AcceptTabPaste',False);
end;

procedure TControlEditorMiceMemo.Save;
begin
  WriteProperty('RemoveDualSpaces',cbRemoveDualSpaces.Checked, True);
  WriteProperty('StringTrim',cbTrimOnPost.Checked, True);
  WriteProperty('SpellCheck',cbSpellCheck.Checked, False);
  WriteProperty('AcceptTabPaste',cbAcceptTabPaste.Checked,False);
  inherited;
end;

initialization
  TControlEditorClassList.RegisterClass(TMiceMemo.ClassName, TControlEditorMiceMemo);

end.
