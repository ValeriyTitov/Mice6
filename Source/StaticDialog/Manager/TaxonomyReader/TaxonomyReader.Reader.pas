unit TaxonomyReader.Reader;

interface
 uses
  System.SysUtils, System.Classes, Xml.xmldom, Xml.XMLIntf,
  Xml.XMLDoc,System.Generics.Collections, System.Generics.Defaults,
  Dialogs, Xml.omnixmldom, WinApi.Windows,
  TaxonomyReader.URIResolver,
  TaxonomyReader.XmlHelper,
  Taxonomy.XBRL.ObjectModel,
  TaxonomyRader.XBRL.DefinitionLinkbase;

type
 TTaxononmyReader = class(TComponent)
   private
    FDocumentList: TObjectDictionary<string,TXMLDocument>;
    FDocument:TXMLDocument;
    FResolver: TURIResolver;
    FTaxonomySchema:TTaxonomySchema;
    FElementList:TElementList;
    FRaisingException:Boolean;
    FLines: TStrings;
    procedure SetResolver(const Value: TURIResolver);
    procedure ImportSchemas(const Node:IXmlNode; const AFileName:string);
    procedure ImportXsd(const Node:IXmlNode; const AFileName:string);
    procedure ReadAnnotation(const Node:IXmlNode; const AFileName:string);
    procedure InspectNode(const Node:IXmlNode; const AFileName:string);
    procedure HandleException(const Msg, FileName:string);
    procedure ShowInfo;
    procedure SetTaxonomyPath(const Value: string);
    function GetTaxonomyPath: string;
   public
    procedure LoadDocument(const AFileName:String); overload;
    procedure LoadDocument(const RootNode:IXmlNode); overload;
    property Resolver:TURIResolver read FResolver write SetResolver;
    property TaxonomySchema:TTaxonomySchema read  FTaxonomySchema;
    property ElementList:TElementList read FElementList;
    property Lines:TStrings read FLines write FLines;
    property TaxonomyPath:string read GetTaxonomyPath write SetTaxonomyPath;
    procedure DebugStr(const s:String);
    constructor Create(AOwner:TComponent); override;
    destructor Destroy; override;
   end;
implementation

{ TTaxononmyReader }


constructor TTaxononmyReader.Create(AOwner:TComponent);
begin
 inherited;
 FDocument:=TXMLDocument.Create(Self);
 FDocument.DOMVendor:=DOMVendors.Find(sOmniXmlVendor);
 FResolver:=TURIResolver.Create;
 FDocumentList:=TObjectDictionary<string,TXMLDocument>.Create([doOwnsValues],TIStringComparer.Ordinal);
 FTaxonomySchema:=TTaxonomySchema.Create;
 FElementList:=TElementList.Create;
end;

procedure TTaxononmyReader.DebugStr(const s: String);
begin
 if Assigned(Lines) then
  Lines.Add(s);
end;

destructor TTaxononmyReader.Destroy;
begin
  FDocumentList.Free;
  FResolver.Free;
  FDocument.Free;
  FTaxonomySchema.Free;
  FElementList.Free;
  inherited;
end;


function TTaxononmyReader.GetTaxonomyPath: string;
begin
 Result:=Self.Resolver.TaxonomyPath;
end;

