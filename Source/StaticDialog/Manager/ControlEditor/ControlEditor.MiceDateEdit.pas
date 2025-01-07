unit ControlEditor.MiceDateEdit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, ControlEditor.Common, cxGraphics,
  cxLookAndFeels, cxLookAndFeelPainters, Vcl.Menus, cxControls, cxContainer,
  cxEdit, dxLayoutcxEditAdapters, Data.DB, dxLayoutContainer, cxClasses,
  cxDropDownEdit, cxButtonEdit, cxDBEdit, cxCheckBox, cxImageComboBox,
  cxTextEdit, cxMaskEdit, dxLayoutControl, Vcl.StdCtrls, cxButtons, Vcl.ExtCtrls,
  CustomControl.MiceDateEdit, Vcl.ComCtrls, dxCore, cxDateUtils, cxCalendar;

type
  TControlEditorMiceDateEdit = class(TControlEditorBase)
    cbAcceptTabPaste: TcxCheckBox;
    dxLayoutItem1: TdxLayoutItem;
    cbShowClearButton: TcxCheckBox;
    dxLayoutItem2: TdxLayoutItem;
    cbShowTodayButton: TcxCheckBox;
    dxLayoutItem3: TdxLayoutItem;
    cbSaveTime: TcxCheckBox;
    dxLayoutItem4: TdxLayoutItem;
    cbShowTime: TcxCheckBox;
    dxLayoutItem5: TdxLayoutItem;
    dxLayoutGroup1: TdxLayoutGroup;
    dxLayoutGroup2: TdxLayoutGroup;
  private
  protected
    procedure Load; override;
    procedure Save; override;
  public
    constructor Create(AOwner:TComponent); override;
   end;


implementation

{$R *.dfm}

{ TControlEditorMiceDateEdit }

constructor TControlEditorMiceDateEdit.Create(AOwner: TComponent);
begin
  inherited;
  ControlClassName:=TMiceDateEdit.ClassName;

end;

procedure TControlEditorMiceDateEdit.Load;
begin
  inherited;
  cbAcceptTabPaste.Checked:=ReadProperty('AcceptTabPaste',False);
  cbShowClearButton.Checked:=ReadProperty('ShowClearButton',False);
  cbShowTodayButton.Checked:=ReadProperty('ShowTodayButton',False);
  cbShowTime.Checked:=ReadProperty('ShowTime',False);
  cbSaveTime.Checked:=ReadProperty('SaveTime',False);
end;

procedure TControlEditorMiceDateEdit.Save;
begin
  WriteProperty('AcceptTabPaste',cbAcceptTabPaste.Checked,False);
  WriteProperty('ShowClearButton',cbShowClearButton.Checked,False);
  WriteProperty('ShowTodayButton',cbShowTodayButton.Checked,False);
  WriteProperty('ShowTime',cbShowTime.Checked,False);
  WriteProperty('SaveTime',cbSaveTime.Checked,False);
  inherited;
end;

initialization
  TControlEditorClassList.RegisterClass(TMiceDateEdit.ClassName, TControlEditorMiceDateEdit);

end.
