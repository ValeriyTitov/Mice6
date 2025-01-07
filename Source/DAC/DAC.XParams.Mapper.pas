unit DAC.XParams.Mapper;

interface

uses System.Classes, System.SysUtils, System.Variants, Data.DB,
     System.Generics.Collections, System.Generics.Defaults,
     Dialogs,
     Common.StringUtils,
     Common.ResourceStrings,
     Common.VariantUtils,
     Common.GlobalSettings,
     DAC.ProviderNamePattern.Parser,
     DAC.XDataSet,
     DAC.XParams,
     DAC.XParams.Utils,
     DAC.XDataSetHelper;

type
 TParamsMapper = class
  private
    FProcessing:TList<string>;
    FDataSetList:TDictionary<string, TDataSet>;
    FParamsList:TDictionary<string, TParams>;
    procedure MapFromDataSet(Item:TDependEntity; FDataSet: TxDataSet);
    procedure LoadConstants(Params:TxParams; DataSet:TDataSet);
    procedure LoadDataFields(Params:TxParams; DataSet:TDataSet; const DataSetName:string);
    procedure LoadParams(Params:TxParams; DataSet:TDataSet; const ParamsName:string);
    procedure LoadGlobalSettings(Params:TxParams; DataSet:TDataSet);
    procedure PopulateParamsByList(FDataSet: TxDataSet);
    procedure PopulateParams(Params:TxParams; DataSet:TDataSet; const Name:string);
    procedure OpenDataSet(const DataSetName:string; DataSet:TDataSet);
    procedure GenerateNewTextProvider(FDataSet: TxDataSet);
    function DataSetByName(const Name:string):TDataSet;
    function ParamsByName(const Name:string):TParams;
    function ReplaceTextWithParams(const Pattern:string):string;
    function ReplaceTextWithDataSetFields(const Pattern:string):string;
    function Params:TParams;
    function FindInDataSet(const CurrentPattern: string; Item:TDependEntity;FDataSet: TxDataSet): string;
    function MapFromParams(Item:TDependEntity;FDataSet: TxDataSet):Boolean;
  public
    procedure AddSource(DataSet:TDataSet; const Name:string);overload;
    procedure AddSource(Params:TParams; const Name:string); overload;
    procedure MapParamsAppCmd(Params:TxParams; AppCmdId:Integer);
    procedure MapDataSet(DataSet:TxDataSet);
    procedure ClearSources;
    function ReplaceTextVars(const Pattern:string):string;
    constructor Create;
    destructor Destroy; override;
 end;


implementation



{ TProviderStringBuilder }

procedure TParamsMapper.AddSource(DataSet: TDataSet; const Name:string);
begin
 if Self.FDataSetList.ContainsKey(Name)=False then
  FDataSetList.Add(Name, DataSet);
end;

procedure TParamsMapper.AddSource(Params: TParams; const Name:string);
begin
 if FParamsList.ContainsKey(Name)=False then
  FParamsList.Add(Name, Params);
end;

procedure TParamsMapper.ClearSources;
begin
  FDataSetList.Clear;
  FParamsList.Clear;
end;

constructor TParamsMapper.Create;
begin
  FProcessing:=TList<string>.Create(TIStringComparer.Ordinal);
  FDataSetList:=TDictionary<string, TDataSet>.Create(TIStringComparer.Ordinal);
  FParamsList:=TDictionary<string, TParams>.Create(TIStringComparer.Ordinal);
end;

function TParamsMapper.DataSetByName(const Name: string): TDataSet;
begin
 if Self.FDataSetList.ContainsKey(Name) then
  Result:=Self.FDataSetList[Name]
   else
  raise Exception.CreateFmt(E_CANNOT_FIND_DATASET_FMT,[Name]);
end;

destructor TParamsMapper.Destroy;
begin
  FProcessing.Free;
  FDataSetList.Free;
  FParamsList.Free;
  inherited;
end;


function TParamsMapper.FindInDataSet(const CurrentPattern:string;Item:TDependEntity;FDataSet: TxDataSet): string;
var
 ADataSet:TDataSet;
 F:TField;
begin
Result:=CurrentPattern;
ADataSet:=DataSetByName(Item.Source);
 if ADataSet.Active=False then
  OpenDataSet(Item.Source, ADataSet);
 F:=ADataSet.FindField(Item.Value);
 if Assigned(F) then
  begin
   Result:=StringReplace(Result,Item.ItemName,TParamUtils.FieldToStr(F),[rfReplaceAll,rfIgnoreCase]);
   FDataSet.SetContext(Item.ItemName,F.AsString);
  end
   else
  raise Exception.CreateFmt(E_CANNOT_FIND_FIELD_DATASET_FMT,[Item.Value, Item.Source]);
