unit CustomControl.MiceFlowChart.FlowObjects;

interface

uses
  Windows, SysUtils, Variants, Classes, dxflchrt,  dxXMLDoc, dxFlowChartShapes, dxCore,
  cxGraphics, cxDrawTextUtils, Vcl.Graphics, System.Types, System.UITypes, Data.DB,
  dxGDIPlusClasses, dxLines, cxGeometry,
  Common.Images;

type
 TMiceFlowObject = class(TdxFcObject)
  private
    FBottomCaption: string;
    FLeftDialogImageIndex: Integer;
    FEditdfMethodsId: Integer;
    FTopCaption: string;
    FRightDialogImageIndex: Integer;
    FDfPathFoldersId: Integer;
    FSimpleLabel: Boolean;
    FAppDialogsLayoutIdAfter: Integer;
    FAppDialogsLayoutIdBefore: Integer;
    FIsCommentFolder: Boolean;
    FFolderType: Integer;
    FCodeName: string;
    FCaption: string;
    procedure SetCodeName(const Value: string);
  protected
    function UserRegion(R: TRect): HRgn; override;
    procedure Load(ANode: TdxXMLNode); override;
    procedure Save(ANode: TdxXMLNode); override;
  public
    LeftDialogRect: TRect;
    RightDialogRect: TRect;
    procedure LoadFromDataSet(DataSet:TDataSet);
    property IsCommentFolder:Boolean read FIsCommentFolder write FIsCommentFolder;
    property SimpleLabel: Boolean read FSimpleLabel write FSimpleLabel;
    property DfPathFoldersId: Integer read FDfPathFoldersId write FDfPathFoldersId;
    property EditdfMethodsId: Integer read FEditdfMethodsId write FEditdfMethodsId;
    property LeftDialogImageIndex: Integer read FLeftDialogImageIndex write FLeftDialogImageIndex;
    property RightDialogImageIndex: Integer read FRightDialogImageIndex write FRightDialogImageIndex;
    property TopCaption: string read FTopCaption write FTopCaption;
    property BottomCaption: string read FBottomCaption write FBottomCaption;
    property AppDialogsLayoutIdBefore: Integer read FAppDialogsLayoutIdBefore write FAppDialogsLayoutIdBefore;
    property AppDialogsLayoutIdAfter: Integer read FAppDialogsLayoutIdAfter write FAppDialogsLayoutIdAfter;
    property FolderType:Integer read FFolderType write FFolderType;
    property Caption:string read FCaption write FCaption;
    property CodeName:string read FCodeName write SetCodeName;
  end;


  TMiceFlowConnector = class(TdxFcConnection)
  private
    FHint: string;
    FSecondaryImageIndex: Integer;
    FImageIndex: Integer;
    FdfMethodsId: Integer;
    FdfPathFoldersIdSource: Integer;
    FdfPathFoldersIdTarget: Integer;
    FTextXOffset: Integer;
    FTextYOffset: Integer;
    procedure SetTextXOffset(const Value: Integer);
    procedure SetTextYOffset(const Value: Integer);
    procedure PaintImageEx(Images: TcxImageList);
    procedure SetImageIndex(const Value: Integer);
    function RealStyle: TdxFclStyle;
  protected
// function GetActualPenWidth: Single; virtual;
// procedure DrawContent(ACanvas: TcxCanvas); virtual;
// procedure DrawLine(AGraphics: TdxGPGraphics); virtual;
// procedure DrawText(ACanvas: TcxCanvas); virtual;
// procedure Paint(ACanvas: TcxCanvas; Upper: Boolean); virtual;

    procedure DrawLine(AGraphics: TdxGPGraphics); override;
    procedure DrawText(ACanvas: TcxCanvas); override;
    procedure DrawContent(ACanvas: TcxCanvas); override;
    procedure Load(ANode: TdxXMLNode); override;
    procedure Save(ANode: TdxXMLNode); override;
    function GetDrawRect:TRect;
  public
    procedure LoadFromDataSet(DataSet:TDataSet);
    property TextXOffset:Integer read FTextXOffset write SetTextXOffset;
    property TextYOffset:Integer read FTextYOffset write SetTextYOffset;
    property Hint: string read FHint write FHint;
    property ImageIndex: Integer read FImageIndex write SetImageIndex;
    property SecondaryImageIndex: Integer read FSecondaryImageIndex write FSecondaryImageIndex;
    property dfMethodsId:Integer read FdfMethodsId write FdfMethodsId;
    property dfPathFoldersIdSource:Integer read FdfPathFoldersIdSource write FdfPathFoldersIdSource;
    property dfPathFoldersIdTarget:Integer read FdfPathFoldersIdTarget write FdfPathFoldersIdTarget;
  end;



   { TdxFlowChartShapeInfo }

  TdxFlowChartShapeInfo = class
  private
    FAdvancedShape: TdxFlowChartObjectAdvancedShape;
    FShapeType: TdxFcShapeType;
  public
    property AdvancedShape: TdxFlowChartObjectAdvancedShape read FAdvancedShape;
    property ShapeType: TdxFcShapeType read FShapeType;
  public
    constructor Create(AShapeType: TdxFcShapeType; AAdvancedShape: TdxFlowChartObjectAdvancedShape = nil);
  end;

