unit ImportExport.Dialogs.ImportConfirmation;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Dialog.Basic, cxGraphics,
  cxLookAndFeels, cxLookAndFeelPainters, Vcl.Menus, Vcl.StdCtrls, cxButtons,
  Vcl.ExtCtrls,
  ImportExport.StatisticList, dxBarBuiltInMenu, cxControls, cxPC, cxFilter,
  cxCustomData, cxStyles, dxScrollbarAnnotations, cxTL, cxTLdxBarBuiltInMenu,
  cxInplaceContainer, cxTextEdit,
  Common.Images,
  CustomControl.MiceGrid.ColorBuilder;

type
  TImportConfirmDialog = class(TBasicDialog)
    Panel1: TPanel;
    Image1: TImage;
    lbDescription: TLabel;
    Tree: TcxTreeList;
    colName: TcxTreeListColumn;
    ColChanged: TcxTreeListColumn;
    colInserted: TcxTreeListColumn;
    colDeleted: TcxTreeListColumn;
    colFields: TcxTreeListColumn;
    procedure TreeCustomDrawDataCell(Sender: TcxCustomTreeList;
      ACanvas: TcxCanvas; AViewInfo: TcxTreeListEditCellViewInfo;
      var ADone: Boolean);
    procedure FormCreate(Sender: TObject);
  private
    FTotalChangeCount:Integer;
    FStatisticList: TImportStatisticList;
    procedure CreateStatisticItem(const Name:string; Item:TImportStatisticItem);
  public
    procedure Init;
    property StatisticList:TImportStatisticList read FStatisticList write FStatisticList;
    class function Execute(AList:TImportStatisticList):Boolean; reintroduce;
  end;

implementation

{$R *.dfm}

procedure TImportConfirmDialog.CreateStatisticItem(const Name:string; Item: TImportStatisticItem);
var
 Node: TcxTreeListNode;
begin
 Node:=Tree.Add;
 Node.Data:=Item;
 Node.Values[Self.colName.ItemIndex]:=Name;
 Node.Values[Self.ColChanged.ItemIndex]:=Item.ChangeCount;
 Node.Values[Self.colInserted.ItemIndex]:=Item.InsertedCount;
 Node.Values[Self.colDeleted.ItemIndex]:=Item.DeletedCount;
 Node.Values[Self.colFields.ItemIndex]:=Item.TotalChangeCount;
 FTotalChangeCount:=FTotalChangeCount+Item.TotalChangeCount;
end;


class function TImportConfirmDialog.Execute(AList: TImportStatisticList): Boolean;
var
 Dlg:TImportConfirmDialog;
begin
 Dlg:=TImportConfirmDialog.Create(nil);
 try
  Dlg.StatisticList:=AList;
  Dlg.Init;
  Result:=Dlg.ShowModal=mrOK;
 finally
  Dlg.Free;
 end;
end;

procedure TImportConfirmDialog.FormCreate(Sender: TObject);
begin
  inherited;
  ImageContainer.LoadToImage(Self.Image1, IMAGEINDEX_INFORMATION);
end;

procedure TImportConfirmDialog.Init;
var
 s:string;
begin
 if Assigned(StatisticList) then
  for s in StatisticList.List.Keys do
   CreateStatisticItem(s,StatisticList.List[s]);
  Self.bnOK.Enabled:=Self.FTotalChangeCount>0;
end;

procedure TImportConfirmDialog.TreeCustomDrawDataCell(Sender: TcxCustomTreeList;
  ACanvas: TcxCanvas; AViewInfo: TcxTreeListEditCellViewInfo;
  var ADone: Boolean);
begin
  TMiceGridColors.DefaultDrawTreeCell(Sender,ACanvas,AViewInfo, ADone)
end;

end.
