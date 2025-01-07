unit ManagerEditor.DocFlowSchema;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, ManagerEditor.Common, cxGraphics,
  cxLookAndFeels, cxLookAndFeelPainters, Vcl.Menus, cxControls, Data.DB,
  cxClasses, dxLayoutContainer, dxLayoutControl, Vcl.StdCtrls, cxButtons,
  Vcl.ExtCtrls, dxflchrt, dxBar, Vcl.Buttons,dxFlowChartShapes,dxCoreGraphics,
  dxGDIPlusClasses, cxGeometry, System.Types, System.UITypes,
  System.Generics.Collections, cxImageComboBox,
  DAC.XDataSet,
  Common.Images,
  Common.ResourceStrings,
  Common.ResourceStrings.Manager,
  CustomControl.MiceFlowChart,
  CustomControl.MiceFlowChart.FlowObjects,
  CustomControl.MiceFlowChart.Shapes,
  CustomControl.MiceFlowChart.FlowCommentPropertiesDialog,
  CustomControl.MiceActionList,
  StaticDialog.MiceInputBox,
  ManagerEditor.dfPathFolder,
  ManagerEditor.dfMethod,
  Manager.WindowManager,
  ManagerEditor.DocFlowSchema.Validate,
  DocFlow.Schema.Helper, dxGallery, dxGalleryControl, System.Actions,
  Vcl.ActnList, System.ImageList, Vcl.ImgList, cxImageList;

type
  TdxFlowChart = class (TMiceFlowChart)
  end;

  TdxGalleryControl = class(dxGalleryControl.TdxGalleryControl)
  end;

  TManagerEditorDocFlowScheme = class(TCommonManagerDialog)
    dxBarManager: TdxBarManager;
    dxBarManagerBar1: TdxBar;
    bnNewFolder: TdxBarButton;
    bnEdit: TdxBarButton;
    bnDelete: TdxBarButton;
    bnNewItem: TdxBarSubItem;
    bnNewMethod: TdxBarButton;
    bnAutoRoute: TdxBarButton;
    Chart: TdxFlowChart;
    Panel3: TPanel;
    gcStencils: TdxGalleryControl;
    gcgStencils: TdxGalleryControlGroup;
    gcShapes: TdxGalleryControl;
    gcgShapes: TdxGalleryControlGroup;
    FlowActions: TActionList;
    acProperties: TAction;
    acPointerTool: TAction;
    acNewMethod: TAction;
    bnPointer: TdxBarButton;
    lbInfo: TLabel;
    acDelete: TAction;
    bnNewCommentGroup: TdxBarButton;
    SaveDialog1: TSaveDialog;
    bnSaveAs: TdxBarButton;
    bnShowGrid: TdxBarButton;
    bnNewLabel: TdxBarButton;
    dxBarButton1: TdxBarButton;
    bnView: TdxBarSubItem;
    bnEditSubMenu: TdxBarSubItem;
    procedure bnAutoRouteClick(Sender: TObject);
    procedure ChartMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ChartMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure ChartMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ChartDragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure acNewMethodExecute(Sender: TObject);
    procedure acPointerToolExecute(Sender: TObject);
    procedure ChartKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure acPropertiesExecute(Sender: TObject);
    procedure ChartSelected(Sender: TdxCustomFlowChart; Item: TdxFcItem);
    procedure acDeleteExecute(Sender: TObject);
    procedure bnNewCommentGroupClick(Sender: TObject);
    procedure bnSaveAsClick(Sender: TObject);
    procedure bnShowGridClick(Sender: TObject);
    procedure bnNewLabelClick(Sender: TObject);
  private
    FHelper:TDocFlowManagerHelper;
    FDownPoint:TPoint;
    FActionList:TMiceActionList;
    function AllowedToDelete:Boolean;
    function DeleteConfirmed:Boolean;
    procedure MoveMethodText(Offset:Integer;IsXAxis:Boolean);
    procedure DoDeleteItem(Item:TdxFcItem);
    procedure UpdateLabel(Item: TdxFcItem);
    procedure InitNewPathFolder(AFolder:TMiceFlowObject);
    procedure InitNewMethod(AMethod:TMiceFlowConnector);
    procedure OnNewObjectDrag(Sender:TObject);
    procedure OnNewMethod(Sender:TObject);
    procedure OnRouteChanged(Sender:TMiceFlowChart; AMethod:TMiceFlowConnector;ASource,ATarget:TMiceFlowObject);
    procedure ValidateSchema(dfTypesId:Integer);
    procedure PopulateFolderImages(Images:TcxImageList);
    procedure PopulateCommentImages(Images:TcxImageList);
    procedure AddToImages(Images: TcxImageList; Shape:TdxFlowChartObjectAdvancedShape; ShapeColor, BkColor:TColor);
  protected
    procedure EditCommentObject(Obj:TdxFcObject);
    procedure DoEditFlowObject(Folder:TMiceFlowObject);
    procedure DoOnEditFolder(Folder:TMiceFlowObject);
    procedure DoOnEditMethod(Method:TMiceFlowConnector);
    procedure DrawAdvancedGalleryShape(AGalleryItem: TdxGalleryControlItem; Entry:TMiceGalleryShapeEntry);
    procedure EnterInsertingState; override;
    procedure EnterEditingState; override;
    procedure LoadFromStream;
    procedure SaveToStream;
    procedure PopulateGallary;
    procedure PopulateFolderTypeItems(Items:TcxImageComboBoxItems);
    function DialogSaveName:string; override;
  public
    procedure SynchronizeTree(ItemInserted:Boolean); override;
    procedure SaveChanges; override;
    procedure Initialize; override;
    constructor Create(AOwner:TComponent);override;
    destructor Destroy; override;
  end;


