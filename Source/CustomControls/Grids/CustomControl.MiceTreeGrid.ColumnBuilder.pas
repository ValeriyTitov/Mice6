unit CustomControl.MiceTreeGrid.ColumnBuilder;

interface


uses
  System.SysUtils, System.Variants, System.Classes, VCL.Graphics, Data.DB,
  cxGraphics, cxControls,cxCalendar,cxCheckBox, cxImageComboBox, cxImage,
  cxBlobEdit, cxTextEdit,cxClasses, cxTL, cxDBTL, cxCustomData,
  cxCurrencyEdit,
  Common.Images,
  Common.LookAndFeel,
  CustomControl.CommonGrid.ColumnBuilder,
  CustomControl.MiceGrid.Helper;

type
 TMiceTreeGridColumnBuilder = class(TCommonColumnBuilder)
   private
    FGrid: TcxDBTreeList;
    FColumn:TcxDBTreeListColumn;

    function CreateDefaultColumn:TcxDBTreeListColumn;
    function FindColumn(const FieldName:string):TcxDBTreeListColumn;

    procedure InternalCreateBand(var FirstBand:Boolean);
    procedure InternalCreateColumn;

    procedure CreateMissingColumn(Field:TField);


    procedure SetColumnPropertiesCheckBox;
    procedure SetColumnPropertiesCurrency;
    procedure SetColumnPropertiesPicture;
    procedure SetColumnPropertiesPopupPicture;
    procedure SetColumnPropertiesImageIndex;
    procedure SetColumnPropertiesSubAccounts;
    procedure SetColumnPropertiesText;
    procedure SetColumnPropertiesDropDown;
    procedure SetColumnPropertiesDate;
    procedure SetColumnPropertiesCurrencyNumber;
   public
    procedure CreateMissingColumns;
    procedure LoadFromDataSet; override;
    constructor Create(Grid: TcxDBTreeList);
    class procedure SetStyles(Grid: TcxDBTreeList);
 end;

implementation

{ TMiceGridColumnBuilder }

constructor TMiceTreeGridColumnBuilder.Create(Grid: TcxDBTreeList);
begin
 inherited Create;
 FGrid:=Grid;
 SetStyles(FGrid);
end;


function TMiceTreeGridColumnBuilder.CreateDefaultColumn: TcxDBTreeListColumn;
var
 SortOrder:Integer;
begin
 Result:=FGrid.CreateColumn as TcxDBTreeListColumn;
 Result.DataBinding.FieldName:=DataSet.FieldByName('FieldName').AsString;
 Result.Name:=DataSet.FieldByName('ColumnName').AsString;
 Result.Caption.Text :=DataSet.FieldByName('Caption').AsString;
 Result.Visible:=DataSet.FieldByName('Visible').AsBoolean;
 Result.Width:=DataSet.FieldByName('Width').AsInteger;
 Result.Options.Moving:= DataSet.FieldByName('Moving').AsBoolean;

 Result.Tag:=DataSet.FieldByName('AppColumnsID').AsInteger;
 Result.Options.Filtering := DataSet.FieldByName('Filter').AsBoolean;

 Result.Position.BandIndex := FGrid.Bands.Count-1;
 SortOrder:=DataSet.FieldByName('SortOrder').AsInteger;

 if SortOrder>=ColumnSortingDisabled  then
  Result.Options.Sorting:=False
   else
  Result.SortOrder:=TcxDataSortOrder(SortOrder);
// Result.Options.Sorting:=False;
// Result.HeaderAlignmentHorz:=TAlignment(DataSet.FieldByName('Align').AsInteger);
// Result.Options.HorzSizing:=DataSet.FieldByName('Sizing').AsBoolean;

end;

procedure TMiceTreeGridColumnBuilder.CreateMissingColumn(Field: TField);
var
  Column:TcxDBTreeListColumn;
begin
if not Assigned(Self.FindColumn(Field.FieldName)) then
 begin
   Column:=FGrid.CreateColumn as TcxDBTreeListColumn;
   (Column.DataBinding as TcxDBItemDataBinding).FieldName:=Field.FieldName;
   Column.Width:=80;
   Column.Visible:=False;
   Column.Options.Filtering := False;
//   Column.Options.HorzSizing:=True;
  // Column.Name:=View.Name + '_' + trim(cds.Fields[i].FieldName);
   Column.Caption.Text:=Field.FieldName;
 end;
end;

procedure TMiceTreeGridColumnBuilder.CreateMissingColumns;
var
 x:Integer;
 DataSet:TDataSet;
begin
 DataSet:=FGrid.DataController.DataSet;
  if Assigned(DataSet) then
   for x := 0 to DataSet.FieldCount - 1 do
    CreateMissingColumn(DataSet.Fields[x]);
end;

function TMiceTreeGridColumnBuilder.FindColumn(const FieldName: string): TcxDBTreeListColumn;
var
 x:Integer;
begin
 for x:=0 to FGrid.ColumnCount-1 do
  begin
   Result:=(FGrid.Columns[x] as TcxDBTreeListColumn);
   if Result.DataBinding.FieldName=FieldName then
    Exit;
  end;
  Result:=nil;
end;

procedure TMiceTreeGridColumnBuilder.InternalCreateBand(var FirstBand: Boolean);
var
 Band:TcxTreeListBand;
