{$M+}
unit AppTemplate.Builder;

interface

uses
 System.Classes, System.SysUtils, System.Variants,
 AppTemplate.Builder.Abstract,
 AppTemplate.Builder.Xml,
 Dialogs,
 System.IOUtils,
 DAC.XParams,
 Common.ResourceStrings,
 Thread.WaitingForm,
 Thread.Basic,
 AppTemplate.Builder.Thread;

type
 TAppTemplateBuilder = class(TComponent)
  private
    FParams: TxParams;
    FAutoClose: Boolean;
    FHandleErrors: Boolean;
    FFileName:string;
    FDefaultFileName:string;
    FHadError: Boolean;
    FUserAbort: Boolean;
    FDBName: string;
    FStream: TStream;
    function ExecuteSaveAsDialog:Boolean;
    function GetDefaultFileName: string;
    function GetFileName: string;
    function FileNameAssigned: Boolean;
    function GetAppTemplatesId: Integer;
    procedure StartDialog(Thread:TBasicThread);
    procedure SetUserAbort(const Value: Boolean);
    procedure InternalExecute;
    procedure SetFileName(const Value: string);
    procedure SetDefaultFileName(const Value: string);
    procedure SetAppTemplatesId(const Value: Integer);
    procedure SetStream(const Value: TStream);
  public
    property DefaultFileName:string read GetDefaultFileName write SetDefaultFileName;
    function Execute:Boolean;
    constructor Create(AOwner:TComponent); override;
    destructor Destroy;override;
  published
    property AppTemplatesId:Integer read GetAppTemplatesId write SetAppTemplatesId;
    property FileName:string read GetFileName write SetFileName;
    property Params:TxParams read FParams;
    property DBName:string read FDBName write FDBName;
    property AutoClose:Boolean read FAutoClose write FAutoClose;
    property HandleErrors:Boolean read FHandleErrors write FHandleErrors;
    property HadError:Boolean read FHadError write FHadError;
    property UserAbort:Boolean read FUserAbort write SetUserAbort;
    property Stream:TStream read FStream write SetStream;
  end;

implementation

{ TTemplateThreadedBuilder }

constructor TAppTemplateBuilder.Create(AOwner:TComponent);
begin
 inherited;
 FHadError:=False;
 UserAbort:=False;
 FParams:=TxParams.Create;
end;

destructor TAppTemplateBuilder.Destroy;
begin
 FParams.Free;
 inherited;
end;

function TAppTemplateBuilder.Execute:Boolean;
begin
 Result:=FileNameAssigned or (ExecuteSaveAsDialog);
 if Result then
  InternalExecute;
end;

function TAppTemplateBuilder.ExecuteSaveAsDialog: Boolean;
var
 Dlg:TSaveDialog;
begin
 Dlg:=TSaveDialog.Create(nil);
  try
   Dlg.FileName:=DefaultFileName;
   Dlg.Filter:=S_OPEN_FILE_FILTER_XML_COMMON;
   Dlg.Options:=Dlg.Options+[ofOverwritePrompt];
   Result:=Dlg.Execute;
    if Result then
     FileName:=Dlg.FileName;
  finally
   Dlg.Free;
  end;

end;

function TAppTemplateBuilder.FileNameAssigned: Boolean;
begin
 Result:= not FileName.IsEmpty and not FileName.ToLower.Equals('.xml');
end;

function TAppTemplateBuilder.GetAppTemplatesId: Integer;
begin
 Result:=Params.ParamByNameDef('AppTemplatesId',0);
end;

function TAppTemplateBuilder.GetDefaultFileName: string;
var
 Ext:string;
begin
  Result := Params.ParamByNameDef('DefaultFileName','');
  Ext:=TPath.GetExtension(Result);
  if Ext.IsEmpty then
   Result:=Result+'.xml'
end;

function TAppTemplateBuilder.GetFileName: string;
var
 Ext:string;
begin
 Result:=Self.Params.ParamByNameDef('FileName','');
 Ext:=TPath.GetExtension(Result);
 if Ext.IsEmpty then
  Result:=Result+'.xml'
end;

procedure TAppTemplateBuilder.InternalExecute;
var
 Thread:TTemplateThread;
begin
 Thread:=TTemplateThread.Create(True);
 Thread.Params:=Params;
 Thread.FileName:=Self.FileName;
 Thread.AppTemplatesId:=Self.AppTemplatesId;
 Thread.DBName:=Self.DBName;
 Thread.FreeOnTerminate:=True;
 HandleErrors:=True;
 Self.StartDialog(Thread);
end;


procedure TAppTemplateBuilder.SetAppTemplatesId(const Value: Integer);
begin
 Params.SetParameter('AppTemplatesId', Value);
end;

procedure TAppTemplateBuilder.SetDefaultFileName(const Value: string);
begin
 FDefaultFileName:=Value;
 Params.SetParameter('DefaultFileName', Value);
end;


procedure TAppTemplateBuilder.SetFileName(const Value: string);
begin
  FFileName:=Value;
  Params.SetParameter('FileName',Value);
end;


procedure TAppTemplateBuilder.SetStream(const Value: TStream);
begin
  FStream := Value;
end;

procedure TAppTemplateBuilder.SetUserAbort(const Value: Boolean);
begin
  FUserAbort := Value;
end;

procedure TAppTemplateBuilder.StartDialog(Thread:TBasicThread);
var
 Dlg:TThreadWaitingForm;
begin
  Dlg:=TThreadWaitingForm.Create(nil);
  try
   Dlg.Caption:=FileName;
   Dlg.Start(Thread, AutoClose, HandleErrors);
   Dlg.ShowModal;
   HadError:=Dlg.HadErrors;
   UserAbort:=Dlg.UserAbort;
  finally
   Dlg.Free;
  end;
end;

end.
