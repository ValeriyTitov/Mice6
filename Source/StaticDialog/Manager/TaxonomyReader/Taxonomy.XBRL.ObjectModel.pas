unit Taxonomy.XBRL.ObjectModel;

interface

uses System.SysUtils, System.Classes, Xml.xmldom, Xml.XMLIntf,
  Xml.XMLDoc,System.Generics.Collections, System.Generics.Defaults,
  Dialogs,
  TaxonomyReader.XmlHelper,
  TaxonomyRader.XBRL.DefinitionLinkbase;


type
  TElementSubstitutionGroup =(esgUnknown,esgItem, esgTuple, esgDimensionItem, esgHypercubeItem);
  TElementPeriodType= (epUnknown, epInstant, epDuration);

  TElement = class
  strict private
    FAType: string;
    FName: string;
    FIsAbstract: Boolean;
    FPeriodType: TElementPeriodType;
    FFromDate: TDateTime;
    FId: string;
    FNillable: Boolean;
    FSubstitutionGroup: TElementSubstitutionGroup;
    FCreationDate: TDateTime;
    FTypedDomainRef: string;
    FHref: string;
    FEnumLinkrole: string;
    FEnumDomain: string;
    procedure SetSubstitutionGroupAsString(const Value:string);
    procedure SetPeriodTypeAsString(const Value:string);
  public
    property Name:string read FName write FName;
    property Id:string read FId write FId;
    property AType:string read FAType write FAType;
    property CreationDate:TDateTime read FCreationDate write FCreationDate;
    property SubstitutionGroup:TElementSubstitutionGroup read FSubstitutionGroup write FSubstitutionGroup;
    property FromDate:TDateTime read FFromDate write FFromDate;
    property IsAbstract:Boolean read FIsAbstract write FIsAbstract;
    property Nillable:Boolean read FNillable write FNillable;
    property PeriodType: TElementPeriodType read FPeriodType write FPeriodType;
    property TypedDomainRef:string read FTypedDomainRef write FTypedDomainRef;
    property Href:string read FHref write FHref;
    property EnumDomain:string read FEnumDomain write FEnumDomain;
    property EnumLinkrole:string read FEnumLinkrole write FEnumLinkrole;
    procedure LoadFromNode(const Node:IXmlNode);
    constructor Create(const Node:IXmlNode); overload;
  end;



  TRoleType = class
  strict private
    FRoleUri: string;
    FId: string;
    FDefinition: string;
    FUsedOnList: TStringList;
    function GetUsedOnDefinition: Boolean;
    function GetUsedOnPresentation: Boolean;
    function GetUsedOnGen: Boolean;
  public
//        public XbrlSchema Schema { get; private set; }
    property RoleUri:string read FRoleUri;
    property Id: string read FId;
    property Definition:string read FDefinition;
    property UsedOnList:TStringList read FUsedOnList;
    property UsedOnPresentation:Boolean read GetUsedOnPresentation;
    property UsedOnDefinition:Boolean read GetUsedOnDefinition;
    property UsedOnGen:Boolean read GetUsedOnGen;
    function UsedOn(const LinkName:string):Boolean;

    constructor Create; overload;
    constructor Create(const Node:IXmlNode);overload;
    destructor Destroy; override;
  end;

  TLinkbaseRef = class
   strict private
    FAType: string;
    FHref: string;
    FArcRole: string;
    FRole: string;
   public
    property AType:string read FAType write FAType;
    property Href:string read FHref write FHref;
    property ArcRole:string read FArcRole write FArcRole;
    property Role:string read FRole write FRole;
    constructor Create; overload;
    constructor Create(const Node:IXmlNode); overload;
    destructor Destroy; override;
  end;

  TLinkBaseRefList = class (TObjectList<TLinkbaseRef>)
  end;

  TRoleTypeList = class (TObjectList<TRoleType>)
  end;


  TElementList = class (TObjectList<TElement>)
  private
   FElementDict:TObjectDictionary<string,TElement>;
  public
   procedure LoadFromNode(const Node:IXmlNode;const Href:string);
   function ElementByName(const Name:string):TElement;
   constructor Create; overload;
   destructor Destroy; override;
  end;

  TTaxonomySchema = class
  private
    FRoleTypeList: TRoleTypeList;
    FLinkBaseRefList: TLinkBaseRefList;
    FDefinitionLinks: TDefinitionLinkList;
    FLabelLinks: TLabelLinkList;
    FRoleTypeDict : TDictionary<string, TRoleType>;
  public
    property LinkBaseRefList:TLinkBaseRefList read FLinkBaseRefList;
    property RoleTypeList:TRoleTypeList read FRoleTypeList;
    property DefinitionLinks:TDefinitionLinkList read FDefinitionLinks;
    property LabelLinks: TLabelLinkList read FLabelLinks;
    procedure LoadFromNode(const Node:IXmlNode);
    procedure LoadDefinitionLinks(const Node:IXmlNode);
    function RoleByUri(const RoleUri:string):TRoleType;
    constructor Create;
    destructor Destroy; override;
  end;




