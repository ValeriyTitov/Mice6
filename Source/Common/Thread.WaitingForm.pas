unit Thread.WaitingForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, cxGraphics, cxLookAndFeels,
  cxLookAndFeelPainters, Vcl.Menus, Vcl.StdCtrls, cxButtons, cxControls,
  dxActivityIndicator, Vcl.ExtCtrls, cxContainer, cxEdit, cxTextEdit, cxMemo,
  Thread.Basic,
  Common.ResourceStrings;

type
  TThreadWaitingForm = class(TForm)
    pnMain: TPanel;
    Indicator: TdxActivityIndicator;
    pnBottom: TPanel;
    pnError: TPanel;
    bnClose: TcxButton;
    memoError: TcxMemo;
    pnInfo: TPanel;
    lbInfo: TLabel;
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure bnCloseClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    FThread:TBasicThread;
    FAutoClose: Boolean;
    FHandleErrors: Boolean;
    FHadErrors: Boolean;
    FUserAbort: Boolean;
  protected
    FBasicHeight:Integer;
    procedure OnThreadError(Sender:TObject);
    procedure OnThreadSuccess(Sender:TObject);
    procedure OnThreadAbort(Sender:TObject);
    procedure OnThreadTerminate(Sender:TObject);
    procedure OnThreadProgress(Sender:TObject);
    procedure SetError(const Msg:string);
    procedure SetProgress(const Msg:string);
    procedure UpdateHeight;
  public
    procedure Start(const Thread:TBasicThread; AutoClose, HandleErrors:Boolean); overload;
    property AutoClose:Boolean read FAutoClose write FAutoClose;
    property HandleErrors:Boolean read FHandleErrors write FHandleErrors;
    property HadErrors:Boolean read FHadErrors write FHadErrors;
    property UserAbort:Boolean read FUserAbort write FUserAbort;
    constructor Create(AOwner:TComponent); override;
    destructor Destroy; override;
    class function StartThread(const Thread:TBasicThread; AutoClose, HandleErrors:Boolean):Boolean; overload;
  end;


implementation

{$R *.dfm}

{ TThreadWaitingForm }



constructor TThreadWaitingForm.Create(AOwner: TComponent);
begin
  inherited;
  HadErrors:=False;
  UserAbort:=False;
  FBasicHeight:=Height-pnError.Height;
  lbInfo.Caption:=string.Empty;
  Height:=FBasicHeight;
  AutoClose:=False;
  HandleErrors:=True;
end;

destructor TThreadWaitingForm.Destroy;
begin
  inherited;
end;

procedure TThreadWaitingForm.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
 CanClose:=not Assigned(FThread);
end;

procedure TThreadWaitingForm.FormShow(Sender: TObject);
begin
 bnClose.Left := pnBottom.Width div 2 - bnClose.Width div 2;
end;

procedure TThreadWaitingForm.bnCloseClick(Sender: TObject);
begin
 if Assigned(FThread) then
  begin
   SetProgress(S_COMMON_ABORTING);
   bnClose.Enabled:=False;
   FThread.AbortThread(OnThreadAbort);
  end
   else
    Close;
end;

procedure TThreadWaitingForm.OnThreadAbort(Sender: TObject);
begin
 FUserAbort:=True;
 Indicator.Active:=False;
 SetProgress(S_COMMON_OPERATION_CANCELED);
 bnClose.Enabled:=True;
 bnClose.Caption:=S_COMMON_CLOSE;
end;

procedure TThreadWaitingForm.OnThreadError(Sender: TObject);
begin
 HadErrors:=True;
 if HandleErrors then
  SetError(FThread.ErrorMessage);
end;


procedure TThreadWaitingForm.OnThreadProgress(Sender: TObject);
begin
 if Assigned(FThread) then
  SetProgress(FThread.CurrentProgress);
end;

procedure TThreadWaitingForm.OnThreadSuccess(Sender: TObject);
begin
 HadErrors:=False;
 Indicator.Active:=False;
 bnClose.Caption:=S_COMMON_OK;
 FThread.OnTerminate:=nil;
 FThread:=nil;
 if AutoClose then
  Close;
end;

procedure TThreadWaitingForm.OnThreadTerminate(Sender: TObject);
begin
 FThread:=nil;
end;


procedure TThreadWaitingForm.SetError(const Msg: string);
begin
 Indicator.Active:=False;
 bnClose.Enabled:=True;
 bnClose.Caption:=S_COMMON_CLOSE;
 memoError.Lines.Text:=Msg;
 pnError.Visible:=True;
 UpdateHeight;
end;


procedure TThreadWaitingForm.SetProgress(const Msg: string);
begin
 lbInfo.Caption:=Msg;
 UpdateHeight;
end;


procedure TThreadWaitingForm.Start(const Thread: TBasicThread; AutoClose, HandleErrors:Boolean);
begin
 Self.AutoClose:=AutoClose;
 Self.HandleErrors:=HandleErrors;
 FThread:=Thread;
 FThread.OnProgress:=OnThreadProgress;
 FThread.OnTerminate:=OnThreadTerminate;
 FThread.OnSuccess:=OnThreadSuccess;
 FThread.OnError:=OnThreadError;
 Indicator.Active:=True;
 FThread.Start;
end;


class function TThreadWaitingForm.StartThread(const Thread: TBasicThread; AutoClose, HandleErrors:Boolean):Boolean;
var
 Dlg:TThreadWaitingForm;
begin
  Dlg:=TThreadWaitingForm.Create(nil);
  try
   Dlg.Caption:=Thread.ThreadResult;
   Dlg.Start(Thread, AutoClose, HandleErrors);
   Dlg.ShowModal;
   Result:=Dlg.HadErrors=False;
  finally
   Dlg.Free;
  end;
end;


procedure TThreadWaitingForm.UpdateHeight;
var
 AddHeight:Integer;
begin
 AddHeight:=0;
 if pnError.Visible then
  AddHeight:=pnError.Height;
 Height:=FBasicHeight+AddHeight;
end;

end.
