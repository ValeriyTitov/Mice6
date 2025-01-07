unit Common.VariantComparator;

interface
{
 TVariantComparator.DefaultRoleComparator устанавливается в другом модуле.
}


uses
   System.SysUtils, System.Variants, System.Classes,
   Common.StringUtils,
   Common.VariantUtils;

type
  TVariantEquation = (veUnknown, veEqual, veNotEqual, veGreaterThan, veGreaterOrEqual, veLessThan, veLessOrEqual, veIsNull, veNotIsNull, veIn, veNotIn, veUserIsInRole);
  TVariantLogicEquation = (vleAnd, vleOr, vleNot, vleXor, vleAndNot, vleOrNot);


  IRoleComparator = interface
   ['{D2D5C491-7164-4BAF-B0A4-1AB037E0F9F1}']
   function UserIsInRole(const Role:string):Boolean;
  end;

  TVariantComparator = class
  strict private
    class var FDefaultRoleComparator: IRoleComparator;
    class procedure SetDefaultRoleComparator(const Value: IRoleComparator); static;
    class function CompareUserIsInRole(const Role:Variant):Boolean;
  public
    class function FindEquationInString(const S: string;  var FieldName: string; var Equation: TVariantEquation; var Value: string):Boolean; static;
    class function VarInCase(const AValue1:Variant; const CaseStr:string):Boolean;
    class function CompareVariant(const AValue1, AValue2:Variant; AEquation:TVariantEquation):Boolean;
    class function TryCompareVariant(const AValue1, AValue2:Variant; AEquation:TVariantEquation):Boolean;
    class function EquationToString(const Eq:TVariantEquation):string;
    class function LogicEquationToString(const AEquation:TVariantLogicEquation):string;
    class property DefaultRoleComparator:IRoleComparator read FDefaultRoleComparator write SetDefaultRoleComparator;
 end;

implementation

class function TVariantComparator.EquationToString(const Eq: TVariantEquation): string;
begin
 case eq of
  veEqual:Result:='=';
  veNotEqual:Result:='<>';
  veGreaterThan:Result:='>';
  veGreaterOrEqual:Result:='>=';
  veLessThan:Result:='<';
  veLessOrEqual:Result:='<=';
  veIsNull:Result:='is null';
  veNotIsNull:Result:='is not null';
  veIn: Result:='in ';
  veNotIn: Result:='not in ';
   else
  Result:='unknown';
 end;
end;


class function TVariantComparator.FindEquationInString(const S: string; var FieldName:string; var Equation:TVariantEquation; var Value:string):Boolean;
var
 AIndex:Integer;
 L:string;
//Клянусь - это единственный раз, когда я использовал вложенные процедуры!
procedure UpdateVars(Offset:Integer; AResult:TVariantEquation);
begin
  FieldName:=Trim(s.Substring(0,AIndex-1));
  Equation:=AResult;
  case Equation of
    veUnknown: ;
    veIsNull: ;
    veNotIsNull: ;
    veIn: Value:=TStringUtils.RemoveBrackets(S.Substring(AIndex+Offset-1),'(',')');
    veNotIn: Value:=TStringUtils.RemoveBrackets(S.Substring(AIndex+Offset-1),'(',')');
     else
    Value:=Trim(S.Substring(AIndex+Offset-1));
  end;
end;

function FindItems(const Sign:string; Eq:TVariantEquation):boolean;
begin
 AIndex:=Pos(Sign,L);
 Result:=AIndex>0;
 if Result then
  UpdateVars(Length(Sign),Eq)
end;

begin
 L:=AnsiLowerCase(s);

 Result:= (
          FindItems('<>',veNotEqual) or
          FindItems('>=',veGreaterOrEqual) or
          FindItems('<=',veLessOrEqual) or
          FindItems('=',veEqual) or
          FindItems('>',veGreaterThan) or
          FindItems('<',veLessThan) or
          FindItems(' is not null',veNotIsNull) or
          FindItems(' is null',veIsNull) or
          FindItems(' not in ',veNotIn) or
          FindItems(' in ',veIn)
          )
end;

class function TVariantComparator.LogicEquationToString(const AEquation: TVariantLogicEquation): String;
begin
 case AEquation of
  vleAnd:    Result:='and';
  vleOr:     Result:='or';
  vleXor:    Result:='xor';
  vleNot:    Result:='not';
  vleAndNot: Result:='and not';
  vleOrNot:  Result:='or not'
   else
    Result:='Unknown';
 end;

end;


class procedure TVariantComparator.SetDefaultRoleComparator(const Value: IRoleComparator);
begin
  FDefaultRoleComparator := Value;
end;

class function TVariantComparator.TryCompareVariant(const AValue1,  AValue2: Variant; AEquation: TVariantEquation): Boolean;
begin
 try
  Result:=CompareVariant(AValue1,AValue2, AEquation);
 except
  Result:=False;
 end;
end;

class function TVariantComparator.CompareUserIsInRole(const Role: Variant): Boolean;
begin
 Result:=Assigned(FDefaultRoleComparator) and FDefaultRoleComparator.UserIsInRole(VarToStr(Role));
end;

class function TVariantComparator.CompareVariant(const AValue1, AValue2:Variant; AEquation: TVariantEquation): Boolean;
begin
 case AEquation of
  veEqual:Result:=VarCompareValue(AValue1,AValue2)=vrEqual;
  veNotEqual:Result:=not (VarCompareValue(AValue1,AValue2)=vrEqual);
  veGreaterThan:Result:=VarCompareValue(AValue1,AValue2) = vrLessThan;
  veGreaterOrEqual:Result:=(VarCompareValue(AValue1,AValue2)=vrLessThan) or (VarCompareValue(AValue1,AValue2)=vrEqual);
  veLessThan:Result:=VarCompareValue(AValue1,AValue2) = vrGreaterThan;
  veLessOrEqual:Result:=(VarCompareValue(AValue1,AValue2)=vrGreaterThan) or (VarCompareValue(AValue1,AValue2)=vrEqual);
  veIsNull:Result:=TVariantUtils.VarIsNullStr(AValue2);
  veNotIsNull:Result:=not (TVariantUtils.VarIsNullStr(AValue2));
  veIN : Result:= VarInCase(AValue2,AValue1);
  veNotIn: Result:= not VarInCase(AValue2, AValue1);
  veUserIsInRole: Result:=CompareUserIsInRole(AValue1);
   else
  Result:=False;
 end;
end;

class function TVariantComparator.VarInCase(const AValue1: Variant; const CaseStr: string): Boolean;
var
 List:TStringList;
 x:Integer;
begin
Result:=False;
List:=TStringList.Create;
 try
  List.StrictDelimiter:=True;
  List.Delimiter:=',';
  if CaseStr.StartsWith('(') and CaseStr.EndsWith(')') then
   List.DelimitedText:=CaseStr.Substring(1,CaseStr.Length-2)
    else
   List.DelimitedText:=CaseStr;
   for x:=0 to List.Count-1 do
    begin
     Result:=TStringUtils.SameString(VarToStr(AValue1),Trim(List[x]))  or (TVariantUtils.VarIsNullStr(AValue1)) and TStringUtils.SameString(List[x],NullStrValue);
     If Result then
      Exit;
    end
 finally
  List.Free;
 end;
end;

end.
