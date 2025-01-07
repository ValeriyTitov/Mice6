unit DAC.ObjectModels.Authorization.Request;

interface
uses
  System.Classes, System.SysUtils, System.Json, DAC.ObjectModels.Exception;


type
  TMiceAuthorizationRequest = class
  private
    FPassword: string;
    FUserName: string;
  public
    property UserName:string read FUserName write FUserName;
    property Password:string read FPassword write FPassword;
    procedure ToJson(jObject:TJsonObject);
    function ToJsonString:string;
    class function CreateAuthRequest(const UserName, Password:string):string;
  end;



implementation


class function TMiceAuthorizationRequest.CreateAuthRequest(const UserName, Password: string): string;
var
 Request:TMiceAuthorizationRequest;
begin
 Request:=TMiceAuthorizationRequest.Create;
 try
  Request.UserName:=UserName;
  Request.Password:=Password;
  Result:=Request.ToJsonString;
 finally
  Request.Free;
 end;

end;

procedure TMiceAuthorizationRequest.ToJson(jObject: TJsonObject);
begin
 jObject.AddPair('UserName',UserName);
 jObject.AddPair('Password',Password);
end;

function TMiceAuthorizationRequest.ToJsonString: string;
var
 jObject:TJsonObject;
begin
 jObject:=TJsonObject.Create;
 try
  Self.ToJson(jObject);
  Result:=jObject.Format;
 finally
   jObject.Free;
 end;
end;
end.
