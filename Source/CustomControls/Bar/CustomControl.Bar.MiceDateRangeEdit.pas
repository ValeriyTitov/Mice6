unit CustomControl.Bar.MiceDateRangeEdit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  dxBar, cxClasses, cxButtonEdit, cxImage, cxCheckBox, cxCalendar, cxBarEditItem, Data.DB,
  Vcl.ExtCtrls, dxBarExtItems,
  CustomControl.MiceDateRangeEdit,
  CustomControl.Interfaces,
  DAC.XParams,
  DAC.XParams.Utils,
  Plugin.Base;

type
 TMiceBarDateRangeEdit = class(TdxBarControlContainerItem, ICanManageParams, ICanSaveLoadState)
  private
    FPlugin: TBasePlugin;
    FAutoRefresh: Boolean;
    FParamName2: string;
    FParamName: string;
    FLoading: Boolean;
    FControl:TMiceDateRangeControl;
    procedure SetParamsTo(Params:TxParams);
    procedure LoadState(Params:TxParams);
    procedure SaveState(Params:TxParams);
  protected
    procedure CaptionChanged; override;
    procedure HandleChange(Sender:TObject);
  public
    procedure LoadFromDataSet(DataSet:TDataSet);

    property Loading:Boolean read FLoading write FLoading;
    property AutoRefresh:Boolean read FAutoRefresh write FAutoRefresh;
    property Plugin:TBasePlugin read FPlugin write FPlugin;
    property ParamName:string read FParamName write FParamName;
    property ParamName2:string read FParamName2 write FParamName2;

    constructor Create(AOwner:TComponent); override;
    destructor Destroy; override;
    class function CreateDefault(AOwner:TBasePlugin; DataSet:TDataSet):TMiceBarDateRangeEdit;
 end;

implementation

{ TMiceBarDateEdit }

procedure TMiceBarDateRangeEdit.CaptionChanged;
begin
  inherited;
  Self.FControl.Caption:=Self.Caption;
end;

constructor TMiceBarDateRangeEdit.Create(AOwner: TComponent);
begin
  inherited;
  FControl:=TMiceDateRangeControl.Create(Self);
  FControl.OnChange:=HandleChange;
  Control:=FControl;
  Align:=TdxBarItemAlign.iaClient;
end;

class function TMiceBarDateRangeEdit.CreateDefault(AOwner: TBasePlugin;  DataSet: TDataSet): TMiceBarDateRangeEdit;
begin
 Result:=TMiceBarDateRangeEdit.Create(AOwner);
 Result.Plugin:=AOwner;
 Result.LoadFromDataSet(DataSet);
end;

destructor TMiceBarDateRangeEdit.Destroy;
begin
  inherited;
end;


procedure TMiceBarDateRangeEdit.HandleChange(Sender: TObject);
begin
if (Assigned(Plugin)) and (AutoRefresh) then
  Plugin.RefreshDataSet;
end;

procedure TMiceBarDateRangeEdit.LoadFromDataSet(DataSet: TDataSet);
begin
  if DataSet.FieldByName('ShowCaption').AsBoolean then
   PaintStyle:=psCaptionGlyph;

  ImageIndex:=DataSet.FieldByName('ImageIndex').AsInteger;
  Width:=DataSet.FieldByName('Width').AsInteger;
  AutoRefresh:=DataSet.FieldByName('AutoRefresh').AsBoolean;
  ParamName:=DataSet.FieldByName('ParamName').AsString;
  ParamName2:=DataSet.FieldByName('ParamName2').AsString;

end;


procedure TMiceBarDateRangeEdit.SaveState(Params: TxParams);
begin
 SetParamsTo(Params);
end;

procedure TMiceBarDateRangeEdit.SetParamsTo(Params: TxParams);
begin
 Params.SetParameter(ParamName, FControl.StartDate);
 Params.SetParameter(ParamName2, FControl.EndDate);
end;


procedure TMiceBarDateRangeEdit.LoadState(Params: TxParams);
begin
 FControl.OnChange:=nil;
 try
    FControl.StartDate:=Params.AsDateTimeDef(ParamName,FControl.StartDate);
    FControl.EndDate:=Params.AsDateTimeDef(ParamName2,FControl.EndDate)
 finally
   FControl.OnChange:=HandleChange;
 end;
end;

initialization
  dxBarRegisterItem(TMiceBarDateRangeEdit, TdxBarControlContainerControl, True );

end.
