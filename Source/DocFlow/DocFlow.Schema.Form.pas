unit DocFlow.Schema.Form;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Dialog.Basic, cxGraphics,
  cxLookAndFeels, cxLookAndFeelPainters, Vcl.Menus, Vcl.StdCtrls, cxButtons,
  Vcl.ExtCtrls, cxControls, dxflchrt, Data.DB,
  System.Generics.Collections, System.Generics.Defaults,
  DAC.XDataSet,
  Common.Registry,
  Common.LookAndFeel,
  CustomControl.MiceFlowChart,
  CustomControl.MiceFlowChart.FlowObjects, dxBar, cxClasses, dxBarBuiltInMenu,
  cxPC;

type
  TdxFlowChart = class(TMiceFlowChart)

  end;

  TDocFlowSchemaForm = class(TBasicDialog)
    BlinkTimer: TTimer;
    dxBarManager: TdxBarManager;
    dxBarManagerBar1: TdxBar;
    bnRefresh: TdxBarButton;
    PlayTimer: TTimer;
    bnPlay: TdxBarButton;
    bnStop: TdxBarButton;
    bnForward: TdxBarButton;
    bnBackward: TdxBarButton;
    lbSteps: TLabel;
    bnFastForward: TdxBarButton;
    Chart: TdxFlowChart;
    lbInfo: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BlinkTimerTimer(Sender: TObject);
    procedure ChartMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure bnRefreshClick(Sender: TObject);
    procedure PlayTimerTimer(Sender: TObject);
    procedure bnPlayClick(Sender: TObject);
    procedure bnStopClick(Sender: TObject);
    procedure bnFastForwardClick(Sender: TObject);
    procedure ChartSelected(Sender: TdxCustomFlowChart; Item: TdxFcItem);
  private
    FFlowObject:TMiceFlowObject;
    FdfPathFoldersId: Integer;
    FdfClassesId: Integer;
    FdfTypesId: Integer;
    FHistoryProviderName: string;
    FDBName: string;
    FDocumentsId: Integer;
    FDataSet:TxDataSet;
    FFlowDataSet:TxDataSet;
    FStepCount:Integer;
    FCurrentStep:Integer;
    function FindFolder(dfPathFoldersId:Integer):TMiceFlowObject;
    function FindMethod(dfMethodsId:Integer):TMiceFlowConnector;
    procedure StartHighlightFlowObject;
    procedure StopHighlightFlowObject;
    procedure LoadDocumentHistrory(DocumentsId:Integer);
    procedure ReloadSchema;
    procedure HighlightMethod(dfMethodsId:Integer);
    procedure HighlightFolder(dfPathFoldersId:Integer);
    procedure QuickHighlightFolder(dfPathFoldersId: Integer);
    procedure QuickHighlightMethod(dfMethodsId: Integer);
    procedure UpdateStepLabel;
    procedure UpdateLabel(Item: TdxFcItem);
  protected
    function DialogSaveName:string; override;
    procedure StartPlay;
    procedure StopPlay;
    procedure QuickForwardToEnd;
    procedure ClearInfoLabel;
  public
    class procedure ShowSchema(DataSet:TxDataSet; dfPathFoldersId:Integer);
    procedure Init(DataSet:TxDataSet);
    procedure ShowFlow;
    property dfPathFoldersId:Integer read FdfPathFoldersId write FdfPathFoldersId;
    property dfClassesId:Integer read FdfClassesId write FdfClassesId;
    property dfTypesId:Integer read FdfTypesId write FdfTypesId;
    property HistoryProviderName:string read FHistoryProviderName write FHistoryProviderName;
    property DBName:string read FDBName write FDBName;
    property DocumentsId:Integer read FDocumentsId write FDocumentsId;
    constructor Create(AOwner:TComponent); override;
    destructor Destroy; override;
  end;


implementation

{$R *.dfm}

procedure TDocFlowSchemaForm.bnFastForwardClick(Sender: TObject);
begin
 LoadDocumentHistrory(DocumentsId);
 QuickForwardToEnd;
end;

procedure TDocFlowSchemaForm.bnPlayClick(Sender: TObject);
begin
 Self.StartPlay;
end;

procedure TDocFlowSchemaForm.bnRefreshClick(Sender: TObject);
begin
 Self.ReloadSchema;
end;

procedure TDocFlowSchemaForm.bnStopClick(Sender: TObject);
begin
 StopPlay;
end;

