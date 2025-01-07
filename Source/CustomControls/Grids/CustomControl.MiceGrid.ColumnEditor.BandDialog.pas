unit CustomControl.MiceGrid.ColumnEditor.BandDialog;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Dialog.Basic, cxGraphics,
  cxLookAndFeels, cxLookAndFeelPainters, Vcl.Menus, Vcl.StdCtrls, cxButtons,
  Vcl.ExtCtrls, cxControls, cxContainer, cxEdit, cxCheckBox, cxDBEdit, Data.DB,
  cxTextEdit, cxMaskEdit, cxDropDownEdit, cxImageComboBox,
  Common.Images;

type
  TBandPropetiesDlg = class(TBasicDialog)
    Label1: TLabel;
    Image1: TImage;
    cbFixed: TcxDBImageComboBox;
    DataSource: TDataSource;
    lbColType: TLabel;
    cbMoving: TcxDBCheckBox;
    cbAlign: TcxDBImageComboBox;
    Label2: TLabel;
    procedure FormCreate(Sender: TObject);
  public
   class function ClassExecute(DataSet: TDataSet):Boolean;
  end;


implementation

{$R *.dfm}

class function TBandPropetiesDlg.ClassExecute(DataSet: TDataSet): Boolean;
var
 Dlg:TBandPropetiesDlg;
begin
 Dlg:=TBandPropetiesDlg.Create(nil);
 try
  Dlg.DataSource.DataSet:=DataSet;
  Result:=Dlg.ShowModal=mrOK;
 finally
  Dlg.Free;
 end;

end;

procedure TBandPropetiesDlg.FormCreate(Sender: TObject);
begin
  inherited;
  TImageContainer.LoadToImage(Image1,84);
end;

end.
