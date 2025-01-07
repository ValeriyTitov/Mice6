unit ManagerEditor.AppDialog.DetailDataSetProperties;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Dialog.Basic, cxGraphics,
  cxLookAndFeels, cxLookAndFeelPainters, Vcl.Menus, Vcl.StdCtrls, cxButtons,
  Vcl.ExtCtrls, cxControls, cxContainer, cxEdit, cxTextEdit, cxMaskEdit,
  cxButtonEdit, cxDBEdit, cxDropDownEdit, Data.DB, cxCheckBox,
  Common.Images,
  DAC.ConnectionMngr,
  Manager.WindowManager,
  StaticDialog.AppObjectSelector;

type
  TDetailsDataSetPropertiesDlg = class(TBasicDialog)
    edSequenceName: TcxDBButtonEdit;
    Image1: TImage;
    Label1: TLabel;
    cbReadOnly: TcxDBCheckBox;
    DataSource1: TDataSource;
    cbSequenceDBName: TcxDBComboBox;
    Label2: TLabel;
    Label3: TLabel;
    edProviderPattern: TcxDBTextEdit;
    Label4: TLabel;
    procedure edSequenceNamePropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
  private
    FDataSet: TDataSet;
  public
    property DataSet:TDataSet read FDataSet write FDataSet;
    constructor Create(AOwner:TComponent); override;
    class function ClassExecute(DataSet: TDataSet):Boolean;
  end;

implementation

{$R *.dfm}

class function TDetailsDataSetPropertiesDlg.ClassExecute(DataSet: TDataSet): Boolean;
var
 Dlg:TDetailsDataSetPropertiesDlg;
begin
  Dlg:=TDetailsDataSetPropertiesDlg.Create(nil);
  try
   Dlg.DataSet:=DataSet;
   Dlg.DataSource1.DataSet:=DataSet;
   Result:=Dlg.Execute;
  finally
   Dlg.Free;
  end;
end;

constructor TDetailsDataSetPropertiesDlg.Create(AOwner: TComponent);
begin
  inherited;
  TImageContainer.LoadToImage(Image1,145);
  ConnectionManager.PopulateDBNames(cbSequenceDBName.Properties.Items);
end;

procedure TDetailsDataSetPropertiesDlg.edSequenceNamePropertiesButtonClick( Sender: TObject; AButtonIndex: Integer);
var
 ID:integer;
 s:string;
 ADBName:string;
begin
 ADBName:=FDataSet.FieldByName('SequenceDBName').AsString;
 if TSysObjectSelectionDialog.ExecuteDialog(iTypeSequence,ID,s, ADBName) then
  begin
   FDataSet.Edit;
   FDataSet.FieldByName('SequenceName').AsString:=s;
  end;
end;

end.