implementation

var
 FCommentShapes:TStringList;
 FBpmnRuntimeImageList:TcxImageList;
 FRuntimeCommentImages:TcxImageList;

{$R *.dfm}


type
  TdxFlowChartObjectAdvancedShapeHelper = class helper for TdxFlowChartObjectAdvancedShape
  public
    procedure PaintShape(AGraphics: TdxGPCanvas; const ABounds: TRect; APenColor, ABrushColor: TdxAlphaColor);
  end;

{ TManagerEditorDocFlowScheme }

procedure TManagerEditorDocFlowScheme.acDeleteExecute(Sender: TObject);
begin
  if AllowedToDelete and DeleteConfirmed  then
   begin
    if Assigned(Chart.SelectedObject) then
     DoDeleteItem(Chart.SelectedObject)
    else
    if Assigned(Chart.SelectedConnection) then
     DoDeleteItem(Chart.SelectedConnection);
   end;
end;

procedure TManagerEditorDocFlowScheme.acNewMethodExecute(Sender: TObject);
begin
  Chart.ClearSelection;
  Chart.IsAddingConnection := True;
  Chart.StartConnectionEndpointHighlight(cxInvisiblePoint.X, cxInvisiblePoint.Y);
end;

procedure TManagerEditorDocFlowScheme.acPointerToolExecute(Sender: TObject);
begin
  Chart.StopConnectionEndpointHighlight;
  Chart.IsAddingConnection := False;
end;

procedure TManagerEditorDocFlowScheme.acPropertiesExecute(Sender: TObject);
var
  hTest: TdxFcHitTest;
begin
  hTest := Chart.GetHitTestAt(FDownPoint.X, FDownPoint.Y);
  if ((hTest * [htByObject,htOnObject]) <> []) and Assigned(Chart.SelectedObject) then
    DoEditFlowObject((Chart.SelectedObject as TMiceFlowObject))
  else
    if ((hTest * [htOnConnection, htOnConLabel,htOnArrowSrc,htOnArrowDst]) <> []) and  Assigned(Chart.SelectedConnection) then
   DoOnEditMethod(Chart.SelectedConnection as TMiceFlowConnector);
end;

procedure TManagerEditorDocFlowScheme.AddToImages(Images: TcxImageList;  Shape: TdxFlowChartObjectAdvancedShape; ShapeColor, BkColor:TColor);
var
  AGlyph: TdxSmartGlyph;
  ACanvas: TdxGpCanvas;
