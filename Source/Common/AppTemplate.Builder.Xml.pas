unit AppTemplate.Builder.Xml;

interface
uses  Data.DB, System.Classes, System.SysUtils, System.Variants,
      Xml.xmldom, Xml.XMLIntf, Xml.XMLDoc,
      cxDBTL, cxTL,
      AppTemplate.Builder.Abstract,
      DAC.XDataSet,
      Xml.omnixmldom; //Значительно быстрее стандартного MSXML при освобождении памяти. В Сотни раз.

type
 TAppTemplateBuilderXml = class(TAbstractAppTemplateBuilder)
  private
    FXml:TXmlDocument;
    FLastProgress:Integer;
    FJsonItemCount:Integer;
    function CreateNode(const Owner:IXmlNode; const TagName, TagValue:string; TagType:Integer):IXmlNode;
    function FindNodeName(Node: TcxTreeListNode):string;
    procedure BuildNode(Node:TcxTreeListNode; const XmlNode:IXmlNode);
    procedure BuildNodeLevel(Node:TcxTreeListNode; const XmlNode:IXmlNode);
    procedure BuildDataSet(Node:TcxTreeListNode; const XmlNode:IXmlNode; const DataSetName:string);
    procedure BuildGroup(Node:TcxTreeListNode; const XmlNode:IXmlNode);
    procedure BuildNodeByDataSet(Node:TcxTreeListNode; const XmlNode:IXmlNode; const DataSetName:string);
    procedure Build;
    procedure SaveAsFile(const FileName:string);
    procedure CalculateProgress(Current, Total:Integer; const DataSetName:string);
    procedure FormatXml(const FileName:string);
  public
    procedure Execute; override;
    constructor Create; override;
 end;

implementation

{ TAppTemplateBuilderXml }

procedure TAppTemplateBuilderXml.Build;
begin
 FJsonItemCount:=0;
 FLastProgress:=0;
 FXml.Active:=True;
 if Assigned(Grid.TopNode) then
  BuildNodeLevel(Grid.TopNode, Fxml.Node);
end;

procedure TAppTemplateBuilderXml.BuildDataSet(Node: TcxTreeListNode;  const XmlNode: IXmlNode; const DataSetName: string);
var
 IsActive:Boolean;
begin
 FLastProgress:=0;
 IsActive:=Node.Values[ZActive];
 if IsActive then
  begin
   CheckAlreadyProcessing(DataSetName);
   BuildNodeByDataSet(Node, XmlNode,DataSetName);
  end;
end;

procedure TAppTemplateBuilderXml.BuildGroup(Node: TcxTreeListNode;  const XmlNode: IXmlNode);
var
 x:Integer;
 IsActive:Boolean;
begin
 IsActive:=Node.Values[ZActive];
 if IsActive then
  for x:=0 to Node.Count-1 do
   BuildNodeLevel(Node.Items[x],XmlNode);
end;

procedure TAppTemplateBuilderXml.BuildNode(Node: TcxTreeListNode; const XmlNode:IXmlNode);
var
 x:Integer;
 NodeValue:string;
 NodeName:string;
 ANode:IXmlNode;
const
 ErrorInfo= '%s'#13'AppTemplateDataID:%s'#13'NodeName:"%s"'#13'NodeValue:"%s"';
begin
 NodeValue:=FindNodeValue(Node);
 if NeedToCreateNode(Node,NodeValue) and Assigned(XmlNode) then
  begin
   try
    NodeName:=FindNodeName(Node);
    ANode:=CreateNode(XmlNode,NodeName,NodeValue, Node.Values[zTagType]);
    if (Node.HasChildren) then
     for x:=0 to Node.Count-1 do
      BuildNodeLevel(Node.Items[x], ANode);
   except on E:Exception do
    raise Exception.CreateFmt(ErrorInfo,[E.Message, VarToStr(Node.Values[ZAppTemplatesDataId]),NodeName,NodeValue]);
   end;
  end;
end;

procedure TAppTemplateBuilderXml.BuildNodeByDataSet(Node: TcxTreeListNode; const XmlNode: IXmlNode; const DataSetName: string);
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
       BuildNodeLevel(Node.Items[x],XmlNode);

      DataSet.Next;
      Inc(Current);
     end;
 finally
  ProcessingDataSets.Delete(AIndex);
 end;
