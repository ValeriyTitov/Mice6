unit Common.GlobalSettings;

interface

uses
     Data.DB, System.Classes, System.SysUtils, System.Variants,
     System.Generics.Collections,System.Generics.Defaults,
     DAC.DataBaseUtils,
     DAC.XDataSet,
     Common.ResourceStrings;

type

 TGlobalSettings = class
  private
    FDict : TDictionary<string, Variant>;
    procedure PopulateLocal;
  public
    class function DefaultInstance:TGlobalSettings;
    procedure SetSetting(const Name:string; const Value:Variant);
    procedure Populate;
    function SettingByName(const Name:string):string;
    function SettingExists(const Name:string):Boolean;
    procedure ToList(List:TStrings);
    constructor Create;
    destructor Destroy; override;
  end;

implementation
var
 FDefaultInstance:TGlobalSettings;

 FLocalProgramStartTime:string;
 FLocalComputerName:string;
 FLocalUserName:string;


{ TGlobalSettings }

constructor TGlobalSettings.Create;
begin
 FDict:=TObjectDictionary<string, Variant>.Create(TIStringComparer.Ordinal);
end;


class function TGlobalSettings.DefaultInstance: TGlobalSettings;
begin
if not Assigned(FDefaultInstance) then
 begin
  FDefaultInstance:=TGlobalSettings.Create;
  FDefaultInstance.Populate;
 end;

  Result:=FDefaultInstance;
end;

destructor TGlobalSettings.Destroy;
begin
  FDict.Free;
  inherited;
end;


procedure TGlobalSettings.Populate;
var
 DataSet:TxDataSet;
begin
 DataSet:=TxDataSet.Create(nil);
  try
   DataSet.Source:='TGlobalSettings.Populate';
   DataSet.ProviderName:='spui_AppGlobalParamtersList';
   DataSet.Open;
   while not DataSet.Eof do
    begin
     SetSetting(DataSet.FieldByName('ParameterName').AsString,DataSet.FieldByName('ParameterValue').AsString);
     DataSet.Next;
    end;
   PopulateLocal;
  finally
   DataSet.Free;
  end;
end;

procedure TGlobalSettings.PopulateLocal;
begin
 SetSetting('Local.ProgramStartTime',FLocalProgramStartTime);
 SetSetting('Local.ComputerName',FLocalComputerName);
 SetSetting('Local.UserName',FLocalUserName);
end;

procedure TGlobalSettings.SetSetting(const Name: string; const Value: Variant);
begin
 if FDict.ContainsKey(Name) then
  FDict[Name]:=Value
   else
  FDict.Add(Name,Value);
end;

function TGlobalSettings.SettingByName(const Name: string): string;
begin
 if not FDict.ContainsKey(Name) then
  begin
   Populate;
    if not FDict.ContainsKey(Name) then
     raise Exception.CreateFmt(E_CANNOT_FIND_GLOBAL_SETTING_FMT,[Name]);
  end;
 Result:=VarToStr(FDict[Name]);
end;

function TGlobalSettings.SettingExists(const Name: string): Boolean;
begin
 Result:=FDict.ContainsKey(Name);
end;

procedure TGlobalSettings.ToList(List: TStrings);
var
 s:string;
begin
 for s in FDict.Keys do
   List.Add(s+'='+FDict[s])
end;

initialization
const
 s_none = '<not implemented>';
 FLocalProgramStartTime:=DateToStr(Now);
 FLocalComputerName:=s_none;
 FLocalUserName:=s_none;

finalization
 FDefaultInstance.Free;

end.
