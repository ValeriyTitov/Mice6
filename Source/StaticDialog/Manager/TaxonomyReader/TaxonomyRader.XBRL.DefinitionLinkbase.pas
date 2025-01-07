unit TaxonomyRader.XBRL.DefinitionLinkbase;

interface

uses
  System.SysUtils, System.Classes, Xml.xmldom, Xml.XMLIntf,
  Xml.XMLDoc,System.Generics.Collections, System.Generics.Defaults,
  System.Variants,
  Dialogs,
  TaxonomyReader.XmlHelper, System.DateUtils;


type

XlinkType =  (Unknown, Simple, Extended, Locator,  Arc, Resource, Title);


 TLocator = class
  strict private
    FHref: string;
    FALabel: string;
  public
    property Href:string read FHref write FHref;
    property ALabel:string read FALabel write FALabel;
    constructor Create(const Node:IXmlNode);
 end;

 TDefinitionArc = class
  strict private
    FTitle: string;
    FToID: string;
    FArcRole: string;
    FFromID: string;
    FOrder: string;
    FFromLocator: TLocator;
    FToLocator: TLocator;
    FAType: XlinkType;
   public
    class function FindXlinkType(const AText:string):XLinkType;
    property AType:XlinkType read FAType write FAType;
    property ArcRole:string read FArcRole write FArcRole;
    property FromID:string read FFromID write FFromID;
    property ToID:string read FToID write FToID;
    property Title:string read FTitle write FTitle;
    property Order: string read FOrder write FOrder;
    property FromLocator:TLocator read FFromLocator write FFromLocator;
    property ToLocator:TLocator read FToLocator write FToLocator;
    procedure LoadFromNode(const Node:IXmlNode);
    constructor Create(const Node:IXmlNode);
    destructor Destroy; override;
 end;

 TDefinitionLink = class
  strict private
    FRole: string;
    FLocators:TObjectList<TLocator>;
    FDefinitionArcs: TObjectList<TDefinitionArc>;
    FAType: XLinkType;
  public
    property AType:XLinkType read FAType write FAType;
    property Role:string read FRole write FRole;
    property DefinitionArcs: TObjectList<TDefinitionArc> read FDefinitionArcs;
    function FindLocator(const ALabel:string):TLocator;
    procedure LoadFormNode(const Node:IXmlNode);
    constructor Create; overload;
    constructor Create(const Node:IXmlNode); overload;
    destructor Destroy; override;
 end;


 TDefinitionLinkList = class(TObjectList<TDefinitionLink>)
 private
  FDict: TDictionary<string, TDefinitionLink>;
 public
  procedure LoadFromNode(const Node:IXmlNode);
  function ContainsDefinitionLink(const Name:string):Boolean;
  function DefinitionLinkByName(const Name:string):TDefinitionLink;
  constructor Create;
  destructor Destroy; override;
 end;

 TLabel = class
  strict private
    FAType: string;
    FRole: string;
    FID: string;
    FALabel: string;
    FLang: string;
    FCaption: string;
    FTitle: string;
  public
    property AType:string read FAType write FAType;
    property ALabel: string read FALabel write FALabel;
    property Role:string read FRole write FRole;
    property Lang:string read FLang write FLang;
    property ID:string read FID write FID;
    property Title:string read FTitle write FTitle;
    property Caption:string read FCaption write FCaption;
    procedure LoadFromNode(const Node:IXmlNode);
    constructor Create(const Node:IXmlNode);
 end;

 TLabelArc = class
  strict private
    FAType: string;
    FToID: string;
    FFromID: string;
    FTitle: string;
    FArcRole: string;
    function GetALabel: TLabel;
  public
    property AType:string read FAType write FAType;
    property ArcRole:string read FArcRole write FArcRole;
    property FromID:string read FFromID write FFromID;
    property ToID:string read FToID write FToID;
    property Title:string read FTitle write FTitle;
    property ALabel:TLabel read GetALabel;
    procedure LoadFromNode(const Node:IXmlNode);
    constructor Create(const Node:IXmlNode);
  end;

 TLabelLinkList = class(TObjectList<TLocator>)
 strict private
  FLabelArcList:TObjectList<TLabelArc>;
  FLocatorsList:TObjectList<TLocator>;
  FLabelsList:TObjectList<TLabel>;

  FLabelArcDict: TObjectDictionary<string,TLabelArc>;
  FLabelsDict:TObjectDictionary<string,TLabel>;
  FLocatorsDict: TObjectDictionary<string,TLocator>;

  procedure AssignLocators;
  procedure AddLabel(const Node: IXmlNode);
  procedure AddLabelArc(const Node: IXmlNode);
  procedure AddLocator(const Node: IXmlNode);
 public
  property LabelsList:TObjectList<TLabel> read FLabelsList;
  constructor Create;
  destructor Destroy; override;
  procedure LoadFromNode(const Node:IXmlNode);
  function FindLabelForFact(const HRef, ID:string):string;
 end;

