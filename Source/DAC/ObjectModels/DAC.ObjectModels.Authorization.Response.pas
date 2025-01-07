unit DAC.ObjectModels.Authorization.Response;

interface
 uses
  System.Classes, System.SysUtils, System.Json,
  DAC.ObjectModels.Token,
  DAC.ObjectModels.Exception,
  DAC.ObjectModels.MiceUser;

 type

  TMiceAuthorizationResponse = class
   private
    FToken: TMiceToken;
    FDBNameList: TStringList;
    FMiceUser: TMiceUser;
    procedure LoadDBNamesList(jArray:TJsonArray);
   public
    property Token:TMiceToken read FToken;

    property DBNameList:TStringList read FDBNameList;
    property MiceUser:TMiceUser read FMiceUser;

    procedure FromJsonString(const s:string);
    procedure FromJson(jValue:TJsonValue);
    constructor Create;
    destructor Destroy; override;

  end;

implementation

{ TMiceAuthorizationResponse }

constructor TMiceAuthorizationResponse.Create;
begin
 FMiceUser:=TMiceUser.Create;
 FDBNameList:=TStringList.Create;
 FToken:=TMiceToken.Create;
end;

destructor TMiceAuthorizationResponse.Destroy;
begin
  FMiceUser.Free;
  FDBNameList.Free;
  FToken.Free;
  inherited;
end;

procedure TMiceAuthorizationResponse.FromJson(jValue: TJsonValue);
var
 jUser:TJsonObject;
 jDBName:TJsonArray;
 jToken:TJsonObject;
begin
 EDACException.CheckForException(jValue);

 jToken:=jValue.GetValue<TJsonObject>('Token');
 Token.FromJson(jToken);

 jUser:=jValue.GetValue<TJsonObject>('MiceUser');
 MiceUser.FromJson(jUser);

 jDBName:=jValue.GetValue<TJsonArray>('DBNameList');
 LoadDBNamesList(jDBName);
end;

procedure TMiceAuthorizationResponse.FromJsonString(const s: string);
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


procedure TMiceAuthorizationResponse.LoadDBNamesList(jArray: TJsonArray);
var
 jValue:TJsonValue;
begin
 for jValue in jArray do
  DBNameList.Add(jValue.Value);
end;

end.
