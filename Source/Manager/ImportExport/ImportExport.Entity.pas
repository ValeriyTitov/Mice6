unit ImportExport.Entity;

interface

uses
  System.SysUtils, System.Variants, System.Classes,
  System.Generics.Defaults, System.JSON,
  System.IOUtils,
  Manager.WindowManager,
  Common.ResourceStrings,
  Common.StringUtils,
  DAC.XDataSet,
  Dialog.MShowMessage,
  Dialog.ShowDataSet,
  DAC.Data.Convert,
  Data.DB,
  System.NetEncoding,  System.Generics.Collections,
  ImportExport.JsonToDataSet,
  ImportExport.ItemLists,
  ImportExport.StatisticList;



type

 TMiceITypeEntityClass = class of TMiceITypeEntity;

 TMiceITypeEntity = class
  strict private
    FObjectId: Integer;
    FAppMainTreeId:Integer;
    FJsonDataSets: TJsonObject;
    FDataSets: TObjectList<TxDataSet>;
    FName: string;
    FKeyField: string;
    FKeyFieldPath: string;
    FAppMainTreePath: string;
    FCaption: string;
    FAppMainTreeParentId: Integer;
    FObjectIDs: TParentIdObjectList;
    FStatisticList: TImportStatisticList;
    FObjectIdParent: Integer;
    FDBName: string;
    FMetaObject: TJsonObject;
    FTotalRowsCount:Integer;
    FDefaultDatasetState: Boolean;
    FGlobalDataSetList:TGlobalDataSetList;
    FGlobalUpdateList: TGlobalUpdateList;
    procedure SetNewDetailsProvider(const TargetTable,MasterField:string;List:TList<integer>);
    procedure CollectKeysJsonArray(jDataSet:TJsonArray; MasterField:string; List:TList<integer>);
    procedure CollectKeysDataSet(DataSet:TxDataSet; MasterKeyField:string; List:TList<integer>);
  protected
    procedure UpdateDetailsProviderNameOnExport(const MasterTable, MasterField, TargetTable:string);
    procedure UpdateDetailsProviderNameOnImport(jDataSet:TJsonArray; const MasterTable, MasterField:string);
    procedure CalculateTotalRows;
    procedure OpenDataSets;
    procedure CheckObjects;
    procedure ExportDataSets;
    procedure CheckZeroRows(DataSet:TDataSet);
    procedure ImportSingleDataSet(DataSet:TxDataSet; jDataSet:TJsonArray; DeleteMissingKeyFields:Boolean);
    procedure SetNewProvider(const TableName, MasterField:string; ObjectId:Integer);
    procedure AddToObjectIds(DataSet:TDataSet);
    function AddDataSet(const TableName, KeyField, MasterField, DBName, Hint:string; Id:Integer):TxDataSet;
    function FindDataSet(const TableName:string):TxDataSet;
    function TryImportObject(const TableName, AKeyField, AKeyFieldPath:string; DeleteMissingKeys:Boolean=False):Boolean;
    function TryImportDetails(const TableName, AKeyField:string;DeleteMissingKeyFields:Boolean):Boolean;
    function WriteNewMetaObject:TJsonObject;
    function AppendDetailsRequired(DataSet:TxDataSet):Boolean;virtual;
    function FindMetaProperty(const JsonPath: string): string;
    property KeyFieldPath:string read FKeyFieldPath write FKeyFieldPath;
    property MetaObject:TJsonObject read FMetaObject write FMetaObject;
  public

    property GlobalUpdateList:TGlobalUpdateList read FGlobalUpdateList write FGlobalUpdateList;
    property AppMainTreePath:string read FAppMainTreePath write FAppMainTreePath;
    property ObjectIDs:TParentIdObjectList read FObjectIDs write FObjectIDs;
    property JsonDataSets:TJsonObject read FJsonDataSets write FJsonDataSets;
    property KeyField:string read FKeyField write FKeyField;
    property AppMainTreeId:Integer read FAppMainTreeId write FAppMainTreeId;
    property AppMainTreeParentId:Integer read FAppMainTreeParentId write FAppMainTreeParentId;
    property Caption:string read FCaption write FCaption;
    property Name:string read FName write FName;
    property ObjectId:Integer read FObjectId write FObjectId;
    property ObjectIdParent:Integer read FObjectIdParent write FObjectIdParent;
    property StatisticList:TImportStatisticList read FStatisticList write FStatisticList;
    property DBName:string read FDBName write FDBName;
    property DefaultDatasetState:Boolean read FDefaultDatasetState write FDefaultDatasetState;
    property GlobalDataSetList:TGlobalDataSetList read FGlobalDataSetList write FGlobalDataSetList;

    property DataSets:TObjectList<TxDataSet> read FDataSets;
    constructor Create; virtual;
    destructor Destroy; override;

    function DataSetByName(const TableName:string):TxDataSet;

    procedure Populate; virtual; abstract;
    procedure SetExportActivity(const TableName:string; Active:Boolean);
    procedure DoExport(JsonRootObject:TJsonObject);virtual;
    procedure ImportJsonDataSets; virtual; abstract;
    procedure ImportCheck; virtual;

    class procedure RegisterImportExportClass(const Name:string; AClass:TMiceITypeEntityClass);
    class function FindImportExportClass(const Name:string):TMiceITypeEntityClass;
    class function iTypeToAppName(iType:Integer):string;
    class function AppNameToiType(const Name:string):Integer;
    class function CanExportIType(iType:Integer):Boolean;
 end;


