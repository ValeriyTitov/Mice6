unit DAC.History;

interface

uses System.Classes, System.Generics.Collections, WinAPI.Windows, SyncObjs, System.SysUtils,
     DAC.ObjectModels.DataSetMessage;

type
 TCommandStatus = (etUnknown, etError, etJustCreated, etRunning, etDirectQuery, etJustLocallyCached, etLoadedFromLocalCache, etJustAppServerCached,  etAppServerCache, etDataScript, etCanceling, etCanceled, etDataSetMessage);

 TSQLHistoryEntry = class
  strict private
    FCommand: string;
    FStatus: TCommandStatus;
    FDBName: string;
    FCacheDuration: integer;
    FTimeToComplete: int64;
    FRecordCount: integer;
    FTimeAdded: Int64;
    FSource: string;
    FInfo: string;
    FDateTimeAdded: TDateTime;
    FMessages: TMiceDataSetMessageList;
  public
    property Source:string read FSource write FSource;
    property Command:string read FCommand write FCommand;
    property Status:TCommandStatus read FStatus write FStatus;
    property CacheDuration:integer read FCacheDuration write FCacheDuration;
    property DBName:string read FDBName write FDBName;
    property RecordCount:integer read FRecordCount write FRecordCount;
    property TimeAdded:Int64 read FTimeAdded write FTimeAdded;
    property TimeToComplete:Int64 read FTimeToComplete write FTimeToComplete;
    property Info:string read FInfo write FInfo;
    property DateTimeAdded:TDateTime read FDateTimeAdded write FDateTimeAdded;

    property Messages:TMiceDataSetMessageList read FMessages write FMessages;

    function ToString:string; override;
    destructor Destroy; override;
 end;

 TSQLExecutionHistory = class
  public
    class procedure EnterSection;
    class procedure LeaveSection;
    class function CreateEntry(const Command, DBName, Source:string):integer;
    class procedure UpdateEntry(const Index: integer; const Command, Info:string; const CacheDuration, RecordCount:Integer; const Status:TCommandStatus; Messages:TMiceDataSetMessageList);
    class procedure UpdateEntryError(const Index: integer; const Command, ErrorMessage: string; Messages:TMiceDataSetMessageList);
    class procedure Clear;
    class function HistoryList:TObjectList<TSQLHistoryEntry>;
 end;

resourcestring
  S_METADATA_QUERY = 'Meta query';
  S_etUnknown = 'Unknown';
  S_etError ='ERROR';
  S_etJustCreated='Just created';
  S_etRunning='Running';
  S_etJustLocallyCached='Just locally cached';
  S_etLoadedFromLocalCache='Local cache';
  S_etDirectQuery ='Direct query';
  S_etJustAppServerCached ='Just cached (server)';
  S_etAppServerCache ='Server cache';
  S_etDataScript ='DataScript';
  S_etCanceling ='Canceling';
  S_etCanceled ='Canceled';
  S_etDataSetMessage ='Dataset Message';

implementation

var
 FList:TObjectList<TSQLHistoryEntry>;
 FSection:TCriticalSection;

const
 MAX_HISTORY_COUNT = 256;


class procedure TSQLExecutionHistory.Clear;
begin
FSection.Enter;
 try
  FList.Clear;
 finally
  FSection.Leave;
 end;
end;

class function TSQLExecutionHistory.CreateEntry(const Command,  DBName, Source: string): integer;
var
 Entry:TSQLHistoryEntry;
begin
 if FList.Count>=MAX_HISTORY_COUNT then
  Clear;
 EnterSection;
 try
   Entry:=TSQLHistoryEntry.Create;
   Entry.Command:=Command;
   Entry.Source:=Source;
   Entry.DBName:=DBName;
   Entry.Status:=etRunning;
   Entry.TimeAdded:=GetTickCount;
   Entry.DateTimeAdded:=Now;
   Result:=FList.Add(Entry);
 finally
   LeaveSection;
 end;
end;


class procedure TSQLExecutionHistory.EnterSection;
begin
 FSection.Enter;
end;

class function TSQLExecutionHistory.HistoryList: TObjectList<TSQLHistoryEntry>;
begin
 Result:=FList;
end;

class procedure TSQLExecutionHistory.LeaveSection;
begin
 FSection.Leave;
end;

class procedure TSQLExecutionHistory.UpdateEntry(const Index: integer;  const Command, Info: string; const CacheDuration,  RecordCount: Integer; const Status :TCommandStatus; Messages:TMiceDataSetMessageList);
var
 Entry:TSQLHistoryEntry;
begin
 FSection.Enter;
 try
  if (Index>=0) and (Index<=FList.Count) then
   begin
    Entry:=FList[Index];
    Entry.Command:=Command;
    Entry.Status:=Status;
    Entry.TimeToComplete:=GetTickCount-Entry.TimeAdded;
    Entry.CacheDuration:=CacheDuration;
    Entry.RecordCount:=RecordCount;
    Entry.Info:=Info;
    if (Messages.Count>0) and not Assigned(Entry.Messages) then
     Entry.Messages:=Messages.Clone;
   end;
 finally
  FSection.Leave;
 end;

end;


class procedure TSQLExecutionHistory.UpdateEntryError(const Index: integer;  const Command, ErrorMessage: string; Messages:TMiceDataSetMessageList);
var
 Entry:TSQLHistoryEntry;
begin
 FSection.Enter;
 try
  if (Index>=0) and (Index<=FList.Count) then
   begin
    Entry:=FList[Index];
    Entry.Status:=etError;
    Entry.Command:=Command;
    Entry.TimeToComplete:=GetTickCount-Entry.TimeAdded;
    Entry.Info:=ErrorMessage;
    if (Messages.Count>0) and not Assigned(Entry.Messages) then
     Entry.Messages:=Messages.Clone;
   end;
 finally
  FSection.Leave;
 end;

end;


{ TSQLHistoryEntry }

destructor TSQLHistoryEntry.Destroy;
begin
 if Assigned(Messages) then
  FreeAndNil(Messages);
  inherited;
end;

function TSQLHistoryEntry.ToString: string;
begin
 case Status of
  etUnknown:Result:=S_etUnknown;
  etError:Result:=S_etError;
  etJustCreated:Result:=S_etJustCreated;
  etRunning:Result:=S_etRunning;
  etJustLocallyCached:Result:=S_etJustLocallyCached;
  etLoadedFromLocalCache: Result:=S_etLoadedFromLocalCache;
  etDirectQuery:Result:=S_etDirectQuery;
  etJustAppServerCached: Result:=S_etJustAppServerCached;
  etAppServerCache : Result:=S_etAppServerCache;
  etDataScript : Result:=S_etDataScript;
  etCanceling : Result:=S_etCanceling;
  etCanceled: Result:=S_etCanceled;
  etDataSetMessage: Result:=S_etDataSetMessage;
   else
    Result:=S_etUnknown;
 end;
end;

initialization
 FList:=TObjectList<TSQLHistoryEntry>.Create;
 FSection:=TCriticalSection.Create;

finalization
 FList.Free;
 FSection.Free;

end.
