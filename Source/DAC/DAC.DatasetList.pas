unit DAC.DataSetList;

interface

uses
  System.SysUtils, System.Variants, System.Classes,
  System.Generics.Collections, System.Generics.Defaults, Data.DB,
  Common.StringUtils,
  Common.ResourceStrings,
  DAC.XDataSet,
  DAC.XParams,
  DAC.DataBaseUtils,
  DAC.XParams.Mapper;

type
  TDataSetList = class(TObjectDictionary<string, TDataSource>)
  private
    FMasterID: Integer;
    FReadonly: Boolean;
    FParams: TxParams;
    FMasterKeyField: string;
    FParamsMapper:TParamsMapper;
    FAfterScroll: TDataSetNotifyEvent;
    FOnFieldChange: TFieldNotifyEvent;
    procedure SetReadonly(const Value: Boolean);
    procedure UpdateProvider(DataSet:TDataSet);
    procedure AfterInsert(DataSet:TDataSet);
    procedure AfterOpen(DataSet:TDataSet);
   public
    property Readonly:Boolean read FReadonly write SetReadonly;
    property MasterID:Integer read FMasterID write FMasterID;
    property MasterKeyField:string read FMasterKeyField write FMasterKeyField;
    property ParamsMapper:TParamsMapper read FParamsMapper write FParamsMapper;
    function DataSetByName(const Name:string):TxDataSet;
    function FieldByName(const FieldName: string): TField;
    function CreateDataSource(const TableName, ProviderPattern, DBName, Source, ASequenceName, ASequenceDBName:string):TDataSource;
    function NameOf(DataSource:TDataSource):string;overload;
    function NameOf(DataSet:TDataSet):string;overload;
    function Modified:Boolean;
    property AfterScroll:TDataSetNotifyEvent read FAfterScroll write FAfterScroll;
    property OnFieldChange:TFieldNotifyEvent read FOnFieldChange write FOnFieldChange;

    procedure CloseAll;
    procedure OpenAll;
    procedure ApplyUpdatesAll;
    procedure ApplyUpdates(const Name:string);
    procedure LoadFromDataSet(DataSet:TDataSet);
    procedure LoadForAppDialog(AppDialogsId:integer);
    procedure ToList(List:TStrings);
    procedure ToListWithDBName(List:TStrings);
    procedure CopyFrom(DataSetList:TDataSetList);
    procedure ClearDataSets;
    procedure AssignFieldChangeEvents(DataSet:TDataSet);

    constructor Create;
    destructor Destroy; override;
  end;

implementation

{ TDataSetList }

const
 DEFAULT_DETAILS_OPEN_STATEMENT = 'SELECT * FROM [%S] WITH (NOLOCK) WHERE %S=%D';

function TDataSetList.CreateDataSource(const TableName, ProviderPattern, DBName, Source, ASequenceName, ASequenceDBName:string):TDataSource;
var
 DataSet:TxDataSet;
begin
 Result:=TDataSource.Create(nil);
 DataSet:=TxDataSet.Create(Result);
 DataSet.ProviderNamePattern:=ProviderPattern;
 DataSet.TableName:=TableName;
 DataSet.BeforeOpen:=UpdateProvider;
 DataSet.DBName:=DBName;
 DataSet.SequenceName:=ASequenceName;
 DataSet.SequenceDBName:=ASequenceDBName;
 DataSet.AfterInsert:=AfterInsert;
 DataSet.AfterOpen:=AfterOpen;
 DataSet.AfterScroll:=AfterScroll;
 Result.DataSet:=DataSet;
 Add(TableName,Result);
 if Source='' then
  DataSet.Source:='Detail DataSet - '+TableName
   else
  DataSet.Source:=Source;
end;


function TDataSetList.DataSetByName(const Name: string): TxDataSet;
begin
 if ContainsKey(Name) then
  Result:=Self[Name].DataSet as TxDataSet
   else
  raise Exception.CreateFmt(E_CANNOT_FIND_DATASET_FMT, [Name]);
end;

destructor TDataSetList.Destroy;
begin
  FParams.Free;
  inherited;
end;

function TDataSetList.FieldByName(const FieldName: string): TField;
var
 AName:string;
 AFieldName:string;
begin
 AName:=TStringUtils.LeftFromDot(FieldName,'');
 AFieldName:=TStringUtils.RightFromDot(FieldName,'');
 Result:= Self[AName].DataSet.FieldByName(AFieldName)
end;

procedure TDataSetList.LoadForAppDialog(AppDialogsId: integer);
var
 DataSet:TxDataSet;
begin
 DataSet:=TxDataSet.Create(nil);
 try
  DataSet.ProviderName:='spui_AppDialogDetailTableList';
  DataSet.SetParameter('AppDialogsId', AppDialogsId);
  DataSet.Source:='TDataSetList.LoadForAppDialog';
  DataSet.Open;
  LoadFromDataSet(DataSet);
 finally
   DataSet.Free;
 end;
end;

procedure TDataSetList.LoadFromDataSet(DataSet: TDataSet);
var
 ADataSet:TxDataSet;
begin
 while not DataSet.Eof do
   begin
    ADataSet:=CreateDataSource(DataSet.FieldByName('TableName').AsString,DataSet.FieldByName('ProviderPattern').AsString,DataSet.FieldByName('DBName').AsString,'', DataSet.FieldByName('SequenceName').AsString, DataSet.FieldByName('SequenceDBName').AsString).DataSet as TxDataSet;
    ADataSet.SetContext('AppDialogDetailTablesId',DataSet.FieldByName('AppDialogDetailTablesId').AsString);
    if Assigned(ParamsMapper) then
      ParamsMapper.AddSource(ADataSet,DataSet.FieldByName('TableName').AsString);
    if (DataSet.FieldByName('ReadOnly').IsNull=False) and (DataSet.FieldByName('ReadOnly').AsBoolean=True) then
     ADataSet.ReadOnly:=True;
    DataSet.Next;
   end;
