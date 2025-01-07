unit DAC.DatabaseUtils;

interface

uses Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
     System.Classes, Data.DB,
     System.Generics.Collections, System.Generics.Defaults,
     Common.StringUtils,
     DAC.ConnectionMngr,
     DAC.XDataSet,
     DAC.XParams.Utils;
type
 TDatabaseObjectType = (otUnknown, otStoredProc, otTable, otView, otTableFunction, otScalarFunction, otTrigger);

 TDatabaseColumn = class
  private
    FColumnDefault: string;
    FIsNullable: Boolean;
    FCharacterMaximumLength: Integer;
    FCharacterOctetLength: Integer;
    FDataType: TFieldType;
    FColumnName: string;
    FNumericPrecision: Integer;
    FDataTypeStr: string;
  public
    property ColumnName:string read FColumnName write FColumnName;
    property ColumnDefault:string read FColumnDefault write FColumnDefault;
    property IsNullable:Boolean read FIsNullable write FIsNullable;
    property DataType:TFieldType read FDataType write FDataType;
    property DataTypeStr:string read FDataTypeStr write FDataTypeStr;
    property CharacterMaximumLength:Integer read FCharacterMaximumLength write FCharacterMaximumLength;
    property CharacterOctetLength:Integer read FCharacterOctetLength write FCharacterOctetLength;
    property NumericPrecision:Integer read FNumericPrecision write FNumericPrecision;
    procedure LoadFromDataSet(DataSet:TDataSet);
    procedure LoadFromField(Field:TField);
    function Clone: TDatabaseColumn;
    class function CloneFrom(Column:TDatabaseColumn):TDatabaseColumn;
 end;

 TDataBaseColumnList = class (TObjectList<TDataBaseColumn>)
 end;

 TDataBaseUtils = class
   private
     class function GetObjectTypeStr(const AObjectName, ADBName:string): string;
   public
     class procedure GetTableColumns(const TableName, APrefix: string;ColumnNames: TStrings; const ADBName:string);overload;
     class procedure GetTableColumns(const TableName:string;Columns: TObjectList<TDataBaseColumn>; const ADBName:string);overload;
     class procedure FindCommonCaptionList(const DataField:string; List:TStrings);
     class procedure GetTableList(const DBName:string; List:TStrings);
     class function GetObjectType(const AObjectName, ADBName:String): TDatabaseObjectType;
     class function GetMaxTableID(const ATableName,AFieldName, DBName:string):Integer;
     class function FindTablePrimaryKey(const TableName, ADBName:string):TDatabaseColumn;
     class function NewAppObjectId(const SequenceName:string):Int64;
     class function GetNextSequenceValue(const SequenceName, ADBName:string):Int64;
     class function NewTreeItem(const Description: string; const ParentId:Variant; const iType, ObjectId, ImageIndex:Integer; const ADBName:string=''):Integer;
   end;

const
  SeqDb ='SeqDB';
  sq_AppBinaryFiles = 'sq_AppBinaryFiles';
  sq_AppMainTree = 'sq_AppMainTree';
  sq_AppIType = 'sq_AppIType';
  sq_AppDBNames = 'sq_AppDBNames';
  sq_AppDataSets = 'sq_AppDataSets';
  sq_AppGlobalParameters = 'sq_AppGlobalParameters';
  sq_AppGridColors = 'sq_AppGridColors';
  sq_AppColumns = 'sq_AppColumns';
  sq_AppCmdParams = 'sq_AppCmdParams';
  sq_AppCmd = 'sq_AppCmd';
  sq_AppDialogControls = 'sq_AppDialogControls';
  sq_AppDialogDetailTables = 'sq_AppDialogDetailTables';
  sq_AppDialogsLayoutFlags = 'sq_AppDialogsLayoutFlags';
  sq_AppDialogsLayout = 'sq_AppDialogsLayout';
  sq_AppDialogs = 'sq_AppDialogs';
  sq_AppPlugins = 'sq_AppPlugins';
  sq_AppPluginsCommonCmd = 'sq_AppPluginsCommonCmd';
  sq_AppReportsDataSets = 'sq_AppReportsDataSets';
  sq_AppReportsParams = 'sq_AppReportsParams';
  sq_AppReports = 'sq_AppReports';
  sq_AppScriptsParams = 'sq_AppScriptsParams';
  sq_AppScripts = 'sq_AppScripts';
  sq_AppTemplatesData = 'sq_AppTemplatesData';
  sq_AppTemplatesDataSets = 'sq_AppTemplatesDataSets';
  sq_AppTemplates = 'sq_AppTemplates';
  sq_dfPathFolderActions = 'sq_dfPathFolderActions';
  sq_dfPathFolderRules = 'sq_dfPathFolderRules';
  sq_dfMethods = 'sq_dfMethods';
  sq_dfPathFolders = 'sq_dfPathFolders';
  sq_dfTypes = 'sq_dfTypes';
  sq_dfClasses = 'sq_dfClasses';
  sq_dfActionsMessages = 'sq_dfActionsMessages';


