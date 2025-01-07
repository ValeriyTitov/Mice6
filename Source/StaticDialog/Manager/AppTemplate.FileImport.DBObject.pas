unit AppTemplate.FileImport.DBObject;

interface
 uses
  AppTemplate.FileImport,
  StaticDialog.AppObjectSelector,
  DAC.DataBaseUtils,
  DAC.Provider.Columns.Finder,
  Common.StringUtils,
  System.Classes, System.SysUtils, System.Variants, Data.DB;

type
 TDBObjectTemplateImport = class(TAbstractTemplateImport)
   private
    FProviderName:string;
    FDBName: string;
    procedure ImportList(List:TDataBaseColumnList);
   public
    function ExecuteDialog:Boolean;override;
    property DBName:string read FDBName write FDBName;
    procedure Import; override;
   end;


implementation

function TDBObjectTemplateImport.ExecuteDialog: Boolean;
var
 ID:Integer;
 s:string;
begin
 Result:=TSysObjectSelectionDialog.ExecuteDialog(-4,ID,S, DBName); //allSQLObjects
 if Result then
  FProviderName:=S;
end;

procedure TDBObjectTemplateImport.Import;
var
 List:TDataBaseColumnList;
begin
 List:=TDataBaseColumnList.Create;
  try
   TProviderColumnsFinder.ToDBList(List, FProviderName, DBName);
   ImportList(List);
  finally
   List.Free;
  end;
end;


procedure TDBObjectTemplateImport.ImportList(List: TDataBaseColumnList);
var
 Column:TDatabaseColumn;
begin
 for Column in List do
  CreateNewItem(NewID,Self.RootParentId,TagTypeNameValue,Column.ColumnName,Column.DataTypeStr, ValueTypeJsonString);
end;

end.