begin
  AGlyph := TdxSmartGlyph.CreateSize(Images.Width,Images.Height);
   try
    ACanvas := AGlyph.CreateCanvas;
      try
        Shape.PaintShape(ACanvas, cxRectInflate(AGlyph.ClientRect, -1), TdxAlphaColors.FromColor(ShapeColor), TdxAlphaColors.FromColor(BkColor));
        Images.Add(AGlyph);
      finally
        ACanvas.Free;
      end;
   finally
    AGlyph.Free;
   end;
end;

function TManagerEditorDocFlowScheme.AllowedToDelete: Boolean;
resourcestring
 S_CANNOT_DELETE_MULTIPLY_ITEMS = 'Cannot delete multiply items.';
 S_CANNOT_DELETE_ITEM_WITH_ACTIVE_METHODS = 'Cannot delete item with active methods.';
begin
 Result:=False;
 if (Chart.SelectedObjectCount+Chart.SelectedConnectionCount)=0 then
  Exit;

 if (Chart.SelectedObjectCount+Chart.SelectedConnectionCount)>1 then
  begin
   MessageBox(Handle, PCHar(S_CANNOT_DELETE_MULTIPLY_ITEMS), PChar(S_CANNOT_DELETE_MULTIPLY_ITEMS), MB_OK+MB_ICONINFORMATION);
   Exit(False);
  end;

 if (Chart.SelectedObject is TMiceFlowObject) and (Chart.SelectedObject.ConnectionCount>0) then
   begin
    MessageBox(Handle,PChar(S_CANNOT_DELETE_ITEM_WITH_ACTIVE_METHODS), PChar(S_COMMON_INFORMATION), MB_OK+MB_ICONINFORMATION);
    Exit(False);
   end;

  Result:=True;
end;

procedure TManagerEditorDocFlowScheme.bnAutoRouteClick(Sender: TObject);
begin
 Chart.AutoRoute:=bnAutoRoute.Down;
end;

procedure TManagerEditorDocFlowScheme.ChartDragOver(Sender, Source: TObject; X,  Y: Integer; State: TDragState; var Accept: Boolean);
var
  AItem: TdxGalleryControlItem;
  AShape:TdxFlowChartObjectAdvancedShape;
  Entry:TMiceGalleryShapeEntry;
begin
  if (Source is TcxDragControlObject) and (TcxDragControlObject(Source).Control = gcShapes) and (State = dsDragEnter) then
  begin
    CancelDrag;
    AItem := gcShapes.Gallery.GetCheckedItem;
    Entry:= TMiceGalleryShapeEntry(AItem.Tag);
    AShape:=Entry.Shape;
    Chart.AddObjectOnDragFromGallery(cxInvisiblePoint, fcsAdvanced, AShape, Entry);
  end;
end;


procedure TManagerEditorDocFlowScheme.ChartKeyDown(Sender: TObject;  var Key: Word; Shift: TShiftState);
var
 DefaultOffset:Integer;
begin
 if (ssCtrl in Shift) or (ssShift in Shift) then
  DefaultOffset:=1
   else
  DefaultOffset:=5;
 case Key of
  VK_SPACE: acPointerTool.Execute;
  VK_UP: MoveMethodText(-DefaultOffset, False);
  VK_DOWN: MoveMethodText(DefaultOffset, False);
  VK_LEFT:MoveMethodText(-DefaultOffset, True);
  VK_RIGHT: MoveMethodText(DefaultOffset, True);
  VK_RETURN: bnOK.Click;
  VK_DELETE:acDeleteExecute(nil);
 end;
end;

procedure TManagerEditorDocFlowScheme.ChartMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  FDownPoint := Point(X, Y);
  if (Button <> mbLeft) then
    Exit;

   if acNewMethod.Checked and Assigned(Chart.SelectedObject) then
    Chart.AddConnectionOnDrag(FDownPoint);

end;

procedure TManagerEditorDocFlowScheme.ChartMouseMove(Sender: TObject;  Shift: TShiftState; X, Y: Integer);
var
  APoint: TPoint;
begin
  APoint := Point(X, Y);
  if (acNewMethod.Checked) and (not acPointerTool.Checked) then
  begin
    if Chart.ConnectionHighlights <> nil then
    begin
      Chart.ConnectionHighlights.Update(X, Y);
      Chart.Invalidate;
    end;
  end
end;


