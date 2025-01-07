unit CustomControl.MiceGrid.ColumnEditor.ColumnDialog;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Dialog.Basic, cxGraphics,
  cxLookAndFeels, cxLookAndFeelPainters, Vcl.Menus, Vcl.StdCtrls, cxButtons,
  Vcl.ExtCtrls, Data.DB, cxControls, cxContainer, cxEdit, cxTextEdit,
  cxMaskEdit, cxDropDownEdit, cxImageComboBox, cxDBEdit,
  Common.Images, cxButtonEdit, cxCheckBox, cxLabel, dxBarBuiltInMenu, cxPC,
  Common.Registry,
  CustomControl.AppObject,
  CustomControl.MiceDropDown.EditorFrame, cxMemo;

type
  TColumnPropetiesDlg = class(TBasicDialog)
    DataSource: TDataSource;
    Panel1: TPanel;
    cbMoving: TcxDBCheckBox;
    cbReadOnly: TcxDBCheckBox;
    cbSortOrder: TcxDBImageComboBox;
    cbColType: TcxDBImageComboBox;
    lbColType: TLabel;
    Image1: TImage;
    Label1: TLabel;
    pgProp: TcxPageControl;
    cxTabSheet1: TcxTabSheet;
    cxTabSheet2: TcxTabSheet;
    cxTabSheet3: TcxTabSheet;
    cxTabSheet4: TcxTabSheet;
    cxTabSheet5: TcxTabSheet;
    cxTabSheet6: TcxTabSheet;
    cxTabSheet7: TcxTabSheet;
    cxTabSheet8: TcxTabSheet;
    cxTabSheet9: TcxTabSheet;
    ddFrame: TDropDownEditorFrame;
    edProviderNameCurr: TcxTextEdit;
    Label2: TLabel;
    DBName: TLabel;
    edDBNameCurr: TcxComboBox;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    edCellHintField: TcxDBTextEdit;
    Panel2: TPanel;
    cbAlign: TcxDBImageComboBox;
    Label6: TLabel;
    cxTabSheet10: TcxTabSheet;
    Panel3: TPanel;
    memoHint: TcxDBMemo;
    edColumnName: TcxDBTextEdit;
    Label7: TLabel;
    procedure cbColTypePropertiesChange(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
  private
    FAppObject: TMiceAppObject;
    procedure SaveCurrency;
  public
    property AppObject:TMiceAppObject read FAppObject;
    constructor Create(AOwner:TComponent); override;
    destructor Destroy; override;
    procedure Load;
    procedure Save;
    class function ClassExecute(DataSet: TDataSet):Boolean;
  end;

implementation

{$R *.dfm}


{ TColumnPropetiesDlg }

procedure TColumnPropetiesDlg.cbColTypePropertiesChange(Sender: TObject);
begin
  Self.pgProp.ActivePageIndex:=Self.cbColType.EditValue;
end;

class function TColumnPropetiesDlg.ClassExecute(DataSet: TDataSet): Boolean;
var
 Dlg:TColumnPropetiesDlg;
begin
 Dlg:=TColumnPropetiesDlg.Create(nil);
 try
  Dlg.DataSource.DataSet:=DataSet;
  Dlg.Load;
  Result:=Dlg.ShowModal=mrOK;
  if Result then
   Dlg.Save;
 finally
  Dlg.Free;
 end;

end;

constructor TColumnPropetiesDlg.Create(AOwner: TComponent);
begin
  inherited;
  TImageContainer.LoadToImage(Image1,84);
  FAppObject:=TMiceAppObject.Create;
  pgProp.Properties.HideTabs:=True;
  Sizeable:=True;
end;

destructor TColumnPropetiesDlg.Destroy;
begin
  AppObject.Free;
  inherited;
end;

procedure TColumnPropetiesDlg.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  TProjectRegistry.DefaultInstance.SaveForm(ClassName,Self);
end;

procedure TColumnPropetiesDlg.FormCreate(Sender: TObject);
begin
  inherited;
  TProjectRegistry.DefaultInstance.LoadForm(ClassName, False, True, Self);
end;

procedure TColumnPropetiesDlg.FormShow(Sender: TObject);
begin
  inherited;
  pgProp.ActivePageIndex:=cbColType.EditValue;
end;


procedure TColumnPropetiesDlg.Load;
begin
 AppObject.AsJson:=DataSource.DataSet.FieldByName('InitString').AsString;
 ddFrame.LoadFromMiceAppObject(FAppObject);
 edDBNameCurr.Text:=AppObject.Properties.DBName;
 edProviderNameCurr.Text:=AppObject.Properties.ProviderName;
end;

procedure TColumnPropetiesDlg.Save;
begin
 DataSource.DataSet.Edit;
 case pgProp.ActivePageIndex of
  7:SaveCurrency;
  3:ddFrame.SaveToMiceMiceAppObject(FAppObject);
 end;

 AppObject.WriteNullIfEmpty(DataSource.DataSet.FieldByName('InitString'));
end;

procedure TColumnPropetiesDlg.SaveCurrency;
begin
 AppObject.Properties.DBName:=Self.edDBNameCurr.Text;
 AppObject.Properties.ProviderName:=Self.edProviderNameCurr.Text;
end;


end.
