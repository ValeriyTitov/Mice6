unit DAC.XParams.Utils;

interface
uses
 Data.DB, System.SysUtils, System.Classes, FireDAC.Stan.Param,
 System.Generics.Collections, System.Generics.Defaults,
 System.Variants,
 Common.StringUtils,
 Common.FormatSettings,
 Common.VariantUtils;

type
 TParamUtils = class
   public
    class procedure CloneExistingParamValues(Source:TParams;Dest:TFDParams); overload;
    class procedure CloneExistingParamValues(Source:TParams;Dest:TParams); overload;
    class procedure FindMatchingParams(Source, Dest:TParams; DataSet:TDataSet);
    class procedure DeleteMissingParams(Source:TParams;Dest:TFDParams);
    class procedure SetParamEx(Params:TParams; const AParamName:string; const AValue:Variant);
    class procedure DataSetToParams(DataSet:TDataSet; Params:TParams);
    class function NormalizeParamName(const ParamName:string):string;
    class function NormalizeParamNameEcho(const ParamName:string):string;
    class function ParamValueToStr(Param:TParam):string;
    class function ParamToStr(Param:TParam):string;
    class function FieldToStr(Field:TField):string;
    class function ParamToQueryStr(Param:TParam):string;
    class function ParamsToStr(Params:TFDParams):string; overload;
    class function ParamsToStr(Params:TParams):string; overload;
    class function ParamByNameDef(Params:TParams;ParamName:string;const DefaultValue:Variant):Variant;
    class function StringToParamType(s:string): TParamType;
    class function StringToFieldType(const s:string): TFieldType;
    class function CreateParamsFromDataSet(DataSet:TDataSet):TParams;
    class function FieldTypeToStr(FieldType:TFieldType):string;
    class function StrToDateTimeDef2(const s:string; Default:TDateTime):TDateTime;
   end;


implementation

var
 FSQLTypes:TDictionary<string, TFieldType>;


{ TParamUtils }

class procedure TParamUtils.CloneExistingParamValues(Source: TParams; Dest: TFDParams);
var
 X:Integer;
 P:TParam;
 ParamName:string;
begin
 for x:=0 to Dest.Count-1 do
  begin
   ParamName:=NormalizeParamName(Dest[x].Name);
   P:=Source.FindParam(ParamName);
   if Assigned(P) then
    Dest[x].Value:=P.Value;
  end;

end;

class procedure TParamUtils.CloneExistingParamValues(Source, Dest: TParams);
var
 X:Integer;
 P:TParam;
 ParamName:string;
begin
 for x:=0 to Dest.Count-1 do
  begin
   ParamName:=NormalizeParamName(Dest[x].Name);
   P:=Source.FindParam(ParamName);
   if Assigned(P) then
    Dest[x].Value:=P.Value;
  end;
end;

class function TParamUtils.CreateParamsFromDataSet(DataSet: TDataSet): TParams;
var
 P:TParam;
begin
 Result:=TParams.Create;
 while not DataSet.Eof do
  begin
   P:=Result.AddParameter;
   P.Name:=TParamUtils.NormalizeParamName(DataSet.FieldByName('PARAMETER_NAME').AsString);
   P.DataType:=TParamUtils.StringToFieldType(DataSet.FieldByName('DATA_TYPE').AsString);
   P.ParamType:=TParamUtils.StringToParamType(DataSet.FieldByName('PARAMETER_MODE').AsString);

   if not DataSet.FieldByName('CHARACTER_MAXIMUM_LENGTH').IsNull then
    P.Size:=DataSet.FieldByName('CHARACTER_MAXIMUM_LENGTH').AsInteger;
//   P.NumericScale:=DataSet.FieldByName('NUMERIC_SCALE').AsInteger;
//   P.Precision:=DataSet.FieldByName('NUMERIC_PRECISION').AsInteger;
   DataSet.Next;
  end;
end;

class function TParamUtils.ParamByNameDef(Params: TParams; ParamName: string; const DefaultValue: Variant): Variant;
var
 P:TParam;
begin
 P:=Params.FindParam(ParamName);
 If Assigned(P) then
  Result:=P.Value
   else
  Result:=DefaultValue;
end;

class function TParamUtils.ParamsToStr(Params: TFDParams): string;
var
 AParams:TParams;
begin
 AParams:=TParams.Create;
 try
  AParams.Assign(Params);
  Result:=Self.ParamsToStr(AParams);
 finally
  AParams.Free;
 end;

end;

class procedure TParamUtils.DataSetToParams(DataSet: TDataSet; Params: TParams);
var
 X:Integer;
begin
 If (DataSet.Active) and (DataSet.FieldCount>0) then
  for x:=0 to Dataset.FieldCount-1 do
   SetParamEx(Params,DataSet.Fields[x].FieldName, DataSet.Fields[x].Value);
end;

class procedure TParamUtils.DeleteMissingParams(Source: TParams;  Dest: TFDParams);
var
 x:Integer;
 P:TParam;
