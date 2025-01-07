unit AppTemplate.Builder.Json;

interface
uses  Data.DB, System.Classes, System.SysUtils, System.Variants,
      cxDBTL, cxTL, System.IOUtils,
      Common.JsonUtils,
      Common.ResourceStrings,
      System.Json,
      AppTemplate.Builder.Abstract,
      DAC.XDataSet;

type
 TAppTemplateBuilderJson = class(TAbstractAppTemplateBuilder)
  private
    FJsonRoot:TJsonValue;
    FLastProgress:Integer;
    procedure Build;
    function NeedXmlValuePair(Node: TcxTreeListNode;jParent:TJsonValue):Boolean;
    procedure AddXmlValuePair(Node: TcxTreeListNode;jParent:TJsonObject);
    procedure AddStandartPair(Node: TcxTreeListNode;jParent:TJsonObject);
    procedure AddPair(Node: TcxTreeListNode;jParent:TJsonValue);
    procedure CreateJsonRoot(Node: TcxTreeListNode);
    procedure CalculateProgress(Current, Total:Integer; const DataSetName:string);

    procedure BuildGroup(Node:TcxTreeListNode; jParent:TJsonValue);
    procedure BuildDataSet(Node:TcxTreeListNode; jParent:TJsonValue; const DataSetName:string);
    procedure BuildNodeByDataSet(Node:TcxTreeListNode; jParent:TJsonValue; const DataSetName:string);
    procedure BuildNodeLevel(ParentNode: TcxTreeListNode;jParent:TJsonValue);

    procedure AddArrayItem(jArray:TJsonArray; Node:TcxTreeListNode; ValueType:Integer);
    procedure DoAddArrayItem(Node:TcxTreeListNode; jParent:TJsonValue);


    function CreateChildObject(Node: TcxTreeListNode;jParent:TJsonValue):TJsonObject;
    function CreateChildArray(Node: TcxTreeListNode;jParent:TJsonValue):TJsonArray;
    function CreateValue(Node: TcxTreeListNode;jParent:TJsonValue; const NodeValue:string):TJsonValue;
    function CreateJsonObject(ObjectType:Integer):TJsonValue;
    function CreateSingleJsonElement(const AValue:string; ValueType:Integer):TJsonValue;
  public
    procedure Execute; override;
    constructor Create; override;
    destructor Destroy; override;
 end;

implementation

{ TAppTemplateBuilderJson }
resourcestring
 E_INVALID_JSON_ITEM_TYPE_FMT= 'Invalid Json item type with ValueType = %d';
 E_INVALID_TAG_TYPE_FMT= 'Invalid tag type with TagType = %d';
 E_INVALID_PARENT_FMT = 'Invalid parent for this type of node %s, AppTemplatesId = %s';

procedure TAppTemplateBuilderJson.Build;
begin
 if Assigned(Grid.TopNode) then
  begin
   CreateJsonRoot(Grid.TopNode);
   BuildNodeLevel(Grid.TopNode, FJsonRoot);
  end;
end;


procedure TAppTemplateBuilderJson.BuildDataSet(Node: TcxTreeListNode; jParent:TJsonValue; const DataSetName: string);
var
 IsActive:Boolean;
begin
 FLastProgress:=0;
 IsActive:=Node.Values[ZActive];
 if IsActive then
  begin
   CheckAlreadyProcessing(DataSetName);
   BuildNodeByDataSet(Node, jParent,DataSetName);
  end;
end;

procedure TAppTemplateBuilderJson.BuildGroup(Node: TcxTreeListNode; jParent: TJsonValue);
var
 x:Integer;
 IsActive:Boolean;
begin
 IsActive:=Node.Values[ZActive];
 if IsActive then
  for x:=0 to Node.Count-1 do
   BuildNodeLevel(Node.Items[x],jParent);
end;

procedure TAppTemplateBuilderJson.BuildNodeByDataSet(Node: TcxTreeListNode; jParent: TJsonValue; const DataSetName: string);
var
 DataSet:TxDataSet;
 AIndex:Integer;
 x:Integer;
 Current:Integer;
begin
 AIndex:=ProcessingDataSets.Add(DataSetName);
 Current:=0;
  try
   DataSet:=DataSetByName(DataSetName);
   SetFilter(DataSet,VarToStr(Node.Values[zDataSetFilter]));
   DataSet.First;
    while (not DataSet.Eof) and (Stopped=False) do
     begin
      CalculateProgress(Current, DataSet.RecordCount,DataSetName);
      for x:=0 to Node.Count-1 do
       BuildNodeLevel(Node.Items[x],jParent);

      DataSet.Next;
      Inc(Current);
     end;
 finally
  ProcessingDataSets.Delete(AIndex);
 end;
