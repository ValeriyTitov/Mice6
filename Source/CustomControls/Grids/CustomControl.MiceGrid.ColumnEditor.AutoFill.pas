unit CustomControl.MiceGrid.ColumnEditor.AutoFill;

interface
 uses
  System.SysUtils, System.Variants, System.Classes,Data.DB,
  DAC.XDataSet,
  DAC.DatabaseUtils,
  DAC.Provider.Columns.Finder,
  Common.ResourceStrings,
  Common.StringUtils;

type
  TMiceGridAutoFiller = class
  private
    FColumnCount:Integer;
    FDataSet: TxDataSet;
    FDefaultReadOnlyState: Boolean;
    function ColumnExists(const FieldName: string): Boolean;
    procedure AutoFillFromList(List:TDataBaseColumnList);
    procedure AutoCreateColumn(Column:TDatabaseColumn);
    procedure SetCommonProperties(ADataSet:TxDataSet; Column: TDatabaseColumn);
    class function GetColumnWidth(ColumnType:Integer):Integer;
  public
    property DataSet:TxDataSet read FDataSet write FDataSet;
    property DefaultReadOnlyState:Boolean read FDefaultReadOnlyState write FDefaultReadOnlyState;
    procedure AutoFillColumns(const ProviderName, DBName:string);
    constructor Create;
    class procedure AutoFill(DataSet:TxDataSet; const ProviderName, DBName:string; DefaultReadOnlyState:Boolean);
    class procedure CreateDefaultColumn(DataSet:TDataSet; Column:TDatabaseColumn; AReadOnly:Boolean);
    class function FindColumnType(Column:TDatabaseColumn):Integer;
    class function CreateColumnName(const FieldName:string; ColumnCount:Integer):string;
  end;

implementation

{ TMiceGridAutoFiller }

procedure TMiceGridAutoFiller.AutoCreateColumn(Column: TDatabaseColumn);
var
 ADataSet:TxDataSet;
begin
 ADataSet:=TxDataSet.Create(nil);
 try
  ADataSet.ProviderName:='spui_AppFindCommonCaptionList';
  ADataSet.Source:='TMiceGridAutoFiller.AutoCreateColumn';
  ADataSet.SetParameter('DataField',Column.ColumnName);
  ADataSet.Open;
  DataSet.Append;
  if ADataSet.RecordCount>0 then
   SetCommonProperties(ADataSet, Column)
    else
   CreateDefaultColumn(DataSet,Column, DefaultReadOnlyState);

   if DataSet.FieldByName('FieldName').AsString.IsEmpty then
    DataSet.FieldByName('FieldName').AsString:=Column.ColumnName;

   if DataSet.FieldByName('ColumnName').AsString.IsEmpty then
    DataSet.FieldByName('ColumnName').AsString:=Self.CreateColumnName(Column.ColumnName, FColumnCount);

   DataSet.FieldByName('Visible').AsBoolean:=not DataSet.FieldByName('FieldName').AsString.ToLower.EndsWith('_hint');
   FColumnCount:=FColumnCount+1;
 finally
   ADataSet.Free;
 end;
end;

class procedure TMiceGridAutoFiller.AutoFill(DataSet: TxDataSet;  const ProviderName, DBName: string; DefaultReadOnlyState:Boolean);
var
 Filler:TMiceGridAutoFiller;
begin
 Filler:=TMiceGridAutoFiller.Create;
 try
  Filler.DefaultReadOnlyState:=DefaultReadOnlyState;
  Filler.DataSet:=DataSet;
  Filler.AutoFillColumns(ProviderName, DBName);
 finally
  Filler.Free;
 end;

end;

procedure TMiceGridAutoFiller.AutoFillColumns(const ProviderName, DBName:string);
var
 List:TDataBaseColumnList;
begin
 List:=TDataBaseColumnList.Create;
 try
  TProviderColumnsFinder.ToDBList(List, ProviderName, DBName);
  AutoFillFromList(List);
 finally
  List.Free;
 end;
end;

procedure TMiceGridAutoFiller.AutoFillFromList(List: TDataBaseColumnList);
var
 Column:TDatabaseColumn;
 B:TBookMark;
begin
 FColumnCount:=0;
 DataSet.DisableControls;
  try
   B:=DataSet.Bookmark;
    for Column in List do
     if not ColumnExists(Column.ColumnName) then
      AutoCreateColumn(Column);
  finally
   if DataSet.BookmarkValid(B) then
    DataSet.Bookmark:=B;

    DataSet.EnableControls;
  end;
end;

function TMiceGridAutoFiller.ColumnExists(const FieldName: string): Boolean;
begin
 Result:=DataSet.Locate('FieldName',FieldName,[loCaseInsensitive]);
end;

constructor TMiceGridAutoFiller.Create;
begin
  DefaultReadOnlyState:=True;
end;