begin
 for x:=Dest.Count-1 downto 0 do
  begin
   P:=Source.FindParam(NormalizeParamName(Dest[x].Name));
   if not Assigned(P) then
    Dest.Delete(x);
  end;
end;

class function TParamUtils.FieldToStr(Field: TField): string;
var
 P:TParam;
begin
 P:=TParam.Create(nil);
 try
   P.DataType:=Field.DataType;
   P.Value:=Field.Value;
   Result:=ParamValueToStr(P);
 finally
  P.Free;
 end;

end;


class function TParamUtils.FieldTypeToStr(FieldType: TFieldType): string;
var
 s:string;
begin
 for s in FSQLTypes.Keys do
  if FSQLTypes[s]=FieldType then
   Exit(s);

 Result:='Unknown';
end;


class procedure TParamUtils.FindMatchingParams(Source, Dest: TParams;  DataSet: TDataSet);
var
 P:TParam;
 NewParam:TParam;
 ParamName:string;
begin
 while not DataSet.Eof do
  begin
   ParamName:=TParamUtils.NormalizeParamName(DataSet.FieldByName('PARAMETER_NAME').AsString);
   P:=Source.FindParam(ParamName);
   if Assigned(P) then
    begin
     NewParam:=Dest.FindParam(ParamName);
      if not Assigned(NewParam) then
       begin
        NewParam:=Dest.AddParameter;
        NewParam.Name:=ParamName;
        NewParam.DataType:=Self.StringToFieldType(DataSet.FieldByName('DATA_TYPE').AsString);
        NewParam.ParamType:=Self.StringToParamType(DataSet.FieldByName('PARAMETER_MODE').AsString);

        if not DataSet.FieldByName('CHARACTER_MAXIMUM_LENGTH').IsNull then
         NewParam.Size:=DataSet.FieldByName('CHARACTER_MAXIMUM_LENGTH').AsInteger;

        {if not DataSet.FieldByName('NUMERIC_PRECISION').IsNull then  //C# конвертирует тим TinyInt в Blob, и тут возникает ошибка.
         NewParam.Precision:=DataSet.FieldByName('NUMERIC_PRECISION').Value;
        if not DataSet.FieldByName('NUMERIC_SCALE').IsNull then
         NewParam.NumericScale:=DataSet.FieldByName('NUMERIC_SCALE').AsInteger;
         }
       end;
    NewParam.Value:=P.Value;
    end;
   DataSet.Next;
  end;
end;

class function TParamUtils.NormalizeParamName(const ParamName: String): String;
begin
 if ParamName.StartsWith('@') then
  Result:=ParamName.Substring(1)
   else
  Result:=ParamName;
end;

class function TParamUtils.NormalizeParamNameEcho(const ParamName: String): String;
begin
 if ParamName.StartsWith('@') then
  Result:=ParamName
   else
  Result:='@'+ParamName;
end;

class function TParamUtils.ParamsToStr(Params: TParams): string;
var
 x:Integer;
begin
Result:='';
If (Params.Count>0) then
 for x:=0 to Params.Count-1 do
  if (x=Params.Count-1) then //не добавлять разделитель в начале и конце
   Result:=Result+ParamToStr(Params[x])
    else
   Result:=Result+ParamToStr(Params[x])+', ';
end;

class function TParamUtils.ParamToQueryStr(Param: TParam): string;
begin
if (Param=nil)or(Param.Name='')or TStringUtils.SameString(Param.Name,'@RETURN_VALUE') then
 Result:=''
  else
 Result:=NormalizeParamName(Param.Name)+'='+VarToStr(Param.Value);
end;

class function TParamUtils.ParamToStr(Param: TParam): string;
begin
if (Param=nil)or(Param.Name='') or (TStringUtils.SameString(Param.Name,'@RETURN_VALUE')) then
 Result:=''
  else
 Result:=NormalizeParamNameEcho(Param.Name+'='+ParamValueToStr(Param));
end;


class function TParamUtils.ParamValueToStr(Param: TParam): string;
begin
if Param.IsNull then
 Exit('NULL');
case Param.DataType of
 ftUnknown:Result:=TVariantUtils.VarToSQLStr(Param.Value, MiceFormatSettings);
 ftInteger, ftSmallint, ftWord, ftLargeint,ftAutoInc : Result:=VarToStr(Param.Value);
 ftDateTime:Result:=QuotedStr(FormatDateTime(DEFAULT_DATETIME_FORMAT, Param.AsDateTime, MiceFormatSettings));
 ftDate: Result:=QuotedStr(FormatDateTime(DEFAULT_DATE_FORMAT, Param.AsDate , MiceFormatSettings));
 ftString, ftWideString: Result:=QuotedStr(VarToStr(Param.Value));
 ftFloat, ftCurrency :Result:=FloatToStr(Param.AsFloat, MiceFormatSettings);
 ftBCD: Result:=FloatToStr(Param.AsFloat, MiceFormatSettings);
 ftBoolean : Result:=VarToStr(Integer(Param.AsBoolean));
 ftBlob : Result:='<BLOB>';
 else
  Result:=TVariantUtils.VarToSQLStr(Param.Value, MiceFormatSettings);
 end;
