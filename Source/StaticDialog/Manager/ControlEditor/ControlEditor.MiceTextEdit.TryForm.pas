unit ControlEditor.MiceTextEdit.TryForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Dialog.Basic, cxGraphics,
  cxLookAndFeels, cxLookAndFeelPainters, Vcl.Menus, Vcl.StdCtrls, cxButtons,
  Vcl.ExtCtrls,
  CustomControl.MiceTextEdit,
  CustomControl.Interfaces,
  DAC.XParams, cxControls, cxContainer, cxEdit, cxTextEdit, cxMaskEdit, cxDBEdit,
  Data.DB, dxmdaset;

type
  TcxDBMaskEdit = class(TMiceTextEdit)
  end;

  TMiceTextEditTryForm = class(TBasicDialog)
    memoInfo: TMemo;
    FEdit: TcxDBMaskEdit;
    DataSource: TDataSource;
    FakeDataSet: TdxMemData;
    FakeDataSetSampleField: TStringField;
    Label1: TLabel;
    Label2: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure bnCancelClick(Sender: TObject);
  public
    procedure Initialize(Params:TxParams);
    class function ExecuteDlg(Params:TxParams):Boolean;
  end;


implementation

{$R *.dfm}

procedure TMiceTextEditTryForm.bnCancelClick(Sender: TObject);
begin
  inherited;
  Close;
end;

class function TMiceTextEditTryForm.ExecuteDlg(Params: TxParams): Boolean;
var
 Dlg:TMiceTextEditTryForm;
begin
 Dlg:=TMiceTextEditTryForm.Create(nil);
 try
  Dlg.Initialize(Params);
  Result:=Dlg.Execute;
 finally
   Dlg.Free;
 end;
end;

procedure TMiceTextEditTryForm.FormCreate(Sender: TObject);
begin
  inherited;
  ReadOnly:=True;
end;

procedure TMiceTextEditTryForm.Initialize(Params:TxParams);
begin
 FakeDataSet.Open;
 FEdit.InitFromParams(Params);
end;

end.
