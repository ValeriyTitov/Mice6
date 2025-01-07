unit CustomControl.MiceFlowChart;


interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,  Forms,
  dxflchrt,  cxClasses,  Generics.Collections, dxFlowChartShapes,
  System.UITypes, cxGeometry, Dialogs,
  Common.LookAndFeel,
  CustomControl.MiceFlowChart.FlowObjects,
  CustomControl.MiceFlowChart.Shapes;

type
  TMiceFlowChart = class;

  { TdxDesignerFlowChartDragHelper }

  TMethodChangedEvent = procedure(Sender:TMiceFlowChart; AMethod:TMiceFlowConnector;ASource,ATarget:TMiceFlowObject) of object;

  TdxDesignerFlowChartDragHelper = class(TdxFlowChartDragHelper)
  private
    function GetOwner: TMiceFlowChart;
    function InvalidDrag:Boolean;
  public
    procedure DragStop(X: Integer; Y: Integer); override;
    property Owner: TMiceFlowChart read GetOwner;
  end;

  { TdxDesignerFlowChart }

  TMiceFlowChart = class(TdxFlowChart)
  strict private
    FAddingConnection: TdxFcConnection;
    FAddinObject: TMiceFlowObject;
    FAutoRouteDestObject: TdxFcObject;
    FAutoRouteSourceObject: TdxFcObject;
    FIsAddingConnection: Boolean;
    function GetDragHelper: TdxDesignerFlowChartDragHelper;
    procedure InternalCreateNewConnection;
    procedure WMSetCursor(var Message: TWMSetCursor); message WM_SETCURSOR;
  private
    FOnNewObjectDrag: TNotifyEvent;
    FOnNewConnection: TNotifyEvent;
    FOnRouteChanged: TMethodChangedEvent;
    procedure SetAutoRoute(const Value: Boolean);
    function GetAutoRoute: Boolean;
  protected
    procedure DoOnOnNewObjectDrag; virtual;
    procedure DoOnNewConnection; virtual;
    procedure DoOnRouteChanged; virtual;
    procedure AddConnectionOnDrag(APoint: TPoint);
    procedure ConnectionEndpointDragLeave(ACanceled: Boolean);
    procedure MoveObjectsDragLeave(ACanceled: Boolean);
    procedure SetupAutoRoutingDestinationObject;
    procedure AddObjectOnDragFromGallery(APoint: TPoint; AShapeType: TdxFcShapeType; AAdvancedShape: TdxFlowChartObjectAdvancedShape; Entry:TMiceGalleryShapeEntry);
    function CreateDragHelper: TdxFlowChartDragHelper; override;
    function InternalCreateObject: TdxFcObject; override;
    function InternalCreateConnection: TdxFcConnection; override;
    function InvalidConnection:Boolean;
    property DragHelper: TdxDesignerFlowChartDragHelper read GetDragHelper;
  public
    property AddingConnection: TdxFcConnection read FAddingConnection;
    property OnNewObjectDrag:TNotifyEvent read FOnNewObjectDrag write FOnNewObjectDrag;
    property OnNewConnection:TNotifyEvent read FOnNewConnection write FOnNewConnection;
    property OnRouteChanged:TMethodChangedEvent read FOnRouteChanged write FOnRouteChanged;
    property AddinObject: TMiceFlowObject read FAddinObject;
    property AutoRouteDestObject: TdxFcObject read FAutoRouteDestObject;
    property AutoRouteSourceObject: TdxFcObject read FAutoRouteSourceObject;
    property AutoRoute:Boolean read GetAutoRoute write SetAutoRoute;
    property IsAddingConnection: Boolean read FIsAddingConnection write FIsAddingConnection;
    function FindDfPathFolder(dfPathFoldersId:Integer): TMiceFlowObject;
    function FindDfMethod(dfMethodsId:Integer): TMiceFlowConnector;
    function ConnectionById(dfMethodsId:Integer):TMiceFlowConnector;
    function PathFolderById(dfPathFoldersId:Integer):TMiceFlowObject;
    procedure MultiSelect(ResetOldSelected : Boolean; SelectRect : TRect);
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  end;



