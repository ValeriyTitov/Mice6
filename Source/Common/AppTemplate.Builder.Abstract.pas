unit AppTemplate.Builder.Abstract;

interface
uses
 Data.DB, System.Classes, System.SysUtils, System.Variants,
 System.IOUtils, System.Generics.Collections,System.Generics.Defaults,
 cxDBTL, cxTL,
 CustomControl.TreeGrid,
 Common.ResourceStrings,
 Common.GlobalSettings,
 Common.VariantComparator,
 DAC.XDataSet,
 DAC.XParams,
 Common.FormatSettings,
 DAC.XParams.Utils;

type
 TAbstractAppTemplateBuilder = class(TComponent)
  private
    FStopped:Boolean;
    FGrid: TMiceTreeGrid;
    FFileName: string;
    FParams: TxParams;
    FAppTemplatesId: Integer;
    FDBName: string;
    FCurrentProgress: string;
    FOnProgress: TNotifyEvent;
    FDataSetList: TObjectDictionary<string, TxDataSet>;
    FProcessingDataSets: TList<string>;
    FFormatAfterCreate: Boolean;
    FStream: TStream;
    procedure SetStream(const Value: TStream);
  protected
    property ProcessingDataSets: TList<string> read FProcessingDataSets;
    property Grid: TMiceTreeGrid read FGrid;
    procedure Load;
    procedure LoadDataSetList;
    procedure SetProgress(const Msg:string);
    procedure DoOnProgress;
    procedure SetFilter(DataSet: TxDataSet; const Filter: string);
    procedure CheckAlreadyProcessing(const DataSetName:string);
    procedure QuickCheckNode(FNode: TcxTreeListNode);

    function DataSetByName(const Name:string):TxDataSet;
    function DataSetInProcess(const DataSetName:string):Boolean;
    function FieldToString(Field:TField;const Format:string):string;
    function FindDataSetValue(const DataSetName, FieldName,  Filter, Format: string): string;
    function FindNodeValue(Node: TcxTreeListNode): string;
    function NeedToCreateNode(Node: TcxTreeListNode;const Value:string):Boolean;
  public
    procedure Execute; virtual;
    procedure Stop;
    constructor Create; reintroduce; virtual;
    destructor Destroy; override;
  published
    property Stopped:Boolean read FStopped;
    property DataSetList: TObjectDictionary<string, TxDataSet> read FDataSetList;
    property Params:TxParams read FParams;
    property OnProgress:TNotifyEvent read FOnProgress write FOnProgress;
    property CurrentProgress:string read FCurrentProgress;
    property AppTemplatesId:Integer read FAppTemplatesId write FAppTemplatesId;
    property FileName:string read FFileName write FFileName;
    property FormatAfterCreate:Boolean read FFormatAfterCreate write FFormatAfterCreate;
    property DBName:string read FDBName write FDBName;
    property Stream:TStream read FStream write SetStream;
 end;

resourcestring

 S_TEMPLATEBUILDER_PROGRESS_WAITING = 'Waiting';
 S_TEMPLATEBUILDER_PROGRESS_GETTING_DATA = 'Opening datasets.';
 S_TEMPLATEBUILDER_PROGRESS_BUILDING_TREE = 'Building data tree';
 S_TEMPLATEBUILDER_PROGRESS_PROCESSING_DATASET_ROWS_FMT = 'Processing dataset "%s", %d of %d';
 S_TEMPLATEBUILDER_PROGRESS_SAVING_DATA_TO_FMT ='Saving to %s';
 S_TEMPLATEBUILDER_PROGRESS_FORMATING_DATA ='Formating data';
 S_TEMPLATEBUILDER_PROGRESS_CLEARING_DATA = 'Clearing data';
 S_TEMPLATEBUILDER_FINISHED_IN_N_SECONDS_FMT = 'Finished in %d seconds';

 E_TEMPLATEBUILDER_TEMPLATE_IS_EMPTY_FMT = 'Export template with AppTemplatesId=%d is empty';


 E_TEMPLATEBUILDER_UNKNOWN_DATASOUCE_FMT = 'Unknown data source (%d) for node value';
 E_TEMPLATEBUILDER_RECURSIVE_DATASET_FMT = 'Recursive acesss to DataSet "%s"';



const
  ZAppTemplatesDataId=0;
  ZAppTemplatesId=1;
  ZParentId=2;
  ZActive=3;
  ZOrderId=4;
  ZTagName=5;
  ZTagType=6;
  ZValueSource=7;
  ZDataSetName=8;
  ZValue=9;
  ZDataSetFilter=10;
  ZDefaultValue=11;
  ZCreateCondition=12;
  ZCreateConditionValue=13;
  ZFormat=14;
  ZDescription=15;
  ZValueType=16;

  TagTypeNameValue=0;
  TagTypeAttrib=1;
  TagTypeJsonItem=2;
  TagTypeListThroughDataSet=3;
  TagTypeGroup=4;

  ValueTypeJsonString = 0;
  ValueTypeJsonNumber = 1;
  ValueTypeJSONBool = 2;
  ValueTypeJsonNull = 3;
  ValueTypeJsonObject = 4;
  ValueTypeJsonArray = 5;
  ValueTypeJsonXml = 6;




