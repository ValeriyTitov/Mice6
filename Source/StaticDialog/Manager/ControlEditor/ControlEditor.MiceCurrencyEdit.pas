unit ControlEditor.MiceCurrencyEdit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, ControlEditor.Common, cxGraphics,
  cxLookAndFeels, cxLookAndFeelPainters, Vcl.Menus, cxControls, cxContainer,
  cxEdit, dxLayoutcxEditAdapters, Data.DB, dxLayoutContainer, cxClasses,
  cxDropDownEdit, cxButtonEdit, cxDBEdit, cxCheckBox, cxTextEdit, cxMaskEdit,
  cxImageComboBox, dxLayoutControl, Vcl.StdCtrls, cxButtons, Vcl.ExtCtrls,
  CustomControl.MiceCurrencyEdit;

type
  TControlEditorMiceCurrencyEdit = class(TControlEditorBase)
  protected
    procedure Load; override;
    procedure Save; override;
  public
    constructor Create(AOwner: TComponent); override;
  end;

implementation

{$R *.dfm}

{ TControlEditorBase2 }

constructor TControlEditorMiceCurrencyEdit.Create(AOwner: TComponent);
begin
  inherited;
  ControlClassName := TMiceCurrencyEdit.ClassName;
end;

procedure TControlEditorMiceCurrencyEdit.Load;
begin
  inherited;

end;

procedure TControlEditorMiceCurrencyEdit.Save;
begin
  inherited;

end;

initialization
TControlEditorClassList.RegisterClass(TMiceCurrencyEdit.ClassName,  TControlEditorMiceCurrencyEdit);

end.
