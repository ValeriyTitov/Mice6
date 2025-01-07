unit Dialog.Layout.JsonStorage.Buffer;

interface
uses  System.SysUtils, System.Classes, System.Variants,
      System.Generics.Collections, System.Generics.Defaults,
      Data.DB;


type
  TDialogLayoutStorageBuffer = class (TDictionary<string,string>)
  public
   constructor Create;
   class function DefaultInstance:TDialogLayoutStorageBuffer;
   class function NewKey:string;
  end;

implementation
var
 ADefaultInstance:TDialogLayoutStorageBuffer;

{ TDialogLayoutStorageBuffer }

constructor TDialogLayoutStorageBuffer.Create;
begin
 inherited Create(TIStringComparer.Ordinal);
end;

class function TDialogLayoutStorageBuffer.DefaultInstance: TDialogLayoutStorageBuffer;
begin
 Result:=ADefaultInstance;
end;

class function TDialogLayoutStorageBuffer.NewKey: string;
var
 AGuid:TGuid;
begin
 CreateGUID(AGuid);
 Result:=GUIDToString(AGuid);
end;

initialization
  ADefaultInstance:= TDialogLayoutStorageBuffer.Create;

finalization
  ADefaultInstance.Free;

end.
