unit ImportExport.ItemLists;

interface
uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  System.IOUtils,
  Common.ResourceStrings,
  Common.StringUtils,
  DAC.XParams,
  DAC.XDataSet,
  StaticDialog.DBNameSelector,
  Dialog.MShowMessage,
  Dialog.ShowDataSet,
  DAC.DataSetList,
  DAC.Data.Convert,
  Data.DB,
  System.NetEncoding,  System.Generics.Collections,
  System.Generics.Defaults, System.JSON,
  Common.VariantUtils,
  Common.FormatSettings,
  ImportExport.Dialogs.LoadProgress;

type
 TParentIdObjectList = class
  private
    FList: TObjectDictionary<string,TDictionary<Integer,Integer>>;
  public
    constructor Create; virtual;
    destructor Destroy; override;
    procedure SetId(const TableName:string; Key:Integer; ParentId:Integer=0);
    procedure LoadFromDataSet(DataSet:TDataSet;const TableName, KeyField:string);
    procedure LoadFromList(List:TParentIdObjectList; const TableName:string);
    procedure CheckParentId(DataSet:TDataSet;const TableName, ParendIdField: string);
    function ContainsId(const TableName:string; AValue:Integer):Boolean;
    function HasTable(const TableName:string):Boolean;
    function DictByName(const TableName:string): TDictionary<Integer,Integer>;
 end;

 TGlobalDataSetList = class
  private
    FList: TObjectDictionary<string,TxDataSet>;
    function Hash(DataSet:TxDataSet):string;
  public
    constructor Create; virtual;
    destructor Destroy; override;
    function AddOrUseExisting(DataSet:TxDataSet):TxDataSet;
 end;

 TGlobalUpdateList = class
  private
    FList: TObjectDictionary<string,TList<TxDataSet>>;
    FListDelete: TObjectDictionary<string,TObjectList<TxDataSet>>;
    FTotal:Integer;
    FCurrent:Integer;
    FProgressForm: TLoadProgressForm;
    procedure UpdateProgress(const Name:string);
    procedure SetDeleteItem(DataSet:TxDataSet);
  public
  const
    DeleteQueueDfMethods = 'Delete:dfMethodsId';
    DeleteQueueDfPathFolders = 'Delete:dfPathFoldersId';
    property ProgressForm:TLoadProgressForm read FProgressForm write FProgressForm;
    constructor Create; virtual;
    destructor Destroy; override;
    procedure CalculateTotal;
    procedure SetDataSet(DataSet:TxDataSet);
    procedure ApplyUpdates(const TableName:string);
    procedure ApplyDelete(const QueueName:string);
    function AddToDeleteQueue(const QueueName, ProviderName, ParamName,DBName:string; ObjectId:Integer):TxDataSet;
 end;



implementation

{ TParentIdObjectList }

procedure TParentIdObjectList.CheckParentId(DataSet: TDataSet; const TableName,  ParendIdField: string);
var
 ParentIdField:TField;
resourcestring
 E_PARENT_IS_MISSING_FMT = 'The object "%s" cannot be imported because the object required for this assembly is missing: %s=%d (ParentId not found)';
begin
 DataSet.DisableControls;
 DataSet.First;
 try
   ParentIdField:=DataSet.FieldByName(ParendIdField);
   while not DataSet.Eof do
    begin
      if (ParentIdField.AsInteger<>0) and (not ContainsId(TableName,ParentIdField.AsInteger)) then
       raise Exception.CreateFmt(E_PARENT_IS_MISSING_FMT,[TableName,TableName,ParentIdField.AsInteger]);
      DataSet.Next;
    end;
 finally
   DataSet.EnableControls;
 end;
end;

function TParentIdObjectList.ContainsId(const TableName: string; AValue: Integer): Boolean;
begin
 Result:=(FList.ContainsKey(TableName)) and (FList[TableName].ContainsKey(AValue));
end;

constructor TParentIdObjectList.Create;
begin
  FList:=TObjectDictionary<string,TDictionary<Integer,Integer>>.Create([doOwnsValues]);
end;

destructor TParentIdObjectList.Destroy;
begin
  FList.Free;
  inherited;
end;

function TParentIdObjectList.DictByName( const TableName: string): TDictionary<Integer, Integer>;
begin
 Result:=FList[TableName];
end;

function TParentIdObjectList.HasTable(const TableName: string): Boolean;
begin
 Result:=Self.FList.ContainsKey(TableName);
end;

procedure TParentIdObjectList.LoadFromDataSet(DataSet: TDataSet; const TableName, KeyField: string);
begin
 DataSet.First;
 DataSet.DisableControls;
 while not DataSet.Eof do
  begin
   Self.SetId(TableName,DataSet.FieldByName(KeyField).AsInteger);
   DataSet.Next;
  end;
end;