implementation

{ TDataBaseUtils }

class function TDataBaseUtils.GetObjectTypeStr(const AObjectName, ADBName: String): String;
var
 Tmp:TxDataSet;
begin
Result:='';
 Tmp:=TxDataSet.Create(nil);
   try
    Tmp.ProviderName:='spsys_GetObjectType';
    Tmp.DBName:=ADBName;
    Tmp.SetParameter('@ObjectName',AObjectName);
    Tmp.Source:='DAC.TDatabaseUtils.GetObjectTypeStr';
    Tmp.Open;
    Result:=Trim(Tmp.Fields[0].AsString);
   finally
    Tmp.Free;
   end;
end;

class function TDataBaseUtils.GetNextSequenceValue(const SequenceName, ADBName: string): Int64;
var
 Tmp:TxDataSet;
begin
Tmp:=TxDataSet.Create(nil);
 try
  Tmp.ProviderName:='spsys_GetNextSequenceValue';
  Tmp.SetParameter('SequenceName',SequenceName);
  Tmp.DBName:=ADBName;
  Tmp.Source:='DAC.TDataBaseUtils.GetNextSequenceValue';
  Tmp.Open;
  Result:=Tmp.FieldByName('NewId').Value;
 finally
   Tmp.Free;
 end;
end;

class procedure TDataBaseUtils.GetTableColumns(const TableName: string; Columns: TObjectList<TDataBaseColumn>; const ADBName: string);
var
 Tmp:TxDataSet;
 Column:TDatabaseColumn;
begin
Tmp:=TxDataSet.Create(nil);
 try
  Tmp.ProviderName:='spsys_GetTableColumns';
  Tmp.SetParameter('TableName',TableName);
  Tmp.DBName:=ADBName;
  Tmp.Source:='DAC.TDatabaseUtils.GetTableColumns';
  Tmp.Open;
   while not Tmp.Eof do
    begin
     Column:=TDatabaseColumn.Create;
     Column.LoadFromDataSet(Tmp);
     Columns.Add(Column);
     Tmp.Next;
    end;
 finally
   Tmp.Free;
 end;
end;


class procedure TDataBaseUtils.GetTableList(const DBName: string;  List: TStrings);
var
 Tmp:TxDataSet;
const
 TableOrViews = -3;
begin
 Tmp:=TxDataSet.Create(nil);
  try
   Tmp.ProviderName:='spui_AppObjectList';
   Tmp.SetParameter('iType',TableOrViews);
   Tmp.DBName:=DBName;
   Tmp.Source:='TDataBaseUtils.GetTableList';
   Tmp.Open;
   List.BeginUpdate;
    while not Tmp.Eof do
     begin
      List.Add(Tmp.FieldByName('Caption').AsString);
      Tmp.Next;
     end;
  finally
   Tmp.Free;
   List.EndUpdate;
  end;
end;

class procedure TDataBaseUtils.GetTableColumns(const TableName, APrefix: string; ColumnNames: TStrings; const ADBName: String);
var
Tmp:TxDataSet;
begin
 Tmp:=TxDataSet.Create(nil);
  try
   Tmp.ProviderName:='spsys_GetTableColumns';
   Tmp.SetParameter('TableName',TableName);
   Tmp.DBName:=ADBName;
   Tmp.Source:='DAC.TDatabaseUtils.GetTableColumns';
   Tmp.Open;
    while not Tmp.Eof do
     begin
      ColumnNames.Add(APrefix+Tmp.FieldByName('COLUMN_NAME').AsString);
      Tmp.Next;
     end;
  finally
   Tmp.Free;
  end;
end;

class function TDataBaseUtils.NewAppObjectId(const SequenceName:string): Int64;
begin
 Result:=GetNextSequenceValue(SequenceName,ConnectionManager.SequenceServer);
end;

class function TDataBaseUtils.NewTreeItem(const Description: string; const ParentId: Variant; const iType, ObjectId, ImageIndex: Integer; const ADBName:string=''): Integer;
var
 Tmp:TxDataSet;
 AppMainTreeId:Integer;
