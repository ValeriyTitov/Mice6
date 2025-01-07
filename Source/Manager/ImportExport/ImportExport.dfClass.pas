unit ImportExport.dfClass;

interface
 uses
  System.SysUtils, System.Variants, System.Classes,
  System.Generics.Defaults, System.JSON,Data.DB,
  DAC.XDataSet,
  ImportExport.Entity;

 type
  TMiceAppdfClassEntity = class(TMiceITypeEntity)
  public
    procedure Populate; override;
    procedure ImportJsonDataSets; override;
    constructor Create; override;
    destructor Destroy; override;
  end;


implementation

constructor TMiceAppdfClassEntity.Create;
begin
  inherited;
  Self.Name:=ITypeAppNameDfClass;
  Self.KeyField:='dfClassesId';
  Self.KeyFieldPath:='dfClasses[0].dfClassesId';
end;

destructor TMiceAppdfClassEntity.Destroy;
begin

  inherited;
end;



procedure TMiceAppdfClassEntity.ImportJsonDataSets;
begin
 Populate;
 TryImportObject('AppMainTree','AppMainTreeId','AppMainTree[0].AppMainTreeId');
 DataSetByName('dfClasses').DBName:=FindMetaProperty(MetaDataDBNamePath);
 TryImportObject('dfClasses','dfClassesId','dfClasses[0].dfClassesId');
end;

procedure TMiceAppdfClassEntity.Populate;
begin
if DataSets.Count=0 then
 begin
  AddDataSet('AppMainTree','AppMainTreeId','AppMainTreeId','',S_IMPORTEXPORT_TABLEHINT_APPMAINTREE, AppMainTreeId);
  AddDataSet('dfClasses','dfClassesId','dfClassesId',DBName,S_IMPORTEXPORT_TABLEHINT_DFCLASS, ObjectId);
 end;
end;

initialization
 TMiceITypeEntity.RegisterImportExportClass(ITypeAppNameDfClass, TMiceAppdfClassEntity)

end.
