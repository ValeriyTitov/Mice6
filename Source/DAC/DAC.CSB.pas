unit DAC.CSB;

interface
 Uses Classes, SysUtils;

type
 TCSB = class {FireDAC Connection String Builder}
  private
    FPassword:String;
    FUser:String;
    FDataBase:String;
    FDriverID:String;
    FServer:String;
    FOldPassword:String;
    FOS_Auth:String;
    FConnectTimeout:String;
    FSettings:TStringList;
    FConnectionString : String;
    FPooled: string;
    Function GetCSValue(s: String): String;
    Procedure SetPropertyValues;
    Procedure ZeroPropertyValues;
    procedure SetSetting(Name,Value: String);
    function GetNewConnectionString:String;
    procedure EnableIntegratedSecurity;
    procedure DisableIntegratedSecurity;
  public
    Constructor Create;
    Destructor Destroy; Override;

    property DriverID:string read FDriverID write FDriverID;
    property Database:string read FDatabase write FDataBase;
    property Server:string read FServer write FServer;
    property UserName:string read FUser write FUser;
    property Password:string read FPassword write FPassword;
    property OS_Auth:string read FOS_Auth write FOS_Auth;
    property Pooled:string read FPooled write FPooled;

    procedure ParseConnectionString(const Value:string);
    Property GenerateNewConnectionString:String read GetNewConnectionString;
end;

implementation

{
Name=Unnamed;
Server=Localhost\SQLExpress;
Database=WebSite;
User_Name=sa;
Password=qwerty666!;
DriverID=MSSQL
}
constructor TCSB.Create;
begin
  inherited;
  FSettings:=TStringList.Create;
  ZeroPropertyValues;
end;

destructor TCSB.Destroy;
begin
  FSettings.Free;
  inherited;
end;

procedure TCSB.DisableIntegratedSecurity;
begin
  SetSetting('User_Name',FUser);
  SetSetting('Password',FPassword);
  SetSetting('old password',FOldPassword);
  SetSetting('OS_Auth','');
end;

procedure TCSB.EnableIntegratedSecurity;
begin
  SetSetting('User_Name','');
  SetSetting('Password','');
  SetSetting('old password','');
  SetSetting('OS_Auth',FOS_Auth);
end;

function TCSB.GetCSValue(s:string): String;
begin
 Result:=FSettings.Values[s];
end;

function TCSB.GetNewConnectionString: String;
var
 x: Integer;
begin
If Trim(FOS_Auth)='' then
 DisableIntegratedSecurity
  else
 EnableIntegratedSecurity;

SetSetting('Server',FServer);
SetSetting('Database',FDatabase);
SetSetting('DriverID',FDriverID);
SetSetting('Pooled', FPooled);
SetSetting('Connect Timeout',FConnectTimeout);

Result:='';
 for x:=0 to FSettings.Count-1 do
  Result:=Result+FSettings[x]+';';
end;

procedure TCSB.ParseConnectionString(const Value: string);
var
 X:Integer;
 LastX:Integer;
 L:Integer;
begin
 FConnectionString:=Value;
 FSettings.Clear;
 ZeroPropertyValues;
 LastX:=1;
 L:=Length(Value);

 for x:=1 to L do
  if (Value[x]=';') then
   begin
    FSettings.Add(Trim(Copy(Value,LastX,X-LastX)));
    LastX:=X+1;
   end
  else
  if X=L then
   FSettings.Add(Trim(Copy(Value,LastX,L)));

SetPropertyValues;
end;



procedure TCSB.SetPropertyValues;
begin
  FDriverID:=GetCSValue('DriverID');
  FServer:=GetCSValue('Server');
  FDatabase:=GetCSValue('Database');
  FUser:=GetCSValue('User_Name');
  FPassword:=GetCSValue('Password');
  FOldPassword:=GetCSValue('old password');
  FOS_Auth:=GetCSValue('OS_Auth');
  FConnecttimeout:=GetCSValue('Connect Timeout');
  FPooled:=GetCSValue('Pooled');
end;

procedure TCSB.SetSetting(Name, Value: String);
var
 AIndex:Integer;
begin
 AIndex:=FSettings.IndexOfName(Name);
  If AIndex>=0 then
   FSettings.ValueFromIndex[AIndex]:=Trim(Value)
  else
   if Trim(Value)<>'' then
    FSettings.Add(Name+'='+Value);
end;


procedure TCSB.ZeroPropertyValues;
begin
  FPassword:='';
  FUser:='';
  FDataBase:='';
  FDriverID:='';
  FServer:='';
  FOldPassword:='';
  FOS_Auth:='';
  FConnectTimeout:='';
  FConnectionString:='';
end;

end.

