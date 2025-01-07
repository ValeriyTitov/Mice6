unit Thread.Basic;

interface

uses
  System.Classes, System.SysUtils, System.Variants, ActiveX;

type
  TBasicThread = class(TThread)
  private
    FOnSuccess: TNotifyEvent;
    FOnExecute: TNotifyEvent;
    FOnError: TNotifyEvent;
    FErrorMessage: string;
    FThreadResult: Variant;
    FOnAbort: TNotifyEvent;
    FOnProgress: TNotifyEvent;
    FCurrentProgress: string;
  protected
    procedure HandleException(const AErrorMessage:string);
    procedure DoOnExecute; virtual;
    procedure DoOnError; virtual;
    procedure DoOnSuccess; virtual;
    procedure DoOnAbort; virtual;
    procedure DoOnProgress; virtual;
    procedure InternalExecute; virtual;
    procedure DoTerminate;override;
    procedure Execute; override;
    procedure Progress(const Msg:string);
  public
    property OnExecute:TNotifyEvent read FOnExecute write FOnExecute;
    property OnError:TNotifyEvent read FOnError write FOnError;
    property OnSuccess:TNotifyEvent read FOnSuccess write FOnSuccess;
    property OnProgress: TNotifyEvent read FOnProgress write FOnProgress;
    property OnAbort: TNotifyEvent read FOnAbort;
    property ErrorMessage:string read FErrorMessage;
    property ThreadResult:Variant read FThreadResult write FThreadResult;
    property CurrentProgress:string read FCurrentProgress;
    procedure AbortThread(OnAbort:TNotifyEvent); virtual;

    class function StartThread(AOnExecute, AOnSuccess, AOnError:TNotifyEvent):TBasicThread; overload;
    class function CreateThread(AOnExecute, AOnSuccess, AOnError:TNotifyEvent):TBasicThread; overload;
  end;

implementation

{ BasicThread }

class function TBasicThread.StartThread(AOnExecute, AOnSuccess, AOnError: TNotifyEvent): TBasicThread;
begin
 Result:=CreateThread(AOnExecute, AOnSuccess, AOnError);
 Result.Start;
end;

procedure TBasicThread.AbortThread(OnAbort: TNotifyEvent);
begin
 FOnAbort:=OnAbort;
 Terminate;
end;

class function TBasicThread.CreateThread(AOnExecute, AOnSuccess,  AOnError: TNotifyEvent): TBasicThread;
begin
 Result:=TBasicThread.Create(True);
 Result.OnError:=AOnError;
 Result.OnSuccess:=AOnSuccess;
 Result.OnExecute:=AOnExecute;
 Result.FreeOnTerminate:=True;
end;

procedure TBasicThread.DoOnAbort;
begin
 if Assigned(OnAbort) then
  OnAbort(Self);
end;

procedure TBasicThread.DoOnError;
begin
 if Assigned(OnError) and (not Terminated) and not Assigned(OnAbort) then
  OnError(Self);
end;

procedure TBasicThread.DoOnExecute;
begin
 if Assigned(OnExecute) and (not Terminated) and not Assigned(OnAbort) then
  OnExecute(Self);
end;

procedure TBasicThread.DoOnProgress;
begin
 if Assigned(OnProgress) and (not Terminated) and not Assigned(OnAbort) then
  OnProgress(Self);
end;

procedure TBasicThread.DoOnSuccess;
begin
  if Assigned(OnSuccess) and (not Terminated) and not Assigned(OnAbort) then
   OnSuccess(Self);
end;

procedure TBasicThread.DoTerminate;
begin
 if Assigned(OnAbort) then
   Synchronize(DoOnAbort);
  inherited;
end;


procedure TBasicThread.Execute;
begin
 CoInitialize(nil);
 try
  InternalExecute;
 finally
  CoUninitialize;
 end;
end;


procedure TBasicThread.HandleException(const AErrorMessage: string);
begin
 FErrorMessage:=AErrorMessage;
 Synchronize(DoOnError);
end;

procedure TBasicThread.InternalExecute;
begin
 try
  DoOnExecute;
  Synchronize(DoOnSuccess);
 except on E:Exception do
  HandleException(E.Message);
 end;
end;

procedure TBasicThread.Progress(const Msg: string);
begin
 FCurrentProgress:=Msg;
 Synchronize(DoOnProgress);
end;

end.
