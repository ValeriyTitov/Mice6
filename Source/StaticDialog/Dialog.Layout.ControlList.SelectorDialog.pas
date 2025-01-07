unit Dialog.Layout.ControlList.SelectorDialog;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Dialog.Basic, cxGraphics,
  cxLookAndFeels, cxLookAndFeelPainters, Vcl.Menus, Vcl.StdCtrls, cxButtons,
  Vcl.ExtCtrls, cxControls, cxContainer, cxEdit, cxLabel, cxTextEdit,
  Vcl.ComCtrls,
  Common.Images,
  Common.StringUtils,
  Common.ResourceStrings,
  Dialog.Layout.ControlList, Vcl.WinXCtrls, cxMemo;

type
  TNewControlSelectorDialog = class(TBasicDialog)
    Panel1: TPanel;
    lvItems: TListView;
    Timer1: TTimer;
    edSearch: TSearchBox;
    lbSearch: TLabel;
    memDescription: TcxMemo;
    procedure Timer1Timer(Sender: TObject);
    procedure lvItemsChange(Sender: TObject; Item: TListItem; Change: TItemChange);
    procedure edSearchPropertiesChange(Sender: TObject);
    procedure lvItemsDblClick(Sender: TObject);
  private
   FLastTick:Int64;
  public
    procedure Init(const Filter:string);
    procedure AddItem(Item:TDialogLayoutControl);
    function SelectedClass:string;
    class function ExecuteDlg(var s:string):Boolean;
    constructor Create(AOwner:TComponent);override;
  end;

implementation

{$R *.dfm}

{ TNewControlSelectorDialog }

procedure TNewControlSelectorDialog.AddItem(Item: TDialogLayoutControl);
var
 ListItem:TListItem;
begin
 ListItem:=lvItems.Items.Add;
 ListItem.Caption:=Item.ControlClass.ClassName;
 ListItem.ImageIndex:=Item.ImageIndex;
 ListItem.Data:=Item;
end;

constructor TNewControlSelectorDialog.Create(AOwner: TComponent);
begin
  inherited;
  FLastTick:=GetTickCount;
end;

procedure TNewControlSelectorDialog.edSearchPropertiesChange(Sender: TObject);
begin
 FLastTick:=GetTickCount;
 Timer1.Enabled:=True;
end;

class function TNewControlSelectorDialog.ExecuteDlg(var s:string): Boolean;
var
 Dlg:TNewControlSelectorDialog;
begin
 Dlg:=TNewControlSelectorDialog.Create(nil);
 try
  Dlg.Init('');
  Result:=Dlg.Execute;
   if Result then
    s:=Dlg.SelectedClass;
 finally
   Dlg.Free;
 end;

end;

procedure TNewControlSelectorDialog.Init(const Filter:string);
var
 s:string;
 Item:TDialogLayoutControl;
begin
 lvItems.Clear;
 for s in TDialogLayoutControlList.DefaultInstance.Keys do
  begin
   Item:=TDialogLayoutControlList.DefaultInstance[s];
   if Filter.IsEmpty or (Pos(AnsiLowerCase(Filter), AnsiLowerCase(Item.ControlClass.ClassName))>0) then
    AddItem(Item);
  end;
end;

procedure TNewControlSelectorDialog.lvItemsChange(Sender: TObject;  Item: TListItem; Change: TItemChange);
var
 DialogItem:TDialogLayoutControl;
begin
 bnOk.Enabled:=Assigned(lvItems.Selected);
 if Assigned(lvItems.Selected) then
  begin
   DialogItem:=Item.Data;
   memDescription.Lines.Text:=DialogItem.Description;
  end;
end;

procedure TNewControlSelectorDialog.lvItemsDblClick(Sender: TObject);
begin
 if Assigned(lvItems.Selected) then
  ModalResult:=mrOK;
end;

function TNewControlSelectorDialog.SelectedClass: string;
begin
 Result:=lvItems.Selected.Caption;
end;

procedure TNewControlSelectorDialog.Timer1Timer(Sender: TObject);
begin
 if GetTickCount>FLastTick+500 then
  begin
   Timer1.Enabled:=False;
   Init(edSearch.Text);
  end;
end;

end.
