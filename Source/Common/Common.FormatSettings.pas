unit Common.FormatSettings;

interface

uses System.SysUtils, System.Classes;

const
 DEFAULT_DATE_FORMAT_SQL = 'yyyymmdd';
 DEFAULT_DATETIME_FORMAT_SQL = 'yyyymmdd';

 DEFAULT_DATE_FORMAT = 'yyyy-mm-dd';
 DEFAULT_DATETIME_FORMAT = 'yyyy-mm-dd';

 type
  TMiceFormatSettings = class
  public
    class procedure SetCustomDecimalSeperator(const Seperator:char);
    class function FindDecimalSeperator:char;
  end;


var
 MiceFormatSettings:TFormatSettings;

implementation

var
 FCustomDecimalSeperator:Char=#0;

{ TMiceFormatSettings }

class function TMiceFormatSettings.FindDecimalSeperator: char;
var
 D:Double;
begin
 if FCustomDecimalSeperator<>#0 then
  Exit(FCustomDecimalSeperator);

 if TryStrToFloat('20000.0000000000',D) then
  Result:=','
   else
  Result:='.'
end;

class procedure TMiceFormatSettings.SetCustomDecimalSeperator( const Seperator: char);
begin
 FCustomDecimalSeperator:=Seperator;
end;

initialization
 MiceFormatSettings:=TFormatSettings.Create;
 MiceFormatSettings.DecimalSeparator:=TMiceFormatSettings.FindDecimalSeperator;
 MiceFormatSettings.DateSeparator:='-';
 MiceFormatSettings.LongDateFormat:=DEFAULT_DATE_FORMAT; //'2009-10-10T00:00:00.0000000'
 MiceFormatSettings.ShortDateFormat:=DEFAULT_DATETIME_FORMAT;//'2009-10-10T00:00:00.0000000'
 MiceFormatSettings.ThousandSeparator := #0;

// MiceFormatSettings.LongDateFormat:='YYYY-MM-DD'; //'2009-10-10T00:00:00.0000000'
// MiceFormatSettings.ShortDateFormat:='YYYY-MM-DD';//'2009-10-10T00:00:00.0000000'
 {
 FFormatSettings:=TFormatSettings.Create;
 FFormatSettings.DecimalSeparator := '.';
 FFormatSettings.ThousandSeparator := #0;
 FFormatSettings.DateSeparator:='-';
 FFormatSettings.ShortDateFormat:=DEFAULT_DATE_FORMAT;
 FFormatSettings.LongDateFormat :=DEFAULT_DATETIME_FORMAT;
  }
finalization


end.
