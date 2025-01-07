unit CustomControl.Bar.MiceOptionBox;


interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  dxBar, cxClasses, cxButtonEdit, cxImage, cxCheckBox, cxCalendar, cxBarEditItem, Data.DB,
  CustomControl.Interfaces,
  DAC.XParams,
  Plugin.Base,
  CustomControl.MiceBalloons;


type
 TMiceBarOptionBox = class(TcxBarEditItem, ICanManageParams, ICanSaveLoadState)
  private
    FPlugin: TBasePlugin;
    FAutoRefresh: Boolean;
    procedure SetParamsTo(Params:TxParams);
    procedure LoadState(Params:TxParams);
    procedure SaveState(Params:TxParams);
  public
    class function CreateDefault(AOwner:TBasePlugin; DataSet:TDataSet):TMiceBarOptionBox;
    constructor Create(AOwner:TComponent); override;
    destructor Destroy; override;

    procedure LoadFromDataSet(DataSet:TDataSet);

    property AutoRefresh:Boolean read FAutoRefresh write FAutoRefresh;
    property Plugin:TBasePlugin read FPlugin write FPlugin;
 end;

implementation

{ TMiceBarDateEdit }

constructor TMiceBarOptionBox.Create(AOwner: TComponent);
begin
  inherited;
  EditValue:=ClassName;
end;

class function TMiceBarOptionBox.CreateDefault(AOwner: TBasePlugin;  DataSet: TDataSet): TMiceBarOptionBox;
begin
 Result:=TMiceBarOptionBox.Create(AOwner);
 Result.Plugin:=AOwner;
 Result.LoadFromDataSet(DataSet);
end;

destructor TMiceBarOptionBox.Destroy;
begin

  inherited;
end;


procedure TMiceBarOptionBox.LoadFromDataSet(DataSet: TDataSet);
begin
  if DataSet.FieldByName('ShowCaption').AsBoolean then
   PaintStyle:=psCaptionGlyph;
end;


procedure TMiceBarOptionBox.SaveState(Params: TxParams);
begin
 SetParamsTo(Params);
end;

procedure TMiceBarOptionBox.SetParamsTo(Params: TxParams);
begin
 TMiceBalloons.ShowBalloon('Failed',Format('SetParamsTo not implemented in %s', [Self.ClassName]),0);
end;

procedure TMiceBarOptionBox.LoadState(Params: TxParams);
begin

end;

initialization
//  dxBarRegisterItem(TMiceBarDateEdit, TcxBarEditItem, True );

end.

