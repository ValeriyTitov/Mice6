unit MainForm.TreeRefresher;

interface
 uses Data.DB,
      System.SysUtils,
      CustomControl.TreeGrid;

type
 TMainFormTreeRefresher = class
  private
    FMainTree: TMiceTreeGrid;
  public
    procedure ItemUpdated(AppMainTreeId, ParentId:Integer; Description: string; ImageIndex:Integer);
    procedure ItemInserted(NewAppMainTreeId, ParentId:Integer; Description: string;  const iType, newObjectId, ImageIndex:Integer);
    procedure ItemDeleted(AppMainTreeId:Integer);
    procedure CompleteRefresh;
    property MainTree: TMiceTreeGrid read FMainTree;
    constructor Create(MainTree: TMiceTreeGrid);
    class function DefaultInstance:TMainFormTreeRefresher;
  end;

implementation
var
 FDefaultInstance:TMainFormTreeRefresher;

procedure TMainFormTreeRefresher.CompleteRefresh;
begin
MainTree.BeginUpdate;
 try
  MainTree.ReQueryTree;
 finally
  MainTree.EndUpdate;
 end;
end;

constructor TMainFormTreeRefresher.Create(MainTree: TMiceTreeGrid);
resourcestring
 S_MAINTREE_CANNOT_CREATE_MORE_THAN_ONE_INSTANCE ='Cannot create more than one instance of MainTree refresher';
begin
 if Assigned(FDefaultInstance) then
  raise Exception.Create(S_MAINTREE_CANNOT_CREATE_MORE_THAN_ONE_INSTANCE);
 inherited Create;
 FMainTree:=MainTree;
 FDefaultInstance:=Self;
end;

class function TMainFormTreeRefresher.DefaultInstance: TMainFormTreeRefresher;
resourcestring
 S_MAINTREE_DEFAULT_INSTANCE_NOT_INITIALIZED = 'Default instance of MainTree refresher is not initialized';

begin
 if Assigned(FDefaultInstance) then
  Result:=FDefaultInstance
   else
  raise Exception.Create(S_MAINTREE_DEFAULT_INSTANCE_NOT_INITIALIZED);
end;

procedure TMainFormTreeRefresher.ItemDeleted(AppMainTreeId: Integer);
var
 DataSet:TDataSet;
 Path:string;
begin
 DataSet:=MainTree.DataSet;
 Path:=MainTree.Path;
 if DataSet.Locate('AppMainTreeId',AppMainTreeId,[]) then
  begin
   DataSet.Edit;
   DataSet.Delete;
  end;
 MainTree.Path:=Path;
end;

procedure TMainFormTreeRefresher.ItemInserted(NewAppMainTreeId,  ParentId: Integer; Description: string; const iType, newObjectId,  ImageIndex: Integer);
begin
 CompleteRefresh;
end;

procedure TMainFormTreeRefresher.ItemUpdated(AppMainTreeId, ParentId: Integer;  Description: string; ImageIndex: Integer);
var
 B:TBookMark;
 DataSet:TDataSet;
begin
 MainTree.BeginUpdate;
 try
 DataSet:=MainTree.DataSet;
 B:=DataSet.Bookmark;
 if DataSet.Locate('AppMainTreeId',AppMainTreeId,[]) then
  begin
   DataSet.Edit;
   DataSet.FieldByName('Description').ReadOnly:=False;
   DataSet.FieldByName('Description').AsString:=Description;
   DataSet.FieldByName('ImageIndex').AsInteger:=ImageIndex;
   DataSet.Post;
  end;
 if DataSet.BookmarkValid(B) then
  DataSet.Bookmark:=B;
 finally
   MainTree.EndUpdate;
 end;

end;


end.
