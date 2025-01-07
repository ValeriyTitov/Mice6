unit Common.StringUtils;

interface

uses System.SysUtils, System.Classes, System.Generics.Collections;

type
 TStringUtils = class
   public
    class function SameString(const Str1, Str2:string):Boolean;
    class function SameTrimString(const Str1, Str2:string):Boolean;
    class function HashStringSpaces(const s:string):string;
    class function StringMaxLength(const s:string; const MaxLength:integer):string;
    class function RemoveBrackets(const s:string; StartBracket, EndBracket:string):string;
    class function RemoveDualSpaces(const s:string):string;
    class function ExtractQuotedText(const s:string; const QuoteChar1, QuoteChar2:string):string;
    class function FindMaxLength(List: TStrings): Integer;
    class function AppendWithSpaces(const s:string; const MaxLength:Integer):string;
    class function ReplaceCaseInsensitive(const s, OldPattern, NewPattern:string):string;
    class function NullIfEmpty(const s:string):string;
    class function LeftFromDot(const s, Default: string):string;
    class function RightFromDot(const s, Default: string):string;
    class function LeftFromText(const s, Pattern, Default: string):string;
    class function RightFromText(const s, Pattern, Default: string):string;
    class function DeQuoteDelphiString(const s:string):string;
    class function ListToString(List:TList<string>):string;
    class function ListToStringLine(List:TList<Integer>; const Seperator:Char):string;
    class function IncludeCount(const s1, s2:string):Integer;
    class function Pretty(const s1:string):string;
    class function WordCount(const s:string):Integer;
    class function ExtractWord(const s:string; WordNumber:Integer):string;
    class function ExtractWordDef(const s:string; WordNumber:Integer; const Default:string):string;
    class function PrettyWord(const s:string):string;
    class function DeleteAllOf(const s:string; const Args: array of string): string;
    class function ContainsAnyOf(const s:string; const Args: array of string): Boolean;
    class function Hash(const s:string): string;
    class function IsNumber(const s:string):Boolean;
    class function SpaceCount(const s:string):Integer;
    class function StringCount(s,s1:string; IgnoreCase:Boolean):Integer;

    //for script
    class function Length(const s1:string):Integer;
    class function Contains(const s1, s2:string; IgnoreCase:Boolean):Boolean;
    class function EndsWith(const s1, s2:string; IgnoreCase:Boolean):Boolean;
    class function StartsWith(const s1, s2:string; IgnoreCase:Boolean):Boolean;
    class function Position(const s1, s2:string; IgnoreCase:Boolean):Integer;
    class function PositionFrom(const s1, s2:string; IgnoreCase:Boolean; StartIndex:Integer):Integer;
    class function ToLower(const s1:string):string;
    class function ToUpper(const s1:string):string;
    class function QuotedStr(const s1:string):string;
    class function LeadingZeros(AValue:Integer; TotalLength: Word):string;

 end;

const
 DelphiQuoteChar = #39;

implementation

{ TStringUtils }

class function TStringUtils.AppendWithSpaces(const s: string;  const MaxLength: Integer): string;
var
 x:Integer;
 L:Integer;
 NewLength:Integer;
begin
 L:=Length(s);
 NewLength:=MaxLength-L-1;
 Result:=s;
  for x:=0 to NewLength do
   Result:=Result+' ';
end;

class function TStringUtils.StringCount(s,s1: string; IgnoreCase:Boolean): Integer;
var
 AIndex:Integer;
begin
 if IgnoreCase then
  begin
    s:=s.ToLower;
    s1:=s1.ToLower;
  end;
 Result:=0;
 AIndex:=s.IndexOf(s1);
 while AIndex>=0 do
  begin
    Inc(Result);
    AIndex:=s.IndexOf(s1,AIndex+Length(s1));
  end;
end;

class function TStringUtils.Contains(const s1, s2: string; IgnoreCase:Boolean): Boolean;
begin
 if IgnoreCase then
  Result:=s1.ToLower.Contains(s2.ToLower)
   else
  Result:=s1.Contains(s2);
end;

class function TStringUtils.ContainsAnyOf(const s: string; const Args: array of string): Boolean;
var
 s1:string;
begin
 for s1 in Args do
  if s.Contains(s) then
   Exit(True);
  Result:=False;
end;

class function TStringUtils.DeleteAllOf(const s: string;   const Args: array of string): string;
var
 s1:string;
begin
 Result:=s;
 for s1 in Args do
  Result:=Result.Replace(s1,'', [rfReplaceAll, rfIgnoreCase]);
end;