class function TMiceGridAutoFiller.CreateColumnName(const FieldName: string;  ColumnCount: Integer): string;
resourcestring
 S_DEFAULT_NEW_COLUMN_NAME_PREFIX = 'Col';
begin
 Result:=S_DEFAULT_NEW_COLUMN_NAME_PREFIX+FieldName;
 if not IsValidIdent(Result, False) then
  Result:=S_DEFAULT_NEW_COLUMN_NAME_PREFIX+ColumnCount.ToString;
end;

class procedure TMiceGridAutoFiller.CreateDefaultColumn(DataSet:TDataSet; Column:TDatabaseColumn; AReadOnly:Boolean);
resourcestring
 S_DEFAULT_NEW_COLUMN = 'New column';
var
 ColType:Integer;
begin
 ColType:=FindColumnType(Column);
 if DataSet.FieldByName('AppColumnsId').IsNull then
  DataSet.FieldByName('AppColumnsId').AsInteger:=TDataBaseUtils.NewAppObjectId(sq_AppColumns);

 DataSet.FieldByName('Width').AsInteger:=GetColumnWidth(ColType);
 DataSet.FieldByName('ParentId').Clear;
 DataSet.FieldByName('ColType').AsInteger:=ColType;
 DataSet.FieldByName('CreateOrder').AsInteger:=DataSet.RecordCount*10;
 DataSet.FieldByName('Align').AsInteger:=0;
 DataSet.FieldByName('Visible').AsBoolean:=True;
 DataSet.FieldByName('Sizing').AsBoolean:=True;
 DataSet.FieldByName('Filter').AsBoolean:=True;
 DataSet.FieldByName('IsBand').AsBoolean:=False;
 DataSet.FieldByName('ReadOnly').AsBoolean:=AReadOnly;
 DataSet.FieldByName('SortOrder').AsInteger:=0; //none
 DataSet.FieldByName('Fixed').AsInteger:=0;
 DataSet.FieldByName('CardVisible').AsBoolean:=False;
 DataSet.FieldByName('CardBand').AsBoolean:=False;
 DataSet.FieldByName('Moving').AsBoolean:=False;
 if Assigned(Column) then
    begin
     DataSet.FieldByName('FieldName').AsString:=Column.ColumnName;
     DataSet.FieldByName('ColumnName').AsString:=CreateColumnName(Column.ColumnName, DataSet.RecordCount);
     DataSet.FieldByName('Caption').AsString:=Column.ColumnName;
    end
 else
  DataSet.FieldByName('Caption').AsString:=S_DEFAULT_NEW_COLUMN
end;

class function TMiceGridAutoFiller.FindColumnType(Column: TDatabaseColumn): Integer;
begin
Result:=0;
if Assigned(Column) then
 begin

  if Column.ColumnName.ToLower.Contains('curr') and (Column.DataType=ftInteger) then
   Result:=7
    else
  if Column.ColumnName.ToLower.Contains('imageindex') and (Column.DataType=ftInteger) then
   Result:=2
    else
  if Column.ColumnName.ToLower.Contains('account') and (Column.DataType=ftString) then
   Result:=4;

  if Result=0 then
   case Column.DataType of
    ftDate, ftTime, ftDateTime: Result:=8;
    ftBlob, ftMemo, ftGraphic, ftFmtMemo, ftTypedBinary: Result:=6;
    ftFloat, ftCurrency, ftBCD: Result:=9; //CurrencyNumber
//    ftWideString: Result:=0;
    ftBoolean: Result:=1;
   end;
 end
end;

class function TMiceGridAutoFiller.GetColumnWidth(ColumnType: Integer): Integer;
begin
 case ColumnType of
    0:Result:=100; //OtherColumn;
    1:Result:=40;  //CheckBoxColumn;
    2:Result:=20;  //ImageIndexColumn;
    3:Result:=100; //DropDownColumn;
    4:Result:=150; //SubAccountColumn;
    5:Result:=32;  //PictureColumn;
    6:Result:=32;  //PopupPictureColumn;
    7:Result:=50;  //CurrencyColumn;
    8:Result:=70;  //DateColumn;
   else
     Result:=100;
 end;
end;


procedure TMiceGridAutoFiller.SetCommonProperties(ADataSet: TxDataSet; Column: TDatabaseColumn);
var
 ColType:Integer;
 AutoColType:Integer;
 ColCaption:string;
begin
 DataSet.CopyRowFrom(ADataSet, False);

 DataSet.FieldByName('CreateOrder').AsInteger:=(DataSet.RecordCount+1)*10;

 ColCaption:=DataSet.FieldByName('Caption').AsString;
 if ColCaption.ToLower=Column.ColumnName.ToLower then
  DataSet.FieldByName('Width').AsInteger:=80;

 ColType:=DataSet.FieldByName('ColType').AsInteger;

 AutoColType:=FindColumnType(Column);
  if (ColType=0) and (AutoColType<>0) then
   DataSet.FieldByName('ColType').AsInteger:=AutoColType;
end;

end.
