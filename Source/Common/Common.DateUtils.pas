unit Common.DateUtils;

interface
 uses System.DateUtils, System.SysUtils;

type
  TDateUtils = class
  public
   class function ToIso8601(const D:TDateTime):string;
   class function ToJsonDate(const D:TDateTime):string;
   class function ToJsonDateTime(const D:TDateTime):string;
   class function EndOfADay(const D:TDateTime):TDateTime;
   class function StartOfTheQuarter(const D:TDateTime):TDateTime;
   class function EndOfTheQuarter (const D:TDateTime):TDateTime;
   class function StartOfTheYear(const D:TDateTime):TDateTime;
   class function EndOfTheYear(const D:TDateTime):TDateTime;
   class function StartOfAMonth(const D:TDateTime):TDateTime;
   class function EndOfAMonth(const D:TDateTime):TDateTime;
   class function RemoveTime(const D:TDateTime):TDateTime;
   class function DateTimeToStr(const D:TDateTime; const AFormat:string):string;
   class function DaysBetween(const D1, D2:TDateTime):Integer;
   class function AddDays(const D1:TDateTime; Amount:Integer):TDateTime;
   class function AddMonths(const D1:TDateTime; Amount:Integer):TDateTime;
   class function AddYears(const D1:TDateTime; Amount:Integer):TDateTime;
   class function SecondsToTime(const Seconds:Integer):string;
   class function Today:TDate;
   class function Now:TDateTime;
  end;

implementation
const
 DEFAULT_DATE_FORMAT = 'yyyy-mm-dd';
 DEFAULT_DATETIME_FORMAT = 'yyyy-mm-dd hh:mm:ss:ms'; //ISO 8601: 2012-04-23T18:25:43.511Z

{ TDateUtils }


class function TDateUtils.AddDays(const D1: TDateTime; Amount: Integer): TDateTime;
begin
 Result:=IncDay(D1,Amount);
end;

class function TDateUtils.AddMonths(const D1: TDateTime;  Amount: Integer): TDateTime;
begin
 Result:=IncMonth(D1,Amount);
end;

class function TDateUtils.AddYears(const D1: TDateTime;  Amount: Integer): TDateTime;
var
 Year, Month, Day, AHour, AMinute, ASeconds, AMSeconds:Word;
begin
 DecodeDateTime(D1,Year, Month,Day,AHour, AMinute, ASeconds, AMSeconds);
 Result:=EncodeDateTime(Year+Amount, Month,Day,AHour, AMinute, ASeconds, AMSeconds);
end;

class function TDateUtils.DateTimeToStr(const D: TDateTime; const AFormat: string): string;
begin
 Result:=FormatDateTime(AFormat, D);
end;

class function TDateUtils.DaysBetween(const D1, D2: TDateTime): Integer;
begin
 Result:=System.DateUtils.DaysBetween(D1,D2);
end;

class function TDateUtils.EndOfADay(const D: TDateTime): TDateTime;
var
 Year, Month, Day:Word;
begin
 DecodeDate(D,Year, Month,Day);
 Result:=System.DateUtils.EndOfADay(Year,Month,Day);
end;

class function TDateUtils.EndOfAMonth(const D: TDateTime): TDateTime;
begin
 Result:=System.DateUtils.EndOfTheMonth(D);
end;

class function TDateUtils.EndOfTheQuarter(const D: TDateTime): TDateTime;
var
 Year, Month, Day:Word;
begin
 DecodeDate(D,Year, Month,Day);
 case Month of
  1..3:Result:=EncodeDate(Year,3,31);
  4..6:Result:=EncodeDate(Year,6,30);
  7..9:Result:=EncodeDate(Year,9,30);
  else
   Result:=EncodeDate(Year,12,31);
 end;

end;
class function TDateUtils.EndOfTheYear(const D: TDateTime): TDateTime;
var
 Year, Month, Day: Word;
begin
 DecodeDate(D,Year, Month,Day);
 Result:=EncodeDate(Year,12,31);
end;

class function TDateUtils.Now: TDateTime;
begin
 Result:=System.SysUtils.Now;
end;

class function TDateUtils.RemoveTime(const D: TDateTime): TDateTime;
var
 Year, Month, Day: Word;
begin
 DecodeDate(D,Year, Month,Day);
 Result:=EncodeDate(Year,Month,Day);
end;

class function TDateUtils.SecondsToTime(const Seconds: Integer): string;
var
 SecondsRemain, Hours, Minutes:Integer;
const
 ATimeFormat = '%.*d:%.*d:%.*d';
begin
 SecondsRemain:=Seconds;
 Hours:=Seconds div 3600;
 Dec(SecondsRemain, Hours*3600);
 Minutes:=SecondsRemain div 60;
 Dec(SecondsRemain, Minutes * 60);
 Result:=Format(ATimeFormat, [2, Hours,2,Minutes,2,SecondsRemain]);
end;

class function TDateUtils.StartOfAMonth(const D: TDateTime): TDateTime;
var
 Year, Month, Day:Word;
begin
 DecodeDate(D,Year, Month,Day);
 Result:=System.DateUtils.StartOfAMonth(Year,Month);
end;

class function TDateUtils.StartOfTheQuarter(const D: TDateTime): TDateTime;
var
 Year, Month, Day:Word;
begin
 DecodeDate(D,Year, Month,Day);
 case Month of
  1..3:Result:=EncodeDate(Year,1,1);
  4..6:Result:=EncodeDate(Year,4,1);
  7..9:Result:=EncodeDate(Year,7,1);
  else
   Result:=EncodeDate(Year,10,1);
 end;
end;

class function TDateUtils.StartOfTheYear(const D: TDateTime): TDateTime;
begin
 Result:=System.DateUtils.StartOfTheYear(D);
end;

class function TDateUtils.Today: TDate;
begin
 Result:=System.DateUtils.Today;
end;

class function TDateUtils.ToIso8601(const D: TDateTime): string;
begin
  Result:=FormatDateTime(DEFAULT_DATETIME_FORMAT, D);
  Result:=Result.Replace(' ','T')+'Z';// ISO 8601: 2012-04-23T18:25:43.511Z
end;

class function TDateUtils.ToJsonDate(const D: TDateTime): string;
begin
 Result:=FormatDateTime(DEFAULT_DATE_FORMAT, D);
end;

class function TDateUtils.ToJsonDateTime(const D: TDateTime): string;
begin
 Result:=ToIso8601(D);
end;

end.
