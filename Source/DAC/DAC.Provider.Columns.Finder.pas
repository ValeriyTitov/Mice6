unit DAC.Provider.Columns.Finder;

interface

uses Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
     System.Classes, Data.DB,
     System.Generics.Collections, System.Generics.Defaults,
     Common.StringUtils,
     DAC.XDataSet,
     DAC.XParams.Utils,
     DAC.DatabaseUtils;

type
  TProviderColumnsFinder = class
   private
    FDBName: string;
    FProviderName: string;
    FProvider:TxDataSet;
    FList:TDataBaseColumnList;
    procedure FindParams;
    procedure ParamsFromDataSet(DataSet:TDataSet);
    procedure FindProcedureColumns;
    procedure FindTableColumns;
 public
    property ProviderName:string read FProviderName write FProviderName;
    property DBName:string read FDBName write FDBName;
    procedure ToDataList(List:TDataBaseColumnList);
    procedure ToStringList(List:TStrings);
    procedure Execute;
    constructor Create;
    destructor Destroy; override;
    class procedure ToList(List:TStrings; const ProviderName,DBName:string);
    class procedure ToDBList(List:TDataBaseColumnList; const ProviderName,DBName:string);
  end;
implementation

{ TProviderColumns }



constructor TProviderColumnsFinder.Create;
begin
 inherited Create;
 FProvider:=TxDataSet.Create(nil);
 FProvider.Source:='DAC.'+ClassName;
 FList:=TDataBaseColumnList.Create;
end;

destructor TProviderColumnsFinder.Destroy;
begin
  FList.Free;
  FProvider.Free;
  inherited;
end;

procedure TProviderColumnsFinder.Execute;
var
 oType:TDatabaseObjectType;
begin
 FList.Clear;
 FProvider.ProviderName:=Self.ProviderName;
 FProvider.DBName:=Self.DBName;
 oType:=TDataBaseUtils.GetObjectType(ProviderName,DBName);
 case oType of
   otStoredProc: FindProcedureColumns;
   otTable: FindTableColumns;
   otView: FindTableColumns;
   else raise Exception.Create('Unknown object type.');
 end;

end;

procedure TProviderColumnsFinder.FindParams;
var
 DataSet:TxDataSet;
begin
 DataSet:=TxDataSet.Create(nil);
 try
   DataSet.Source:='DAC.TProviderColumnsFinder.FindParams';
   DataSet.ProviderName:='spsys_GetProcedureParams';
   DataSet.SetParameter('ProcedureName',FProvider.CommandName);
   DataSet.DBName:=DBName;
   DataSet.Open;
   ParamsFromDataSet(DataSet);
 finally
   DataSet.Free;
 end;

end;

procedure TProviderColumnsFinder.FindProcedureColumns;
var
 Field:TField;
 Column:TDataBaseColumn;
begin
 FindParams;
 FProvider.Open;
  for Field in FProvider.Fields do
   begin
    Column:=TDataBaseColumn.Create;
    Column.LoadFromField(Field);
    FList.Add(Column);
   end;
end;


procedure TProviderColumnsFinder.FindTableColumns;
begin
 TDataBaseUtils.GetTableColumns(ProviderName,FList,DBName);
end;

procedure TProviderColumnsFinder.ParamsFromDataSet(DataSet: TDataSet);
begin
 FProvider.Params.Clear;
 while not DataSet.Eof do
  begin
    FProvider.SetParameter(DataSet.FieldByName('PARAMETER_NAME').AsString, NULL);
    DataSet.Next;
  end;
end;

procedure TProviderColumnsFinder.ToDataList(List: TDataBaseColumnList);
var
 Column:TDataBaseColumn;
begin
if not FProvider.Active then
 Execute;
List.Clear;

for Column in FList do
 List.Add(Column.Clone);

end;

class procedure TProviderColumnsFinder.ToDBList(List: TDataBaseColumnList;  const ProviderName, DBName: string);
var
 Finder:TProviderColumnsFinder;
begin
 Finder:=TProviderColumnsFinder.Create;
 try
  Finder.ProviderName:=ProviderName;
  Finder.DBName:=DBName;
  Finder.ToDataList(List);
 finally
  Finder.Free;
 end;
end;

class procedure TProviderColumnsFinder.ToList(List: TStrings; const ProviderName, DBName: string);
var
 Finder:TProviderColumnsFinder;
begin
 Finder:=TProviderColumnsFinder.Create;
 try
  Finder.ProviderName:=ProviderName;
  Finder.DBName:=DBName;
  Finder.ToStringList(List);
 finally
  Finder.Free;
 end;
end;

procedure TProviderColumnsFinder.ToStringList(List: TStrings);
var
 DBList:TDataBaseColumnList;
 Column:TDataBaseColumn;
begin
 DBList:=TDataBaseColumnList.Create;
 try
  ToDataList(DBList);
  for Column in DBList do
   List.Add(Column.ColumnName);
 finally
  DBList.Free;
 end;
end;

end.