end;

function TDataSetList.NameOf(DataSource: TDataSource): string;
var
 s:string;
begin
 s:='';
 for s in Keys do
  if Self[s]=DataSource then
   Exit(s);
end;

procedure TDataSetList.AfterInsert(DataSet: TDataSet);
var
 XDataSet:TxDataSet;
begin
 XDataSet:=DataSet as TxDataSet;
 if XDataSet.NeedSequence then
  XDataSet.FieldByName(XDataSet.KeyField).Value:=TDataBaseUtils.GetNextSequenceValue(XDataSet.SequenceName, XDataSet.SequenceDBName);
end;

procedure TDataSetList.AfterOpen(DataSet: TDataSet);
begin
 AssignFieldChangeEvents(DataSet);
end;

procedure TDataSetList.ApplyUpdates(const Name: string);
var
 DataSet:TxDataSet;
begin
  DataSet:=Self[Name].DataSet as TxDataSet;
  DataSet.TryUpdateMasterKey(MasterKeyField,MasterID);
  DataSet.ApplyUpdatesIfChanged;
end;

procedure TDataSetList.ApplyUpdatesAll;
var
 DataSet:TxDataSet;
 s:string;
begin
for s in Keys do
 begin
  DataSet:=Self[s].DataSet as TxDataSet;
  if DataSet.Active then
   begin
    DataSet.TryUpdateMasterKey(MasterKeyField,MasterID);
    DataSet.ApplyUpdatesIfChanged;
   end;
 end;
end;

procedure TDataSetList.AssignFieldChangeEvents(DataSet: TDataSet);
var
 Field:TField;
begin
 for Field in DataSet.Fields do
   Field.OnChange:=OnFieldChange;
end;

procedure TDataSetList.ClearDataSets;
var
 ADataSet:TxDataSet;
 s:string;
begin
 for s in Keys do
  begin
    ADataSet:=Self[s].DataSet as TxDataSet;
    ADataSet.Clear;
  end;
end;

procedure TDataSetList.CloseAll;
var
 DataSource:TDataSource;
begin
 for DataSource in Values do
 (DataSource.DataSet as TxDataSet).Close;
end;

procedure TDataSetList.CopyFrom(DataSetList: TDataSetList);
var
 ASource:TxDataSet;
 ADest:TxDataSet;
 s:string;
begin
 for s in DataSetList.Keys do
  begin
   ASource:=DataSetList[s].DataSet as TxDataSet;
   if ContainsKey(s) then
    ADest:=Self[s].DataSet as TxDataSet
     else
    ADest:=CreateDataSource(s,ASource.ProviderNamePattern,ASource.DBName, ASource.Source, ASource.SequenceName, ASource.SequenceDBName).DataSet as TxDataSet;

   if ADest.CopyExclusionList.IndexOf(MasterKeyField)<0 then
    ADest.CopyExclusionList.Add(MasterKeyField);
   ADest.LoadFromDataSet(ASource, False);
  end;
end;

constructor TDataSetList.Create;
begin
 inherited Create([doOwnsValues],TIStringComparer.Ordinal);
 FParams:=TxParams.Create;
 FReadOnly:=False;
end;


procedure TDataSetList.SetReadonly(const Value: Boolean);
var
 DataSource:TDataSource;
begin
 FReadonly := Value;
 for DataSource in Values do
  (DataSource.DataSet as TxDataSet).ReadOnly:=Value;
end;

procedure TDataSetList.ToList(List: TStrings);
var
 s:string;
 xDataSet:TxDataSet;
begin
for s in Keys do
 begin
  xDataSet:=Self.Items[s].DataSet as TxDataSet;
  List.Add(XDataSet.TableName)
 end;
end;

procedure TDataSetList.ToListWithDBName(List: TStrings);
var
 s:string;
 FDBName:string;
 xDataSet:TxDataSet;
begin
for s in Keys do
 begin
  xDataSet:=Self.Items[s].DataSet as TxDataSet;
  if xDataSet.DBName.Trim.IsEmpty then
   FDBName:=''
    else
   FDBName:=' ('+xDataSet.DBName+')';
  List.Add(s+FDBName);
 end;
end;

procedure TDataSetList.UpdateProvider(DataSet: TDataSet);
var
 XDataSet:TxDataSet;
begin
 XDataSet:= DataSet as TxDataSet;

 if (xDataSet.ProviderNamePattern='') then
  XDataSet.ProviderName:=Format(DEFAULT_DETAILS_OPEN_STATEMENT,[XDataSet.TableName, MasterKeyField, MasterID])
   else
  if Assigned(ParamsMapper) then
   ParamsMapper.MapDataSet(XDataSet);
end;

function TDataSetList.Modified: Boolean;
var
 s:string;
begin
 for s in Keys do
  if (Self[s].DataSet as TxDataSet).Modified then
   Exit(True);
 Result:=False;
end;

function TDataSetList.NameOf(DataSet: TDataSet): string;
var
 s:string;
begin
 s:='';
 for s in Keys do
  if Self[s].DataSet=DataSet then
   Exit(s);
end;

procedure TDataSetList.OpenAll;
var
 D:TDataSource;
begin
 for D in Values do
   D.DataSet.Open;
end;

end.
