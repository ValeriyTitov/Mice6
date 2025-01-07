unit DAC.ConnectionMngr;

interface
 uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  System.Generics.Collections, System.Generics.Defaults, System.Json,
//  System.IOUtils,

  Common.Config.ApplicationSettings,
  DAC.ObjectModels.Authorization.Request,
  DAC.ObjectModels.Authorization.Response,
  DAC.ObjectModels.MiceUser,
  DAC.ObjectModels.Token,
  DAC.HttpClient,
  Thread.Basic;

type
  TConnectionManager = class
  private
    FConnectionThread:TBasicThread;
    FResponse:TMiceAuthorizationResponse;
    FConnectionResult:string;
    function GetSequenceServer: string;
    procedure OnTryConnect(Sender:TObject);
  public
    procedure CheckConnectionAsync(OnError, OnSuccess:TNotifyEvent);
    procedure AbortConnection;
    procedure ClearThread;
    procedure PopulateDBNames(Items:TStrings);
    property SequenceServer:string read GetSequenceServer;
    property ConnectionResult:string read FConnectionResult;
    constructor Create;
    destructor Destroy; override;
    function CheckConnection:string;
    procedure SetMetaConnection(const Json:string);
    class function DefaultInstance:TConnectionManager;
  end;

function ConnectionManager:TConnectionManager;

implementation

const
 DefaultSequenceServerName = 'SeqDb';

var
  FConnectionManager:TConnectionManager;

function ConnectionManager:TConnectionManager;
begin
  Result:=FConnectionManager;
end;

{ TConnectionManager }

procedure TConnectionManager.AbortConnection;
begin
 if Assigned(FConnectionThread) then
  FConnectionThread.Terminate;
end;

function TConnectionManager.CheckConnection:string;
var
 FClient: TMiceHttpClient;
 jValue:TJsonValue;
 Request:string;
begin
  FClient:=TMiceHttpClient.Create(nil);
   try
    Request:=TMiceAuthorizationRequest.CreateAuthRequest(ApplicationSettings.UserName, ApplicationSettings.Password);
    //TFile.WriteAllText('C:\AuthRequest.json',Request);
    jValue:= FClient.CreateResponseObject(ApplicationSettings.FullPathAuthorize,Request);
     try
//      TMiceAuthorizationResponse.GetTokenFromJson(jValue);
      Result:=jValue.Format;
     finally
      jValue.Free;
    end;
  finally
    FClient.Free;
  end;
end;

procedure TConnectionManager.CheckConnectionAsync(OnError, OnSuccess: TNotifyEvent);
begin
  FConnectionThread:=TBasicThread.Create(True);
  FConnectionThread.FreeOnTerminate:=True;
  FConnectionThread.OnExecute:=OnTryConnect;
  FConnectionThread.OnError:=OnError;
  FConnectionThread.OnSuccess:=OnSuccess;
  FConnectionThread.Start;
end;

procedure TConnectionManager.ClearThread;
begin
 Self.FConnectionThread:=nil;
end;

constructor TConnectionManager.Create;
begin
 FResponse:=TMiceAuthorizationResponse.Create;
end;

class function TConnectionManager.DefaultInstance: TConnectionManager;
begin
 Result:=FConnectionManager;
end;

destructor TConnectionManager.Destroy;
begin
  inherited;
  FResponse.Free;
end;


function TConnectionManager.GetSequenceServer: string;
begin
 if FResponse.DBNameList.IndexOf(DefaultSequenceServerName)>=0 then
  Result:=DefaultSequenceServerName
   else
  Result:='';
end;

procedure TConnectionManager.OnTryConnect(Sender: TObject);
begin
 FConnectionResult:=CheckConnection;
end;

procedure TConnectionManager.PopulateDBNames(Items: TStrings);
begin
 Items.Text:=Self.FResponse.DBNameList.Text;
end;

procedure TConnectionManager.SetMetaConnection(const Json: string);
var
  jValue:TJsonValue;
begin
  jValue:=TJsonObject.ParseJSONValue(Json);
  try
   FResponse.FromJson(jValue);
   TMiceUser.SetCurrentUser(FResponse.MiceUser);
   TMiceUser.CurrentUser.Token.LoadFrom(FResponse.Token);
  finally
    jValue.Free;
  end;
end;


initialization
  FConnectionManager:=TConnectionManager.Create;
finalization
  FConnectionManager.Free;
end.
