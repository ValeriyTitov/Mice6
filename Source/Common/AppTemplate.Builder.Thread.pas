unit AppTemplate.Builder.Thread;

interface
uses
 System.Classes, System.SysUtils,
 Thread.Basic,
 DAC.XParams,
 DAC.XDataSet,
 AppTemplate.Builder.Abstract,
 AppTemplate.Builder.Json,
 AppTemplate.Builder.Xml,
 AppTemplate.Builder.Xbrl;


type
 TTemplateThread = class(TBasicThread)
  private
    FParams: TxParams;
    FFileName: string;
    FAppTemplatesId: Integer;
    FDefaultFileName: string;
    FDBName: string;

    FTemplateType:Integer;
    FActive:Boolean;
    FDefaultDateTimeFormat:string;
    FFormatAfterCreate:Boolean;
    FStream: TStream;
    function CreateBuilder:TAbstractAppTemplateBuilder;
    procedure SetDefaultFileName(const Value: string);
    procedure GetAppTemplateInfo;
    procedure SetStream(const Value: TStream);
  protected
    Builder:TAbstractAppTemplateBuilder;
    procedure DoOnProgress; override;
    procedure DoOnExecute; override;
    procedure InternalGetProgress(Sender:TObject);
  public
    property Params:TxParams read FParams write FParams;
    property AppTemplatesId:Integer read FAppTemplatesId write FAppTemplatesId;
    property FileName:string read FFileName write FFileName;
    property DefaultFileName:string read FDefaultFileName write SetDefaultFileName;
    property DBName:string read FDBName write FDBName;
    property Stream:TStream read FStream write SetStream;

    procedure AbortThread(OnAbort:TNotifyEvent); override;
 end;

implementation


{ TTemplateThread }

procedure TTemplateThread.AbortThread(OnAbort: TNotifyEvent);
begin
  inherited;
  if Assigned(Builder) then
   Builder.Stop;
end;

function TTemplateThread.CreateBuilder: TAbstractAppTemplateBuilder;
resourcestring
 E_UNKNOWN_TEMPLATE_TYPE_FMT = 'Unknown template type: %d';
 E_TEMPLATE_IS_DISABLED = 'Export template is disabled';
begin
 GetAppTemplateInfo;
 if not FActive then
  raise Exception.Create(E_TEMPLATE_IS_DISABLED);

 case FTemplateType of
   0:Result:=TAppTemplateBuilderXml.Create;
   1:Result:=TAppTemplateBuilderXbrl.Create;
   2:Result:=TAppTemplateBuilderJson.Create;
    else
     raise Exception.CreateFmt(E_UNKNOWN_TEMPLATE_TYPE_FMT,[FTemplateType]);
 end;
 Result.FormatAfterCreate:=Params.ParamByNameDef('FormatAfterCreate', FFormatAfterCreate);
end;

procedure TTemplateThread.DoOnExecute;
var
 Ticks:Int64;
begin
  inherited;
  Ticks:=GetTickCount;
   Builder:=CreateBuilder;
    try
     Builder.OnProgress:=InternalGetProgress;
     Builder.AppTemplatesId:=AppTemplatesId;
     Builder.FileName:=FileName;
     Builder.DBName:=Self.DBName;
     if Assigned(Params) then
      Builder.Params.Assign(Params);
     Builder.Execute;
    finally
     Progress(S_TEMPLATEBUILDER_PROGRESS_CLEARING_DATA);
     Builder.Free;
   end;
    Progress(Format(S_TEMPLATEBUILDER_FINISHED_IN_N_SECONDS_FMT,[(GetTickCount-Ticks) div 1000]));
end;

procedure TTemplateThread.DoOnProgress;
begin
 inherited;
end;


procedure TTemplateThread.GetAppTemplateInfo;
var
 DataSet:TxDataSet;
begin
 DataSet:=TxDataSet.Create(nil);
 try
  DataSet.ProviderName:='spui_AppTemplatesInfo';
  DataSet.SetParameter('AppTemplatesId', Self.AppTemplatesId);
  DataSet.Open;
  FTemplateType:=DataSet.FieldByName('TemplateType').AsInteger;
  FActive:=DataSet.FieldByName('Active').AsBoolean;
  FDefaultDateTimeFormat:=DataSet.FieldByName('DefaultDateTimeFormat').AsString;
  FFormatAfterCreate:=DataSet.FieldByName('FormatAfterCreate').AsBoolean;
 finally
  DataSet.Free;
 end;
end;

procedure TTemplateThread.InternalGetProgress(Sender: TObject);
begin
 Progress((Sender as TAbstractAppTemplateBuilder).CurrentProgress);
end;

procedure TTemplateThread.SetDefaultFileName(const Value: string);
begin
  FDefaultFileName := Value;
end;

procedure TTemplateThread.SetStream(const Value: TStream);
begin
  FStream := Value;
end;

end.