implementation

type
 TdxCustomFlowChartAccesss = class(TdxCustomFlowChart)
 end;

{ TMiceFlowObject }

procedure TMiceFlowObject.Load(ANode: TdxXMLNode);
var
  AAttributes: TdxXMLNodeAttributes;
begin
  inherited;
  AAttributes := ANode.Attributes;
  DfPathFoldersId := AAttributes.GetValueAsInteger('dfPathFoldersId');
  IsCommentFolder:=AAttributes.GetValueAsBoolean('IsCommentFolder');
  Caption:=AAttributes.GetValueAsString('Caption');
  CodeName:=AAttributes.GetValueAsString('CodeName');
end;

procedure TMiceFlowObject.LoadFromDataSet(DataSet: TDataSet);
begin

end;

procedure TMiceFlowObject.Save(ANode: TdxXMLNode);
var
  AAttributes: TdxXMLNodeAttributes;
begin
  inherited;
  AAttributes := ANode.Attributes;
  AAttributes.SetValueAsInteger('dfPathFoldersId', dfPathFoldersId);
  AAttributes.SetValueAsBoolean('IsCommentFolder',IsCommentFolder);
  AAttributes.SetValueAsString('Caption',Caption);
  AAttributes.SetValueAsString('CodeName',CodeName);
end;

procedure TMiceFlowObject.SetCodeName(const Value: string);
begin
  FCodeName := Value;
  //if not CodeName.IsEmpty then
//   Text:=Caption+' ('+CodeName+')';
end;

function TMiceFlowObject.UserRegion(R: TRect): HRgn;
begin
 Result:=inherited UserRegion(R);
end;

{ TMiceFlowConnector }

procedure TMiceFlowConnector.PaintImageEx(Images: TcxImageList);
var
  R: TRect;
begin
  R := GetDrawRect;
  Owner.Canvas.DrawImage(Images,R.Left+(R.Width div 2)-(Images.Width div 2),R.Top-Images.Height-5,ImageIndex);
end;

procedure TMiceFlowConnector.DrawContent(ACanvas: TcxCanvas);
begin
 inherited;
 if ImageIndex>0 then
  PaintImageEx(ImageContainer.Images16);
end;


function TMiceFlowConnector.RealStyle: TdxFclStyle;
begin
  if (Style = fclCurved) and (RealCount < 3) then
    Result := fclStraight
  else
    Result := Style;
end;


procedure TMiceFlowConnector.DrawLine(AGraphics: TdxGPGraphics);
const
  TextIndent = 1;
var
  P: TPoints;
begin
// Код из старых девэкспрессов - рисует линии без пропуска для текста.
  FRealPoints.CalculatePolyline(TLineType(RealStyle), P);
  TdxCustomFlowChartAccesss(Owner).Painter.DrawPolyline(AGraphics, P, Color, PenStyle, GetActualPenWidth, TdxCustomFlowChartAccesss(Owner).PaintScaleFactor.ApplyF(1));
  P := nil;

// Ниже код из новых девэкспресс 20+, они переделали эту процедуру рисования
// Она теперь рисует пустой прямоугольник для текста на линии
// Но поскольку Майс может двигать текст, она просто рисует пустое место на пути
// Странное решение.

{  if Text <> '' then
  begin
    AGraphics.SaveClipRegion;
    AGraphics.SetClipRect(GetExcludeTextBounds, gmExclude);
  end;
  FRealPoints.CalculatePolyline(TLineType(RealStyle), P);
  TdxCustomFlowChartAccesss(Owner).Painter.DrawPolyline(AGraphics, P, Color, PenStyle, GetActualPenWidth,
    TdxCustomFlowChartAccesss(Owner).PaintScaleFactor.ApplyF(1));
  P := nil;
  if Text <> '' then
    AGraphics.RestoreClipRegion;

}
end;

