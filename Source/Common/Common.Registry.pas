unit Common.Registry;

interface
 uses IniFiles, SysUtils, Registry, Windows, Classes,
 Vcl.Forms, Vcl.Controls,
 System.Math,
 dxLayoutContainer,
 dxLayoutControl;

const
 DefaultIniFile = 'config.ini';
 RegistryPathBase ='\Software\Mice6\';
 RegistryPathUserData = RegistryPathBase+'UserData\';

 RegistryPathProject =    RegistryPathBase+'Project\';
 RegistryPathPlugins = RegistryPathUserData+'Plugins\';
 RegistryPathDialogs = RegistryPathUserData+'Dialogs\';
 RegistryPathReports = RegistryPathUserData+'Reports\'; // обязательно должно начинаться с \Software\
 //frxClass.pas: if Pos('\Software\', FIniFile) = 1 then




 RegKeyLastPath = 'LastPath';



 type
  TProjectRegistry = class
   private
    FRegistry: TRegistry;
   public
    function ReadIntDef(const Path,Key:string; Default:Integer):Integer;
    function WriteInt(const Path,Key:string;Value:Integer):Boolean;
    function ReadStringDef(const Path,Key:string; Default:string):string;
    function WriteString(const Path,Key,Value:string):Boolean;
    function ReadBool(const Path,Key:string; Default:Boolean):Boolean;
    function WriteBool(const Path,Key:string;Value:Boolean):Boolean;
    function IniReadStr(const Section,Value,DefaultValue:string):string;
    function IniReadInt(const Section,Value:string; DefaultValue:Integer):Integer;
    function DialogPath(const Key:string):string;

    procedure GetKeyNames(const Path:string; List:TStrings);
    procedure DeleteKeys(const Path:string);
    procedure SaveSplitters(Layout:TdxLayoutControl);
    procedure Clear;

    procedure SaveForm(const Key:string; Form:TForm);
    procedure LoadForm(const Key:string; LoadPosition, LoadSize:Boolean; Form:TForm);

    property Registry:TRegistry read FRegistry;
    constructor Create;
    destructor Destroy; override;
    class function DefaultInstance:TProjectRegistry;
  end;



implementation

const
 ATop = 'Top';
 ALeft = 'Left';
 AHeight = 'Height';
 AWidth = 'Width';
 AWindowState = 'WindowState';

var
FDefaultInstance:TProjectRegistry;
IniFileName:string = DefaultIniFile;



function TProjectRegistry.IniReadStr(const Section,Value,DefaultValue:string):string;
var
 AFile:TIniFile;
begin
AFile:=TIniFile.Create(IniFileName);
 try
  Result := AFile.Readstring(Section,Value, DefaultValue);
 finally
  AFile.Free;
 end;
end;



function TProjectRegistry.IniReadInt(const Section,Value:string; DefaultValue:Integer):Integer;
var
 AFile:TIniFile;
begin
 AFile:=TIniFile.Create(IniFileName);
  try
   try
    Result := StrToInt(AFile.Readstring(Section,Value, IntToStr(DefaultValue)));
    except on E:Exception do
     Result:=DefaultValue;
    end;
  finally
   AFile.Free;
  end;
end;


function TProjectRegistry.ReadIntDef(const Path,Key:string; Default:Integer):Integer;
var
  Registry: TRegistry;
begin
  Registry:=TRegistry.Create;
 try
  Registry.RootKey:=HKEY_CURRENT_USER;
  if  Registry.OpenKey(Path,False) then
  begin
   try
    If Registry.ValueExists(Key) then
     Result :=Registry.ReadInteger(Key)
      else
     Result:=Default;
    except
     Result:=Default;
    end;
   end
   else Result:=Default;
  Finally
   Registry.Free;
  end;
end;


function TProjectRegistry.WriteInt(const Path,Key:string;Value:Integer):Boolean;
var
  Registry: TRegistry;
begin
  Result:=False;
  Registry := TRegistry.Create;
   try
    try
     Registry.RootKey := HKEY_CURRENT_USER;
     if Registry.OpenKey(Path, True) then
      begin
       Registry.WriteInteger(Key,Value);
       Registry.CloseKey;
       Result:=True;
      end;
    except
     Result:=False;
    end;
  finally
    Registry.Free;
  end;
end;


function TProjectRegistry.ReadStringDef(const Path,Key:string; Default:string):string;
var
  Registry: TRegistry;
begin
  Registry:=TRegistry.Create;
 try
  Registry.RootKey:=HKEY_CURRENT_USER;
  if Registry.OpenKey(Path,False) then
  begin
   try
    If Registry.ValueExists(Key) then
     Result :=Registry.Readstring(Key)
      else
     Result:=Default;
    except
     Result:=Default;
    end;
   end
   else
    Result:=Default;
  Finally
   Registry.Free;
  end;