end;

procedure TParamsMapper.GenerateNewTextProvider(FDataSet: TxDataSet);
var
 Item:TDependEntity;
 P:TParam;
 AProviderName:string;
begin
AProviderName:=FDataSet.Parser.ProviderName;
for Item in FDataSet.Parser.DependenciesList do
 if Item.IsExternalSource then
  begin
   if Item.Source.IsEmpty then
    begin
     P:=Params.FindParam(Item.Value);
     if Assigned(P) then
      AProviderName:=StringReplace(AProviderName,Item.ItemName,TParamUtils.ParamValueToStr(P),[rfReplaceAll,rfIgnoreCase])
       else
      AProviderName:=FindInDataSet(AProviderName,Item, FDataSet);
    end
     else
    AProviderName:=FindInDataSet(AProviderName,Item, FDataSet);
  end;
  FDataSet.ProviderName:=AProviderName;
end;


procedure TParamsMapper.LoadConstants(Params: TxParams; DataSet: TDataSet);
var
 AValue:Variant;
 AName:string;
begin
 DataSet.Filtered:=False;
 DataSet.Filter:='ParamType=0';
 DataSet.Filtered:=True;
 while not DataSet.Eof do
  begin
    AName:=DataSet.FieldByName('Name').AsString;
    AValue:=TVariantUtils.StrToVariant(DataSet.FieldByName('Value').Value);
    Params.SetParameter(AName, AValue);
    DataSet.Next;
  end;
end;

procedure TParamsMapper.LoadDataFields(Params: TxParams;  DataSet: TDataSet; const DataSetName:string);
var
 ADataSet:TDataSet;
 AValue:Variant;
 AParamName:string;
begin
 DataSet.Filtered:=False;
 DataSet.Filter:='ParamType=1';
 DataSet.Filtered:=True;
 ADataSet:=DataSetByName(DataSetName);
 if Assigned(ADataSet) and (ADataSet.Active) and (not ADataSet.IsEmpty) then
   while not DataSet.Eof do
    begin
      AValue:=TVariantUtils.StrToVariant(ADataSet.FieldByName(DataSet.FieldByName('Value').AsString).Value);
      AParamName:=DataSet.FieldByName('Name').AsString;
      Params.SetParameter(AParamName, AValue);
      DataSet.Next;
    end;
end;

procedure TParamsMapper.LoadGlobalSettings(Params: TxParams;  DataSet: TDataSet);
var
 AName:string;
 AValue:Variant;
begin
 DataSet.Filtered:=False;
 DataSet.Filter:='ParamType=3';
 DataSet.Filtered:=True;
 while not DataSet.Eof do
  begin
    AName:=DataSet.FieldByName('Value').AsString;
    AValue:=TGlobalSettings.DefaultInstance.SettingByName(AName);
    Params.SetParameter(DataSet.FieldByName('Name').AsString, AValue);
    DataSet.Next;
  end;
end;

procedure TParamsMapper.LoadParams(Params: TxParams; DataSet: TDataSet; const ParamsName:string);
var
 AParams:TParams;
 AValue:Variant;
 AParamName:string;
begin
 DataSet.Filtered:=False;
 DataSet.Filter:='ParamType=2';
 DataSet.Filtered:=True;
 AParams:=ParamsByName(ParamsName);
   while not DataSet.Eof do
    begin
      AValue:=TVariantUtils.StrToVariant(AParams.ParamByName(DataSet.FieldByName('Value').AsString).Value);
      AParamName:=DataSet.FieldByName('Name').AsString;
      Params.SetParameter(AParamName, AValue);
      DataSet.Next;
    end;
end;

procedure TParamsMapper.MapDataSet(DataSet:TxDataSet);
begin
 if DataSet.Parser.IsStoredProc then
  PopulateParamsByList(DataSet)
   else
  GenerateNewTextProvider(DataSet);
end;

procedure TParamsMapper.MapFromDataSet(Item:TDependEntity; FDataSet: TxDataSet);
var
 ADataSet:TDataSet;
 F:TField;
