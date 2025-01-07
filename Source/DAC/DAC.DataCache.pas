unit DAC.DataCache;

interface
 uses
  System.Classes, System.SysUtils, FireDac.Comp.Client, System.SyncObjs, Windows,
  System.Generics.Collections, System.Generics.Defaults,
  FireDAC.Stan.StorageBin;




 type
  TMiceDataCache = class
  private
   class procedure InternalLoadItem(SourceStream:TMemoryStream; DataSet:TFDMemTable);
  public
   class procedure RemoveItem(const Hash:string);
   class procedure PutToCache(const Hash, Region:string; Duration:Integer; DataSet:TFDMemTable);
   class procedure ClearEntireCache;
   class procedure ClearRegion(const Region:string);
   class procedure EnterSection;
   class procedure LeaveSection;
   class function  TryLoadFromCache(const Hash:string; DataSet:TFDMemTable):Boolean;
   class function  LocalCacheRequired(const ProviderName:string):Boolean;

  end;

implementation

type
 TCacheItem = class
   private
    FTimeAdded: Int64;
    FStream: TMemoryStream;
    FDuration: Integer;
    FExecutionContextJson: string;
    FHash: string;
   public
    property Stream:TMemoryStream read FStream;
    property TimeAdded:Int64 read FTimeAdded;
    property Duration:Integer read FDuration write FDuration;
    property ExecutionContextJson: string read FExecutionContextJson write FExecutionContextJson;
    property Hash:string read FHash write FHash;
    function Expired:Boolean;
    constructor Create;
    destructor Destroy; override;
  end;

 TMemoryReaderStream = class(TCustomMemoryStream)
  public
   procedure SetMemoryPointer(Stream:TMemoryStream);
   function Write(const Buffer; Count: Longint): Longint; override;
  end;

var
 FSection:TCriticalSection;
 FCachableProceduresList:TList<string>;
 FCacheStorage:TObjectDictionary<string, TCacheItem>;
 FRegionStorage:TObjectDictionary<string, TList<TCacheItem>>;


procedure PutToRegion(const Region:string; Item:TCacheItem);
var
 List:TList<TCacheItem>;
begin
 if not FRegionStorage.ContainsKey(Region) then
  begin
   List:=TList<TCacheItem>.Create;
   FRegionStorage.Add(Region,List);
  end
   else
    List:=FRegionStorage[Region];

  if not List.Contains(Item) then
   List.Add(Item)
end;


{ TMemoryReaderStream }

procedure TMemoryReaderStream.SetMemoryPointer(Stream: TMemoryStream);
begin
 SetPointer(Stream.Memory, Stream.Size);
end;

function TMemoryReaderStream.Write(const Buffer; Count: Integer): Longint;
begin
 raise Exception.CreateFmt('Not implemented in %s',[ClassName]);
end;

{ TMiceDataCache }

class procedure TMiceDataCache.ClearEntireCache;
begin
 EnterSection;
 try
  FCacheStorage.Clear;
 finally
  LeaveSection;
 end;
end;

class procedure TMiceDataCache.ClearRegion(const Region: string);
begin
 raise Exception.Create('ClearRegion not implemented');
end;

class procedure TMiceDataCache.EnterSection;
begin
 FSection.Enter;
end;

class procedure TMiceDataCache.InternalLoadItem(SourceStream: TMemoryStream;  DataSet: TFDMemTable);
var
 Stream:TMemoryReaderStream;
begin
 Stream:=TMemoryReaderStream.Create;
  try
   Stream.SetMemoryPointer(SourceStream);
   Stream.Seek(0,0);
   DataSet.LoadFromStream(Stream);
  finally
   Stream.Free;
  end;
end;

class procedure TMiceDataCache.LeaveSection;
begin
 FSection.Leave;
end;

class function TMiceDataCache.LocalCacheRequired(const ProviderName: string): Boolean;
begin
 Result:=FCachableProceduresList.IndexOf(ProviderName)>=0;
end;

class procedure TMiceDataCache.RemoveItem(const Hash: string);
begin
  try
    EnterSection;
    FCacheStorage.Remove(Hash);
  finally
    LeaveSection;
  end;
end;

class procedure TMiceDataCache.PutToCache(const Hash, Region: string; Duration:Integer; DataSet: TFDMemTable);
var
 Item:TCacheItem;
begin
 if not FCacheStorage.ContainsKey(Hash) then
  begin
   Item:=TCacheItem.Create;
   Item.Duration:=Duration;
   Item.Hash:=Hash;
   DataSet.SaveToStream(Item.Stream);
   FCacheStorage.Add(Hash,Item);
   PutToRegion(Region, Item);
  end;
end;


class function TMiceDataCache.TryLoadFromCache(const Hash: string;  DataSet: TFDMemTable): Boolean;
var
 Item:TCacheItem;
begin
 Result:=FCacheStorage.ContainsKey(Hash);
  if Result then
   begin
    Item:=FCacheStorage[Hash];
     Result:= not Item.Expired;
      if Result then
       InternalLoadItem(Item.Stream, DataSet)
        else
       FCacheStorage.Remove(Hash);
   end;
end;



{ TCachedObject }

constructor TCacheItem.Create;
begin
  FStream:=TMemoryStream.Create;
  FTimeAdded:=GetTickCount;
  Duration:=0;
end;

destructor TCacheItem.Destroy;
begin
  FStream.Free;
  inherited;
end;


function TCacheItem.Expired: Boolean;
begin
 Result:=(Duration>0) and (GetTickCount > TimeAdded+Duration);
end;



initialization
  FSection:=TCriticalSection.Create;

  FCacheStorage:=TObjectDictionary<string, TCacheItem>.Create([doOwnsValues],TIStringComparer.Ordinal);;
  FRegionStorage:=TObjectDictionary<string, TList<TCacheItem>>.Create([doOwnsValues],TIStringComparer.Ordinal);
  FCachableProceduresList:=TList<string>.Create(TIStringComparer.Ordinal);
//  FCachableProceduresList.Add('spww_GetEmployeeDetails');
//  FCachableProceduresList.Add('spww_EmployeeList');
  FCachableProceduresList.Add('spsys_GetProcedureParams');
finalization
  FCachableProceduresList.Free;
  FRegionStorage.Free;
  FCacheStorage.Free;
  FSection.Free;
end.
