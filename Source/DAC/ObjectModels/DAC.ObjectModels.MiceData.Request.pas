unit DAC.ObjectModels.MiceData.Request;

interface

uses
 System.SysUtils, System.Variants, System.Classes, System.Json,
 Common.JsonUtils,
 DAC.ObjectModels.ExecutionContext;

type
  TMiceDataRequest = class
   strict private
    FExecutionContext: TMiceExecutionContext;
    FIsExecute: Boolean;
   public
    property IsExecute:Boolean read FIsExecute write FIsExecute;
    property ExecutionContext:TMiceExecutionContext read FExecutionContext write FExecutionContext;
    function ToJsonString:string;
    procedure ToJson(jObject:TJsonObject);
   end;

implementation



function TMiceDataRequest.ToJsonString: string;
var
 jObject:TJsonObject;
begin
 jObject:=TJsonObject.Create;
 try
  Self.ToJson(jObject);
  Result:=jObject.Format;
 finally
  jObject.Free;
 end;
end;



procedure TMiceDataRequest.ToJson(jObject: TJsonObject);
begin
  if Assigned(ExecutionContext) then
   ExecutionContext.ToNewJsonObject(jObject);
  jObject.AddPair('IsExecute', TJsonBool.Create(IsExecute));
end;

end.
