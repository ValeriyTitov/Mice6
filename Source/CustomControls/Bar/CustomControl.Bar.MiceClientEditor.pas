unit CustomControl.Bar.MiceClientEditor;


interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  dxBar, cxClasses, cxButtonEdit, cxImage, cxCheckBox, cxCalendar, cxBarEditItem, Data.DB,
  CustomControl.Interfaces,
  DAC.XParams,
  Plugin.Base,
  CustomControl.MiceBalloons;


type
 TMiceBarClientEditor = class(TcxBarEditItem, ICanManageParams,ICanSaveLoadState)
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
    class function CreateDefault(AOwner: TBasePlugin; DataSet:TDataSet):TMiceBarClientEditor;

    property AutoRefresh:Boolean read FAutoRefresh write FAutoRefresh;
    property Plugin:TBasePlugin read FPlugin write FPlugin;
 end;

implementation

{ TMiceBarDateEdit }

constructor TMiceBarClientEditor.Create(AOwner: TComponent);
begin
  inherited;
  EditValue:=Self.ClassName;
end;

class function TMiceBarClientEditor.CreateDefault(AOwner:  TBasePlugin;  DataSet: TDataSet): TMiceBarClientEditor;
begin
 Result:=TMiceBarClientEditor.Create(AOwner);
 Result.Plugin:=AOwner;
 Result.LoadFromDataSet(DataSet);
end;

destructor TMiceBarClientEditor.Destroy;
begin

  inherited;
end;


procedure TMiceBarClientEditor.LoadFromDataSet(DataSet: TDataSet);
begin
  if DataSet.FieldByName('ShowCaption').AsBoolean then
   PaintStyle:=psCaptionGlyph;
end;


procedure TMiceBarClientEditor.SaveState(Params: TxParams);
begin
 SetParamsTo(Params);
end;

procedure TMiceBarClientEditor.SetParamsTo(Params: TxParams);
begin
 TMiceBalloons.ShowBalloon('Failed',Format('SetParamsTo not implemented in %s', [Self.ClassName]),0);
end;

procedure TMiceBarClientEditor.LoadState(Params: TxParams);
begin

end;

initialization
//  dxBarRegisterItem(TMiceBarDateEdit, TcxBarEditItem, True );

end.