const
 MetaDataSectionName = 'MetaData';
 MetaDataDBNamePath = MetaDataSectionName+'.DBName';
 MetaDataItemPath = MetaDataSectionName+'.Path';

 ITypeAppNameFolder='Folder';
 ITypeAppNamePlugin= 'AppPlugin';
 ITypeAppNameDialog= 'AppDialog';
 ITypeAppNameDialogLayout = 'AppDialogLayout';
 ITypeAppNameCommonCommand= 'CommonCommand';
 ITypeAppNameCommand = 'Command';
 ITypeAppNameCommonFilter = 'CommonFilter';
 ITypeAppNameFilter = 'Filter';
 ITypeAppNameCommandGroup = 'CommandGroup';
 ITypeAppNameSQLScript = 'SQLScript';
 ITypeAppNamePascalScript = 'PascalScript';
 ITypeAppNameCSharpScript =  'CSharpScript';
 ITypeAppNameJsonText = 'JsonText';
 ITypeAppNameXMLText= 'XMLText';
 ITypeAppNameAppDataSet = 'AppDataSet';
 ITypeAppNameExternalFile= 'ExternalFile';
 ITypeAppNameAppTemplate = 'AppTemplate';
 ITypeAppNameDfClass= 'dfClass';
 ITypeAppNameDfTypes= 'dfTypes';
 ITypeAppNameDfScheme= 'dfScheme';
 ITypeAppNameAppReport= 'AppReport';
 _ITypeAppNameVersionManager = 'AssemblyVersion';

 DEFAULT_TABLE_OPEN_STATEMENT = 'SELECT * FROM [%s] WITH (NOLOCK) WHERE %s=%d';
 DEFAULT_TABLE_OPEN_DETAILS_STATEMENT = 'SELECT * FROM [%s] WITH (NOLOCK) WHERE %s IN (%s)';


 resourcestring
 E_JSONPATH_NOT_FOUND = 'Cannot find requested path %s';

 S_IMPORTEXPORT_TABLEHINT_APPMAINTREE='Represent item in Main Menu(including user menu)';
 S_IMPORTEXPORT_TABLEHINT_COLUMNS='Columns properties';
 S_IMPORTEXPORT_TABLEHINT_COLORS='Grid colors properties';
 S_IMPORTEXPORT_TABLEHINT_PLUGIN='Main properties of Plugin';
 S_IMPORTEXPORT_TABLEHINT_LAYOUT='Main properties of dialog layout. Note: Layout json is exported in seperate section of resulting Json';
 S_IMPORTEXPORT_TABLEHINT_LAYOUT_FLAGS='Auto Enable/disable flags for layout';
 S_IMPORTEXPORT_TABLEHINT_DIALOG='Main properties of Adaptive Dialog';
 S_IMPORTEXPORT_TABLEHINT_DIALOG_CONTROLS='Properties of all controls of selected dialog;';
 S_IMPORTEXPORT_TABLEHINT_DIALOG_COLUMNS='Include grid colums in assembly';
 S_IMPORTEXPORT_TABLEHINT_DIALOG_COLORS='Include grid line color rules in assembly';
 S_IMPORTEXPORT_TABLEHINT_DIALOG_DETAIL_TABLES='List of detail tables attached to dialog';
 S_IMPORTEXPORT_TABLEHINT_APPTEMPLATE='Main properties of template';
 S_IMPORTEXPORT_TABLEHINT_APPCOMMAND='Application command. If command is common, changes will affect ALL possible references on this command';
 S_IMPORTEXPORT_TABLEHINT_APPCOMMAND_PARAMS='Include command parameters';
 S_IMPORTEXPORT_TABLEHINT_APP_COMMAND_COMMON='Application common command';
 S_IMPORTEXPORT_TABLEHINT_DFSCHEMA='Only schema reference as Main Menu item';

 S_IMPORTEXPORT_TABLEHINT_APPTEMPLATE_NODES='Properties of all nodes of template';
 S_IMPORTEXPORT_TABLEHINT_DATASETS='Properties of all datasets within template';
 S_IMPORTEXPORT_TABLEHINT_FOLDER='Folder properties. Note: if parent folder does not exists on target, all children objects will fail to import';
 S_IMPORTEXPORT_TABLEHINT_APPSCRIPTS='Script body';
 S_IMPORTEXPORT_TABLEHINT_COMMANDGROUP='';
 S_IMPORTEXPORT_TABLEHINT_BINARYFILE='Include file content';
 S_IMPORTEXPORT_TABLEHINT_APPDATASET='Include dataset properties shown by Rename command (F2)';
 S_IMPORTEXPORT_TABLEHINT_DFCLASS='Include base properties of DocFlow class';
 S_IMPORTEXPORT_TABLEHINT_DFTYPES='Include base properties of DocFlow type and it Schema';
 S_IMPORTEXPORT_TABLEHINT_DFPATHFOLDERS='Include all Path Folders of DocFlow type';
 S_IMPORTEXPORT_TABLEHINT_DFPATHFOLDERS_ACTIONS='Include all actions';
 S_IMPORTEXPORT_TABLEHINT_DFPATHFOLDERS_RULES='Include all rules';
 S_IMPORTEXPORT_TABLEHINT_DFMETHODS='Include all Methods of DocFlow type';
 S_IMPORTEXPORT_TABLEHINT_SCRIPT_PLUGIN='Export script attached to a Plugin (if any)';

