unit StaticDialog.DBNameSelector;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxContainer, cxEdit, Vcl.Menus, cxLabel, Vcl.StdCtrls,
  cxButtons, cxTextEdit, Vcl.ExtCtrls,
  Common.Images,
  DAC.ConnectionMngr,
  CustomControl.Interfaces, cxMaskEdit, cxDropDownEdit;

type
  TDBNameSelectorDialog = class(TForm)
    Image: TImage;
    bnOK: TcxButton;
    bnCancel: TcxButton;
    lbText: TcxLabel;
    edDBName: TcxComboBox;
    procedure FormCreate(Sender: TObject);
  private
    FImageIndex: Integer;
    procedure SetImageIndex(const Value: Integer);
    function GetDBName: string;
    procedure SetDBName(const Value: string);
  public
    property DBName:string read GetDBName write SetDBName;
    property ImageIndex:Integer read FImageIndex write SetImageIndex;
    class function Execute(var ADBName: string):Boolean;
  end;


implementation

{$R *.dfm}

{ TDBNameSelectorDlg  }

class function TDBNameSelectorDialog.Execute(var ADBName: string): Boolean;
var
 Dlg:TDBNameSelectorDialog;
begin
 Dlg:=TDBNameSelectorDialog.Create(nil);
 try
  Dlg.DBName:=ADBName;
  Result:=Dlg.ShowModal=mrOk;
  if Result then
   ADBName:=Dlg.DBName;
 finally
  Dlg.Free;
 end;
end;

procedure TDBNameSelectorDialog.FormCreate(Sender: TObject);
begin
 ImageIndex:=166;
 ConnectionManager.PopulateDBNames(edDBName.Properties.Items);
end;

function TDBNameSelectorDialog.GetDBName: string;
begin
 Result:=edDBName.Text;
end;

procedure TDBNameSelectorDialog.SetDBName(const Value: string);
begin
 edDBName.Text:=Value;
end;

procedure TDBNameSelectorDialog.SetImageIndex(const Value: Integer);
begin
  Image.Picture.Bitmap:=nil;
  ImageContainer.Images32.GetBitmap(Value,Image.Picture.Bitmap);
  FImageIndex := Value;
end;

end.
