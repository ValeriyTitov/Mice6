unit DocFlow.NewDocument.SelectionDialog;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, StaticDialog.ItemTreeSelector.Common,
  cxGraphics, cxLookAndFeels, cxLookAndFeelPainters, Vcl.Menus, cxControls,
  cxCustomData, cxStyles, cxTL, cxMaskEdit, cxTLdxBarBuiltInMenu,
  cxInplaceContainer, cxDBTL, cxTLData, Vcl.StdCtrls, cxButtons, Vcl.ExtCtrls;

type
  TDocFlowNewDocDialog = class(TCommonSelectTreeDialog)
    colObjectId: TcxDBTreeListColumn;
    colIType: TcxDBTreeListColumn;
  private
    FDBName: string;
    FDfPathFoldersId: Integer;
    FAppDialogsLayoutId: Integer;
    FDfTypesId: Integer;
    FDfClassesId: Integer;
  public
    function Execute: Boolean; override;
    property DfTypesId:Integer read FDfTypesId write FDfTypesId;
    property DfClassesId:Integer read FDfClassesId write FDfClassesId;
    property DfPathFoldersId:Integer read FDfPathFoldersId write FDfPathFoldersId;
    property AppDialogsLayoutId:Integer read FAppDialogsLayoutId write FAppDialogsLayoutId;
    property DBName:string read FDBName write FDBName;
    constructor Create(AOwner:TComponent); override;
  end;

implementation

{$R *.dfm}

{ TDocFlowNewDocDialog }

constructor TDocFlowNewDocDialog.Create(AOwner: TComponent);
const
 iTypeDfPathFolder = 23;
begin
  inherited;
  ParentIdField:='ParentId';
  KeyField:='Id';
  TreeView.DataSet.ProviderName:='spui_dfStartingFolderList';
  TreeView.DataSet.SetParameter('AllowDeskTop',1);
  EnabledField:='iType';
  EnabledValue:=iTypeDfPathFolder;
  ExpandLevel:=3;
end;

function TDocFlowNewDocDialog.Execute: Boolean;
resourcestring
 E_CANNOT_FIND_STARTING_FOLDER_FMT ='Cannot find starting folders for dfClassesId=%d';
begin
 TreeView.DataSet.DBName:=Self.DBName;
 TreeView.DataSet.SetParameter('DfClassesId',DfClassesId);
 TreeView.DataSet.Open;
 if TreeView.DataSet.RecordCount<=0 then
  raise Exception.CreateFmt(E_CANNOT_FIND_STARTING_FOLDER_FMT, [dfClassesId]);


 Result:=inherited Execute;
 if Result then
  begin
    DfPathFoldersId:=TreeView.DataSet.FieldByName('ObjectId').AsInteger;
    DfTypesId:=TreeView.FocusedNode.Parent.Values[colObjectId.ItemIndex];
    AppDialogsLayoutId:=TreeView.DataSet.FieldByName('AppDialogsLayoutId').AsInteger
  end;
end;


end.
