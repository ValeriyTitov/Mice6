unit DAC.ObjectModels.ExecutionContext;

interface
uses
 System.SysUtils, System.Variants, System.Classes, Data.DB,
 System.Generics.Defaults, System.Generics.Collections,
 DAC.XParams,
 DAC.ObjectModels.DataSetMessage,
 FireDAC.Comp.Client,
 DAC.XDataSetHelper,
 System.Json;

type
 TMiceExecutionContext = class
  private
    FProviderName: string;
    FStatus: Integer;
    FDBName: string;
    FCacheDuraion: Integer;
    FParams: TxParams;
    FApplicationContext: TDictionary<string, string>;
    FKeyField: string;
    FMessages: TMiceDataSetMessageList;
    function GetCommandName: string;
  public
    property ProviderName:string read FProviderName write FProviderName;
    property CommandName:string read GetCommandName;
    property DBName:string read FDBName write FDBName;
    property CacheDuraion:Integer read FCacheDuraion write FCacheDuraion;
    property Status:Integer read FStatus write FStatus;
    property Params:TxParams read FParams;
    property ApplicationContext: TDictionary<string, string> read FApplicationContext;
    property Messages: TMiceDataSetMessageList read FMessages;
    property KeyField:string read FKeyField write FKeyField;

    procedure FromJsonObject(jObject:TJsonObject);
    procedure ToJsonObject(jObject:TJsonObject);
    procedure ToNewJsonObject(jOwner:TJsonObject);
    procedure CheckProviderNameEmpty;

    function ToJsonString:string;
    function CalculateHash:string;
    constructor Create;
    destructor Destroy; override;
  end;

  TMiceExtendedContext = class(TMiceExecutionContext) //Для истории SQL

  end;

implementation



function TMiceExecutionContext.CalculateHash: string;
begin
 if TxDataSetHelper.ProviderIsStoredProc(Self.ProviderName) then
  Result:=Trim(ProviderName+' '+Params.ToString)
   else
  Result:=ProviderName;
end;

procedure TMiceExecutionContext.CheckProviderNameEmpty;
resourcestring
 E_NO_PROVIDER_SPECIFIED = 'Unable to execute: ProviderName is empty';
begin
 if ProviderName.Trim.IsEmpty then
  raise Exception.Create(E_NO_PROVIDER_SPECIFIED);
end;

constructor TMiceExecutionContext.Create;
begin
 FParams:=TxParams.Create;
 FApplicationContext:=TDictionary<string, string>.Create(TIStringComparer.Ordinal);
 FMessages:=TMiceDataSetMessageList.Create;
end;

destructor TMiceExecutionContext.Destroy;
begin
 FParams.Free;
 FApplicationContext.Free;
 FMessages.Free;
 inherited;
end;

procedure TMiceExecutionContext.FromJsonObject(jObject: TJsonObject);
var
 //jParams:TJsonValue;
 jMessages:TJsonValue;
begin
 ProviderName:=jObject.GetValue<string>('ProviderName');
 DBName:=jObject.GetValue<string>('DBName');
 Status:=jObject.GetValue<Integer>('Status');

// if jObject.TryGetValue('Params',jParams) then;
// if jObject.TryGetValue('ApplicationContext',jContext) then;

 if jObject.TryGetValue('Messages',jMessages) and (jMessages is TJsonArray) then
  Messages.FromJson(jMessages as TJsonArray);
end;


function TMiceExecutionContext.GetCommandName: string;
begin
 Result:=TxDataSetHelper.FindProviderCommandName(ProviderName);
end;

procedure TMiceExecutionContext.ToJsonObject(jObject: TJsonObject);
var
 jParams:TJsonObject;
 jContext:TJsonObject;
 s:string;
begin
  if not ProviderName.Trim.IsEmpty then
   jObject.AddPair('ProviderName',ProviderName);

  if not DBName.Trim.IsEmpty then
   jObject.AddPair('DBName', DBName);

  if not KeyField.Trim.IsEmpty then
   jObject.AddPair('KeyField',KeyField);

  if Params.Count>0  then
   begin
    jParams:=TJsonObject.Create;
    jObject.AddPair('Params',jParams);
    Params.ToJsonObject(jParams);
   end;

  if FApplicationContext.Count>0 then
   begin
    jContext:=TJsonObject.Create;
     for s in FApplicationContext.Keys do
       jContext.AddPair(s,FApplicationContext[s]);
    jObject.AddPair('ApplicationContext',jContext);
   end;

end;

function TMiceExecutionContext.ToJsonString: string;
var
 jObject:TJsonObject;
begin
  jObject:=TJsonObject.Create;
  try
   ToJsonObject(jObject);
   Result:=jObject.Format;
  finally
   jObject.Free;
  end;
end;

procedure TMiceExecutionContext.ToNewJsonObject(jOwner: TJsonObject);
var
 jExecution:TJsonObject;
begin
  jExecution:=TJsonObject.Create;
  ToJsonObject(jExecution);
  jOwner.AddPair('ExecutionContext',jExecution);
end;

end.
