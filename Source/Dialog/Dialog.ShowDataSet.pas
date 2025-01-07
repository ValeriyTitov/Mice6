unit Dialog.ShowDataSet;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Dialog.Basic, cxGraphics,
  cxLookAndFeels, cxLookAndFeelPainters, Vcl.Menus, Vcl.StdCtrls, cxButtons,
  Vcl.ExtCtrls, cxControls, cxStyles, cxCustomData, cxFilter, cxData,
  cxDataStorage, cxEdit, cxNavigator, dxDateRanges, dxScrollbarAnnotations,
  Data.DB, cxDBData, cxGridCustomView, cxGridCustomTableView, cxGridTableView,
  cxGridBandedTableView, cxGridDBBandedTableView, cxClasses, cxGridLevel, cxGrid,
  CustomControl.MiceGrid,
  Common.Images,
  Common.ResourceStrings,
  CustomControl.MiceGrid.ColorBuilder, dxBar, cxContainer, Vcl.ComCtrls, dxCore,
  cxDateUtils, cxMaskEdit, cxDropDownEdit, cxCalendar, cxTextEdit,
  System.Actions, Vcl.ActnList;

type
  TcxGrid = class (TMiceGrid)

  end;

  TShowDatasetDialog = class(TBasicDialog)
    pnTop: TPanel;
    Image: TImage;
    lbInfo: TLabel;
    lbRows: TLabel;
    DataSource: TDataSource;
    lbColumns: TLabel;
    dxBar: TdxBarManager;
    GridPopupMenu: TdxBarPopupMenu;
    bnColumns: TdxBarSubItem;
    bnShowAll: TdxBarButton;
    bnHideAll: TdxBarButton;
    bnAutoWidth: TdxBarButton;
    lbDataSetIsNil: TLabel;
    MainGrid: TcxGrid;
    MainView: TcxGridDBBandedTableView;
    MainLevel: TcxGridLevel;
    ActionList1: TActionList;
    acShowAll: TAction;
    acHideAll: TAction;
    acAutoWidth: TAction;
    dxBarSeparator1: TdxBarSeparator;
    procedure MainViewCustomDrawCell(Sender: TcxCustomGridTableView;
      ACanvas: TcxCanvas; AViewInfo: TcxGridTableDataCellViewInfo;
      var ADone: Boolean);
    procedure acShowAllExecute(Sender: TObject);
    procedure acHideAllExecute(Sender: TObject);
    procedure acAutoWidthExecute(Sender: TObject);
  private
    FDataSet: TDataSet;
    FImageIndex: Integer;
    procedure SetDataSet(const Value: TDataSet);
    procedure DestroyColumnsMenu;
    procedure CreateColumnsMenu;
    procedure UpdateWidth;
    procedure SetColumnProps(Column:TcxGridDBBandedColumn);
    procedure ToggleVisible(Sender: TObject);
    procedure UpdateRuntimeButtons;
    procedure UpdateInformation;
    procedure SetImageIndex(const Value: Integer);
    procedure Open;
  public
    property DataSet:TDataSet read FDataSet write SetDataSet;
    property ImageIndex:Integer read FImageIndex write SetImageIndex;
    function ExecuteDialog:Boolean;
    class procedure ShowDataSet(DataSet:TDataSet);
    class procedure ShowDataSetEx(DataSet:TDataSet; const WindowCaption, LabelCaption:string; AImageIndex:Integer);
    constructor CreateDefault(const WindowCaption, LabelCaption: string; AImageIndex: Integer; AReadOnly:Boolean);
  end;

procedure ShowDataSet(DataSet:TDataSet);

implementation

procedure ShowDataSet(DataSet:TDataSet);
begin
 TShowDatasetDialog.ShowDataSet(DataSet);
end;

{$R *.dfm}

{ TShowDatasetDialog }
const
 RUNTIME_BUTTON = 666;

procedure TShowDatasetDialog.acAutoWidthExecute(Sender: TObject);
begin
 MainView.OptionsView.ColumnAutoWidth:=Self.acAutoWidth.Checked;
end;

procedure TShowDatasetDialog.acHideAllExecute(Sender: TObject);
var
 x:Integer;
begin
 for x:=0 to MainView.ColumnCount-1 do
  if x>0 then
    MainView.Columns[x].Visible:=False;
  UpdateRuntimeButtons;
end;


procedure TShowDatasetDialog.acShowAllExecute(Sender: TObject);
var
 x:Integer;
begin
 for x:=0 to MainView.ColumnCount-1 do
    MainView.Columns[x].Visible:=True;
 UpdateRuntimeButtons;
end;

procedure TShowDatasetDialog.CreateColumnsMenu;
var
 x:Integer;
 Btn:TdxBarButton;
 Col:TcxGridDBBandedColumn;
begin
 for x:=0 to MainView.ColumnCount-1 do
   begin
    Col:=MainView.Columns[x];
    Btn:=TdxBarButton.Create(dxBar);
    Btn.Caption:=Col.Caption;
    Btn.ButtonStyle:=bsChecked;
    Btn.Down:=True;
    Btn.Data:=Col;
    Btn.Tag:=RUNTIME_BUTTON;
    Btn.CloseSubMenuOnClick:=False;
    Btn.OnClick:=ToggleVisible;
    bnColumns.ItemLinks.Add.Item:=Btn;
   end;
