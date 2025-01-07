unit Common.ExeVersion;

interface
 uses WinApi.Windows, System.SysUtils, Common.ResourceStrings;

type
 TExeVerion = class
  class procedure GetBuildInfo(var V1, V2, V3, V4: Word; const FileName:string);
  class function GetExeVersion(const FileName:string):string;
  class function GetSelfVersion:string;
 end;

implementation

{ TExeVerion }
var
 FSelfVersion:string;

class procedure TExeVerion.GetBuildInfo(var V1, V2, V3, V4: Word; const FileName: string);
var
 VerInfoSize, VerValueSize, Dummy : DWORD;
 VerInfo : Pointer;
 VerValue : PVSFixedFileInfo;
begin
 VerInfoSize := GetFileVersionInfoSize(PChar(FileName), Dummy);
 GetMem(VerInfo, VerInfoSize);
 GetFileVersionInfo(PChar(FileName), 0, VerInfoSize, VerInfo);
 VerQueryValue(VerInfo, '\', Pointer(VerValue), VerValueSize);
 With VerValue^ do
 begin
   V1 := dwFileVersionMS shr 16;
   V2 := dwFileVersionMS and $FFFF;
   V3 := dwFileVersionLS shr 16;
   V4 := dwFileVersionLS and $FFFF;
 end;
 FreeMem(VerInfo, VerInfoSize);
end;


class function TExeVerion.GetExeVersion(const FileName: string): string;
var
   V1,       // Major Version
   V2,       // Minor Version
   V3,       // Release
   V4: Word; // Build Number
begin
 try
   GetBuildInfo(V1, V2, V3, V4, FileName);
   Result := IntToStr(V1) + '.'+ IntToStr(V2) + '.'+ IntToStr(V3) + '.' + IntToStr(V4);
 except
  Result:=S_COMMON_UNKNOWN_BRACKETS;
 end;
end;


class function TExeVerion.GetSelfVersion: string;
begin
 If FSelfVersion.IsEmpty then
   FSelfVersion:=GetExeVersion(ParamStr(0));

  Result:=FSelfVersion;
end;

end.