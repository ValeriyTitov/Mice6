unit DAC.HttpClient;

interface
uses
 System.Net.URLClient, System.Classes, System.SysUtils, System.Net.HttpClient,
 System.Net.HttpClientComponent, System.Json, System.IOUtils,
 DAC.ObjectModels.MiceUser,
 Common.Config.ApplicationSettings;

type
 TMiceHttpClient = class(TNetHTTPClient)
 public
  constructor Create(AOwner:TComponent); override;
  destructor Destroy; override;
  function CreateResponseObject(const CompleteUrl,  Request: string): TJsonValue;
 end;


implementation
const
 AuthHeader = 'Authorization:Bearer';

{ TMiceHttpClient }

constructor TMiceHttpClient.Create(AOwner: TComponent);
begin
  inherited;
  Self.ResponseTimeout:=ApplicationSettings.ResponseTimeOut;
  Self.ConnectionTimeout:=ApplicationSettings.ConnectionTimeOut;

  if not ApplicationSettings.ProxyServer.Trim.IsEmpty then
   ProxySettings := TProxySettings.Create(ApplicationSettings.ProxyServer,ApplicationSettings.ProxyPort , ApplicationSettings.ProxyUser, ApplicationSettings.ProxyPassword);

  Accept:='application/json, text/javascript, */*; q=0.01';
  ContentType:='application/json; charset=UTF-8';
end;

function TMiceHttpClient.CreateResponseObject(const CompleteUrl,  Request: string): TJsonValue;
var
 RequestStream:TStringStream;
 ResponseStream:TStringStream;
 HttpCode:Integer;
resourcestring
 E_ERROR_RETRIVING_DATA_OBJECT = 'Error retriving data object (Application server returned invalid Json: %s), StatusCode=%d';

begin
RequestStream:=TStringStream.Create(Request, TEncoding.UTF8);

 if TMiceUser.CurrentUserHasToken then
    CustHeaders[AuthHeader]:=TMiceUser.CurrentUser.Token.Token;
  if TMiceUser.CurrentUserHasToken then
    CustHeaders[AuthHeader]:=TMiceUser.CurrentUser.Token.Token;
     if TMiceUser.CurrentUserHasToken then
    CustHeaders[AuthHeader]:=TMiceUser.CurrentUser.Token.Token;
 try
  ResponseStream:=TStringStream.Create('',TEncoding.UTF8);
  try
   HttpCode:=Post(CompleteUrl,RequestStream,ResponseStream).StatusCode;
   Result:=TJsonObject.ParseJSONValue(ResponseStream.DataString);
// TFile.WriteAllText('C:\Request.json',Request);
// TFile.WriteAllText('C:\Response.json',ResponseStream.DataString);

   if not Assigned(Result) then
    begin
     try
//      TFile.WriteAllText('C:\RequestFailure.json',Request);
//      TFile.WriteAllText('C:\ResponseFailure.txt',ResponseStream.DataString);
     except
     end;
     raise Exception.CreateFmt(E_ERROR_RETRIVING_DATA_OBJECT,[ResponseStream.DataString,HttpCode]);
    end;
  finally
   ResponseStream.Free;
  end;
 finally
  RequestStream.Free;
 end;
end;

destructor TMiceHttpClient.Destroy;
begin
  inherited;
end;

end.
