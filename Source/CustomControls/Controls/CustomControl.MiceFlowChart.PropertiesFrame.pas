unit CustomControl.MiceFlowChart.PropertiesFrame;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, cxContainer, cxEdit, dxCore,
  Vcl.StdCtrls, cxTextEdit, cxMaskEdit, cxDropDownEdit, dxColorEdit, cxSpinEdit,
  cxCheckBox, dxflchrt,  Generics.Collections, dxFlowChartShapes,
  System.UITypes, cxGeometry,dxGDIPlusClasses,
  CustomControl.MiceFlowChart.FlowObjects,
  CustomControl.MiceFlowChart.Shapes, cxImageComboBox, System.ImageList,
  Common.Images,
  Vcl.ImgList, cxImageList, cxClasses, dxColorDialog, Vcl.ExtCtrls, Vcl.Menus,
  cxButtons, cxMemo;
  //dxEditObj
type
  TShapePropertiesFrame = class(TFrame)
    FontDialog: TFontDialog;
    Panel1: TPanel;
    ddShapeStyle: TcxImageComboBox;
    cbTextPositionY: TcxComboBox;
    seLineWidth: TcxSpinEdit;
    cbTextPositionX: TcxComboBox;
    cbTransparent: TcxCheckBox;
    ceColor: TdxColorEdit;
    ceLineColor: TdxColorEdit;
    Label5: TLabel;
    Label4: TLabel;
    Label3: TLabel;
    Label2: TLabel;
    Label1: TLabel;
    Color: TLabel;
    Panel2: TPanel;
    memoText: TcxMemo;
    sbFont: TcxButton;
    cxButton1: TcxButton;
    cxButton2: TcxButton;
    ColorDialog: TColorDialog;
    procedure ddShapeStylePropertiesChange(Sender: TObject);
    procedure sbFontClick(Sender: TObject);
    procedure cxButton1Click(Sender: TObject);
    procedure cxButton2Click(Sender: TObject);
  private
    function FindFolderShapeIndex(Folder:TMiceFlowObject):Integer;
    function FindShapeIndex(Shape:TdxFlowChartObjectAdvancedShape):Integer;
    function CurrentEntry:TMiceGalleryShapeEntry;
  public
    procedure LoadFromObject(Obj: TdxFcObject);
    procedure SaveToObject(Obj: TdxFcObject);
    procedure SaveToMiceFlowObject(Folder:TMiceFlowObject);
    procedure LoadFromMiceFlowObject(Folder:TMiceFlowObject);
    procedure EntryChanged(Entry:TMiceGalleryShapeEntry);
    procedure PopulateForPathFolder;
    procedure PopulateForComment(List:TStringList);
  end;

implementation

{$R *.dfm}

function TShapePropertiesFrame.CurrentEntry: TMiceGalleryShapeEntry;
begin
 Result:=TMiceGalleryShapeEntry(ddShapeStyle.Properties.Items[ddShapeStyle.ItemIndex].Tag);
end;

procedure TShapePropertiesFrame.cxButton1Click(Sender: TObject);
begin
 ColorDialog.Color:=ceColor.ColorValue;
 if ColorDialog.Execute then
  ceColor.ColorValue:=ColorDialog.Color;
end;

procedure TShapePropertiesFrame.cxButton2Click(Sender: TObject);
begin
 ColorDialog.Color:=ceLineColor.ColorValue;
 if ColorDialog.Execute then
  ceLineColor.ColorValue:=ColorDialog.Color;
end;

procedure TShapePropertiesFrame.ddShapeStylePropertiesChange(Sender: TObject);
begin
 ceLineColor.ColorValue:=CurrentEntry.ShapeColor;
 ceColor.ColorValue:=CurrentEntry.BkColor;
 seLineWidth.Value:=CurrentEntry.LineWidth;
end;

procedure TShapePropertiesFrame.EntryChanged(Entry: TMiceGalleryShapeEntry);
begin
 ceColor.ColorValue:=Entry.BkColor;
 ceLineColor.ColorValue:=Entry.ShapeColor;
 seLineWidth.Value:=Entry.LineWidth;
 ddShapeStyle.ItemIndex:=TMiceShapesGalleryCollection.DefaultInstance.IndexOf(Entry);
