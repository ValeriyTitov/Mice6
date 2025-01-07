unit DAC.ObjectModels.DataSetMessage;

interface
uses
 System.SysUtils, System.Variants, System.Classes, Data.DB,
 System.Generics.Defaults, System.Generics.Collections,
 System.Json;

type
 TMiceDataSetMessage = class
  private
    FCode: Integer;
    FLineNumber: Integer;
    FAMessage: string;
  public
    function Clone:TMiceDataSetMessage;
    property AMessage:string read FAMessage write FAMessage;
    property LineNumber:Integer read FLineNumber write FLineNumber;
    property Code:Integer read FCode write FCode;
    procedure FromJsonObject(jObject:TJsonObject);
    procedure ToJsonObject(jObject:TJsonObject);
    constructor Create(jOwner:TJsonObject); overload;
    constructor Create; overload;
  end;

  TMiceDataSetMessageList = class(TObjectList<TMiceDataSetMessage>)
  public
    constructor Create;
    procedure FromJson(jArray:TJsonArray);
    procedure ToList(List:TStrings);
    function Clone: TMiceDataSetMessageList;
  end;


implementation

function TMiceDataSetMessage.Clone: TMiceDataSetMessage;
begin
 Result:=TMiceDataSetMessage.Create;
 Result.Code:=Self.Code;
 Result.LineNumber:=Self.LineNumber;
 Result.AMessage:=Self.AMessage;
end;

constructor TMiceDataSetMessage.Create(jOwner: TJsonObject);
begin
 FromJsonObject(jOwner);
end;

constructor TMiceDataSetMessage.Create;
begin

end;

procedure TMiceDataSetMessage.FromJsonObject(jObject: TJsonObject);
begin
 AMessage:=jObject.GetValue<string>('AMessage');
 LineNumber:=jObject.GetValue<Integer>('LineNumber');
 Code:=jObject.GetValue<Integer>('Code');
end;

procedure TMiceDataSetMessage.ToJsonObject(jObject: TJsonObject);
begin
 jObject.AddPair('AMessage',AMessage);
 jObject.AddPair('LineNumber',TJsonNumber.Create(LineNumber));
 jObject.AddPair('Code',TJsonNumber.Create(Code));
end;


{ TMiceDataSetMessageList }

function TMiceDataSetMessageList.Clone: TMiceDataSetMessageList;
var
 Msg: TMiceDataSetMessage;
begin
 Result:=TMiceDataSetMessageList.Create;
 for Msg in Self do
   Result.Add(Msg.Clone);
end;

constructor TMiceDataSetMessageList.Create;
begin
 inherited Create(True);
end;

procedure TMiceDataSetMessageList.FromJson(jArray: TJsonArray);
var
 x:Integer;
begin
 Self.Clear;
 for x:=0 to jArray.Count-1 do
   Add(TMiceDataSetMessage.Create(jArray.Items[x] as TJsonObject));
end;

procedure TMiceDataSetMessageList.ToList(List: TStrings);
var
 Msg:TMiceDataSetMessage;
begin
 for Msg in Self do
  List.Add(Msg.AMessage);
end;

end.
