unit DAC.ObjectModels.ApplyUpdates.Request;

interface

uses
 System.SysUtils, System.Variants, System.Classes, Data.DB,
 System.Generics.Defaults, System.Generics.Collections,
 FireDAC.Comp.Client, Rest.Json, System.Json,
 Common.JsonUtils,
 DAC.ObjectModels.ExecutionContext,
 DAC.ObjectModels.ApplyContent;

type
  TMiceApplyUpdatesRequest = class
   private
     FExecutionContext: TMiceExecutionContext;
     FApplyContext: TMiceApllyContent;
     FKeyField: string;
    public
     property KeyField:string read FKeyField write FKeyField;
     property ExecutionContext:TMiceExecutionContext read FExecutionContext write FExecutionContext;
     property ApplyContext:TMiceApllyContent read FApplyContext write FApplyContext;
     procedure ToJsonObject(jOwner:TJsonObject);
     function ToJsonString:string;
     constructor Create;
     destructor Destroy; override;
   end;

implementation



{ TMiceApplyUpdatesRequest }

constructor TMiceApplyUpdatesRequest.Create;
begin
 FApplyContext:=TMiceApllyContent.Create;
end;

destructor TMiceApplyUpdatesRequest.Destroy;
begin
  FApplyContext.Free;
  inherited;
end;


procedure TMiceApplyUpdatesRequest.ToJsonObject(jOwner: TJsonObject);
begin
// jOwner.AddPair('Token',Token);

 if Assigned(ExecutionContext) then
  ExecutionContext.ToNewJsonObject(jOwner);

 if Assigned(ApplyContext) then
  ApplyContext.ToNewJsonObject(jOwner);
end;

function TMiceApplyUpdatesRequest.ToJsonString: string;
var
 jObject:TJsonObject;
begin
  jObject:=TJsonObject.Create;
  try
    ToJsonObject(jObject);
    Result:=TJsonUtils.Format(jObject);
  finally
   jObject.Free;
  end;
end;

end.
