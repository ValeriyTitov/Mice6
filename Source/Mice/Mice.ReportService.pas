unit Mice.ReportService;

interface
 uses System.SysUtils,
      System.Classes,
      System.NetEncoding,
      DAC.XDataSet,
      Data.DB,
      System.Variants,
      Mice.Report;

 type
  TMiceReportService = class
  private
    procedure ExecuteTask(DataSet:TDataSet);
    procedure SaveReport(Stream:TMemoryStream; DataSet:TDataSet);
    procedure SetError(DataSet:TDataSet; ErrorMessage:string);
    function StreamToBase64(Stream:TMemoryStream): string;
  public
    procedure Execute;
  end;

implementation

{ TMiceReportService }

procedure TMiceReportService.Execute;
var
  Tmp:TxDataSet;
begin
  Tmp:=TxDataSet.Create(nil);
  try
   Tmp.DBName:='ReportDB';
   Tmp.ProviderName:='spww_EnquedReportList';
   Tmp.Open;
   while not Tmp.EOf do
     begin
      ExecuteTask(Tmp);
      Tmp.Next;
     end;
  finally
    Tmp.Free;
  end;
end;

procedure TMiceReportService.SaveReport(Stream: TMemoryStream; DataSet: TDataSet);
var
  Tmp:TxDataSet;
begin
  Tmp:=TxDataSet.Create(nil);
   try
    Tmp.DBName:='ReportDB';
    Tmp.ProviderName:='spww_LoadEnquedReport';
    Tmp.SetParameter('EnquedReportsId',DataSet.FieldByName('EnquedReportsId').AsInteger);
    Tmp.SetParameter('StringStatus','Выполнен');
    Tmp.SetParameter('IntStatus',1);
    Tmp.SetParameter('ReportBody',StreamToBase64(Stream));
    Tmp.OpenOrExecute;
   finally
    Tmp.Free;
   end;
end;

procedure TMiceReportService.SetError(DataSet: TDataSet; ErrorMessage: string);
var
  Tmp:TxDataSet;
begin
  Tmp:=TxDataSet.Create(nil);
   try
     Tmp.DBName:='ReportDB';
     Tmp.ProviderName:='spww_LoadEnquedReport';
     Tmp.SetParameter('EnquedReportsId',DataSet.FieldByName('EnquedReportsId').AsInteger);
     Tmp.SetParameter('StringStatus',ErrorMessage);
     Tmp.SetParameter('IntStatus',2);
     Tmp.SetParameter('ReportBody',NULL);
     Tmp.OpenOrExecute;
   finally
    Tmp.Free;
   end;
end;

procedure TMiceReportService.ExecuteTask(DataSet: TDataSet);
var
 R:TMiceReport;
 Stream:TMemoryStream;
begin
 R:=TMiceReport.Create(nil);
 Stream:=TMemoryStream.Create;
 try
  try
   R.AppReportsId:=DataSet.FieldByName('AppReportsId').AsInteger;
   R.Params.AsJson:=DataSet.FieldByName('JsonParams').AsString;
   R.ExportToStream(Stream,DataSet.FieldByName('FileFormat').AsString);
   SaveReport(Stream, DataSet);
  except on E:Exception do
   SetError(DataSet,E.Message);
  end;
 finally
  Stream.Free;
  R.Free;
 end;
end;

function TMiceReportService.StreamToBase64(Stream: TMemoryStream): string;
var
 M1:TStringStream;
begin
 M1:=TStringStream.Create('');
  try
   Stream.Seek(0,0);
   TNetEncoding.Base64.Encode(Stream,M1);
   Result:=M1.DataString;
  finally
   M1.Free;
  end;
end;

end.
