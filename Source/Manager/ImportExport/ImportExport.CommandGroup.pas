unit ImportExport.CommandGroup;

interface
 uses
  System.SysUtils, System.Variants, System.Classes,
  System.Generics.Defaults, System.JSON,Data.DB,
  DAC.XDataSet,
  ImportExport.Entity;

 type
  TMiceCommandGroupEntity = class(TMiceITypeEntity)
    procedure Populate; override;
  public
    procedure ImportJsonDataSets; override;
    constructor Create; override;
    destructor Destroy; override;
  end;


implementation



{ TMiceFolderEntity }


constructor TMiceCommandGroupEntity.Create;
begin
  inherited;
  Self.Name:=ITypeAppNameCommandGroup;
  Self.KeyField:='AppMainTreeId';
  Self.KeyFieldPath:='AppMainTree[0].AppMainTreeId';
end;

destructor TMiceCommandGroupEntity.Destroy;
begin

  inherited;
end;

procedure TMiceCommandGroupEntity.ImportJsonDataSets;
begin
 Populate;
 TryImportObject('AppMainTree','AppMainTreeId','AppMainTree[0].AppMainTreeId');
end;

procedure TMiceCommandGroupEntity.Populate;
begin
ObjectId:=AppMainTreeId;
if Self.DataSets.Count=0 then
  AddDataSet('AppMainTree','AppMainTreeId','AppMainTreeId','',S_IMPORTEXPORT_TABLEHINT_FOLDER, AppMainTreeId);
end;

initialization
 TMiceITypeEntity.RegisterImportExportClass(ITypeAppNameCommandGroup, TMiceCommandGroupEntity)

end.
