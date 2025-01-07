unit TaxonomyReader.XlinkNode;

interface
 uses System.Classes, System.SysUtils, Xml.xmldom, Xml.XMLIntf,
  Xml.XMLDoc,System.Generics.Collections, System.Generics.Defaults,
  System.Variants;

type
  TLocator = class
  strict private
    FHref: string;
    FALabel: string;
  public
    property Href:string read FHref write FHref;
    property ALabel:string read FALabel write FALabel;
    procedure LoadFromNode(const Node: IXmlNode);
    constructor Create(const Node:IXmlNode); overload;
    constructor Create; overload;
 end;

 TXlinkNode = class

 end;

implementation




{ TLocator }

constructor TLocator.Create(const Node: IXmlNode);
begin
 LoadFromNode(Node);
end;

constructor TLocator.Create;
begin

end;

procedure TLocator.LoadFromNode(const Node: IXmlNode);
begin
 if Node.HasAttribute('xlink:href') then
  Href:=Node.Attributes['xlink:href'];

 if Node.HasAttribute('xlink:label') then
  ALabel:=Node.Attributes['xlink:label'];

end;

end.