implementation


{ TAbstractAppTemplateBuilder }

procedure TAbstractAppTemplateBuilder.CheckAlreadyProcessing(const DataSetName: string);
begin
 if DataSetInProcess(DataSetName) then
  raise Exception.CreateFmt(E_TEMPLATEBUILDER_RECURSIVE_DATASET_FMT, [DataSetName]);
end;

procedure TAbstractAppTemplateBuilder.QuickCheckNode(FNode: TcxTreeListNode);
var
 FValueSource:Integer;
 FID:Integer;
 FValue:string;
 FDataSetName:string;
 FActive:Boolean;
 X:Integer;
const
 ErrorInfo ='%s'#13'Node details:'#13'AppTemplatesDataId=%d'#13'ValueSource=%d'#13'DataSetName=%s'#13'Value=%s';
begin
   FActive:=FNode.Values[ZActive];
   FValue:=S_COMMON_UNKNOWN_BRACKETS;
   FDataSetName:=S_COMMON_UNKNOWN_BRACKETS;
   FValueSource:=-1;
   FID:=-1;
   if FActive then
    begin
      try
       FID:=FNode.Values[ZAppTemplatesDataId];
       FValueSource:=FNode.Values[ZValueSource];
       FDataSetName:=VarToStr(FNode.Values[ZDataSetName]);
       FValue:=VarToStr(FNode.Values[ZValue]);
       case FValueSource of
         1:DataSetByName(FDataSetName).FieldByName(FValue);
         2:Params.ParamByName(FValue);
         3:TGlobalSettings.DefaultInstance.SettingByName(FValue);
       end;
      except on E:Exception do
       raise Exception.CreateFmt(ErrorInfo,[E.Message, FID, FValueSource, FDataSetName,FValue]);
     end;
      for x:=0 to FNode.Count-1 do
       QuickCheckNode(FNode.Items[x]);
    end;
end;

constructor TAbstractAppTemplateBuilder.Create;
begin
 inherited Create(nil);
 FStopped:=False;
 FDataSetList:=TObjectDictionary<string, TxDataSet>.Create([doOwnsValues],TIStringComparer.Ordinal);
 FParams:=TxParams.Create;
 FProcessingDataSets:=TList<string>.Create;
 FCurrentProgress:= S_TEMPLATEBUILDER_PROGRESS_WAITING;

 FGrid:=TMiceTreeGrid.Create(Self);
 FGrid.DataSet.ProviderName:='spui_AppTemplatesData';
 FGrid.DataController.KeyField:='AppTemplatesDataId';
 FGrid.DataController.ParentField:='ParentId';
end;

function TAbstractAppTemplateBuilder.DataSetByName( const Name: string): TxDataSet;
begin
 if FDataSetList.ContainsKey(Name) then
  begin
   Result:=FDataSetList[Name];
   if not Result.Active then
    begin
     Result.Params.LoadFromParams(Self.Params);
     Result.Open;
    end;
  end
   else
  raise Exception.CreateFmt(E_CANNOT_FIND_DATASET_FMT,[Name]);
end;

function TAbstractAppTemplateBuilder.DataSetInProcess(const DataSetName: string): Boolean;
begin
 Result:=ProcessingDataSets.IndexOf(DataSetName)>=0;
end;

destructor TAbstractAppTemplateBuilder.Destroy;
begin
  FDataSetList.Free;
  FParams.Free;
  FProcessingDataSets.Free;
  inherited;
end;

procedure TAbstractAppTemplateBuilder.DoOnProgress;
begin
 if Assigned(OnProgress) then
  OnProgress(Self);
end;

procedure TAbstractAppTemplateBuilder.Execute;
begin
 FStopped:=False;
 ProcessingDataSets.Clear;
end;

function TAbstractAppTemplateBuilder.FieldToString(Field: TField;  const Format: string): string;
begin
 if (Field.DataType=ftDateTime) or (Field.DataType=ftDate) and (Format.IsEmpty=False) and (Field.AsString.IsEmpty=False) then
  Result:=FormatDateTime(Format, Field.AsDateTime, MiceFormatSettings)
   else
 Result:=Field.AsString;
end;

function TAbstractAppTemplateBuilder.FindDataSetValue(const DataSetName,  FieldName, Filter, Format: string): string;
var
 DataSet:TxDataSet;
begin
 DataSet:=DataSetByName(DataSetName);
 if not Filter.Trim.IsEmpty then
    begin
     CheckAlreadyProcessing(DataSetName);
     SetFilter(DataSet,Filter);
    end;
   Result:=FieldToString(DataSet.FieldByName(FieldName), Format);
