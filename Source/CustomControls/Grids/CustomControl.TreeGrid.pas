unit CustomControl.TreeGrid;

interface
uses Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
     System.Classes, cxGraphics, cxControls, cxLookAndFeels, cxLookAndFeelPainters,
     cxCustomData, cxStyles, cxTL, cxTLdxBarBuiltInMenu, cxInplaceContainer,
     Graphics, Dialogs,
     System.Generics.Collections,
     CustomControl.MiceGrid.ColorBuilder,
     cxTLData, cxDBTL, DB,
     DAC.XDataSet,
     Common.Images,
     Common.ResourceStrings;

type

 TMiceTreeGrid = class (TcxDBTreeList)
  private
    FDataSet: TxDataSet;
    FDataSource: TDataSource;
    FPathColumn: TcxDBTreeListColumn;
    FMiceGridColors: TMiceGridColors;
    FFindDlg: TFindDialog;
    FHotKeyEnabled: Boolean;
    function GetPath: String;
    procedure SetPath(const Value: String);
    procedure CustomDrawDataCell(Sender: TcxCustomTreeList; ACanvas: TcxCanvas; AViewInfo: TcxTreeListEditCellViewInfo; var ADone: Boolean);
    function GetKeyFieldValue: Variant;
    function GetFindDialog: TFindDialog;
  protected
    property FindDlg:TFindDialog read GetFindDialog;
    procedure PathByList(List:TStringList);
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure DoBeforeOpen(DataSet:TDataSet);
    procedure FindExpandedNodes(const Node:TcxTreeListNode; List:TList<Variant>);
    procedure ExpandNodes(List:TList<Variant>);
    procedure OnFindExecute(Sender:TObject);
    function Expand(ANode: TcxTreeListNode; const ALevel:Integer): String;
    function ContainText(ANode:TcxTreeListNode; const AText:string; var AColumnIndex:Integer):Boolean;
    procedure FocusNodeByText(AParentNode:TcxTreeListNode; const AText:string; AForward:Boolean);
  public
    property MiceGridColors:TMiceGridColors read FMiceGridColors;
    property DataSet:TxDataSet read FDataSet;
    property DataSource:TDataSource read FDataSource;
    property Path:string read GetPath write SetPath;
    property KeyFieldValue:Variant read GetKeyFieldValue;
    property PathColumn: TcxDBTreeListColumn read FPathColumn write FPathColumn;
    property HotKeyEnabled:Boolean read FHotKeyEnabled write FHotKeyEnabled;
    procedure ReQueryTree;
    procedure ClearColumns;
    procedure ExpandByLevel(const ALevel: Integer);
    procedure FindItem;
    procedure FindNext;
    function ItemByName(ANode: TcxTreeListNode; Name: string): TcxTreeListNode;
    function PathTo(ANode: TcxTreeListNode): string;
    constructor Create(AOwner:TComponent); override;
    destructor Destroy; override;
  end;



implementation
type
  PFindTextInfo = ^TFindTextInfo;
  TFindTextInfo = record
    Text: string;
    ColumnIndex: Integer;
  end;


{ TMiceTreeGrid }
procedure TMiceTreeGrid.ClearColumns;
var
 x:Integer;
begin
 for x:=ColumnCount-10 downto 0 do
   Columns[x].Free;
end;


function TMiceTreeGrid.ContainText(ANode: TcxTreeListNode; const AText: string;  var AColumnIndex: Integer): Boolean;
var
 Column:Integer;
 s:string;
begin
 for Column:=0 to VisibleColumnCount-1 do
  begin
   s:=VarToStr(ANode.Values[VisibleColumns[Column].ItemIndex]).ToLower;
   if s.Contains(AText.ToLower) then
     begin
      AColumnIndex:=Self.VisibleColumns[Column].ItemIndex;
      Exit(True);
     end;
  end;
  Result:=False;
end;

