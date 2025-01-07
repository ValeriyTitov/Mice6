unit DocFlow.Schema.Helper;

interface
 uses
  System.SysUtils,
  DAC.DatabaseUtils,
  DAC.XDataSet;

 type
  TDocFlowManagerHelper = class
  private
    FDfClassesId: Integer;
    FDfTypesId: Integer;
    FDBName: string;
   public
    property DfClassesId:Integer read FDfClassesId write FDfClassesId;
    property DfTypesId:Integer read FDfTypesId write FDfTypesId;
    property DBName:string read FDBName write FDBName;

    function NewMethod(const Caption:string;dfPathFoldersIdSource, dfPathFoldersIdDest:Integer):Integer;
    function NewDocFlowFolder(const Caption:string; FolderType:Integer):Integer;
    procedure CreateMethod(const Caption:string;dfPathFoldersIdSource, dfPathFoldersIdTarget, dfMethodsId:Integer);
    procedure CreatePathFolder(const Caption:string; dfPathFoldersId, FolderType :Integer);
    procedure DeleteMethod(dfMethodsId:Integer);
    procedure DeletePathFolder(dfPathFoldersId:Integer);
    procedure ChangeSourceFolder(dfMethodsId, dfPathFoldersIdSource:Integer);
    procedure ChangeTargetFolder(dfMethodsId, dfPathFoldersIdTarget:Integer);
    constructor Create;
  end;

implementation

const
  iTypeDFClass         = 19;
  iTypeDfTypes         = 20;
  iTypeDFScheme        = 21;
  iTypeDFMethod        = 22;
  iTypeDFPathFolder    = 23;

{ TDocFlowManagerHelper }

procedure TDocFlowManagerHelper.CreatePathFolder(const Caption:string; dfPathFoldersId, FolderType: Integer);
var
 Tmp:TxDataSet;
begin
 Tmp:=TxDataSet.Create(nil);
 try
  Tmp.ProviderName:='spui_dfCreateNewPathFolder';
  Tmp.Source:='TDocFlowManagerHelper.CreatePathFolder';
  Tmp.DBName:=DBName;
  Tmp.SetParameter('dfClassesId',DfClassesId);
  Tmp.SetParameter('dfTypesId',Self.DfTypesId);
  Tmp.SetParameter('Caption',Caption);
  Tmp.SetParameter('dfPathFoldersId',dfPathFoldersId);
  Tmp.SetParameter('FolderType',FolderType);
  Tmp.Execute;
 finally
  Tmp.Free;
 end;
end;


function TDocFlowManagerHelper.NewMethod(const Caption: string; dfPathFoldersIdSource, dfPathFoldersIdDest: Integer): Integer;
begin
 Result:=TDataBaseUtils.NewAppObjectId(sq_dfMethods);
 CreateMethod(Caption, dfPathFoldersIdSource, dfPathFoldersIdDest, Result);
end;

procedure TDocFlowManagerHelper.CreateMethod(const Caption: string;  dfPathFoldersIdSource, dfPathFoldersIdTarget, dfMethodsId: Integer);
var
 Tmp:TxDataSet;
begin
 Tmp:=TxDataSet.Create(nil);
 try
  Tmp.ProviderName:='spui_dfCreateNewMethod';
  Tmp.Source:='TDocFlowManagerHelper.CreateMethod';
  Tmp.DBName:=DBName;
  Tmp.SetParameter('dfMethodsId',dfMethodsId);
  Tmp.SetParameter('dfClassesId',DfClassesId);
  Tmp.SetParameter('dfTypesId',Self.DfTypesId);
  Tmp.SetParameter('Caption',Caption);
  Tmp.SetParameter('dfPathFoldersIdSource',dfPathFoldersIdSource);
  Tmp.SetParameter('dfPathFoldersIdTarget',dfPathFoldersIdTarget);
  Tmp.Execute;
 finally
  Tmp.Free;
 end;
end;

procedure TDocFlowManagerHelper.ChangeSourceFolder(dfMethodsId,  dfPathFoldersIdSource: Integer);
var
 Tmp:TxDataSet;
begin
 Tmp:=TxDataSet.Create(nil);
 try
  Tmp.ProviderName:='spui_dfUpdateMethodSource';
  Tmp.Source:='TDocFlowManagerHelper.ChangeSourceFolder';
  Tmp.DBName:=Self.DBName;
  Tmp.SetParameter('dfMethodsId',dfMethodsId);
  Tmp.SetParameter('dfPathFoldersIdSource',dfPathFoldersIdSource);
  Tmp.Execute;
 finally
  Tmp.Free;
 end;
end;

procedure TDocFlowManagerHelper.ChangeTargetFolder(dfMethodsId,  dfPathFoldersIdTarget: Integer);
var
 Tmp:TxDataSet;
begin
 Tmp:=TxDataSet.Create(nil);
 try
  Tmp.ProviderName:='spui_dfUpdateMethodTarget';
  Tmp.Source:='TDocFlowManagerHelper.ChangeTargetFolder';
  Tmp.DBName:=Self.DBName;
  Tmp.SetParameter('dfMethodsId',dfMethodsId);
  Tmp.SetParameter('dfPathFoldersIdTarget',dfPathFoldersIdTarget);
  Tmp.Execute;
 finally
  Tmp.Free;
 end;
end;

constructor TDocFlowManagerHelper.Create;
begin
end;

procedure TDocFlowManagerHelper.DeleteMethod(dfMethodsId: Integer);
var
 Tmp:TxDataSet;
begin
 Tmp:=TxDataSet.Create(nil);
 try
  Tmp.ProviderName:='spui_dfDeleteMethod';
  Tmp.Source:='TDocFlowManagerHelper.DeleteMethod';
  Tmp.DBName:=Self.DBName;
  Tmp.SetParameter('dfMethodsId',dfMethodsId);
  Tmp.Execute;
 finally
  Tmp.Free;
 end;
end;

procedure TDocFlowManagerHelper.DeletePathFolder(dfPathFoldersId: Integer);
var
 Tmp:TxDataSet;
begin
 Tmp:=TxDataSet.Create(nil);
 try
  Tmp.ProviderName:='spui_dfDeletePathFolder';
  Tmp.Source:='TDocFlowManagerHelper.DeletePathFolder';
  Tmp.DBName:=DBName;
  Tmp.SetParameter('dfPathFoldersId',dfPathFoldersId);
  Tmp.Execute;
 finally
  Tmp.Free;
 end;
end;

function TDocFlowManagerHelper.NewDocFlowFolder(const Caption:string; FolderType:Integer):Integer;
begin
 Result:=TDataBaseUtils.NewAppObjectId(sq_dfPathFolders);
 CreatePathFolder(Caption, Result, FolderType);
end;

end.
