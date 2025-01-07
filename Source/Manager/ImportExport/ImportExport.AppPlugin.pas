unit ImportExport.AppPlugin;

interface
 uses
  System.SysUtils, System.Variants, System.Classes,
  System.Generics.Defaults, System.JSON,Data.DB,
  DAC.XDataSet,
  Manager.WindowManager,
  ImportExport.Entity,
  DAC.Data.Convert;

 type
  TMiceAppPluginEntity = class(TMiceITypeEntity)
  protected
    procedure FindAppScript(DataSet:TDataSet);
    procedure ForceOpenAppPlugins(DataSet:TDataSet);
  public
    procedure DoExport(JsonRootObject:TJsonObject);override;
    procedure ImportJsonDataSets; override;
    procedure Populate; override;
    constructor Create; override;
    destructor Destroy; override;
 end;

implementation


{ TMicePluginEntity }


constructor TMiceAppPluginEntity.Create;
begin
  inherited;
  Name:=ITypeAppNamePlugin;
  KeyField:='AppPluginsId';
  KeyFieldPath:='AppPlugins[0].'+KeyField;
end;

destructor TMiceAppPluginEntity.Destroy;
begin
  inherited;
end;

procedure TMiceAppPluginEntity.DoExport(JsonRootObject: TJsonObject);
begin
  DataSetByName('AppPlugins').AfterOpen:=FindAppScript;
  DataSetByName('AppScripts').BeforeOpen:=ForceOpenAppPlugins;
  inherited;

end;

procedure TMiceAppPluginEntity.ImportJsonDataSets;
begin
 Populate;
 TryImportObject('AppMainTree','AppMainTreeId','AppMainTree[0].AppMainTreeId');
 TryImportObject('AppScripts','AppScriptsId','AppScripts[0].AppScriptsId');
 TryImportObject('AppPlugins','AppPluginsId','AppPlugins[0].AppPluginsId');
 TryImportObject('AppColumns','AppPluginsId','AppColumns[0].AppPluginsId');
 TryImportObject('AppGridColors','AppPluginsId','AppGridColors[0].AppPluginsId');
end;

procedure TMiceAppPluginEntity.FindAppScript(DataSet: TDataSet);
begin
 if not DataSet.FieldByName('AppScriptsId').IsNull then
  SetNewProvider('AppScripts','AppScriptsId',DataSet.FieldByName('AppScriptsId').AsInteger);
 DataSet.FieldByName('InitString').EditMask:=S_FIELD_CONTAINTS_JSON_TEXT;
end;


procedure TMiceAppPluginEntity.ForceOpenAppPlugins(DataSet: TDataSet);
begin
 Self.DataSetByName('AppPlugins').Open;
end;

procedure TMiceAppPluginEntity.Populate;
begin
if Self.DataSets.Count=0 then
 begin
  AddDataSet('AppMainTree','AppMainTreeId','AppMainTreeId','', S_IMPORTEXPORT_TABLEHINT_APPMAINTREE,AppMainTreeId);
  AddDataSet('AppPlugins',KeyField,KeyField, '', S_IMPORTEXPORT_TABLEHINT_PLUGIN, ObjectId);
  AddDataSet('AppColumns','AppColumnsId',KeyField,'',S_IMPORTEXPORT_TABLEHINT_COLUMNS,ObjectId);
  AddDataSet('AppGridColors','AppGridColorsId',KeyField,'',S_IMPORTEXPORT_TABLEHINT_COLORS,ObjectId);
  AddDataSet('AppScripts','AppScriptsId','AppScriptsId', '',S_IMPORTEXPORT_TABLEHINT_SCRIPT_PLUGIN,-1);
 end;
end;



initialization
 TMiceITypeEntity.RegisterImportExportClass(ITypeAppNamePlugin, TMiceAppPluginEntity)

end.
