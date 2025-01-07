unit CustomControl.Bar.MiceTextEdit;


interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  dxBar, cxClasses, cxBarEditItem, Data.DB,Vcl.ExtCtrls, cxTextEdit,
  CustomControl.Interfaces, Dialogs,
  CustomControl.Bar.MiceBasicControl,
  DAC.XParams,
  Plugin.Base;

type
 TMiceBarTextEdit = class(TMiceBasicBarControl,ICanManageParams, ICanSaveLoadState)
  private
    FProperties:TcxTextEditProperties;
    FTimer:TTimer;
    FTicks:Int64;
    FChangeInterval: Integer;
    procedure HandleTimer(Sender:TObject);
    procedure HandleEditChange(Sender:TObject);
    procedure SetChangeInterval(const Value: Integer);
    procedure SetParamsTo(Params:TxParams);
    procedure LoadState(Params:TxParams);
    procedure SaveState(Params:TxParams);
  public
    class function CreateDefault(AOwner:TBasePlugin; DataSet:TDataSet):TMiceBarTextEdit;
    constructor Create(AOwner:TComponent); override;
    destructor Destroy; override;

    procedure LoadFromDataSet(DataSet:TDataSet); override;
    property ChangeInterval:Integer read FChangeInterval write SetChangeInterval;

 end;

implementation

{ TMiceBarDateEdit }

constructor TMiceBarTextEdit.Create(AOwner: TComponent);
begin
  inherited;
  FTimer:=TTimer.Create(Self);
  FTimer.Enabled:=False;
  FTimer.OnTimer:=HandleTimer;
  ChangeInterval:=600;
  PropertiesClass:= TcxTextEditProperties;
  FProperties:= Properties as TcxTextEditProperties;
  FProperties.OnChange:=HandleEditChange;
end;

class function TMiceBarTextEdit.CreateDefault(AOwner: TBasePlugin;  DataSet: TDataSet): TMiceBarTextEdit;
begin
 Result:=TMiceBarTextEdit.Create(AOwner);
 Result.Plugin:=AOwner;
 Result.LoadFromDataSet(DataSet);
end;

destructor TMiceBarTextEdit.Destroy;
begin
  inherited;
end;

procedure TMiceBarTextEdit.HandleEditChange(Sender: TObject);
begin
 FTicks:=GetTickCount;
 FTimer.Enabled:=AutoRefresh and not Loading;
end;

procedure TMiceBarTextEdit.HandleTimer(Sender: TObject);
begin
 if (FTicks+ChangeInterval)<GetTickCount then
  begin
//   ShowMessage('Self.EditValue');
   FTimer.Enabled:=False;
   Self.EditValue:=Self.CurEditValue;
  end;
end;

procedure TMiceBarTextEdit.LoadFromDataSet(DataSet: TDataSet);
begin
 inherited;

end;

procedure TMiceBarTextEdit.SaveState(Params: TxParams);
begin
 SetParamsTo(Params);
end;

procedure TMiceBarTextEdit.SetChangeInterval(const Value: Integer);
begin
  FChangeInterval := Value;
  FTimer.Interval:=Value div 3;
end;

procedure TMiceBarTextEdit.SetParamsTo(Params: TxParams);
begin
 if VarToStr(EditValue)='' then
  Params.SetParameter(ParamName, Null)
   else
  Params.SetParameter(ParamName, Self.EditValue);
end;

procedure TMiceBarTextEdit.LoadState(Params: TxParams);
begin
 Loading:=True;
  try
   EditValue:=Params.ParamByNameDef(ParamName, Self.EditValue);
  finally
   Loading:=False;
 end;
end;

initialization
//  dxBarRegisterItem(TMiceBarDateEdit, TcxBarEditItem, True );

end.

