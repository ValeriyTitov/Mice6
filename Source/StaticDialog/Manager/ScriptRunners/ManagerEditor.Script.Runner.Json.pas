unit ManagerEditor.Script.Runner.Json;

interface
uses
  System.Classes, System.SysUtils, Data.DB,  Rest.Json,  System.JSON,
  ManagerEditor.Script.Runner,
  Common.JsonUtils;



type
TJsonScriptRunner = class (TCustomScriptRunner)
 private
   FCount:Integer;
 protected
   procedure DoOnSuccess(DataSet:TDataSet); override;
   procedure DoOnError(const Msg:string); override;
 public
   procedure Run;override;
   function Format:string;override;
   constructor Create; override;
   destructor Destroy; override;
 end;

implementation

{ TJsonScriptRunner }

constructor TJsonScriptRunner.Create;
begin
  inherited;
  Syntax:='Json';
  DefaultExtension:='.json'
end;

destructor TJsonScriptRunner.Destroy;
begin

  inherited;
end;

procedure TJsonScriptRunner.DoOnError(const Msg: string);
begin
  InfoLines.Add(Msg);
  inherited;
end;

procedure TJsonScriptRunner.DoOnSuccess(DataSet: TDataSet);
begin
  InfoLines.Add('Json: OK');
  if FCount>0 then
  InfoLines.Add(string.Format('Count: %d',[FCount]));
  inherited;
end;

function TJsonScriptRunner.Format:string;
begin
 try
  Self.InfoLines.Clear;
  Result:=TJsonUtils.Format(Text.Text);
  DoOnSuccess(nil);
 except on E:Exception do
  begin
   Result:=Text.Text;
   DoOnError(E_UNABLE_PARSE_JSON_TEXT);
  end;
 end;
end;

procedure TJsonScriptRunner.Run;
var
 jObj:TJsonValue;
begin
 inherited;
  try
   Fcount:=0;
   jObj:=TJsonUtils.TryCreateJson(Text.Text);
   if Assigned(jObj) and (jObj is TJsonObject) then
    begin
     FCount:=(jObj as TJsonObject).Count;
     jObj.Value;
     DoOnSuccess(nil);
     jObj.Free;
    end
  except on E:Exception do
   DoOnError(E_UNABLE_PARSE_JSON_TEXT);
  end;
end;

end.
