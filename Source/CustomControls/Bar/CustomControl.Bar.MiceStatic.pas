unit CustomControl.Bar.MiceStatic;


interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  dxBar, cxClasses, cxButtonEdit, cxImage, cxCheckBox, cxCalendar, cxBarEditItem, Data.DB,
  CustomControl.Interfaces,
  DAC.XParams,
  Plugin.Base,
  CustomControl.MiceBalloons;


type
 TMiceBarStatic = class(TcxBarEditItem, ICanManageParams, ICanSaveLoadState)
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
    class function CreateDefault(AOwner:TBasePlugin; DataSet:TDataSet):TMiceBarStatic;


    property AutoRefresh:Boolean read FAutoRefresh write FAutoRefresh;
    property Plugin:TBasePlugin read FPlugin write FPlugin;
 end;

implementation

{ TMiceBarDateEdit }

constructor TMiceBarStatic.Create(AOwner: TComponent);
begin
  inherited;
  EditValue:=ClassName;
end;

class function TMiceBarStatic.CreateDefault(AOwner: TBasePlugin;  DataSet: TDataSet): TMiceBarStatic;
begin
 Result:=TMiceBarStatic.Create(AOwner);
 Result.Plugin:=AOwner;
 Result.LoadFromDataSet(DataSet);
end;

destructor TMiceBarStatic.Destroy;
begin

  inherited;
end;


procedure TMiceBarStatic.LoadFromDataSet(DataSet: TDataSet);
begin
  if DataSet.FieldByName('ShowCaption').AsBoolean then
   PaintStyle:=psCaptionGlyph;
end;


procedure TMiceBarStatic.SaveState(Params: TxParams);
begin
 SetParamsTo(Params);
end;

procedure TMiceBarStatic.SetParamsTo(Params: TxParams);
begin
 TMiceBalloons.ShowBalloon('Failed',Format('SetParamsTo not implemented in %s', [Self.ClassName]),0);
end;

procedure TMiceBarStatic.LoadState(Params: TxParams);
begin

end;

initialization
//  dxBarRegisterItem(TMiceBarDateEdit, TcxBarEditItem, True );

end.