end;

function TAbstractAppTemplateBuilder.FindNodeValue( Node: TcxTreeListNode): string;
var
 ASource:Integer;
 AValue:string;
 AFormat:string;
begin
 ASource:=Node.Values[ZValueSource];
 AValue:=VarToStr(Node.Values[zValue]);
 AFormat:=VarToStr(Node.Values[zFormat]);
 case ASource of
  0:Result:=AValue; //const
  1:Result:=FindDataSetValue(VarToStr(Node.Values[ZDataSetName]),AValue,VarToStr(Node.Values[ZDataSetFilter]), AFormat); //DataSet
  2:Result:=Params.ParamByName(AValue).AsString; //Params
  3:Result:=TGlobalSettings.DefaultInstance.SettingByName(AValue); //GlobalSettings
   else
    raise Exception.CreateFmt(E_TEMPLATEBUILDER_UNKNOWN_DATASOUCE_FMT,[ASource]);
 end;
 if Result.IsEmpty then
  Result:=VarToStr(Node.Values[ZDefaultValue]);
end;

procedure TAbstractAppTemplateBuilder.Load;
begin
 SetProgress(S_TEMPLATEBUILDER_PROGRESS_GETTING_DATA);
 FGrid.DataSet.Params.SetParameter('AppTemplatesId', AppTemplatesId);
 LoadDataSetList;
 SetProgress(S_TEMPLATEBUILDER_PROGRESS_BUILDING_TREE);
 FGrid.DataSet.Open;
 if FGrid.DataSet.RecordCount<=0 then
  raise Exception.CreateFmt(E_TEMPLATEBUILDER_TEMPLATE_IS_EMPTY_FMT,[AppTemplatesId]);

 FGrid.DataController.CreateAllItems;
 FGrid.BeginUpdate;
 FGrid.DataSet.DisableControls;
end;

procedure TAbstractAppTemplateBuilder.LoadDataSetList;
var
 DataSet:TxDataSet;
 NewDataSet:TxDataSet;
 AKey:string;
 ADBName:string;
begin
  DataSet:=TxDataSet.Create(nil);
  try
   DataSet.ProviderName:='spui_AppTemplatesDataSetList';
   DataSet.SetParameter('AppTemplatesId',AppTemplatesId);
   DataSet.Source:='TAppTemplateBuilderXml.LoadDataSetList';
   DataSet.Open;
//   if DataSet.IsEmpty then
//    raise Exception.CreateFmt(S_TEMPLATEBUILDER_TEMPLATE_IS_EMPTY_FMT,[AppTemplatesId]);
   while not DataSet.Eof do
    begin
      AKey:=DataSet.FieldByName('DataSetName').AsString;
      NewDataSet:=TxDataSet.Create(nil);
      FDataSetList.Add(AKey,NewDataSet);
      NewDataSet.Source:='TAppTemplateBuilderXml.LoadDataSetList';
      NewDataSet.ProviderName:=DataSet.FieldByName('ProviderName').AsString;
      ADBName:=DataSet.FieldByName('DBName').AsString;
      if ADBName.IsEmpty then
        NewDataSet.DBName:=Self.DBName
         else
        NewDataSet.DBName:=ADBName;
      DataSet.Next;
    end;
  finally
   DataSet.Free;
  end;
end;

function TAbstractAppTemplateBuilder.NeedToCreateNode(Node: TcxTreeListNode; const Value: string): Boolean;
var
 AEquation:TVariantEquation;
 AActive:Boolean;
 AComparationValue:Variant;
 DeleteByRule:Boolean;
begin
 AActive:=Node.Values[ZActive];
 AEquation:=Node.Values[ZCreateCondition];
 Result:=(AActive) and (AEquation = veUnknown);
 if AActive and (Result=False) then
  begin
   AComparationValue:=Node.Values[ZCreateConditionValue];
   DeleteByRule:=TVariantComparator.CompareVariant(AComparationValue, Value, AEquation);
   Result:=DeleteByRule; //or NodeHasAttributes(Node) //  or (Node.HasChildren);
  end;
end;

procedure TAbstractAppTemplateBuilder.SetFilter(DataSet: TxDataSet;  const Filter: string);
begin
 if Filter.Trim<>'' then
  begin
   DataSet.Filtered:=False;
   DataSet.Filter:=Filter;
   DataSet.Filtered:=True;
  end;
end;

procedure TAbstractAppTemplateBuilder.SetProgress(const Msg: string);
begin
 FCurrentProgress:=Msg;
 DoOnProgress;
end;

procedure TAbstractAppTemplateBuilder.SetStream(const Value: TStream);
begin
  FStream := Value;
end;

procedure TAbstractAppTemplateBuilder.Stop;
begin
 FStopped:=True;
end;

end.
