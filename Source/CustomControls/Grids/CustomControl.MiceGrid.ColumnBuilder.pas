unit CustomControl.MiceGrid.ColumnBuilder;

interface

uses
  System.SysUtils, System.Variants, System.Classes,
  cxGraphics, cxControls, VCL.Graphics,  cxClasses, cxGridCustomView,
  cxGridCustomTableView, cxGridTableView,cxGridDBBandedTableView,  cxGridDBTableView,
  cxGrid,  Data.DB, cxCheckBox, cxImageComboBox, cxImage, cxBlobEdit, cxTextEdit,
  cxGridBandedTableView,cxCalendar, Vcl.Controls, System.Types,
  Common.Images,
  cxCurrencyEdit,
  Common.LookAndFeel,
  Common.StringUtils,
  CustomControl.CommonGrid.ColumnBuilder,
  CustomControl.MiceGrid.Helper;

type
 TMiceGridColumnBuilder = class(TCommonColumnBuilder)
   private
    FView: TcxGridDBBandedTableView;
    FColumn:TcxGridDBBandedColumn;

    function CreateDefaultColumn:TcxGridDBBandedColumn;

    procedure InternalCreateBand(var FirstBand:Boolean);
    procedure InternalCreateColumn;

    procedure CreateMissingColumn(Field:TField);
    procedure MapHintColumns;


    procedure SetColumnPropertiesCheckBox;
    procedure SetColumnPropertiesCurrency;
    procedure SetColumnPropertiesPicture;
    procedure SetColumnPropertiesPopupPicture;
    procedure SetColumnPropertiesImageIndex;
    procedure SetColumnPropertiesSubAccounts;
    procedure SetColumnPropertiesText;
    procedure SetColumnPropertiesDropDown;
    procedure SetColumnPropertiesDate;
    procedure DoOnGetCellHint(Sender: TcxCustomGridTableItem;
                              ARecord: TcxCustomGridRecord;
                              ACellViewInfo: TcxGridTableDataCellViewInfo;
                              const AMousePos: TPoint;
                              var AHintText: TCaption;
                              var AIsHintMultiLine: Boolean;
                              var AHintTextRect: TRect);
    procedure SetColumnPropertiesCurrencyNumber;
   public
    procedure CreateMissingColumns;
    procedure LoadFromDataSet; override;
    constructor Create(View: TcxGridDBBandedTableView);
    class procedure SetStyles(View: TcxGridDBBandedTableView);
 end;

implementation

{ TMiceGridColumnBuilder }

constructor TMiceGridColumnBuilder.Create(View: TcxGridDBBandedTableView);
begin
 inherited Create;
 FView:=View;
 SetStyles(View);
end;


function TMiceGridColumnBuilder.CreateDefaultColumn: TcxGridDBBandedColumn;
var
 SortOrder:Integer;
begin
 Result:=FView.CreateColumn;
 Result.DataBinding.FieldName:=DataSet.FieldByName('FieldName').AsString;
 Result.Name:=DataSet.FieldByName('ColumnName').AsString;
 Result.Caption:=DataSet.FieldByName('Caption').AsString;
 Result.Visible:=DataSet.FieldByName('Visible').AsBoolean;
 Result.Width:=DataSet.FieldByName('Width').AsInteger;
 Result.HeaderAlignmentHorz:=TAlignment(DataSet.FieldByName('Align').AsInteger);
 Result.Options.HorzSizing:=DataSet.FieldByName('Sizing').AsBoolean;
 Result.Options.Moving:= DataSet.FieldByName('Moving').AsBoolean;
