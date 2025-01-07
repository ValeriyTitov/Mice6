unit Common.Config.ApplicationSettings;

interface

 uses Classes, SysUtils;

 type
  TApplicationSettings = class
   private
    FProxyServer: string;
    FProxyPort: Integer;
    FProxyPassword: string;
    FProxyUser: string;
    FServerAddress: string;
    FPassword: string;
    FUserName: string;
    FFullPathDataRequest: string;
    FFullPathAuthorize: string;
    FFullPathApplyUpdates: string;
    FOsAuth: Boolean;
    FFullPathRefreshToken: string;
    FProjectName: string;
    FConnectionTimeOut: Integer;
    FResponseTimeOut: Integer;
    function RemoveLastComa(const s:string):string;
    procedure SetServerAddress(const Value: string);
   public
    property ServerAddress:string read FServerAddress write SetServerAddress;
    property UserName:string read FUserName write FUserName;
    property Password:string read FPassword write FPassword;
    property OsAuth:Boolean read FOsAuth write FOsAuth;
    property ProjectName:string read FProjectName write FProjectName;
    property ConnectionTimeOut:Integer read FConnectionTimeOut write FConnectionTimeOut;
    property ResponseTimeOut:Integer read FResponseTimeOut write FResponseTimeOut;


    property ProxyServer:string read FProxyServer write FProxyServer;
    property ProxyPort:Integer read FProxyPort write FProxyPort;
    property ProxyUser:string read FProxyUser write FProxyUser;
    property ProxyPassword:string read FProxyPassword write FProxyPassword;

    property FullPathAuthorize:string read FFullPathAuthorize;
    property FullPathDataRequest:string read FFullPathDataRequest;
    property FullPathApplyUpdates:string read FFullPathApplyUpdates;
    property FullPathRefreshToken:string read FFullPathRefreshToken;



    constructor Create;
    procedure LoadFromString(const s:string);
  end;

var
 ApplicationSettings:TApplicationSettings;

implementation

{ TApplicationSettings }

procedure TApplicationSettings.LoadFromString(const s: string);
var
 List:TStringList;
begin
  List:=TStringList.Create;
  try
   List.StrictDelimiter:=True;
   List.Delimiter:=';';
   List.DelimitedText:=s;
   ServerAddress:=RemoveLastComa(List.Values['Server']);
   UserName:=RemoveLastComa(List.Values['UserName']);
   Password:=RemoveLastComa(List.Values['Password']);
   OsAuth:=StrToBoolDef(RemoveLastComa(List.Values['OsAuth']),False);
   ProxyServer:=RemoveLastComa(List.Values['ProxyServer']);
   ProxyPort:=StrToIntDef(RemoveLastComa(List.Values['ProxyPort']),80);
   ConnectionTimeOut:=StrToIntDef(RemoveLastComa(List.Values['ConnectionTimeOut']),10000);
   if ConnectionTimeOut<750 then
    ConnectionTimeOut:=750;
   ResponseTimeOut:=StrToIntDef(RemoveLastComa(List.Values['ResponseTimeOut']),60000*5);
   if ResponseTimeOut<750 then
    ResponseTimeOut:=750;

   ProxyUser:=RemoveLastComa(List.Values['ProxyUser']);
   ProxyPassword:=RemoveLastComa(List.Values['ProxyPassword']);
  finally
    List.Free;
  end;
end;


function TApplicationSettings.RemoveLastComa(const s: string): string;
begin
 if s.EndsWith(';') then
  Result:=s.Substring(0,s.Length-1)
   else
  Result:=s;
end;

procedure TApplicationSettings.SetServerAddress(const Value: string);
begin
  FServerAddress := Value;
  FFullPathApplyUpdates:= FServerAddress+'/Home/MiceApplyUpdatesRequest';
  FFullPathDataRequest:= FServerAddress+'/Home/MiceRequest';
  FFullPathAuthorize:= FServerAddress+'/Home/Authorize';
  FFullPathRefreshToken:=FServerAddress+'/Home/RefreshToken';
end;

{ TApplicationSettings }

constructor TApplicationSettings.Create;
begin
 ConnectionTimeOut:=10000;
 ResponseTimeOut:=60000*5;
end;

initialization
  ApplicationSettings:=TApplicationSettings.Create;
finalization
  ApplicationSettings.Free;
end.