implementation

{ TLocator }

constructor TLocator.Create(const Node: IXmlNode);
begin
 inherited Create;
 if Node.HasAttribute('xlink:href') then
  Href:=Node.Attributes['xlink:href'];

 if Node.HasAttribute('xlink:label') then
  ALabel:=Node.Attributes['xlink:label'];
end;

{ TDefinitionArc }

constructor TDefinitionArc.Create(const Node: IXmlNode);
begin
 LoadFromNode((Node));
end;



destructor TDefinitionArc.Destroy;
begin
  inherited;
end;


class function TDefinitionArc.FindXlinkType(const AText: string): XLinkType;
begin
 if AText.IsEmpty then
  Result:= XlinkType.Simple
   else

 if AText='simple' then
  Result:=XlinkType.Simple
   else

 if AText='extended' then
  Result:=XlinkType.Extended
   else

 if AText='locator' then
  Result:=XlinkType.Locator
   else

 if AText='arc' then
  Result:=XlinkType.Arc
   else

 if AText='resource' then
  Result:=XlinkType.Resource
    else

 if AText='title' then
  Result:=XlinkType.Title

   else
  Result:=XlinkType.Unknown;
end;


procedure TDefinitionArc.LoadFromNode(const Node: IXmlNode);
begin
 if Node.HasAttribute('xlink:arcrole') then
  ArcRole:=Node.Attributes['xlink:arcrole'];

 if Node.HasAttribute('xlink:from') then
  FromID:=Node.Attributes['xlink:from'];

 if Node.HasAttribute('xlink:to') then
  ToID:=Node.Attributes['xlink:to'];

 if Node.HasAttribute('xlink:title') then
  Title:=Node.Attributes['xlink:title'];

 if Node.HasAttribute('order') then
  Order:=Node.Attributes['order'];

 if Node.HasAttribute('xlink:type') then
  AType:=FindXlinkType(Node.Attributes['xlink:type']);

end;

{ TDefinitionLink }

constructor TDefinitionLink.Create(const Node: IXmlNode);
begin
  Create;
  LoadFormNode(Node);
end;

destructor TDefinitionLink.Destroy;
begin
  FLocators.Free;
  FDefinitionArcs.Free;
  inherited;
end;

function TDefinitionLink.FindLocator(const ALabel: string): TLocator;
var
 Locator:TLocator;
begin
 for Locator in FLocators do
  if (Locator.ALabel=ALabel) then
   Exit(Locator);

 Result:=nil;
end;


procedure TDefinitionLink.LoadFormNode(const Node: IXmlNode);
var
 x:Integer;
 ANode:IXmlNode;
 DefinitionArc:TDefinitionArc;
begin
 if Node.HasAttribute('xlink:role') then
   Role:=Node.Attributes['xlink:role'];

 if Node.HasAttribute('xlink:type') then
   AType:=TDefinitionArc.FindXlinkType(Node.Attributes['xlink:type']);

 for x:=0 to Node.ChildNodes.Count-1 do
  begin
   ANode:=Node.ChildNodes[x];
   if ANode.LocalName='loc' then
    FLocators.Add(TLocator.Create(ANode))    else

   if ANode.LocalName='definitionArc' then
    begin
     DefinitionArc:=TDefinitionArc.Create(ANode);
     DefinitionArc.FromLocator:=FindLocator(DefinitionArc.FromID);
     DefinitionArc.ToLocator:=FindLocator(DefinitionArc.ToID);
     FDefinitionArcs.Add(DefinitionArc);
    end;
  end;

end;

constructor TDefinitionLink.Create;
begin
 FLocators:=TObjectList<TLocator>.Create;
 FDefinitionArcs:=TObjectList<TDefinitionArc>.Create;
end;


{ TDefinitionLinkList }

function TDefinitionLinkList.DefinitionLinkByName(const Name: string): TDefinitionLink;
begin
 Result:=FDict[Name];
end;

destructor TDefinitionLinkList.Destroy;
begin
  FDict.Free;
  inherited;
end;

procedure TDefinitionLinkList.LoadFromNode(const Node: IXmlNode);
var
 Key:string;
 Link:TDefinitionLink;
begin
 Link:=TDefinitionLink.Create(Node);
 Add(Link);

 Key:=Node.Attributes['xlink:role'];
 if not FDict.ContainsKey(Key) then
  FDict.Add(Key,Link);
end;

function TDefinitionLinkList.ContainsDefinitionLink(const Name: string): Boolean;
begin
 Result:=FDict.ContainsKey(Name);
end;

constructor TDefinitionLinkList.Create;
begin
 inherited Create;
 FDict:=TDictionary<string, TDefinitionLink>.Create;
end;

{ TLabel }

constructor TLabel.Create(const Node: IXmlNode);
begin
 inherited Create;
 LoadFromNode(Node);