end;

function TShapePropertiesFrame.FindFolderShapeIndex(Folder: TMiceFlowObject): Integer;
begin
 Result:=FindShapeIndex(Folder.AdvancedShape);
  if (Result=FolderTypeOnPageReference) and (Folder.BkColor=MiceDefaultEventColor) then
   case Folder.ShapeColor of
    MiceDefaultEndEventLineColor:Result:=FolderTypeEndEvent;
    MiceDefaultStartEventLineColor:Result:=FolderTypeStartEvent;
   end;
end;

function TShapePropertiesFrame.FindShapeIndex(Shape: TdxFlowChartObjectAdvancedShape): Integer;
var
 x:Integer;
begin
 for x:=0 to ddShapeStyle.Properties.Items.Count-1 do
  if (Shape.ID=TMiceGalleryShapeEntry(ddShapeStyle.Properties.Items[x].Tag).Shape.ID) then
   Exit(x);
 Result:=0;
end;

procedure TShapePropertiesFrame.PopulateForComment(List: TStringList);
var
 x:Integer;
 Item:TcxImageComboBoxItem;
begin
 for x:=0 to List.Count-1 do
  begin
   Item:=ddShapeStyle.Properties.Items.Add;
   Item.Value:=x;
   Item.ImageIndex:=x;
   Item.Description:=List[x];
   Item.Tag:=Integer(List.Objects[x]);
  end;
end;

procedure TShapePropertiesFrame.PopulateForPathFolder;
var
 Entry: TMiceGalleryShapeEntry;
 Item:TcxImageComboBoxItem;
 x:Integer;
begin
 x:=0;
 for Entry in TMiceShapesGalleryCollection.DefaultInstance do
  begin
   Item:=ddShapeStyle.Properties.Items.Add;
   Item.Value:=x;
   Item.ImageIndex:=x;
   Item.Description:=Entry.GalleryCaption;
   Item.Tag:=Integer(Entry);
   x:=x+1;
  end;
end;

procedure TShapePropertiesFrame.SaveToMiceFlowObject(Folder: TMiceFlowObject);
begin
 SaveToObject(Folder);
 Folder.AdvancedShape:=CurrentEntry.Shape;
 Folder.Width:=CurrentEntry.Width;
 Folder.Height:=CurrentEntry.Height;
end;

procedure TShapePropertiesFrame.SaveToObject(Obj: TdxFcObject);
begin
 Obj.ShapeColor:= ceLineColor.ColorValue;
 Obj.BkColor:=  ceColor.ColorValue;
 Obj.ShapeWidth:= seLineWidth.Value;
 Obj.HorzTextPos:=TdxFcHorzPos(cbTextPositionX.ItemIndex);
 Obj.VertTextPos:=TdxFcVertPos(cbTextPositionY.ItemIndex);
 Obj.Transparent:=cbTransparent.Checked;
 Obj.Font.Assign(sbFont.Font);
end;

procedure TShapePropertiesFrame.sbFontClick(Sender: TObject);
begin
 FontDialog.Font.Assign(sbFont.Font);
 if FontDialog.Execute then
  sbFont.Font.Assign(FontDialog.Font);
end;

procedure TShapePropertiesFrame.LoadFromMiceFlowObject(Folder: TMiceFlowObject);
begin
 LoadFromObject(Folder);
 ddShapeStyle.ItemIndex:=FindFolderShapeIndex(Folder);
 ddShapeStyle.Properties.OnChange:=ddShapeStylePropertiesChange;
 CurrentEntry.Width:=Folder.Width;
 CurrentEntry.Height:=Folder.Height;
end;

procedure TShapePropertiesFrame.LoadFromObject(Obj: TdxFcObject);
begin
 ceLineColor.ColorValue:=Obj.ShapeColor;
 ceColor.ColorValue:=Obj.BkColor;
 seLineWidth.Value:=Obj.ShapeWidth;
 cbTextPositionX.ItemIndex:=Ord(Obj.HorzTextPos);
 cbTextPositionY.ItemIndex:=Ord(Obj.VertTextPos);
 cbTransparent.Checked := Obj.Transparent;
 memoText.Text:=Obj.Text;
 sbFont.Font.Assign(Obj.Font);
end;



end.