implementation

{ TMiceITypeEntity }

var
 FITypeClassExport:TDictionary<string,TMiceITypeEntityClass>;
 FITypeAppNameList:TDictionary<integer,string>;

function TMiceITypeEntity.FindDataSet(const TableName: string): TxDataSet;
var
 DataSet:TxDataSet;
begin
 for DataSet in Self.DataSets do
  if DataSet.TableName=TableName then
   Exit(DataSet);
 Result:=nil;
end;



class function TMiceITypeEntity.FindImportExportClass(const Name: string): TMiceITypeEntityClass;
resourcestring
 E_IMPORT_EXPORT_CLASS_NOT_FOUND_FMT = 'Unable to find import/export class for object "%s"';
begin
 if FITypeClassExport.ContainsKey(Name) then
  Result:=FITypeClassExport[Name]
   else
  raise Exception.CreateFmt(E_IMPORT_EXPORT_CLASS_NOT_FOUND_FMT,[Name]);
end;

procedure TMiceITypeEntity.ImportCheck;
begin
 if Assigned(FindDataSet('AppMainTree')) and Self.DataSetByName('AppMainTree').Active then
  ObjectIDs.CheckParentId(DataSetByName('AppMainTree'),'AppMainTree','ParentId');
end;

function TMiceITypeEntity.FindMetaProperty(const JsonPath: string): string;
begin
 if Assigned(JsonDataSets) and (JsonDataSets.TryGetValue(JsonPath, Result)=False) then
  raise Exception.CreateFmt(E_JSONPATH_NOT_FOUND,[JsonPath]);
end;


procedure TMiceITypeEntity.ImportSingleDataSet(DataSet: TxDataSet; jDataSet: TJsonArray;DeleteMissingKeyFields:Boolean);
var
 Importer:TJsonToDataSetConverter;
