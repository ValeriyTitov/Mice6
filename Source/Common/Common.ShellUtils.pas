unit Common.ShellUtils;

interface
 uses
  WinAPI.Windows, System.SysUtils, ShellAPI, Vcl.Forms, WinAPI.SHFolder,
  System.IOUtils,
  Common.ResourceStrings;


type
 TShellUtils = class
 public
  class procedure ShellExecuteSafe(const FullPath, Params: string);
  class procedure ShellSelectFile(const FullPath:string);
  class procedure ShellOpenFolder(const FullPath:string);
  class function MiceFolder:string;
  class function ShellExecute2(const FullPath, Params: string):Boolean;
  class function AppDataDir:string;
  class function LocalAppDataDir:string;
  class function MyDocsDir:string;
  class function ShellFolder(ID:Integer):string;
  class function EnviromentVar(const VarName: string): string;
 end;

implementation

{ TShellUtils }

class procedure TShellUtils.ShellExecuteSafe(const FullPath, Params: string);
var
  Msg:string;
resourcestring
 S_FAIL_TO_EXECUTE_FMT = 'Failed to execute: %s';
begin
if not ShellExecute2(FullPath,Params) then
  begin
   Msg:=Format(S_FAIL_TO_EXECUTE_FMT,[SysErrorMessage(GetLastError)+#13#13+FullPath]);
   MessageBox(Application.Handle,PChar(Msg), PChar(S_COMMON_INFORMATION), MB_OK+MB_ICONINFORMATION);
  end;
end;

class function TShellUtils.ShellFolder(ID: Integer): string;
var
  Path: array [0..MAX_PATH] of Char;
begin
  if Succeeded(SHGetFolderPath(0, ID or CSIDL_FLAG_CREATE, 0, SHGFP_TYPE_CURRENT, @Path[0])) then
    Result := Path
  else
    Result := '';
end;

class procedure TShellUtils.ShellOpenFolder(const FullPath: string);
begin
 ShellExecute(Application.Handle, 'Open', 'Explorer.exe', PChar(ExtractFileDir(FullPath)), '',SW_SHOWNORMAL)
end;

class procedure TShellUtils.ShellSelectFile(const FullPath: string);
begin
//��� ������� ����� � �������� � ��� ���� ?
 ShellExecute(Application.Handle, 'Open', 'Explorer.exe', PChar('/select, ' + FullPath), '',SW_SHOWNORMAL)
end;

class function TShellUtils.AppDataDir: string;
begin
 Result:=ShellFolder(CSIDL_APPDATA);
end;

class function TShellUtils.EnviromentVar(const VarName: string): string;
var
  i: integer;
begin
  Result := '';
  try
    i := GetEnvironmentVariable(PChar(VarName), nil, 0);
    if i > 0 then
    begin
      SetLength(Result, i-1);
      GetEnvironmentVariable(Pchar(VarName), PChar(Result), i);
    end;
  except
    Result := '';
  end;
end;

class function TShellUtils.LocalAppDataDir: string;
begin
 Result:=ShellFolder(CSIDL_LOCAL_APPDATA);
end;

class function TShellUtils.MiceFolder: string;
resourcestring
 S_CANNOT_ACCESS_MICE_FOLDER_FMT = 'Unable to access to %s';
begin
 Result:=AppDataDir+'\Mice6\';
 if not ForceDirectories(Result) then
  raise Exception.CreateFmt(S_CANNOT_ACCESS_MICE_FOLDER_FMT, [Result]);
end;

class function TShellUtils.MyDocsDir: string;
begin
 Result:= ShellFolder(CSIDL_LOCAL_APPDATA);
end;

class function TShellUtils.ShellExecute2(const FullPath,  Params: string): Boolean;
begin
 Result:=ShellExecute(Application.Handle,'Open',PChar(FullPath),PChar(Params),PChar(ExtractFileDir(FullPath)),SW_SHOWDEFAULT)>32;
end;







{
CSIDL_DESKTOP = $0000;   // ����������� �������, �������������� ������� ����. (������ � ����������)
CSIDL_INTERNET = $0001;  // ����������� ������� ��� Internet Explorer.
CSIDL_PROGRAMS = $0002;  // ���� ���� -&gt; ���������
CSIDL_CONTROLS = $0003;  // ����������� �������, ���������� ������ ������� ������ ����������
CSIDL_PRINTERS = $0004;  // ����������� �������, ���������� ������������� ��������
CSIDL_PERSONAL = $0005;  // ����������� �������, �������������� ����� "��� ���������" // �� Vista �������� �� �������� "��� ���������" �� ������ �����
CSIDL_FAVORITES = $0006; // ���������. (������ C:\Documents and Settings\username\Favorites)
CSIDL_STARTUP = $0007;   // ���� -&gt; ��������� -&gt; ������������
CSIDL_RECENT = $0008;    // �������� ��������� (������ C:\Documents and Settings\username\My Recent Documents // ��� ���������� ������ ��������� ����������� SHAddToRecentDocs
CSIDL_SENDTO = $0009;    // �����, ���������� ������ ���� "���������" (Sent to...) //(������ C:\Documents and Settings\username\SendTo)
CSIDL_BITBUCKET = $000a; // ����������� �������, ���������� ����� � ������� �������� ������������
CSIDL_STARTMENU = $000b; // �������� ���� ���� �������� ������������ //(������ C:\Documents and Settings\username\Start Menu)
CSIDL_DESKTOPDIRECTORY = $0010; // ������� ���� �������� ������������ (������ C:\Documents and Settings\username\Desktop)
CSIDL_DRIVES = $0011;    // ����������� �������, �������������� ����� "��� ���������"
CSIDL_NETWORK = $0012;   // ����������� �������, �������������� "������� ���������"
CSIDL_NETHOOD = $0013;   // ����� "My Nethood Places" (������ C:\Documents and Settings\username\NetHood) // � �� ������ �� ��������� ����������� �������
CSIDL_FONTS = $0014;     // �����, ���������� ������������� ������. (������ C:\Windows\Fonts)
CSIDL_TEMPLATES = $0015; // ������� ����������. (������ Settings\username\Templates)
CSIDL_COMMON_STARTMENU = $0016; // �������� ���� ���� ��� ���� �������������.//(������ C:\Documents and Settings\All Users\Start Menu) // ���������, ������������ �� CSIDL_COMMON_ ���������� ������ � NT �������
CSIDL_COMMON_PROGRAMS = $0017;  // ���� ���� -&gt; ��������� ��� ���� ������������� //(������ C:\Documents and Settings\All Users\Start Menu\Programs)
CSIDL_COMMON_STARTUP = $0018;   // ���� ���� -&gt; ��������� -&gt; ������������ ��� ���� ������������� //(������ C:\Documents and Settings\All Users\Start Menu\Programs\Startup)
CSIDL_COMMON_DESKTOPDIRECTORY = $0019; // �������� �������� ����� ��� ���� ������������� //(������ C:\Documents and Settings\All Users\Desktop)
CSIDL_APPDATA = $001a;     // �����, � ������� �������� ������ ������� ���� ������ //(C:\Documents and Settings\username\Application Data)
CSIDL_PRINTHOOD = $001b;   // ������������� ��������.//(������ C:\Documents and Settings\username\PrintHood)
CSIDL_ALTSTARTUP = $001d;  // DBCS // user's nonlocalized Startup program group. ��������.
CSIDL_COMMON_ALTSTARTUP = $001e; // DBCS // ��������
CSIDL_COMMON_FAVORITES = $001f;  // ������ "���������" ��� ���� �������������
CSIDL_INTERNET_CACHE = $0020;    // ��������� Internet ����� //(������ C:\Documents and Settings\username\Local Settings\Temporary Internet Files)
CSIDL_COOKIES = $0021; // ����� ��� �������� Cookies (������ C:\Documents and Settings\username\Cookies)
CSIDL_HISTORY = $0022; // ������ ������ �������� ������� IE

��������� ��������������� ��� � ShlObj:
CSIDL_ADMINTOOLS = $30;// ���������������� ����������� �������� ������������ (�������� ������� MMC). Win2000+
CSIDL_CDBURN_AREA = $3b; // ����� ��� ������, �������������� � ������ �� CD/DVD //(������ //C:\Documents and Settings\username\Local Settings\Application Data\Microsoft\CD Burning)
CSIDL_COMMON_ADMINTOOLS = $2f; // �����, ���������� ����������� �����������������
CSIDL_COMMON_APPDATA = $23; // ������ AppData ��� ���� �������������. //(������ C:\Documents and Settings\All Users\Application Data)
CSIDL_COMMON_DOCUMENTS = $2e; // ����� "����� ���������" (������ C:\Documents and Settings\All Users\Documents)
CSIDL_COMMON_TEMPLATES = $2d; // ����� �������� ���������� ��� ���� ������������� //(������ C:\Documents and Settings\All Users\Templates)
CSIDL_COMMON_MUSIC = $35; // ����� "��� ������" ��� ���� �������������. //(������ C:\Documents and Settings\All Users\Documents\My Music)
CSIDL_COMMON_PICTURES = $36; // ����� "��� �������" ��� ���� �������������. //(������ C:\Documents and Settings\All Users\Documents\My Pictures)
CSIDL_COMMON_VIDEO = $37; // ����� "�� �����" ��� ���� ������������� //(C:\Documents and Settings\All Users\Documents\My Videos)
CSIDL_COMPUTERSNEARME = $3d; // ����������� �����, ������������ ������ ����������� � ����� ������� ������
CSIDL_CONNECTIONS = $31; // ����������� �����, ������������ ������ ������� �����������
CSIDL_LOCAL_APPDATA = $1c; // AppData ��� ����������, ������� �� ����������� �� ������ ��������� //(������ C:\Documents and Settings\username\Local Settings\Application Data)
CSIDL_MYDOCUMENTS = $0c; // ����������� �������, �������������� ����� "��� ���������"
CSIDL_MYMUSIC = $0d; // ����� "��� ������"
CSIDL_MYPICTURES = $27; // ����� "��� ��������"
CSIDL_MYVIDEO = $0e; // ����� "�� �����"
CSIDL_PROFILE = $28; // ����� ������������ (������ C:\Documents and Settings\username)
CSIDL_PROGRAM_FILES = $26; // ����� Program Files (������ C:\Program Files)
CSIDL_PROGRAM_FILESX86 = $2a;
CSIDL_PROGRAM_FILES_COMMON = $2b; // ����� Program Files\Common (������ C:\Program Files\Common)
CSIDL_PROGRAM_FILES_COMMONX86 = $2c;
CSIDL_RESOURCES = $38; // ����� ��� ��������. Vista � ���� (������ C:\Windows\Resources)
CSIDL_RESOURCES_LOCALIZED = $39;
CSIDL_SYSTEM = $25; // ������ System (������ C:\Windows\System32 ��� C:\Windows\System)
CSIDL_SYSTEMX86 = $29;
CSIDL_WINDOWS = $24; // ����� Windows. ��� �� %windir% ��� %SYSTEMROOT% (������ C:\Windows)
}
end.
