unit ImportExport.AppDialogLayout;

interface
 uses
  System.SysUtils, System.Variants, System.Classes,
  System.Generics.Defaults, System.JSON,Data.DB,
  DAC.XDataSet,
  System.IOUtils,
  Common.ResourceStrings,
  ImportExport.Entity,
  DAC.Data.Convert;

 type
  TMiceAppDialogLayoutEntity = class(TMiceITypeEntity)
   protected
    procedure SetFIeldProperties(DataSet:TDataSet);
  public
    procedure ImportJsonDataSets; override;
    procedure Populate; override;
    procedure DoExport(JsonRootObject:TJsonObject);override;
    constructor Create; override;
    destructor Destroy; override;
  end;

implementation

{ TMiceLayoutEntity }
const
 sLayoutDataSection='JsonValue';

constructor TMiceAppDialogLayoutEntity.Create;
begin
  inherited;
  Name:=ITypeAppNameDialogLayout;
  KeyField:='AppDialogsLayoutId';
  KeyFieldPath:='AppDialogsLayout[0].'+KeyField;
end;

destructor TMiceAppDialogLayoutEntity.Destroy;
begin

  inherited;
end;

procedure TMiceAppDialogLayoutEntity.DoExport(JsonRootObject: TJsonObject);
begin
  DataSetByName('AppDialogsLayout').AfterOpen:=SetFIeldProperties;
  inherited;
end;

procedure TMiceAppDialogLayoutEntity.ImportJsonDataSets;
begin
 Self.Populate;
 TryImportObject('AppMainTree','AppMainTreeId','AppMainTree[0].AppMainTreeId');
 TryImportObject('AppDialogsLayout','AppDialogsLayoutId','AppDialogsLayout[0].AppDialogsLayoutId');
 TryImportObject('AppDialogsLayoutFlags','AppDialogsLayoutId','AppDialogsLayoutFlags[0].AppDialogsLayoutId');
end;

procedure TMiceAppDialogLayoutEntity.Populate;
begin
if Self.DataSets.Count=0 then
 begin
  AddDataSet('AppMainTree','AppMainTreeId','AppMainTreeId','',S_IMPORTEXPORT_TABLEHINT_APPMAINTREE, AppMainTreeId);
  AddDataSet('AppDialogsLayout','AppDialogsLayoutId','AppDialogsLayoutId','',S_IMPORTEXPORT_TABLEHINT_LAYOUT, ObjectId);
  AddDataSet('AppDialogsLayoutFlags','AppDialogsLayoutFlagsId','AppDialogsLayoutId','',S_IMPORTEXPORT_TABLEHINT_LAYOUT_FLAGS, ObjectId);
 end;
end;


procedure TMiceAppDialogLayoutEntity.SetFIeldProperties(DataSet: TDataSet);
begin
 DataSet.FieldByName('Layout').EditMask:=S_FIELD_CONTAINTS_JSON_TEXT;
end;

initialization
 TMiceITypeEntity.RegisterImportExportClass(ITypeAppNameDialogLayout, TMiceAppDialogLayoutEntity)


end.
