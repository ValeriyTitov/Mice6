unit CustomControl.MiceFlowChart.Shapes;

interface
uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,  Forms,
  dxflchrt,  cxClasses,  Generics.Collections, dxFlowChartShapes,
  System.UITypes, cxGeometry, Dialogs,
  CustomControl.MiceFlowChart.FlowObjects;


type
 TMiceGalleryShapeEntry = class
  strict private
    FShape: TdxFlowChartObjectAdvancedShape;
    FShapeColor: TColor;
    FLineWidth: Integer;
    FGalleryCaption: string;
    FBkColor: TColor;
    FWidth: Integer;
    FHeight: Integer;
    FFolderType: Integer;
    FImageIndex: Integer;
    FDevDescription: string;
 public
    property Shape:TdxFlowChartObjectAdvancedShape read FShape;
    property ShapeColor:TColor read FShapeColor write FShapeColor;
    property BkColor:TColor read FBkColor write FBkColor;
    property LineWidth:Integer read FLineWidth write FLineWidth;
    property GalleryCaption:string read FGalleryCaption write FGalleryCaption;
    property Width:Integer read FWidth write FWidth;
    property Height:Integer read FHeight write FHeight;
    property FolderType:Integer read FFolderType write FFolderType;
    property ImageIndex:Integer read FImageIndex write FImageIndex;
    property DevDescription:string read FDevDescription write FDevDescription;

    constructor Create(AShape:TdxFlowChartObjectAdvancedShape);
    procedure ToObject(Obj:TdxFcObject);
 end;

 TMiceShapesGalleryCollection = class (TObjectList<TMiceGalleryShapeEntry>)
 private
    FRepo:TdxFlowChartBasicFlowchartShapes;
    procedure AddProcess;
    procedure AddSubProcess;
    procedure AddDocument;
    procedure AddEndEvent;
    procedure AddStartEvent;
    procedure AddDecision;
    procedure AddOnPageReference;
    procedure AddOffPageReference;
    procedure CheckFoldersTypes;
 public
    class function DefaultInstance:TMiceShapesGalleryCollection;
    procedure Populate;
 end;

const
  clDarkRed = $000400BB;
  MiceDefaultCommentFolderColor = $E8E8E8;
  MiceDefaultFolderColor = $C8C8C8;
  MiceDefaultFolderColorBk = $D59B5B;
  MiceDefaultArrowColor = MiceDefaultFolderColorBk;
  MiceDefaultEventColor = $00EDDFCC;
  MiceDefaultEndEventLineColor = clDarkRed;
  MiceDefaultStartEventLineColor = clGreen;

  MiceDefaultStartEventLineWidth = 3;
  MiceDefaultEndEventLineWidth = 5;
  FolderTypeProcess = 0;
  FolderTypeDecision = 1;
  FolderTypeSubProcess = 2;
  FolderTypeDocument = 3;
  FolderTypeOnPageReference = 4;
  FolderTypeOffPageReference = 5;
  FolderTypeStartEvent = 6;
  FolderTypeEndEvent = 7;

implementation

var
 FDefaultInstance: TMiceShapesGalleryCollection;

{ TMiceShapesGalleryCollection }

resourcestring
 S_BPPN_START_EVENT = 'Start event';
 S_BPPN_END_EVENT = 'End event';

 S_BPPN_DEV_DESC_PRCESS = '[Any action] Represents any process.';
 S_BPPN_DEV_DESC_DECISION = '[Auto push] Automatically routes document under the certain condition.';
 S_BPPN_DEV_DESC_SUBPROCESS = '[Auto push] Indicates about some another process has started during this step. Automatically moves to the next folder.';
 S_BPPN_DEV_DESC_DOCUMENT = '[Auto push] Indicates about some documents were created during this step. Automatically moves to the next folder.';
 S_BPPN_DEV_DESC_ONPAGE_REFERENCE = '[Any action] Indicates process was resumed from previous point.';
 S_BPPN_DEV_DESC_OFFPAGE_REFERENCE = '[Any action] Indicates end of logical part of current process.';
 S_BPPN_DEV_DESC_START_EVENT = '[Allows user to create document]. Starting event of process.';
 S_BPPN_DEV_DESC_END_EVENT= '[Any action] Represents the result of a process.';


procedure TMiceShapesGalleryCollection.AddOffPageReference;
var
 Entry:TMiceGalleryShapeEntry;
begin
 Entry:=TMiceGalleryShapeEntry.Create(FRepo.OffPageReference);
 Entry.FolderType:=FolderTypeOffPageReference;
 Entry.Width:=100;
 Entry.Height:=75;
 Entry.DevDescription:=S_BPPN_DEV_DESC_OFFPAGE_REFERENCE;
 Add(Entry);
end;

procedure TMiceShapesGalleryCollection.AddOnPageReference;
var
 Entry:TMiceGalleryShapeEntry;
begin
 Entry:=TMiceGalleryShapeEntry.Create(FRepo.OnPageReference);
 Entry.FolderType:=FolderTypeOnPageReference;
 Entry.Width:=75;
 Entry.Height:=75;
 Entry.DevDescription:=S_BPPN_DEV_DESC_ONPAGE_REFERENCE;
 Add(Entry);
end;

procedure TMiceShapesGalleryCollection.AddProcess;
var
 Entry:TMiceGalleryShapeEntry;
