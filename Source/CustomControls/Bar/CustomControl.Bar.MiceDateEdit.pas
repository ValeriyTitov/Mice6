unit CustomControl.Bar.MiceDateEdit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  dxBar, cxClasses, cxButtonEdit, cxImage, cxCheckBox, cxCalendar, cxBarEditItem, Data.DB,
  CustomControl.Interfaces,
  CustomControl.Bar.MiceBasicControl,
  DAC.XParams,
  Plugin.Base;

type
 TMiceBarDateEdit = class(TMiceBasicBarControl, ICanManageParams, ICanSaveLoadState)
  private
    FProperties:TcxDateEditProperties;
    function GetDate: TDateTime;
    procedure SetDate(const Value: TDateTime);
    procedure SetParamsTo(Params:TxParams);
    procedure LoadState(Params:TxParams);
    procedure SaveState(Params:TxParams);
  public
    property Date:TDateTime read GetDate write SetDate;
    constructor Create(AOwner:TComponent); override;
    destructor Destroy; override;
    class function CreateDefault(Owner:TBasePlugin;  DataSet: TDataSet): TMiceBarDateEdit;

 end;

implementation

{ TMiceBarDateEdit }


constructor TMiceBarDateEdit.Create(AOwner: TComponent);
begin
  inherited;
  Loading:=True;
  PropertiesClass:=TcxDateEditProperties;
  FProperties:=(Properties as TcxDateEditProperties);
  FProperties.ShowTime:=False;
  FProperties.SaveTime:=False;
  FProperties.DateButtons:=[];
  Date:=TDate(Now);
  Loading:=False;
end;


class function TMiceBarDateEdit.CreateDefault(Owner: TBasePlugin; DataSet: TDataSet): TMiceBarDateEdit;
begin
 Result:=TMiceBarDateEdit.Create(Owner.Container.Tab);
 Result.Plugin:=Owner;
 Result.LoadFromDataSet(DataSet);
end;

destructor TMiceBarDateEdit.Destroy;
begin
  inherited;
end;

function TMiceBarDateEdit.GetDate: TDateTime;
begin
 Result:=EditValue;
end;

procedure TMiceBarDateEdit.SaveState(Params: TxParams);
begin
 SetParamsTo(Params);
end;

procedure TMiceBarDateEdit.SetDate(const Value: TDateTime);
begin
 EditValue:=Value;
end;


procedure TMiceBarDateEdit.SetParamsTo(Params: TxParams);
begin
 Params.SetParameter(ParamName, Date);
end;


procedure TMiceBarDateEdit.LoadState(Params: TxParams);
begin
 Loading:=True;
 try
  EditValue:=Params.AsDateDef(ParamName, Self.GetDate)
 finally
   Loading:=False;
 end;
end;

initialization
//  dxBarRegisterItem(TMiceBarDateEdit, TcxBarEditItem, True );

end.