begin
 Importer:=TJsonToDataSetConverter.Create;
 try
 //если в сбореке есть 2 вставки одного итого же ИД, то берём 1ый набор данных, в который уже бюл добавлен этот ИД
  Importer.DataSet:=GlobalDataSetList.AddOrUseExisting(DataSet);
  Importer.KeyField:=DataSet.KeyField;
  Importer.JsonDataSet:=jDataSet;
  Importer.AfterInsert:=AddToObjectIds;
  Importer.DeleteMissingKeyFields:=DeleteMissingKeyFields;
  Importer.Fill;
  GlobalUpdateList.SetDataSet(GlobalDataSetList.AddOrUseExisting(DataSet));

  if Assigned(StatisticList) then
   StatisticList.SetImportStatistic(DataSet.TableName, Importer);
 finally
  Importer.Free;
 end;
end;

class function TMiceITypeEntity.iTypeToAppName(iType: Integer): string;
begin
 Result:=FITypeAppNameList[iType];
end;

procedure TMiceITypeEntity.OpenDataSets;
var
 DataSet:TxDataSet;
begin
for DataSet in Self.DataSets do
 if (DataSet.Tag=1) and (DataSet.Active=False) then
   DataSet.Open;
end;

procedure TMiceITypeEntity.CollectKeysDataSet(DataSet: TxDataSet; MasterKeyField: string; List: TList<integer>);
var
 AKeyValue:Integer;
begin
 DataSet.Open;
  while not DataSet.Eof do
   begin
    AKeyValue:=DataSet.FieldByName(MasterKeyField).AsInteger;
    if AppendDetailsRequired(DataSet) and (List.Contains(AKeyValue)=False) then
     List.Add(AKeyValue);
     DataSet.Next;
   end;

  DataSet.First;
end;

procedure TMiceITypeEntity.UpdateDetailsProviderNameOnExport(const MasterTable, MasterField,  TargetTable: string);
var
 List:TList<Integer>;
begin
  List:=TList<Integer>.Create;
  try
   CollectKeysDataSet(DataSetByName(MasterTable),MasterField, List);
   SetNewDetailsProvider(TargetTable, MasterField,List);
  finally
   List.Free;
  end;
end;

procedure TMiceITypeEntity.UpdateDetailsProviderNameOnImport(jDataSet:TJsonArray;const MasterTable, MasterField: string);
var
 List:TList<Integer>;
begin
 List:=TList<Integer>.Create;
 try
  Self.CollectKeysJsonArray(jDataSet, MasterField, List);
  SetNewDetailsProvider(MasterTable, MasterField,List);
 finally
   List.Free;
 end;
end;

procedure TMiceITypeEntity.CollectKeysJsonArray(jDataSet: TJsonArray; MasterField: string; List:TList<integer>);
var
 x:Integer;
 AObjectId:Integer;
begin
 for x:=0 to jDataSet.Count-1 do
  begin
   AObjectId:=jDataSet.Items[x].GetValue<Integer>(MasterField);
   if not List.Contains(AObjectId) then
    List.Add(AObjectId);
  end;
end;

function TMiceITypeEntity.TryImportDetails(const TableName, AKeyField : string; DeleteMissingKeyFields:Boolean): Boolean;
var
 jDataSet:TJsonArray;
 DataSet:TxDataSet;
begin
 Result:=JsonDataSets.TryGetValue(TableName,jDataSet);
 if Result then
  begin
   DataSet:=DataSetByName(TableName);
   UpdateDetailsProviderNameOnImport(jDataSet,TableName,AKeyField);
   DataSet.DBName:=Self.DBName;
   DataSet.Open;
   ImportSingleDataSet(DataSet,jDataSet, DeleteMissingKeyFields);
  end;
end;

function TMiceITypeEntity.TryImportObject(const TableName, AKeyField, AKeyFieldPath: string; DeleteMissingKeys:Boolean=False):Boolean;
var
 jDataSet:TJsonArray;
 DataSet:TxDataSet;
 AObjectId:Integer;
begin
 Result:=JsonDataSets.TryGetValue(TableName,jDataSet);
 if Result then
  begin
   DataSet:=DataSetByName(TableName);
   AObjectId:=JsonDataSets.GetValue<Integer>(AKeyFieldPath);
   SetNewProvider(TableName,AKeyField,AObjectId);
   DataSet.Open;
   ImportSingleDataSet(DataSet,jDataSet, DeleteMissingKeys);
  end;
end;