procedure TDocFlowSchemaForm.ChartMouseDown(Sender: TObject;  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
 StopHighlightFlowObject
end;

procedure TDocFlowSchemaForm.ChartSelected(Sender: TdxCustomFlowChart; Item: TdxFcItem);
begin
 if Assigned(Item) then
  UpdateLabel(Item)
   else
  ClearInfoLabel;
end;

procedure TDocFlowSchemaForm.ClearInfoLabel;
begin
  lbInfo.Caption:='';
end;

constructor TDocFlowSchemaForm.Create(AOwner: TComponent);
begin
 inherited;
 lbInfo.Caption:='';
// FAllObjects:=TList<TdxFcItem>.Create;
end;

destructor TDocFlowSchemaForm.Destroy;
begin
   //FAllObjects.Free;
  inherited;
end;

function TDocFlowSchemaForm.DialogSaveName: string;
begin
 Result:=ClassName+'\dfTypesId='+dfTypesId.ToString;
end;

function TDocFlowSchemaForm.FindFolder(dfPathFoldersId:Integer): TMiceFlowObject;
var
 x:Integer;
begin
 for x:=0 to Chart.ObjectCount-1 do
  if Chart.Objects[x] is TMiceFlowObject then
   begin
     Result:=Chart.Objects[x] as TMiceFlowObject;
     if (Result.DfPathFoldersId=dfPathFoldersId) and (Result.IsCommentFolder=False) then
      Exit;
   end;
  Result:=nil;
end;

function TDocFlowSchemaForm.FindMethod(dfMethodsId:Integer): TMiceFlowConnector;
var
 x:Integer;
begin
 for x:=0 to Chart.ConnectionCount-1 do
  if Chart.Connections[x] is TMiceFlowConnector then
   begin
     Result:=Chart.Connections[x] as TMiceFlowConnector;
     if Result.dfMethodsId=dfMethodsId then
      Exit;
   end;
  Result:=nil;
end;

procedure TDocFlowSchemaForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
 TProjectRegistry.DefaultInstance.SaveForm(DialogSaveName,Self);
end;

procedure TDocFlowSchemaForm.FormCreate(Sender: TObject);
begin
 ReadOnly:=True;
end;

procedure TDocFlowSchemaForm.Init(DataSet: TxDataSet);
var
 HistoryAvaible:Boolean;
begin
 FDataSet:=DataSet;
 dfClassesId:=DataSet.FieldByName('dfClassesId').AsInteger;
 dfTypesId:=DataSet.FieldByName('dfTypesId').AsInteger;
 Caption:=DataSet.FieldByName('Caption').AsString;
 Self.DBName:=DataSet.DBName;
 Self.HistoryProviderName:=DataSet.FieldByName('HistoryProviderName').AsString;
 Self.DocumentsId:=DataSet.Params.ParamByName('DocumentsId').AsInteger;
 Self.ReloadSchema;
 HistoryAvaible:=not HistoryProviderName.Trim.IsEmpty;
 Self.bnPlay.Enabled:=HistoryAvaible;
 Self.bnFastForward.Enabled:=HistoryAvaible;
 TProjectRegistry.DefaultInstance.LoadForm(DialogSaveName,True,True,Self);
// Self.Chart.Color:=DefaultLookAndFeel.DefaultWindowColor;
end;

procedure TDocFlowSchemaForm.LoadDocumentHistrory(DocumentsId: Integer);
begin
 if not Assigned(FFlowDataSet) then
  begin
    FFlowDataSet:=TxDataSet.Create(Self);
    FFlowDataSet.ProviderName:=HistoryProviderName;
    FFlowDataSet.DBName:=Self.DBName;
    FFlowDataSet.SetParameter('DocumentsId',DocumentsId);
    FFlowDataSet.SetParameter('dfPathFoldersId',Self.dfPathFoldersId);
    FFlowDataSet.SetParameter('dfTypesId',Self.dfTypesId);
    FFlowDataSet.SetParameter('dfClassesId',Self.dfClassesId);
    FFlowDataSet.Open;
    FFlowDataSet.First;
  end;
end;

procedure TDocFlowSchemaForm.ReloadSchema;
var
 Stream:TStream;
begin
 Stream:=FDataSet.CreateBlobStream(FDataSet.FieldByName('Scheme'), bmRead);
 try
  Stream.Seek(0,0);
  Chart.LoadFromStream(Stream);
  FreeAndNil(Self.FFlowDataSet);
  Self.FFlowObject:=nil;
  Chart.Repaint;
 finally
  Stream.Free;
 end;
end;

procedure TDocFlowSchemaForm.ShowFlow;
begin
 StartHighlightFlowObject;
 ShowModal;
end;


procedure TDocFlowSchemaForm.QuickHighlightFolder(dfPathFoldersId:Integer);
var
 Folder:TMiceFlowObject;
begin
 Folder:=FindFolder(dfPathFoldersId);
  if Assigned(Folder) then
   Folder.BkColor:=clSoftOrange
end;

procedure TDocFlowSchemaForm.QuickHighlightMethod(dfMethodsId:Integer);
var
 Method:TMiceFlowConnector;
begin
 Method:=Self.FindMethod(dfMethodsId);
  if Assigned(Method) then
   Method.Color:=clSoftOrange
end;

procedure TDocFlowSchemaForm.HighlightFolder(dfPathFoldersId:Integer);
var
 Folder:TMiceFlowObject;
begin
  Folder:=FindFolder(dfPathFoldersId);
   if Assigned(Folder) then
    begin
     if Folder.BkColor<>clSoftOrange then
      Folder.BkColor:=clSoftOrange
       else
      Folder.BkColor:=clDarkOrange
    end;
end;

procedure TDocFlowSchemaForm.UpdateLabel(Item: TdxFcItem);
var
 C:TMiceFlowConnector;
 F:TMiceFlowObject;
resourcestring
 S_WORKFLOW_SCHEMA_COMMENT = '<Comment>';
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
   if F.IsCommentFolder then
    Self.lbInfo.Caption:=S_WORKFLOW_SCHEMA_COMMENT
     else
    lbInfo.Caption:=Format('dfPathFoldersId = %d',[F.DfPathFoldersId]);
  end
   else
  ClearInfoLabel;
end;



procedure TDocFlowSchemaForm.HighlightMethod(dfMethodsId:Integer);
var
 Method:TMiceFlowConnector;
begin
   Method:=Self.FindMethod(dfMethodsId);
   if Assigned(Method) then
    begin
     if Method.Color<>clSoftOrange then
      Method.Color:=clSoftOrange
       else
      Method.Color:=clDarkOrange;
    end;
end;

procedure TDocFlowSchemaForm.PlayTimerTimer(Sender: TObject);
begin
 if (FStepCount mod 2)=0 then
 HighlightMethod(FFlowDataSet.FieldByName('dfMethodsId').AsInteger)
  else
  begin
   HighlightFolder(FFlowDataSet.FieldByName('dfPathFoldersId').AsInteger);
   FFlowDataSet.Next;
   Self.UpdateStepLabel;
   Inc(FCurrentStep);
  end;

 Inc(FStepCount);
 Chart.Repaint;

 if FFlowDataSet.Eof then
  begin
   QuickForwardToEnd;
   StopPlay;
  end;
end;


procedure TDocFlowSchemaForm.QuickForwardToEnd;
begin
 FFlowDataSet.First;
 while not FFlowDataSet.Eof do
  begin
    QuickHighlightMethod(FFlowDataSet.FieldByName('dfMethodsId').AsInteger);
    QuickHighlightFolder(FFlowDataSet.FieldByName('dfPathFoldersId').AsInteger);
    FFlowDataSet.Next;
  end;
  Chart.Repaint;
end;

class procedure TDocFlowSchemaForm.ShowSchema(DataSet: TxDataSet; dfPathFoldersId: Integer);
var
 Dlg:TDocFlowSchemaForm;
begin
 Dlg:=TDocFlowSchemaForm.Create(nil);
 try
  Dlg.dfPathFoldersId:=dfPathFoldersId;
  Dlg.Init(DataSet);
  Dlg.ShowFlow;
 finally
  Dlg.Free;
 end;
end;

procedure TDocFlowSchemaForm.StartHighlightFlowObject;
begin
 FFlowObject:=FindFolder(Self.dfPathFoldersId);
 BlinkTimer.Enabled:=Assigned(FFlowObject);
end;

procedure TDocFlowSchemaForm.StartPlay;
begin
 StopHighlightFlowObject;
 ReloadSchema;
 LoadDocumentHistrory(Self.DocumentsId);

 if FFlowDataSet.FieldByName('dfMethodsId').AsInteger<=0 then
 FStepCount:=1
  else
 FStepCount:=0;
 FCurrentStep:=1;
 Self.FFlowDataSet.First;
 Self.bnPlay.Enabled:=False;
 Self.bnStop.Enabled:=True;
 Self.bnForward.Enabled:=False;
 Self.bnBackward.Enabled:=False;
 Self.PlayTimer.Enabled:=True;
 Self.bnRefresh.Enabled:=False;
end;

procedure TDocFlowSchemaForm.StopHighlightFlowObject;
begin
 BlinkTimer.Enabled:=False;
end;

procedure TDocFlowSchemaForm.StopPlay;
begin
 Self.PlayTimer.Enabled:=False;
 Self.bnPlay.Enabled:=True;
 Self.bnStop.Enabled:=False;
 Self.bnForward.Enabled:=True;
 Self.bnBackward.Enabled:=True;
 Self.StartHighlightFlowObject;
 Self.bnRefresh.Enabled:=True;
end;


procedure TDocFlowSchemaForm.UpdateStepLabel;
resourcestring
 S_STEPS_LABEL_CAPTION_FMT = 'Step %d of %d';
begin
 Self.lbSteps.Caption:=Format(S_STEPS_LABEL_CAPTION_FMT,[FCurrentStep, FFlowDataSet.RecordCount]);
 Self.lbSteps.Visible:=True;
end;

procedure TDocFlowSchemaForm.BlinkTimerTimer(Sender: TObject);
begin
 if Assigned(FFlowObject) then
  FFlowObject.Selected:=not FFlowObject.Selected;
end;

end.
