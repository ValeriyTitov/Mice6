unit ManagerEditor.DocFlowSchema.Validate;

interface

uses
  System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, System.Generics.Collections,
  dxflchrt,dxFlowChartShapes,cxGeometry, Data.DB, System.Types,
  DAC.XDataSet,
  Common.ResourceStrings,
  Common.ResourceStrings.Manager,
  CustomControl.MiceFlowChart,
  CustomControl.MiceFlowChart.Shapes,
  CustomControl.MiceFlowChart.FlowObjects,
  CustomControl.MiceActionList,
  StaticDialog.MiceInputBox;

type
  TDocFlowSchemaValidator = class
  private
    FLastX:Integer;
    fdfTypesId:Integer;
    FSchema:TMiceFlowChart;
    FDBName: string;
    procedure CorrectDfPathFolder(Folder:TMiceFlowObject; DataSet:TDataSet);
    procedure CorrectDfMethod(Method:TMiceFlowConnector; DataSet:TDataSet);
    procedure CreateMissingPathFolder(DataSet:TDataSet);
    procedure CreateMissingMethod(DataSet:TDataSet);
    procedure DoValidateMethods(DataSet:TDataSet);
    procedure DoValidateFolders(DataSet:TDataSet);
    procedure ValidateMethods;
    procedure ValidateFolders;
    procedure FindInvalidFoldersOnSchema(DataSet:TDataSet);
    procedure FindInvalidMethodsOnSchema(DataSet:TDataSet);
    function IsValidMethod(Method:TMiceFlowConnector; DataSet:TDataSet):Boolean;
    function IsValidFolder(Folder:TMiceFlowObject; DataSet:TDataSet):Boolean;
  public
    constructor Create(Schema:TMiceFlowChart; dfTypesId:Integer);
    procedure Validate;
    property DBName:string read FDBName write FDBName;
  end;

implementation

{ TDocFlowSchemaValidator }

procedure TDocFlowSchemaValidator.CorrectDfMethod(Method: TMiceFlowConnector; DataSet: TDataSet);
var
 ASource:TMiceFlowObject;
 ATarget:TMiceFlowObject;
begin
 ASource:=FSchema.PathFolderById(DataSet.FieldByName('dfPathFoldersIdSource').AsInteger);
 ATarget:=FSchema.PathFolderById(DataSet.FieldByName('dfPathFoldersIdTarget').AsInteger);
 Method.SetObjectSource(ASource,0);
 Method.SetObjectDest(ATarget, 0);
 Method.dfPathFoldersIdSource:=ASource.DfPathFoldersId;
 Method.dfPathFoldersIdTarget:=ATarget.DfPathFoldersId;
 Method.Text:=DataSet.FieldByName('Caption').AsString;
end;

procedure TDocFlowSchemaValidator.CorrectDfPathFolder(Folder: TMiceFlowObject; DataSet: TDataSet);
begin
 Folder.Text:=DataSet.FieldByName('Caption').AsString;
end;

constructor TDocFlowSchemaValidator.Create(Schema: TMiceFlowChart; dfTypesId: Integer);
begin
 Self.fdfTypesId:=dfTypesId;
 Self.FSchema:=Schema;
 FLastX:=0;
end;

procedure TDocFlowSchemaValidator.CreateMissingMethod(DataSet: TDataSet);
var
 Method:TMiceFlowConnector;
 ASource:TMiceFlowObject;
 ATarget:TMiceFlowObject;
begin
 ASource:=FSchema.PathFolderById(DataSet.FieldByName('dfPathFoldersIdSource').AsInteger);
 ATarget:=FSchema.PathFolderById(DataSet.FieldByName('dfPathFoldersIdTarget').AsInteger);
 Method:=FSchema.CreateConnection(ASource,ATarget, 0,0) as TMiceFlowConnector;
 Method.Text:=DataSet.FieldByName('Caption').AsString;
 Method.dfMethodsId:=DataSet.FieldByName('dfMethodsId').AsInteger;
 Method.dfPathFoldersIdSource:=ASource.DfPathFoldersId;
 Method.dfPathFoldersIdTarget:=ATarget.DfPathFoldersId;
 Method.Color:=MiceDefaultArrowColor;
 Method.ArrowDest.ArrowType := fcaArrow;
 Method.PenWidth:=2;
 if DataSet.FieldByName('AllowDesktop').AsBoolean = True then
  Method.PenStyle:=TPenStyle.psSolid
   else
  Method.PenStyle:=TPenStyle.psDash;
end;

procedure TDocFlowSchemaValidator.CreateMissingPathFolder(DataSet: TDataSet);
var
 Folder:TMiceFlowObject;
 AShape:TdxFlowChartObjectAdvancedShape;
