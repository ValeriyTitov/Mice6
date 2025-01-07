unit CustomControl.MiceCheckBox;

interface

uses SysUtils, Windows, Messages, Classes, Controls, StdCtrls, cxTextEdit,
     cxDBEdit, ExtCtrls, cxEdit,Data.DB,
     Mice.Script,
     CustomControl.Interfaces;


type
  TMiceCheckBox = class(TcxDBCheckBox, IHaveDataBinding, IHaveScriptSupport)
  private
    FScript:TMiceScripter;
    FAppDialogControlsId:Integer;
    procedure CallScript;
    function GetIDataSource:TDataSource;
    function GetIDataField:string;
    procedure SetIDataSource(const Value:TDataSource);
    procedure SetIDataField(const Value:string);
    function GetAppDialogControlsId: Integer;
    procedure SetAppDialogControlsId(const Value: Integer);
  public
    property AppDialogControlsId: Integer read GetAppDialogControlsId write SetAppDialogControlsId;
    procedure RegisterScripter(Scripter:TMiceScripter);
    class function DevDescription:string;
    procedure Click; override;
 end;

implementation

{ TMiceCheckBox }

procedure TMiceCheckBox.CallScript;
begin
 if Assigned(FScript) then
  FScript.CallOnClick(Self);
end;

procedure TMiceCheckBox.Click;
begin
  inherited;
  CallScript;
end;

class function TMiceCheckBox.DevDescription: string;
resourcestring
 S_DevDescription_TMiceCheckBox = 'Check box with Check, Unchecked and Grayed(NULL) status. Usually used for a boolean fields';
begin
 Result:= S_DevDescription_TMiceCheckBox;
end;

function TMiceCheckBox.GetAppDialogControlsId: Integer;
begin
 Result:=FAppDialogControlsId;
end;

function TMiceCheckBox.GetIDataField: string;
begin
 Result:=DataBinding.DataField;
end;

function TMiceCheckBox.GetIDataSource: TDataSource;
begin
 Result:=DataBinding.DataSource;
end;

procedure TMiceCheckBox.RegisterScripter(Scripter: TMiceScripter);
begin
 FScript:=Scripter;
end;

procedure TMiceCheckBox.SetAppDialogControlsId(const Value: Integer);
begin
 FAppDialogControlsId:=Value;
end;

procedure TMiceCheckBox.SetIDataField(const Value: string);
begin
 DataBinding.DataField:=Value;
end;

procedure TMiceCheckBox.SetIDataSource(const Value: TDataSource);
begin
 DataBinding.DataSource:=Value;
end;

end.
