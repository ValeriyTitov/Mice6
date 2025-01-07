unit DAC.ADOHelper;

interface
 Uses ADODB, DB, Windows, Classes, SysUtils;

type
 TADOHelper = class
   class function SelectBestSQLProvider:String;
   class function SelectBestExcelProvider:String;
   class function ProviderExists(ProviderName:String):Boolean;
   class function ACEProviderAvaible:Boolean;
 end;

implementation

Const
 SQL_NATIVE_CLIENT = 'SQLNCLI';
 EXCEL_ACE_CLIENT  = 'ACE';


{ TADOHelper }

var
 ADOProviderNames : TStringList;

Procedure FillADOProvider;
begin
 If ADOProviderNames.Count=0 then
   GetProviderNames(ADOProviderNames);
end;

class function TADOHelper.ACEProviderAvaible: Boolean;
begin
 Result:=Pos(EXCEL_ACE_CLIENT,SelectBestExcelProvider)>0;
end;

class function TADOHelper.ProviderExists(ProviderName: String): Boolean;
begin
 FillADOProvider;
 Result:=ADOProviderNames.IndexOf(ProviderName)>=0;
end;

class function TADOHelper.SelectBestExcelProvider: String;
var
 X:Integer;
begin
 FillADOProvider;
 Result:='Microsoft.Jet.OLEDB.4.0';
  for x:=0 to ADOProviderNames.Count-1 do
   If Pos(EXCEL_ACE_CLIENT,ADOProviderNames[x])>0 then
    begin
     Result:=ADOProviderNames[X];
     Break;
    end;
end;

class function TADOHelper.SelectBestSQLProvider: String;
var
 X:Integer;
begin
 FillADOProvider;
 Result:='SQLOLEDB';
  for x:=0 to ADOProviderNames.Count-1 do
   If Pos(SQL_NATIVE_CLIENT,ADOProviderNames[x])>0 then
    begin
     Result:=ADOProviderNames[X];
     Break;
    end;
end;

initialization
 ADOProviderNames:=TStringList.Create;
finalization
 ADOProviderNames.Free;
end.