end;

procedure TAppTemplateBuilderJson.BuildNodeLevel(ParentNode: TcxTreeListNode; jParent: TJsonValue);
var
 x:Integer;
 ANode:TcxTreeListNode;
 TagType:Integer;
begin
for x:=0 to ParentNode.Count-1 do
  begin
   ANode:=ParentNode[x];
   TagType:=ANode.Values[ZTagType];
    case TagType of
     TagTypeListThroughDataSet: BuildDataSet(ParentNode,jParent,VarToStr(ANode.Values[ZDataSetName]));
     TagTypeGroup:BuildGroup(ANode,jParent);
     TagTypeAttrib: AddPair(ANode,jParent);
     TagTypeNameValue: AddPair(ANode,jParent);
     TagTypeJsonItem: DoAddArrayItem(ANode, jParent);
      else
       raise Exception.CreateFmt(E_INVALID_TAG_TYPE_FMT,[TagType]);
    end;
  end;
end;

procedure TAppTemplateBuilderJson.CalculateProgress(Current, Total: Integer; const DataSetName: string);
begin
 if Current>=FLastProgress then
  begin
   FLastProgress:=FlastProgress+(Total div 231);
   SetProgress(string.Format(S_TEMPLATEBUILDER_PROGRESS_PROCESSING_DATASET_ROWS_FMT,[DataSetName, Current, Total]));
  end;
end;

constructor TAppTemplateBuilderJson.Create;
begin
  inherited;
end;

function TAppTemplateBuilderJson.CreateValue(Node: TcxTreeListNode; jParent: TJsonValue; const  NodeValue:string):TJsonValue;
var
 ValueType:Integer;
begin
 ValueType:=Node.Values[ZValueType];
 case ValueType of
  ValueTypeJsonString: Result:=CreateSingleJsonElement(NodeValue,ValueType);
  ValueTypeJsonNumber: Result:=CreateSingleJsonElement(NodeValue,ValueType);
  ValueTypeJSONBool:   Result:=CreateSingleJsonElement(NodeValue,ValueType);
  ValueTypeJsonNull:   Result:=CreateSingleJsonElement(NodeValue,ValueType);
  ValueTypeJsonObject: Result:=CreateChildObject(Node, jParent);
  ValueTypeJsonArray:  Result:=CreateChildArray(Node,jParent);
  else
   raise Exception.CreateFmt(E_INVALID_JSON_ITEM_TYPE_FMT,[ValueType]);
 end;
end;

function TAppTemplateBuilderJson.CreateChildArray(Node: TcxTreeListNode;  jParent: TJsonValue): TJsonArray;
var
 x:Integer;
 Child:TJsonObject;
 ValueType:Integer;
begin
 Result:=TJsonArray.Create;
 for x:=0 to Node.Count-1 do
  begin
   ValueType:=Node[x].Values[ZValueType];
   if (ValueType=ValueTypeJsonArray)  or (ValueType=ValueTypeJsonObject) then
    begin
     Child:=TJsonObject.Create;
     Result.Add(Child);
     BuildNodeLevel(Node[x],Child)
    end
     else
   AddArrayItem(Result,Node[x], ValueType);
  end;

end;


function TAppTemplateBuilderJson.CreateChildObject(Node: TcxTreeListNode;  jParent: TJsonValue): TJsonObject;
var
 x:Integer;
begin
 Result:=TJsonObject.Create;
 for x:=0 to Node.Count-1 do
  AddPair(Node[x],Result);
end;

procedure TAppTemplateBuilderJson.AddArrayItem(jArray: TJsonArray;  Node: TcxTreeListNode; ValueType:Integer);
var
 NodeValue:string;
begin
 NodeValue:=FindNodeValue(Node);
 jArray.AddElement(CreateSingleJsonElement(NodeValue,ValueType));
end;

function TAppTemplateBuilderJson.NeedXmlValuePair(Node: TcxTreeListNode; jParent: TJsonValue):Boolean;
var
 ValueType:Integer;
begin
 ValueType:=Node.Values[ZValueType];
 Result:=ValueType=ValueTypeJsonXml;
end;