procedure TManagerEditorDocFlowScheme.InitNewMethod(AMethod: TMiceFlowConnector);
resourcestring
 S_DEFAULT_NEW_METHOD_CAPTION = 'New method';
var
 Source, Target:TMiceFlowObject;
 MethodId:Integer;
begin
 try
  Source:=AMethod.ObjectSource as TMiceFlowObject;
  Target:=AMethod.ObjectDest as TMiceFlowObject;
  MethodId:=FHelper.NewMethod(S_DEFAULT_NEW_METHOD_CAPTION,Source.DfPathFoldersId,Target.DfPathFoldersId);
  AMethod.dfPathFoldersIdSource:=Source.DfPathFoldersId;
  AMethod.dfPathFoldersIdTarget:=Target.DfPathFoldersId;
  AMethod.dfMethodsId:=MethodId;
  AMethod.Text:=S_DEFAULT_NEW_METHOD_CAPTION;
 except
  AMethod.Free;
  raise;
 end;
end;

procedure TManagerEditorDocFlowScheme.InitNewPathFolder(AFolder: TMiceFlowObject);
begin
 try
  AFolder.DfPathFoldersId:=FHelper.NewDocFlowFolder(AFolder.Text, AFolder.FolderType);
 except
  AFolder.Free;
  raise;
 end;
end;


procedure TManagerEditorDocFlowScheme.ChartMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  acPointerTool.Execute;
end;

procedure TManagerEditorDocFlowScheme.ChartSelected(Sender: TdxCustomFlowChart; Item: TdxFcItem);
begin
 if Assigned(Item) then
  UpdateLabel(Item)
   else
 lbInfo.Caption:='';
end;

constructor TManagerEditorDocFlowScheme.Create(AOwner: TComponent);
begin
  inherited;
  Chart.OnNewObjectDrag:=OnNewObjectDrag;
  Chart.OnNewConnection:=OnNewMethod;
  Chart.OnRouteChanged:=OnRouteChanged;
  TableName:='dfTypes';
  KeyField:='dfTypesId';
  AppMainTreeDescriptionField:='Caption';
  ImageIndex:= IMAGEINDEX_ITYPE_DFSCHEME;
  iType:=iTypeDFScheme;
  FHelper:=TDocFlowManagerHelper.Create;
  FActionList:=TMiceActionList.Create;
  gcShapes.DragMode := dmAutomatic;
  PopulateGallary;

  Self.SaveDialog1.Filter:=S_OPEN_FILE_FILTER_XML_ONLY;


  if not Assigned(FCommentShapes) then
   begin
     FCommentShapes:=TStringList.Create;
     TFlowCommentPropertiesDialog.PopulateForComment(FCommentShapes);
   end;

  if not Assigned(FBpmnRuntimeImageList) then
   begin
    FBpmnRuntimeImageList:=TcxImageList.Create(Application);
    PopulateFolderImages(FBpmnRuntimeImageList);
   end;

  if not Assigned(FRuntimeCommentImages) then
   begin
    FRuntimeCommentImages:=TcxImageList.Create(Application);
    PopulateCommentImages(FRuntimeCommentImages);
   end;

end;

function TManagerEditorDocFlowScheme.DeleteConfirmed: Boolean;
begin
 Result:=MessageBox(Handle,PChar(S_COMMON_DELETE_ITEM_CONFIRMATION),PChar(S_COMMON_DELETE_RECORD_CAPTION),MB_YESNO+MB_ICONQUESTION)=ID_YES;
end;

destructor TManagerEditorDocFlowScheme.Destroy;
begin
  FActionList.Free;
  FHelper.Free;
  inherited;
end;

function TManagerEditorDocFlowScheme.DialogSaveName: string;
begin
 Result:=Self.ClassName + '_dfTypesId='+Self.ID.ToString;
end;

procedure TManagerEditorDocFlowScheme.DoDeleteItem(Item: TdxFcItem);
begin
 if (Item is TMiceFlowObject) and ((Item as TMiceFlowObject).IsCommentFolder=False) then
  FHelper.DeletePathFolder((Item as TMiceFlowObject).DfPathFoldersId)
 else
  if Item is TMiceFlowConnector then
   FHelper.DeleteMethod((Item as TMiceFlowConnector).dfMethodsId);

  Chart.Delete(Item);
  Item.Free;