end;

procedure TLabel.LoadFromNode(const Node: IXmlNode);
begin
 if Node.HasAttribute('xlink:type') then
   AType:=Node.Attributes['xlink:type'];

 if Node.HasAttribute('xlink:label') then
  ALabel:=Node.Attributes['xlink:label'];

 if Node.HasAttribute('xlink:role') then
 Role:=Node.Attributes['xlink:role'];

 if Node.HasAttribute('xlink:title') then
  Title:=Node.Attributes['xlink:title'];

 if Node.HasAttribute('xml:lang') then
  Lang:=Node.Attributes['xml:lang'];

 if not VarIsNull(Node.Text) then

  Caption:=Node.Text;

 if Node.HasAttribute('id') then
  ID:=Node.Attributes['id'];

end;


{ TLabelArc }

constructor TLabelArc.Create(const Node: IXmlNode);
begin
 inherited Create;
 LoadFromNode(Node);
end;

function TLabelArc.GetALabel: TLabel;
begin
 Result:=nil;
end;

procedure TLabelArc.LoadFromNode(const Node: IXmlNode);
begin
if Node.HasAttribute('xlink:type') then
   AType:=Node.Attributes['xlink:type'];

 if Node.HasAttribute('xlink:arcrole') then
 ArcRole:=Node.Attributes['xlink:arcrole'];

 if Node.HasAttribute('xlink:title') then
  Title:=Node.Attributes['xlink:title'];

 if Node.HasAttribute('xlink:to') then
  ToID:=Node.Attributes['xlink:to'];

 if Node.HasAttribute('xlink:from') then
  FromID:=Node.Attributes['xlink:from'];
end;

{ TLabelLinkList }

procedure TLabelLinkList.AddLabel(const Node: IXmlNode);
var
 ALabel:TLabel;
 AKey:string;
begin
 ALabel:=TLabel.Create(Node);
 FLabelsList.Add(ALabel);
 AKey:=ALabel.ID;
 if not FLabelsDict.ContainsKey(AKey) then
  FLabelsDict.Add(AKey, ALabel);
end;

procedure TLabelLinkList.AddLabelArc(const Node: IXmlNode);
var
 LabelArc:TLabelArc;
 AKey:string;
begin
 LabelArc:=TLabelArc.Create(Node);
 FLabelArcList.Add(LabelArc);
 AKey:=LabelArc.FromID;
 if not FLabelArcDict.ContainsKey(AKey) then
     FLabelArcDict.Add(AKey, LabelArc);
end;

procedure TLabelLinkList.AddLocator(const Node: IXmlNode);
var
 Locator:TLocator;
 AKey:string;
begin
 Locator:=TLocator.Create(Node);
 FLocatorsList.Add(Locator);
 AKey:=Locator.Href;
 if not FLocatorsDict.ContainsKey(AKey) then
   FLocatorsDict.Add(AKey, Locator);
end;

procedure TLabelLinkList.AssignLocators;
begin
end;

constructor TLabelLinkList.Create;
begin
 inherited Create(True);
 FLabelArcList:=TObjectList<TLabelArc>.Create;
 FLocatorsList:=TObjectList<TLocator>.Create;
 FLabelsList:=TObjectList<TLabel>.Create;

 FLabelArcDict:=TObjectDictionary<string,TLabelArc>.Create;
 FLabelsDict:=TObjectDictionary<string,TLabel>.Create;;
 FLocatorsDict:=TObjectDictionary<string,TLocator>.Create;;
end;


destructor TLabelLinkList.Destroy;
begin
  FLabelArcDict.Free;
  FLabelsDict.Free;
  FLocatorsDict.Free;

  FLabelsList.Free;
  FLocatorsList.Free;
  FLabelArcList.Free;
  inherited;
end;


function TLabelLinkList.FindLabelForFact(const HRef, ID: string): string;
var
 AKey:string;
begin
 Result:='';
 AKey:=HRef+'#'+ID;
 if FLocatorsDict.ContainsKey(AKey) then
  begin
   AKey:=FLocatorsDict[AKey].ALabel;
    if FLabelArcDict.ContainsKey(AKey) then
     begin
       AKey:=FLabelArcDict[AKey].ToID;
       if FLabelsDict.ContainsKey(AKey) then
        Result:=FLabelsDict[AKey].Caption;
     end;
  end;
end;

procedure TLabelLinkList.LoadFromNode(const Node: IXmlNode);
var
 x:Integer;
 ANode:IXmlNode;
begin
 for x:=0 to Node.ChildNodes.Count-1 do
   begin
     ANode:=Node.ChildNodes[x];
     if ANode.LocalName='loc' then
      AddLocator(ANode)
      else
     if ANode.LocalName='label' then
      AddLabel(ANode)
       else
     if ANode.LocalName='labelArc' then
      AddLabelArc(ANode);
   end;
  AssignLocators;
end;

end.
