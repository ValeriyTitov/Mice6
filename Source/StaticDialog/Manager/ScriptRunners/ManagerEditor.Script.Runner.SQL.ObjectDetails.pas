unit ManagerEditor.Script.Runner.SQL.ObjectDetails;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Common.ResourceStrings,
  Common.Images,
  DAC.ConnectionMngr,
  DAC.DatabaseUtils,
  DAC.BaseDataSet,
  DAC.XDataSet,
  Dialog.MShowMessage,
  Dialog.ShowDataSet,
  dxmdaset;

type
  TSqlObjectDetailsGetter = class
  private
    FObjectName: string;
    FDBName: string;
    FObjectType: TDatabaseObjectType;
    FDest:TdxMemData;
    procedure RaiseNotImplemented;
    procedure GetProcedureDetails;
    procedure GetTableDetails;
    procedure GetObjectType;
  public
    property ObjectName:string read FObjectName write FObjectName;
    property DBName: string read FDBName write FDBName;
    procedure FindObjectProperties;
    constructor Create(ADest:TdxMemData);
  end;

implementation

{ TSqlObjectDetailsGetter }


{ TSqlObjectDetailsGetter }

constructor TSqlObjectDetailsGetter.Create(ADest: TdxMemData);
begin
  FDest:=ADest;
end;

procedure TSqlObjectDetailsGetter.FindObjectProperties;
begin
 Self.GetObjectType;
end;

procedure TSqlObjectDetailsGetter.GetObjectType;
begin
 FObjectType:=TDataBaseUtils.GetObjectType(ObjectName,DBName);
 case FObjectType  of
  otStoredProc: GetProcedureDetails;
  otTable: GetTableDetails;
  otView: GetTableDetails;

  otTableFunction:RaiseNotImplemented;
  otScalarFunction:RaiseNotImplemented;
  otTrigger:RaiseNotImplemented;
  else
   RaiseNotImplemented
 end;
end;

procedure TSqlObjectDetailsGetter.GetProcedureDetails;
var
 D:TxDataSet;
begin
 D:=TxDataSet.Create(nil);
  try
   D.ProviderName:=sp_ParamsProcedure;
   D.SetParameter(sp_ProcedureParamName,ObjectName);
   D.DBName:=DBName;
   D.Source:='TSqlObjectDetailsGetter.GetProcedureDetails';
   D.UseHistory:=True;
   D.ExactParams:=True;
   D.Open;
   FDest.LoadFromDataSet(D);
//   ShowDataSet(D);

  finally
   D.Free;
  end;
end;

procedure TSqlObjectDetailsGetter.GetTableDetails;
var
 Tmp:TxDataSet;
begin
Tmp:=TxDataSet.Create(nil);
 try
  Tmp.ProviderName:='spsys_GetTableColumns';
  Tmp.SetParameter('TableName',ObjectName);
  Tmp.DBName:=Self.DBName;
  Tmp.Source:='SqlObjectDetailsGetter.GetTableDetails';
  Tmp.Open;
  FDest.LoadFromDataSet(Tmp);
 finally
   Tmp.Free;
 end;
end;


procedure TSqlObjectDetailsGetter.RaiseNotImplemented;
begin
 raise ENotImplemented.Create('Not implemented');
end;

end.
