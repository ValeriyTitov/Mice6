unit DAC.BaseDataSet;

interface
uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  FireDAC.Comp.Client,
  FireDAC.DatS,
  Data.DB,
  FireDAC.Stan.Error,

  FireDAC.Stan.Consts,

  DAC.ObjectModels.Exception,
  DAC.ObjectModels.ExecutionContext,
  DAC.ObjectModels.DataSetMessage,

  DAC.XDataSetHelper,
  DAC.ConnectionMngr,
  DAC.History,
  DAC.XParams.Utils,
  DAC.XParams,
  DAC.DataSnap;



type
 TCachePolicy = (cpAuto, cpForceOn, cpForceOff);

 TBaseDataSet=class(TFDMemTable)
  strict private
    FOpenOrExecute:Boolean;
    FCacheDuration: Integer;
    FCommandName: string;
    FParams:TxParams;
    FOpening:Boolean;
    FProviderIsStoredProc:Boolean;
    FParamsInitialized:Boolean;
    FSource: string;
    FApp:TMiceAppServerClient;
    FExecutionContext: TMiceExecutionContext;
    FHistoryIndex:Integer;
    FHash:string;
    FCacheRegion: string;
    FUseHistory: Boolean;
    FExactParams: Boolean;
    function GetProviderName: String;
    function InternalGetKeyField:String;
    function GetKeyField: String;
    function GetDBName: string;
    function GetStatus: TCommandStatus;
    function GetMessages: TMiceDataSetMessageList;
    function GetCacheRegion: string;
    procedure SetCommandName(const Value: string);
    procedure SetCacheDuration(const Value: Integer);
    procedure SetProvider(const Value: string);
    procedure SetDBName(const Value: string);
    procedure SetKeyField(const Value: string);
    function IsFakeException(E:Exception):Boolean;
  private
    FSequenceDBName: string;
    procedure SetSequenceDBName(const Value: string);
    function GetSequenceDBName: string;
  protected
    procedure InternalOpenCursor;
    procedure OpenCursor(InfoQuery:Boolean); override;
    procedure DoAfterOpen; override;
    procedure InitializeParams;
    procedure CreateHistoryEntry;
    procedure DoAppServerUpdate(UpdateHistoryIndex:Integer; const AName:string);
    function DoApplyUpdates(ATable: TFDDatSTable; AMaxErrors: Integer): Integer; override;
  public
    class procedure FindProviderParams(const ProviderName:string; ASource, ADest:TParams; const DBName:string);
    constructor Create(AOwner:TComponent); override;
    destructor Destroy; override;
    function KeyFieldValue:Variant;
    function CreateBasicHash:string;
    function CreateFinalHash:string;
    function Modified:Boolean;
    procedure GetParameters(AUseHistory:Boolean);
    procedure SetParameter(ParamName:string; const Value:Variant);
    procedure Execute(ATimes: Integer = 0; AOffset: Integer = 0);override;
    procedure ApplyUpdatesIfChanged;
    procedure OpenOrExecute; reintroduce;
    property ExecutionContext:TMiceExecutionContext read FExecutionContext;
    property Status:TCommandStatus read GetStatus;
  published
    property ProviderName:string read GetProviderName write SetProvider;
    property CommandName:string read FCommandName write SetCommandName;
    property CacheDuration:Integer read FCacheDuration write SetCacheDuration;
    property DBName:string read GetDBName write SetDBName;
    property SequenceDBName:string read GetSequenceDBName write SetSequenceDBName;
    property Params:TxParams read FParams;
    property KeyField:string read GetKeyField write SetKeyField;
    property Source:string read FSource write FSource;
    property Messages:TMiceDataSetMessageList read GetMessages;
    property CacheRegion:string read GetCacheRegion write FCacheRegion;
    property ExactParams:Boolean read FExactParams write FExactParams;
    property UseHistory:Boolean read FUseHistory write FUseHistory;
 end;

const
 sp_ParamsProcedure = 'spsys_GetProcedureParams';
 sp_ProcedureParamName = 'ProcedureName';

