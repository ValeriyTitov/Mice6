unit ImportExport.AppScripts;

interface
 uses
  System.SysUtils, System.Variants, System.Classes,
  System.Generics.Defaults, System.JSON,Data.DB,
  DAC.XDataSet,
  ImportExport.Entity;

 type
  TMiceAppScriptsEntity = class(TMiceITypeEntity)
    procedure Populate; override;
  public
    procedure ImportJsonDataSets; override;
    constructor Create; override;
    destructor Destroy; override;
  end;


  TMiceSQLScriptEntity  = class(TMiceAppScriptsEntity)
  public
   constructor Create; override;
  end;

  TMicePascalScriptEntity  = class(TMiceAppScriptsEntity)
  public
   constructor Create; override;
  end;

  TMiceCSharpScriptEntity  = class(TMiceAppScriptsEntity)
  public
   constructor Create; override;
  end;

  TMiceJsonTextEntity  = class(TMiceAppScriptsEntity)
  public
   constructor Create; override;
  end;

  TMiceXMLTextEntity  = class(TMiceAppScriptsEntity)
  public
   constructor Create; override;
  end;




implementation

{ TMiceFolderEntity }


constructor TMiceAppScriptsEntity.Create;
begin
  inherited;
  Self.Name:='';
  Self.KeyField:='AppScriptsId';
  Self.KeyFieldPath:='AppScripts[0].AppScriptsId';
end;

destructor TMiceAppScriptsEntity.Destroy;
begin

  inherited;
end;

procedure TMiceAppScriptsEntity.ImportJsonDataSets;
begin
 Populate;
 TryImportObject('AppMainTree','AppMainTreeId','AppMainTree[0].AppMainTreeId');
 TryImportObject('AppScripts','AppScriptsId','AppScripts[0].AppScriptsId');
end;

procedure TMiceAppScriptsEntity.Populate;
begin
if Self.DataSets.Count=0 then
 begin
  AddDataSet('AppMainTree','AppMainTreeId','AppMainTreeId','',S_IMPORTEXPORT_TABLEHINT_APPMAINTREE, AppMainTreeId);
  AddDataSet('AppScripts','AppScriptsId','AppScriptsId','',S_IMPORTEXPORT_TABLEHINT_APPSCRIPTS, ObjectId);
 end;
end;


{ TMiceXMLTextEntity }

constructor TMiceXMLTextEntity.Create;
begin
  inherited;
  Self.Name:=ITypeAppNameXMLText;
end;

{ TMiceJsonTextEntity }

constructor TMiceJsonTextEntity.Create;
begin
  inherited;
  Name:=ITypeAppNameJsonText;
end;

{ TMiceCSharpScriptEntity }

constructor TMiceCSharpScriptEntity.Create;
begin
  inherited;
  Name:=ITypeAppNameCSharpScript;
end;

{ TMicePascalScriptEntity }

constructor TMicePascalScriptEntity.Create;
begin
  inherited;
  Name:=ITypeAppNamePascalScript;

end;

{ TMiceSQLScriptEntity }

constructor TMiceSQLScriptEntity.Create;
begin
  inherited;
  Name:=ITypeAppNameSQLScript;
end;

initialization

 TMiceITypeEntity.RegisterImportExportClass(ITypeAppNameSQLScript, TMiceSQLScriptEntity);
 TMiceITypeEntity.RegisterImportExportClass(ITypeAppNamePascalScript, TMicePascalScriptEntity);
 TMiceITypeEntity.RegisterImportExportClass(ITypeAppNameCSharpScript, TMiceCSharpScriptEntity);
 TMiceITypeEntity.RegisterImportExportClass(ITypeAppNameJsonText, TMiceJsonTextEntity);
 TMiceITypeEntity.RegisterImportExportClass(ITypeAppNameXMLText, TMiceXMLTextEntity);


end.