procedure TParentIdObjectList.LoadFromList(List: TParentIdObjectList; const TableName: string);
var
 Key:Integer;
 Dict:TDictionary<Integer,Integer>;
begin
 if List.HasTable(TableName) then
  begin
   Dict:=List.DictByName(TableName);
   for Key in Dict.Values do
     SetId(TableName,Key);
  end;
end;

procedure TParentIdObjectList.SetId(const TableName: string; Key: Integer; ParentId:Integer=0);
var
 Dict:TDictionary<Integer,Integer>;
begin
 if not FList.ContainsKey(TableName) then
   FList.Add(TableName,TDictionary<Integer,Integer>.Create);

  Dict:=FList[TableName];
  if not Dict.ContainsKey(Key) then
    Dict.Add(Key, ParentId);
end;

{ TGlobalDataSetList }

function TGlobalDataSetList.AddOrUseExisting(DataSet: TxDataSet): TxDataSet;
var
 AHash:string;
begin
 AHash:=Hash(DataSet);
 if Self.FList.ContainsKey(AHash) then
  Result:=Self.FList[AHash]
   else
  begin
    Self.FList.Add(AHash,DataSet);
    Result:=DataSet;
  end;
end;

constructor TGlobalDataSetList.Create;
begin
 FList:=TObjectDictionary<string,TxDataSet>.Create;
end;

destructor TGlobalDataSetList.Destroy;
begin
   FList.Free;
  inherited;
end;

function TGlobalDataSetList.Hash(DataSet: TxDataSet): string;
begin
 Result:=DataSet.DBName+DataSet.ProviderName+DataSet.Filter;
end;

{ TGlobalUpdateList }

function TGlobalUpdateList.AddToDeleteQueue(const QueueName, ProviderName, ParamName, DBName: string; ObjectId: Integer): TxDataSet;
begin
 Result:=TxDataSet.Create(nil);
 Result.ProviderName:=ProviderName;
 Result.DBName:=DBName;
 Result.SetParameter(ParamName,ObjectId);
 Result.TableName:=QueueName;
 SetDeleteItem(Result);
end;

procedure TGlobalUpdateList.ApplyDelete(const QueueName: string);
var
 DataSet:TxDataSet;
begin
 if Self.FListDelete.ContainsKey(QueueName) then
  for DataSet in Self.FListDelete[QueueName] do
   begin
    UpdateProgress(DataSet.ProviderName);
//    Sleep(50);
    DataSet.Execute;
    FCurrent:=FCurrent+1;
   end;
end;

procedure TGlobalUpdateList.ApplyUpdates(const TableName: string);
var
 DataSet:TxDataSet;
begin
 if Self.FList.ContainsKey(TableName) then
  for DataSet in Self.FList[TableName] do
   begin
//    Sleep(50);
    UpdateProgress(DataSet.ProviderName+' '+Format(S_ROWS_FMT,[DataSet.RecordCount]));
    DataSet.ApplyUpdatesIfChanged;
    FCurrent:=FCurrent+1;
   end;
end;

procedure TGlobalUpdateList.CalculateTotal;
var
 AMax:Integer;
 s:string;
begin
 AMax:=0;
 for s in FList.Keys do
  AMax:=AMax+Flist[s].Count;

 for s in FListDelete.Keys do
  AMax:=AMax+FListDelete[s].Count;

 Self.FTotal:=AMax;
 Self.FCurrent:=0;
end;

constructor TGlobalUpdateList.Create;
begin
 FList:=TObjectDictionary<string,TList<TxDataSet>>.Create([doOwnsValues]);
 FListDelete:=TObjectDictionary<string,TObjectList<TxDataSet>>.Create([doOwnsValues]);
end;

destructor TGlobalUpdateList.Destroy;
begin
  FList.Free;
  FListDelete.Free;
  inherited;
end;

procedure TGlobalUpdateList.SetDataSet(DataSet: TxDataSet);
var
 AList:TList<TxDataSet>;
begin
 if not FList.ContainsKey(DataSet.TableName) then
  begin
    AList:=TList<TxDataSet>.Create;
    FList.Add(DataSet.TableName, AList);
  end;

  AList:=FList[DataSet.TableName];
  AList.Add(DataSet);
end;

procedure TGlobalUpdateList.SetDeleteItem(DataSet: TxDataSet);
var
 AList:TObjectList<TxDataSet>;
begin
 if not Self.FListDelete.ContainsKey(DataSet.TableName) then
  begin
    AList:=TObjectList<TxDataSet>.Create;
    FListDelete.Add(DataSet.TableName, AList);
  end;

  AList:=FListDelete[DataSet.TableName];
  AList.Add(DataSet);
end;


procedure TGlobalUpdateList.UpdateProgress(const Name:string);
begin
 if Assigned(Self.ProgressForm) then
  begin
   ProgressForm.AddText(Name,0);
   ProgressForm.SetProgress(Self.FCurrent, Self.FTotal);
  end;
end;

end.
