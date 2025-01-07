unit CustomControl.MiceGrid.ColorBuilder;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  cxGraphics, cxControls, cxLookAndFeels, cxLookAndFeelPainters, cxStyles, cxCustomData, cxFilter,
  cxData, cxDataStorage, Data.DB, cxDBData, cxGridLevel, Graphics, System.UITypes,
  cxClasses, cxGridCustomView, cxGridCustomTableView, cxGridTableView,
  cxGridDBTableView, cxGrid, cxGridDBDataDefinitions,
  System.Generics.Collections, System.Generics.Defaults,
  CxTL,
  CxDBTL,
  cxInplaceContainer,
  Common.Images,
  Common.LookAndFeel,
  Common.VariantComparator,
  Common.StringUtils,
  DAC.XDataSet;


type
 TMiceColorEntity = class
  private
    FSign: TVariantEquation;
    FWholeRow: Boolean;
    FColor: TColor;
    FFieldName: string;
    FValue: Variant;
    FItalic: Boolean;
    FBold: Boolean;
    FbgColor: TColor;
    FGridItem: TcxCustomGridTableItem;
    FTreeGridColumn: TcxTreeListColumn;
    FGridItemRef: TcxCustomGridTableItem;
    FTreeGridColumnRef: TcxTreeListColumn;
  public
    property FieldName:string read FFieldName write FFieldName;
    property Sign:TVariantEquation read FSign write FSign;
    property Value:Variant read FValue write FValue;
    property bgColor:TColor read FbgColor write FbgColor;
    property Color:TColor read FColor write FColor;
    property Bold:Boolean read FBold write FBold;
    property Italic:Boolean read FItalic write FItalic;
    property WholeRow:Boolean read FWholeRow write FWholeRow;

    property GridItem:TcxCustomGridTableItem read FGridItem write FGridItem;
    property GridItemRef: TcxCustomGridTableItem read FGridItemRef write FGridItemRef;
    property TreeGridColumn:TcxTreeListColumn read FTreeGridColumn write FTreeGridColumn;
    property TreeGridColumnRef:TcxTreeListColumn read FTreeGridColumnRef write FTreeGridColumnRef;

    procedure LoadFromDataSet(DataSet:TDataSet);
    function FindGridFieldValue(AViewInfo: TcxGridTableDataCellViewInfo):Variant; overload;
 end;


 TMiceGridColors = class
 private
  FItems: TObjectList<TMiceColorEntity>;
  FFontColorField: string;
  FbgColorField: string;
  FFontStyleField: string;

  procedure InternalDrawGridCell(Item:TMiceColorEntity; ACanvas: TcxCanvas; const AValue:Variant; AViewInfo: TcxGridTableDataCellViewInfo);
  procedure InternalDrawTreeCell(Item:TMiceColorEntity; ACanvas: TcxCanvas; const AValue:Variant; AViewInfo: TcxTreeListEditCellViewInfo);
  procedure DrawItem(Item:TMiceColorEntity; ACanvas: TcxCanvas);
 public
  property Items:TObjectList<TMiceColorEntity> read FItems;
  property bgColorField:string read FbgColorField write FbgColorField;
  property FontColorField:string read FFontColorField write FFontColorField;
  property FontStyleField:string read FFontStyleField write FFontStyleField;

  procedure LoadFromDataSet(DataSet:TDataSet);
  procedure LoadForPlugin(AppPluginsId:Integer);
  procedure LoadForControl(AppDialogControlsId:Integer);
  procedure MapGridItems(View:TcxCustomGridTableView);
  procedure MapTreeGridItems(TreeGrid:TcxDBTreeList);

  procedure DrawGridColorCell(Sender: TcxCustomGridTableView; ACanvas: TcxCanvas; AViewInfo: TcxGridTableDataCellViewInfo;var ADone: Boolean);
  procedure DrawTreeColorCell(Sender: TcxCustomTreeList;  ACanvas: TcxCanvas; AViewInfo: TcxTreeListEditCellViewInfo; var ADone: Boolean);

  class procedure DefaultDrawGridCell(Sender: TcxCustomGridTableView; ACanvas: TcxCanvas; AViewInfo: TcxGridTableDataCellViewInfo;var ADone: Boolean);
  class procedure DefaultDrawTreeCell(Sender: TcxCustomTreeList;  ACanvas: TcxCanvas; AViewInfo: TcxTreeListEditCellViewInfo; var ADone: Boolean);

  constructor Create;
  destructor Destroy; override;
 end;


implementation


{ TMiceColorEntity }


