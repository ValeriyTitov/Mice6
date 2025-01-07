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
//Как открыть папку и выделить в ней файл ?
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
CSIDL_DESKTOP = $0000;   // Виртуальный каталог, представляющий Рабочий стол. (Корень в проводнике)
CSIDL_INTERNET = $0001;  // Виртуальный каталог для Internet Explorer.
CSIDL_PROGRAMS = $0002;  // Меню Пуск -&gt; Программы
CSIDL_CONTROLS = $0003;  // Виртуальный каталог, содержащий иконки пунктов панели управления
CSIDL_PRINTERS = $0004;  // Виртуальный каталог, содержащий установленные принтеры
CSIDL_PERSONAL = $0005;  // Виртуальный каталог, представляющий папку "Мои документы" // До Vista ссылался на какталог "Мои документы" на жёстком диске
CSIDL_FAVORITES = $0006; // Избранное. (обычно C:\Documents and Settings\username\Favorites)
CSIDL_STARTUP = $0007;   // Пуск -&gt; Программы -&gt; Автозагрузка
CSIDL_RECENT = $0008;    // Недавние документы (обычно C:\Documents and Settings\username\My Recent Documents // Для добавления ссылки документа используйте SHAddToRecentDocs
CSIDL_SENDTO = $0009;    // Папка, содержащая ярлыки меню "Отправить" (Sent to...) //(обычно C:\Documents and Settings\username\SendTo)
CSIDL_BITBUCKET = $000a; // Виртуальный каталог, содержащий файлы в корзине текущего пользователя
CSIDL_STARTMENU = $000b; // Элементы меню Пуск текущего пользователя //(обычно C:\Documents and Settings\username\Start Menu)
CSIDL_DESKTOPDIRECTORY = $0010; // Рабочий стол текущего пользователя (обычно C:\Documents and Settings\username\Desktop)
CSIDL_DRIVES = $0011;    // Виртуальный каталог, представляющий папку "Мой компьютер"
CSIDL_NETWORK = $0012;   // Виртуальный каталог, представляющий "Сетевое окружение"
CSIDL_NETHOOD = $0013;   // Папка "My Nethood Places" (обычно C:\Documents and Settings\username\NetHood) // В неё ссылки на избранные расшаренные ресурсы
CSIDL_FONTS = $0014;     // Папка, содержащая установленные шрифты. (обычно C:\Windows\Fonts)
CSIDL_TEMPLATES = $0015; // Шаблоны документов. (Обычно Settings\username\Templates)
CSIDL_COMMON_STARTMENU = $0016; // Элементы меню Пуск для всех пользователей.//(обычно C:\Documents and Settings\All Users\Start Menu) // Константы, начинающиеся на CSIDL_COMMON_ существуют только в NT версиях
CSIDL_COMMON_PROGRAMS = $0017;  // Меню Пуск -&gt; программы для всех пользователей //(обычно C:\Documents and Settings\All Users\Start Menu\Programs)
CSIDL_COMMON_STARTUP = $0018;   // Меню Пуск -&gt; Программы -&gt; Автозагрузка для всех пользователей //(обычно C:\Documents and Settings\All Users\Start Menu\Programs\Startup)
CSIDL_COMMON_DESKTOPDIRECTORY = $0019; // Элементы Рабочего стола для всех пользователей //(обычно C:\Documents and Settings\All Users\Desktop)
CSIDL_APPDATA = $001a;     // Папка, в которой рограммы должны хранить свои данные //(C:\Documents and Settings\username\Application Data)
CSIDL_PRINTHOOD = $001b;   // Установленные принтеры.//(обычно C:\Documents and Settings\username\PrintHood)
CSIDL_ALTSTARTUP = $001d;  // DBCS // user's nonlocalized Startup program group. Устарело.
CSIDL_COMMON_ALTSTARTUP = $001e; // DBCS // Устарело
CSIDL_COMMON_FAVORITES = $001f;  // Ссылки "Избранное" для всех пользователей
CSIDL_INTERNET_CACHE = $0020;    // Временные Internet файлы //(обычно C:\Documents and Settings\username\Local Settings\Temporary Internet Files)
CSIDL_COOKIES = $0021; // Папка для хранения Cookies (обычно C:\Documents and Settings\username\Cookies)
CSIDL_HISTORY = $0022; // Хранит ссылки интернет истории IE

Следующих идентификаторов нет в ShlObj:
CSIDL_ADMINTOOLS = $30;// Административные инструменты текущего пользователя (например консоль MMC). Win2000+
CSIDL_CDBURN_AREA = $3b; // Папка для файлов, подготовленных к записи на CD/DVD //(Обычно //C:\Documents and Settings\username\Local Settings\Application Data\Microsoft\CD Burning)
CSIDL_COMMON_ADMINTOOLS = $2f; // Папка, содержащая инструменты администрирования
CSIDL_COMMON_APPDATA = $23; // Папака AppData для всех пользователей. //(обычно C:\Documents and Settings\All Users\Application Data)
CSIDL_COMMON_DOCUMENTS = $2e; // Папка "Общие документы" (обычно C:\Documents and Settings\All Users\Documents)
CSIDL_COMMON_TEMPLATES = $2d; // Папка шаблонов документов для всех пользователей //(Обычно C:\Documents and Settings\All Users\Templates)
CSIDL_COMMON_MUSIC = $35; // Папка "Моя музыка" для всех пользователей. //(обычно C:\Documents and Settings\All Users\Documents\My Music)
CSIDL_COMMON_PICTURES = $36; // Папка "Мои рисунки" для всех пользователей. //(обычно C:\Documents and Settings\All Users\Documents\My Pictures)
CSIDL_COMMON_VIDEO = $37; // Папка "Моё видео" для всех пользователей //(C:\Documents and Settings\All Users\Documents\My Videos)
CSIDL_COMPUTERSNEARME = $3d; // Виртуальная папка, представляет список компьютеров в вашей рабочей группе
CSIDL_CONNECTIONS = $31; // Виртуальная папка, представляет список сетевых подключений
CSIDL_LOCAL_APPDATA = $1c; // AppData для приложений, которые не переносятся на другой компьютер //(обычно C:\Documents and Settings\username\Local Settings\Application Data)
CSIDL_MYDOCUMENTS = $0c; // Виртуальный каталог, представляющий папку "Мои документы"
CSIDL_MYMUSIC = $0d; // Папка "Моя музыка"
CSIDL_MYPICTURES = $27; // Папка "Мои картинки"
CSIDL_MYVIDEO = $0e; // Папка "Моё видео"
CSIDL_PROFILE = $28; // Папка пользователя (обычно C:\Documents and Settings\username)
CSIDL_PROGRAM_FILES = $26; // Папка Program Files (обычно C:\Program Files)
CSIDL_PROGRAM_FILESX86 = $2a;
CSIDL_PROGRAM_FILES_COMMON = $2b; // Папка Program Files\Common (обычно C:\Program Files\Common)
CSIDL_PROGRAM_FILES_COMMONX86 = $2c;
CSIDL_RESOURCES = $38; // Папка для ресерсов. Vista и выше (обычно C:\Windows\Resources)
CSIDL_RESOURCES_LOCALIZED = $39;
CSIDL_SYSTEM = $25; // Папака System (обычно C:\Windows\System32 или C:\Windows\System)
CSIDL_SYSTEMX86 = $29;
CSIDL_WINDOWS = $24; // Папка Windows. Она же %windir% или %SYSTEMROOT% (обычно C:\Windows)
}
end.