begin
Tmp:=TxDataSet.Create(nil);
 try
  AppMainTreeId:=NewAppObjectId(sq_AppMainTree);
  Tmp.ProviderName:='spui_AppTreeInsertItem';
  Tmp.SetParameter('AppMainTreeId',AppMainTreeId);
  Tmp.SetParameter('Description',Description);
  Tmp.SetParameter('ParentId',ParentId);
  Tmp.SetParameter('iType',iType);
  Tmp.SetParameter('ImageIndex',ImageIndex);
  Tmp.SetParameter('ObjectId',ObjectId);
  if ADBName.IsEmpty then
   Tmp.SetParameter('DBName',NULL)
    else
   Tmp.SetParameter('DBName',ADBName);
  Tmp.Source:='TDataBaseUtils.NewTreeItem';
  Tmp.Open;
  Result:=Tmp.FieldByName('AppMainTreeId').AsInteger;
 finally
   Tmp.Free;
 end;
end;


class procedure TDataBaseUtils.FindCommonCaptionList(const DataField: string; List: TStrings);
var
 Tmp:TxDataSet;
 ADataField:string;
begin
 Tmp:=TxDataSet.Create(nil);
 try
  ADataField:=TStringUtils.RightFromDot(DataField, DataField);
  Tmp.ProviderName:='spui_AppFindCommonCaptionList';
  Tmp.Source:='DAC.TDatabaseUtils.FindCommonCaptionList';
  Tmp.SetParameter('DataField',ADataField);
  Tmp.Open;
   while not Tmp.Eof do
    begin
     List.Add(Tmp.FieldByName('Caption').AsString);
     Tmp.Next;
    end;
 finally
   Tmp.Free;
 end;
end;

class function TDataBaseUtils.FindTablePrimaryKey(const TableName,  ADBName: string): TDatabaseColumn;
var
 List:TDataBaseColumnList;
 Column:TDatabaseColumn;
begin
 raise Exception.Create('Not implemented');
 List:=TDataBaseColumnList.Create;
 try
  GetTableColumns(TableName,List,ADBName);
  for Column in List do;

 finally
  List.Free;
 end;

end;

class function TDataBaseUtils.GetMaxTableID(const ATableName, AFieldName,  DBName: string): Integer;
begin
  raise Exception.Create('Not implemented');
end;

class function TDataBaseUtils.GetObjectType(const AObjectName,  ADBName: String): TDatabaseObjectType;
var
 s:string;
begin
 s:=GetObjectTypeStr(AObjectName,ADBName);
 if s='P' then Result:=otStoredProc else
 if s='U' then Result:=otTable else
 if s='V' then Result:=otView else
 if s='TF' then Result:=otTableFunction else
 if s='FN' then Result:=otScalarFunction else
 if s='TR' then Result:=otTrigger else
  Result:=otUnknown;
end;


{ TDatabaseColumn }

function TDatabaseColumn.Clone: TDatabaseColumn;
begin
 Result:=CloneFrom(Self);
end;

class function TDatabaseColumn.CloneFrom(Column: TDatabaseColumn): TDatabaseColumn;
begin
if Assigned(Column) then
 begin
   Result:=TDatabaseColumn.Create;
   Result.ColumnName:=Column.ColumnName;
   Result.ColumnDefault:=Column.ColumnDefault;
   Result.IsNullable:=Column.IsNullable;
   Result.DataType:=Column.DataType;
   Result.DataTypeStr:=Column.DataTypeStr;
   Result.CharacterMaximumLength:=Column.CharacterMaximumLength;
   Result.CharacterOctetLength:=Column.CharacterOctetLength;
   Result.NumericPrecision:=Column.NumericPrecision;
 end
  else
 Result:=nil;
end;

procedure TDatabaseColumn.LoadFromDataSet(DataSet: TDataSet);
begin
  ColumnDefault:=DataSet.FieldByName('COLUMN_DEFAULT').AsString;
  IsNullable:=DataSet.FieldByName('IS_NULLABLE').AsBoolean;
  CharacterMaximumLength:=DataSet.FieldByName('CHARACTER_MAXIMUM_LENGTH').AsInteger;
  CharacterOctetLength:=DataSet.FieldByName('CHARACTER_OCTET_LENGTH').AsInteger;
  DataType:=TParamUtils.StringToFieldType(DataSet.FieldByName('DATA_TYPE').AsString);
  DataTypeStr:=DataSet.FieldByName('DATA_TYPE').AsString;
  ColumnName:=DataSet.FieldByName('COLUMN_NAME').AsString;
  NumericPrecision:=DataSet.FieldByName('NUMERIC_PRECISION').AsInteger;
end;

procedure TDatabaseColumn.LoadFromField(Field: TField);
begin
  ColumnDefault:='';
  IsNullable:=Field.DataType<>ftAutoInc;
  CharacterMaximumLength:=Field.Size;
  CharacterOctetLength:=0;
  DataType:=Field.DataType;
  DataTypeStr:=TParamUtils.FieldTypeToStr(DataType);
  ColumnName:=Field.FieldName;
  NumericPrecision:=0;
end;


end.