implementation
type
  { TdxFcObjectHelper }

  TdxFcObjectHelper = class helper for TdxFcObject
  public
    function AutoRoutingPoint: TPoint;
  end;


{ TdxFcObjectHelper }

function TdxFcObjectHelper.AutoRoutingPoint: TPoint;
begin
  Result := Owner.ChartPoint(DisplayRect.CenterPoint);
end;


{ TdxDesignerFlowChartDragHelper }

function TdxDesignerFlowChartDragHelper.InvalidDrag: Boolean;
begin
 Result:=(Cancelled=False) and Assigned(Owner.SelectedConnection) and not Assigned(Owner.AutoRouteDestObject);
end;

procedure TdxDesignerFlowChartDragHelper.DragStop(X, Y: Integer);
var
  ADragKind: TFlowChartDragKind;
begin
  ADragKind := DragKind;
  if ADragKind = TFlowChartDragKind.Endpoint then
    Owner.SetupAutoRoutingDestinationObject;

  if (ADragKind = TFlowChartDragKind.Endpoint) and InvalidDrag then
   begin
    CancelDrag;
    Exit;
   end;

  inherited DragStop(X, Y);
  if ADragKind = TFlowChartDragKind.Endpoint then
    Owner.ConnectionEndpointDragLeave(Cancelled)
  else if ADragKind = TFlowChartDragKind.Move then
    Owner.MoveObjectsDragLeave(Cancelled);
end;

function TdxDesignerFlowChartDragHelper.GetOwner: TMiceFlowChart;
begin
  Result := TMiceFlowChart(inherited Owner);
end;

{ TdxDesignerFlowChart }

constructor TMiceFlowChart.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  if Self.Color<>DefaultLookAndFeel.WindowColor then
   Self.Color:=DefaultLookAndFeel.WindowColor;
  Self.GridLineOptions.MajorLines.Color:=DefaultLookAndFeel.FlowChartMajorLinesColor;
  Self.GridLineOptions.MinorLines.Color:=DefaultLookAndFeel.FlowChartMinorLinesColor;
end;

destructor TMiceFlowChart.Destroy;
begin
  inherited Destroy;
end;

procedure TMiceFlowChart.DoOnRouteChanged;
var
 RealyChanged:Boolean;
 Method:TMiceFlowConnector;
 Source:TMiceFlowObject;
 Target:TMiceFlowObject;
begin
 if Assigned(OnRouteChanged) and Assigned(SelectedConnection) and (SelectedConnection is TMiceFlowConnector) then
  begin
   Method:=SelectedConnection as TMiceFlowConnector;
   Source:=Method.ObjectSource as TMiceFlowObject;
   Target:=Method.ObjectDest as TMiceFlowObject;
   RealyChanged:=(Method.dfPathFoldersIdSource<>Source.DfPathFoldersId) or (Method.dfPathFoldersIdTarget<>Target.DfPathFoldersId);
   if RealyChanged then
    OnRouteChanged(Self, Method, Source, Target);
  end;
end;

function TMiceFlowChart.FindDfMethod(dfMethodsId: Integer): TMiceFlowConnector;
var
 x:Integer;
begin
 for x:=0 to ConnectionCount-1 do
  if Connections[x] is TMiceFlowConnector then
   begin
    if (Connections[x] as TMiceFlowConnector).dfMethodsId=dfMethodsId then
     Exit(Connections[x] as TMiceFlowConnector);
   end;
  Result:=nil;
end;

function TMiceFlowChart.FindDfPathFolder(dfPathFoldersId: Integer): TMiceFlowObject;
var
 x:Integer;
 Candidate:TMiceFlowObject;
begin
 for x:=0 to ObjectCount-1 do
  if Objects[x] is TMiceFlowObject then
   begin
    Candidate:=(Objects[x] as TMiceFlowObject);
    if (Candidate.DfPathFoldersId=dfPathFoldersId) and (Candidate.IsCommentFolder=False) then
     Exit(Candidate);
   end;
 Result:=nil;