end;

procedure TManagerEditorDocFlowScheme.DoEditFlowObject(Folder: TMiceFlowObject);
begin
 if Folder.IsCommentFolder then
   EditCommentObject(Folder)
    else
   DoOnEditFolder(Folder);
end;

procedure TManagerEditorDocFlowScheme.DoOnEditFolder(Folder:TMiceFlowObject);
var
 Dlg:TManagerEditorDfPathFolder;
begin
 Dlg:=TManagerEditorDfPathFolder.Create(Self);
 try
   PopulateFolderTypeItems(Dlg.ddFolderType.Properties.Items);
   Dlg.ddFolderType.Properties.Images:=FBpmnRuntimeImageList;
   Dlg.PopulateShapeFrame;
   Dlg.ID:=Folder.DfPathFoldersId;
   Dlg.DBName:=FHelper.DBName;
   Dlg.Folder:=Folder;
   if Dlg.Execute then
    Dlg.SaveFolder;
 finally
  Dlg.Free;
 end;
end;

procedure TManagerEditorDocFlowScheme.DoOnEditMethod(Method:TMiceFlowConnector);
var
 Dlg:TManagerEditorDfMethod;
begin
 Dlg:=TManagerEditorDfMethod.Create(Self);
 try
   Dlg.ID:=Method.dfMethodsId;
   Dlg.DBName:=FHelper.DBName;
   Dlg.Method:=Method;
   if Dlg.Execute then;
    Dlg.SaveMethod;
 finally
  Dlg.Free;
 end;
end;

procedure TManagerEditorDocFlowScheme.DrawAdvancedGalleryShape(AGalleryItem: TdxGalleryControlItem; Entry:TMiceGalleryShapeEntry);
var
  AGlyph: TdxSmartGlyph;
  ACanvas: TdxGpCanvas;
begin
  AGlyph := TdxSmartGlyph.CreateSize(gcShapes.OptionsView.Item.Image.Size.Size);
  try
    ACanvas := AGlyph.CreateCanvas;
    try
      Entry.Shape.PaintShape(ACanvas, cxRectInflate(AGlyph.ClientRect, -1), TdxAlphaColors.FromColor(Entry.ShapeColor), TdxAlphaColors.FromColor(Entry.BkColor));
      AGalleryItem.Glyph := AGlyph;
    finally
      ACanvas.Free;
    end;
  finally
    AGlyph.Free;
  end;
end;

procedure TManagerEditorDocFlowScheme.bnNewCommentGroupClick(Sender: TObject);
var
 Obj:TMiceFlowObject;
resourcestring
 S_NEW_COMMENT_GROUP = 'New comment';
begin
  acPointerTool.Execute;
  Obj:=Chart.CreateObject(150,150,300,175, Chart.Repository.BasicFlowchartShapes.OnPageReference ) as TMiceFlowObject;
  Obj.ShapeColor := MiceDefaultCommentFolderColor;
  Obj.BkColor := MiceDefaultCommentFolderColor;
  Obj.SendToBack;
  Obj.IsCommentFolder:=True;
  Obj.Text:=S_NEW_COMMENT_GROUP;
  Obj.Font.Style:=[fsBold];
  Obj.Font.Size:=12;
  Chart.StopConnectionEndpointHighlight;
  Chart.IsAddingConnection := False;
end;


procedure TManagerEditorDocFlowScheme.EditCommentObject(Obj: TdxFcObject);
var
 Dlg:TFlowCommentPropertiesDialog;
begin
 Dlg:=TFlowCommentPropertiesDialog.Create(nil);
 try
  Dlg.Load(FRuntimeCommentImages, FCommentShapes);
  Dlg.LoadObject(Obj);
   if Dlg.Execute then
    Dlg.SaveObject(Obj);
 finally
  Dlg.Free;
 end;

end;

procedure TManagerEditorDocFlowScheme.EnterEditingState;
begin
  inherited;
  if not DataSet.FieldByName('Scheme').IsNull then
   LoadFromStream;
  ValidateSchema(ID);
end;

procedure TManagerEditorDocFlowScheme.EnterInsertingState;
begin
  inherited;

end;

