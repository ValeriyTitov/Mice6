unit ManagerEditor.dfPathFolder.ActionsFrame.SendEmail;

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
  Common.Images,
  DAC.XDataSet,
  DAC.DatabaseUtils,
  DAC.ConnectionMngr;

type
  TDfActionsEmailDialog = class(TCommonDfActionsDialog)
    edMailTo: TcxDBTextEdit;
    item_MailTo: TdxLayoutItem;
    edSubject: TcxDBTextEdit;
    item_Subject: TdxLayoutItem;
    memoBody: TcxDBMemo;
    item_Body: TdxLayoutItem;
    ddMessageType: TcxDBImageComboBox;
    item_MessageType: TdxLayoutItem;
  private
    FDetails:TxDataSet;
  public
    procedure Initialize; override;
    constructor Create(AOwner: TComponent);override;
  end;

implementation

{$R *.dfm}

{ TDfActionsEmailDialog }

constructor TDfActionsEmailDialog.Create(AOwner: TComponent);
resourcestring
  S_DFACTION_CAPTION_SENDMESSAGE = 'New message';
begin
  inherited;
  ActionType:=ACTION_TYPE_SEND_MAIL;
  ImageIndex:=IMAGEINDEX_ITYPE_DFACTION_MAIL;
  DetailSource.DataSet:=AddDetailTable('dfActionsMessages','','','TDfActionsEmailDialog.Create',sq_dfActionsMessages,SeqDb).DataSet;
  FDetails:=(DetailSource.DataSet as TxDataSet);
  FDetails.SequenceDBName:=ConnectionManager.SequenceServer;
  DefaultCaption:=S_DFACTION_CAPTION_SENDMESSAGE;
end;


procedure TDfActionsEmailDialog.Initialize;
begin
  FDetails.DBName:=Self.DBName;
  inherited;
end;

initialization
 TCommonDfActionsDialog.RegisterActionEditor(ACTION_TYPE_SEND_MAIL, TDfActionsEmailDialog);


end.
