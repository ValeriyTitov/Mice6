unit ImportExport.dfSchema;

interface
 uses
  System.SysUtils, System.Variants, System.Classes,
  System.Generics.Defaults, System.JSON,Data.DB,
  DAC.XDataSet,
  ImportExport.Entity;

 type
  TMicedfSchemaEntity = class(TMiceITypeEntity)
    procedure Populate; override;
  public
    procedure ImportJsonDataSets; override;
    constructor Create; override;
    destructor Destroy; override;
  end;


implementation



{ TMiceFolderEntity }


constructor TMicedfSchemaEntity.Create;
begin
  inherited;
  Self.Name:=ITypeAppNameDfScheme;
  Self.KeyField:='AppMainTreeId';
  Self.KeyFieldPath:='AppMainTree[0].AppMainTreeId';
end;

destructor TMicedfSchemaEntity.Destroy;
begin

  inherited;
end;

procedure TMicedfSchemaEntity.ImportJsonDataSets;
begin
 Populate;
 TryImportObject('AppMainTree','AppMainTreeId','AppMainTree[0].AppMainTreeId');
end;

procedure TMicedfSchemaEntity.Populate;
begin
ObjectId:=AppMainTreeId;
if Self.DataSets.Count=0 then
  AddDataSet('AppMainTree','AppMainTreeId','AppMainTreeId','',S_IMPORTEXPORT_TABLEHINT_DFSCHEMA, AppMainTreeId);
end;

initialization
 TMiceITypeEntity.RegisterImportExportClass(ITypeAppNameDfScheme, TMicedfSchemaEntity)

end.