if Result='' then
 Result:='NULL';
end;

class procedure TParamUtils.SetParamEx(Params: TParams; const AParamName: string; const AValue: Variant);
var
 FName:String;
 P:TParam;
 I:Integer;
 D:TDateTime;
 B:Boolean;
 s:string;
begin
 FName:=NormalizeParamName(AParamName).Trim;
 if (FName<>'') then
  begin
   P:=Params.FindParam(FName);
   if not Assigned(P) then
    begin
     if VarIsNull(AValue) then
      begin
       Params.CreateParam(ftUnknown,FName,ptInput);
       Exit;
      end;

     s:=VarToStr(AValue);
    { if TStringUtils.SameString(AValue,NullStrValue) then
      Params.CreateParam(ftUnknown,FName,ptInput).Value:=NULL
      else }
     if TryStrToInt(s,I) then
      Params.CreateParam(ftInteger,FName,ptInput).Value:=I
       else
     if TryStrToDate(s,D, MiceFormatSettings) then
      Params.CreateParam(ftDateTime,FName,ptInput).Value:=D
       else
     if TryStrToBool(s,B) then
       Params.CreateParam(ftBoolean,FName,ptInput).Value:=B
      else
     if VarIsStr(AValue) then
      Params.CreateParam(ftString,FName,ptInput).Value:=TVariantUtils.StrToVariant(AValue)
         else
      Params.CreateParam(ftUnknown,FName,ptInput).Value:=AValue
    end
     else
      begin
       P.DataType:=ftUnknown;
       P.Value:=AValue;
      end;
  end;
end;


class function TParamUtils.StringToFieldType(const s: string): TFieldType;
begin
{ftUnknown, ftString, ftSmallint, ftInteger, ftWord, ftBoolean, ftFloat, ftCurrency, ftBCD, ftDate,
ftTime, ftDateTime, ftBytes, ftVarBytes, ftAutoInc, ftBlob, ftMemo, ftGraphic, ftFmtMemo, ftParadoxOle,
ftDBaseOle, ftTypedBinary, ftCursor, ftFixedChar, ftWideString, ftLargeint, ftADT, ftArray, ftReference,
ftDataSet, ftOraBlob, ftOraClob, ftVariant, ftInterface, ftIDispatch, ftGuid, ftTimeStamp, ftFMTBcd}
 if FSQLTypes.ContainsKey(s) then
  Result:=FSQLTypes[s]
   else
  Result:=ftUnknown;
end;

class function TParamUtils.StringToParamType(S: string): TParamType;
begin
{TParameterDirection =(pdUnknown, pdInput, pdOutput, pdInputOutput, pdReturnValue);}
s:=AnsiUppercase(s);
if s='OUT' then Result:=ptOutput
 else
if s='IN' then Result:=ptInput
 else
if s='INOUT' then Result:=ptInputOutput
 else
 Result := ptUnknown;
end;




class function TParamUtils.StrToDateTimeDef2(const s: string;  Default: TDateTime): TDateTime;
begin
 Result:=StrToDateTimeDef(s,Default, MiceFormatSettings);
end;

initialization

FSQLTypes:=TDictionary<string, TFieldType>.Create(TIStringComparer.Ordinal);
FSQLTypes.Add('bigint', ftLargeint);      {0}
FSQLTypes.Add('bit', ftBoolean);          {1}
FSQLTypes.Add('char', ftString);          {2}
FSQLTypes.Add('date', ftDate);	          {3}
FSQLTypes.Add('datetime',ftDateTime);     {4}
FSQLTypes.Add('decimal',ftBCD);	          {5}
FSQLTypes.Add('float',ftFloat);	          {6}
FSQLTypes.Add('image',ftBLOB);	          {7}
FSQLTypes.Add('int',ftInteger);	          {8}
FSQLTypes.Add('money',ftBCD);	            {9}
FSQLTypes.Add('numeric',ftBCD);  	        {10}
FSQLTypes.Add('nvarchar',ftWideString);	  {11}
FSQLTypes.Add('real',ftFloat);	          {12}
FSQLTypes.Add('smallint',ftSmallInt);	    {13}
FSQLTypes.Add('text',ftString);	          {14}
FSQLTypes.Add('tinyint',ftSmallInt);	    {15}
FSQLTypes.Add('uniqueidentifier',ftGuid); {16}
FSQLTypes.Add('varbinary',ftGuid);	      {17}
FSQLTypes.Add('varchar',ftString);	      {18}
FSQLTypes.Add('xml',ftString);            {19}

finalization
FSQLTypes.Free;

end.