implementation

{ TRoleType }
 var
 AFormatSetting:TFormatSettings;

constructor TRoleType.Create(const Node: IXmlNode);
var
 ANode:IXmlNode;
begin
 Create;
 FId:=Node.Attributes['id'];
 FRoleUri:=Node.Attributes['roleURI'];
 ANode:=TXmlHelper.SelectNode(Node,'definition');
 if Assigned(ANode) then
  FDefinition:=ANode.NodeValue;

 TXmlHelper.LoadValuesToList(Node,UsedOnList,'usedOn');
end;

destructor TRoleType.Destroy;
begin
  FUsedOnList.Free;
  inherited;
end;

function TRoleType.GetUsedOnDefinition: Boolean;
begin
 Result:=UsedOn('link:definitionLink');
end;

function TRoleType.GetUsedOnGen: Boolean;
begin
  Result:=UsedOn('gen:link');
end;

function TRoleType.GetUsedOnPresentation: Boolean;
begin
 Result:=UsedOn('link:presentationLink');
end;

function TRoleType.UsedOn(const LinkName: string): Boolean;
begin
 Result:=FUsedOnList.IndexOf(LinkName)>=0;
end;

constructor TRoleType.Create;
begin
 FUsedOnList:=TStringList.Create;
end;


{ TLinkbaseRef }

constructor TLinkbaseRef.Create;
begin

end;

constructor TLinkbaseRef.Create(const Node: IXmlNode);
begin
 AType:=Node.Attributes['xlink:type'];
 Href:=Node.Attributes['xlink:href'];
 if Node.HasAttribute('xlink:arcrole') then
  ArcRole:=Node.Attributes['xlink:arcrole'];

 if Node.HasAttribute('xlink:role') then
  Role:=Node.Attributes['xlink:role'];
end;

destructor TLinkbaseRef.Destroy;
begin

  inherited;
end;

{ TRoleTypeList }


{ TTaxonomySchema }

constructor TTaxonomySchema.Create;
begin
 FLinkBaseRefList:=TLinkBaseRefList.Create;
 FRoleTypeList:=TRoleTypeList.Create;
 FDefinitionLinks:=TDefinitionLinkList.Create;
 FLabelLinks:=TLabelLinkList.Create;
 FRoleTypeDict:= TDictionary<string, TRoleType>.Create();
end;

destructor TTaxonomySchema.Destroy;
begin
  FRoleTypeDict.Free;
  FDefinitionLinks.Free;
  FLinkBaseRefList.Free;
  FRoleTypeList.Free;
  FLabelLinks.Free;
  inherited;
end;



procedure TTaxonomySchema.LoadDefinitionLinks(const Node: IXmlNode);
var
 x:Integer;
 LinkNode:IXmlNode;
 ANode:IXmlNode;
begin
 LinkNode:=TXmlHelper.SelectNode(Node, 'linkbase');
 if Assigned(LinkNode) then
   for x:=0 to LinkNode.ChildNodes.Count-1 do
     begin
       ANode:=LinkNode.ChildNodes[x];
       if ANode.LocalName='roleRef' then
        else
       if ANode.LocalName='arcroleRef' then
        else
       if ANode.LocalName='definitionLink' then
        DefinitionLinks.LoadFromNode(ANode)
        else
       if ANode.LocalName='labelLink' then
         LabelLinks.LoadFromNode(ANode);
     end;

end;

procedure TTaxonomySchema.LoadFromNode(const Node: IXmlNode);
var
 x:Integer;
 ANode:IXmlNode;
 RoleType:TRoleType;
begin
 for x:=0 to Node.ChildNodes.Count-1 do
  begin
   ANode:=Node.ChildNodes[x];
   if ANode.LocalName='linkbaseRef' then
      LinkBaseRefList.Add(TLinkbaseRef.Create(ANode)) else
   if ANode.LocalName='roleType' then
    begin
     RoleType:=TRoleType.Create(ANode);
     RoleTypeList.Add(RoleType);
     if FRoleTypeDict.ContainsKey(RoleType.RoleUri)=False then
      FRoleTypeDict.Add(RoleType.RoleUri, RoleType);
    end;
  end;
