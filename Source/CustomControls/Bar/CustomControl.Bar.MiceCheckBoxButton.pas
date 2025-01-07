unit CustomControl.Bar.MiceCheckBoxButton;

{
   CreateDefault может создать 3 разных контрола в зависимости от стиля.
   0:TMiceBarLargeButton (В режиме залипания)
   1:TMiceBarButton (В режиме залипания)
   else
    TMiceBarCheckBoxButton (В режиме галочки)
}
interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  dxBar, cxClasses, cxButtonEdit, cxImage, cxCheckBox, cxCalendar, cxBarEditItem, Data.DB,
  CustomControl.Interfaces,
  CustomControl.Bar.MiceBasicControl,
  CustomControl.AppObject,
  CustomControl.Bar.MiceButton,
  CustomControl.Bar.MiceLargeButton,
  DAC.XParams,
  Plugin.Base;

type
 TMiceBarCheckBoxButton = class(TMiceBasicBarControl, ICanManageParams, ICanSaveLoadState)
  private
    FProperties:TcxCheckBoxProperties;
    procedure DoOnClick(Sender:TObject);
    procedure SetParamsTo(Params:TxParams);
    procedure LoadState(Params:TxParams);
    procedure SaveState(Params:TxParams);
  public
    constructor Create(AOwner:TComponent); override;
    destructor Destroy; override;
    class function CreateCheckBox(Owner:TBasePlugin;  DataSet: TDataSet): TMiceBarCheckBoxButton;
    class function CreateDefault(Owner:TBasePlugin;  DataSet: TDataSet): TdxBarItem;
    class function FindStyle(const Json:string):Integer;
 end;

implementation

{ TMiceBarDateEdit }


constructor TMiceBarCheckBoxButton.Create(AOwner: TComponent);
begin
  inherited;
  PropertiesClass:=TcxCheckBoxProperties;
  FProperties:=(Properties as TcxCheckBoxProperties);
  FProperties.AllowGrayed:=False;
  FProperties.ValueChecked:=1;
  FProperties.ValueUnchecked:=0;
  FProperties.ImmediatePost:=True;
  FProperties.OnChange:=DoOnClick;
  OnClick:=DoOnClick;
end;


class function TMiceBarCheckBoxButton.CreateCheckBox(Owner: TBasePlugin; DataSet: TDataSet): TMiceBarCheckBoxButton;
begin
 Result:=TMiceBarCheckBoxButton.Create(Owner.Container.Tab);
 Result.Plugin:=Owner;
 Result.LoadFromDataSet(DataSet);
 Result.FProperties.ValueChecked:=DataSet.FieldByName('SPValue').Value;
 Result.FProperties.ValueUnchecked:=DataSet.FieldByName('SPValue1').Value;
 Result.EditValue:=Result.FProperties.ValueUnchecked;
 Result.Loading:=False;
end;

class function TMiceBarCheckBoxButton.CreateDefault(Owner: TBasePlugin; DataSet: TDataSet): TdxBarItem;
var
 AStyle:Integer;
begin
 AStyle:=FindStyle(DataSet.FieldByName('InitString').AsString);
 case AStyle of
  0:Result:=TMiceBarLargeButton.CreateDefault(Owner, DataSet,bsChecked);
  1:Result:=TMiceBarButton.CreateDefault(Owner, DataSet,bsChecked);
   else
    Result:=CreateCheckBox(Owner,DataSet)
 end;
end;

destructor TMiceBarCheckBoxButton.Destroy;
begin
  inherited;
end;



procedure TMiceBarCheckBoxButton.DoOnClick(Sender: TObject);
begin
 DoRefresh;
end;

class function TMiceBarCheckBoxButton.FindStyle(const Json: string): Integer;
var
 AppObject:TMiceAppObject;
begin
if Json.Trim.IsEmpty then
 Result:=0
  else
   begin
     AppObject:=TMiceAppObject.Create;
     try
       AppObject.AsJson:=Json;
       Result:=AppObject.Properties.Style;
     finally
      AppObject.Free;
     end;
   end;
end;

procedure TMiceBarCheckBoxButton.SaveState(Params: TxParams);
begin
 SetParamsTo(Params);
end;

procedure TMiceBarCheckBoxButton.SetParamsTo(Params: TxParams);
begin
if CurEditValue=FProperties.ValueChecked then
  Params.SetParameter(ParamName, FProperties.ValueChecked)
   else
  Params.SetParameter(ParamName, FProperties.ValueUnchecked)
end;


procedure TMiceBarCheckBoxButton.LoadState(Params: TxParams);
begin

end;

initialization
//  dxBarRegisterItem(TMiceBarDateEdit, TcxBarEditItem, True );

end.