function TMiceColorEntity.FindGridFieldValue(AViewInfo: TcxGridTableDataCellViewInfo): Variant;
begin
 if Assigned(GridItemRef) then
  Result:=AViewInfo.GridRecord.Values[GridItemRef.Index]
   else
  Result:=Self.Value;
end;

procedure TMiceColorEntity.LoadFromDataSet(DataSet: TDataSet);
begin
 FieldName:= DataSet.FieldByName('FieldName').AsString;
 Sign:=TVariantEquation(DataSet.FieldByName('Sign').AsInteger);
 Value:=DataSet.FieldByName('Value').Value;
 bgColor:=DataSet.FieldByName('bgColor').AsInteger;
 Color:= DataSet.FieldByName('Color').AsInteger;
 Italic:=DataSet.FieldByName('Italic').AsBoolean;
 Bold:=DataSet.FieldByName('Bold').AsBoolean;
 WholeRow:=DataSet.FieldByName('WholeRow').AsBoolean;
end;

{ TMiceGridColors }

constructor TMiceGridColors.Create;
begin
  FItems:=TObjectList<TMiceColorEntity>.Create;
end;

procedure TMiceGridColors.DrawTreeColorCell(Sender: TcxCustomTreeList;  ACanvas: TcxCanvas; AViewInfo: TcxTreeListEditCellViewInfo;  var ADone: Boolean);
var
 Item:TMiceColorEntity;
begin
 for Item in Items do
  if (Item.WholeRow) and Assigned(Item.TreeGridColumn)  then
   InternalDrawTreeCell(Item, ACanvas, AViewInfo.Node.Values[Item.TreeGridColumn.ItemIndex], AViewInfo)
    else
  if AViewInfo.Column=Item.TreeGridColumn then
   InternalDrawTreeCell(Item, ACanvas, AViewInfo.DisplayValue, AViewInfo)
end;

procedure TMiceGridColors.DrawGridColorCell(Sender: TcxCustomGridTableView; ACanvas: TcxCanvas; AViewInfo: TcxGridTableDataCellViewInfo;  var ADone: Boolean);
var
 Item:TMiceColorEntity;
begin
for Item in Items do
 if (Item.WholeRow) and Assigned(Item.GridItem) then
  InternalDrawGridCell(Item, ACanvas, AViewInfo.GridRecord.Values[Item.GridItem.Index], AViewInfo)
    else
 if AViewInfo.Item=Item.GridItem then
  InternalDrawGridCell(Item, ACanvas, AViewInfo.GridRecord.Values[AViewInfo.Item.Index], AViewInfo)
end;

procedure TMiceGridColors.DrawItem(Item: TMiceColorEntity; ACanvas: TcxCanvas);
begin
 ACanvas.Brush.Color:=Item.bgColor;
 ACanvas.Font.Color:=Item.Color;

 if Item.Bold then
  ACanvas.Font.Style:=ACanvas.Font.Style+[fsBold];

 if Item.Italic then
  ACanvas.Font.Style:=ACanvas.Font.Style+[fsItalic];
end;

class procedure TMiceGridColors.DefaultDrawGridCell(Sender: TcxCustomGridTableView;  ACanvas: TcxCanvas; AViewInfo: TcxGridTableDataCellViewInfo;  var ADone: Boolean);
begin
 ACanvas.Font.Color:=DefaultLookAndFeel.GridColors.FontColor;
 ACanvas.Brush.Color:=DefaultLookAndFeel.GridColors.BackColor;

 if AViewInfo.GridRecord.Selected then
  begin
    ACanvas.Font.Color:=DefaultLookAndFeel.GridColors.SelectedLineFontColor;
    ACanvas.Brush.Color:=DefaultLookAndFeel.GridColors.SelectedLineColor;
  end;
 if AViewInfo.Focused and AViewInfo.GridRecord.Focused then
  begin
    ACanvas.Brush.Color:=DefaultLookAndFeel.GridColors.SelectedCellColor;
    ACanvas.Font.Color:=DefaultLookAndFeel.GridColors.SelectedCellFontColor;
  end;
end;

class procedure TMiceGridColors.DefaultDrawTreeCell(Sender: TcxCustomTreeList; ACanvas: TcxCanvas; AViewInfo: TcxTreeListEditCellViewInfo;  var ADone: Boolean);
begin
 ACanvas.Font.Color:=DefaultLookAndFeel.GridColors.FontColor;
 ACanvas.Brush.Color:=DefaultLookAndFeel.GridColors.BackColor;
 if AViewInfo.Selected then
   begin
    ACanvas.Font.Color:=DefaultLookAndFeel.GridColors.SelectedLineFontColor;
    ACanvas.Brush.Color:=DefaultLookAndFeel.GridColors.SelectedLineColor;
   end;
  if AViewInfo.Focused then
   begin
    ACanvas.Brush.Color:=DefaultLookAndFeel.GridColors.SelectedCellColor;
    ACanvas.Font.Color:=DefaultLookAndFeel.GridColors.SelectedCellFontColor;
   end;
