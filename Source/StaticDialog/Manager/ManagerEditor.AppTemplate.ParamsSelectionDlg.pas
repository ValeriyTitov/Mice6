unit ManagerEditor.AppTemplate.ParamsSelectionDlg;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Dialog.Basic, cxGraphics,
  cxLookAndFeels, cxLookAndFeelPainters, Vcl.Menus, Vcl.StdCtrls, cxButtons,
  Vcl.ExtCtrls, Data.DB, Params.SourceSelectorFrame;

type
  TParamSourceDlg = class(TBasicDialog)
    ParamsFrame: TCommandPropertiesFrame;
  private
    { Private declarations }
  public
    class function ExecuteDialog(DataSource: TDataSource):Boolean;
  end;


implementation

{$R *.dfm}

{ TParamSourceDlg }

class function TParamSourceDlg.ExecuteDialog(DataSource: TDataSource): Boolean;
var
 Dlg:TParamSourceDlg;
begin
  Dlg:=TParamSourceDlg.Create(nil);
  try
   Dlg.ParamsFrame.MainView.DataController.DataSource:=DataSource;
   Dlg.ParamsFrame.LazyInit(nil);
   DataSource.DataSet.Edit;
   Result:=Dlg.Execute;
   if Result and (DataSource.DataSet.State in [dsInsert, dsEdit]) then
    DataSource.DataSet.Post;
  finally
    Dlg.Free;
  end;
end;

end.