// Result.Tag:=DataSet.FieldByName('AppColumnsID').AsInteger;
 Result.Options.Filtering := DataSet.FieldByName('Filter').AsBoolean;
 Result.Position.BandIndex := FView.Bands.Count - 1;
 Result.Options.VertSizing:=False;
 Result.HeaderHint:=DataSet.FieldByName('HeaderHint').AsString;

 SortOrder:=DataSet.FieldByName('SortOrder').AsInteger;

 if SortOrder>=ColumnSortingDisabled  then
  Result.Options.Sorting:=False
   else
  Result.SortOrder:=TcxGridSortOrder(SortOrder);


// Result.Data:=1;

// Result.Options.Sorting:=True;
end;

procedure TMiceGridColumnBuilder.CreateMissingColumn(Field: TField);
var
  Column:TcxGridDBBandedColumn;
begin
 if (FView.DataController.GetItemByFieldName(Field.FieldName) = nil) then
 begin
   Column:=FView.CreateColumn;
   Column.DataBinding.FieldName:=Field.FieldName;
   Column.Width:=80;
   Column.Visible:=False;
   Column.Options.Filtering := False;
   Column.Options.HorzSizing:=True;
  // Column.Name:=View.Name + '_' + trim(cds.Fields[i].FieldName);
   Column.Caption:=Field.FieldName;
 end;
end;

procedure TMiceGridColumnBuilder.CreateMissingColumns;
var
 x:Integer;
 DataSet:TDataSet;
begin
FView.BeginUpdate;
FView.DataController.BeginUpdateFields;
 try
  DataSet:=FView.DataController.DataSource.DataSet;
  if Assigned(DataSet) then
   for x := 0 to DataSet.FieldCount - 1 do
    CreateMissingColumn(DataSet.Fields[x]);

  MapHintColumns;
 finally
  FView.EndUpdate;
  FView.DataController.EndUpdateFields;
 end;
end;



procedure TMiceGridColumnBuilder.InternalCreateBand(var FirstBand:Boolean);
var
  Band: TcxGridBand;
begin
 if FirstBand then
  Band:=FView.Bands[0]
   else
  Band:=FView.Bands.Add;
  Band.Width:=DataSet.FieldByName('Width').AsInteger;
  Band.Alignment:=TAlignment(DataSet.FieldByName('Align').AsInteger);
  Band.FixedKind:=TcxGridBandFixedKind(DataSet.FieldByName('Fixed').AsInteger);
  Band.Options.Sizing:=DataSet.FieldByName('Sizing').AsBoolean;
  Band.Caption:=DataSet.FieldByName('Caption').AsString;
  Band.Options.Moving:=DataSet.FieldByName('Moving').AsBoolean;
  Band.Styles.Header:=DefaultLookAndFeel.StyleGridBand;
  FView.OptionsView.BandHeaders := True;
  FirstBand:=False;
end;

procedure TMiceGridColumnBuilder.InternalCreateColumn;
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

procedure TMiceGridColumnBuilder.LoadFromDataSet;
var
 FirstBand:Boolean;
begin
 try
   FirstBand:=True;
   FView.BeginUpdate;
   FView.DataController.BeginUpdateFields;
   DataSet.DisableControls;
   DataSet.First;
   while not DataSet.Eof do
    begin
      if DataSet.FieldByName('IsBand').AsBoolean then
       InternalCreateBand(FirstBand)
        else
       InternalCreateColumn;
      DataSet.Next;
    end;
 finally
  FView.EndUpdate;
  FView.DataController.EndUpdateFields;
 end;
end;


procedure TMiceGridColumnBuilder.MapHintColumns;
var
 Col:TcxGridDBBandedColumn;
 HintCol:TcxCustomGridTableItem;
 x:Integer;
begin
 for x:=0 to FView.ColumnCount-1 do
  begin
    Col:=FView.Columns[x];
    HintCol:=FView.DataController.GetItemByFieldName(Col.DataBinding.FieldName+'_hint');
    if Assigned(HintCol) then
     begin
      Col.Tag:=HintCol.Index;
      Col.OnGetCellHint:=Self.DoOnGetCellHint;
     end;
  end;
end;

