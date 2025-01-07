unit ImportExport.dfTypes;

interface
 uses
  System.SysUtils, System.Variants, System.Classes,
  System.Generics.Defaults, System.JSON,Data.DB,
  DAC.XDataSet,
  Dialog.MShowMessage,
  ImportExport.Entity;

 type
  TMiceAppdfTypesEntity = class(TMiceITypeEntity)
  private
    procedure BeforeOpenPathFoldersActions(DataSet:TDataSet);
    procedure BeforeOpenPathFoldersRules(DataSet:TDataSet);
    procedure BeforeDeletePathFolders(DataSet:TDataSet);
    procedure BeforeDeleteMethods(DataSet:TDataSet);
  public
    procedure Populate; override;
    procedure ImportJsonDataSets; override;
    procedure DoExport(JsonRootObject:TJsonObject);override;
    constructor Create; override;
    destructor Destroy; override;
  end;


implementation

{
  Tmp.ProviderName:='';
  Tmp.Source:='TDocFlowManagerHelper.DeleteMethod';
  Tmp.ProviderName:='spui_dfDeletePathFolder';
}


procedure TMiceAppdfTypesEntity.BeforeDeleteMethods(DataSet: TDataSet);
begin
 GlobalUpdateList.AddToDeleteQueue(GlobalUpdateList.DeleteQueueDfMethods, 'spui_dfDeleteMethod','dfMethodsId',Self.DBName, DataSet.FieldByName('dfMethodsId').AsInteger)
end;

procedure TMiceAppdfTypesEntity.BeforeDeletePathFolders(DataSet: TDataSet);
begin
 GlobalUpdateList.AddToDeleteQueue(GlobalUpdateList.DeleteQueueDfPathFolders, 'spui_dfDeletePathFolder','dfPathFoldersId',Self.DBName, DataSet.FieldByName('dfPathFoldersId').AsInteger)
end;

procedure TMiceAppdfTypesEntity.BeforeOpenPathFoldersActions(DataSet: TDataSet);
begin
  UpdateDetailsProviderNameOnExport('dfPathFolders','dfPathFoldersId','dfPathFolderActions');
end;

procedure TMiceAppdfTypesEntity.BeforeOpenPathFoldersRules(DataSet: TDataSet);
begin
  UpdateDetailsProviderNameOnExport('dfPathFolders','dfPathFoldersId','dfPathFolderRules');
end;

constructor TMiceAppdfTypesEntity.Create;
begin
  inherited;
  Self.Name:=ITypeAppNameDfTypes;
  Self.KeyField:='dfTypesId';
  Self.KeyFieldPath:='dfTypes[0].dfTypesId';
end;

destructor TMiceAppdfTypesEntity.Destroy;
begin

  inherited;
end;

procedure TMiceAppdfTypesEntity.DoExport(JsonRootObject: TJsonObject);
begin
  DataSetByName('dfPathFolderActions').BeforeOpen:=Self.BeforeOpenPathFoldersActions;
  DataSetByName('dfPathFolderRules').BeforeOpen:=Self.BeforeOpenPathFoldersRules;
  inherited;
end;

procedure TMiceAppdfTypesEntity.ImportJsonDataSets;
begin
 Populate;
 TryImportObject('AppMainTree','AppMainTreeId','AppMainTree[0].AppMainTreeId');
 Self.DBName:=FindMetaProperty(MetaDataDBNamePath);

 DataSetByName('dfTypes').DBName:=Self.DBName;
 DataSetByName('dfPathFolders').DBName:=Self.DBName;
 DataSetByName('dfMethods').DBName:=Self.DBName;

 DataSetByName('dfMethods').BeforeDelete:=BeforeDeleteMethods;
 DataSetByName('dfPathFolders').BeforeDelete:=BeforeDeletePathFolders;

 TryImportObject('dfTypes','dfTypesId','dfTypes[0].dfTypesId');
 TryImportObject('dfPathFolders','dfTypesId','dfPathFolders[0].dfTypesId', True);
 TryImportObject('dfMethods','dfTypesId','dfMethods[0].dfTypesId', True);
 TryImportDetails('dfPathFolderActions','dfPathFoldersId', True);
 TryImportDetails('dfPathFolderRules','dfPathFoldersId',True);

end;

procedure TMiceAppdfTypesEntity.Populate;
begin
if DataSets.Count=0 then
 begin
  AddDataSet('AppMainTree','AppMainTreeId','AppMainTreeId','',S_IMPORTEXPORT_TABLEHINT_APPMAINTREE, AppMainTreeId);
  AddDataSet('dfTypes','dfTypesId','dfTypesId',DBName,S_IMPORTEXPORT_TABLEHINT_DFTYPES, ObjectId);
  AddDataSet('dfPathFolders','dfPathFoldersId','dfTypesId',DBName,S_IMPORTEXPORT_TABLEHINT_DFPATHFOLDERS, ObjectId);
  AddDataSet('dfMethods','dfMethodsId','dfTypesId',DBName,S_IMPORTEXPORT_TABLEHINT_DFMETHODS, ObjectId);
  AddDataSet('dfPathFolderActions','dfPathFolderActionsId','dfPathFoldersId',DBName,S_IMPORTEXPORT_TABLEHINT_DFPATHFOLDERS_ACTIONS, -1);
  AddDataSet('dfPathFolderRules','dfPathFolderRulesId','dfPathFoldersId',DBName,S_IMPORTEXPORT_TABLEHINT_DFPATHFOLDERS_RULES, -1);
 end;
end;

initialization
 TMiceITypeEntity.RegisterImportExportClass(ITypeAppNameDfTypes, TMiceAppdfTypesEntity)

end.
