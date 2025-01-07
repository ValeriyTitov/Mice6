unit CustomControl.Bar.MiceSubAccountEditor;


interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  dxBar, cxClasses, cxButtonEdit, cxImage, cxCheckBox, cxCalendar, cxBarEditItem, Data.DB,
  cxTextEdit,
  CustomControl.Interfaces,
  CustomControl.MiceBalloons,
  DAC.XParams,
  Plugin.Base;

type
 TMiceBarSubAccountEditor = class(TcxBarEditItem, ICanManageParams, ICanSaveLoadState)
  private
    FPlugin: TBasePlugin;
    FAutoRefresh: Boolean;
    procedure SaveState(Params:TxParams);
    procedure SetParamsTo(Params:TxParams);
    procedure LoadState(Params:TxParams);
  public
    procedure LoadFromDataSet(DataSet:TDataSet);
    constructor Create(AOwner:TComponent); override;
    destructor Destroy; override;
    class function CreateDefault(AOwner:TBasePlugin; DataSet:TDataSet):TMiceBarSubAccountEditor;

    property AutoRefresh:Boolean read FAutoRefresh write FAutoRefresh;
    property Plugin:TBasePlugin read FPlugin write FPlugin;
 end;

implementation

{ TMiceBarDateEdit }

constructor TMiceBarSubAccountEditor.Create(AOwner: TComponent);
begin
  inherited;
  PropertiesClass:=TcxTextEditProperties;
  EditValue:='40817810100009590888';
  Width:=300;
end;

class function TMiceBarSubAccountEditor.CreateDefault(AOwner: TBasePlugin;  DataSet: TDataSet): TMiceBarSubAccountEditor;
begin
 Result:=TMiceBarSubAccountEditor.Create(AOwner);
 Result.Plugin:=AOwner;
 Result.LoadFromDataSet(DataSet);
end;

destructor TMiceBarSubAccountEditor.Destroy;
begin

  inherited;
end;


procedure TMiceBarSubAccountEditor.LoadFromDataSet(DataSet: TDataSet);
begin
  if DataSet.FieldByName('ShowCaption').AsBoolean then
   PaintStyle:=psCaptionGlyph;

  case DataSet.FieldByName('CommandType').AsInteger of
   9,10:EditValue:='<Replaced by '+ClassName+'>';
  end;
end;


procedure TMiceBarSubAccountEditor.SaveState(Params: TxParams);
begin
 SetParamsTo(Params);
end;

procedure TMiceBarSubAccountEditor.SetParamsTo(Params: TxParams);
begin
 TMiceBalloons.ShowBalloon('', format('SetParamsTo not implemented in %s', [Self.ClassName]),10);
end;

procedure TMiceBarSubAccountEditor.LoadState(Params: TxParams);
begin

end;

initialization
//  dxBarRegisterItem(TMiceBarDateEdit, TcxBarEditItem, True );

end.