procedure TMiceFlowConnector.DrawText(ACanvas: TcxCanvas);
const
  TextIndent = 1;
var
  R: TRect;
begin
  if Text <> '' then
  begin
    R:=GetDrawRect;
    ACanvas.FillRect(R, TdxCustomFlowChartAccesss(Owner).BackgroundColor);
    cxTextOut(ACanvas.Handle, Text, R, CXTO_CENTER_HORIZONTALLY or CXTO_CENTER_VERTICALLY, RealFont, 0, TextIndent, TextIndent);
  end;
end;

function TMiceFlowConnector.GetDrawRect: TRect;
const
  TextIndent = 1;
begin
 Result:=RealTextRect;
 Result.Inflate(TextIndent, 0);
 Result.Offset(TextXOffset, TextYOffset);
end;

procedure TMiceFlowConnector.Load(ANode: TdxXMLNode);
var
  AAttributes: TdxXMLNodeAttributes;
begin
  inherited;
  AAttributes := ANode.Attributes;
  dfMethodsId:=AAttributes.GetValueAsInteger('dfMethodsId');
  dfPathFoldersIdSource:=AAttributes.GetValueAsInteger('dfPathFoldersIdSource');
  dfPathFoldersIdTarget:=AAttributes.GetValueAsInteger('dfPathFoldersIdTarget');
  TextXOffset:=AAttributes.GetValueAsInteger('TextXOffset');
  TextYOffset:=AAttributes.GetValueAsInteger('TextYOffset');
  ImageIndex:=AAttributes.GetValueAsInteger('ImageIndex');
  Hint:=AAttributes.GetValueAsString('Hint');
end;


procedure TMiceFlowConnector.LoadFromDataSet(DataSet: TDataSet);
begin
 Text:=DataSet.FieldByName('Caption').AsString;

 if DataSet.FieldByName('AllowRollback').AsBoolean=True then
  ArrowSource.ArrowType:=TdxFcaType.fcaArrow
   else
  ArrowSource.ArrowType:=TdxFcaType.fcaNone;

 if DataSet.FieldByName('IsDefault').AsBoolean = True then
  PenWidth:=4
   else
  PenWidth:=2;

 if DataSet.FieldByName('AllowDesktop').AsBoolean = True then
  PenStyle:=TPenStyle.psSolid
   else
  PenStyle:=TPenStyle.psDash;

 if DataSet.FieldByName('Active').AsBoolean then
  Font.Style:=[]
   else
  Font.Style:=[fsStrikeOut];

 if DataSet.FieldByName('ImageIndex').AsInteger>0 then
  ImageIndex:=DataSet.FieldByName('ImageIndex').AsInteger
   else
  ImageIndex:=-1;
end;

procedure TMiceFlowConnector.Save(ANode: TdxXMLNode);
var
  AAttributes: TdxXMLNodeAttributes;
begin
  inherited;
  AAttributes := ANode.Attributes;
  AAttributes.SetValueAsInteger('dfMethodsId', dfMethodsId);
  AAttributes.SetValueAsInteger('dfPathFoldersIdSource', dfPathFoldersIdSource);
  AAttributes.SetValueAsInteger('dfPathFoldersIdTarget', dfPathFoldersIdTarget);
  AAttributes.SetValueAsInteger('ImageIndex', ImageIndex);
  AAttributes.SetValueAsString('Hint',Hint);
  AAttributes.SetValueAsInteger('TextXOffset', TextXOffset);
  AAttributes.SetValueAsInteger('TextYOffset', TextYOffset);
end;

procedure TMiceFlowConnector.SetImageIndex(const Value: Integer);
begin
  FImageIndex := Value;
  Owner.Repaint;
end;

procedure TMiceFlowConnector.SetTextXOffset(const Value: Integer);
begin
  FTextXOffset := Value;
//  DrawText(Owner.Canvas);
  Owner.Repaint;
end;

procedure TMiceFlowConnector.SetTextYOffset(const Value: Integer);
begin
  FTextYOffset := Value;
//  DrawText(Owner.Canvas);
  Owner.Repaint;
end;

{ TdxFlowChartShapeInfo }

constructor TdxFlowChartShapeInfo.Create(AShapeType: TdxFcShapeType; AAdvancedShape: TdxFlowChartObjectAdvancedShape = nil);
begin
  inherited Create;
  FShapeType := AShapeType;
  FAdvancedShape := AAdvancedShape;
end;

end.