begin
 ADataSet:=DataSetByName(Item.Source);
 if not ADataSet.Active then
  OpenDataSet(Item.Source, ADataSet);
  F:=ADataSet.FindField(Item.Value);
  if Assigned(F) then
   FDataSet.SetParameter(Item.Name,F.Value)
    else
  raise Exception.CreateFmt(E_CANNOT_FIND_FIELD_DATASET_FMT,[Item.Value, Item.Source]);
end;

function TParamsMapper.MapFromParams(Item:TDependEntity;FDataSet: TxDataSet):Boolean;
var
 P:TParam;
begin
 if Item.Source.IsEmpty then
  begin
   P:=Params.FindParam(Item.Value);
   Result:=Assigned(P);
   if Result then
    FDataSet.Params.SetParameter(Item.Name, P.Value);
  end
   else
    Result:=False;
end;

function TParamsMapper.Params: TParams;
begin
 Result:=ParamsByName('');
end;

function TParamsMapper.ParamsByName(const Name: string): TParams;
begin
 if Self.FParamsList.ContainsKey(Name) then
  Result:=Self.FParamsList[Name]
   else
  raise Exception.CreateFmt(E_CANNOT_FIND_ITEM_FMT,[Name]);
end;

procedure TParamsMapper.MapParamsAppCmd(Params: TxParams; AppCmdId: Integer);
var
 DataSet:TxDataSet;
begin
  DataSet:=TxDataSet.Create(nil);
  try
   DataSet.Source:='TParamsMapper.PopulateForAppCmd';
   DataSet.ProviderName:='spui_AppCmdParamList';
   DataSet.SetParameter('AppCmdId',AppCmdId);
   DataSet.Open;
   PopulateParams(Params,DataSet,'');
  finally
   DataSet.Free;
  end;
end;


procedure TParamsMapper.OpenDataSet(const DataSetName: string; DataSet: TDataSet);
begin
 if FProcessing.Contains(DataSetName) then
  raise Exception.CreateFmt(E_RECURSIVE_ERROR_FMT,[DataSetName, TStringUtils.ListToString(FProcessing), DataSetName]);
  try
   FProcessing.Add(DataSetName);
   DataSet.Open;
  finally
    FProcessing.Remove(DataSetName);
  end;
end;


procedure TParamsMapper.PopulateParams(Params: TxParams; DataSet:TDataSet; const Name:string);
begin
 DataSet.DisableControls;
 LoadDataFields(Params, DataSet,Name);
 LoadParams(Params, DataSet,Name);
 LoadGlobalSettings(Params, DataSet);
 LoadConstants(Params, DataSet);
end;

procedure TParamsMapper.PopulateParamsByList(FDataSet: TxDataSet);
var
 Item:TDependEntity;
begin
 for Item in FDataSet.Parser.DependenciesList do
  if Item.IsExternalSource then
   begin
    if not MapFromParams(Item, FDataSet) then
     MapFromDataSet(Item, FDataSet);
   end
    else
     FDataSet.SetParameter(Item.Name,Item.Value);
end;

function TParamsMapper.ReplaceTextVars(const Pattern: string): string;
begin
 Result:=Self.ReplaceTextWithParams(Pattern);
 Result:=Self.ReplaceTextWithDataSetFields(Result);
end;

function TParamsMapper.ReplaceTextWithDataSetFields(const Pattern: string): string;
var
 AName:string;
 AKey:string;
 F:TField;
 DataSet:TDataSet;
begin
Result:=Pattern;
for AKey in FDataSetList.Keys do
 begin
  DataSet:=FDataSetList[AKey];
  if (DataSet.Active) and (DataSet.FieldCount>0) then
   for F in DataSet.Fields do
    begin
      if AKey='' then
       AName:=F.FieldName
        else
       AName:=AKey+'.'+F.FieldName;
       AName:='<'+AName+'>';
       Result:=Result.Replace(AName,F.AsString);
    end;
 end;
end;

function TParamsMapper.ReplaceTextWithParams(const Pattern: string): string;
var
 AName:string;
 AKey:string;
 x:Integer;
 P:TParam;
begin
Result:=Pattern;
for AKey in FParamsList.Keys do
 for x:=0 to FParamsList[AKey].Count-1 do
  begin
   P:=FParamsList[AKey][x];
    if AKey='' then
     AName:=P.Name
      else
     AName:=AKey+'.'+P.Name;
     AName:='<'+AName+'>';
     Result:=Result.Replace(AName,VarToStr(P.Value));
  end;
end;

end.

