unit Common.LookAndFeel;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, dxLayoutLookAndFeels, cxClasses,
  cxStyles, cxLookAndFeels,
  System.UITypes, Vcl.StdCtrls;

type
  TGridColors = class
  private
    FDefaultGridBackColor: TColor;
    FDefaultGridFontColor: TColor;
    FSelectedCellColor: TColor;
    FSelectedCellFontColor: TColor;
    FSelectedLineColor: TColor;
    FSelectedLineFontColor: TColor;
  public
    property BackColor: TColor read FDefaultGridBackColor write FDefaultGridBackColor;
    property FontColor: TColor read FDefaultGridFontColor write FDefaultGridFontColor;
    property SelectedCellColor: TColor read FSelectedCellColor write FSelectedCellColor;
    property SelectedCellFontColor: TColor read FSelectedCellFontColor write FSelectedCellFontColor;
    property SelectedLineColor: TColor read FSelectedLineColor write FSelectedLineColor;
    property SelectedLineFontColor: TColor read FSelectedLineFontColor write FSelectedLineFontColor;
    constructor Create;
    procedure SetBlackStyle;
    procedure SetWhiteStyle;
  end;

  TMiceColorTheme = (mctWhiteTheme, mctDarkTheme);

  TDefaultLookAndFeel = class(TForm)
    DefaultLayoutLookAndFeel: TdxLayoutLookAndFeelList;
    ManagerDialog: TdxLayoutStandardLookAndFeel;
    GridRepository: TcxStyleRepository;
    StyleGridBand: TcxStyle;
    DefaultLookAndFeel: TcxLookAndFeelController;
    StyleGridBack: TcxStyle;
    StyleGridColumn: TcxStyle;
    StyleBarItem: TcxStyle;
  private
    FWindowColor: TColor;
    FGridColors: TGridColors;
    FTheme: TMiceColorTheme;
    FStaleDataCellColor: TColor;
    FControlColor: TColor;
    FFlowChartMinorLinesColor: TColor;
    FFlowChartMajorLinesColor: TColor;
    procedure SetWindowColor(const Value: TColor);
    procedure UpdateGroupColors(const Value: TColor);
    procedure SetTheme(const Value: TMiceColorTheme);
    procedure SetDarkTheme;
    procedure SetWhiteTheme;
    procedure SetControlColor(const Value: TColor);
    procedure SetFlowChartMajorLinesColor(const Value: TColor);
    procedure SetFlowChartMinorLinesColor(const Value: TColor);
  public
    property FlowChartMajorLinesColor:TColor read FFlowChartMajorLinesColor write SetFlowChartMajorLinesColor;
    property FlowChartMinorLinesColor:TColor read FFlowChartMinorLinesColor write SetFlowChartMinorLinesColor;
    property ControlColor: TColor read FControlColor write SetControlColor;
    property WindowColor: TColor read FWindowColor write SetWindowColor;
    property StaleDataCellColor:TColor read FStaleDataCellColor write FStaleDataCellColor;
    property GridColors: TGridColors read FGridColors;
    property Theme:TMiceColorTheme read FTheme write SetTheme;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  end;

var
  DefaultLookAndFeel: TDefaultLookAndFeel;

const
  clSoftBlack    = $004A4136;
  clSofterBlack  = $00C8C2C6;
  clReducedBlack = clSoftBlack-$101010;
  clDeepBlack    = $002A2116;
  clSoftWhite    = $00F0F9FF;
  clSoftSilver   = $E5E5E5;
  clDeepSilver   = $656565;
  clDarkGray     = $808080;
  clSoftYellow   = $C1FFFF;
  clSoftBlue     = $FFFFC1;
  clSoftOrange   = $00A0FF;
  clDarkOrange   = $0070DF;
  clSoftGreen    = $20D02F;
  clDefaultGridColorBright = -16777211;
  clDefaultGridFontColorBright = -16777208;
  clDefaultDevExpressControlColorBright = -16777205;



implementation

{$R *.dfm}
{ TDefaultLookAndFeel }

