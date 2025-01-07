unit AppTemplate.FileImport.Xbrl;

interface

uses  Data.DB, System.Classes, System.SysUtils, System.Variants,
      AppTemplate.FileImport,
      DAC.DataBaseUtils,
      DAC.Provider.Columns.Finder,
      Common.StringUtils,
      TaxonomyReader.LogForm,
      VCL.Dialogs;


type
 TXbrlTemplateImport = class(TAbstractTemplateImport)
   private
    procedure DoAddNewRow(DataSet:TDataSet);
   public
    procedure Import; override;
    constructor Create(SchemaDataSet:TDataSet); override;
    destructor Destroy; override;
 end;

implementation

{ TXbrlTemplateImport }
resourcestring
 S_XBRL_FILES_FILTER = 'XBRL entry points |*.xsd';

constructor TXbrlTemplateImport.Create(SchemaDataSet:TDataSet);
begin
  inherited;
  OpenDialog.Filter:=S_XBRL_FILES_FILTER;
end;

destructor TXbrlTemplateImport.Destroy;
begin

  inherited;
end;

procedure TXbrlTemplateImport.DoAddNewRow(DataSet: TDataSet);
begin
 NewItem(DataSet, NewID,NULL,TagTypeNameValue, '','', ValueTypeJsonString);
end;

procedure TXbrlTemplateImport.Import;
begin
  inherited;
  TTaxonomyReaderLogForm.Execute(FileName, DataSet, DoAddNewRow);
//  CreateNewItem(NewID,Self.RootParentId,TagTypeNameValue,Column.ColumnName,Column.DataTypeStr);
end;

end.