function TMiceITypeEntity.DataSetByName(const TableName: string): TxDataSet;
begin
 Result:=Self.FindDataSet(TableName);
 if not Assigned(Result) then
  raise Exception.CreateFmt(E_CANNOT_FIND_DATASET_FMT,[TableName]);
end;

destructor TMiceITypeEntity.Destroy;
begin
  FDataSets.Free;
  inherited;
end;

constructor TMiceITypeEntity.Create;
begin
 FDataSets:=TObjectList<TxDataSet>.Create;
 FDefaultDatasetState:=False;
end;


function TMiceITypeEntity.WriteNewMetaObject: TJsonObject;
begin
 Result:=TJsonObject.Create;
 Result.AddPair(KeyField,ObjectId);
 Result.AddPair('DBName',DBName);
 Result.AddPair('Caption',Caption);
 Result.AddPair('Path',AppMainTreePath);
 JsonDataSets.AddPair(MetaDataSectionName,Result);
end;

procedure TMiceITypeEntity.DoExport(JsonRootObject:TJsonObject);
begin
 CheckObjects;
 OpenDataSets;
 CalculateTotalRows;

 if Self.FTotalRowsCount>0 then
  begin
   FJsonDataSets:=TJsonObject.Create;
   FMetaObject:=WriteNewMetaObject;
   ExportDataSets;
   JsonRootObject.AddPair(Name,FJsonDataSets)
  end;
end;


procedure TMiceITypeEntity.ExportDataSets;
var
 jArray:TJsonArray;
 DataSet:TxDataSet;
begin
for DataSet in Self.DataSets do
 if (DataSet.Active) and (DataSet.RecordCount>0) and (DataSet.Tag=1) then
  begin
   DataSet.First;
   jArray:=TJsonDataConvert.DataSetToJsonObjectWebApi(DataSet);
   FJsonDataSets.AddPair(DataSet.TableName,jArray);
  end;
end;


function TMiceITypeEntity.AddDataSet(const TableName, KeyField, MasterField, DBName, Hint: string; Id:Integer):TxDataSet;
begin
 Result:=TxDataSet.Create(nil);
 Result.TableName:=TableName;
 Result.KeyField:=KeyField;
 Result.DBName:=DBName;
 Result.ProviderName:=Format(DEFAULT_TABLE_OPEN_STATEMENT, [Result.TableName, MasterField, Id]);
 Result.Source:=Self.ClassName+'.AddDataSet('+TableName+')';
 Result.Hint:=Hint;
 if DefaultDatasetState=True then
  Result.Tag:=1
   else
  Result.Tag:=0;
 FDataSets.Add(Result);
end;

procedure TMiceITypeEntity.AddToObjectIds(DataSet: TDataSet);
var
 Dx:TxDataSet;
begin
 Dx:=DataSet as TxDataSet;
 ObjectIDs.SetId(dx.TableName, dx.FieldByName(dx.KeyField).AsInteger);
end;

function TMiceITypeEntity.AppendDetailsRequired(DataSet: TxDataSet): Boolean;
begin
 Result:=True;
end;

class function TMiceITypeEntity.AppNameToiType(const Name: string): Integer;
resourcestring
 E_CANNOT_FIND_APP_NAME ='Cannot find iType for %s';
var
 x:Integer;
begin
 for x in FITypeAppNameList.Keys do
  if FITypeAppNameList[x]=Name then
   Exit(x);

 raise Exception.CreateFmt(E_CANNOT_FIND_APP_NAME,[Name]);
end;

procedure TMiceITypeEntity.CalculateTotalRows;
var
 DataSet:TxDataSet;
begin
FTotalRowsCount:=0;
for DataSet in Self.DataSets do
 if (DataSet.Active=True) and (DataSet.Tag=1) then
   FTotalRowsCount:=FTotalRowsCount+DataSet.RecordCount;
end;

class function TMiceITypeEntity.CanExportIType(iType: Integer): Boolean;
begin
 Result:=FITypeAppNameList.ContainsKey(iType) and FITypeClassExport.ContainsKey(FITypeAppNameList[iType]);
end;

procedure TMiceITypeEntity.CheckObjects;
resourcestring
 E_INVALID_OBJECT_FMT = 'Export error: %s not defined';
