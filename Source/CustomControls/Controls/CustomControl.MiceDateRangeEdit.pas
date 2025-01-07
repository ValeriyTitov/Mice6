unit CustomControl.MiceDateRangeEdit;

interface
uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  cxGraphics, cxControls, cxLookAndFeels, Vcl.Controls, Vcl.ExtCtrls,  Vcl.StdCtrls,
  cxLookAndFeelPainters, cxContainer, cxEdit, dxCore, cxDateUtils,
  cxTextEdit, cxMaskEdit, cxDropDownEdit, cxCalendar, DateUtils;


type
 TMiceDateRangeControl = class (TCustomPanel)
  private
    FStartDateControl: TcxDateEdit;
    FEndDateControl: TcxDateEdit;
    FOnChange: TNotifyEvent;
    FMaxPeriodDays: Integer;
    FLabel:TLabel;
    FCaption: string;
    FUpdating:Boolean;
    procedure SetEndDate(const Value: TDateTime);
    procedure SetStartDate(const Value: TDateTime);
    function GetEndDate: TDateTime;
    function GetStartDate: TDateTime;
    procedure SetCaption(const Value: string);
  protected
    function CreateDefaultControl(ALeft, AWidth:Integer):TcxDateEdit;
    procedure HandleOnChange(Sender:TObject);
    procedure CheckPeriod(Sender:TObject);
    procedure UpdateWidth;
  public
    property StartDate:TDateTime read GetStartDate write SetStartDate;
    property EndDate:TDateTime read GetEndDate write SetEndDate;
    property OnChange:TNotifyEvent read FOnChange write FOnChange;
    property MaxPeriodDays:Integer read FMaxPeriodDays write FMaxPeriodDays;
    property Caption:string read FCaption write SetCaption;
    constructor Create(AOwner:TComponent); override;
    destructor Destroy; override;
  end;



implementation

{ TMiceDateRangeControl }

procedure TMiceDateRangeControl.CheckPeriod(Sender:TObject);
begin
 FUpdating:=True;
 try
   if (Sender=Self.FStartDateControl) then
    begin
     if (StartDate>EndDate) then
      EndDate:=StartDate;
     if DaysBetween(StartDate, EndDate)> MaxPeriodDays then
      EndDate:=IncDay(StartDate,MaxPeriodDays);
    end
     else
   if (Sender=Self.FEndDateControl) then
    begin
     if (EndDate<StartDate) then
      StartDate:=EndDate;
     if DaysBetween(StartDate, EndDate)> MaxPeriodDays then
      StartDate:=IncDay(EndDate,-MaxPeriodDays);
    end;

 finally
   FUpdating:=False;
 end;
end;

constructor TMiceDateRangeControl.Create(AOwner: TComponent);
var
 DefaultControlWidth:Integer;
 ALeft:Integer;
begin
  inherited;
  FLabel:=TLabel.Create(Self);
  FLabel.Parent:=Self;
  FLabel.AutoSize:=True;
  DefaultControlWidth:=80;
  FStartDateControl:=CreateDefaultControl(11, DefaultControlWidth);
  ALeft:=FStartDateControl.Width+FStartDateControl.Left+3;
  FEndDateControl:=CreateDefaultControl(ALeft, DefaultControlWidth);

  ShowCaption:=False;
//  BevelOuter:=bvRaised;
  BevelOuter:=bvNone;
  Width:=DefaultControlWidth*2+5;
  Height:=FStartDateControl.Height;
  Self.FLabel.Top:=Height div 2 - FLabel.Height div 2;
  Self.FLabel.Left:=2;
  MaxPeriodDays:=365;

  FEndDateControl.Date:=Today;
  StartDate:=StartOfTheMonth(Today);
 // Caption:='DateRange';
end;

function TMiceDateRangeControl.CreateDefaultControl(ALeft,  AWidth: Integer): TcxDateEdit;
begin
 Result:=TcxDateEdit.Create(Self);
 Result.Parent:=Self;
 Result.Left:=ALeft;
 Result.Width:=AWidth;
 Result.Top:=1;
 Result.Properties.ShowTime:=False;
 Result.Properties.SaveTime:=False;
 Result.Properties.DateButtons:=[];
 Result.Properties.OnChange:=HandleOnChange;
 Result.Properties.Animation:=False;
 //Result.Properties.ReadOnly:=True;
// Result.Align:=alRight;
end;

destructor TMiceDateRangeControl.Destroy;
begin

  inherited;
end;

function TMiceDateRangeControl.GetEndDate: TDateTime;
begin
 Result:=FEndDateControl.Date;
end;

function TMiceDateRangeControl.GetStartDate: TDateTime;
begin
 Result:=FStartDateControl.Date;
end;

procedure TMiceDateRangeControl.HandleOnChange(Sender: TObject);
begin
 CheckPeriod(Sender);
 if (FUpdating=False) and Assigned(OnChange) then
  OnChange(Self);
end;


procedure TMiceDateRangeControl.SetCaption(const Value: string);
begin
  FCaption := Value;
  Self.FLabel.Caption:=Value;
  UpdateWidth;
end;

procedure TMiceDateRangeControl.SetEndDate(const Value: TDateTime);
begin
  FEndDateControl.Date := Value;
end;

procedure TMiceDateRangeControl.SetStartDate(const Value: TDateTime);
begin
  FStartDateControl.Date := Value;
end;

procedure TMiceDateRangeControl.UpdateWidth;
begin
 Self.FStartDateControl.Left:=FLabel.Left+FLabel.Width+3;
 Self.FEndDateControl.Left:=Self.FStartDateControl.Left+Self.FStartDateControl.Width+2;
 Self.Width:=FLabel.Width+80*2+5;
end;

end.
