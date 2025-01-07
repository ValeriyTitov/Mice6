unit DAC.ObjectModels.Token;


interface
 uses
  System.Classes, System.SysUtils, System.Json, DateUtils,
  DAC.ObjectModels.Exception;

type
  TMiceToken=class
   private
    FRefreshToken: string;
    FExpireInMinutes: Integer;
    FToken: string;
    FValidThru: TDateTime;
    FCreatedOn: TDateTime;
    procedure CalculateExpiration;
   public
    property Token:string read FToken write FToken;
    property RefreshToken:string read FRefreshToken write FRefreshToken;
    property ExpireInMinutes:Integer read FExpireInMinutes write FExpireInMinutes;
    property ValidThru:TDateTime read FValidThru;
    property CreatedOn:TDateTime read FCreatedOn;

    procedure LoadFrom(AToken:TMiceToken);
    procedure FromJsonString(const s:string);
    procedure FromJson(jValue:TJsonValue);
    procedure ToJsonObject(jObject:TJsonObject);
    function ToJsonString:string;
    function Expired:Boolean;
 end;


implementation

{ TMiceToken }

procedure TMiceToken.CalculateExpiration;
begin
 FCreatedOn:=Now;
 FValidThru:=IncMinute(FCreatedOn,ExpireInMinutes);
 FValidThru:=IncSecond(FValidThru,-20);
end;

function TMiceToken.Expired: Boolean;
begin
 Result:=Now>ValidThru;
end;

procedure TMiceToken.FromJson(jValue: TJsonValue);
begin
try
 Token:=jValue.GetValue<string>('Token');
 RefreshToken:=jValue.GetValue<string>('RefreshToken');
 ExpireInMinutes:=jValue.GetValue<Integer>('ExpireInMinutes');
 CalculateExpiration;
 except on E:Exception do
  raise Exception.Create(E.Message+#13+jValue.Format);
 end;
end;

procedure TMiceToken.FromJsonString(const s: string);
var
 jValue:TJsonValue;
begin
 jValue:=TJsonObject.ParseJSONValue(s);
 try
  Self.FromJson(jValue);
 finally
  jValue.Free;
 end;
end;

procedure TMiceToken.LoadFrom(AToken: TMiceToken);
begin
 Token:=AToken.Token;
 RefreshToken:=AToken.RefreshToken;
 ExpireInMinutes:=AToken.ExpireInMinutes;
 CalculateExpiration;
end;

procedure TMiceToken.ToJsonObject(jObject: TJsonObject);
begin
  jObject.AddPair('Token',Token);
  jObject.AddPair('RefreshToken',RefreshToken);
  jObject.AddPair('ExpireInMinutes',TJsonNumber.Create(ExpireInMinutes));
end;

function TMiceToken.ToJsonString: string;
var
 jObject:TJsonObject;
begin
 jObject:=TJsonObject.Create;
 try
  ToJsonObject(jObject);
  Result:=jObject.Format;
 finally
   jObject.Free;
 end;
end;

end.