end;

procedure TProjectRegistry.SaveSplitters(Layout: TdxLayoutControl);
begin

end;


procedure TProjectRegistry.SaveForm(const Key: string; Form: TForm);
var
 Path:string;
begin
  Path:=DialogPath(Key);
  WriteInt(Path,AWindowState,Integer(Form.WindowState));
  if Form.WindowState=TWindowState.wsNormal then
   begin
    WriteInt(Path,AWidth,Form.Width);
    WriteInt(Path,AHeight,Form.Height);
    WriteInt(Path,ALeft,Form.Left);
    WriteInt(Path,ATop,Form.Top);
  end;
end;

procedure TProjectRegistry.LoadForm(const Key: string; LoadPosition, LoadSize: Boolean;  Form: TForm);
var
 Path:string;
 NewState:TWindowState;
begin
  Path:=DialogPath(Key);
 if LoadPosition then
  begin
   Form.Position:=TPosition.poDesigned;
   Form.Top:=ReadIntDef(Path, ATop, Form.Top);
   Form.Left:=ReadIntDef(Path, ALeft, Form.Left);
  end;

 if LoadSize then
  begin
  NewState:=TWindowState(ReadIntDef(Path, AWindowState, Integer(Form.WindowState)));
  if NewState=TWindowState.wsMinimized then
   NewState:=TWindowState.wsNormal;
   Form.WindowState:=NewState;
  if Form.WindowState=TWindowState.wsNormal then
    begin
     Form.Width:=Max(100, ReadIntDef(Path, AWidth, Form.Width));
     Form.Height:=Max(100,ReadIntDef(Path, AHeight, Form.Height));
    end;
  end;
end;


function TProjectRegistry.WriteString(const Path,Key,Value:string):Boolean;
var
  Registry: TRegistry;
begin
  Result:=False;
  Registry := TRegistry.Create;
   try
    Registry.RootKey := HKEY_CURRENT_USER;
    if Registry.OpenKey(Path, True) then
    begin
       Registry.Writestring(Key,Value);
       Registry.CloseKey;
       Result:=True;
    end;
  finally
    Registry.Free;
 end;
end;





function TProjectRegistry.ReadBool(const Path,Key:string; Default:Boolean):Boolean;
var
  Registry: TRegistry;
begin
  Registry:=TRegistry.Create;
try
  Registry.RootKey:=HKEY_CURRENT_USER;
  if  Registry.OpenKey(Path,False) then
  begin
   try
    If Registry.ValueExists(Key) then
     Result :=Registry.ReadBool(Key)
      else Result:=Default;
    except
     result:=Default;
    end;
   end
   else Result:=Default;
 Finally
  Registry.Free;
 end;
end;



function TProjectRegistry.WriteBool(const Path,Key:string; Value:Boolean):Boolean;
var
  Registry: TRegistry;
begin
  Result:=False;
  Registry := TRegistry.Create;
   try
    Registry.RootKey := HKEY_CURRENT_USER;
    if Registry.OpenKey(Path, True) then
    begin
     Registry.WriteBool(Key,Value);
     Registry.CloseKey;
     Result:=True;
    end;
  finally
   Registry.Free;
 end;
end;


procedure TProjectRegistry.Clear;
begin
 DeleteKeys(RegistryPathUserData);
end;

constructor TProjectRegistry.Create;
begin
 FRegistry:=TRegistry.Create;
end;

class function TProjectRegistry.DefaultInstance: TProjectRegistry;
begin
 Result:=FDefaultInstance;
end;

procedure TProjectRegistry.DeleteKeys(const Path: string);
var
  Registry: TRegistry;
begin
  Registry:=TRegistry.Create;
  try
    Registry.DeleteKey(Path);
  finally
    Registry.Free;
  end;
end;

destructor TProjectRegistry.Destroy;
begin
  Registry.Free;
  inherited;
end;

function TProjectRegistry.DialogPath(const Key: string): string;
begin
 Result:=IncludeTrailingPathDelimiter(RegistryPathDialogs+Key);
end;

procedure TProjectRegistry.GetKeyNames(const Path:string; List:TStrings);
var
  Registry: TRegistry;
begin
  Registry:=TRegistry.Create;
  try
    if Registry.OpenKey(Path, False) then
     begin
      Registry.GetKeyNames(List);
      Registry.CloseKey;
     end;
  finally
    Registry.Free;
  end;
end;

initialization
 IniFileName:= ExtractFilePath(Paramstr(0))+DefaultIniFile;
 FDefaultInstance:=TProjectRegistry.Create;

finalization
 FDefaultInstance.Free;

end.
