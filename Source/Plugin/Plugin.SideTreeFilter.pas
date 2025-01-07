unit Plugin.SideTreeFilter;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Db, Variants, Vcl.ExtCtrls, cxClasses,
  cxGraphics, cxControls, cxLookAndFeels, cxLookAndFeelPainters,
  cxCustomData, cxStyles, cxTL, cxTLdxBarBuiltInMenu, cxInplaceContainer,
  cxTLData, cxDBTL, cxMaskEdit, cxContainer, cxEdit, cxTextEdit,
  cxDataControllerConditionalFormattingRulesManagerDialog,
  CustomControl.Interfaces,
  CustomControl.TreeGrid,
  CustomControl.MiceTreeGrid.ColumnBuilder,
  Common.Images,
  DAC.XDataSet,
  DAC.XParams.Utils,
  DAC.XParams, Vcl.Menus, dxScrollbarAnnotations;

type
  TcxDBTreeList = class(TMiceTreeGrid);

  TSideTreeFilter = class(TFrame, ICanManageParams, ICanSaveLoadState)
    TreeFilter: TcxDBTreeList;
    colID: TcxDBTreeListColumn;
    colParentId: TcxDBTreeListColumn;
    colName: TcxDBTreeListColumn;
    SideTreePopupMenu: TPopupMenu;
    miRefresh: TMenuItem;
    colHint: TcxDBTreeListColumn;
    colValue: TcxDBTreeListColumn;
    colOrderId: TcxDBTreeListColumn;
    procedure miRefreshClick(Sender: TObject);
    procedure TreeFilterGetCellHint(Sender: TcxCustomTreeList; ACell: TObject; var AText: string; var ANeedShow: Boolean);
  private
    FParamName: string;
    FAutoRefresh: Boolean;
    FActive: Boolean;
    FCustomProviderEnabled: Boolean;
    FProviderField:TField;
    FExpandLevel: Integer;
    FAfterCustomRefresh: TNotifyEvent;
    FCaptionField: string;
    FInheritableAppObject: IInheritableAppObject;
    procedure SetActive(const Value: Boolean);
    function GetCurrentProviderName: string;
    function FindCaptionField:TField;
    procedure SetExpandLevel(const Value: Integer);
    procedure SetParamName(const Value: string);
    procedure SetAfterCustomRefresh(const Value: TNotifyEvent);
    procedure LoadState(Params:TxParams);
    procedure SaveState(Params:TxParams);
    procedure SetParamsTo(Params:TxParams);
  public
    function KeyFieldValue:Variant;
    property AutoRefresh:Boolean read FAutoRefresh write FAutoRefresh;
    property CaptionField:string read FCaptionField write FCaptionField;
    property Active:Boolean read FActive write SetActive;
    property CurrentProviderName:string read GetCurrentProviderName;
    property CustomProviderEnabled:Boolean read FCustomProviderEnabled;
    property ParamName:string read FParamName write SetParamName;
    property ExpandLevel:Integer read FExpandLevel write SetExpandLevel;
    property AfterCustomRefresh:TNotifyEvent read FAfterCustomRefresh write SetAfterCustomRefresh;
    property InheritableAppObject:IInheritableAppObject read FInheritableAppObject write FInheritableAppObject;
    function HasCustomProvider:Boolean;
    procedure Initialize;
    procedure DoRefreshTree;
    constructor Create(AOwner:TComponent); override;
  end;

implementation

{$R *.dfm}

{ TSideTreeFilter }


procedure TSideTreeFilter.Initialize;
var
 F:TField;
begin
 F:=FindCaptionField;
 if Assigned(F) then
  begin
    Self.colName.DataBinding.FieldName:=F.FieldName;
    Self.TreeFilter.PathColumn:=ColName;
  end;

  colValue.Visible:=Assigned(TreeFilter.DataSet.FindField('Value'));
  colID.DataBinding.FieldName:=TreeFilter.DataController.KeyField;
  colParentId.DataBinding.FieldName:=TreeFilter.DataController.ParentField;
//  Self.colOrederID.DataBinding.FieldName:=TreeFilter.DataController.Or


  FProviderField:=TreeFilter.DataSet.FindField('ProviderName');
  FCustomProviderEnabled:=Assigned(FProviderField);
  TreeFilter.ExpandByLevel(ExpandLevel);
end;

function TSideTreeFilter.KeyFieldValue: Variant;
var
 F:TField;
resourcestring
 S_SIDETREE_FIELD_NOT_FOUND_FMT ='SideTree dataset does not contain field "%s"';