begin
 if (ObjectId<=0) then
  raise Exception.CreateFmt(E_INVALID_OBJECT_FMT,['ObjectId']);
 if Self.AppMainTreeId<=0 then
  raise Exception.CreateFmt(E_INVALID_OBJECT_FMT,['AppMainTreeId']);
 Self.AppNameToiType(Name);
end;

procedure TMiceITypeEntity.CheckZeroRows(DataSet: TDataSet);
resourcestring
 E_EXPORT_OBJECT_NOT_FOUND_FMT = 'Object %s not found with %s=%d';
begin
 if DataSet.RecordCount<=0 then
  raise Exception.CreateFmt(E_EXPORT_OBJECT_NOT_FOUND_FMT, [Name,KeyField,ObjectId]);
end;




class procedure TMiceITypeEntity.RegisterImportExportClass(const Name:string; AClass: TMiceITypeEntityClass);
begin
 FITypeClassExport.Add(Name, AClass);
end;


procedure TMiceITypeEntity.SetExportActivity(const TableName: string; Active: Boolean);
var
 ADataSet:TxDataSet;
begin
 ADataSet:=FindDataSet(TableName);
 if Active then
  ADataSet.Tag:=1
   else
  ADataSet.Tag:=0;
end;


procedure TMiceITypeEntity.SetNewDetailsProvider(const TargetTable, MasterField: string; List: TList<integer>);
var
 InClause:string;
begin
 if List.Count>0 then
  begin
   InClause:=TStringUtils.ListToStringLine(List,',');
   DataSetByName(TargetTable).ProviderName:=Format(DEFAULT_TABLE_OPEN_DETAILS_STATEMENT,[TargetTable,MasterField,InClause]);
  end
   else
  SetExportActivity(TargetTable,False);
end;

procedure TMiceITypeEntity.SetNewProvider(const TableName, MasterField: string;ObjectId: Integer);
var
 DataSet:TxDataSet;
begin
 DataSet:=Self.DataSetByName(TableName);
 DataSet.ProviderName:=Format(DEFAULT_TABLE_OPEN_STATEMENT, [DataSet.TableName, MasterField, ObjectId]);
end;


initialization
 FITypeClassExport:=TDictionary<string,TMiceITypeEntityClass>.Create;
 FITypeAppNameList:=TDictionary<integer,string>.Create;

 FITypeAppNameList.Add(iTypeFolder, ITypeAppNameFolder);
 FITypeAppNameList.Add(iTypePlugin, ITypeAppNamePlugin);
 FITypeAppNameList.Add(iTypeDialog, ITypeAppNameDialog);
 FITypeAppNameList.Add(iTypeAppDialogLayout, ITypeAppNameDialogLayout);
 FITypeAppNameList.Add(iTypeCommonCommand, ITypeAppNameCommonCommand);
 FITypeAppNameList.Add(iTypeCommand, ITypeAppNameCommand);
 FITypeAppNameList.Add(iTypeCommonFilter, ITypeAppNameCommonFilter);
 FITypeAppNameList.Add(iTypeFilter, ITypeAppNameFilter);
 FITypeAppNameList.Add(iTypeCommandGroup, ITypeAppNameCommandGroup);
 FITypeAppNameList.Add(iTypeSQLScript, ITypeAppNameSQLScript);
 FITypeAppNameList.Add(iTypePascalScript, ITypeAppNamePascalScript);
 FITypeAppNameList.Add(iTypeCSharpScript, ITypeAppNameCSharpScript);
 FITypeAppNameList.Add(iTypeJsonText, ITypeAppNameJsonText);
 FITypeAppNameList.Add(iTypeXMLText, ITypeAppNameXMLText);
 FITypeAppNameList.Add(iTypeAppDataSet, ITypeAppNameAppDataSet);
 FITypeAppNameList.Add(iTypeExternalFile, ITypeAppNameExternalFile);
 FITypeAppNameList.Add(iTypeAppTemplate, ITypeAppNameAppTemplate);
 FITypeAppNameList.Add(iTypeDfClass, ITypeAppNameDfClass);
 FITypeAppNameList.Add(iTypeDfTypes, ITypeAppNameDfTypes);
 FITypeAppNameList.Add(iTypeDfScheme, ITypeAppNameDfScheme);
 FITypeAppNameList.Add(iTypeAppReport, ITypeAppNameAppReport);




finalization
 FITypeClassExport.Free;
 FITypeAppNameList.Free;

end.
