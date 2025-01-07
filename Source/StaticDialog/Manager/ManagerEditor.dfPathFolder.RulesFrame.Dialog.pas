unit ManagerEditor.dfPathFolder.RulesFrame.Dialog;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Dialog.Basic, cxGraphics,
  cxLookAndFeels, cxLookAndFeelPainters, Vcl.Menus, Vcl.StdCtrls, cxButtons,
  Vcl.ExtCtrls, cxControls, dxLayoutControlAdapters, dxLayoutcxEditAdapters,
  cxContainer, cxEdit, cxMemo, cxDBEdit, cxTextEdit, dxLayoutContainer,
  Vcl.DBCtrls, cxClasses, dxLayoutControl, Data.DB, dxmdaset,
  CustomControl.MiceSyntaxEdit, Common.Images;

type
  TDBMemo = class(TMiceSyntaxEdit)
  end;

  TPathFolderRuleDialog = class(TBasicDialog)
    DialogLayout: TdxLayoutControl;
    DialogLayoutGroup_Root: TdxLayoutGroup;
    cbActive: TDBCheckBox;
    item_Active: TdxLayoutItem;
    gpMain: TdxLayoutGroup;
    edCaption: TcxDBTextEdit;
    item_UserCaption: TdxLayoutItem;
    edExpression: TcxDBTextEdit;
    item_Expression: TdxLayoutItem;
    memoUserMessage: TcxDBMemo;
    item_Message: TdxLayoutItem;
    cbVisibleToUser: TDBCheckBox;
    item_VisibleToUser: TdxLayoutItem;
    DataSource1: TDataSource;
    item_Example: TdxLayoutItem;
    Group_Eample: TdxLayoutGroup;
    MemoSqlExample: TDBMemo;
    dsExample: TDataSource;
    dxMemData1: TdxMemData;
    dxMemData1SQLStr: TStringField;
    dxLayoutEmptySpaceItem1: TdxLayoutEmptySpaceItem;
    Image1: TImage;
    dxLayoutItem1: TdxLayoutItem;
    Label1: TLabel;
    dxLayoutItem2: TdxLayoutItem;
    dxLayoutAutoCreatedGroup1: TdxLayoutAutoCreatedGroup;
    Group_All: TdxLayoutGroup;
    procedure cbActiveClick(Sender: TObject);
    procedure edExpressionPropertiesChange(Sender: TObject);
  private
    FTableName: string;
    FKeyFieldValue: Integer;
    FKeyField: string;
    procedure UpdateAll;
  public
   property TableName:string read FTableName write FTableName;
   property KeyField:string read FKeyField write FKeyField;
   property KeyFieldValue:Integer read FKeyFieldValue write FKeyFieldValue;
   procedure Init;
   class function ExecuteDialog(DataSet:TDataSet; const TableName, KeyField:string):Boolean;
  end;


implementation

{$R *.dfm}

procedure TPathFolderRuleDialog.cbActiveClick(Sender: TObject);
begin
  Group_All.Enabled:=cbActive.Checked;;
end;

procedure TPathFolderRuleDialog.edExpressionPropertiesChange(Sender: TObject);
begin
  inherited;
  UpdateAll;
end;

class function TPathFolderRuleDialog.ExecuteDialog(DataSet: TDataSet; const TableName, KeyField:string): Boolean;
var
 Dlg:TPathFolderRuleDialog;
begin
 Dlg:=TPathFolderRuleDialog.Create(nil);
 try
  DataSet.Edit;
  Dlg.DataSource1.DataSet:=DataSet;
  Dlg.KeyField:=KeyField;
  Dlg.TableName:=TableName;
  Dlg.Init;
  Result:=Dlg.ShowModal=mrOk;
  if Result then
   DataSet.Post;
 finally
  Dlg.Free;
 end;
end;

procedure TPathFolderRuleDialog.Init;
const
 MAGIC_NUMBER = 42;
begin
 TImageContainer.LoadToImage(Image1, 483);
 KeyFieldValue:=MAGIC_NUMBER;
 cbActiveClick(nil);
 UpdateAll;
 MemoSqlExample.Syntax:='Sql';
end;

procedure TPathFolderRuleDialog.UpdateAll;
const
 S_SQL_PATTERN = 'SELECT'#13' %s as [Caption],'#13' %s as [UserMessage],'#13' 227 as [ImageIndex]'#13+
                 'FROM %s WITH (NOLOCK)'#13+
                 'WHERE %s = %d'#13+
                 'AND %s';
begin
 dxMemData1.Open;
 dxMemData1.Edit;
 dxMemData1.FieldByName('SQLStr').AsString :=Format(S_SQL_PATTERN,[QuotedStr(edCaption.Text), QuotedStr(MemoUserMessage.Text),TableName,KeyField,KeyFieldValue, edExpression.Text]);
 dxMemData1.Post;
end;

end.
