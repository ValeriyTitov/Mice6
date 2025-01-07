unit ManagerEditor.Script.SyntaxFrame;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  CustomControl.MiceSyntaxEdit,
  DAC.XDataSet, Vcl.ComCtrls, Vcl.ExtCtrls, Vcl.StdCtrls, Vcl.DBCtrls, Data.DB,
  cxGraphics, cxControls, cxLookAndFeels, cxLookAndFeelPainters,
  dxBarBuiltInMenu, cxPC, cxStyles, cxCustomData, cxFilter, cxData,
  cxDataStorage, cxEdit, cxNavigator, cxDBData, cxGridLevel, cxClasses,
  cxGridCustomView, cxGridCustomTableView, cxGridTableView, cxGridDBTableView,
  Common.StringUtils,
  cxGrid,
  ClipBrd,
  Common.Images,
  Common.LookAndFeel,
  Mice.Script.ClassTree,
  StaticDialog.MiceInputBox,
  ManagerEditor.Script.Runner,
  DAC.DataSetList,
  DAC.DatabaseUtils,
  Common.ResourceStrings,
  DAC.XParams,
  cxDataControllerConditionalFormattingRulesManagerDialog, dxDateRanges,
  Params.SourceSelectorFrame, cxContainer, cxTreeView, cxSplitter,
  dxScrollbarAnnotations, cxTextEdit, Vcl.Menus, Vcl.StdActns, System.Actions,
  Vcl.ActnList, dxStatusBar;

type
  TDBMemo = class (TMiceSyntaxEdit)
  end;

  TSyntaxFrame = class(TFrame)
    pnBottom: TPanel;
    Editor: TDBMemo;
    EditorDS: TDataSource;
    pgOutput: TcxPageControl;
    tabInfo: TcxTabSheet;
    tabGrid: TcxTabSheet;
    ExecutionInfo: TRichEdit;
    DataSource: TDataSource;
    MainView: TcxGridDBTableView;
    MainGridLevel1: TcxGridLevel;
    MainGrid: TcxGrid;
    Splitter1: TSplitter;
    pnParams: TPanel;
    ParamsFrame: TCommandPropertiesFrame;
    pnDataTree: TPanel;
    DataTree: TcxTreeView;
    cxSplitter1: TcxSplitter;
    pnHelp: TPanel;
    memoHelp: TMemo;
    PopupMenu1: TPopupMenu;
    ActionList1: TActionList;
    EditCut1: TEditCut;
    EditCopy1: TEditCopy;
    EditPaste1: TEditPaste;
    EditSelectAll1: TEditSelectAll;
    EditUndo1: TEditUndo;
    EditDelete1: TEditDelete;
    Copy1: TMenuItem;
    Cut1: TMenuItem;
    Paste1: TMenuItem;
    SelectAll1: TMenuItem;
    Undo1: TMenuItem;
    N1: TMenuItem;
    acQuote: TAction;
    Quote1: TMenuItem;
    StatusBar: TdxStatusBar;
    procedure MainViewCustomDrawCell(Sender: TcxCustomGridTableView;
      ACanvas: TcxCanvas; AViewInfo: TcxGridTableDataCellViewInfo;
      var ADone: Boolean);
    procedure EditorChange(Sender: TObject);
    procedure DataTreeDblClick(Sender: TObject);
    procedure DataTreeChange(Sender: TObject; Node: TTreeNode);
    procedure MainViewKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure acQuoteExecute(Sender: TObject);
    procedure EditorKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    FDataSet:TxDataSet;
    FID: Integer;
    FSyntax: string;
    FWasChanged: Boolean;
    FScriptName: string;
    FScriptRunner: TCustomScriptRunner;
    FOldText:string;
    FOnInsertNewItem: TNotifyEvent;
    FTableName: string;
    FKeyField: string;
    FParentId: Integer;
    FOnScriptSave: TNotifyEvent;
    FParamsPanelVisible: Boolean;
    FDetailDataSet:TDataSetList;
    FParamsDataSet: TxDataSet;
    FDataTreeVisible: Boolean;
    FFlags: Integer;
    FSelectedText:TStringList;
    procedure SetSyntax(const Value: string);
    procedure SetColumnsWidth;
    procedure DoOnSuccess(DataSet:TDataSet; Lines:TStrings);
    procedure FocusOnErrorLine;
    procedure DoOnError(DataSet:TDataSet; Lines:TStrings);
    procedure DoOnProgress(DataSet:TDataSet; Lines:TStrings);
    procedure InsertNewScript;
    procedure SetParamsPanelVisible(const Value: Boolean);
    procedure SetDataTreeVisible(const Value: Boolean);
    function GetDBName: string;
    procedure SetDBName(const Value: string);
  protected
    function QuoteFirstWord(AText:string):string;
    procedure GetObjectDetails;
    procedure InternalExecute;
    procedure DoOnInsertNewItem;
    procedure DoOnScriptSave;
    procedure GoOrCreateEvent(const EventName:string);
  public
    constructor Create(AOwner:TComponent);override;
    destructor Destroy; override;
    procedure Open(ID:Integer);
    procedure NewScript;
    procedure Execute;
    procedure CreateScriptRunner(AClass:TCustomScriptRunnerClass);
    procedure FormatCurrentText;
    procedure CollectParams(Params:TxParams);
    procedure PrepareToExecute;
    function ScriptTypeToSyntax(const ScriptType: Variant):string;
    property ID:Integer read FID;
    property ScriptRunner:TCustomScriptRunner read FScriptRunner;
    property Syntax:string read FSyntax write SetSyntax;
    property WasChanged:Boolean read FWasChanged write FWasChanged;
    property ScriptName:string read FScriptName write FScriptName;
    property DBName:string read GetDBName write SetDBName;
    property OnInsertNewItem:TNotifyEvent read FOnInsertNewItem write FOnInsertNewItem;
    property TableName:string read FTableName write FTableName;
    property KeyField:string read FKeyField write FKeyField;
    property ParentId:Integer read FParentId write FParentId;
    property OnScriptSave:TNotifyEvent read FOnScriptSave write FOnScriptSave;
    property ParamsPanelVisible:Boolean read FParamsPanelVisible write SetParamsPanelVisible;
    property DataTreeVisible:Boolean read FDataTreeVisible write SetDataTreeVisible;
    property DataSet:TxDataSet read FDataSet;
    property ParamDataSet:TxDataSet read FParamsDataSet;
    property Flags:Integer read FFlags write FFlags;
    procedure Save;virtual;
  end;

