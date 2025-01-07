unit CustomControl.Bar.MiceDropDown;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  dxBar, cxClasses, cxButtonEdit, cxImage, cxCheckBox, cxCalendar, cxBarEditItem, Data.DB,
  cxImageComboBox,
  Common.Images,
  CustomControl.Bar.MiceBasicControl,
  CustomControl.Interfaces,
  CustomControl.MiceDropDown.Builder,
  DAC.XParams,
  Plugin.Base;

type
 TMiceBarDropDown = class(TMiceBasicBarControl, ICanManageParams, ICanSaveLoadState)
  private
    FProperties:TcxImageComboBoxProperties;
    procedure SetParamsTo(Params:TxParams);
    procedure LoadState(Params:TxParams);
    procedure SaveState(Params:TxParams);

  public
    procedure LoadItems;
    constructor Create(AOwner:TComponent); override;
    destructor Destroy; override;
    class function CreateDefault(Owner:TBasePlugin; DataSet:TDataSet):TMiceBarDropDown;
 end;

implementation

{ TMiceBarDateEdit }


constructor TMiceBarDropDown.Create(AOwner: TComponent);
begin
  inherited;
  PropertiesClass:=TcxImageComboBoxProperties;
  FProperties:=Properties as TcxImageComboBoxProperties;
  FProperties.Images:=ImageContainer.Images16;
  FProperties.ImmediateDropDownWhenActivated:=True;
end;

class function TMiceBarDropDown.CreateDefault(Owner:TBasePlugin; DataSet: TDataSet): TMiceBarDropDown;
begin
 Result:=TMiceBarDropDown.Create(Owner);
 Result.Plugin:=Owner;
 Result.LoadFromDataSet(DataSet);
 Result.LoadItems;
 Result.Loading:=False;
end;

destructor TMiceBarDropDown.Destroy;
begin
  inherited;
end;



procedure TMiceBarDropDown.LoadItems;
var
 Builder:TMiceDropDownBuilder;
begin
 Builder:=TMiceDropDownBuilder.Create;
 try
  Builder.Items:=FProperties.Items;
  Builder.DataSet.Source:='TMiceBarDropDown.LoadItems';
  Builder.LoadFromAppObject(AppObject);
  if FProperties.Items.Count>0 then
   EditValue:=FProperties.Items[0].Value;

 finally
  Builder.Free;
 end;

end;

procedure TMiceBarDropDown.SaveState(Params: TxParams);
begin
 SetParamsTo(Params);
end;

procedure TMiceBarDropDown.SetParamsTo(Params: TxParams);
begin
 Params.SetParameter(ParamName,EditValue);
end;

procedure TMiceBarDropDown.LoadState(Params: TxParams);
var
 AValue:Variant;
begin
Loading:=True;
 try
  if FProperties.Items.Count>0 then
   AValue:=FProperties.Items[0].Value
    else
   AValue:=NULL;

  EditValue:=Params.ParamByNameDef(ParamName,AValue);
 finally
  Self.Loading:=False;
 end;

end;

initialization
//  dxBarRegisterItem(TMiceBarDateEdit, TcxBarEditItem, True );

end.

