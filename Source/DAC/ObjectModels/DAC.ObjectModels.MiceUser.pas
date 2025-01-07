{$M+}
unit DAC.ObjectModels.MiceUser;

interface
 uses
  System.Classes, System.SysUtils, System.Json,
  DAC.ObjectModels.Token,
  Common.VariantComparator;

type
  TMiceUser=class
   private
    FRoleList: TStringList;
    FUserId: string;
    FToken: TMiceToken;
    FFullName: string;
    FLoaded:Boolean;
    FLoginName: string;
    procedure LoadRoles(jArray:TJsonArray);
   public
    property Token: TMiceToken read FToken;
    procedure FromJsonString(const s:string);
    procedure FromJson(jValue:TJsonValue);
    class function CurrentUserHasToken:Boolean;
    class function CurrentUser:TMiceUser;
    class procedure SetCurrentUser(const Value: TMiceUser);
   published
    property UserId:string read FUserId;
    property FullName: string read FFullName;
    property LoginName: string read FLoginName;
    property RoleList:TStringList read FRoleList;
    function IsInRole(const RoleName:string):Boolean;
    constructor Create;
    destructor Destroy; override;
 end;


implementation

type
 TMiceRoleComparator = class (TInterfacedObject, IRoleComparator)
   function UserIsInRole(const Role:string):Boolean;
 end;

var
 FMiceRoleComparator:TMiceRoleComparator;
 FCurrentUser: TMiceUser;


constructor TMiceUser.Create;
begin
  FRoleList:=TStringList.Create;
  FLoaded:=False;
  FToken:=TMiceToken.Create;
end;


class function TMiceUser.CurrentUser: TMiceUser;
begin
 Result:=FCurrentUser;
end;

destructor TMiceUser.Destroy;
begin
  FToken.Free;
  FRoleList.Free;
  inherited;
end;

procedure TMiceUser.FromJson(jValue: TJsonValue);
var
 jRoles:TJsonArray;
begin
 FFullName:=jValue.GetValue<string>('FullName');
 FUserId:=jValue.GetValue<string>('UserId');
 FLoginName:=jValue.GetValue<string>('LoginName');

 if jValue.TryGetValue('RoleList',jRoles) and (jRoles is TJsonArray) then
  LoadRoles(jRoles);
end;

procedure TMiceUser.FromJsonString(const s: string);
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

function TMiceUser.IsInRole(const RoleName: string): Boolean;
begin
 Result:=FRoleList.IndexOf(RoleName)>=0;
end;


procedure TMiceUser.LoadRoles(jArray: TJsonArray);
var
 jValue:TJsonValue;
begin
 RoleList.Clear;
 for jValue in jArray do
  RoleList.Add(jValue.Value);
end;

class procedure TMiceUser.SetCurrentUser(const Value: TMiceUser);
begin
  FCurrentUser := Value;
end;

class function TMiceUser.CurrentUserHasToken: Boolean;
begin
 Result:=Assigned(FCurrentUser) and (not FCurrentUser.Token.Token.IsEmpty);
end;

{ TMiceRoleComparator }

function TMiceRoleComparator.UserIsInRole(const Role: string): Boolean;
begin
 Result:=(TMiceUser.CurrentUser<>nil) and TMiceUser.CurrentUser.IsInRole(Role);
end;

initialization
  FCurrentUser:=nil;
  FMiceRoleComparator:=TMiceRoleComparator.Create;
  TVariantComparator.DefaultRoleComparator:=FMiceRoleComparator;
finalization

end.
