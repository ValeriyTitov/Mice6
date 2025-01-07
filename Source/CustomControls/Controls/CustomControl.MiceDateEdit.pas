unit CustomControl.MiceDateEdit;

interface

uses SysUtils, Windows, Messages, Classes, Controls, StdCtrls, cxTextEdit,
     cxDBEdit, ExtCtrls, cxEdit,Data.DB, cxCalendar,
     Mice.Script,
     DAC.XParams,
     Common.LookAndFeel,
     Common.ResourceStrings,
     CustomControl.Interfaces,
     CustomControl.AppObject;


type
  TMiceDateEdit = class(TcxDBDateEdit, IHaveDataBinding, IHaveScriptSupport, ICanInitFromJson)
  private
    FScript:TMiceScripter;
    FAppDialogControlsId:Integer;
    function GetIDataSource:TDataSource;
    function GetIDataField:string;
    procedure SetIDataSource(const Value:TDataSource);
    procedure SetIDataField(const Value:string);
    procedure RegisterScripter(Scripter:TMiceScripter);
    procedure InitFromJson(const Json:string);
    procedure InitFromParams(Params:TxParams);
    function GetAppDialogControlsId: Integer;
    procedure SetAppDialogControlsId(const Value: Integer);
  protected
    procedure DoChange; override;
  public
    property AppDialogControlsId: Integer read GetAppDialogControlsId write SetAppDialogControlsId;
    class function FindProperCaption(const DataField: string): string;
    class function DevDescription:string;
    constructor Create(AOwner:TComponent); override;
  end;

implementation

{ TMiceDateEdit }

constructor TMiceDateEdit.Create(AOwner: TComponent);
begin
  inherited;
  Self.Properties.DateButtons:=[];
  Self.Properties.ShowTime:=False;
  Self.Properties.SaveTime:=False;
  if DefaultLookAndFeel.Theme<>TMiceColorTheme.mctWhiteTheme then
   Self.Color:=DefaultLookAndFeel.ControlColor;
end;

class function TMiceDateEdit.DevDescription: string;
resourcestring
 S_DevDescription_TMiceDateEdit = 'Control which allows user to edit Date or DateTime fields.';
begin
 Result:= S_DevDescription_TMiceDateEdit;
end;

procedure TMiceDateEdit.DoChange;
begin
  inherited;
  if Assigned(FScript) then
   FScript.CallOnChange(Self);
end;

class function TMiceDateEdit.FindProperCaption(const DataField: string): string;
var
 AName:string;
begin
 AName:=AnsiLowerCase(DataField);
 if (Pos(AName,'begin')>0) or (Pos(AName,'start')>0) or (Pos(AName,'datebeg')>0) then
  Result:=S_COMMON_START_PERIOD else
 if (Pos(AName,'end')>0) then
  Result:=S_COMMON_END_PERIOD else
 if (Pos(AName,'prev')>0) then
  Result:=S_COMMON_PREVIOUS_DATE else
 if (Pos(AName,'cur')>0) then
  Result:=S_COMMON_CURRENT_DATE else
 if (Pos(AName,'date')>0) then
  Result:=S_COMMON_DATE else
  Result:=DataField;
end;

function TMiceDateEdit.GetAppDialogControlsId: Integer;
begin
 Result:=FAppDialogControlsId;
end;

function TMiceDateEdit.GetIDataField: string;
begin
  Result:=DataBinding.DataField;
end;

function TMiceDateEdit.GetIDataSource: TDataSource;
begin
  Result:=DataBinding.DataSource;
end;

procedure TMiceDateEdit.InitFromJson(const Json: string);
var
 App:TMiceAppObject;
begin
 App:=TMiceAppObject.Create;
 try
  App.AsJson:=Json;
  InitFromParams(App.Params);
 finally
  App.Free;
 end;
end;

procedure TMiceDateEdit.InitFromParams(Params: TxParams);
var
 ShowClearButton:Boolean;
 ShowTodayButton:Boolean;
begin
 Properties.ShowTime:=Params.ParamByNameDef('ShowTime', False);
 Properties.SaveTime:=Params.ParamByNameDef('SaveTime', False);
 ShowClearButton:=Params.ParamByNameDef('ShowClearButton', False);
 if ShowClearButton then
   Properties.DateButtons:=[btnClear];

 ShowTodayButton:=Params.ParamByNameDef('ShowTodayButton', False);
 if ShowTodayButton then
   Properties.DateButtons:=Properties.DateButtons+[btnToday];
end;

procedure TMiceDateEdit.RegisterScripter(Scripter: TMiceScripter);
begin
 FScript:=Scripter;
end;

procedure TMiceDateEdit.SetAppDialogControlsId(const Value: Integer);
begin
 FAppDialogControlsId:=Value;
end;

procedure TMiceDateEdit.SetIDataField(const Value: string);
begin
 DataBinding.DataField:=Value;
end;

procedure TMiceDateEdit.SetIDataSource(const Value: TDataSource);
begin
 DataBinding.DataSource:=Value;
end;


initialization
 TMiceScripter.RegisterClassEventOnClick(TMiceDateEdit.ClassName);
 TMiceScripter.RegisterClassEventOnChange(TMiceDateEdit.ClassName);

end.
