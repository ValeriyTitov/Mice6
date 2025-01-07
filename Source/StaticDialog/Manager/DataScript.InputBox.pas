unit DataScript.InputBox;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, StaticDialog.MiceInputBox, cxGraphics,
  cxControls, cxLookAndFeels, cxLookAndFeelPainters, cxContainer, cxEdit,
  Vcl.Menus, cxLabel, Vcl.StdCtrls, cxButtons, cxTextEdit, Vcl.ExtCtrls,
  DAC.XDataSet;

type
  TDataScriptInputBox = class(TMiceInputBox)
    lbExitsts: TcxLabel;
    procedure FormCreate(Sender: TObject);
    procedure edTextPropertiesChange(Sender: TObject);
  private
    procedure OnDelayedChangeEvent(Sender:TObject);
    procedure TryEnabledButton(AEnabled:Boolean);
  public
    class function Execute(ImageIndex: Integer;  var s: string; const LabelText:string=''; const Caption: string=''): Boolean; override;
  end;


implementation

{$R *.dfm}

{ TDataScriptInputBox }

procedure TDataScriptInputBox.edTextPropertiesChange(Sender: TObject);
begin
 inherited;
 bnOK.Enabled:=False;
end;

class function TDataScriptInputBox.Execute(ImageIndex: Integer; var s: string;  const LabelText, Caption: string): Boolean;
begin
 Result:=ExecuteAsClass(ImageIndex,s, TDataScriptInputBox, LabelText,Caption);
end;

procedure TDataScriptInputBox.FormCreate(Sender: TObject);
begin
  inherited;
  OnDelayedChange:=OnDelayedChangeEvent;
end;

procedure TDataScriptInputBox.OnDelayedChangeEvent(Sender: TObject);
var
 DataSet:TxDataSet;
begin
 DataSet:=TxDataSet.Create(nil);
 try
  DataSet.ProviderName:='spui_AppFindScript';
  DataSet.SetParameter('Name',Self.edText.Text);
  DataSet.SetParameter('Syntax','C#');
  DataSet.Open;
  Self.TryEnabledButton(DataSet.RecordCount=0);
 finally
  DataSet.Free;
 end;
end;

procedure TDataScriptInputBox.TryEnabledButton(AEnabled: Boolean);
begin
 Self.bnOK.Enabled:=AEnabled;
 Self.lbExitsts.Visible:=not AEnabled;
end;

end.
