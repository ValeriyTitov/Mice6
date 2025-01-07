unit Common.VariantUtils;

interface

uses System.Variants, System.SysUtils,
     Common.StringUtils;

type
 TVariantUtils = class
   class function VarHasValue(const Value:Variant):Boolean;
   class function VarToIntDef(const Value:Variant;Default:Integer):Integer;
   class function VarToIntDefNonZero(const Value:Variant;Default:Integer):Integer;
   class function VarToSQLStr(const Value:Variant; AFormatSettings:TFormatSettings):string;
   class function VarIsBoolean(const Value:Variant):Boolean;
   class function VarIsNullStr(const Value:Variant):Boolean;
   class function StrToVariant(const Value:Variant):Variant;
 end;

const
 NullStrValue = 'null';

implementation



{ TVariantUtils }

class function TVariantUtils.StrToVariant(const Value: Variant): Variant;
begin
 if VarIsNullStr(Value) then
  Result:=NULL
   else
  Result:=Value;
end;

class function TVariantUtils.VarHasValue(const Value: Variant): Boolean;
begin
 Result:=not VarIsNull(Value) or (Trim(VarToStr(Value))<>'');
end;


class function TVariantUtils.VarIsBoolean(const Value: Variant): Boolean;
begin
 Result := varIsType(Value, varBoolean);
end;

class function TVariantUtils.VarIsNullStr(const Value: Variant): Boolean;
var
 s:string;
begin
 Result:=VarIsNull(Value) or VarIsEmpty(Value);
 if not Result then
  begin
   s:=VarToStr(Value);
   Result:=(s.IsEmpty) or (TStringUtils.SameString(s,NullStrValue));
  end;
end;

class function TVariantUtils.VarToIntDef(const Value: Variant; Default: Integer): Integer;
begin
 if VarIsOrdinal(Value) and not VarIsNull(Value)then
  Result:=Value
   else
  Result:=Default;
end;

class function TVariantUtils.VarToIntDefNonZero(const Value: Variant;  Default: Integer): Integer;
begin
 Result:=Self.VarToIntDef(Value,Default);
 if Result=0 then
  Result:=Default;
end;

class function TVariantUtils.VarToSQLStr(const Value: Variant; AFormatSettings:TFormatSettings): string;
begin
if (VarIsNull(Value)) or VarIsEmpty(Value) then
 Result:='NULL'
 else
  case VarType(Value) of
      varBoolean:  Result:=VarToStr(Value);
      varDate:     Result:=FormatDateTime('yyyy"/"mm"/"dd"', Value, AFormatSettings);
      varOleStr,varString,varUString:Result:=QuotedStr(VarToStr(Value));
      else
       Result:=VarToStr(Value);
  end;
end;

end.
