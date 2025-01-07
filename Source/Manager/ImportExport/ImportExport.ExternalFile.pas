unit ImportExport.ExternalFile;

interface
 uses
  System.SysUtils, System.Variants, System.Classes,
  System.Generics.Defaults, System.JSON,Data.DB,
  DAC.XDataSet,
  ImportExport.Entity;

 type
  TMiceExternalFileEntity = class(TMiceITypeEntity)
    procedure Populate; override;
  public
    procedure ImportJsonDataSets; override;
    constructor Create; override;
    destructor Destroy; override;
  end;


implementation



{ TMiceFolderEntity }


constructor TMiceExternalFileEntity.Create;
begin
  inherited;
  Self.Name:=ITypeAppNameExternalFile;
  Self.KeyField:='AppBinaryFilesId';
  Self.KeyFieldPath:='AppBinaryFiles[0].AppBinaryFilesId';
end;

destructor TMiceExternalFileEntity.Destroy;
begin

  inherited;
end;

procedure TMiceExternalFileEntity.ImportJsonDataSets;
begin
 Populate;
 TryImportObject('AppMainTree','AppMainTreeId','AppMainTree[0].AppMainTreeId');
 TryImportObject('AppBinaryFiles','AppBinaryFilesId','AppBinaryFiles[0].AppBinaryFilesId');
end;

procedure TMiceExternalFileEntity.Populate;
begin
if DataSets.Count=0 then
 begin
  AddDataSet('AppMainTree','AppMainTreeId','AppMainTreeId','',S_IMPORTEXPORT_TABLEHINT_APPMAINTREE, AppMainTreeId);
  AddDataSet('AppBinaryFiles','AppBinaryFilesId','AppBinaryFilesId','',S_IMPORTEXPORT_TABLEHINT_BINARYFILE, ObjectId);
//  raise Exception.Create('Error Message');
 end;
end;

initialization
 TMiceITypeEntity.RegisterImportExportClass(ITypeAppNameExternalFile, TMiceExternalFileEntity)

end.
