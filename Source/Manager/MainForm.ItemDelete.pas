unit MainForm.ItemDelete;

interface
 uses
  DAC.XDataSet, Windows, Common.ResourceStrings, Forms, SysUtils, Classes,
  System.Generics.Collections, System.Generics.Defaults,
  Manager.WindowManager, cxTL;

type

 TMainFormItemDelete = class
  private
    FAppMainTreeId: Integer;
    FiType: Integer;
    FObjectId: Integer;
    FDBName: string;
    FNode: TcxTreeListNode;
    function AllowedToDelete:Boolean;
    function RequireToDeleteObject:Boolean;
    function IsMetaObject:Boolean;
    function ItemHasChilds:Boolean;
    procedure CheckBeforeDelete;
    procedure DeleteMetaAppObject;
    procedure DeleteDocFlowAppObject;
    procedure DeleteAppMainTree;
    procedure DeleteObject;
    function SchemaFolderCount:Integer;
   public
    property AppMainTreeId:Integer read FAppMainTreeId write FAppMainTreeId;
    property iType:Integer read FiType write FiType;
    property ObjectId:Integer read FObjectId write FObjectId;
    property DBName:string read FDBName write FDBName;
    property Node:TcxTreeListNode read FNode write FNode;
    procedure Delete;
    function Execute:Boolean;
    constructor Create;
    destructor Destroy;override;
 end;

const
 ItemDeleteFilter = 'iType in (0,1,2,3,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21)';

implementation

var
 FDelList: TDictionary<Integer, Boolean>;

{ TMainFormItemDelete }

function TMainFormItemDelete.AllowedToDelete: Boolean;
begin
 Result:=RequireToDeleteObject or (iType=iTypeAppDataSet) or (iType=iTypeFolder) or (iType=iTypeDfScheme) or (iType=iTypeCommandGroup);
end;

procedure TMainFormItemDelete.CheckBeforeDelete;
resourcestring
 E_CANNOT_DELETE_TREEITEM_WITH_ITYPE_FMT = 'Cannot delete tree item with iType %d and AppMainTreeId %d';
 E_CANNOT_DELETE_DFSCHEMA_WITH_FOLDERS = 'Cannot delete Doc flow schema while folders inside.';
 E_CANNOT_DELETE_OBJECT_WITH_CHILDREN = 'Cannot delete object while children nodes exists.';
begin
 if (AppMainTreeId=-1) or (not AllowedToDelete) then
  raise Exception.CreateFmt(E_CANNOT_DELETE_TREEITEM_WITH_ITYPE_FMT,[iType, AppMainTreeId]);
 if (iType=iTypeDfScheme) and (SchemaFolderCount<>0) then
  raise Exception.Create(E_CANNOT_DELETE_DFSCHEMA_WITH_FOLDERS);
 if ItemHasChilds then
  raise Exception.Create(E_CANNOT_DELETE_OBJECT_WITH_CHILDREN);
end;


constructor TMainFormItemDelete.Create;
begin
 iType:=-1;
 AppMainTreeId:=-1;
end;

procedure TMainFormItemDelete.Delete;
begin
 CheckBeforeDelete;
 if RequireToDeleteObject then
   DeleteObject;

 DeleteAppMainTree;
end;

procedure TMainFormItemDelete.DeleteAppMainTree;
var
 Tmp:TxDataSet;
begin
 Tmp:=TxDataSet.Create(nil);
 try
   Tmp.Source:='TMainFormItemDelete.DeleteAppMainTree';
   Tmp.ProviderName:='spui_AppDeleteAppMainTree';
   Tmp.SetParameter('AppMainTreeId',AppMainTreeId);
   Tmp.Execute;
 finally
   Tmp.Free;
 end;
end;

procedure TMainFormItemDelete.DeleteDocFlowAppObject;
var
 Tmp:TxDataSet;
begin
 Tmp:=TxDataSet.Create(nil);
 try
   Tmp.Source:='TMainFormItemDelete.DeleteDocFlowAppObject';
   Tmp.ProviderName:='spui_dfDeleteAppObject';
   Tmp.SetParameter('ObjectId',ObjectId);
   Tmp.SetParameter('iType',iType);
   Tmp.DBName:=Self.DBName;
   Tmp.Execute;
 finally
   Tmp.Free;
 end;
end;

procedure TMainFormItemDelete.DeleteMetaAppObject;
var
 Tmp:TxDataSet;
begin
 Tmp:=TxDataSet.Create(nil);
 try
   Tmp.Source:='TMainFormItemDelete.DeleteAppObject';
   Tmp.ProviderName:='spui_AppDeleteObject';
   Tmp.SetParameter('ObjectId',ObjectId);
   Tmp.SetParameter('iType',iType);
   Tmp.Execute;
 finally
   Tmp.Free;
 end;
end;

procedure TMainFormItemDelete.DeleteObject;
begin
 if IsMetaObject then
  DeleteMetaAppObject
   else
  DeleteDocFlowAppObject;
end;

destructor TMainFormItemDelete.Destroy;
begin
  inherited;
end;

function TMainFormItemDelete.Execute: Boolean;
begin
 Result:=MessageBox(Application.Handle,PChar(S_COMMON_DELETE_RECORD_CONFIRMATION), PChar(S_COMMON_DELETE_RECORD_CAPTION), MB_YESNO+MB_ICONQUESTION)=ID_YES;
 if Result then
  Delete;
end;

function TMainFormItemDelete.IsMetaObject: Boolean;
begin
 Result:=FDelList[iType];
end;

function TMainFormItemDelete.ItemHasChilds: Boolean;
begin
 Result:=Assigned(Node) and Node.HasChildren;
end;

function TMainFormItemDelete.RequireToDeleteObject: Boolean;
begin
 Result:=FDelList.ContainsKey(iType)
end;


function TMainFormItemDelete.SchemaFolderCount: Integer;
var
 Tmp:TxDataSet;
begin
 Tmp:=TxDataSet.Create(nil);
 try
  Tmp.Source:='TMainFormItemDelete.SchemaFolderCount';
  Tmp.ProviderName:='spui_dfPathFoldersList';
  Tmp.SetParameter('dfTypesId',ObjectId);
  Tmp.DBName:=Self.DBName;
  Tmp.Open;
  Result:=Tmp.RecordCount;
 finally
   Tmp.Free;
 end;
end;

initialization
 FDelList:= TDictionary<Integer, Boolean>.Create;
 FDelList.Add(iTypePlugin, True);
 FDelList.Add(iTypeDialog, True);
 FDelList.Add(iTypeAppDialogLayout, True);
 FDelList.Add(iTypeCommonCommand, True);
 FDelList.Add(iTypeCommand, True);
 FDelList.Add(iTypeFilter, True);
 FDelList.Add(iTypeCommonFilter, True);
 FDelList.Add(iTypeSQLScript, True);
 FDelList.Add(iTypePascalScript, True);
 FDelList.Add(iTypeCSharpScript, True);
 FDelList.Add(iTypeJsonText, True);
 FDelList.Add(iTypeXMLText, False);
 FDelList.Add(iTypeExternalFile, True);
 FDelList.Add(iTypeAppTemplate, True);

 FDelList.Add(iTypeDFClass, False);
 FDelList.Add(iTypeDfTypes, False);



finalization
 FDelList.Free;

end.