implementation

resourcestring
 S_INFO_TAB_CAPTION = 'Information';

{$R *.dfm}

{ TSQLScriptFrame }

procedure TSyntaxFrame.acQuoteExecute(Sender: TObject);
begin
// ShowMessage(QuoteFirstWord(Editor.SelectedText));
 Editor.SelectedText:=QuoteFirstWord(Editor.SelectedText);
end;

procedure TSyntaxFrame.CollectParams(Params:TxParams);
begin
 ParamsFrame.LazyInit(nil);
 if ParamDataSet.State in [dsEdit, dsInsert] then
  ParamDataSet.Post;
 Params.LoadFromDataSetList(ParamDataSet,'Name','Value');
end;

constructor TSyntaxFrame.Create(AOwner: TComponent);
begin
  inherited;
  FDataSet:=TxDataSet.Create(Self);
  FDataSet.Source:='TSyntaxFrame';
  EditorDS.DataSet:=FDataSet;
  Self.TableName:='AppScripts';
  Self.KeyField:='AppScriptsId';
  Self.ParamsPanelVisible:=False;
  FDetailDataSet:=TDataSetList.Create;
  FDetailDataSet.MasterKeyField:=Self.KeyField;
  ParamsFrame.MainView.DataController.DataSource:=FDetailDataSet.CreateDataSource('AppScriptsParams','','','TSyntaxFrame.Create','','');
  FParamsDataSet:=ParamsFrame.MainView.DataController.DataSource.DataSet as TxDataSet;
  tabInfo.Caption:=S_INFO_TAB_CAPTION;
  Flags:=0;
  Self.Editor.Lines.OnChange:=Self.EditorChange;
  FSelectedText:=TStringList.Create;
  Self.pnBottom.Visible:=False;
end;

