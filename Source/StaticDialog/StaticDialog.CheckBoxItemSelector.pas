unit StaticDialog.CheckBoxItemSelector;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Dialog.Basic, cxGraphics,
  cxLookAndFeels, cxLookAndFeelPainters, Vcl.Menus, Vcl.StdCtrls, Vcl.CheckLst,
  cxButtons, Vcl.ExtCtrls, cxControls, cxContainer, cxEdit, cxCheckListBox,
  System.Generics.Collections, System.Generics.Defaults, Data.DB;

type

  TCheckBoxItemSelector = class(TBasicDialog)
    CheckItems: TcxCheckListBox;
    procedure CheckItemsEditValueChanged(Sender: TObject);
  private
   function SomethingChecked:Boolean;
  public
   class function ExecuteTableSelectDlg(DataSet:TDataSet; OutList: TStrings;const MainTable:string; AOwner:TComponent):Boolean;
   procedure LoadFromDataSet(DataSet:TDataSet; const FieldName:string);
   procedure ToList(List:TStrings); overload;
  end;

implementation

{$R *.dfm}

{ TCheckBoxItemSelector }

procedure TCheckBoxItemSelector.CheckItemsEditValueChanged(Sender: TObject);
begin
 bnOK.Enabled:=SomethingChecked;
end;

class function TCheckBoxItemSelector.ExecuteTableSelectDlg(DataSet:TDataSet; OutList: TStrings; const MainTable:string; AOwner:TComponent): Boolean;
var
 Dlg:TCheckBoxItemSelector;
begin
 Dlg:=TCheckBoxItemSelector.Create(AOwner);
 try
  Dlg.CheckItems.AddItem(MainTable);
  Dlg.LoadFromDataSet(DataSet,'TableName');
  Result:=Dlg.Execute;
  if Result then
   Dlg.ToList(OutList);
 finally
   Dlg.Free;
 end;
end;

procedure TCheckBoxItemSelector.LoadFromDataSet(DataSet: TDataSet;  const FieldName: string);
var
 Item:TcxCheckListBoxItem;
begin
  DataSet.First;
  while not DataSet.Eof do
   begin
    Item:=CheckItems.Items.Add;
    Item.Checked:=False;
    Item.Text:=DataSet.FieldByName(FieldName).AsString;
    DataSet.Next;
   end;
end;


function TCheckBoxItemSelector.SomethingChecked: Boolean;
var
 x:Integer;
begin
 Result:=False;
  for x:=0 to CheckItems.Items.Count-1 do
   if CheckItems.Items[x].Checked then
    Exit(True);
end;

procedure TCheckBoxItemSelector.ToList(List: TStrings);
var
 Item:TCollectionItem;
begin
 for Item in CheckItems.Items do
  if (Item as TcxCheckListBoxItem).Checked then
   List.Add((Item as TcxCheckListBoxItem).Text)
end;

end.
