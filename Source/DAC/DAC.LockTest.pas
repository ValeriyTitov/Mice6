unit DAC.LockTest;

interface
 uses Classes, DAC.XDataSet;

type
 TXDataSetThread = class(TThread)
 protected
  procedure Execute; override;

 end;

implementation

{ TXDataSetThread }

procedure TXDataSetThread.Execute;
var
 DataSet:TxDataSet;
begin
 DataSet:=TxDataSet.Create(nil);
  try
    DataSet.ProviderName:='spsys_LockTest';
    DataSet.Open;
  finally
    DataSet.Free;
  end;

end;

end.
