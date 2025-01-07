unit ManagerEditor.Script.Runner.CSharp;

interface
uses
  System.Classes, System.SysUtils,
  DAC.XDataSet,
  ManagerEditor.Script.Runner;


type

TCSharpScriptRunner = class (TCustomScriptRunner)
 private
   FDataSet:TxDataSet;
 protected
   procedure DoOnError(const Msg:string); override;
   procedure InternalPublish;
 public
   procedure PublishDataScript;
   procedure Run; override;
   constructor Create; override;
   destructor Destroy; override;
 end;


implementation

{ TCSharpScriptRunner }

constructor TCSharpScriptRunner.Create;
begin
  inherited;
  Syntax:='C#';
  DefaultExtension:='.cs';
  FDataSet:=TxDataSet.Create(nil);
  FDataSet.ExactParams:=True;
end;

destructor TCSharpScriptRunner.Destroy;
begin
  FDataSet.Free;
  inherited;
end;

procedure TCSharpScriptRunner.DoOnError(const Msg: string);
begin
  InfoLines.Add(Msg);
  inherited;
end;



procedure TCSharpScriptRunner.InternalPublish;
var
 ADataSet:TxDataSet;
resourcestring
 S_SCRIPT_PUBLISHED = 'Script published';
begin
 ADataSet:=TxDataSet.Create(nil);
 try
  ADataSet.ProviderName:='spds_DataScriptPublish';
  ADataSet.SetParameter('ScriptName',ScriptName);
  ADataSet.SetParameter('ScriptText',Text.Text);
  ADataSet.OpenOrExecute;
  ADataSet.Messages.ToList(InfoLines);
  InfoLines.Add(S_SCRIPT_PUBLISHED);
 finally
  ADataSet.Free;
 end;
end;

procedure TCSharpScriptRunner.PublishDataScript;
begin
 try
  InfoLines.Clear;
  InternalPublish;
  DoOnSuccess(FDataSet);
 except on E:Exception do
  DoOnError(E.Message);
 end;

end;


procedure TCSharpScriptRunner.Run;
begin
 try
  InfoLines.Clear;
  FDataSet.Close;
  FDataSet.ProviderName:='spds_DataScriptRun';
  FDataSet.Params.Assign(Params);
  FDataSet.SetParameter('ScriptText',Text.Text);
  FDataSet.SetParameter('ScriptName', ScriptName);
  FDataSet.OpenOrExecute;
  FDataSet.Messages.ToList(InfoLines);
  DoOnSuccess(FDataSet);
 except on E:Exception do
  DoOnError(E.Message);
 end;

end;

end.
