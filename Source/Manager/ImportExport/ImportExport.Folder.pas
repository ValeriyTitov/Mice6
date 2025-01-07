unit ImportExport.Folder;

interface
 uses
  System.SysUtils, System.Variants, System.Classes,
  System.Generics.Defaults, System.JSON,Data.DB,
  DAC.XDataSet,
  ImportExport.Entity;

 type
  TMiceFolderEntity = class(TMiceITypeEntity)
    procedure Populate; override;
  public
    procedure ImportJsonDataSets; override;
    constructor Create; override;
    destructor Destroy; override;
  end;


implementation



{ TMiceFolderEntity }


constructor TMiceFolderEntity.Create;
begin
  inherited;
  Self.Name:=ITypeAppNameFolder;
  Self.KeyField:='AppMainTreeId';
  Self.KeyFieldPath:='AppMainTree[0].AppMainTreeId';
end;

destructor TMiceFolderEntity.Destroy;
begin

  inherited;
end;

procedure TMiceFolderEntity.ImportJsonDataSets;
begin
 Populate;
 TryImportObject('AppMainTree','AppMainTreeId','AppMainTree[0].AppMainTreeId');
end;

procedure TMiceFolderEntity.Populate;
begin
ObjectId:=AppMainTreeId;
if Self.DataSets.Count=0 then
  AddDataSet('AppMainTree','AppMainTreeId','AppMainTreeId','',S_IMPORTEXPORT_TABLEHINT_FOLDER, AppMainTreeId);
end;

initialization
 TMiceITypeEntity.RegisterImportExportClass(ITypeAppNameFolder, TMiceFolderEntity)

end.