procedure TAppTemplateBuilderJson.AddPair(Node: TcxTreeListNode; jParent: TJsonValue);
begin
 if not (jParent is TJsonObject) then
  raise Exception.CreateFmt(E_INVALID_PARENT_FMT,[jParent.ClassName, VarToStr(Node.Values[ZAppTemplatesDataId])]);

 if NeedXmlValuePair(Node,jParent) then
  AddXmlValuePair(Node,jParent as TJsonObject)
   else
  AddStandartPair(Node,jParent as TJsonObject) 
end;

procedure TAppTemplateBuilderJson.AddStandartPair(Node: TcxTreeListNode; jParent: TJsonObject);
var
 Pair:TJsonPair;
 PairValue:TJsonValue;
 NodeValue:string;
begin
 NodeValue:=FindNodeValue(Node);
 if NeedToCreateNode(Node,NodeValue) then
  begin
   PairValue:=CreateValue(Node,jParent, NodeValue);
   Pair:=TJsonPair.Create(Node.Values[ZTagName],PairValue);
   jParent.AddPair(Pair);
  end;
end;

procedure TAppTemplateBuilderJson.AddXmlValuePair(Node: TcxTreeListNode; jParent: TJsonObject);
var
 ATag:TJsonObject;
 ANodeValue:string;
begin
 ANodeValue:=FindNodeValue(Node);
 ATag:=TJsonObject.Create;

 if (ANodeValue.IsEmpty=False) then
  ATag.AddPair('Value',ANodeValue);

 BuildNodeLevel(Node,ATag);
 jParent.AddPair(Node.Values[ZTagName],ATag);
end;

function TAppTemplateBuilderJson.CreateJsonObject(ObjectType: Integer): TJsonValue;
begin
 case ObjectType of
  ValueTypeJsonObject: Result:=TJsonObject.Create;
  ValueTypeJsonArray : Result:=TJsonArray.Create;
  else
   raise Exception.CreateFmt(E_INVALID_JSON_ITEM_TYPE_FMT,[ObjectType]);
 end;
end;

procedure TAppTemplateBuilderJson.Execute;
begin
  inherited;
  Load;
  QuickCheckNode(Grid.TopNode);
  Build;
  if FormatAfterCreate then
   TFile.WriteAllText(FileName, FJsonRoot.Format())
    else
   TFile.WriteAllText(FileName, FJsonRoot.ToJSON);
end;

procedure TAppTemplateBuilderJson.DoAddArrayItem( Node: TcxTreeListNode; jParent: TJsonValue);
var
 NodeValue:string;
begin
if not (jParent is TJsonArray) then
  raise Exception.CreateFmt(E_INVALID_PARENT_FMT,[jParent.ClassName, VarToStr(Node.Values[ZAppTemplatesDataId])]);

 NodeValue:=FindNodeValue(Node);
 if NeedToCreateNode(Node,NodeValue) then
 (jParent as TJsonArray).AddElement(CreateValue(Node,jParent, NodeValue));
end;

procedure TAppTemplateBuilderJson.CreateJsonRoot(Node: TcxTreeListNode);
var
 TagType:Integer;
 ValueType:Integer;
begin
 FJsonRoot.Free;
 TagType:=Node.Values[ZTagType];
 ValueType:=Node.Values[ZValueType];
 case TagType of
  TagTypeNameValue:FJsonRoot:=CreateJsonObject(ValueTypeJsonObject);
  TagTypeAttrib:FJsonRoot:=CreateJsonObject(ValueTypeJsonObject);
  TagTypeJsonItem:FJsonRoot:=CreateJsonObject(ValueType);
   else
  raise Exception.CreateFmt(E_INVALID_TAG_TYPE_FMT,[TagType]);
 end;
end;

function TAppTemplateBuilderJson.CreateSingleJsonElement(const AValue: string;ValueType: Integer): TJsonValue;
begin
 case ValueType of
  ValueTypeJsonString: Result:=TJsonString.Create(AValue);
  ValueTypeJsonNumber: Result:=TJsonNumber.Create(AValue);
  ValueTypeJSONBool:   Result:=TJsonBool.Create(StrToBool(AValue));
  ValueTypeJsonNull:   Result:=TJsonNull.Create;
  else
   raise Exception.CreateFmt(E_INVALID_JSON_ITEM_TYPE_FMT,[ValueType]);
 end;
end;

destructor TAppTemplateBuilderJson.Destroy;
begin
  FJsonRoot.Free;
  inherited;
end;

end.