procedure TManagerEditorDocFlowScheme.Initialize;
begin
  inherited;
  Self.FHelper.DfClassesId:=Self.DataSet.FieldByName('dfClassesId').AsInteger;
  Self.FHelper.dfTypesId:=Self.ID;
  Self.FHelper.DBName:=DBName;
end;


procedure TManagerEditorDocFlowScheme.LoadFromStream;
var
 Stream:TStream;
begin
 Stream:=DataSet.CreateBlobStream(DataSet.FieldByName('Scheme'), bmRead);
 try
  Stream.Seek(0,0);
  Chart.LoadFromStream(Stream);
  bnAutoRoute.Down:=Chart.AutoRoute;
 finally
  Stream.Free;
 end;

end;

procedure TManagerEditorDocFlowScheme.MoveMethodText(Offset: Integer; IsXAxis:Boolean);
var
 Item:TMiceFlowConnector;
 x:Integer;
begin
if Chart.SelectedConnectionCount>0 then
 for x:=0 to Chart.SelectedConnectionCount-1 do
  begin
   Item:= (Chart.SelectedConnections[x] as TMiceFlowConnector);
   if IsXAxis then
   Item.TextXOffset:=Item.TextXOffset+Offset
    else
   Item.TextYOffset:=Item.TextYOffset+Offset;
  end;
end;

procedure TManagerEditorDocFlowScheme.OnRouteChanged(Sender:TMiceFlowChart; AMethod:TMiceFlowConnector;ASource,ATarget:TMiceFlowObject);
begin
 if AMethod.dfPathFoldersIdSource<>ASource.DfPathFoldersId then
  begin
    FHelper.ChangeSourceFolder(AMethod.dfMethodsId, ASource.DfPathFoldersId);
    AMethod.dfPathFoldersIdSource:=ASource.DfPathFoldersId;
  end;

  if AMethod.dfPathFoldersIdTarget<>ATarget.DfPathFoldersId then
   begin
     FHelper.ChangeTargetFolder(AMethod.dfMethodsId, ATarget.DfPathFoldersId);
     AMethod.dfPathFoldersIdTarget:=ATarget.DfPathFoldersId;
   end;
 UpdateLabel(AMethod);
end;

procedure TManagerEditorDocFlowScheme.OnNewMethod(Sender: TObject);
begin
 InitNewMethod(Chart.AddingConnection as TMiceFlowConnector);
end;

procedure TManagerEditorDocFlowScheme.OnNewObjectDrag(Sender: TObject);
begin
 InitNewPathFolder(Chart.AddinObject);
end;

procedure TManagerEditorDocFlowScheme.PopulateFolderTypeItems(Items: TcxImageComboBoxItems);
var
  Item:TcxImageComboBoxItem;
  Entry:TMiceGalleryShapeEntry;
begin
 for Entry in TMiceShapesGalleryCollection.DefaultInstance do
  begin
   Item:=Items.Add;
   Item.ImageIndex:=Entry.FolderType;
   Item.Description:=Entry.GalleryCaption;
   Item.Value:=Entry.FolderType;
  end;
end;

procedure TManagerEditorDocFlowScheme.PopulateGallary;
var
 Entry: TMiceGalleryShapeEntry;
 Item: TdxGalleryControlItem;
begin
 for Entry in TMiceShapesGalleryCollection.DefaultInstance do
  begin
   Item := gcgShapes.Items.Add;
   Item.Caption := Entry.GalleryCaption;
   Item.Tag:=Integer(Entry);
   if Entry.ImageIndex<>0 then
   Item.ImageIndex:=Entry.ImageIndex
    else
   DrawAdvancedGalleryShape(Item, Entry);
  end;
end;

procedure TManagerEditorDocFlowScheme.PopulateCommentImages(Images: TcxImageList);
var
 x:Integer;
 Shape: TdxFlowChartObjectAdvancedShape;
begin
 for x:=0 to FCommentShapes.Count-1 do
 begin
  Shape:=FCommentShapes.Objects[x] as  TdxFlowChartObjectAdvancedShape;
  AddToImages(Images, Shape, MiceDefaultFolderColorBk, MiceDefaultFolderColorBk);
 end;
end;