end;

procedure TMiceFlowChart.DoOnNewConnection;
begin
 if Assigned(OnNewConnection) then
  OnNewConnection(Self);
end;

procedure TMiceFlowChart.DoOnOnNewObjectDrag;
begin
 if Assigned(OnNewObjectDrag) then
  OnNewObjectDrag(Self);
end;

procedure TMiceFlowChart.AddConnectionOnDrag(APoint: TPoint);
var
  ASourcePoint: Integer;
  ASourceObject: TdxFcObject;
begin
  if AutoRouting and (GetEndpointHighlightedObject = nil) then
    Exit;
    FAutoRouteSourceObject := ConnectionHighlights.&Object;
    if ConnectionHighlights.PointInfo <> nil then
    begin
      ASourceObject := ConnectionHighlights.PointInfo.&Object;
      ASourcePoint := ConnectionHighlights.PointInfo.Index;
    end
    else
    begin
      ASourcePoint := 0;
      ASourceObject := SelectedObject;
    end;
    FAddingConnection := CreateConnection(ASourceObject, nil, ASourcePoint, 0);
    AddingConnection.Color := MiceDefaultArrowColor;
    AddingConnection.PenStyle := psDash;
    if ASourceObject = nil then
    begin
      if FAutoRouteSourceObject <> nil then
        AddingConnection.AddPoint(FAutoRouteSourceObject.AutoRoutingPoint)
      else
        AddingConnection.AddPoint(ChartPoint(APoint));
    end;
    AddingConnection.AddPoint(ChartPoint(APoint));
    DragHelper.SetupDragConnection(AddingConnection, 1);
    DragHelper.DragStart(APoint.X, APoint.Y, TdxFlowChartDragHelper.TFlowChartDragKind.Endpoint);
end;

procedure TMiceFlowChart.AddObjectOnDragFromGallery(APoint: TPoint; AShapeType: TdxFcShapeType; AAdvancedShape: TdxFlowChartObjectAdvancedShape; Entry:TMiceGalleryShapeEntry);
begin
    StartExternalDrag(APoint,
    function (): TdxFcObject
    begin
      if AShapeType = fcsAdvanced then
        FAddinObject := CreateObject(0, 0, 0, 0, AAdvancedShape) as TMiceFlowObject
      else
        FAddinObject := CreateObject(0, 0, 0, 0, AShapeType) as TMiceFlowObject;
      Entry.ToObject(FAddinObject);
      FAddinObject.FolderType:=Entry.FolderType;

      Result := AddinObject;
    end);

   if Assigned(AddinObject) then
     Entry.ToObject(AddinObject);
end;

function TMiceFlowChart.PathFolderById(dfPathFoldersId: Integer): TMiceFlowObject;
resourcestring
 E_CANNOT_FIND_FOLDER_FMT = 'Cannnot find folder with dfPathFoldersId %d';
begin
 Result:=Self.FindDfPathFolder(dfPathFoldersId);
 if not Assigned(Result) then
  raise Exception.CreateFmt(E_CANNOT_FIND_FOLDER_FMT,[dfPathFoldersId]);
end;

function TMiceFlowChart.ConnectionById(dfMethodsId: Integer): TMiceFlowConnector;
resourcestring
 E_CANNOT_FIND_METHOD_FMT = 'Cannnot find method with dfMethodsId %d';
begin
 Result:=FindDfMethod(dfMethodsId);
 if not Assigned(Result) then
  raise Exception.CreateFmt(E_CANNOT_FIND_METHOD_FMT,[dfMethodsId]);
end;

procedure TMiceFlowChart.ConnectionEndpointDragLeave(ACanceled: Boolean);
begin
  if AddingConnection <> nil then
  begin
    if ACanceled or InvalidConnection or (AutoRouteSourceObject = AutoRouteDestObject) then
     FAddingConnection.Free
    else
     InternalCreateNewConnection;
    FAddingConnection := nil;
  end
  else
   begin
    InvalidateRouting;
    DoOnRouteChanged;
   end;
