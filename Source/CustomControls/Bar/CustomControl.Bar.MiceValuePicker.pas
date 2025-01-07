unit CustomControl.Bar.MiceValuePicker;


interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  dxBar, cxClasses, cxButtonEdit, cxImage, cxCheckBox, cxCalendar, cxBarEditItem, Data.DB,
  CustomControl.Interfaces,
  DAC.XParams,
  Plugin.Base,
  cxTextEdit,
  CustomControl.MiceBalloons;

type
 TMiceBarValuePicker = class(TcxBarEditItem, ICanManageParams, ICanSaveLoadState)
  private
    FPlugin: TBasePlugin;
    FAutoRefresh: Boolean;
    procedure SetParamsTo(Params:TxParams);
    procedure LoadState(Params:TxParams);
    procedure SaveState(Params:TxParams);

  public
    procedure LoadFromDataSet(DataSet:TDataSet);
    constructor Create(AOwner:TComponent); override;
    destructor Destroy; override;
    class function CreateDefault(AOwner: TBasePlugin; DataSet:TDataSet):TMiceBarValuePicker;

    property AutoRefresh:Boolean read FAutoRefresh write FAutoRefresh;
    property Plugin:TBasePlugin read FPlugin write FPlugin;
 end;

implementation

{ TMiceBarDateEdit }

constructor TMiceBarValuePicker.Create(AOwner: TComponent);
begin
  inherited;
  PropertiesClass:=TcxTextEditProperties;
  EditValue:=ClassName;
end;

class function TMiceBarValuePicker.CreateDefault(AOwner:  TBasePlugin;  DataSet: TDataSet): TMiceBarValuePicker;
begin
 Result:=TMiceBarValuePicker.Create(AOwner);
 Result.Plugin:=AOwner;
 Result.LoadFromDataSet(DataSet);
end;

destructor TMiceBarValuePicker.Destroy;
begin

  inherited;
end;


procedure TMiceBarValuePicker.LoadFromDataSet(DataSet: TDataSet);
begin
  if DataSet.FieldByName('ShowCaption').AsBoolean then
   PaintStyle:=psCaptionGlyph;
end;


procedure TMiceBarValuePicker.SaveState(Params: TxParams);
begin
 SetParamsTo(Params);
end;

procedure TMiceBarValuePicker.SetParamsTo(Params: TxParams);
begin
 TMiceBalloons.ShowBalloon('Failed',Format('SetParamsTo not implemented in %s', [Self.ClassName]),0);
end;

procedure TMiceBarValuePicker.LoadState(Params: TxParams);
begin

end;

initialization
//  dxBarRegisterItem(TMiceBarDateEdit, TcxBarEditItem, True );

end.