implementation


{ TXDataSet }

procedure TBaseDataSet.ApplyUpdatesIfChanged;
begin
 if State in [dsEdit, dsInsert] then
   Post;
  if UpdatesPending then
   ApplyUpdates;
end;

function TBaseDataSet.CreateBasicHash: string;
begin
 if Self.FProviderIsStoredProc then
  Result:=CommandName+' '+Params.ToString
   else
  Result:=CommandName;
end;

constructor TBaseDataSet.Create(AOwner: TComponent);
begin
  inherited;
  FExecutionContext:=TMiceExecutionContext.Create;
  FParams:=TxParams.Create;
  FParamsInitialized:=False;
  CachedUpdates:=True;
  FOpening:=False;
  Source:='INTERNAL: UNKNOWN';
  FApp:=TMiceAppServerClient.Create;
  FApp.ExecutionContext:=Self.ExecutionContext;
  UseHistory:=True;
  ExactParams:=False;
  FOpenOrExecute:=False;
end;

destructor TBaseDataSet.Destroy;
begin
  FParams.Free;
  FExecutionContext.Free;
  FApp.Free;
  inherited;
end;

procedure TBaseDataSet.DoAfterOpen;
begin
  TSQLExecutionHistory.UpdateEntry(FHistoryIndex,FHash,'',CacheDuration,Self.RecordCount,Status, Messages);
  inherited;
end;


function TBaseDataSet.DoApplyUpdates(ATable: TFDDatSTable;  AMaxErrors: Integer): Integer;
var
 UpdateHistoryIndex:Integer;
 AName:string;
begin
 AName:='APPLYING: '+ProviderName+' '+TParamUtils.ParamsToStr(Self.ExecutionContext.Params);
 UpdateHistoryIndex:=TSQLExecutionHistory.CreateEntry(AName,DBName,Source);
 Self.OnUpdateRecord:=FApp.UpdateRecordEvent;
 FApp.ExecutionContext.KeyField:=Self.KeyField;
 FApp.PrepareForUpdates(Self);
 Result:=inherited DoApplyUpdates(ATable,AMaxErrors);
 if Result<>0 then
  TSQLExecutionHistory.UpdateEntryError(UpdateHistoryIndex,AName,FApp.UpdateError, Messages)
   else
  DoAppServerUpdate(UpdateHistoryIndex, AName);
end;


procedure TBaseDataSet.DoAppServerUpdate(UpdateHistoryIndex:Integer; const AName:string);
var
 NewIdentity, Identity:Variant;
 AScopeIdentity:string;
 AErrorMsg:string;
begin
 try
  Identity:=TXDataSetHelper.FindIdentity(Self);
  FApp.ApplyUpdates(Self);
   NewIdentity:=TXDataSetHelper.FindIdentity(Self);
   if (VarIsNull(Identity) or (VarIsNumeric(Identity) and (Identity<0))) and (VarIsNull(NewIdentity)=False) then
      AScopeIdentity:='SCOPE_IDENTITY()='+VarToStr(NewIdentity)
       else
      AScopeIdentity:='';
     TSQLExecutionHistory.UpdateEntry(UpdateHistoryIndex,AName,AScopeIdentity,0,ChangeCount,etDirectQuery, Messages);
  except on E:Exception do
    begin
     if FApp.UpdateError.IsEmpty then
      AErrorMsg:=E.Message
       else
      AErrorMsg:=FApp.UpdateError;
     TSQLExecutionHistory.UpdateEntryError(UpdateHistoryIndex,AName,AErrorMsg, Messages);
     raise;
    end;
  end;
end;

procedure TBaseDataSet.Execute(ATimes: Integer = 0; AOffset: Integer = 0);
begin
 inherited;
 InitializeParams;
 CreateHistoryEntry;
   try
    ExecutionContext.CheckProviderNameEmpty;
    FApp.Execute;
    FHash:=CreateFinalHash;
    TSQLExecutionHistory.UpdateEntry(FHistoryIndex,FHash,'',CacheDuration,Self.RecordCount,Status, Messages);
   except on E:Exception do
    begin
     TSQLExecutionHistory.UpdateEntryError(FHistoryIndex,FHash,E.Message, Messages);
     raise;
    end;
  end;
