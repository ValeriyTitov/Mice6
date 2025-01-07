unit Common.JsonUtils;

interface
 uses System.Classes, System.SysUtils, System.Json, Rest.Json,
       System.Variants,
       Common.VariantUtils;

 type
  TJsonUtils = class
    class function Format(const json: string): string; overload;
    class function Format(jObject: TJsonValue): string; overload;
    class function VariantToJson(const Value:Variant):TJsonValue;
    class function FindValueDef(AJson:TJsonObject; const Name:string; Default:Variant):Variant;
    class procedure RaiseParseError;
    class function TryCreateJson(const JsonText:string):TJSONValue;
  end;


resourcestring
 E_UNABLE_PARSE_JSON_TEXT  ='Unable to parse Json text';

implementation

{ TJsonUtils }

class function TJsonUtils.FindValueDef(AJson: TJsonObject; const Name: string;  Default: Variant): Variant;
var
 jValue:TJsonValue;
begin
if Assigned(AJson) then
 begin
  jValue:=AJson.Values[Name];
   if Assigned(jValue) then
    begin
     Result:=jValue.Value;
     if TVariantUtils.VarIsNullStr(Result) then
      Result:=NULL;
    end
   else
  Result:=Default;
 end
  else
   Result:=Default;

end;

class function TJsonUtils.Format(const Json: string): string;
var
 Tmp: TJsonValue;
begin
 Tmp:= TJSONObject.ParseJSONValue(Json);
 try
  Result:=Tmp.Format;
 finally
  Tmp.Free;
 end;
end;

class function TJsonUtils.Format(jObject: TJsonValue): string;
begin
 Result := jObject.Format;
end;


class procedure TJsonUtils.RaiseParseError;
begin
 raise Exception.Create(E_UNABLE_PARSE_JSON_TEXT);
end;

class function TJsonUtils.TryCreateJson(const JsonText: string): TJSONValue;
begin
try
  Result := TJSONObject.ParseJSONValue(JsonText);
  if not Assigned(Result) then
   raise Exception.Create(E_UNABLE_PARSE_JSON_TEXT);
 except
  raise Exception.Create(E_UNABLE_PARSE_JSON_TEXT);
 end;
end;

class function TJsonUtils.VariantToJson(const Value: Variant): TJsonValue;
begin
 if TVariantUtils.VarIsNullStr(Value) then
  Result:=TJsonNull.Create
   else
    begin
     if VarIsOrdinal(Value) then
      Result:=TJsonNumber.Create(VarToStr(Value))
       else
     if TVariantUtils.VarIsBoolean(Value) then
      Result:=TJsonBool.Create(Value)
       else

      Result:=TJsonString.Create(VarToStr(Value));
    end;
end;

end.
