unit CustomControl.MiceValuePicker.SelectItemDlg;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, StaticDialog.ItemSelector.Common,
  cxGraphics, cxLookAndFeels, cxLookAndFeelPainters, Vcl.Menus, cxControls,
  cxContainer, cxEdit, Vcl.ExtCtrls, Vcl.StdCtrls, Vcl.WinXCtrls, cxTextEdit,
  cxMaskEdit, cxDropDownEdit, cxImageComboBox, Vcl.ComCtrls, cxButtons;

type
  TVPickSelectItemDialog = class(TCommonItemSelectorDlg)
  private
    FAppDialogControlsId: Integer;
  protected
    function DialogSaveName:string; override;
  public
    property AppDialogControlsId: Integer read FAppDialogControlsId write FAppDialogControlsId;
  end;


implementation

{$R *.dfm}

{ TVPickSelectItemDialog }

function TVPickSelectItemDialog.DialogSaveName: string;
begin
 Result:='MiceValuePicker\AppDialogControlsId='+AppDialogControlsId.ToString;
end;

end.
