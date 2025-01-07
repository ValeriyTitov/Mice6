unit ImportExport.VersionReader;

interface
 uses
  System.SysUtils, System.Variants, System.Classes,
  System.Generics.Defaults, System.JSON,Data.DB,
  DAC.XDataSet,
  ImportExport.Entity;

 type
  TMiceVersionReaderEntity = class(TMiceITypeEntity)
  public
    procedure ImportJsonDataSets; override;
    procedure DoExport(JsonRootObject:TJsonObject);override;
    constructor Create; override;
    destructor Destroy; override;
  end;


implementation

const
 S_UTF8_ENCODED_VERSION_TEXT = 'Версия сборки 1';

{ TMiceFolderEntity }


constructor TMiceVersionReaderEntity.Create;
begin
  inherited;
  Name:=_ITypeAppNameVersionManager;
end;

destructor TMiceVersionReaderEntity.Destroy;
begin

  inherited;
end;

procedure TMiceVersionReaderEntity.DoExport(JsonRootObject: TJsonObject);
var
 JVersion:TJsonObject;
begin
 jVersion:=TJsonObject.Create;
 jVersion.AddPair('Version', S_UTF8_ENCODED_VERSION_TEXT);
 JsonRootObject.AddPair(Name,jVersion);
end;

procedure TMiceVersionReaderEntity.ImportJsonDataSets;
var
 jVersion:TJsonPair;
resourcestring
 E_CANNOT_FIND_VERSION_INFO = 'Version information is missing in assembly';
 E_VERSION_ASSEMBLY_VERSION_MISMATCH_FMT = 'This assembly requires another version of program. Assembly version:%s, supported: %s';
begin
 {if JsonDataSets.TryGetValue(_ITypeAppNameVersionManager,jVersion) then
  begin
   if jVersion.JsonValue.Value <>S_UTF8_ENCODED_VERSION_TEXT then
    raise Exception.CreateFmt(E_VERSION_ASSEMBLY_VERSION_MISMATCH_FMT,[jVersion.JsonValue.Value,S_UTF8_ENCODED_VERSION_TEXT]);
  end
   else
    raise Exception.Create(E_CANNOT_FIND_VERSION_INFO);
    }
end;

initialization
 TMiceITypeEntity.RegisterImportExportClass(_ITypeAppNameVersionManager, TMiceVersionReaderEntity)

end.