end;

constructor TShowDatasetDialog.CreateDefault(const WindowCaption, LabelCaption: string; AImageIndex: Integer; AReadOnly: Boolean);
begin
 Create(Application);
 lbInfo.Caption:=LabelCaption;
 Caption:=WindowCaption;
 pnTop.Visible:=LabelCaption.Trim.IsEmpty=False;
 ImageIndex:=AImageIndex;
 ReadOnly:=AReadOnly;
 TImageContainer.LoadToImage(Image, ImageIndex);
end;

procedure TShowDatasetDialog.DestroyColumnsMenu;
begin

end;

function TShowDatasetDialog.ExecuteDialog: Boolean;
begin
 LoadState(False,True);
 if not Assigned(DataSet) then
   MainGrid.Visible:=False
    else
   Open;

  Result:=ShowModal=mrOk;
end;

procedure TShowDatasetDialog.MainViewCustomDrawCell( Sender: TcxCustomGridTableView; ACanvas: TcxCanvas;  AViewInfo: TcxGridTableDataCellViewInfo; var ADone: Boolean);
begin
 TMiceGridColors.DefaultDrawGridCell(Sender,ACanvas,AViewInfo,ADone);
end;


procedure TShowDatasetDialog.Open;
begin
 MainView.BeginUpdate();
 DataSource.DataSet:=DataSet;
 DataSet.Open;
 try
  MainView.DataController.CreateAllItems(True);
  DestroyColumnsMenu;
  CreateColumnsMenu;
  UpdateWidth;
  UpdateInformation;
 finally
   MainView.EndUpdate;
 end;
end;

procedure TShowDatasetDialog.SetDataSet(const Value: TDataSet);
begin
  FDataSet := Value;
end;

procedure TShowDatasetDialog.SetImageIndex(const Value: Integer);
begin
  FImageIndex := Value;
end;

class procedure TShowDatasetDialog.ShowDataSet(DataSet: TDataSet);
begin
 ShowDataSetEx(DataSet,  Application.Title, S_COMMON_DATASET_CONTENTS, IMAGEINDEX_INFORMATION);
end;

class procedure TShowDatasetDialog.ShowDataSetEx(DataSet: TDataSet; const WindowCaption, LabelCaption: string; AImageIndex:Integer);
var
 Dlg:TShowDatasetDialog;
begin
 Dlg:=TShowDatasetDialog.CreateDefault(WindowCaption, LabelCaption,AImageIndex, True);
  try
   Dlg.DataSet:=DataSet;
   Dlg.ExecuteDialog;
   Dlg.SaveState;
  finally
   Dlg.Free;
  end;
end;

procedure TShowDatasetDialog.ToggleVisible(Sender: TObject);
var
 Btn:TdxBarButton;
 Col:TcxGridDBBandedColumn;
begin
 Btn:=Sender as TdxBarButton;
 Col:=Btn.Data as TcxGridDBBandedColumn;
 Col.Visible:=Btn.Down;
end;

procedure TShowDatasetDialog.SetColumnProps(Column: TcxGridDBBandedColumn);
begin
 Column.PropertiesClass := TcxTextEditProperties;
 Column.Properties.ReadOnly := True;
 Column.Properties.Alignment.Horz:=taLeftJustify;

 if (Column.DataBinding.Field.DataType = ftBoolean) then
  Column.Width := 32;

 if (Column.DataBinding.Field.DataType = ftDateTime) then
  begin
   Column.Width := 60;
   Column.PropertiesClass := TcxDateEditProperties;
   (Column.Properties as TcxDateEditProperties).ReadOnly:=True;
   (Column.Properties as TcxDateEditProperties).DateButtons:=[];
  end;

 if (Column.DataBinding.Field.Size < 21) and (Column.DataBinding.Field.DataType = ftString) then
  Column.Width := (Column.DataBinding.Field.Size) * 3;

 if Column.Width > 100 then
  Column.Width := 100;
end;


procedure TShowDatasetDialog.UpdateInformation;
begin
 Self.lbColumns.Caption:=Format(S_COLUMNS_FMT,[DataSet.FieldCount]);
 Self.lbRows.Caption:=Format(S_ROWS_FMT,[DataSet.RecordCount]);
end;

procedure TShowDatasetDialog.UpdateRuntimeButtons;
var
 x:Integer;
 ItemLink: TdxBarItemLink;
begin
 for x:=0 to bnColumns.ItemLinks.Count-1 do
  begin
   ItemLink:=bnColumns.ItemLinks[x];
   if Assigned(ItemLink.Item) and (ItemLink.Item.Tag=RUNTIME_BUTTON) then
    (ItemLink.Item as TdxBarButton).Down:=(ItemLink.Item.Data as TcxGridDBBandedColumn).Visible;
  end;
end;

procedure TShowDatasetDialog.UpdateWidth;
var
 x: integer;
 Column:TcxGridDBBandedColumn;
begin
 for x := 0 to MainView.ColumnCount - 1 do
  begin
    Column:=MainView.Columns[x];
    SetColumnProps(Column);
  end;
end;


end.
