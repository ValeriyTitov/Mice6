unit StaticDialog.ItemTreeSelector.Common;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Dialog.Basic, cxGraphics,
  cxLookAndFeels, cxLookAndFeelPainters, Vcl.Menus, Vcl.StdCtrls, cxButtons,
  Vcl.ExtCtrls, cxControls, cxCustomData, cxStyles, cxTL, cxTLdxBarBuiltInMenu,
  cxDataControllerConditionalFormattingRulesManagerDialog, cxInplaceContainer,
  cxTLData, cxDBTL,
  Data.DB,
  Common.ResourceStrings,
  Common.Registry,
  CustomControl.TreeGrid, cxMaskEdit;


type
 TcxDBTreeList= class(TMiceTreeGrid)

 end;

  TCommonSelectTreeDialog = class(TBasicDialog)
    TreeView: TcxDBTreeList;
    colCaption: TcxDBTreeListColumn;
    colOrderId: TcxDBTreeListColumn;
    lbInfo: TLabel;
    procedure TreeViewDblClick(Sender: TObject);
    procedure TreeViewSelectionChanged(Sender: TObject);
    procedure TreeViewFocusedNodeChanged(Sender: TcxCustomTreeList;
      APrevFocusedNode, AFocusedNode: TcxTreeListNode);
  private
    FSelectedDescription: string;
    FKeyFieldValue: Variant;
    FEnabledField: string;
    FEnabledValue: Variant;
    FExpandLevel: Integer;
    FDescriptionField: string;
    FResultingValue: Variant;
    function GetImageIndexField: string;
    function GetKeyField: string;
    function GetParentIdField: string;
    procedure SetEnabledField(const Value: string);
    procedure SetImageIndexField(const Value: string);
    procedure SetKeyField(const Value: string);
    procedure SetParentIdField(const Value: string);
    procedure TryEnabledOKButton;
    procedure ValidCheck;
    function GetCaptionField: string;
    procedure SetCaptionField(const Value: string);
  public
    constructor Create(AOwner:TComponent); override;
    function Execute: Boolean; override;
    property EnabledField:string read FEnabledField write SetEnabledField;
    property EnabledValue:Variant read FEnabledValue write FEnabledValue;
    property KeyField:string read GetKeyField write SetKeyField;
    property ParentIdField:string read GetParentIdField write SetParentIdField;
    property ImageIndexField:string read GetImageIndexField write SetImageIndexField;
    property DescriptionField:string read FDescriptionField write FDescriptionField;
    property CaptionField:string read GetCaptionField write SetCaptionField;
    property KeyFieldValue:Variant read FKeyFieldValue write FKeyFieldValue;
    property SelectedDescription:string read FSelectedDescription;
    property ExpandLevel:Integer read FExpandLevel write FExpandLevel;
    property ResultingValue:Variant read FResultingValue write FResultingValue;
  end;


implementation

{$R *.dfm}

{ TCommonSelectTreeDialog }

constructor TCommonSelectTreeDialog.Create(AOwner: TComponent);
begin
  inherited;
  FSelectedDescription:='';
  KeyFieldValue:=NULL;
  ImageIndexField:='ImageIndex';
  ParentIdField:='ParentId';
  DescriptionField:='Description';
  EnabledValue:=1;
  lbInfo.Caption:=S_COMMON_NO_ITEM_SELECTED;
end;

function TCommonSelectTreeDialog.Execute: Boolean;
var
 F:TField;
begin
 ValidCheck;
 TreeView.DataSet.Open;
 TreeView.ExpandByLevel(ExpandLevel);
 if not VarIsNull(KeyFieldValue) then
  TreeView.DataSet.Locate(KeyField,KeyFieldValue,[]);

 TProjectRegistry.DefaultInstance.LoadForm(DialogSaveName,True,True,Self);
 Result:=ShowModal=mrOK;
 if Result then
  begin
   TProjectRegistry.DefaultInstance.SaveForm(DialogSaveName,Self);
   KeyFieldValue:=TreeView.DataSet.FieldByName(KeyField).Value;
   F:=TreeView.DataSet.FindField(DescriptionField);
   if Assigned(F) then
    FSelectedDescription:=F.AsString;
  end;
end;


function TCommonSelectTreeDialog.GetCaptionField: string;
begin
 Result:=colCaption.DataBinding.FieldName;
end;

function TCommonSelectTreeDialog.GetImageIndexField: string;
begin
 Result:=TreeView.DataController.ImageIndexField;
end;

function TCommonSelectTreeDialog.GetKeyField: String;
begin
 Result:=TreeView.DataController.KeyField;
end;

function TCommonSelectTreeDialog.GetParentIdField: String;
begin
 Result:=TreeView.DataController.ParentField;
end;

procedure TCommonSelectTreeDialog.SetCaptionField(const Value: string);
begin
 colCaption.DataBinding.FieldName:=Value;
end;

procedure TCommonSelectTreeDialog.SetEnabledField(const Value: string);
begin
  FEnabledField := Value;
  bnOK.Enabled:=Value='';
end;


procedure TCommonSelectTreeDialog.SetImageIndexField(const Value: string);
begin
 TreeView.DataController.ImageIndexField:=Value;
end;

procedure TCommonSelectTreeDialog.SetKeyField(const Value: String);
begin
  TreeView.DataController.KeyField:=Value;
  TreeView.DataSet.KeyField:=Value;
end;


procedure TCommonSelectTreeDialog.SetParentIdField(const Value: String);
begin
 TreeView.DataController.ParentField:=Value;
end;


procedure TCommonSelectTreeDialog.TreeViewDblClick(Sender: TObject);
begin
 if bnOK.Enabled then
  bnOk.Click;
end;

procedure TCommonSelectTreeDialog.TreeViewFocusedNodeChanged(Sender: TcxCustomTreeList; APrevFocusedNode, AFocusedNode: TcxTreeListNode);
var
 sId:string;
 sParentId:string;
begin
 if Assigned(AFocusedNode) then
  begin
   sId:=TreeView.DataSet.FieldByName(KeyField).AsString;
   sParentId:=TreeView.DataSet.FieldByName(ParentIdField).AsString;
   lbInfo.Caption:=Format('ID=%s, ParentId=%s',[sId, sParentId]);
  end
   else
  lbInfo.Caption:=S_COMMON_NO_ITEM_SELECTED;
end;

procedure TCommonSelectTreeDialog.TreeViewSelectionChanged(Sender: TObject);
begin
 TryEnabledOKButton;
end;

procedure TCommonSelectTreeDialog.TryEnabledOKButton;
var
 F:TField;
begin
 F:=TreeView.DataSet.FindField(EnabledField);
 if Assigned(F) then
  bnOK.Enabled:=F.Value=EnabledValue;
end;

procedure TCommonSelectTreeDialog.ValidCheck;
resourcestring
 S_INVALID_FIELD_CONFIGURATION = 'Invalid field configuration.';
begin
 if (KeyField.Trim.IsEmpty) or (ParentIdField.Trim.IsEmpty) or (DescriptionField.Trim.IsEmpty) then
  raise Exception.Create(S_INVALID_FIELD_CONFIGURATION);
end;


end.
