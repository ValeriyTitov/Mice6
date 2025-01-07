unit ImportExport.AppCmd;

interface
 uses
  System.SysUtils, System.Variants, System.Classes,
  System.Generics.Defaults, System.JSON,Data.DB,
  DAC.XDataSet,
  ImportExport.ItemLists,
  ImportExport.Entity;

 type
  TMiceAppCmdEntity = class(TMiceITypeEntity)
   private
    procedure AfterOpenList(DataSet:TDataSet);
    procedure FindAppScript(DataSet:TDataSet);
   public
    procedure Populate; override;
    procedure ImportJsonDataSets; override;
    procedure ImportCheck; override;
    procedure DoExport(JsonRootObject:TJsonObject);override;
    constructor Create; override;
    destructor Destroy; override;
  end;

  TMiceCommonCommand = class(TMiceAppCmdEntity)
   public
    constructor Create; override;
  end;

  TMicePluginCommand = class(TMiceAppCmdEntity)
   public
    constructor Create; override;
  end;

  TMiceCommonFilter = class(TMiceAppCmdEntity)
   public
    constructor Create; override;
  end;

  TMicePluginFilter = class(TMiceAppCmdEntity)
   public
    constructor Create; override;
  end;

implementation

{ TMiceAppTemplateEntity }

procedure TMiceAppCmdEntity.AfterOpenList(DataSet: TDataSet);
begin
 DataSet.Filter:='AppPluginsId='+Self.ObjectIdParent.ToString;
 DataSet.Filtered:=True;
end;

constructor TMiceAppCmdEntity.Create;
begin
  inherited;
 // Name:=ITypeAppNameAppTemplate;
  KeyField:='AppCmdId';
  KeyFieldPath:='AppCmdId[0].'+KeyField;
end;

destructor TMiceAppCmdEntity.Destroy;
begin
  inherited;
end;

procedure TMiceAppCmdEntity.DoExport(JsonRootObject: TJsonObject);
begin
  DataSetByName('AppPluginsCommonCmd').AfterOpen:=Self.AfterOpenList;
  DataSetByName('AppCmd').AfterOpen:=FindAppScript;
//  DataSetByName('AppScripts').AfterOpen:=FindAppScript;
  inherited;
end;

procedure TMiceAppCmdEntity.FindAppScript(DataSet: TDataSet);
begin
 if not DataSet.FieldByName('RunAppScriptsId').IsNull then
  SetNewProvider('AppScripts','AppScriptsId',DataSet.FieldByName('RunAppScriptsId').AsInteger);
end;

procedure TMiceAppCmdEntity.ImportCheck;
begin
  inherited;
end;

procedure TMiceAppCmdEntity.ImportJsonDataSets;
begin
 Populate;
 TryImportObject('AppMainTree','AppMainTreeId','AppMainTree[0].AppMainTreeId');
 TryImportObject('AppScripts','AppScriptsId','AppScripts[0].AppScriptsId');
 TryImportObject('AppCmd','AppCmdId','AppCmd[0].AppCmdId');
 TryImportObject('AppCmdParams','AppCmdId','AppCmdParams[0].AppCmdId');
 TryImportObject('AppPluginsCommonCmd','AppCmdId','AppPluginsCommonCmd[0].AppCmdId');
end;

procedure TMiceAppCmdEntity.Populate;
begin
if Self.DataSets.Count=0 then
 begin
  AddDataSet('AppMainTree','AppMainTreeId','AppMainTreeId','',S_IMPORTEXPORT_TABLEHINT_APPMAINTREE,AppMainTreeId);
  AddDataSet('AppCmd','AppCmdId','AppCmdId','',S_IMPORTEXPORT_TABLEHINT_APPCOMMAND, ObjectId);
  AddDataSet('AppCmdParams','AppCmdParamsId','AppCmdId','',S_IMPORTEXPORT_TABLEHINT_APPCOMMAND_PARAMS, ObjectId);
  AddDataSet('AppPluginsCommonCmd','AppPluginsCommonCmdId','AppCmdId','','', ObjectId);
  AddDataSet('AppScripts','AppScriptsId','AppScriptsId','','', -1);
 end;
end;

{ TMicePluginFilter }

constructor TMicePluginFilter.Create;
begin
  inherited;
  Name:=ITypeAppNameFilter;
end;

{ TMiceCommonCommand }

constructor TMiceCommonCommand.Create;
begin
  inherited;
  Name:=ITypeAppNameCommonCommand;
end;

{ TMiceCommonFilter }

constructor TMiceCommonFilter.Create;
begin
  inherited;
  Name:=ITypeAppNameCommonFilter;
end;

{ TMicePluginCommand }

constructor TMicePluginCommand.Create;
begin
  inherited;
  Name:=ITypeAppNameCommand;
end;

initialization
 TMiceITypeEntity.RegisterImportExportClass(ITypeAppNameCommonCommand, TMiceCommonCommand);
 TMiceITypeEntity.RegisterImportExportClass(ITypeAppNameCommand, TMicePluginCommand);
 TMiceITypeEntity.RegisterImportExportClass(ITypeAppNameCommonFilter, TMiceCommonFilter);
 TMiceITypeEntity.RegisterImportExportClass(ITypeAppNameFilter, TMiceCommonFilter);

end.
