unit ManagerEditor.AppDialogLayout.JsonView;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Dialog.Basic, cxGraphics,
  cxLookAndFeels, cxLookAndFeelPainters, Vcl.Menus, Vcl.StdCtrls, cxButtons,
  Vcl.ExtCtrls,
  CustomControl.MiceSyntaxEdit, Data.DB;

type
  TLayoutJsonViewDlg = class(TBasicDialog)
    DataSource: TDataSource;
  private
   FEditor:TMiceSyntaxEdit;
  public
   constructor Create(AOwner:TComponent); override;
   property Editor:TMiceSyntaxEdit read FEditor;
   class function ExecuteDlg(DataSet:TDataSet):Boolean;
  end;

implementation

{$R *.dfm}

{ TLayoutJsonViewDlg }

constructor TLayoutJsonViewDlg.Create(AOwner: TComponent);
begin
  inherited;
  FEditor:=TMiceSyntaxEdit.Create(Self);
  FEditor.Parent:=Self;
  FEditor.Align:=alClient;
  FEditor.Syntax:='Json';
  FEditor.DataSource:=DataSource;
  FEditor.DataField:='Layout';
  Sizeable:=True;
end;

class function TLayoutJsonViewDlg.ExecuteDlg(DataSet: TDataSet): Boolean;
var
 Dlg:TLayoutJsonViewDlg;
begin
 Dlg:=TLayoutJsonViewDlg.Create(nil);
 try
  Dlg.DataSource.DataSet:=DataSet;
  Result:=Dlg.Execute;
 finally
  Dlg.Free;
 end;
end;

end.
