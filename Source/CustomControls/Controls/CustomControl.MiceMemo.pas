unit CustomControl.MiceMemo;

interface
uses SysUtils, Windows, Messages, Classes, Controls, StdCtrls, cxTextEdit,
     cxDBEdit, ExtCtrls, cxEdit,Data.DB,
     Common.LookAndFeel,
     CustomControl.Interfaces;

type
 TMiceMemo = class(TcxDBMemo, IHaveDataBinding)
 private
    FAppDialogControlsId:Integer;
    function GetIDataSource:TDataSource;
    function GetIDataField:string;
    procedure SetIDataSource(const Value:TDataSource);
    procedure SetIDataField(const Value:string);
    function GetAppDialogControlsId: Integer;
    procedure SetAppDialogControlsId(const Value: Integer);
 public
    class function DevDescription:string;
    property AppDialogControlsId: Integer read GetAppDialogControlsId write SetAppDialogControlsId;
    constructor Create(AOwner:TComponent); override;
 end;

implementation

{ TMiceMemo }

constructor TMiceMemo.Create(AOwner: TComponent);
begin
  inherited;
  if DefaultLookAndFeel.Theme<>TMiceColorTheme.mctWhiteTheme then
   Self.Color:=DefaultLookAndFeel.ControlColor;
end;

class function TMiceMemo.DevDescription: string;
resourcestring
 S_DevDescription_TMiceMemo = 'Control which allows user to edit large amount of text.';
begin
 Result:= S_DevDescription_TMiceMemo;
end;

function TMiceMemo.GetAppDialogControlsId: Integer;
begin
 Result:=FAppDialogControlsId;
end;

function TMiceMemo.GetIDataField: string;
begin
 Result:=DataBinding.DataField;
end;

function TMiceMemo.GetIDataSource: TDataSource;
begin
 Result:=DataBinding.DataSource;
end;

procedure TMiceMemo.SetAppDialogControlsId(const Value: Integer);
begin
 FAppDialogControlsId:=Value;
end;

procedure TMiceMemo.SetIDataField(const Value: string);
begin
 DataBinding.DataField:=Value;
end;

procedure TMiceMemo.SetIDataSource(const Value: TDataSource);
begin
 DataBinding.DataSource:=Value;
end;

end.
