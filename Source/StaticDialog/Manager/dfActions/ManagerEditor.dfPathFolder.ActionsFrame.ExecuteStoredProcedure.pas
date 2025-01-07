unit ManagerEditor.dfPathFolder.ActionsFrame.ExecuteStoredProcedure;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  ManagerEditor.dfPathFolder.ActionsFrame.CommonDialog, cxGraphics,
  cxLookAndFeels, cxLookAndFeelPainters, Vcl.Menus, cxControls, cxContainer,
  cxEdit, dxLayoutcxEditAdapters, dxLayoutControlAdapters, dxLayoutContainer,
  Data.DB, cxClasses, Vcl.StdCtrls, Vcl.ExtCtrls, cxDropDownEdit,
  cxImageComboBox, cxDBEdit, cxMemo, Vcl.DBCtrls, cxTextEdit, cxMaskEdit,
  cxButtonEdit, dxLayoutControl, cxButtons, Vcl.Buttons,
  StaticDialog.AppObjectSelector,
  Manager.WindowManager,
  Common.Images;

type
  TdfActionsExecuteStoredProcedureDialog = class(TCommonDfActionsDialog)
    cbDBName: TcxDBComboBox;
    Item_cbDBName: TdxLayoutItem;
    edbProviderName: TcxDBButtonEdit;
    item_edbProviderName: TdxLayoutItem;
    dxLayoutLabeledItem1: TdxLayoutLabeledItem;
    procedure edbProviderNamePropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
  private
    { Private declarations }
  public
    constructor Create(AOwner:TComponent); override;
  end;


implementation

{$R *.dfm}

constructor TdfActionsExecuteStoredProcedureDialog.Create(AOwner: TComponent);
resourcestring
  S_DFACTION_CAPTION_STOREDPROC = 'Execute stored procedure';
begin
  inherited;
  ActionType:=ACTION_TYPE_SEND_STOREDPROC;
  ImageIndex:=IMAGEINDEX_ITYPE_DFACTION_STOREDPROC;
  DefaultCaption:=S_DFACTION_CAPTION_STOREDPROC;
end;

procedure TdfActionsExecuteStoredProcedureDialog.edbProviderNamePropertiesButtonClick(
  Sender: TObject; AButtonIndex: Integer);
var
 ID:integer;
 s:string;
begin
 if TSysObjectSelectionDialog.ExecuteDialog(iTypeStoredProc,ID,s,cbDBName.Text) then
  DataSet.FieldByName('ProviderName').AsString:=s;
end;

initialization
 TCommonDfActionsDialog.RegisterActionEditor(ACTION_TYPE_SEND_STOREDPROC, TdfActionsExecuteStoredProcedureDialog);


end.
