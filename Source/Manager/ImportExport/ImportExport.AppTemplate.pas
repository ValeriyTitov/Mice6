unit ImportExport.AppTemplate;

interface
 uses
  System.SysUtils, System.Variants, System.Classes,
  System.Generics.Defaults, System.JSON,Data.DB,
  DAC.XDataSet,
  ImportExport.ItemLists,
  ImportExport.Entity;

 type
  TMiceAppTemplateEntity = class(TMiceITypeEntity)
   private
    FParents: TParentIdObjectList;
  public
    procedure Populate; override;
    procedure ImportJsonDataSets; override;
    procedure ImportCheck; override;
    constructor Create; override;
    destructor Destroy; override;
  end;


implementation

{ TMiceAppTemplateEntity }

constructor TMiceAppTemplateEntity.Create;
begin
  inherited;
  Name:=ITypeAppNameAppTemplate;
  KeyField:='AppTemplatesId';
  KeyFieldPath:='AppTemplates[0].'+KeyField;
  FParents:=TParentIdObjectList.Create;
end;

destructor TMiceAppTemplateEntity.Destroy;
begin
  FParents.Free;
  inherited;
end;

procedure TMiceAppTemplateEntity.ImportCheck;
begin
  inherited;
  if Assigned(FindDataSet('AppTemplatesData')) and Self.DataSetByName('AppTemplatesData').Active then
    FParents.CheckParentId(DataSetByName('AppTemplatesData'),'AppTemplatesData','ParentId');
end;

procedure TMiceAppTemplateEntity.ImportJsonDataSets;
begin
 Populate;
 TryImportObject('AppMainTree','AppMainTreeId','AppMainTree[0].AppMainTreeId');
 TryImportObject('AppTemplates','AppTemplatesId','AppTemplates[0].AppTemplatesId');
 if TryImportObject('AppTemplatesData','AppTemplatesId','AppTemplatesData[0].AppTemplatesId') then
  FParents.LoadFromDataSet(Self.DataSetByName('AppTemplatesData'), 'AppTemplatesData','AppTemplatesDataId');
 TryImportObject('AppTemplatesDataSets','AppTemplatesId','AppTemplatesDataSets[0].AppTemplatesId');

end;

procedure TMiceAppTemplateEntity.Populate;
begin
if Self.DataSets.Count=0 then
 begin
  AddDataSet('AppMainTree','AppMainTreeId','AppMainTreeId','',S_IMPORTEXPORT_TABLEHINT_APPMAINTREE,AppMainTreeId);
  AddDataSet('AppTemplates','AppTemplatesId','AppTemplatesId','',S_IMPORTEXPORT_TABLEHINT_APPTEMPLATE, ObjectId);
  AddDataSet('AppTemplatesData','AppTemplatesDataId','AppTemplatesId','',S_IMPORTEXPORT_TABLEHINT_APPTEMPLATE_NODES, ObjectId);
  AddDataSet('AppTemplatesDataSets','AppTemplatesDataSetsId','AppTemplatesId','',S_IMPORTEXPORT_TABLEHINT_DATASETS, ObjectId);
 end;
end;



initialization
 TMiceITypeEntity.RegisterImportExportClass(ITypeAppNameAppTemplate, TMiceAppTemplateEntity)

end.