constructor TDefaultLookAndFeel.Create(AOwner: TComponent);
begin
  inherited;
  FGridColors:=TGridColors.Create;
  StaleDataCellColor:=clDarkGray;
  Theme:=TMiceColorTheme.mctWhiteTheme;
end;

destructor TDefaultLookAndFeel.Destroy;
begin
  FGridColors.Free;
  inherited;
end;

procedure TDefaultLookAndFeel.SetDarkTheme;
begin
 GridColors.SetBlackStyle;

 StyleGridBand.Color:=clSoftBlack;
 StyleGridBack.Color:=clSoftBlack;
 StyleGridColumn.Color:=clSoftBlack;
 StyleBarItem.TextColor:=clSoftWhite;

 WindowColor:=clSoftBlack;
 ControlColor:=clSofterBlack;
 ManagerDialog.ItemOptions.CaptionOptions.TextColor:=clSoftWhite;
 FlowChartMajorLinesColor:=clBlack;
 FlowChartMinorLinesColor:=clReducedBlack;
end;

procedure TDefaultLookAndFeel.SetFlowChartMajorLinesColor(const Value: TColor);
begin
  FFlowChartMajorLinesColor := Value;
end;

procedure TDefaultLookAndFeel.SetFlowChartMinorLinesColor(const Value: TColor);
begin
  FFlowChartMinorLinesColor := Value;
end;

procedure TDefaultLookAndFeel.SetWhiteTheme;
var
 ADefault:TColor;
begin
 ADefault:= clWhite;
// WindowColor:=Self.Color;


 WindowColor:=ADefault;
 StyleGridBand.Color:=ADefault;
 StyleGridBack.Color:=ADefault;
 StyleGridColumn.Color:=ADefault;

 StyleBarItem.TextColor:=clBlack;
 ManagerDialog.ItemOptions.CaptionOptions.TextColor:=clBlack;

 ControlColor:=clDefaultDevExpressControlColorBright;
 FlowChartMajorLinesColor:=$00D0D0D0;
 FlowChartMinorLinesColor:=$00E8E8E8;

 GridColors.SetWhiteStyle;

end;


procedure TDefaultLookAndFeel.SetControlColor(const Value: TColor);
begin
  FControlColor := Value;
end;

procedure TDefaultLookAndFeel.SetWindowColor(const Value: TColor);
begin
  if FWindowColor <> Value then
  begin
    FWindowColor := Value;
    UpdateGroupColors(Value);
  end;
end;

procedure TDefaultLookAndFeel.SetTheme(const Value: TMiceColorTheme);
begin
 FTheme := Value;
 case Value of
  mctWhiteTheme: SetWhiteTheme;
  mctDarkTheme: SetDarkTheme;
 end;
end;

procedure TDefaultLookAndFeel.UpdateGroupColors(const Value: TColor);
var
  x: Integer;
begin
  for x := 0 to DefaultLayoutLookAndFeel.Count - 1 do
   DefaultLayoutLookAndFeel.Items[x].GroupOptions.Color := Value;
end;

{ TGridColors }

constructor TGridColors.Create;
begin
 SetWhiteStyle;
end;


procedure TGridColors.SetBlackStyle;
begin
 BackColor:=clSoftBlack;
 FontColor:=clSoftWhite;
 SelectedCellColor:=clReducedBlack;
 SelectedCellFontColor:=clSoftWhite;
 SelectedLineColor:=clDeepSilver;
 SelectedLineFontColor:=clSoftWhite;
end;

procedure TGridColors.SetWhiteStyle;
begin
 BackColor:=clDefaultGridColorBright;
 FontColor:=clDefaultGridFontColorBright;
 SelectedCellColor:=clSilver;
 SelectedCellFontColor:=clDefault;
 SelectedLineColor:=clSoftSilver;
 SelectedLineFontColor:=clDefault;
end;

initialization
 DefaultLookAndFeel:=TDefaultLookAndFeel.Create(nil);

finalization
 DefaultLookAndFeel.Free;

end.
