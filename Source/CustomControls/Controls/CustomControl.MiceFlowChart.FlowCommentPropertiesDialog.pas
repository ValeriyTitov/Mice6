unit CustomControl.MiceFlowChart.FlowCommentPropertiesDialog;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Dialog.Basic, cxGraphics,
  cxLookAndFeels, cxLookAndFeelPainters, Vcl.Menus,
  CustomControl.MiceFlowChart.PropertiesFrame, Vcl.StdCtrls, cxButtons,
  Vcl.ExtCtrls, dxflchrt,  Generics.Collections, dxFlowChartShapes,
  Common.Images, cxClasses, dxColorDialog;

type
  TFlowCommentPropertiesDialog = class(TBasicDialog)
    ShapeFrame: TShapePropertiesFrame;
    dxColorDialog1: TdxColorDialog;
    dxColorDialog2: TdxColorDialog;
  private
   function FindShapeIndex(Shape:TdxFlowChartObjectAdvancedShape):Integer;
  public
   class procedure PopulateForComment(List:TStringList);
   procedure Load(Images:TcxImageList; List:TStringList);
   procedure LoadObject(Obj: TdxFcObject);
   procedure SaveObject(Obj: TdxFcObject);
  end;

implementation

{$R *.dfm}

{ TFlowCommentPropertiesDialog }

function TFlowCommentPropertiesDialog.FindShapeIndex(Shape: TdxFlowChartObjectAdvancedShape): Integer;
var
 x:Integer;
 Candidate: TdxFlowChartObjectAdvancedShape;
begin
 for x:=0 to ShapeFrame.ddShapeStyle.Properties.Items.Count-1 do
  begin
   Candidate:=TdxFlowChartObjectAdvancedShape(ShapeFrame.ddShapeStyle.Properties.Items[x].Tag);
   if Candidate.ID=Shape.ID then
    Exit(x);
  end;
  Result:=0;
end;

procedure TFlowCommentPropertiesDialog.Load(Images: TcxImageList; List:TStringList);
begin
 ShapeFrame.ddShapeStyle.Properties.Images:=Images;
 ShapeFrame.PopulateForComment(List);
end;

procedure TFlowCommentPropertiesDialog.LoadObject(Obj: TdxFcObject);
begin
 ShapeFrame.LoadFromObject(Obj);
 ShapeFrame.ddShapeStyle.ItemIndex:=FindShapeIndex(Obj.AdvancedShape);
end;

class procedure TFlowCommentPropertiesDialog.PopulateForComment( List: TStringList);
var
  AShapeIndex, AStencilIndex: Integer;
  AShape: TdxFlowChartObjectAdvancedShape;
  AStencil: TdxFlowChartAdvancedShapeStencil;
begin
  for AStencilIndex := 0 to TdxFlowChart.Repository.StencilCount - 1 do
  begin
    AStencil := TdxFlowChart.Repository.Stencils[AStencilIndex];
    for AShapeIndex := 0 to AStencil.Count - 1 do
    begin
      AShape := AStencil.Shapes[AShapeIndex];
      List.AddObject(AShape.Caption, AShape);
    end;
  end;
end;

procedure TFlowCommentPropertiesDialog.SaveObject(Obj: TdxFcObject);
begin
 ShapeFrame.SaveToObject(Obj);
 Obj.AdvancedShape:=TdxFlowChartObjectAdvancedShape(ShapeFrame.ddShapeStyle.Properties.Items[ShapeFrame.ddShapeStyle.ItemIndex].Tag);
 Obj.Text:=ShapeFrame.memoText.Text;
end;

end.
