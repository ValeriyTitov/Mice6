unit DAC.XDataSetHelper;

interface

uses DB, System.SysUtils, System.Classes, System.Variants;

type
 TxDataSetHelper = class
  class function ProviderIsStoredProc(const ProviderName:String):Boolean;
  class function FindProviderCacheDuration(const ProviderName:string; Default:Integer):Integer;
  class function FindProviderCommandName(const ProviderName:string):string;
  class function FindProviderDBName(const ProviderName, Default:string):string;
  class function DBNameToStr(const DBName:string):string;
  class function CacheDurationToStr(const Duration:Integer):string;
  class function DataSetToStr(DataSet:TDataSet):string;
  class function DataSetRowToString(DataSet:TDataSet):string;
  class function FindIdentity(DataSet:TDataSet):Variant;
  class function FindAutoIncField(DataSet:TDataSet):TField;
  class function DateTimeToSQLStr(Value: TDateTime): string;
  class function DateToSQLStr(Value: TDateTime): string;
 end;

implementation

{ TxDataSetHelper }

class function TxDataSetHelper.CacheDurationToStr(const Duration: Integer): string;
begin
 if (Duration <= 0) then
  Result:=''
   else
  Result:=',' + IntToStr(Duration);
end;

class function TxDataSetHelper.DataSetRowToString(DataSet: TDataSet): string;
var
 x:integer;
begin
Result:='';
 for x:=0 to DataSet.FieldCount-1 do
  if DataSet.Fields[x].IsNull then
   Result:=Result+DataSet.Fields[x].FieldName+'=NULL '
    else
   Result:=Result+DataSet.Fields[x].FieldName+'='+VarToStr(DataSet.Fields[x].Value)+' ';
end;

class function TxDataSetHelper.DataSetToStr(DataSet: TDataSet): string;
var
 List:TStringList;
 x:Integer;
begin
 List:=TStringList.Create;
 try
  x:=0;
  if not Assigned(DataSet) then
  List.Add('Data set is not assigned; DataSet=nil')
   else
   begin
    if DataSet.Active then
      while not (DataSet.Eof) and (x<10) do
       begin
        List.Add(DataSetRowToString(DataSet));
        Inc(x);
        DataSet.Next;
       end
      else List.Add('DataSet '+DataSet.Name+'is not opened');
   end;
  Result:=List.Text;
 finally
  List.Free;
 end;
end;

class function TxDataSetHelper.DateTimeToSQLStr(Value: TDateTime): string;
begin
  Result := FormatDateTime('yyyy"/"mm"/"dd hh":"nn":"ss', Value);
end;

class function TxDataSetHelper.DateToSQLStr(Value: TDateTime): string;
begin
  Result := FormatDateTime('yyyy"/"mm"/"dd', Value);
end;

class function TxDataSetHelper.DBNameToStr(const DBName: string): string;
begin
if DBName='' then
 Result:=''
  else
 Result:= '['+DBName+'].';
end;

class function TxDataSetHelper.FindAutoIncField(DataSet: TDataSet): TField;
var
 x:Integer;
begin
 for x:=0 to DataSet.FieldCount-1 do
  If DataSet.Fields[x].DataType=ftAutoInc then
    Exit(DataSet.Fields[x]);

 Result:=nil;
end;

class function TxDataSetHelper.FindIdentity(DataSet: TDataSet): Variant;
var
 F:TField;
begin
 F:=FindAutoIncField(DataSet);
 if Assigned(F) and (F.AsInteger<>-1) then
  Result:=F.Value
   else
  Result:=NULL;
end;

class function TxDataSetHelper.FindProviderCacheDuration(const ProviderName: string; Default:Integer): Integer;
var
 AIndex:Integer;
 L:Integer;
begin
 Result:=0;
 AIndex:=Pos(',',ProviderName);
 if (AIndex >= 1) then
  begin
   L:=Length(ProviderName);
   if (AIndex+1)<=L then
    Result:=StrToIntDef(ProviderName.Substring(AIndex+1),0);
  end;
end;


class function TxDataSetHelper.FindProviderCommandName(const ProviderName: string): string;
var
 AIndex, AIndex2:Integer;
begin
 AIndex:= Pos('].',ProviderName);
 AIndex2:= Pos(',',ProviderName);
 Result:=ProviderName;
 if ((AIndex > 0) and (AIndex2 > 0)) then
  Result:= ProviderName.Substring(AIndex + 1,AIndex2 - AIndex - 2)
 else if ((AIndex <= 0) and (AIndex2 > 0)) then
   Result:=ProviderName.Substring(0, AIndex2-1)
 else if (AIndex > 0) and (AIndex2 <= 0) then
   Result:= ProviderName.Substring(AIndex+1, Length(ProviderName)-AIndex-1);
end;

class function TxDataSetHelper.FindProviderDBName(const ProviderName, Default: string): string;
var
 AIndex:integer;
begin
 AIndex:=Pos('].',ProviderName);
 if (AIndex >= 2) then
   Result:=ProviderName.Substring(1,AIndex - 2)
    else
   Result:=Default;
end;

class function TxDataSetHelper.ProviderIsStoredProc(const ProviderName: string): Boolean;
begin
 Result:=not (ProviderName.Contains(' ') or ProviderName.Contains(#9) or ProviderName.Contains(#13) or ProviderName.Contains(#160));
//  Result:=Pos(' ',ProviderName)<=0;
end;

end.