end;



function TTaxonomySchema.RoleByUri(const RoleUri: string): TRoleType;
begin
 Result:=FRoleTypeDict[RoleUri];
end;

{ TElement }

constructor TElement.Create(const Node: IXmlNode);
begin
 inherited Create;
 LoadFromNode(Node);
end;

procedure TElement.LoadFromNode(const Node: IXmlNode);
var
 CreationDateStr:string;
 FromDateStr:string;
begin
 if Node.HasAttribute('name') then
  Name:=Node.Attributes['name'];

 if Node.HasAttribute('type') then
  AType:=Node.Attributes['type'];

 if Node.HasAttribute('id') then
 Id:=Node.Attributes['id'];

 if Node.HasAttribute('model:creationDate') then
  begin
   CreationDateStr:=Node.Attributes['model:creationDate'];
   StrToDateTime(CreationDateStr,AFormatSetting);
   CreationDate:=StrToDateTime(CreationDateStr,AFormatSetting);
  end;

 if Node.HasAttribute('model:fromDate') then
  begin
   FromDateStr:=Node.Attributes['model:fromDate'];
   FromDate:=StrToDateTime(FromDateStr,AFormatSetting);
  end;

 if Node.HasAttribute('xbrli:periodType') then
   SetPeriodTypeAsString(Node.Attributes['xbrli:periodType']);

 if Node.HasAttribute('xbrldt:typedDomainRef') then
  TypedDomainRef:=Node.Attributes['xbrldt:typedDomainRef'];

 if Node.HasAttribute('substitutionGroup') then
  SetSubstitutionGroupAsString(Node.Attributes['substitutionGroup']);

 if Node.HasAttribute('nillable') then
  Nillable:=Node.Attributes['nillable']='true'
   else
  Nillable:=True;

 IsAbstract:=Node.Attributes['abstract']='true';

 if Node.HasAttribute('enum:domain') then
  FEnumDomain:=Node.Attributes['enum:domain']
   else
  FEnumDomain:='<NONE>';

 if Node.HasAttribute('enum:linkrole') then
  FEnumLinkrole:=Node.Attributes['enum:linkrole']
   else
  FEnumLinkrole:='';
end;


procedure TElement.SetPeriodTypeAsString(const Value: string);
begin
  if Value='duration' then
   PeriodType:=TElementPeriodType.epDuration else
  if Value='instant' then
   PeriodType:=TElementPeriodType.epDuration else
    PeriodType:=TElementPeriodType.epUnknown;
end;

procedure TElement.SetSubstitutionGroupAsString(const Value: string);
begin
 if Value='xbrli:item' then
  FSubstitutionGroup:=TElementSubstitutionGroup.esgItem else
 if Value='xbrli:tuple' then
  FSubstitutionGroup:=TElementSubstitutionGroup.esgTuple else
 if Value='xbrldt:dimensionItem' then
  FSubstitutionGroup:=TElementSubstitutionGroup.esgDimensionItem else
 if Value='xbrli:hypercubeItem' then
  FSubstitutionGroup:=TElementSubstitutionGroup.esgHypercubeItem else
   FSubstitutionGroup:=TElementSubstitutionGroup.esgUnknown;
end;


{ TElementList }

destructor TElementList.Destroy;
begin
  FElementDict.Free;
  inherited;
end;

function TElementList.ElementByName(const Name: string): TElement;
begin
 if Self.FElementDict.ContainsKey(Name) then
   Result:=FElementDict[Name]
    else
   Result:=nil;
end;

procedure TElementList.LoadFromNode(const Node: IXmlNode; const Href:string);
var
 Element:TElement;
begin
 Element:=TElement.Create(Node);
 Element.Href:=Href;
 Add(Element);

 if not FElementDict.ContainsKey(Element.Name) then
   FElementDict.Add(Element.Name, Element);
end;

constructor TElementList.Create;
begin
 inherited Create;
 FElementDict:=TObjectDictionary<string,TElement>.Create;
end;


initialization
 AFormatSetting:=TFormatSettings.Create;
 AFormatSetting.DateSeparator:='-';
 AFormatSetting.LongDateFormat:='yyyy-mm-dd';
 AFormatSetting.ShortDateFormat:='yyyy-mm-dd';

finalization

end.

