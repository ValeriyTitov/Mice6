unit CustomControl.Bar.MiceButton;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  dxBar, cxClasses, cxButtonEdit, cxImage, cxCheckBox, cxCalendar, cxBarEditItem, Data.DB,
  CustomControl.Interfaces,
  DAC.XParams,
  Plugin.Base;

type
 TMiceBarButton = class(TdxBarButton, ICanManageParams, ICanSaveLoadState)
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
    class function CreateDefault(AOwner:TBasePlugin; DataSet:TDataSet; Style:TdxBarButtonStyle):TMiceBarButton;
 end;

implementation

{ TMiceBarDateEdit }

constructor TMiceBarButton.Create(AOwner: TComponent);
begin
  inherited;
  Loading:=True;
  Align:=TdxBarItemAlign.iaLeft;
end;

class function TMiceBarButton.CreateDefault(AOwner: TBasePlugin;  DataSet: TDataSet; Style:TdxBarButtonStyle): TMiceBarButton;
begin
 Result:=TMiceBarButton.Create(AOwner);
 Result.Plugin:= AOwner;
 Result.UpdateStyle(Style);
 Result.LoadFromDataSet(DataSet);
 Result.Loading:=False;
end;

destructor TMiceBarButton.Destroy;
begin

  inherited;
end;


procedure TMiceBarButton.DoRefresh;
begin
if (Assigned(Plugin)) and (AutoRefresh) then
  Plugin.RefreshDataSet;
end;

procedure TMiceBarButton.DoOnClick(Sender: TObject);
begin
 if Loading=False then
  DoRefresh;
end;

procedure TMiceBarButton.LoadFromDataSet(DataSet: TDataSet);
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


procedure TMiceBarButton.SaveState(Params: TxParams);
begin
 SetParamsTo(Params);
end;

procedure TMiceBarButton.SetParamsTo(Params: TxParams);
begin
 if Self.Down then
  Params.SetParameter(ParamName, CheckedValue)
   else
  Params.SetParameter(ParamName, UnCheckedValue)
end;

procedure TMiceBarButton.LoadState(Params: TxParams);
begin

end;

procedure TMiceBarButton.UpdateStyle(Style: TdxBarButtonStyle);
begin
 ButtonStyle:=Style;
 if Style=TdxBarButtonStyle.bsChecked then
  OnClick:=DoOnClick
   else
  OnClick:=nil;
end;

initialization
  dxBarRegisterItem(TMiceBarButton, TdxBarButtonControl, True );
end.