constructor TMiceTreeGrid.Create(AOwner: TComponent);
begin
  inherited;
  FDataSet:= TxDataSet.Create(Self);
  FDataSet.BeforeOpen:=DoBeforeOpen;
  FDataSource:=TDataSource.Create(Self);
  FDataSource.DataSet:=FDataSet;
  DataController.DataSource:=FDataSource;
  OptionsData.Deleting:=False;
  OptionsData.Inserting:=False;
  OptionsData.Editing:=False;
  Images:=ImageContainer.Images16;
  OnCustomDrawDataCell:=CustomDrawDataCell;
  FMiceGridColors:=TMiceGridColors.Create;
  HotKeyEnabled:=True;
end;


procedure TMiceTreeGrid.CustomDrawDataCell(Sender: TcxCustomTreeList;  ACanvas: TcxCanvas; AViewInfo: TcxTreeListEditCellViewInfo; var ADone: Boolean);
begin
 MiceGridColors.DrawTreeColorCell(Sender, ACanvas, AViewInfo,ADone);
 TMiceGridColors.DefaultDrawTreeCell(Sender, ACanvas, AViewInfo,ADone);
end;

destructor TMiceTreeGrid.Destroy;
begin
  FMiceGridColors.Free;
  inherited;
end;

procedure TMiceTreeGrid.DoBeforeOpen(DataSet: TDataSet);
var
 AOwner:string;
begin
 if Assigned(Self.Owner) then
  AOwner:=Owner.ClassName+'.'
   else
  AOwner:='.';
 if Trim(Name).IsEmpty then
  FDataSet.Source:=AOwner+ClassName
   else
  FDataSet.Source:=AOwner+Name;
end;

function TMiceTreeGrid.Expand(ANode: TcxTreeListNode; const ALevel:Integer): String;
var
 i: integer;
begin
 if ANode.Level < ALevel then
   begin
    ANode.Expand(False);
    for i:=0 to Pred(ANode.Count) do
      Expand(ANode.Items[i], ALevel);
  end
  else
    ANode.Collapse(True);
end;

procedure TMiceTreeGrid.ExpandByLevel(const ALevel: integer);
var
  x:Integer;
begin
if ALevel > 0 then
  for x:=0 to Count-1 do
    Expand(Items[x],ALevel)
end;

procedure TMiceTreeGrid.ExpandNodes(List: TList<Variant>);
var
 ANode: TcxTreeListNode;
 AValue: Variant;
begin
  for AValue in List do
   begin
    ANode:=FindNodeByKeyValue(AValue);
    if Assigned(ANode)  then
     ANode.Expand(False);
   end;
end;

procedure TMiceTreeGrid.FindNext;
begin
 OnFindExecute(Self);
end;


function Local_FindTextFilter(ANode: TcxTreeListNode; AData: Pointer): Boolean;
var
 ATreeList:TMiceTreeGrid;
 F:PFindTextInfo;
begin
 F:=PFindTextInfo(AData);
 ATreeList:=ANode.TreeList as TMiceTreeGrid;
 Result:=ATreeList.ContainText(ANode, F.Text, F.ColumnIndex);
end;

procedure TMiceTreeGrid.FocusNodeByText(AParentNode: TcxTreeListNode; const AText: string;AForward:Boolean);
var
 ANode:TcxTreeListNode;
 AFindInfo: TFindTextInfo;
begin
 AFindInfo.Text := AText;
 AFindInfo.ColumnIndex := 0;
 ANode := Find(@AFindInfo, AParentNode, False, AForward, Local_FindTextFilter, True);
  if Assigned(ANode) then
   begin
     ANode.Focused:=True;
     ANode.Selected:=True;
     FocusedColumn:=Columns[AFindInfo.ColumnIndex];
   end
    else
     MessageBox(FindDlg.Handle,PChar(Format(S_COMMON_CANNOT_FIND_TEXT_FMT,[AText])), PCHar(S_COMMON_INFORMATION), MB_OK+MB_ICONINFORMATION);
end;

procedure TMiceTreeGrid.FindItem;
begin
 FindDlg.Execute(Handle)
end;


procedure TMiceTreeGrid.FindExpandedNodes(const Node: TcxTreeListNode; List:TList<Variant>);
var
 x: Integer;
