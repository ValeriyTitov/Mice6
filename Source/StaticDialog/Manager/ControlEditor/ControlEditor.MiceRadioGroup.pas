unit ControlEditor.MiceRadioGroup;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, ControlEditor.Common, cxGraphics,
  cxLookAndFeels, cxLookAndFeelPainters, Vcl.Menus, cxControls, cxContainer,
  cxEdit, dxLayoutcxEditAdapters, Data.DB, dxLayoutContainer, cxClasses,
  cxButtonEdit, cxDBEdit, cxCheckBox, cxTextEdit, cxMaskEdit, cxDropDownEdit,
  cxImageComboBox, dxLayoutControl, Vcl.StdCtrls, cxButtons, Vcl.ExtCtrls,
  CustomControl.MiceRadioGroup, CustomControl.MiceDropDown.EditorFrame,
  cxSpinEdit;

type
  TControlEditMiceRadioGroup = class(TControlEditorBase)
    ddFrame: TDropDownEditorFrame;
    item_ddFrame: TdxLayoutItem;
    dxLayoutGroup1: TdxLayoutGroup;
    seColumnsN: TcxSpinEdit;
    item_seColumnsN: TdxLayoutItem;
  protected
    procedure Load; override;
    procedure Save; override;
  public
    constructor Create(AOwner:TComponent); override;
  end;


implementation

{$R *.dfm}

{ TControlEditMiceRadioGroup }

constructor TControlEditMiceRadioGroup.Create(AOwner: TComponent);
begin
  inherited;
  ControlClassName:=TMiceRadioGroup.ClassName;
end;

procedure TControlEditMiceRadioGroup.Load;
begin
  inherited;
  ddFrame.LoadFromMiceAppObject(MiceAppObject);
  seColumnsN.Value:=ReadProperty('Columns',1);
end;

procedure TControlEditMiceRadioGroup.Save;
begin
  WriteProperty('Columns',seColumnsN.Value,0);
  ddFrame.SaveToMiceMiceAppObject(MiceAppObject);
  inherited;
end;

initialization
  TControlEditorClassList.RegisterClass(TMiceRadioGroup.ClassName, TControlEditMiceRadioGroup);

end.
