unit ImportExport.AppDataSet;

interface
 uses
  System.SysUtils, System.Variants, System.Classes,
  System.Generics.Defaults, System.JSON,Data.DB,
  DAC.XDataSet,
  ImportExport.Entity;

 type
  TMiceAppDataSetEntity = class(TMiceITypeEntity)
    procedure Populate; override;
  public
    procedure ImportJsonDataSets; override;
    constructor Create; override;
    destructor Destroy; override;
  end;


implementation



{ TMiceFolderEntity }


constructor TMiceAppDataSetEntity.Create;
begin
  inherited;
  Self.Name:=ITypeAppNameAppDataSet;
  Self.KeyField:='AppDataSetsId';
  Self.KeyFieldPath:='AppDataSets[0].AppDataSetsId';
end;

destructor TMiceAppDataSetEntity.Destroy;
begin

  inherited;
end;

procedure TMiceAppDataSetEntity.ImportJsonDataSets;
begin
 Populate;
 TryImportObject('AppMainTree','AppMainTreeId','AppMainTree[0].AppMainTreeId');
 TryImportObject('AppDataSets','AppDataSetsId','AppDataSets[0].AppDataSetsId');
end;

procedure TMiceAppDataSetEntity.Populate;
begin
if DataSets.Count=0 then
 begin
  AddDataSet('AppMainTree','AppMainTreeId','AppMainTreeId','',S_IMPORTEXPORT_TABLEHINT_APPMAINTREE, AppMainTreeId);
  AddDataSet('AppDataSets','AppDataSetsId','AppDataSetsId','',S_IMPORTEXPORT_TABLEHINT_APPDATASET, ObjectId);
 end;
end;

initialization
 TMiceITypeEntity.RegisterImportExportClass(ITypeAppNameAppDataSet, TMiceAppDataSetEntity)

end.
