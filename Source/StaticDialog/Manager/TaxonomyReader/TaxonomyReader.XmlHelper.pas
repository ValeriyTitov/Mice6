unit TaxonomyReader.XmlHelper;

interface
 uses System.SysUtils, System.Classes, Xml.xmldom, Xml.XMLIntf,
  Xml.XMLDoc,System.Generics.Collections, System.Generics.Defaults,
  System.Variants,
  TaxonomyReader.URIResolver;

  type
   TXmlEvent = procedure (const Node:IXmlNode) of object;
   TXmlHelper = class
     class function SelectNode(const Root: IXmlNode; const Path: string): IXmlNode;
     class function NodeToString(const Node:IXmlNode):string;
     class procedure ForEeach(const Node:IXmlNode; Event:TXmlEvent);
     class procedure LoadValuesToList(const Node:IXmlNode; List:TStrings; const NodeLocalName:string);
//     class procedure SelectNodeList(const Root: IXmlNode; const Path: string);
   end;

implementation



{ TXmlHelper }

class procedure TXmlHelper.ForEeach(const Node: IXmlNode; Event:TXmlEvent);
var
 x:Integer;
begin
 for x:=0 to Node.ChildNodes.Count-1 do
  Event(Node.ChildNodes[x]);
end;

class procedure TXmlHelper.LoadValuesToList(const Node: IXmlNode;  List: TStrings; const NodeLocalName: string);
var
 x:Integer;
 ANode:IXmlNode;
begin
 for x:=0 to Node.ChildNodes.Count-1 do
    begin
     ANode:=Node.ChildNodes[x];
     if ANode.LocalName=NodeLocalName then
      List.Add(ANode.NodeValue)
    end;
end;

class function TXmlHelper.NodeToString(const Node: IXmlNode): string;
var
 x:Integer;
 Attribs:String;
begin
 Attribs:='';
 if Node.AttributeNodes.Count>10 then
  Attribs:='MORE THAN 10 ATTRIBS'
   else
 for x:=0 to Node.AttributeNodes.Count-1 do
  Attribs:=Attribs+Node.AttributeNodes[x].NodeName+':'+Node.AttributeNodes[x].NodeValue;

  Attribs:=Attribs.Trim;
  if not Attribs.IsEmpty then
   Attribs:='('+Attribs+')';

  if Node.NodeType<>ntElement then
   Result:=Node.NodeName+'='+VarToStr(Node.NodeValue) + Attribs
    else
   Result:=Node.NodeName+Attribs
end;

class function TXmlHelper.SelectNode(const Root: IXmlNode;  const Path: string): IXmlNode;
var
 List:TStringList;
 x:Integer;
 Node:IXmlNode;
begin
 Result:=nil;
 List:=TStringList.Create;
 try
  Node:=Root;
  List.StrictDelimiter:=True;
  List.Delimiter:='/';
  List.DelimitedText:=Path;
  for x:=0 to List.Count-1 do
   begin
     if not Assigned(Node) then
      Exit;
     Node:=Node.ChildNodes.FindNode(List[x],'');
   end;
  Result:=Node;
 finally
  List.Free;
 end;
end;


end.
