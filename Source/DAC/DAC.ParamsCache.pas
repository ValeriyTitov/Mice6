unit DAC.ParamsCache;

interface
 uses
  System.Classes, System.SysUtils, System.Generics.Collections, Data.DB, System.SyncObjs;

 type
  TMiceParamsCache = class
  public
   class procedure Clear;
   class procedure SaveToCache(const Hash:string; Params:TParams);
   class function LoadFromCache(const Hash:string; Params:TParams):Boolean;
  end;


implementation

var
 FDict:TObjectDictionary<string,TParams>;
 FSection:TCriticalSection;


{ TMiceParamsCache }

class procedure TMiceParamsCache.Clear;
begin
 FSection.Enter;
 FDict.Clear;
 FSection.Leave;
end;

class function TMiceParamsCache.LoadFromCache(const Hash: string;  Params: TParams): Boolean;
begin
 Result:=FDict.ContainsKey(Hash);
 if Result then
  Params.Assign(FDict[Hash]);
end;

class procedure TMiceParamsCache.SaveToCache(const Hash: string; Params: TParams);
var
 NewParams:TParams;
begin
 if FDict.ContainsKey(Hash)=False then
  begin
   FSection.Enter;
    if FDict.ContainsKey(Hash)=False then
     begin
      NewParams:=TParams.Create;
      NewParams.Assign(Params);
      FDict.Add(Hash, NewParams);
     end;
   FSection.Leave;
  end;
end;


initialization
  FDict:=TObjectDictionary<string,TParams>.Create;
  FSection:=TCriticalSection.Create;
finalization
  FSection.Free;
  FDict.Free;
end.
