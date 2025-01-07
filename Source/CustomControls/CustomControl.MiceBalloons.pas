unit CustomControl.MiceBalloons;

interface
 uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, VCL.ExtCtrls, VCL.Forms;

 type
  TMiceBalloons = class
   private
    class procedure OnTimer(Sender:TObject);
   public
    class procedure ShowBalloon(const ACaption, AText:string; IconType:Integer);
    class procedure Show(const ACaption, AText:string);
  end;

implementation

var
 Icon:TTrayIcon;
 Timer:TTimer;


{ TMiceBalloons }

class procedure TMiceBalloons.OnTimer(Sender: TObject);
begin
 Timer.Enabled:=False;
 Icon.Visible:=False;
 Icon.BalloonHint:='';
end;

class procedure TMiceBalloons.Show(const ACaption, AText: string);
begin
  Icon.Visible:=True;
  Icon.BalloonHint:=AText;
  Icon.BalloonTitle:=ACaption;
  Icon.BalloonTimeout:=20;
  Timer.Interval:=Icon.BalloonTimeout*1000;
  Icon.ShowBalloonHint;
end;

class procedure TMiceBalloons.ShowBalloon(const ACaption, AText: string;  IconType: Integer);
var
 List:TStringList;
begin
 List:=TStringList.Create;
 try
  Timer.Enabled:=False;
  List.Text:=Icon.BalloonHint;
  Icon.Visible:=True;
  if List.IndexOf(AText)<0 then
   List.Add(AText);
  Icon.BalloonHint:=List.Text;
  Icon.BalloonTitle:=Application.Title;
  Icon.BalloonTimeout:=20;
  Icon.ShowBalloonHint;
  Timer.Interval:=Icon.BalloonTimeout*1000;
//  Timer.Enabled:=True;
 finally
  List.Free;
 end;
end;

initialization
 Icon:=TTrayIcon.Create(Application);
 Timer:=TTimer.Create(Application);
 Timer.Enabled:=False;
 Timer.Interval:=10000;
 Timer.OnTimer:=TMiceBalloons.OnTimer;
end.

