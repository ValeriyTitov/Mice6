unit DAC.DataSnap;

interface

uses
 System.Classes, System.SysUtils,FireDac.Comp.Client,System.Json,
 FireDAC.Stan.Option, FireDAC.Stan.Intf, Data.DB, System.Variants,
 System.IOUtils,
 System.SyncObjs,
 Common.Config.ApplicationSettings,
 DAC.ObjectModels.ExecutionContext,
 DAC.ObjectModels.MiceData.Request,
 DAC.ObjectModels.MiceData.Response,
 DAC.ObjectModels.ApplyUpdates.Request,
 DAC.ObjectModels.ApplyUpdates.Response,
 DAC.ObjectModels.ApplyContent,
 DAC.ObjectModels.MiceUser,
 DAC.ConnectionMngr,
 DAC.DataCache,
 DAC.History,
 DAC.HttpClient;

type
 TMiceAppServerClient = class
  private
    FMiceHttpClient:TMiceHttpClient;
    FExecutionContext: TMiceExecutionContext;
    FMiceDataRequest:TMiceDataRequest;
    FApplyUpdatesRequest:TMiceApplyUpdatesRequest;
    FUpdateError: string;
    procedure CheckCacheAgain(const Hash:string; DataSet:TFDMemTable);
    procedure LoadFromCache(DataSet:TFDMemTable);
    procedure CheckKeyField;
    procedure ApplyToDataSet(jValue:TJsonValue;DataSet:TFDMemTable);
    procedure DirectFill(DataSet:TFDMemTable);
    procedure InteralUpdateRecordEvent(ASender: TDataSet;  ARequest: TFDUpdateRequest);
    procedure CheckToken;
  public
    procedure RefreshToken;
    procedure UpdateRecordEvent(ASender: TDataSet;  ARequest: TFDUpdateRequest; var AAction: TFDErrorAction;  AOptions: TFDUpdateRowOptions);
    procedure Fill(DataSet:TFDMemTable);
    procedure ApplyUpdates(DataSet:TFDMemTable);
    procedure PrepareForUpdates(DataSet:TFDMemTable);
    procedure Execute;
    property ExecutionContext:TMiceExecutionContext read FExecutionContext write FExecutionContext;
    property UpdateError: string read FUpdateError;
    constructor Create;
    destructor Destroy; override;
 end;

implementation

var
 FSection:TCriticalSection;

{ TMiceAppWebServer }

procedure TMiceAppServerClient.ApplyToDataSet(jValue:TJsonValue; DataSet: TFDMemTable);
var
  Response:TMiceApplyUpdatesResponse;
resourcestring
 S_APPLICATION_SERVER_UNKNOWN_UPDATE_ERROR = 'Application server unknown update error. Update was too large ?';
begin
 if not Assigned(jValue) then
  raise Exception.Create(S_APPLICATION_SERVER_UNKNOWN_UPDATE_ERROR);

 Response:=TMiceApplyUpdatesResponse.Create;
 try
  Response.LoadFromJsonValue(jValue);
  Response.ApplyToDataSet(DataSet,Self.ExecutionContext.KeyField);
 finally
   Response.Free;
 end;
end;

procedure TMiceAppServerClient.ApplyUpdates(DataSet:TFDMemTable);
var
 ResponseObject:TJsonValue;
begin
 CheckToken;
 ResponseObject:=FMiceHttpClient.CreateResponseObject(ApplicationSettings.FullPathApplyUpdates,FApplyUpdatesRequest.ToJsonString);
  try
//   TFile.WriteAllText('C:\ApplyRequest.json',FApplyUpdatesRequest.ToJsonString);
//   TFile.WriteAllText('C:\ApplyResponse.json',ResponseObject.Format);
   ApplyToDataSet(ResponseObject,DataSet);
  finally
   ResponseObject.Free;
  end;
end;

procedure TMiceAppServerClient.CheckCacheAgain(const Hash: string; DataSet:TFDMemTable);
begin
 try
  TMiceDataCache.EnterSection;
   if not TMiceDataCache.TryLoadFromCache(Hash,DataSet) then
    begin
     DirectFill(DataSet);
     TMiceDataCache.PutToCache(Hash, ExecutionContext.CommandName,ExecutionContext.CacheDuraion,DataSet);
     ExecutionContext.Status:=Integer(TCommandStatus.etJustLocallyCached);
    end
     else
      ExecutionContext.Status:=Integer(TCommandStatus.etLoadedFromLocalCache);
 finally
  TMiceDataCache.LeaveSection;
 end;
end;

procedure TMiceAppServerClient.CheckKeyField;
resourcestring
 S_KEY_FIELD_IS_NOT_DEFINED_IN_DATASET='Keyfield is not defined in DataSet. Cannot apply updates without keyfield.';
begin
  if Self.ExecutionContext.KeyField.IsEmpty then
   raise Exception.Create(S_KEY_FIELD_IS_NOT_DEFINED_IN_DATASET);
end;

