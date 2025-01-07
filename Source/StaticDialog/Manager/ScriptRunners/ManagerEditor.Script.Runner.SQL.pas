unit ManagerEditor.Script.Runner.SQL;

interface
uses
  System.Classes, System.SysUtils, Data.DB,
  DAC.XDataSet,
  Common.ResourceStrings,
  ManagerEditor.Script.Runner,
  ManagerEditor.Script.Runner.SQL.ObjectDetails,
  DAC.ObjectModels.Exception,
  DAC.ObjectModels.DataSetMessage,
  dxmdaset;



type
 TSQLScriptRunner = class (TCustomScriptRunner)
 private
  FDataSet: TxDataSet;
  FInfoDataSet: TdxMemData;
  procedure InternalExecute;
 protected
  procedure DoOnSuccess(DataSet:TDataSet); override;
  procedure DoOnProgress; override;
  procedure DoOnError(const Msg:string); override;
  procedure HandleDACExcpetion(const Msg:string; LineNumber, SQLNativeError:Integer);
  procedure InternalExecuteObjectDetails(Getter:TSqlObjectDetailsGetter);
 public
  procedure ObjectDetails(const ObjectName:string); override;
  procedure Run; override;
  property DataSet: TxDataSet read FDataSet;
  constructor Create; override;
  destructor Destroy; override;
 end;

implementation


constructor TSQLScriptRunner.Create;
begin
 inherited;
 FDataSet:=TxDataSet.Create(nil);
 FDataSet.Source:='TSQLScriptRunner';
 FInfoDataSet:=TdxMemData.Create(nil);
 DefaultExtension:='.sql';
 Syntax:='sql';
end;

destructor TSQLScriptRunner.Destroy;
begin
  FInfoDataSet.Free;
  FDataSet.Free;
  inherited;
end;

procedure TSQLScriptRunner.DoOnError(const Msg:string);
begin
 InfoLines.Clear;
 InfoLines.Add(Msg);
 inherited;
end;

procedure TSQLScriptRunner.DoOnProgress;
var
 ALines:TStringList;
begin
 ALines:=TStringList.Create;
try
  FDataSet.ExecutionContext.Messages.ToList(ALines);
  if Assigned(Self.OnProgress) then
    OnProgress(FDataSet, ALines);
 finally
  ALines.Free;
 end;
end;

procedure TSQLScriptRunner.DoOnSuccess(DataSet:TDataSet);
resourcestring
 S_DATASET_PROGRESS_MESSAGES = 'Messages: %d';
begin
 InfoLines.Clear;
 if FDataSet.ExecutionContext.Messages.Count>0 then
   DoOnProgress;

  InfoLines.Add(String.Format(S_ROWS_FMT,[DataSet.RecordCount]));
  InfoLines.Add(String.Format(S_COLUMNS_FMT,[DataSet.FieldCount]));
  InfoLines.Add(String.Format(S_DATASET_PROGRESS_MESSAGES,[FDataSet.Messages.Count]));

 inherited;
end;


procedure TSQLScriptRunner.HandleDACExcpetion(const Msg: string; LineNumber, SQLNativeError: Integer);
begin
 Self.ErrorLineNumber:=LineNumber;
 Self.NativeError:=SQLNativeError;
 DoOnError(Msg);
end;

procedure TSQLScriptRunner.InternalExecute;
begin
 try
  FDataSet.OpenOrExecute;
  DoOnSuccess(FDataSet);
 except
  on E:Exception do DoOnError(E.Message);
  on E:EDACException do HandleDACExcpetion(E.Message, E.LineNumber, E.SQLNativeError);
 end;
end;

procedure TSQLScriptRunner.InternalExecuteObjectDetails(Getter: TSqlObjectDetailsGetter);
begin
 try
  Getter.FindObjectProperties;
  DoOnSuccess(FInfoDataSet);
 except
  on E:Exception do DoOnError(E.Message);
  on E:EDACException do HandleDACExcpetion(E.Message, E.LineNumber, E.SQLNativeError);
 end;
end;

procedure TSQLScriptRunner.ObjectDetails(const ObjectName: string);
var
 Getter:TSqlObjectDetailsGetter;
begin
 Getter:=TSqlObjectDetailsGetter.Create(FInfoDataSet);
 try
  FreeAndNil(Self.FInfoDataSet);
  FInfoDataSet:=TdxMemData.Create(nil);
  Getter.ObjectName:=ObjectName;
  Getter.DBName:=Self.DBName;
  InternalExecuteObjectDetails(Getter);
 finally
  Getter.Free;
 end;
end;


procedure TSQLScriptRunner.Run;
begin
  inherited;
  FDataSet.SetContext('CommandBehavior','0');
  FDataSet.Close;
  FDataSet.ProviderName:=Text.Text;
  FDataSet.DBName:=DBName;
  InternalExecute;
end;


end.
