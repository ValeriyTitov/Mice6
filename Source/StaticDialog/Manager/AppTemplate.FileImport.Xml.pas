unit AppTemplate.FileImport.Xml;

interface
uses
 System.Classes, System.SysUtils, System.Variants,
 Xml.xmldom, Xml.XMLIntf, Xml.XMLDoc, msxmldom,
 AppTemplate.FileImport,
 Common.StringUtils;


type
 TXmlTemplateImport = class(TAbstractTemplateImport)
  private
    procedure ImportAttribute(ParentId:Variant; Node:IXmlNode);
    procedure ImportNode(const ParentId:Variant; const Node:IXmlNode);
   public
    procedure Import; override;
  end;


implementation

procedure TXmlTemplateImport.Import;
var
 FXml:TXmlDocument;
begin
 FXml:=TXmlDocument.Create(Self);
   try
    FXml.LoadFromFile(FileName);
    ImportNode(RootParentId,FXml.Node);
   finally
    FXml.Free;
   end;
end;

procedure TXmlTemplateImport.ImportAttribute(ParentId: Variant;  Node: IXmlNode);
begin
 CreateNewItem(NewID, ParentId, TagTypeXmlAttrib,Node.NodeName, Node.Text, ValueTypeJsonString);
end;

procedure TXmlTemplateImport.ImportNode(const ParentId: Variant;  const Node: IXmlNode);
var
 x:Integer;
 ID:Integer;
 ValueType:Integer;
begin
ID:=NewID;
 if (TStringUtils.SameString(Node.NodeName,'#text')=False) then
 begin
  if (Node.HasChildNodes) or (Node.AttributeNodes.Count>0) then
   ValueType:=ValueTypeJsonXmlTag
    else
   ValueType:=ValueTypeJsonString;

    case Node.NodeType of
     ntText:CreateNewItem(ID, ParentId, TagTypeNameValue,Node.NodeName, Node.Text, ValueType);
     ntElement: if Node.IsTextElement then
                 CreateNewItem(ID, ParentId, TagTypeNameValue,Node.NodeName, VarToStr(Node.NodeValue), ValueType)
                  else
                 CreateNewItem(ID, ParentId, TagTypeNameValue,Node.NodeName, '', ValueType);
    end;
 end;

 if Node.NodeType<> ntProcessingInstr then //skip "Version" and "Encoding" attributes
  begin
  if (Node.NodeType=ntDocument) and (VarIsNull(ParentId)=False) then
   ID:=ParentId;
   if Node.AttributeNodes.Count>0 then
    for x:=0 to Node.AttributeNodes.Count-1 do
     ImportAttribute(ID,Node.AttributeNodes[x]);

   if Node.HasChildNodes then
    for x:=0 to Node.ChildNodes.Count-1 do
     if (TStringUtils.SameString(Node.ChildNodes[x].NodeName,'#text')=False) then
      ImportNode(ID,Node.ChildNodes[x]);
  end;
end;



end.