procedure TMiceAppServerClient.CheckToken;
begin
 if TMiceUser.CurrentUser.Token.Expired then
  try
   FSection.Enter;
   if TMiceUser.CurrentUser.Token.Expired then
    RefreshToken;
  finally
   FSection.Leave;
  end;
end;

constructor TMiceAppServerClient.Create;
begin
 FMiceHttpClient:=TMiceHttpClient.Create(nil);
 FMiceDataRequest:=TMiceDataRequest.Create;
end;

destructor TMiceAppServerClient.Destroy;
begin
  FMiceHttpClient.Free;
  FMiceDataRequest.Free;
  FApplyUpdatesRequest.Free;
  inherited;
end;

procedure TMiceAppServerClient.DirectFill(DataSet: TFDMemTable);
var
 ResponseObject:TJsonValue;
begin
 CheckToken;
 FMiceDataRequest.ExecutionContext:=ExecutionContext;
 FMiceDataRequest.ExecutionContext.Messages.Clear;
 FMiceDataRequest.IsExecute:=not Assigned(DataSet);
 ResponseObject:=FMiceHttpClient.CreateResponseObject(ApplicationSettings.FullPathDataRequest,FMiceDataRequest.ToJsonString);
  try
//   ShowMessage(ResponseObject.Format);
   TMiceDataResponse.SerializeObjects(ResponseObject, DataSet, ExecutionContext);
  finally
   ResponseObject.Free;
  end;
end;

procedure TMiceAppServerClient.Execute;
begin
 DirectFill(nil);
end;

procedure TMiceAppServerClient.Fill(DataSet:TFDMemTable);
begin
  if TMiceDataCache.LocalCacheRequired(ExecutionContext.CommandName) then
   LoadFromCache(DataSet)
    else
   DirectFill(DataSet);
end;


procedure TMiceAppServerClient.InteralUpdateRecordEvent(ASender: TDataSet;  ARequest: TFDUpdateRequest);
var
 UpdateItem:TDataSetRow;
resourcestring
 E_KEYFIELD_UPDATE_ON_NULL = 'Attempt to apply updates with NULL value on keyfield';
begin
 UpdateItem:=TDataSetRow.Create;
 FApplyUpdatesRequest.ApplyContext.Add(UpdateItem);
 UpdateItem.UpdateRequest:=ARequest;
 UpdateItem.KeyField:=ExecutionContext.KeyField;
 if VarIsNull(ASender.FieldByName(ExecutionContext.KeyField).Value) then
  raise Exception.Create(E_KEYFIELD_UPDATE_ON_NULL);

 UpdateItem.KeyFieldValue:=ASender.FieldByName(ExecutionContext.KeyField).Value;
 UpdateItem.LoadFromDataSet(ASender);
end;


procedure TMiceAppServerClient.LoadFromCache(DataSet:TFDMemTable);
var
 Hash:string;
begin
 Hash:=ExecutionContext.CalculateHash;
 if not TMiceDataCache.TryLoadFromCache(Hash,DataSet) then
  CheckCacheAgain(Hash,DataSet)
   else
  ExecutionContext.Status:=Integer(TCommandStatus.etLoadedFromLocalCache);
end;

procedure TMiceAppServerClient.PrepareForUpdates(DataSet:TFDMemTable);
begin
 CheckKeyField;
 FUpdateError:='';
 if not Assigned(FApplyUpdatesRequest) then
  FApplyUpdatesRequest:=TMiceApplyUpdatesRequest.Create;

  FApplyUpdatesRequest.ApplyContext.Clear;
  FApplyUpdatesRequest.ExecutionContext:=ExecutionContext;
end;



procedure TMiceAppServerClient.RefreshToken;
var
 FClient: TMiceHttpClient;
 jValue:TJsonValue;
 Request:string;
begin
  FClient:=TMiceHttpClient.Create(nil);
   try
    Request:=TMiceUser.CurrentUser.Token.ToJsonString;
    jValue:= FClient.CreateResponseObject(ApplicationSettings.FullPathRefreshToken,Request);
     try
       TMiceUser.CurrentUser.Token.FromJson(jValue);
     finally
      jValue.Free;
    end;
  finally
    FClient.Free;
  end;
end;

procedure TMiceAppServerClient.UpdateRecordEvent(ASender: TDataSet;  ARequest: TFDUpdateRequest; var AAction: TFDErrorAction;  AOptions: TFDUpdateRowOptions);
resourcestring
 S_UNKNOW_UPDATE_TYPE = 'Unknown update type in DataSet';
begin
  try
   if (ARequest in [arInsert, arUpdate, arDelete]) then
    InteralUpdateRecordEvent(ASender,ARequest)
     else
    raise Exception.Create(S_UNKNOW_UPDATE_TYPE);

   except on E:Exception do
     begin
      FUpdateError:=E.Message;
      raise;
     end;
  end;
 end;


initialization
 FSection:=TCriticalSection.Create;
finalization
 FSection.Free;

end.
