unit ControlEditor.MiceCheckBox;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, ControlEditor.Common, cxGraphics,
  cxLookAndFeels, cxLookAndFeelPainters, Vcl.Menus, cxControls, cxContainer,
  cxEdit, dxLayoutcxEditAdapters, Data.DB, dxLayoutContainer, cxClasses,
  cxDropDownEdit, cxButtonEdit, cxDBEdit, cxCheckBox, cxImageComboBox,
  cxTextEdit, cxMaskEdit, dxLayoutControl, Vcl.StdCtrls, cxButtons, Vcl.ExtCtrls,
  CustomControl.MiceCheckBox;

type
  TControlEditorMiceCheckBox = class(TControlEditorBase)
    edChecked: TcxTextEdit;
    edChecked_Item: TdxLayoutItem;
    edUnchecked: TcxTextEdit;
    edUnchecked_Item: TdxLayoutItem;
    edGrayed: TcxTextEdit;
    edGrayed_Item: TdxLayoutItem;
  private

  protected
    procedure Load; override;
    procedure Save; override;
  public
    constructor Create(AOwner:TComponent); override;
  end;


implementation

{$R *.dfm}

{ TControlEditorMiceCheckBox }

constructor TControlEditorMiceCheckBox.Create(AOwner: TComponent);
begin
 inherited;
 ControlClassName:=TMiceCheckBox.ClassName;
end;

procedure TControlEditorMiceCheckBox.Load;
begin
  inherited;
  edChecked.Text:=ReadProperty('CheckedValue','1');
  edUnchecked.Text:=ReadProperty('UncheckedValue','0');
  edGrayed.Text:=ReadProperty('GrayedValue','NULL');
end;

procedure TControlEditorMiceCheckBox.Save;
begin
  WriteProperty('CheckedValue',edChecked.Text,'1');
  WriteProperty('UncheckedValue',edUnchecked.Text,'0');
  WriteProperty('GrayedValue',edGrayed.Text,'NULL');

  inherited;
end;

initialization
  TControlEditorClassList.RegisterClass(TMiceCheckBox.ClassName, TControlEditorMiceCheckBox);

end.