begin
 if Assigned(Node) then
  for x:=0 to Node.Count-1 do
   if Node.Items[x].Expanded then
    begin
     List.Add(Node.Items[x].Values[0]);
     FindExpandedNodes(Node.Items[x], List);
    end;
end;

function TMiceTreeGrid.GetFindDialog: TFindDialog;
begin
 if not Assigned(FFindDlg) then
  begin
   FFindDlg:=TFindDialog.Create(Self);
   FFindDlg.OnFind:=OnFindExecute;
   FFindDlg.Options:=[frDown, frHideWholeWord, frDisableMatchCase];
  end;
 Result:=FFindDlg;
end;

function TMiceTreeGrid.GetKeyFieldValue: Variant;
begin
 Result:=Self.DataSet.FieldByName(DataController.KeyField).Value;
end;

function TMiceTreeGrid.GetPath: String;
begin
 If Assigned(FocusedNode) then
  Result:=PathTo(FocusedNode)
   else
  Result:='';
end;

function TMiceTreeGrid.ItemByName(ANode: TcxTreeListNode; Name: String): TcxTreeListNode;
var
 x:integer;
begin
Result:=nil;
if Assigned(PathColumn) then
 begin
  for x:=0 to ANode.Count-1 do
   if ANode.Items[x].Values[PathColumn.ItemIndex]=Name then
    Exit(ANode.Items[x]);
 end;
end;


procedure TMiceTreeGrid.KeyDown(var Key: Word; Shift: TShiftState);
begin
 if (ssCtrl in Shift) and (Key=Ord('F')) and HotKeyEnabled then
   FindItem
  else
   inherited;
end;

procedure TMiceTreeGrid.OnFindExecute(Sender: TObject);
var
 AForward:Boolean;
begin
AForward:=frDown in FindDlg.Options;
if Assigned(FocusedNode) then
 FocusNodeByText(FocusedNode, FindDlg.FindText, AForward);
end;

function TMiceTreeGrid.PathTo(ANode: TcxTreeListNode): String;
var
  Item:TcxTreeListNode;
  List:TStringList;
  x: Integer;
begin
Result:='';
Item:=ANode;
List:=TStringList.Create;
try
if Assigned(PathColumn) then
 while Assigned(Item) do
  begin
   if Item.Values[PathColumn.ItemIndex]<>'' then
    List.Add(VarToStr(Item.Values[PathColumn.ItemIndex]));
   Item:=Item.Parent;
  end;
 for x:=List.Count-1 downto 0 do
  if x=0 then
  Result:=Result+List[x]
   else
  Result:=Result+List[x]+'\';
 finally
  List.Free;
 end;
end;

procedure TMiceTreeGrid.ReQueryTree;
var
 List:TList<Variant>;
// Key:Variant;
 OldPath:string;
begin
 List:=TList<Variant>.Create;
 try
  OldPath:=Path;
  FindExpandedNodes(Root, List);
  DataSet.ReQuery;
  Path:=OldPath;
  ExpandNodes(List);
 finally
  List.Free;
 end;
end;

procedure TMiceTreeGrid.PathByList(List: TStringList);
var
 X:Integer;
 Item:TcxTreeListNode;
begin
 Item:=Root;
 X:=0;
 while Assigned(Item) and (X<List.Count) do
  begin
   Item.Focused:=True;
   Item.Selected:=True;
   if (List[x]<>'') then
    Item:=ItemByName(Item,List[x]);
   Inc(X);
  end;

if Assigned(Item) then
 begin
  Item.Focused:=True;
  Item.Selected:=True;
 end;

end;


procedure TMiceTreeGrid.SetPath(const Value: String);
var
S:TStringList;
begin
 S:=TStringList.Create;
 try
  S.StrictDelimiter:=True;
  S.Delimiter:='\';
  S.DelimitedText:=Value;
  PathByList(S);
 finally
  S.Free;
 end;
if Assigned(FocusedNode) then
    FocusedNode.MakeVisible;
end;



end.
