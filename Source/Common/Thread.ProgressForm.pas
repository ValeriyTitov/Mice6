unit Thread.ProgressForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, cxGraphics, cxLookAndFeels,
  cxLookAndFeelPainters, Vcl.Menus, cxControls, cxContainer, cxEdit,
  cxProgressBar, Vcl.StdCtrls, cxButtons, Vcl.ExtCtrls, Data.DB,
  Thread.Basic;

type
  TThreadProgressForm = class(TForm)
    pnTop: TPanel;
    pnMid: TPanel;
    pnBottom: TPanel;
    lbUserMessage: TLabel;
    bnAll: TcxButton;
    cxProgressBar1: TcxProgressBar;
  private
    FAutoCloseOnSuccsess: Boolean;
    FUserMessage: string;
    procedure SetUserMessage(const Value: string);
    procedure DoExecute(DataSet:TDataSet);
  public
    property AutoCloseOnSuccsess:Boolean read FAutoCloseOnSuccsess write FAutoCloseOnSuccsess;
    property UserMessage:string read FUserMessage write SetUserMessage;
  end;

implementation

{$R *.dfm}

{ TThreadProgressForm }

procedure TThreadProgressForm.DoExecute(DataSet: TDataSet);
begin
 DataSet.DisableControls;
  while not DataSet.Eof do
   begin
     DataSet.Next;
   end;
end;

procedure TThreadProgressForm.SetUserMessage(const Value: string);
begin
  lbUserMessage.Caption:=Value;
end;

end.
