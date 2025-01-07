unit CustomControl.MiceValuePicker.SelectTreeDlg;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, StaticDialog.ItemTreeSelector.Common,
  cxGraphics, cxLookAndFeels, cxLookAndFeelPainters, Vcl.Menus, cxControls,
  cxCustomData, cxStyles, cxTL, cxMaskEdit, cxTLdxBarBuiltInMenu,
  cxInplaceContainer, cxDBTL, cxTLData, Vcl.StdCtrls, cxButtons, Vcl.ExtCtrls;

type
  TVPickSelectTreeDialog = class(TCommonSelectTreeDialog)
  private
    FAppDialogControlsId: Integer;
  protected
    function DialogSaveName:string; override;
  public
    property AppDialogControlsId: Integer read FAppDialogControlsId write FAppDialogControlsId;
  end;


implementation

{$R *.dfm}

{ TSelectTreeDialog2 }

function TVPickSelectTreeDialog.DialogSaveName: string;
begin
 Result:='MiceValuePicker\AppDialogControlsId='+AppDialogControlsId.ToString;
end;

end.
