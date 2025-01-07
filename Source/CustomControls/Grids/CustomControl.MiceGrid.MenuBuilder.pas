unit CustomControl.MiceGrid.MenuBuilder;

interface

uses Data.DB, System.SysUtils, System.Classes, cxGridBandedTableView,
     cxGridDBBandedTableView, dxBar, cxCustomData,
     Common.StringUtils;
type
 TMiceGridColumnMenuBuilder = class
   private
    FView: TcxGridDBBandedTableView;
    FMenu: TdxBarSubItem;
    FKeyField: string;
    procedure FreeColumnsMenu;
    procedure BuildColumnsMenu(DataSet:TDataSet);
    procedure BuildBandsMenu;
    procedure ToggleColumnVisible(Sender:TObject);
    procedure ToggleBandVisible(Sender:TObject);
    procedure AddSummaryMenu(DataSet:TDataSet);
   public
    constructor Create(View: TcxGridDBBandedTableView; Menu: TdxBarSubItem);
    property KeyField:string read FKeyField write FKeyField;
    procedure BuildMenu(DataSet:TDataSet);
   end;

implementation

{ TMiceGridColumnMenuBuilder }

procedure TMiceGridColumnMenuBuilder.AddSummaryMenu(DataSet: TDataSet);
begin
end;

procedure TMiceGridColumnMenuBuilder.BuildBandsMenu;
var
 x:Integer;
 Button:TdxBarButton;
 Band: TcxGridBand;
begin
if FView.Bands.Count>1 then
 for x:=0 to Self.FView.Bands.Count-1 do
  begin
   Band:=FView.Bands[x];
   Button:=TdxBarButton.Create(FMenu);
   Button.Caption:=Band.Caption;
   Button.Tag:=Integer(Band);
   Button.ButtonStyle:=bsChecked;
   Button.OnClick:=ToggleColumnVisible;
   Button.CloseSubMenuOnClick:=False;
   Button.ImageIndex:=271;
   Button.OnClick:=ToggleBandVisible;
   Button.Down:=Band.Visible;
   FMenu.ItemLinks.Add(Button);
  end;
end;

procedure TMiceGridColumnMenuBuilder.BuildColumnsMenu(DataSet:TDataSet);
var
 Field:TField;
 Button:TdxBarButton;
 Column:TcxGridDBBandedColumn;
begin
 for Field in DataSet.Fields do
  begin
   Column:=FView.GetColumnByFieldName(Field.FieldName);
    if Assigned(Column) then
     begin
       Button:=TdxBarButton.Create(FMenu);
       Button.ButtonStyle:=bsChecked;
       Button.Tag:=Integer(Column);
       Button.CloseSubMenuOnClick:=False;
       Button.Down:=Column.Visible;
       Button.OnClick:=ToggleColumnVisible;
       Button.Caption:=Field.FieldName;
       if Button.Caption<>Column.Caption then
        Button.Caption:=Button.Caption+' ('+Column.Caption+')';
       if TStringUtils.SameString(Column.DataBinding.FieldName,Self.KeyField) then
        Button.ImageIndex:=637;

       FMenu.ItemLinks.Add(Button);
     end;
  end;
end;

procedure TMiceGridColumnMenuBuilder.BuildMenu(DataSet:TDataSet);
begin
 Self.FreeColumnsMenu;
 Self.BuildBandsMenu;
 Self.BuildColumnsMenu(DataSet);
end;

constructor TMiceGridColumnMenuBuilder.Create(View: TcxGridDBBandedTableView; Menu: TdxBarSubItem);
begin
 FView:=View;
 FMenu:=Menu;
end;

procedure TMiceGridColumnMenuBuilder.FreeColumnsMenu;
var
 x:Integer;
begin
 for x:=FMenu.ItemLinks.Count-1 downto 0 do
  FMenu.ItemLinks[x].Free;
end;

procedure TMiceGridColumnMenuBuilder.ToggleBandVisible(Sender: TObject);
var
 Menu:TdxBarButton;
 Band: TcxGridBand;
begin
 Menu:=(Sender as TdxBarButton);
 Band:= TcxGridBand(Menu.Tag);
 Band.Visible:=Menu.Down;
end;

procedure TMiceGridColumnMenuBuilder.ToggleColumnVisible(Sender: TObject);
var
 Menu:TdxBarButton;
 Column:TcxGridDBBandedColumn;
begin
 Menu:=(Sender as TdxBarButton);
 Column:=TcxGridDBBandedColumn(Menu.Tag);
 Column.Visible:=Menu.Down;
end;

end.
