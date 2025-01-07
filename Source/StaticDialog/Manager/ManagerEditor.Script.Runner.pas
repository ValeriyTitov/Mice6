unit ManagerEditor.Script.Runner;

interface
 uses
 System.Classes, Data.DB, System.SysUtils,
 DAC.XParams,
 DAC.XDataSet;

type
 TExecutionEvent = procedure (DataSet:TDataSet; Lines:TStrings) of object;

 TCustomScriptRunner = class
  strict private
    FOnSuccess: TExecutionEvent;
    FOnError: TExecutionEvent;
    FInfoLines: TStringList;
    FDefaultExtension: string;
    FSyntax: string;
    FOnProgress: TExecutionEvent;
    FDBName: string;
    FText: TStrings;
    FParams: TxPArams;
    FScriptName: string;
    FErrorLineNumber: Integer;
    FErrorLinePos: Integer;
    FErrorMessage: string;
    FNativeError: Integer;
  protected
    procedure DoOnSuccess(DataSet:TDataSet); virtual;
    procedure DoOnError(const Msg:string); virtual;
    procedure DoOnProgress; virtual;
  public
    procedure Run; virtual; abstract;
    procedure Abort(OnStop:TExecutionEvent); virtual; abstract;
    procedure ObjectDetails(const ObjectName :string); virtual;
    function Format:string; virtual;
    property OnSuccess:TExecutionEvent read FOnSuccess write FOnSuccess;
    property OnError:TExecutionEvent read FOnError write FOnError;
    property OnProgress:TExecutionEvent read FOnProgress write FOnProgress;
    property InfoLines:TStringList read FInfoLines;
    property DefaultExtension:string read FDefaultExtension write FDefaultExtension;
    property Syntax:string read FSyntax write FSyntax;
    property Text:TStrings read FText write FText;
    property DBName:string read FDBName write FDBName;
    property Params:TxParams read FParams;
    property ScriptName:string read FScriptName write FScriptName;
    property ErrorLineNumber:Integer read FErrorLineNumber write FErrorLineNumber;
    property ErrorLinePos:Integer read FErrorLinePos write FErrorLinePos;
    property ErrorMessage:string read FErrorMessage write FErrorMessage;
    property NativeError:Integer read FNativeError write FNativeError;

    constructor Create; virtual;
    destructor Destroy; override;
 end;

 TCustomScriptRunnerClass = class of TCustomScriptRunner;

implementation

{ TCustomScriptRunner }

constructor TCustomScriptRunner.Create;
begin
 FInfoLines:=TStringList.Create;
 FParams:=TxParams.Create;
end;

destructor TCustomScriptRunner.Destroy;
begin
  FParams.Free;
  FInfoLines.Free;
  inherited;
end;

procedure TCustomScriptRunner.DoOnError(const Msg: string);
begin
 if Assigned(OnError) then
  OnError(nil, InfoLines);
end;

procedure TCustomScriptRunner.DoOnProgress;
begin
end;

procedure TCustomScriptRunner.DoOnSuccess(DataSet: TDataSet);
begin
 if Assigned(OnSuccess) then
  OnSuccess(DataSet,InfoLines);
end;

function TCustomScriptRunner.Format: string;
resourcestring
 S_NOT_IMPLEMENTED_IN_CLASS_FMT = 'Not implemented in class %s';
begin
 raise Exception.CreateFmt(S_NOT_IMPLEMENTED_IN_CLASS_FMT,[ClassName]);
end;


procedure TCustomScriptRunner.ObjectDetails(const ObjectName: string);
begin
end;

end.