procedure TManagerEditorDocFlowScheme.PopulateFolderImages(Images: TcxImageList);
var
  Entry:TMiceGalleryShapeEntry;
begin
for Entry in TMiceShapesGalleryCollection.DefaultInstance do
  AddToImages(Images, Entry.Shape, Entry.ShapeColor, Entry.BkColor);
end;

procedure TManagerEditorDocFlowScheme.SaveChanges;
begin
  SaveToStream;
  inherited;
end;

procedure TManagerEditorDocFlowScheme.SaveToStream;
var
 Stream:TStream;
begin
 DataSet.FieldByName('Scheme').Clear;
 Stream:=DataSet.CreateBlobStream(DataSet.FieldByName('Scheme'), bmWrite);
 try
  Chart.SaveToStream(Stream);
 finally
  Stream.Free;
 end;
end;

procedure TManagerEditorDocFlowScheme.SynchronizeTree(ItemInserted: Boolean);
begin
 //DoNothing
end;

procedure TManagerEditorDocFlowScheme.UpdateLabel(Item: TdxFcItem);
var
 C:TMiceFlowConnector;
 F:TMiceFlowObject;
begin
 if (Item is TMiceFlowConnector) then
  begin
   C:=Item as TMiceFlowConnector;
   lbInfo.Caption:=Format('dfMethodsId = %d, Source=%d, Target=%d',[c.dfMethodsId, c.dfPathFoldersIdSource, c.dfPathFoldersIdTarget]);
  end
  else
 if (Item is TMiceFlowObject) then
  begin
   F:=Item as TMiceFlowObject;
   lbInfo.Caption:=Format('dfPathFoldersId = %d',[F.DfPathFoldersId]);
  end
   else
   lbInfo.Caption:='';
end;


procedure TManagerEditorDocFlowScheme.ValidateSchema(dfTypesId: Integer);
var
 Validator:TDocFlowSchemaValidator;
begin
 Validator:=TDocFlowSchemaValidator.Create(Self.Chart, dfTypesId);
  try
   Validator.DBName:=Self.DBName;
   Validator.Validate;
  finally
   Validator.Free;
  end;
end;

{ TdxFlowChartObjectAdvancedShapeHelper }

procedure TdxFlowChartObjectAdvancedShapeHelper.PaintShape( AGraphics: TdxGPCanvas; const ABounds: TRect; APenColor,  ABrushColor: TdxAlphaColor);
begin
  FShape.PaintDefaultShape(AGraphics, ABounds, APenColor, ABrushColor);
end;

procedure TManagerEditorDocFlowScheme.bnSaveAsClick(Sender: TObject);
begin
 if Self.SaveDialog1.FileName='' then
   Self.SaveDialog1.FileName:=Self.DataSet.FieldByName('Caption').AsString+'.xml';
 if Self.SaveDialog1.Execute(Handle) then
  Self.Chart.SaveToFile(SaveDialog1.FileName);
end;

procedure TManagerEditorDocFlowScheme.bnShowGridClick(Sender: TObject);
begin
 Chart.GridLineOptions.ShowLines:=not Chart.GridLineOptions.ShowLines;
end;

procedure TManagerEditorDocFlowScheme.bnNewLabelClick(Sender: TObject);
var
 Obj:TMiceFlowObject;
resourcestring
 S_NEW_LABEL_CAPTION = 'New Label';
begin
  acPointerTool.Execute;
  Obj:=Chart.CreateObject(350,250,100,25, Chart.Repository.BasicFlowchartShapes.Process) as TMiceFlowObject;
  Obj.ShapeColor := clWhite;
  Obj.BkColor := clWhite;
//  Obj.SendToBack;
//  Obj.ShapeStyle:=TPenStyle.psClear;
  Obj.IsCommentFolder:=True;
  Obj.Text:=S_NEW_LABEL_CAPTION;
  Obj.Font.Style:=[];
  Obj.Font.Size:=10;
  Obj.Transparent:=True;
  Chart.StopConnectionEndpointHighlight;
  Chart.IsAddingConnection := False;
end;

initialization
  TWindowManager.RegisterEditor(iTypeDFScheme,nil,TManagerEditorDocFlowScheme, False);
finalization
  FCommentShapes.Free;

end.