procedure TTaxononmyReader.HandleException(const Msg, FileName: string);
begin
if (FRaisingException=False) then
 begin
  FRaisingException:=True;
  raise Exception.Create(Msg+#13+FileName);
 end
  else
  raise Exception.Create(Msg);
end;

procedure TTaxononmyReader.ReadAnnotation(const Node: IXmlNode;const AFileName:string);
var
 ANode:IXmlNode;
 LinkBaseRef: TLinkbaseRef;
 Xml:TXmlDocument;
begin
 ANode:=TXmlHelper.SelectNode(Node,'appinfo');
 if Assigned(ANode) then
   FTaxonomySchema.LoadFromNode(ANode);

 for LinkBaseRef in FTaxonomySchema.LinkBaseRefList do
  begin
   if FDocumentList.ContainsKey(LinkBaseRef.Href)=False then
    begin
     Xml:=TXmlDocument.Create(Self);
     Xml.DOMVendor:=DOMVendors.Find(sOmniXmlVendor);
     FDocumentList.Add(LinkBaseRef.Href,Xml);
     try
      Xml.FileName:=Resolver.Resolve(AFileName,LinkBaseRef.Href);
      Xml.Active:=True;
      DebugStr('Rading annotation: '+Xml.FileName);
      FTaxonomySchema.LoadDefinitionLinks(Xml.Node);
     except on E:Exception do
      HandleException(e.Message, Xml.FileName);
     end;

    end;

  end;
end;

procedure TTaxononmyReader.ImportSchemas(const Node: IXmlNode;const AFileName:string);
var
 x:Integer;
 ANode:IXmlNode;
begin
{
There are five different kinds of linkbase documents (each kind is discussed later on):
Definition
Calculation
Presentation
Label
Reference
}
 for x:=0 to Node.ChildNodes.Count-1 do
  begin
   ANode:=Node.ChildNodes[x];
   if ANode.LocalName='import' then
    ImportXsd(ANode, AFileName) else
   if ANode.LocalName='annotation' then
    ReadAnnotation(ANode, AFileName);
   if ANode.LocalName='element' then
     FElementList.LoadFromNode(ANode,ExtractFileName(AFileName));
  end;
end;

procedure TTaxononmyReader.ImportXsd(const Node: IXmlNode; const AFileName:string);
var
 APath:string;
 ANameSpace:string;
 Xml:TXmlDocument;
begin
 APath:=Resolver.Resolve(AFileName, Node.Attributes['schemaLocation']);
 ANameSpace:=Node.Attributes['namespace'];
 if (FDocumentList.ContainsKey(ANameSpace)=False) and (APath.EndsWith('cbr-coa.xsd')=False) then
    begin
     Xml:=TXmlDocument.Create(Self);
     FDocumentList.Add(ANameSpace,Xml);
     try
      Xml.FileName:=APath;
      Xml.Active:=True;
      DebugStr('Loading: '+APath+'...OK');
      InspectNode(Xml.Node, Xml.FileName);
     except on E:Exception do
       HandleException(E.Message, APath);
     end;
    end;
end;

procedure TTaxononmyReader.InspectNode(const Node: IXmlNode; const AFileName:string);
var
 x:Integer;
 ANode:IXmlNode;
begin
 for x:=0 to Node.ChildNodes.Count-1 do
  begin
   ANode:=Node.ChildNodes[x];
   if ANode.LocalName='schema' then
    ImportSchemas(Node.ChildNodes[x], AFileName)
  end;
end;

procedure TTaxononmyReader.LoadDocument(const AFileName: String);
begin
  FDocument.FileName:=AFileName;
  FDocument.Active:=True;
  LoadDocument(FDocument.Node);
end;

procedure TTaxononmyReader.LoadDocument(const RootNode:IXmlNode);
begin
 FRaisingException:=False;
// Ticks:=GetTickCount;
 InspectNode(RootNode, FDocument.FileName);
 ShowInfo;
end;



procedure TTaxononmyReader.SetResolver(const Value: TURIResolver);
begin
 if FResolver<>Value then
 begin
  FreeAndNil(FResolver);
  FResolver := Value;
 end;
end;

procedure TTaxononmyReader.SetTaxonomyPath(const Value: string);
begin
 Resolver.TaxonomyPath:=Value;
end;

procedure TTaxononmyReader.ShowInfo;
begin
// DebugStr('Time: '+(GetTickCount-Ticks).ToString);
 DebugStr('Concept count: '+FElementList.Count.ToString);
 DebugStr('Label count: '+FTaxonomySchema.LabelLinks.LabelsList.Count.ToString);
 DebugStr('DefinitionLinks count:'+FTaxonomySchema.DefinitionLinks.Count.ToString);

 DebugStr('');
{
 Lines.BeginUpdate;
 for DefLink in FTaxonomySchema.DefinitionLinks do
  begin
   if (FTaxonomySchema.RoleByUri(DefLink.Role).UsedOnPresentation) then
    begin
     DebugStr('-'+FTaxonomySchema.RoleByUri(DefLink.Role).Definition);
      for DefArc in DefLink.DefinitionArcs do
       begin
        Elem:=FElementList.ElementByName(DefArc.ToID);
        if Assigned(Elem) then
         ALabel:=Self.FTaxonomySchema.LabelLinks.FindLabelForFact(Elem.Href, Elem.Id)
          else
         ALabel:='Метка не найдена';
        DebugStr(DefArc.ToID +' ('+ALabel+')');
       end;

    end;
  end;
 Lines.EndUpdate;
 }


end;

end.