procedure TMiceGridColumnBuilder.DoOnGetCellHint(Sender: TcxCustomGridTableItem;
  ARecord: TcxCustomGridRecord; ACellViewInfo: TcxGridTableDataCellViewInfo;
  const AMousePos: TPoint; var AHintText: TCaption;
  var AIsHintMultiLine: Boolean; var AHintTextRect: TRect);
var
 HintCol:TcxGridDBBandedColumn;
begin
  HintCol:=FView.Columns[Sender.Tag];
  if TStringUtils.SameString(HintCol.Caption,HintCol.DataBinding.FieldName) then
  AHintText:=VarToStr(ARecord.Values[Sender.Tag])
   else
  AHintText:=HintCol.Caption+#13+VarToStr(ARecord.Values[Sender.Tag]);
end;

procedure TMiceGridColumnBuilder.SetColumnPropertiesCheckBox;
begin
 FColumn.PropertiesClass := TcxCheckBoxProperties;
 SetPropertiesCheckBox(FColumn.Properties);
end;

procedure TMiceGridColumnBuilder.SetColumnPropertiesCurrency;
begin
 FColumn.PropertiesClass := TcxImageComboBoxProperties;;
 SetPropertiesCurrency(FColumn.Properties);
end;

procedure TMiceGridColumnBuilder.SetColumnPropertiesDate;
begin
 FColumn.PropertiesClass := TcxDateEditProperties;
 SetPropertiesDate(FColumn.Properties);
end;

procedure TMiceGridColumnBuilder.SetColumnPropertiesDropDown;
begin
 FColumn.PropertiesClass := TcxImageComboBoxProperties;
 Self.SetPropertiesDropDown(FColumn.Properties);
end;

procedure TMiceGridColumnBuilder.SetColumnPropertiesImageIndex;
begin
 FColumn.PropertiesClass := TcxImageComboBoxProperties;
 SetPropertiesImageIndex(FColumn.Properties);
 FColumn.Options.Editing:=False;
end;

procedure TMiceGridColumnBuilder.SetColumnPropertiesText;
begin
 FColumn.PropertiesClass := TcxTextEditProperties;
 SetPropertiesText(FColumn.Properties);
end;

class procedure TMiceGridColumnBuilder.SetStyles( View: TcxGridDBBandedTableView);
begin
 View.Styles.Background:=DefaultLookAndFeel.StyleGridBack;
end;

procedure TMiceGridColumnBuilder.SetColumnPropertiesCurrencyNumber;
begin
 FColumn.PropertiesClass := TcxCurrencyEditProperties;
 SetPropertiesCurrencyNumber(FColumn.Properties);
end;


procedure TMiceGridColumnBuilder.SetColumnPropertiesPicture;
begin
 FColumn.PropertiesClass := TcxImageProperties;
 SetPropertiesPicture(FColumn.Properties);
 (FColumn.Properties as TcxImageProperties).OnGetGraphicClass := TMiceGridHelper.GetGraphicClass;
 (FColumn.Properties as TcxImageProperties).GraphicClass := nil;
end;

procedure TMiceGridColumnBuilder.SetColumnPropertiesPopupPicture;
begin
 FColumn.PropertiesClass := TcxBLOBEditProperties;
 Self.SetPropertiesPopupPicture(FColumn.Properties);
 (FColumn.Properties as TcxBLOBEditProperties).OnGetGraphicClass:= TMiceGridHelper.GetGraphicClass;
 (FColumn.Properties as TcxBLOBEditProperties).PictureGraphicClass := nil;
end;

procedure TMiceGridColumnBuilder.SetColumnPropertiesSubAccounts;
begin
 FColumn.PropertiesClass := TcxTextEditProperties;
 FColumn.OnGetDisplayText:= TMiceGridHelper.FormatSubAccount;
//FColumn.Width:=GetTextWidth('40817 810 9 0000 0000005',Font)+15
end;

end.