procedure TSyntaxFrame.CreateScriptRunner(AClass: TCustomScriptRunnerClass);
begin
 if Assigned(FScriptRunner) then
  FreeAndNil(FScriptRunner);
 Self.FScriptRunner:=AClass.Create;
 Self.Syntax:=FScriptRunner.Syntax;

 ScriptRunner.DBName:=Self.DBName;
 ScriptRunner.ScriptName:=ScriptName;
 ScriptRunner.OnError:=DoOnError;
 ScriptRunner.OnSuccess:=DoOnSuccess;
 ScriptRunner.OnProgress:=DoOnProgress;
end;

procedure TSyntaxFrame.DataTreeChange(Sender: TObject; Node: TTreeNode);
var
 Entry:TScriptEntry;
begin
if Node.Data<>nil then
 begin
  Entry:=TScriptEntry(Node.Data);
  memoHelp.Lines.Text:=Format('%s'#13'%s',[Entry.Description,Entry.Example]);
 end
  else
   memoHelp.Lines.Text:='';
end;

procedure TSyntaxFrame.DataTreeDblClick(Sender: TObject);
var
 Entry:TScriptEntry;
begin
 if Assigned(DataTree.Selected) and Assigned(DataTree.Selected.Data) then
  begin
    Entry:=DataTree.Selected.Data;
    case Entry.EntryType of
      etAppEvent, etEvent: GoOrCreateEvent(Format(Entry.Example, [DataTree.Selected.Parent.Text]));
//      etEvent:GoOrCreateEvent(Entry.Example);
      etProperty: ShowMessage(Entry.Example+#13+Entry.Description);
      etMethod: ShowMessage(Entry.Example+#13+Entry.Description);
    end;
  end;
end;

destructor TSyntaxFrame.Destroy;
begin
 FSelectedText.Free;
 FDetailDataSet.Free;
 if Assigned(FScriptRunner) then
  FreeAndNil(FScriptRunner);
  inherited;
end;

procedure TSyntaxFrame.DoOnInsertNewItem;
begin
 if Assigned(OnInsertNewItem) then
  OnInsertNewItem(Self);
end;

procedure TSyntaxFrame.DoOnProgress(DataSet: TDataSet; Lines: TStrings);
begin
 tabInfo.Caption:=S_INFO_TAB_CAPTION+'*';
 ExecutionInfo.SelAttributes.Color:=clBlue;
// ExecutionInfo.SelAttributes.fon Font.Style:=[];
 ExecutionInfo.Lines.Add(Lines.Text);
end;

procedure TSyntaxFrame.DoOnScriptSave;
begin
 if Assigned(OnScriptSave) then
  OnScriptSave(Self)
end;

procedure TSyntaxFrame.DoOnError(DataSet: TDataSet; Lines: TStrings);
begin
if Assigned(Lines) then
 ExecutionInfo.Lines.Assign(Lines);
 ExecutionInfo.Font.Color:=clRed;
 ExecutionInfo.Font.Style:=[fsBold];

 DataSource.DataSet:=DataSet;

 FocusOnErrorLine;
 pgOutput.ActivePage:=tabInfo;

end;

procedure TSyntaxFrame.DoOnSuccess(DataSet: TDataSet; Lines: TStrings);
begin
if Assigned(Lines) then
 ExecutionInfo.SelAttributes.Color:=clBlack;
 ExecutionInfo.Font.Color:=clBlack;
 ExecutionInfo.Font.Style:=[];
 ExecutionInfo.Lines.Assign(Lines);
 ExecutionInfo.Lines.Add('OK');

if Assigned(DataSet) then
 begin
  DataSource.DataSet:=DataSet;
  SetColumnsWidth;
  StatusBar.Panels[0].Text:=Format(S_ROWS_FMT, [DataSet.RecordCount]);
  StatusBar.Panels[1].Text:=Format(S_COLUMNS_FMT, [DataSet.FieldCount]);
  if DataSet.FieldCount>0 then
   pgOutput.ActivePage:=tabGrid
    else
   pgOutput.ActivePage:=tabInfo;
 end
  else
   pgOutput.ActivePage:=tabInfo;

end;

procedure TSyntaxFrame.EditorChange(Sender: TObject);
begin
 FWasChanged:=True;
end;

procedure TSyntaxFrame.EditorKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
 if (ssAlt in Shift) and (Key=VK_F1) then
  GetObjectDetails;
end;

procedure TSyntaxFrame.Execute;
resourcestring
 S_NO_SCRIPTRUNNER_ASSIGNED = 'Script runner not assigned for this instance of %s';
begin
 tabInfo.Caption:=S_INFO_TAB_CAPTION;
 ExecutionInfo.Lines.Clear;
 if Assigned(ScriptRunner) then
  InternalExecute
   else
  raise Exception.CreateFmt(S_NO_SCRIPTRUNNER_ASSIGNED, [ClassName]);
end;

procedure TSyntaxFrame.FocusOnErrorLine;
begin
 if ScriptRunner.ErrorLineNumber<>0 then
  Editor.FocusLine(ScriptRunner.ErrorLineNumber-1);
end;

procedure TSyntaxFrame.FormatCurrentText;
begin
 ScriptRunner.InfoLines.Clear;
 ScriptRunner.OnError:=DoOnError;
 ScriptRunner.OnSuccess:=DoOnSuccess;
 ScriptRunner.Text:=Editor.Lines;
 Editor.Lines.Text:=ScriptRunner.Format;
end;


function TSyntaxFrame.GetDBName: string;
begin
 Result:=DataSet.FieldByName('DBName').AsString;
end;

procedure TSyntaxFrame.GetObjectDetails;
var
 s:string;
begin
   if Editor.SelectedText.IsEmpty then
       s:=Editor.WordAtCursor
        else
       s:=Editor.SelectedText;
  Self.PrepareToExecute;
  ScriptRunner.ObjectDetails(s)
end;

procedure TSyntaxFrame.GoOrCreateEvent(const EventName: string);
var
 AIndex:Integer;
begin
 AIndex:=Editor.FindTextLineIndex(EventName);
 if AIndex>=0 then
  Editor.GotoLine(AIndex+1)
   else
    begin
     AIndex:=Editor.Lines.Count-2;
     if AIndex<0 then
      AIndex:=0;
     Editor.Lines.InsertText(AIndex,#13+EventName+#13+'begin'+#13+'end;'#13#13);
     Editor.GotoLine(AIndex);
    end;
end;

procedure TSyntaxFrame.InsertNewScript;
var
 s:string;
begin
 s:=ScriptName;
 if TMiceInputBox.Execute(42,s) then
  begin
    FDataSet.FieldByName(KeyField).AsInteger:=TDataBaseUtils.NewAppObjectId(sq_AppScripts);
    FDataSet.FieldByName('Name').AsString:=s;
    FDataSet.FieldByName('Syntax').AsString:=FScriptRunner.Syntax;
    FScriptName:=s;
    FDataSet.ApplyUpdatesIfChanged;
    FID:=FDataSet.FieldByName(KeyField).AsInteger;
    Self.FDetailDataSet.MasterID:=FID;
    DoOnInsertNewItem;
  end;
end;

procedure TSyntaxFrame.InternalExecute;
begin
  PrepareToExecute;
  ScriptRunner.Run;
end;

procedure TSyntaxFrame.MainViewCustomDrawCell(Sender: TcxCustomGridTableView; ACanvas: TcxCanvas; AViewInfo: TcxGridTableDataCellViewInfo; var ADone: Boolean);
var
 CellValue:Variant;
 x:Integer;
begin
 for x:=0 to AViewInfo.GridRecord.ValueCount-1 do
    begin
     CellValue:=AViewInfo.GridRecord.Values[x];
     if VarIsNull(CellValue) and (AViewInfo.Item.Index=x) then
        ACanvas.Brush.Color:=clSoftYellow;
    end;

 if AViewInfo.GridRecord.Selected then
  begin
   ACanvas.Font.Color:=clBlack;
   ACanvas.Brush.Color:=clSoftSilver;
  end;
 if AViewInfo.Focused and AViewInfo.GridRecord.Focused then
  ACanvas.Brush.Color:=clSilver;
end;

procedure TSyntaxFrame.MainViewKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
var
  AGridSite: TcxGridSite;
  AGridView: TcxGridTableView;
  AValue: string;
begin
  if ((Key = Ord('C')) or (Key=VK_INSERT)) and (ssCtrl in Shift) then
  begin
    AGridSite := Sender as TcxGridSite;
    AGridView := AGridSite.GridView as TcxGridTableView;
    AValue := VarToStr(AGridView.Controller.FocusedColumn.EditValue);
    Clipboard.AsText := AValue;
    Key := 0;
  end;
end;

procedure TSyntaxFrame.NewScript;
begin
 Open(-1);
end;

procedure TSyntaxFrame.Open(ID: Integer);
const
 AppScriptProviderPattern = 'SELECT * FROM [%s] WITH (NOLOCK) WHERE %s = %d';
begin
 FID:=ID;
 Self.FDetailDataSet.MasterID:=ID;
 FDataSet.ProviderName:=Format(AppScriptProviderPattern,[TableName, KeyField, ID]);
 FDataSet.Open;
 if FID>0 then
 ScriptName:=FDataSet.FieldByName('Name').AsString;
 FOldText:=Editor.Lines.Text;
 if FID<0 then
  FDataSet.Insert
   else
  FDataSet.Edit;
 FWasChanged:=False;
end;

procedure TSyntaxFrame.PrepareToExecute;
begin
 ExecutionInfo.SelAttributes.Color:=clBlack;
 ExecutionInfo.Font.Style:=[];

  CollectParams(ScriptRunner.Params);
  if Editor.SelectionLength>0 then
   FSelectedText.Text:=Editor.SelectedText
    else
   FSelectedText.Assign(Editor.Lines);

  ScriptRunner.Text:=FSelectedText;
end;

function TSyntaxFrame.QuoteFirstWord(AText: string): string;
var
 List:TStringList;
 x:Integer;
 s:string;
 s1:string;
begin
 List:=TStringList.Create;
 try
  List.QuoteChar:=#0;
  List.Text:=AText;
  for x:=0 to List.Count-1 do
   begin
    s:=TStringUtils.ExtractWordDef(List[x],0,List[x]).Trim;
    s1:=s;
    if s.StartsWith('"')=False then
     s:='"'+s;
    if s.EndsWith('"')=False then
     s:=s+'"';
    List[x]:=List[x].Replace(s1,s);
   end;
  if List[List.Count-1]='' then
   List.Delete(List.Count-1);
  Result:=List.Text;
 finally
  List.Free;
 end;
end;

procedure TSyntaxFrame.Save;
begin
 if FID<0 then
  InsertNewScript
   else
  FDataSet.ApplyUpdatesIfChanged;
  FDetailDataSet.ApplyUpdatesAll;
  FWasChanged:=False;
end;

function TSyntaxFrame.ScriptTypeToSyntax(const ScriptType: Variant): string;
begin
if VarIsNull(ScriptType) then
 Result:='SQL'
  else
 case ScriptType of
   0:Result:='SQL';
   1:Result:='Pascal';
   2:Result:='CSharp';
   else
    Result:='SQL';
 end;
end;


procedure TSyntaxFrame.SetColumnsWidth;
var
 x:Integer;
 C:TcxGridDBColumn;
begin
 MainView.ClearItems;
 MainView.DataController.CreateAllItems;
 for x:=0 to MainView.ColumnCount-1 do
  begin
   C:=MainView.Columns[x];
   C.Width:=C.DataBinding.FieldName.Length*7+5;
   if (C.DataBinding.Field.DataType=ftDate) or (C.DataBinding.Field.DataType=ftDateTime)  then
    C.Width:=110;

   C.PropertiesClass:=TcxTextEditProperties;
   (C.Properties as TcxTextEditProperties).UseNullString:=True;
   (C.Properties as TcxTextEditProperties).Nullstring:='NULL';
  end;
end;


procedure TSyntaxFrame.SetDataTreeVisible(const Value: Boolean);
begin
  FDataTreeVisible := Value;
  Self.pnDataTree.Visible:=Value;
  Self.pnHelp.Visible:=Value;
  Self.pnBottom.Visible:=Value;
end;


procedure TSyntaxFrame.SetDBName(const Value: string);
begin
 DataSet.Edit;
 DataSet.FieldByName('DBName').AsString:=Value;
end;

procedure TSyntaxFrame.SetParamsPanelVisible(const Value: Boolean);
begin
  FParamsPanelVisible := Value;
  Self.pnParams.Visible:=Value;
  if Value then
   ParamsFrame.LazyInit(nil);
end;

procedure TSyntaxFrame.SetSyntax(const Value: string);
begin
  Editor.Syntax:=Value;
  FSyntax:=Value;
end;



end.
