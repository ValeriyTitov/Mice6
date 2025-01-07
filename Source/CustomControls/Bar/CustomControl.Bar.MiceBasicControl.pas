unit CustomControl.Bar.MiceBasicControl;

interface
uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  dxBar, cxClasses, cxButtonEdit, cxImage, cxCheckBox, cxCalendar, cxBarEditItem, Data.DB,
  Vcl.Forms,
  CustomControl.Interfaces,
  CustomControl.AppObject,
  Common.ResourceStrings,
  DAC.XParams,
  Plugin.Base;

type
 TMiceBasicBarControl = class(TcxBarEditItem)
  private
    FLoading:Boolean;
    FPlugin: TBasePlugin;
    FAutoRefresh: Boolean;
    FParamName2: string;
    FParamName: string;
    FAppObject:TMiceAppObject;
    procedure TryInitAppObject(const Json:string);
  protected
    procedure Change; override;
    procedure DoRefresh;
    property AppObject:TMiceAppObject read FAppObject;
  public
    property Loading:Boolean read FLoading write FLoading;
    property AutoRefresh:Boolean read FAutoRefresh write FAutoRefresh;
    property Plugin:TBasePlugin read FPlugin write FPlugin;
    property ParamName:string read FParamName write FParamName;
    property ParamName2:string read FParamName2 write FParamName2;

    procedure LoadFromDataSet(DataSet: TDataSet); virtual;
    constructor Create(AOwner:TComponent); override;
    destructor Destroy; override;
 end;


implementation

{ TMiceBarDateEdit }

procedure TMiceBasicBarControl.Change;
begin
  inherited;
  if (not Loading) then
   DoRefresh;
end;

constructor TMiceBasicBarControl.Create(AOwner: TComponent);
begin
  inherited;
  FAppObject:=TMiceAppObject.Create;
  FLoading:=True;
  FAutoRefresh:=True;
  Align:=TdxBarItemAlign.iaClient;
end;


destructor TMiceBasicBarControl.Destroy;
begin
  FAppObject.Free;
  inherited;
end;


procedure TMiceBasicBarControl.DoRefresh;
begin
if (Assigned(Plugin)) and (AutoRefresh) then
  Plugin.RefreshDataSet;
end;

procedure TMiceBasicBarControl.LoadFromDataSet(DataSet: TDataSet);
begin
  if (DataSet.FieldByName('InitString').IsNull=False) then
    TryInitAppObject(DataSet.FieldByName('InitString').AsString);

  if DataSet.FieldByName('ShowCaption').AsBoolean then
     PaintStyle:=psCaptionGlyph;

  ImageIndex:=DataSet.FieldByName('ImageIndex').AsInteger;
  Width:=DataSet.FieldByName('Width').AsInteger;
  AutoRefresh:=DataSet.FieldByName('AutoRefresh').AsBoolean;
  ParamName:=DataSet.FieldByName('ParamName').AsString;
  ParamName2:=DataSet.FieldByName('ParamName2').AsString;


end;


procedure TMiceBasicBarControl.TryInitAppObject(const Json: string);
resourcestring
 S_BAR_ITEM_FAILED_TO_LOAD_FROM_JSON_FMT = 'Class %s failed to load from Json string';
begin
if Json.Trim<>'' then
 try
  AppObject.AsJson:=Json;
 except
  MessageBox(Application.Handle,PChar(string.Format(S_BAR_ITEM_FAILED_TO_LOAD_FROM_JSON_FMT, [ClassName])),PChar(S_COMMON_ERROR), MB_OK+MB_ICONERROR);
 end;
end;

end.