begin
 AShape:=FSchema.Repository.BasicFlowchartShapes.Shapes[0];
 Folder:=FSchema.CreateObject(FLastX, 0, 100, 75, AShape) as TMiceFlowObject;
 FLastX:=FLastX+Folder.Width+100;
 Folder.ShapeColor := MiceDefaultFolderColor;
 Folder.BkColor := MiceDefaultFolderColorBk;
 Folder.Text:=DataSet.FieldByName('Caption').AsString;
 Folder.DfPathFoldersId:=DataSet.FieldByName('DfPathFoldersId').AsInteger;
 Folder.IsCommentFolder:=False;
end;

procedure TDocFlowSchemaValidator.DoValidateFolders(DataSet: TDataSet);
var
 Folder:TMiceFlowObject;
begin
 while not DataSet.Eof do
  begin
   Folder:=FSchema.FindDfPathFolder(DataSet.FieldByName('dfPathFoldersId').AsInteger);
   if Assigned(Folder) then
    begin
     if IsValidFolder(Folder,DataSet)=False then
      CorrectDfPathFolder(Folder, DataSet);
    end
     else
    CreateMissingPathFolder(DataSet);
   DataSet.Next;
  end;
end;

procedure TDocFlowSchemaValidator.DoValidateMethods(DataSet: TDataSet);
var
 Method:TMiceFlowConnector;
begin
 while not DataSet.Eof do
  begin
   Method:=FSchema.FindDfMethod(DataSet.FieldByName('dfMethodsId').AsInteger);
   if Assigned(Method) then
    begin
      if (IsValidMethod(Method, DataSet)=False) then
       CorrectDfMethod(Method,DataSet);
    end
     else
      CreateMissingMethod(DataSet);
   DataSet.Next;
  end;
end;

procedure TDocFlowSchemaValidator.FindInvalidFoldersOnSchema(DataSet: TDataSet);
var
 x:Integer;
 Obj:TMiceFlowObject;
begin
 for x:=FSchema.ObjectCount downto 0 do
 if FSchema.Objects[x] is TMiceFlowObject then
  begin
    Obj:=FSchema.Objects[x] as TMiceFlowObject;
    if (Obj.IsCommentFolder=False) and (DataSet.Locate('DfPathFoldersId',Obj.DfPathFoldersId,[])=False) then
     FSchema.DeleteObject(Obj);
  end;
end;

procedure TDocFlowSchemaValidator.FindInvalidMethodsOnSchema(DataSet: TDataSet);
var
 x:Integer;
 Con:TMiceFlowConnector;
begin
for x:=FSchema.ConnectionCount-1 downto 0 do
 if FSchema.Connections[x] is TMiceFlowConnector then
  begin
   Con:=FSchema.Connections[x] as TMiceFlowConnector;
   if (DataSet.Locate('DfMethodsId', Con.dfMethodsId ,[])=False) then
     FSchema.DeleteConnection(Con);
  end;
end;

procedure TDocFlowSchemaValidator.Validate;
begin
 ValidateFolders;
 ValidateMethods;
end;

procedure TDocFlowSchemaValidator.ValidateFolders;
var
 Tmp:TxDataSet;
begin
  Tmp:=TxDataSet.Create(nil);
  try
   Tmp.Source:='TDocFlowSchemaValidator.ValidateFolders';
   Tmp.ProviderName:='spui_dfPathFoldersList';
   Tmp.SetParameter('dfTypesId',fdfTypesId);
   Tmp.DBName:=Self.DBName;
   Tmp.Open;
   DoValidateFolders(Tmp);
   FindInvalidFoldersOnSchema(Tmp);
  finally
   Tmp.Free;
  end;
end;

procedure TDocFlowSchemaValidator.ValidateMethods;
var
 Tmp:TxDataSet;
begin
  Tmp:=TxDataSet.Create(nil);
  try
   Tmp.Source:='TDocFlowSchemaValidator.ValidateMethods';
   Tmp.ProviderName:='spui_dfMethodsList';
   Tmp.SetParameter('dfTypesId',fdfTypesId);
   Tmp.DBName:=Self.DBName;
   Tmp.Open;
   DoValidateMethods(Tmp);
   FindInvalidMethodsOnSchema(Tmp);
  finally
   Tmp.Free;
  end;
end;


function TDocFlowSchemaValidator.IsValidFolder(Folder: TMiceFlowObject; DataSet: TDataSet): Boolean;
begin
  Result:=Folder.Text=DataSet.FieldByName('Caption').AsString;
end;

function TDocFlowSchemaValidator.IsValidMethod(Method: TMiceFlowConnector; DataSet: TDataSet): Boolean;
begin
 Result:=(Method.dfPathFoldersIdSource=DataSet.FieldByName('dfPathFoldersIdSource').AsInteger)
     and (Method.dfPathFoldersIdTarget=DataSet.FieldByName('dfPathFoldersIdTarget').AsInteger)
     and (Method.Text=DataSet.FieldByName('Caption').AsString);

end;

end.