begin
 Entry:=TMiceGalleryShapeEntry.Create(FRepo.Process);
 Entry.FolderType:=FolderTypeProcess;
 Entry.Width:=100;
 Entry.Height:=75;
 Entry.DevDescription:=S_BPPN_DEV_DESC_PRCESS;
 Add(Entry);
end;

procedure TMiceShapesGalleryCollection.AddStartEvent;
var
 Entry:TMiceGalleryShapeEntry;
begin
 Entry:=TMiceGalleryShapeEntry.Create(FRepo.OnPageReference);
 Entry.FolderType:=FolderTypeStartEvent;
 Entry.GalleryCaption:=S_BPPN_START_EVENT;
 Entry.LineWidth:=MiceDefaultStartEventLineWidth;
 Entry.BkColor:=MiceDefaultEventColor;
 Entry.ShapeColor:=MiceDefaultStartEventLineColor;
 Entry.Width:=75;
 Entry.Height:=75;
 Entry.DevDescription:=S_BPPN_DEV_DESC_START_EVENT;
 Add(Entry);
end;

procedure TMiceShapesGalleryCollection.AddSubProcess;
var
 Entry:TMiceGalleryShapeEntry;
begin
 Entry:=TMiceGalleryShapeEntry.Create(FRepo.Subprocess);
 Entry.FolderType:=FolderTypeSubProcess;
 Entry.Width:=100;
 Entry.Height:=75;
 Entry.DevDescription:=S_BPPN_DEV_DESC_SUBPROCESS;
 Add(Entry);
end;

procedure TMiceShapesGalleryCollection.AddDecision;
var
 Entry:TMiceGalleryShapeEntry;
begin
 Entry:=TMiceGalleryShapeEntry.Create(FRepo.Decision);
 Entry.FolderType:=FolderTypeDecision;
 Entry.Width:=135;
 Entry.Height:=110;
 Entry.DevDescription:=S_BPPN_DEV_DESC_DECISION;
 Add(Entry);
end;

procedure TMiceShapesGalleryCollection.AddDocument;
var
 Entry:TMiceGalleryShapeEntry;
begin
 Entry:=TMiceGalleryShapeEntry.Create(FRepo.Document);
 Entry.FolderType:=FolderTypeDocument;
 Entry.Width:=100;
 Entry.Height:=75;
 Entry.DevDescription:=S_BPPN_DEV_DESC_DOCUMENT;
 Add(Entry);
end;

procedure TMiceShapesGalleryCollection.AddEndEvent;
var
 Entry:TMiceGalleryShapeEntry;
begin
 Entry:=TMiceGalleryShapeEntry.Create(FRepo.OnPageReference);
 Entry.FolderType:=FolderTypeEndEvent;
 Entry.GalleryCaption:=S_BPPN_END_EVENT;
 Entry.LineWidth:=MiceDefaultEndEventLineWidth;
 Entry.BkColor:=MiceDefaultEventColor;
 Entry.ShapeColor:=MiceDefaultEndEventLineColor;
 Entry.Width:=75;
 Entry.Height:=75;
 Entry.DevDescription:=S_BPPN_DEV_DESC_END_EVENT;
// TdxFlowChartObjectAdvancedShapeAccess(FRepo).AddPredefinedShape('EndEvent', @S_BPPN_END_EVENT);
 Add(Entry);
end;

class function TMiceShapesGalleryCollection.DefaultInstance: TMiceShapesGalleryCollection;
begin
 Result:=FDefaultInstance;
end;

procedure TMiceShapesGalleryCollection.Populate;
begin
 FRepo:=TdxFlowChart.Repository.BasicFlowchartShapes;
 AddProcess;
 AddDecision;
 AddSubProcess;
 AddDocument;
 AddOnPageReference;
 AddOffPageReference;
 AddStartEvent;
 AddEndEvent;

 CheckFoldersTypes;
end;

procedure TMiceShapesGalleryCollection.CheckFoldersTypes;
var
 x:Integer;
resourcestring
 E_INVALID_FOLDER_TYPE_INDEX = 'Invalid folder type index';
begin
 for x:=0 to Self.Count-1 do
  if Items[x].FolderType<>x then
   raise Exception.Create(E_INVALID_FOLDER_TYPE_INDEX);
end;


{ TMiceGalleryShapeEntry }

constructor TMiceGalleryShapeEntry.Create(AShape:TdxFlowChartObjectAdvancedShape);
begin
 FShape:=AShape;
 GalleryCaption:=FShape.Caption;
 ShapeColor:=MiceDefaultFolderColor;
 BkColor:=MiceDefaultFolderColorBk;
 LineWidth:=1;
end;

procedure TMiceGalleryShapeEntry.ToObject(Obj: TdxFcObject);
begin
 Obj.ShapeColor := Self.ShapeColor;
 Obj.BkColor := Self.BkColor;
 Obj.Text:=Self.GalleryCaption;
 Obj.ShapeWidth:=Self.LineWidth;
 Obj.Tag:=Integer(Self);
 Obj.Width:=Self.Width;
 Obj.Height:=Self.Height;
end;

initialization
 FDefaultInstance:=TMiceShapesGalleryCollection.Create(True);
 FDefaultInstance.Populate;

finalization
 FDefaultInstance.Free;
end.
