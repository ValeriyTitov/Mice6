unit CustomControl.Bar.MiceTreeViewCombo;


interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  dxBar, cxClasses, cxButtonEdit, cxImage, cxCheckBox, cxCalendar, cxBarEditItem,
  Data.DB,dxBarExtItems,
  CustomControl.Interfaces,
  Common.Images,
  DAC.XParams,
  Plugin.Base,
  CustomControl.MiceBalloons;


type
 TMiceBarTreeViewCombo = class(TdxBarTreeViewCombo, ICanManageParams, ICanSaveLoadState)
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
    class function CreateDefault(AOwner:TBasePlugin; DataSet:TDataSet):TMiceBarTreeViewCombo;

    property AutoRefresh:Boolean read FAutoRefresh write FAutoRefresh;
    property Plugin:TBasePlugin read FPlugin write FPlugin;
 end;

implementation

{ TMiceBarDateEdit }

constructor TMiceBarTreeViewCombo.Create(AOwner: TComponent);
begin
  inherited;
  //Text:=ClassName;
end;

class function TMiceBarTreeViewCombo.CreateDefault(AOwner: TBasePlugin;  DataSet: TDataSet): TMiceBarTreeViewCombo;
begin
 Result:=TMiceBarTreeViewCombo.Create(AOwner);
 Result.Plugin:=AOwner;
 Result.LoadFromDataSet(DataSet);
end;

destructor TMiceBarTreeViewCombo.Destroy;
begin

  inherited;
end;


procedure TMiceBarTreeViewCombo.LoadFromDataSet(DataSet: TDataSet);
begin
  if DataSet.FieldByName('ShowCaption').AsBoolean then
   PaintStyle:=psCaptionGlyph;
  Width:=DataSet.FieldByName('Width').AsInteger; //ScaleSize
  ImageIndex:=DataSet.FieldByName('ImageIndex').AsInteger;
  Images:=Common.Images.ImageContainer.Images16;
//RefreshCommand(Result, DataSet.FieldByName('AppCmdId').AsInteger);
//Result.OnChange:=MenuItemClick;
end;



procedure TMiceBarTreeViewCombo.SaveState(Params: TxParams);
begin
 SetParamsTo(Params);
end;

procedure TMiceBarTreeViewCombo.SetParamsTo(Params: TxParams);
begin
 TMiceBalloons.ShowBalloon('Failed',Format('SetParamsTo not implemented in %s', [Self.ClassName]),0);
end;

procedure TMiceBarTreeViewCombo.LoadState(Params: TxParams);
begin

end;

initialization
 dxBarRegisterItem(TMiceBarTreeViewCombo, TdxBarTreeViewComboControl, True );

end.