end;

class procedure TBaseDataSet.FindProviderParams(const ProviderName:string; ASource, ADest:TParams; const DBName:string);
var
 DataSet:TBaseDataSet;
begin
 DataSet:=TBaseDataSet.Create(nil);
  try
   DataSet.ProviderName:=sp_ParamsProcedure;
   DataSet.SetParameter(sp_ProcedureParamName,TxDataSetHelper.FindProviderCommandName(ProviderName));
   DataSet.DBName:=TxDataSetHelper.FindProviderDBName(ProviderName,DBName);
   DataSet.Source:=S_METADATA_QUERY;
   DataSet.UseHistory:=False;
   DataSet.ExactParams:=True;
   DataSet.Open;
   DataSet.DisableControls;
   ADest.Clear;
   TParamUtils.FindMatchingParams(ASource,ADest,DataSet);
  finally
   DataSet.Free;
  end;
end;



procedure TBaseDataSet.SetCacheDuration(const Value: Integer);
begin
  FCacheDuration := Value;
end;


procedure TBaseDataSet.SetCommandName(const Value: string);
begin
  FParamsInitialized:=False;
  FCommandName := Value;
end;

procedure TBaseDataSet.SetDBName(const Value: String);
begin
  FParamsInitialized:=False;
  ExecutionContext.DBName := Value;
end;


procedure TBaseDataSet.SetKeyField(const Value: string);
begin
  if ExecutionContext.KeyField<>Value then
      ExecutionContext.KeyField:=Value;
end;

procedure TBaseDataSet.SetParameter(ParamName: string; const Value: Variant);
begin
 Params.SetParameter(ParamName,Value);
end;

function TBaseDataSet.GetCacheRegion: string;
begin
 if FCacheRegion.IsEmpty then
  FCacheRegion:=CommandName;
  Result := FCacheRegion;
end;

function TBaseDataSet.GetDBName: string;
begin
 Result:=ExecutionContext.DBName;
end;

function TBaseDataSet.GetKeyField: string;
begin
 if ExecutionContext.KeyField.IsEmpty then
  Result:=InternalGetKeyField
   else
  Result:=ExecutionContext.KeyField;
end;


function TBaseDataSet.GetMessages: TMiceDataSetMessageList;
begin
 Result:=FExecutionContext.Messages;
end;

procedure TBaseDataSet.GetParameters(AUseHistory: Boolean);
var
 DataSet:TBaseDataSet;
begin
 DataSet:=TBaseDataSet.Create(nil);
  try
   DataSet.ProviderName:=sp_ParamsProcedure;
   DataSet.SetParameter(sp_ProcedureParamName,ProviderName);
   DataSet.DBName:=DBName;
   DataSet.Source:=S_METADATA_QUERY;
   DataSet.UseHistory:=AUseHistory;
   DataSet.ExactParams:=True;
   DataSet.Open;
   DataSet.DisableControls;
   while not DataSet.Eof do
    begin
     SetParameter(TParamUtils.NormalizeParamName(DataSet.FieldByName('PARAMETER_NAME').AsString),NULL);
     DataSet.Next;
    end;
  finally
   DataSet.Free;
  end;
end;

function TBaseDataSet.GetProviderName: string;
begin
  Result:=ExecutionContext.ProviderName;
end;

function TBaseDataSet.GetSequenceDBName: string;
begin
 if FSequenceDBName.IsEmpty then
  Result:=DBName
   else
  Result:=FSequenceDBName;
end;

function TBaseDataSet.GetStatus: TCommandStatus;
begin
 Result:=TCommandStatus(FApp.ExecutionContext.Status);
end;

