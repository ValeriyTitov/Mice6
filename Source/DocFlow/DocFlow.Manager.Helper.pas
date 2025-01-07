unit DocFlow.Manager.Helper;

interface
uses
  System.SysUtils, System.Classes, Data.Db, System.Variants,
  DAC.XDataSet,
  DocFlow.Manager.MessageWindow,
  DAC.XParams,
  Mice.Script;


type

 TDocFlowManagerHelper = class
  private
    FDfClassesId: Integer;
    FDBName: string;
    FAppDialogsId: Integer;
    FScript:TMiceScripter;
    FLogProviderName: string;
    procedure SetAppDialogsId(const Value: Integer);
    procedure LoadFromDataSet(DataSet:TDataSet);
    procedure InternalPushDocument(DocumentsId, dfPathFoldersIdSource, dfMethodsIdTarget, dfEventsId:Integer);
    procedure InternalRollBackDocument(DocumentsId, dfPathFoldersIdSource, dfMethodsIdTarget, dfEventsId: Integer);
 public
    procedure PushDocument(DocumentsId, dfPathFoldersIdSource, dfMethodsIdTarget, dfEventsId:Integer);
    procedure RollBackDocument(DocumentsId, dfPathFoldersIdSource, dfMethodsIdTarget, dfEventsId: Integer);
    procedure DeleteDocument(DocumentsId:Integer);
    procedure GetClassProperties;

    class procedure CheckValidDocFlowDataSet(DataSet:TDataSet; CheckDfEvent:Boolean);
    property DfClassesId:Integer read FDfClassesId write FDfClassesId;
    property DBName:string read FDBName write FDBName;
    property AppDialogsId:Integer read FAppDialogsId write SetAppDialogsId;
    property LogProviderName:string read FLogProviderName write FLogProviderName;
    constructor Create(Script:TMiceScripter);
 end;

implementation

{ TDocFlowManager }

class procedure TDocFlowManagerHelper.CheckValidDocFlowDataSet(DataSet: TDataSet; CheckDfEvent:Boolean);
resourcestring
 E_INVALID_DOCFLOW_DATASET = 'Invalid DataSet format.'#13' DataSet should contain dfTypesId, dfPathFoldersId, dfClassesId and should not be NULL';
 E_DOCFLOW_NO_DOCUMENT = 'Cannot find document or document is invalid';
var
 F:TField;
begin
 if not DataSet.Active or (DataSet.RecordCount<=0) then
  raise Exception.Create(E_DOCFLOW_NO_DOCUMENT);

 F:=DataSet.FindField('dfPathFoldersId');
 if not Assigned(F) then
  raise Exception.Create(E_INVALID_DOCFLOW_DATASET);

 F:=DataSet.FindField('dfTypesId');
 if not Assigned(F) or F.IsNull then
  raise Exception.Create(E_INVALID_DOCFLOW_DATASET);

 F:=DataSet.FindField('dfClassesId');
 if not Assigned(F) then
  raise Exception.Create(E_INVALID_DOCFLOW_DATASET);
end;

constructor TDocFlowManagerHelper.Create;
begin
 FScript:=Script;
end;

procedure TDocFlowManagerHelper.DeleteDocument(DocumentsId: Integer);
var
 Tmp:TxDataSet;
begin
 Tmp:=TxDataSet.Create(nil);
 try
  Tmp.ProviderName:='sysdf_DocumentDelete';
  Tmp.Source:='TDocFlowManager.DeleteDocument';
  Tmp.DBName:=DBName;
  Tmp.SetParameter('dfPathFoldersIdSource',DocumentsId);
  Tmp.OpenOrExecute;
 finally
  Tmp.Free;
 end;
end;

procedure TDocFlowManagerHelper.GetClassProperties;
var
 Tmp:TxDataSet;
begin
 Tmp:=TxDataSet.Create(nil);
 try
  Tmp.ProviderName:='spui_dfClassInfo';
  Tmp.DBName:=DBName;
  Tmp.Source:='TDocFlowManagerHelper.GetClassProperties';
  Tmp.SetParameter('dfClassesId',DfClassesId);
  Tmp.Open;
  LoadFromDataSet(Tmp);
 finally
  Tmp.Free;
 end;
end;

procedure TDocFlowManagerHelper.InternalPushDocument(DocumentsId, dfPathFoldersIdSource, dfMethodsIdTarget, dfEventsId: Integer);
var
 Tmp:TxDataSet;
begin
 Tmp:=TxDataSet.Create(nil);
 try
  Tmp.ProviderName:='sysdf_DocumentPush';
  Tmp.DBName:=DBName;
  Tmp.Source:='TDocFlowManager.PushDocument';
  Tmp.SetParameter('DocumentsId',DocumentsId);
  Tmp.SetParameter('dfMethodsIdTarget',dfMethodsIdTarget);
  Tmp.SetParameter('dfPathFoldersIdSource',dfPathFoldersIdSource);
  Tmp.SetParameter('dfEventsId',dfEventsId);
  Tmp.OpenOrExecute;
  if Tmp.RecordCount>0 then
   TDocFlowMessageWindow.ShowDocFlowMessages(Tmp);
 finally
  Tmp.Free;
 end;
end;


procedure TDocFlowManagerHelper.InternalRollBackDocument(DocumentsId, dfPathFoldersIdSource, dfMethodsIdTarget, dfEventsId: Integer);
var
 Tmp:TxDataSet;
begin
 Tmp:=TxDataSet.Create(nil);
 try
  Tmp.ProviderName:='sysdf_DocumentRollback';
  Tmp.DBName:=DBName;
  Tmp.Source:='TDocFlowManager.RollBackDocument';
  Tmp.SetParameter('DocumentsId',DocumentsId);
  Tmp.SetParameter('dfMethodsIdTarget',dfMethodsIdTarget);
  Tmp.SetParameter('dfPathFoldersIdSource',dfPathFoldersIdSource);
  Tmp.SetParameter('dfEventsId',dfEventsId);
  Tmp.OpenOrExecute;
 finally
  Tmp.Free;
 end;
end;

procedure TDocFlowManagerHelper.LoadFromDataSet(DataSet: TDataSet);
begin
 Self.AppDialogsId:=DataSet.FieldByName('AppDialogsId').AsInteger;
 LogProviderName:=DataSet.FieldByName('LogProviderName').AsString;
end;

procedure TDocFlowManagerHelper.PushDocument(DocumentsId, dfPathFoldersIdSource, dfMethodsIdTarget, dfEventsId: Integer);
begin
 InternalPushDocument(DocumentsId, dfPathFoldersIdSource, dfMethodsIdTarget, dfEventsId);
end;

procedure TDocFlowManagerHelper.RollBackDocument(DocumentsId, dfPathFoldersIdSource, dfMethodsIdTarget, dfEventsId: Integer);
begin
 InternalRollBackDocument(DocumentsId, dfPathFoldersIdSource, dfMethodsIdTarget, dfEventsId);
end;

procedure TDocFlowManagerHelper.SetAppDialogsId(const Value: Integer);
begin
  FAppDialogsId := Value;
end;

end.