end;

function TMiceFlowChart.CreateDragHelper: TdxFlowChartDragHelper;
begin
  Result := TdxDesignerFlowChartDragHelper.Create(Self);
end;

procedure TMiceFlowChart.MoveObjectsDragLeave(ACanceled: Boolean);
begin
  if ACanceled then
    FAddinObject.Free
     else
   if Assigned(FAddinObject) then
     DoOnOnNewObjectDrag;

  FAddinObject := nil;
end;

procedure TMiceFlowChart.MultiSelect(ResetOldSelected: Boolean; SelectRect: TRect);
var
  x: Integer;
begin
  if ResetOldSelected then
    ClearSelection;

  for x := 0 to ObjectCount - 1 do
    if Objects[x].InRect(SelectRect) then
      Objects[x].Selected := not Objects[x].Selected;

  for x := 0 to ConnectionCount - 1 do
    if Connections[x].InRect(SelectRect) then
      Connections[x].Selected := not Connections[x].Selected;
end;

procedure TMiceFlowChart.SetAutoRoute(const Value: Boolean);
begin
  if Value then
   Options:=Options+[fcoAutoRouteConnections]
    else
   Options:=Options-[fcoAutoRouteConnections];
end;

procedure TMiceFlowChart.SetupAutoRoutingDestinationObject;
begin
  FAutoRouteDestObject := GetEndpointHighlightedObject;
end;

procedure TMiceFlowChart.WMSetCursor(var Message: TWMSetCursor);
begin
  if FIsAddingConnection then
  begin
    if AutoRouting and (GetEndpointHighlightedObject = nil) then
      Windows.SetCursor(Screen.Cursors[crDefault])
    else
      Windows.SetCursor(Screen.Cursors[crFlChartDrawFreeConnector]);
  end
  else
    inherited;
end;

function TMiceFlowChart.GetAutoRoute: Boolean;
begin
 Result:=(fcoAutoRouteConnections in Options);
end;

function TMiceFlowChart.GetDragHelper: TdxDesignerFlowChartDragHelper;
begin
  Result := TdxDesignerFlowChartDragHelper(inherited DragHelper);
end;


function TMiceFlowChart.InternalCreateConnection: TdxFcConnection;
begin
 Result:=TMiceFlowConnector.Create(Self);
end;

procedure TMiceFlowChart.InternalCreateNewConnection;
begin
  ClearSelection;
  AddingConnection.Color := MiceDefaultArrowColor;
  AddingConnection.PenStyle := psSolid;
  AddingConnection.ArrowDest.ArrowType := fcaArrow;
  AddingConnection.ArrowDest.Height := 8;
  AddingConnection.ArrowDest.Width := 8;
  AddingConnection.Selected := True;
  AddingConnection.PenWidth:=2;
  if AutoRouting then
  begin
    AddingConnection.SetObjectDest(AutoRouteDestObject, 0);
    AddingConnection.SetObjectSource(AutoRouteSourceObject, 0);
  end;
  DoOnNewConnection;
end;

function TMiceFlowChart.InternalCreateObject: TdxFcObject;
begin
 Result:=TMiceFlowObject.Create(Self);
 Result.HorzTextPos:=TdxFcHorzPos.fchpCenter;
 Result.VertTextPos:=TdxFcVertPos.fcvpCenter;
end;

function TMiceFlowChart.InvalidConnection: Boolean;
var
 ValidObject:Boolean;
 EmptyObject:Boolean;
begin
 ValidObject:=(AutoRouteSourceObject is TMiceFlowObject and (AutoRouteSourceObject as TMiceFlowObject).IsCommentFolder=False)
           and (AutoRouteDestObject is TMiceFlowObject and (AutoRouteDestObject as TMiceFlowObject).IsCommentFolder=False);
 EmptyObject:=(AutoRouteSourceObject = nil) or (AutoRouteDestObject = nil);
 Result:=(ValidObject=False) or EmptyObject;
end;


end.