end;

procedure TAppTemplateBuilderXml.BuildNodeLevel(Node: TcxTreeListNode;const XmlNode: IXmlNode);
var
 TagType:Integer;
begin
 TagType:=Node.Values[ZTagType];
  case TagType of
   TagTypeListThroughDataSet:BuildDataSet(Node,XmlNode,VarToStr(Node.Values[ZDataSetName]));
   TagTypeGroup:BuildGroup(Node, XmlNode);
   TagTypeJsonItem : BuildNode(Node,XmlNode);
   TagTypeNameValue: BuildNode(Node,XmlNode);
   TagTypeAttrib: BuildNode(Node,XmlNode)
    else
     raise Exception.Create('Unknown tag type');
  end;
end;

function TAppTemplateBuilderXml.CreateNode(const Owner: IXmlNode; const TagName, TagValue:string; TagType:Integer):IXmlNode;
var
 ATagName:string;
begin
 ATagName:= TagName.Replace(' ','',[rfReplaceAll]);
 if TagType=TagTypeAttrib then
   begin
    if not Assigned(Owner.AttributeNodes.FindNode(TagName)) then
     Owner.Attributes[ATagName]:=TagValue;
    Result:=Owner.AttributeNodes[ATagName];
   end
   else
  if TagType=TagTypeJsonItem then
   begin
    Result:=Owner.AddChild(ATagName,'');
    Result.Text:=TagValue;
    Inc(FJsonItemCount);
   end
   else
   begin
    Result:=Owner.AddChild(ATagName,'');
    Result.Text:=TagValue;
   end

end;


procedure TAppTemplateBuilderXml.CalculateProgress(Current, Total: Integer; const DataSetName:string);
begin
 if Current>=FLastProgress then
  begin
   FLastProgress:=FlastProgress+(Total div 231);
   SetProgress(string.Format(S_TEMPLATEBUILDER_PROGRESS_PROCESSING_DATASET_ROWS_FMT,[DataSetName, Current, Total]));
  end;
end;

constructor TAppTemplateBuilderXml.Create;
begin
 inherited Create;
 FXml:=TXmlDocument.Create(Self);
 FXml.DOMVendor:=DOMVendors.Find(sOmniXmlVendor);
 FXml.Options := [doNodeAutoIndent];
end;


procedure TAppTemplateBuilderXml.Execute;
begin
 inherited;
 Load;
 QuickCheckNode(Grid.TopNode);
 Build;
 SaveAsFile(Self.FileName);
end;


function TAppTemplateBuilderXml.FindNodeName(Node: TcxTreeListNode): string;
var
 TagType:Integer;
 AName:string;
begin
 TagType:=Node.Values[ZTagType];
 if (TagType=TagTypeJsonItem) then
  begin
   AName:=VarToStr(Node.Values[ZFormat]);
   if AName.Trim.IsEmpty then
    AName:='Item';
   Result:=AName;
  end
  else
 Result:=VarToStr(Node.Values[zTagName]);
end;

procedure TAppTemplateBuilderXml.FormatXml(const FileName:string);
var
 oXml : iXMLDocument;
begin
 oXml := TXMLDocument.Create(nil);
 try
  SetProgress(S_TEMPLATEBUILDER_PROGRESS_FORMATING_DATA);
//oXml.DOMVendor:=DOMVendors.Find(sOmniXmlVendor);
  oXml.LoadFromFile(FileName);
  oXml.XML.Text:=Xml.XmlDoc.FormatXMLData(oXml.XML.Text);
  oXml.Active := true;
  oXml.SaveToFile(FileName);
 finally
//     oXml.Free;
 end;
end;

procedure TAppTemplateBuilderXml.SaveAsFile(const FileName: string);
begin
 if not Stopped then
  begin
   SetProgress(string.Format(S_TEMPLATEBUILDER_PROGRESS_SAVING_DATA_TO_FMT,[FileName]));
   FXml.SaveToFile(FileName);
   if FormatAfterCreate then
    FormatXml(FileName);
  end;
end;


end.
