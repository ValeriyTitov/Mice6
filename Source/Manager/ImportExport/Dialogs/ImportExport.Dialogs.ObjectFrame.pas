unit ImportExport.Dialogs.ObjectFrame;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, cxStyles, cxCustomData, cxFilter,
  cxData, cxDataStorage, cxEdit, cxNavigator, dxDateRanges,
  dxScrollbarAnnotations, Data.DB, cxDBData, cxGridLevel, cxClasses,
  cxGridCustomView, cxGridCustomTableView, cxGridTableView, cxGridDBTableView,
  cxGrid, cxTL, cxTLdxBarBuiltInMenu, cxInplaceContainer,
  ImportExport.Entity,
  Common.ResourceStrings,
  CustomControl.MiceGrid.ColorBuilder,
  cxCheckBox,
  DAC.XDataSet, cxTextEdit, Vcl.StdCtrls;

type
  TAppObjectExportFrame = class(TFrame)
    Tree: TcxTreeList;
    procedure TreeCustomDrawDataCell(Sender: TcxCustomTreeList;
      ACanvas: TcxCanvas; AViewInfo: TcxTreeListEditCellViewInfo;
      var ADone: Boolean);
    procedure Button1Click(Sender: TObject);
  private
    FObjectIdCol:TcxTreeListColumn;
    FCaptionCol:TcxTreeListColumn;
    FIntialized:Boolean;
    FSelectedCount: Integer;
    FOnSelectionChanged: TNotifyEvent;
    procedure ToggleDataSetActivity(Sender:TObject);
    procedure CreateColumns(Entity:TMiceITypeEntity);
    procedure CreateItem(Entity:TMiceITypeEntity);
    procedure DoOnSelectionChanged;
    function CreateDefaultColumn(const Name, Caption,Hint:string; Width:Integer):TcxTreeListColumn;
    procedure SetOnSelectionChanged(const Value: TNotifyEvent);
  public
    property OnSelectionChanged:TNotifyEvent read FOnSelectionChanged write SetOnSelectionChanged;
    property SelectedCount:Integer read FSelectedCount;
    procedure Init(Entity:TMiceITypeEntity);
    constructor Create(AOwner:TComponent); override;
    procedure SetAll(AValue:Boolean);
  end;

implementation

{$R *.dfm}

{ TAppObjectExportFrame }
procedure TAppObjectExportFrame.Button1Click(Sender: TObject);
begin
 Self.SetAll(False);
end;

constructor TAppObjectExportFrame.Create(AOwner: TComponent);
begin
  inherited;
  Self.FIntialized:=False;
end;

procedure TAppObjectExportFrame.CreateColumns(Entity: TMiceITypeEntity);
var
 DataSet:TxDataSet;
 Col:TcxTreeListColumn;
resourcestring
 S_COLUMN_HINT_APPEXPORT_OBJECTID='Represents an ID of object';
 S_COLUMN_HINT_APPEXPORT_CAPTION='Caption of object';
begin
 FObjectIdCol:=CreateDefaultColumn('', Entity.KeyField, S_COLUMN_HINT_APPEXPORT_OBJECTID, Length(Entity.KeyField)*3);
 FObjectIdCol.Options.Editing:=False;
 FCaptionCol:=CreateDefaultColumn('', S_COMMON_CAPTION,S_COLUMN_HINT_APPEXPORT_CAPTION, 80);
 FCaptionCol.Options.Editing:=False;
 for DataSet in Entity.DataSets do
  begin
   Col:=Self.CreateDefaultColumn(DataSet.TableName, DataSet.TableName,DataSet.Hint,Length(DataSet.TableName)*3 );
   Col.PropertiesClass := TcxCheckBoxProperties;
   (Col.Properties as TcxCheckBoxProperties).OnEditValueChanged :=ToggleDataSetActivity;
  end;
Self.FIntialized:=True;
end;

function TAppObjectExportFrame.CreateDefaultColumn(const Name, Caption, Hint:string; Width:Integer): TcxTreeListColumn;
begin
 Result:=Tree.CreateColumn(Tree.Bands.Items[0]);
 Result.Name:=Name;
 Result.Caption.Text :=Caption;
 Result.Options.Filtering := False;
 Result.Visible:=True;
 Result.Options.Moving:=False;
 Result.Options.Filtering:=False;
 Result.Options.Sorting:=False;
 Result.Width:=Width;
 Result.StatusHint:=Hint;
end;

procedure TAppObjectExportFrame.CreateItem(Entity: TMiceITypeEntity);
var
 Node: TcxTreeListNode;
 DataSet:TxDataSet;
 Col: TcxTreeListColumn;
 AValue:Boolean;
begin
 Node:=Tree.Add;
 Node.Data:=Entity;
 Node.Values[FObjectIdCol.ItemIndex]:=Entity.ObjectId;
 Node.Values[FCaptionCol.ItemIndex]:=Entity.Caption;
 for DataSet in Entity.DataSets do
  begin
   Col:=Tree.ColumnByName(DataSet.TableName);
   AValue:=DataSet.Tag=1;
   Node.Values[Col.ItemIndex]:=AValue;
   if AValue then
    Inc(FSelectedCount);

  end;
end;

procedure TAppObjectExportFrame.DoOnSelectionChanged;
begin
 if Assigned(OnSelectionChanged) then
  OnSelectionChanged(Self);
end;

procedure TAppObjectExportFrame.Init(Entity: TMiceITypeEntity);
begin
 if FIntialized=False then
  CreateColumns(Entity);

  CreateItem(Entity);
end;

procedure TAppObjectExportFrame.SetAll(AValue: Boolean);
var
 Node: TcxTreeListNode;
 x:Integer;
 y:Integer;
begin
 for x:=0 to Tree.Count-1 do
  begin
   Node:=Tree.Items[x];
   for y:=2 to Node.ValueCount-1 do
    Node.Values[y]:=AValue;
  end;

end;

procedure TAppObjectExportFrame.SetOnSelectionChanged(
  const Value: TNotifyEvent);
begin
  FOnSelectionChanged := Value;
end;

procedure TAppObjectExportFrame.ToggleDataSetActivity(Sender: TObject);
var
 Entity:TMiceITypeEntity;
 AChecked:Boolean;
 AName:string;
begin
 Entity:=TMiceITypeEntity(Tree.FocusedNode.Data);
 AChecked:=(Sender as TcxCheckBox).Checked;
 AName:=Tree.FocusedColumn.Name;
 if AChecked then
  begin
   Entity.SetExportActivity(AName,True);
   Inc(FSelectedCount);
  end
   else
   begin
    Entity.SetExportActivity(AName,False);
    Dec(FSelectedCount);
   end;
 Self.DoOnSelectionChanged;
end;

procedure TAppObjectExportFrame.TreeCustomDrawDataCell(
  Sender: TcxCustomTreeList; ACanvas: TcxCanvas;
  AViewInfo: TcxTreeListEditCellViewInfo; var ADone: Boolean);
begin
 TMiceGridColors.DefaultDrawTreeCell(Sender,ACanvas,AViewInfo, ADone)
end;

end.