end;

destructor TMiceGridColors.Destroy;
begin
  FItems.Free;
  inherited;
end;

procedure TMiceGridColors.InternalDrawGridCell(Item: TMiceColorEntity;  ACanvas: TcxCanvas; const AValue: Variant; AViewInfo: TcxGridTableDataCellViewInfo);
var
 RealValue:Variant;
begin
 if Assigned(Item.GridItemRef) then
  RealValue:=AViewInfo.GridRecord.Values[Item.GridItemRef.Index]
   else
  RealValue:=Item.Value;

 if TVariantComparator.TryCompareVariant(RealValue, AValue, Item.Sign) then
  DrawItem(Item, ACanvas);
end;


procedure TMiceGridColors.InternalDrawTreeCell(Item: TMiceColorEntity;  ACanvas: TcxCanvas; const AValue: Variant;  AViewInfo: TcxTreeListEditCellViewInfo);
var
 RealValue:Variant;
begin
 if Assigned(Item.TreeGridColumnRef) then
  RealValue:=AViewInfo.Node.Values[Item.TreeGridColumnRef.ItemIndex]
   else
  RealValue:=Item.Value;

 if TVariantComparator.TryCompareVariant(RealValue, AValue, Item.Sign) then
  DrawItem(Item, ACanvas);
end;

procedure TMiceGridColors.LoadForControl(AppDialogControlsId: Integer);
var
 DataSet:TxDataSet;
begin
 DataSet:=TxDataSet.Create(nil);
 try
  DataSet.ProviderName:='spui_AppControlGetColors';
  DataSet.SetParameter('AppDialogControlsId',AppDialogControlsId);
  DataSet.Source:='TMiceGridColors.LoadForControl';
  DataSet.Open;
  LoadFromDataSet(DataSet);
 finally
  DataSet.Free;
 end;
end;

procedure TMiceGridColors.LoadForPlugin(AppPluginsId: Integer);
var
 DataSet:TxDataSet;
begin
 DataSet:=TxDataSet.Create(nil);
 try
  DataSet.ProviderName:='spui_AppPluginGetColors';
  DataSet.SetParameter('AppPluginsId',AppPluginsId);
  DataSet.Source:='TMiceGridColors.LoadForPlugin';
  DataSet.Open;
  LoadFromDataSet(DataSet);
 finally
  DataSet.Free;
 end;
end;

procedure TMiceGridColors.LoadFromDataSet(DataSet: TDataSet);
var
 Item:TMiceColorEntity;
begin
 while not DataSet.Eof do
  begin
   Item:=TMiceColorEntity.Create;
   Item.LoadFromDataSet(DataSet);
   FItems.Add(Item);
   DataSet.Next;
  end;
end;

procedure TMiceGridColors.MapGridItems(View: TcxCustomGridTableView);
var
 Item:TMiceColorEntity;
 AFieldName:string;
 X:Integer;
begin
 for Item in Items do
   for x:=0 to View.ItemCount-1 do
    begin
     AFieldName:=(View.Items[x].DataBinding as TcxGridItemDBDataBinding).FieldName;
     if TStringUtils.SameString(VarToStr(Item.FieldName), AFieldName) then
      Item.GridItem:=View.Items[x];

     AFieldName:='<'+AFieldName+'>';  //—сылка на столбец со значением
     if TStringUtils.SameString(VarToStr(Item.Value), AFieldName) then
      Item.GridItemRef:=View.Items[x];
    end;
end;


procedure TMiceGridColors.MapTreeGridItems(TreeGrid: TcxDBTreeList);
var
 Item:TMiceColorEntity;
 AFieldName:string;
 X:Integer;
begin
 for Item in Items do
   for x:=0 to TreeGrid.ColumnCount-1 do
    begin
     AFieldName:=((TreeGrid.Columns[x].DataBinding as TcxCustomItemDataBinding) as TcxDBItemDataBinding).FieldName;
     if TStringUtils.SameString(VarToStr(Item.FieldName), AFieldName) then
      Item.TreeGridColumn:=TreeGrid.Columns[x];

    AFieldName:='<'+AFieldName+'>'; //reference to column which holds value
     if TStringUtils.SameString(VarToStr(Item.Value), AFieldName) then
      Item.TreeGridColumnRef:=TreeGrid.Columns[x];
    end;
end;


end.