class function TStringUtils.DeQuoteDelphiString(const s: string): string;
begin
 if (s.StartsWith(DelphiQuoteChar)) and (s.EndsWith(DelphiQuoteChar)) and (s.Length>=2) then
  Result:=s.Substring(1,s.Length-2)
   else
  Result:=s;
end;

class function TStringUtils.EndsWith(const s1, s2: string; IgnoreCase:Boolean): Boolean;
begin
 Result:=s1.EndsWith(s2,IgnoreCase);
end;

class function TStringUtils.ExtractQuotedText(const s, QuoteChar1,  QuoteChar2: string): string;
var
 AIndex1, AIndex2:Integer;
begin
 AIndex1:=s.IndexOf(QuoteChar1);
 AIndex2:=s.LastIndexOf(QuoteChar2);
 if (AIndex1>=0) and (AIndex2>=0) and (AIndex1<AIndex2) then
  Result:=s.Substring(AIndex1+1,AIndex2-AIndex1-1)
   else
  Result:=s;
end;

class function TStringUtils.FindMaxLength(List: TStrings): Integer;
var
 x:Integer;
 L:Integer;
begin
 Result:=-1;
 for x:=0 to List.Count-1 do
  begin
   L:=Length(List.Names[x]);
   if L>Result then
    Result:=L;
  end;
end;

class function TStringUtils.Hash(const s: string): string;
var
 Args:array of string;
