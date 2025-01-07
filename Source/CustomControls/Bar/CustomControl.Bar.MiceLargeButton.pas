unit CustomControl.Bar.MiceLargeButton;

interface
uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  dxBar, cxClasses, cxButtonEdit, cxImage, cxCheckBox, cxCalendar, cxBarEditItem, Data.DB,
  CustomControl.Interfaces,
  DAC.XParams,
  Plugin.Base,
  Common.LookAndFeel,
  CustomControl.MiceBalloons;

type
 TMiceBarLargeButton = class(TdxBarLargeButton, ICanManageParams, ICanSaveLoadState)
  private
    FPlugin: TBasePlugin;
    FLoading: Boolean;
    FAutoRefresh: Boolean;
    FParamName: string;
    FCheckedValue: Variant;
    FUncheckedValue: Variant;
    procedure DoOnClick(Sender:TObject);
    procedure DoRefresh;
    procedure SetParamsTo(Params:TxParams);
    procedure LoadState(Params:TxParams);
    procedure SaveState(Params:TxParams);
  public
    property Loading:Boolean read FLoading write FLoading;
    property AutoRefresh:Boolean read FAutoRefresh write FAutoRefresh;
    property Plugin:TBasePlugin read FPlugin write FPlugin;
    property ParamName:string read FParamName write FParamName;
    property CheckedValue:Variant read FCheckedValue write FCheckedValue;
    property UncheckedValue:Variant read FUncheckedValue write FUncheckedValue;
    procedure UpdateStyle(Style:TdxBarButtonStyle);
    procedure LoadFromDataSet(DataSet:TDataSet);
    constructor Create(AOwner:TComponent); override;
    destructor Destroy; override;
    class function CreateDefault(AOwner:TBasePlugin; DataSet:TDataSet; Style:TdxBarButtonStyle):TMiceBarLargeButton;
 end;


implementation

{ TMiceBarDateEdit }

constructor TMiceBarLargeButton.Create(AOwner: TComponent);
begin
  inherited;
  Align:=TdxBarItemAlign.iaRight;
end;

class function TMiceBarLargeButton.CreateDefault(AOwner: TBasePlugin;  DataSet: TDataSet; Style:TdxBarButtonStyle): TMiceBarLargeButton;
begin
 Result:=TMiceBarLargeButton.Create(AOwner);
 Result.Plugin:= AOwner;
 Result.UpdateStyle(Style);
 Result.LoadFromDataSet(DataSet);
 Result.Loading:=False;
 Result.AutoGrayScale:=False;
 Result.Style:=DefaultLookAndFeel.StyleBarItem;
end;


destructor TMiceBarLargeButton.Destroy;
begin

  inherited;
end;


procedure TMiceBarLargeButton.DoRefresh;
begin
if (Assigned(Plugin)) and (AutoRefresh) then
  Plugin.RefreshDataSet;
end;

procedure TMiceBarLargeButton.DoOnClick(Sender: TObject);
begin
if Loading=False then
 DoRefresh;
end;

procedure TMiceBarLargeButton.LoadFromDataSet(DataSet: TDataSet);
begin
{ if (DataSet.FieldByName('InitString').IsNull=False) then
    TryInitAppObject(DataSet.FieldByName('InitString').AsString);}

  if DataSet.FieldByName('ShowCaption').AsBoolean then
     PaintStyle:=psCaptionGlyph;

  ImageIndex:=DataSet.FieldByName('ImageIndex').AsInteger;
  LargeImageIndex:=DataSet.FieldByName('ImageIndex').AsInteger;
  Width:=DataSet.FieldByName('Width').AsInteger;
  AutoRefresh:=DataSet.FieldByName('AutoRefresh').AsBoolean;
  ParamName:=DataSet.FieldByName('ParamName').AsString;
  CheckedValue:=DataSet.FieldByName('SPValue').Value;
  UncheckedValue:=DataSet.FieldByName('SPValue1').Value;
end;


procedure TMiceBarLargeButton.SaveState(Params: TxParams);
begin
 SetParamsTo(Params);
end;

procedure TMiceBarLargeButton.SetParamsTo(Params: TxParams);
begin
 if Self.Down then
  Params.SetParameter(ParamName, CheckedValue)
   else
  Params.SetParameter(ParamName, UnCheckedValue)
end;

procedure TMiceBarLargeButton.LoadState(Params: TxParams);
begin
 Loading:=True;
  try
   Down:=Params.AsBooleanDef(ParamName,UncheckedValue );
  finally
    Loading:=False;
  end;
end;

procedure TMiceBarLargeButton.UpdateStyle(Style: TdxBarButtonStyle);
begin
 ButtonStyle:=Style;
 if Style=TdxBarButtonStyle.bsChecked then
  OnClick:=DoOnClick
   else
  OnClick:=nil;
end;

initialization
  dxBarRegisterItem(TMiceBarLargeButton, TdxBarLargeButtonControl, True );
end.