begin
 if ParamName.Trim.IsEmpty then
  Exit(Null);

 F:=TreeFilter.DataSet.FindField(ParamName);
 if not Assigned(F) then
  raise Exception.CreateFmt(S_SIDETREE_FIELD_NOT_FOUND_FMT,[ParamName]);

 Result:=TreeFilter.DataSet.FindField(ParamName).Value;
end;

procedure TSideTreeFilter.miRefreshClick(Sender: TObject);
begin
 DoRefreshTree;
end;

constructor TSideTreeFilter.Create(AOwner: TComponent);
begin
  inherited;
  miRefresh.ImageIndex:=IMAGEINDEX_ACTION_REFRESH;
  TMiceTreeGridColumnBuilder.SetStyles(TreeFilter);
end;

procedure TSideTreeFilter.DoRefreshTree;
var
 Event:TcxTreeListFocusedNodeChangedEvent;
begin
 TreeFilter.BeginUpdate;
 Event:=TreeFilter.OnFocusedNodeChanged;
 TreeFilter.OnFocusedNodeChanged:=nil;
   try
    if Assigned(InheritableAppObject) then
     begin
       TreeFilter.DataSet.DBName:=InheritableAppObject.DBName;
       InheritableAppObject.ParamsMapper.MapDataSet(TreeFilter.DataSet);
     end;
    TreeFilter.ReQueryTree;
   finally
    TreeFilter.OnFocusedNodeChanged:=Event;
    TreeFilter.EndUpdate;
   end;
 if Assigned(AfterCustomRefresh) then
  AfterCustomRefresh(Self);
end;

function TSideTreeFilter.FindCaptionField: TField;
begin
 Result:=TreeFilter.DataSet.FindField(CaptionField);
 if not Assigned(Result) then
  Result:=TreeFilter.DataSet.FindField('Caption');
 if not Assigned(Result) then
  Result:=Self.TreeFilter.DataSet.FindField('Name');
 if not Assigned(Result) then
  Result:=Self.TreeFilter.DataSet.FindField('Description');
end;

function TSideTreeFilter.GetCurrentProviderName: string;
begin
 Result:=FProviderField.AsString;
end;

function TSideTreeFilter.HasCustomProvider: Boolean;
begin
 Result:=(Active) and (CustomProviderEnabled);
end;

procedure TSideTreeFilter.SaveState(Params: TxParams);
begin
 SetParamsTo(Params);
end;

procedure TSideTreeFilter.SetActive(const Value: Boolean);
begin
  FActive := Value;
end;


procedure TSideTreeFilter.SetAfterCustomRefresh(const Value: TNotifyEvent);
begin
  FAfterCustomRefresh := Value;
end;


procedure TSideTreeFilter.SetExpandLevel(const Value: Integer);
begin
  FExpandLevel := Value;
end;


procedure TSideTreeFilter.SetParamName(const Value: string);
begin
  FParamName := TParamUtils.NormalizeParamName(Value);
end;

procedure TSideTreeFilter.SetParamsTo(Params: TxParams);
begin
 if Self.Active and TreeFilter.DataSet.Active and (ParamName.Trim.IsEmpty=False) then
   Params.SetParameter(ParamName,KeyFieldValue);
end;

procedure TSideTreeFilter.LoadState(Params: TxParams);
var
 F:TField;
 DataSet:TDataSet;
 Event:TcxTreeListFocusedNodeChangedEvent;
begin
 if Self.Active and TreeFilter.DataSet.Active then
  begin
   DataSet:=TreeFilter.DataSet;
   F:=DataSet.FindField(ParamName);
   Event:=TreeFilter.OnFocusedNodeChanged;
   if Assigned(F) then
     try
      TreeFilter.OnFocusedNodeChanged:=nil;
      DataSet.Locate(ParamName, Params.ParamByNameDef(ParamName, NULL),[]);
     finally
      TreeFilter.OnFocusedNodeChanged:=Event;
     end;
  end;
end;


procedure TSideTreeFilter.TreeFilterGetCellHint(Sender: TcxCustomTreeList; ACell: TObject; var AText: string; var ANeedShow: Boolean);
var
 Item:TcxTreeListEditCellViewInfo;
begin
 if ACell is TcxTreeListEditCellViewInfo  then
  begin
   Item:=ACell as TcxTreeListEditCellViewInfo;
   AText:=VarToStr(Item.Node.Values[colHint.ItemIndex]);
   ANeedShow:=not AText.IsEmpty;
  end;
end;

end.