begin
  Args:=[' ','_','-','#','.',',','!','=',#9,#13,#10,'"',';','@',DelphiQuoteChar];
  Result:=DeleteAllOf(s,Args).ToLower;
end;

class function TStringUtils.HashStringSpaces(const s: string): string;
begin
 Result:=StringReplace(s,' ','',[rfReplaceAll]);
 Result:=AnsiLowerCase(Result);
end;

class function TStringUtils.IncludeCount(const s1, s2: string): Integer;
begin
 raise Exception.Create('IncludeCount Not implemented');
end;

class function TStringUtils.IsNumber(const s: string): Boolean;
var
 x:Int64;
begin
 Result:=TryStrToInt64(s,x);
end;

class function TStringUtils.NullIfEmpty(const s: string): string;
begin
 if Trim(s).IsEmpty then
  Result:='NULL'
   else
  Result:=s;
end;

class function TStringUtils.Position(const s1, s2: string; IgnoreCase: Boolean): Integer;
begin
 if IgnoreCase then
 Result:=s1.ToLower.IndexOf(s2.ToLower)
  else
 Result:=s1.IndexOf(s2);
end;

class function TStringUtils.PositionFrom(const s1, s2: string; IgnoreCase: Boolean; StartIndex: Integer): Integer;
begin
 if IgnoreCase then
  Result:=s1.ToLower.IndexOf(s2.ToLower,StartIndex)
   else
  Result:=s1.IndexOf(s2,StartIndex);
end;

class function TStringUtils.Pretty(const s1: string): string;
var
 List:TStringList;
 x:Integer;
begin
 List:=TStringList.Create;
  try
   List.Delimiter:=' ';
   List.DelimitedText:=s1;
   Result:='';
   for x:=0 to List.Count-1 do
    if x=List.Count then
     Result:=Result+PrettyWord(List[x])
      else
     Result:=Result+' '+PrettyWord(List[x]);

   Result:=Result.Replace('  ',' ',[rfReplaceAll]);
   if Result.EndsWith(' ') then
    Result:=Result.Substring(0,Result.Length-1);
  finally
   List.Free;
  end;
end;

class function TStringUtils.PrettyWord(const s: string): string;
var
 C:Char;
 s2:string;
begin
 if s<>'' then
  begin
   Result:=s.ToLower;
   C:=s[1];
   s2:=C;
   s2:=s2.ToUpper;
   C:=s2[1];
   Result[1]:=C;
  end
   else
  Result:=s;
end;

class function TStringUtils.QuotedStr(const s1: string): string;
begin
 Result:=System.SysUtils.QuotedStr(s1);
end;

class function TStringUtils.RemoveBrackets(const s: string; StartBracket, EndBracket: string): string;
begin
 Result:=s.Replace(StartBracket,'');
 Result:=Result.Replace(EndBracket,'');
end;

class function TStringUtils.RemoveDualSpaces(const s: string): string;
begin
 Result:=s.Replace('  ',' ');
 while Result.Contains('  ') do
  Result:=Result.Replace('  ',' ');
end;

class function TStringUtils.ReplaceCaseInsensitive(const s, OldPattern,  NewPattern: string): string;
begin
 Result:=StringReplace(s,OldPattern,NewPattern,[rfReplaceAll,rfIgnoreCase]);
end;


class function TStringUtils.LeadingZeros(AValue:Integer; TotalLength: Word): string;
begin
 Result := Format('%.*d', [TotalLength, AValue]);
end;

class function TStringUtils.LeftFromDot(const s, Default: string): string;
var
 AIndex:integer;
begin
 AIndex:=s.IndexOf('.');
  if (AIndex>0) then
   Result:=s.Substring(0,AIndex)
    else
   Result:=Default;
end;

class function TStringUtils.RightFromDot(const s, Default: string): string;
var
 AIndex:integer;
begin
 AIndex:=s.IndexOf('.');
  if (AIndex>0) and (AIndex+1<s.Length) then
   Result:=s.Substring(AIndex+1)
    else
   Result:=Default;
end;

class function TStringUtils.LeftFromText(const s, Pattern,  Default: string): string;
var
 AIndex:integer;
begin
 AIndex:=s.IndexOf(Pattern,0);
  if (AIndex>0) then
   Result:=s.Substring(0,AIndex)
    else
   Result:=Default;
end;


class function TStringUtils.Length(const s1: string): Integer;
begin
 Result:=s1.Length;
end;

class function TStringUtils.ListToString(List: TList<string>): string;
var
 AList:TStringList;
 s:string;
begin
 AList:=TStringList.Create;
 try
  for s in List do
    AList.Add(s);
   Result:=AList.Text;
 finally
  AList.Free;
 end;
end;

class function TStringUtils.ListToStringLine(List: TList<Integer>;const Seperator: Char): string;
var
 AList:TStringList;
 AValue:Integer;
begin
 AList:=TStringList.Create;
 try
  for AValue in List do
    AList.Add(AValue.ToString);
   AList.Delimiter:=Seperator;
   Result:=AList.DelimitedText;
 finally
  AList.Free;
 end;
end;

class function TStringUtils.RightFromText(const s, Pattern,  Default: string): string;
var
 AIndex:Integer;
begin
 AIndex:=s.IndexOf(Pattern,0);
  if (AIndex>0) and (AIndex+1<s.Length) then
   Result:=s.Substring(AIndex+1)
    else
   Result:=Default;
end;

class function TStringUtils.SameString(const Str1, Str2: String): Boolean;
begin
 Result:=string.Compare(Str1,Str2,True)=0;
end;

class function TStringUtils.SameTrimString(const Str1, Str2: String): Boolean;
begin
 Result:=AnsiLowerCase(Trim(Str1))=AnsiLowerCase(Trim(Str2));
end;

class function TStringUtils.SpaceCount(const s: string): Integer;
var
 Temp:string;
begin
 Temp:=s;
 while Temp.Contains('  ') do
  Temp:=Temp.Replace('  ',' ');

 Result:=StringCount(Temp,' ', False);
end;

class function TStringUtils.StartsWith(const s1, s2: string; IgnoreCase:Boolean): Boolean;
begin
 Result:=s1.StartsWith(s2, IgnoreCase);
end;

class function TStringUtils.StringMaxLength(const s: string;  const MaxLength: integer): string;
begin
 if Length(s)>MaxLength then
  Result:=Copy(s,0,MaxLength)
   else
  Result:=s;
end;

class function TStringUtils.ToLower(const s1: string): string;
begin
 Result:=s1.ToLower;
end;

class function TStringUtils.ToUpper(const s1: string): string;
begin
 Result:=s1.ToUpper;
end;

class function TStringUtils.WordCount(const s: string): Integer;
var
 List:TStringList;
begin
  List:=TStringList.Create;
  try
   List.Delimiter:=' ';
   List.DelimitedText:=s;
   Result:=List.Count;
  finally
   List.Free;
  end;
end;


class function TStringUtils.ExtractWord(const s: string; WordNumber: Integer): string;
var
 List:TStringList;
begin
  List:=TStringList.Create;
  try
   List.Delimiter:=' ';
   List.QuoteChar:=#0;
   List.DelimitedText:=s;
   Result:=List[WordNumber];
  finally
   List.Free;
  end;
end;


class function TStringUtils.ExtractWordDef(const s: string; WordNumber: Integer;  const Default: string): string;
var
 List:TStringList;
begin
  List:=TStringList.Create;
  try
   List.Delimiter:=' ';
   List.QuoteChar:=#0;
   List.DelimitedText:=s;
   if List.Count<WordNumber then
    Result:=Default
     else
    Result:=List[WordNumber];
  finally
   List.Free;
  end;
end;

end.