begin
 Self.FGrid.OptionsView.Bands:=True;
 if FirstBand then
  Band:=FGrid.Bands[0]
   else
  Band:=FGrid.Bands.Add;
  Band.Width:=DataSet.FieldByName('Width').AsInteger;
  Band.Caption.AlignHorz:=TAlignment(DataSet.FieldByName('Align').AsInteger);
  Band.FixedKind:=TcxTreeListBandFixedKind(DataSet.FieldByName('Fixed').AsInteger);
  Band.Options.Sizing:=DataSet.FieldByName('Sizing').AsBoolean;
  Band.Caption.Text:=DataSet.FieldByName('Caption').AsString;
  Band.Options.Moving:=DataSet.FieldByName('Moving').AsBoolean;
  Band.Styles.Header:=DefaultLookAndFeel.StyleGridBand;
  FirstBand:=False;
end;

procedure TMiceTreeGridColumnBuilder.InternalCreateColumn;
var
 ColumnType:Integer;
begin
 ColumnType:=DataSet.FieldByName('ColType').AsInteger;
 FColumn:=CreateDefaultColumn;

  case ColumnType of
    0:SetColumnPropertiesText;
    1:SetColumnPropertiesCheckBox;
    2:SetColumnPropertiesImageIndex;
    3:SetColumnPropertiesDropDown;
    4:SetColumnPropertiesSubAccounts;
    5:SetColumnPropertiesPicture;
    6:SetColumnPropertiesPopupPicture;
    7:SetColumnPropertiesCurrency;
    8:SetColumnPropertiesDate;
    9:SetColumnPropertiesCurrencyNumber;

     else
      SetColumnPropertiesText;
  end;
  SetPropertiesDefault(FColumn.Properties);
end;

procedure TMiceTreeGridColumnBuilder.LoadFromDataSet;
var
 FirstBand:Boolean;
begin
 try
   FirstBand:=True;
   FGrid.BeginUpdate;
   DataSet.DisableControls;
   DataSet.First;
   FGrid.Bands.Add;
   while not DataSet.Eof do
    begin
      if DataSet.FieldByName('IsBand').AsBoolean then
       InternalCreateBand(FirstBand)
        else
       InternalCreateColumn;
      DataSet.Next;
    end;
 finally
  FGrid.EndUpdate;
 end;
end;


procedure TMiceTreeGridColumnBuilder.SetColumnPropertiesCheckBox;
begin
 FColumn.PropertiesClass := TcxCheckBoxProperties;
 SetPropertiesCheckBox(FColumn.Properties);
end;

procedure TMiceTreeGridColumnBuilder.SetColumnPropertiesCurrency;
begin
 FColumn.PropertiesClass := TcxImageComboBoxProperties;;
 SetPropertiesCurrency(FColumn.Properties);
end;

procedure TMiceTreeGridColumnBuilder.SetColumnPropertiesCurrencyNumber;
begin
 FColumn.PropertiesClass := TcxCurrencyEditProperties;
 SetPropertiesCurrencyNumber(FColumn.Properties);
end;

procedure TMiceTreeGridColumnBuilder.SetColumnPropertiesDate;
begin
 FColumn.PropertiesClass := TcxDateEditProperties;
 SetPropertiesDate(FColumn.Properties);
end;

procedure TMiceTreeGridColumnBuilder.SetColumnPropertiesDropDown;
begin
 FColumn.PropertiesClass := TcxImageComboBoxProperties;
 Self.SetPropertiesDropDown(FColumn.Properties);
end;

procedure TMiceTreeGridColumnBuilder.SetColumnPropertiesImageIndex;
begin
 FColumn.PropertiesClass := TcxImageComboBoxProperties;
 SetPropertiesImageIndex(FColumn.Properties);
 FColumn.Options.Editing:=False;
end;

procedure TMiceTreeGridColumnBuilder.SetColumnPropertiesText;
begin
 FColumn.PropertiesClass := TcxTextEditProperties;
 SetPropertiesText(FColumn.Properties);
end;

class procedure TMiceTreeGridColumnBuilder.SetStyles(Grid: TcxDBTreeList);
begin
 Grid.Styles.Background:=DefaultLookAndFeel.StyleGridBack;
 Grid.Styles.Content :=DefaultLookAndFeel.StyleGridBack;
end;

procedure TMiceTreeGridColumnBuilder.SetColumnPropertiesPicture;
begin
 FColumn.PropertiesClass := TcxImageProperties;
 SetPropertiesPicture(FColumn.Properties);
 (FColumn.Properties as TcxImageProperties).OnGetGraphicClass := TMiceGridHelper.GetGraphicClass;
 (FColumn.Properties as TcxImageProperties).GraphicClass := nil;
end;

procedure TMiceTreeGridColumnBuilder.SetColumnPropertiesPopupPicture;
begin
 FColumn.PropertiesClass := TcxBLOBEditProperties;
 Self.SetPropertiesPopupPicture(FColumn.Properties);
 (FColumn.Properties as TcxBLOBEditProperties).OnGetGraphicClass:= TMiceGridHelper.GetGraphicClass;
 (FColumn.Properties as TcxBLOBEditProperties).PictureGraphicClass := nil;
end;

procedure TMiceTreeGridColumnBuilder.SetColumnPropertiesSubAccounts;
begin
 FColumn.PropertiesClass := TcxTextEditProperties;
// FColumn.OnGetDisplayText:= TMiceGridHelper.FormatSubAccount;
//FColumn.Width:=GetTextWidth('40817 810 9 0000 0000005',Font)+15
end;


end.