function TBaseDataSet.CreateFinalHash: string;
begin
 if FParamsInitialized=False then
  InitializeParams;

 Result:=ExecutionContext.CalculateHash;
end;

procedure TBaseDataSet.CreateHistoryEntry;
begin
FHash:=Self.CreateBasicHash;
 if UseHistory then
  FHistoryIndex:=TSQLExecutionHistory.CreateEntry(FHash, DBName,Source)
   else
  FHistoryIndex:=-1;
end;

procedure TBaseDataSet.InitializeParams;
begin
 if (FParamsInitialized=False) and (FProviderIsStoredProc=True) then
  begin
   if (ExactParams) or CommandName.Equals(sp_ParamsProcedure)  then
    ExecutionContext.Params.Assign(Self.Params)
     else
    FindProviderParams(ProviderName, Params, ExecutionContext.Params, DBName);

   FParamsInitialized:=True;
  end
   else
    TParamUtils.CloneExistingParamValues(Params, ExecutionContext.Params);
end;

function TBaseDataSet.InternalGetKeyField: string;
var
 X:integer;
begin
Result:='';
if Active then
 for x:=0 to FieldCount-1 do
  if Pos('id',Fields[x].FieldName.ToLower)>=1 then
   begin
     Result:=Fields[x].FieldName;
     ExecutionContext.KeyField:=Result;
     Exit;
   end;
end;

procedure TBaseDataSet.OpenCursor(InfoQuery: Boolean);
begin
if FOpening=False then
  CreateHistoryEntry;

 try
  InitializeParams;
  if FOpening=False then
   InternalOpenCursor
    else
   inherited;

 except on E:Exception do
  if IsFakeException(E) then
    TSQLExecutionHistory.UpdateEntry(FHistoryIndex,CreateFinalHash,'',CacheDuration,Self.RecordCount,Status, Messages)
    else
   begin
    TSQLExecutionHistory.UpdateEntryError(FHistoryIndex,FHash,E.Message, Messages);
    raise;
   end;
 end;
end;


procedure TBaseDataSet.InternalOpenCursor;
begin
  FOpening:=True;
   try
    ExecutionContext.CheckProviderNameEmpty;
    FApp.Fill(Self);
    FHash:=CreateFinalHash;
   finally
    FOpening:=False;
   end;
end;


function TBaseDataSet.IsFakeException(E: Exception): Boolean;
begin
 Result:= (E is EFDException) and (FOpenOrExecute) and (((E as EFDException).FDCode = er_FD_AccCmdMHRowSet) or ((E as EFDException).FDCode = er_FD_DSNoDataTable));
end;

function TBaseDataSet.KeyFieldValue: Variant;
begin
 Result:=FieldByName(KeyField).Value;
end;

function TBaseDataSet.Modified: Boolean;
var
 Field:TField;
begin
 Result:=UpdatesPending;
 if (Result=False) and Active then
  begin
   for Field in Fields do
    if (Field.IsBlob=False) and (Field.Value<>Field.OldValue) then
     Exit(True);
   Result:=False;
  end;
end;

procedure TBaseDataSet.OpenOrExecute;
begin
 try
  FOpenOrExecute:=True;
  Open;
 finally
  FOpenOrExecute:=False;
 end;
end;

procedure TBaseDataSet.SetProvider(const Value: string);
begin
 if Self.ProviderName<>Value then
  begin
   FParamsInitialized:=False;
   FProviderIsStoredProc:=TxDataSetHelper.ProviderIsStoredProc(Value);
   if FProviderIsStoredProc then
    begin
     FCommandName:=TxDataSetHelper.FindProviderCommandName(Value);
     DBName:=TxDataSetHelper.FindProviderDBName(Value, DBName);
     CacheDuration:=TxDataSetHelper.FindProviderCacheDuration(Value, CacheDuration);
    end
     else
      FCommandName:=Value;
   ExecutionContext.ProviderName:=Value;
  end;
end;

procedure TBaseDataSet.SetSequenceDBName(const Value: string);
begin
  FSequenceDBName := Value;
end;

end.
