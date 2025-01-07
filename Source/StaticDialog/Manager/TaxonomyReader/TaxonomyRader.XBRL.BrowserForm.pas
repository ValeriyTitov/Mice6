unit TaxonomyRader.XBRL.BrowserForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.ComCtrls,
  Data.DB, Vcl.Grids, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, FireDAC.Comp.DataSet, FireDAC.Comp.Client,
  System.Generics.Defaults, System.Generics.Collections,
  Taxonomy.XBRL.ObjectModel, TaxonomyReader.Reader, TaxonomyRader.XBRL.DefinitionLinkbase,
  cxGraphics, cxControls, cxLookAndFeels, cxLookAndFeelPainters, cxStyles,
  cxCustomData, cxFilter, cxData, cxDataStorage, cxEdit, cxNavigator,
  cxDataControllerConditionalFormattingRulesManagerDialog, cxDBData,
  cxGridLevel, cxClasses, cxGridCustomView, cxGridCustomTableView,
  cxGridTableView, cxGridDBTableView, cxGrid,
  cxGridDBBandedTableView,
  TaxonomyRader.XBRL.BrowserForm.DataFrame, Vcl.Menus, cxButtons, cxContainer,
  cxTextEdit, cxMemo;

type
  TReportPart = class
  private
    FDataFrame: TDataFrame;
    FDataSet:TFDMemTable;
    FDefinitionLink: TDefinitionLink;
    FReader: TTaxononmyReader;

    procedure CreateItem(Elem:TElement; const ALabel:string);
  public
    property DataFrame:TDataFrame read FDataFrame;
    property DefinitionLink:TDefinitionLink read FDefinitionLink write FDefinitionLink;
    property Reader:TTaxononmyReader read FReader write FReader;
    constructor Create(AParent:TWinControl);
    destructor Destroy; override;
    procedure LoadFromArc(DefLink: TDefinitionLink; Reader:TTaxononmyReader);
  end;

  TReportPartList = class(TObjectList<TReportPart>)
  end;

  TXbrlBrowserForm = class(TForm)
    pnTop: TPanel;
    cbDefinitions: TComboBox;
    pgData: TPageControl;
    Panel1: TPanel;
    bnImport: TcxButton;
    memDesc: TcxMemo;
    procedure cbDefinitionsChange(Sender: TObject);
    procedure bnImportClick(Sender: TObject);
  private
    FPartList:TObjectList<TReportPart>;
    FDataSet: TDataSet;
    FOnAddDataSet: TDataSetNotifyEvent;
    procedure CreateRow(Elem:TElement; const ALabel:string; const ParentId:Variant);
    procedure CreateContextRef(const ParentId:Variant);
    procedure CreateDecimals(const ParentId:Variant);
    procedure CreateConcepts(Part:TReportPart; const ParentId:Variant);
    procedure CreateContext(Part:TReportPart; const ParentId:Variant);
    procedure ImportData(Part:TReportPart);
    procedure DoOnAddDataSet;
    function IsUserRole(Role:TRoleType):Boolean;
    function IsDecimalsRequired(Elem:TElement):Boolean;
  public
    procedure LoadFromReader(Reader:TTaxononmyReader);
    constructor Create(AOwner:TComponent);override;
    destructor Destroy; override;
    property DataSet:TDataSet read FDataSet write FDataSet;
    property OnAddDataSet:TDataSetNotifyEvent read FOnAddDataSet write FOnAddDataSet;
    function CurrentDataSetName:string;
  end;

var
  XbrlBrowserForm: TXbrlBrowserForm;


const
 cXmlTag = 0;
 cXmlAttrib = 1;
 cDataSet = 5;
 cGroup = 6;

 cConst = 0;
 cDataField = 1;

implementation

{$R *.dfm}

{ TReportPart }

constructor TReportPart.Create(AParent:TWinControl);
begin
  FDataFrame:=TDataFrame.Create(AParent);
  FDataFrame.Parent:=AParent;
  FDataFrame.Align:=alClient;
  FDataSet:=FDataFrame.DataSet;
end;

procedure TReportPart.CreateItem(Elem:TElement; const ALabel:string);
begin
 FDataSet.Append;
 FDataSet.FieldByName('Name').AsString:=Elem.Name;
 FDataSet.FieldByName('Label').AsString:=ALabel;
 FDataSet.FieldByName('Type').AsString:=Elem.AType;
 FDataSet.FieldByName('Enumeration').AsString:=Elem.EnumDomain;
 FDataSet.FieldByName('Nillable').AsString:=Elem.Nillable.ToString(TUseBoolStrs.True);
 FDataSet.Post;
end;



destructor TReportPart.Destroy;
begin
  inherited;
end;

procedure TReportPart.LoadFromArc(DefLink: TDefinitionLink; Reader:TTaxononmyReader);
var
 DefArc:TDefinitionArc;
 Elem:TElement;
 ALabel:string;
begin
 DefinitionLink:=DefLink;
 Self.Reader:=Reader;
 Self.DataFrame.gridView.BeginUpdate;
 Self.FDataSet.Open;
  for DefArc in DefLink.DefinitionArcs do
   begin
    Elem:=Reader.ElementList.ElementByName(DefArc.ToID);
    if Assigned(Elem) and (not Elem.Name.StartsWith('hyp')) then
//    http://xbrl.org/int/dim/arcrole/hypercube-dimension
     begin
      ALabel:=Reader.TaxonomySchema.LabelLinks.FindLabelForFact(Elem.Href, Elem.Id);
      CreateItem(Elem,ALabel);
     end;
   end;
 Self.DataFrame.gridView.EndUpdate;
end;


procedure TXbrlBrowserForm.bnImportClick(Sender: TObject);
begin
 if Assigned(DataSet) then
  ImportData(Self.FPartList[pgData.ActivePageIndex]);
end;

procedure TXbrlBrowserForm.cbDefinitionsChange(Sender: TObject);
begin
 Self.pgData.ActivePageIndex:=self.cbDefinitions.ItemIndex;
 Self.bnImport.Enabled:=Self.cbDefinitions.Text<>'';
 Self.memDesc.Lines.Text:=Self.cbDefinitions.Text;
end;

constructor TXbrlBrowserForm.Create(AOwner: TComponent);
begin
  inherited;
  FPartList:=TObjectList<TReportPart>.Create();
end;

procedure TXbrlBrowserForm.CreateConcepts(Part:TReportPart; const ParentId:Variant);
var
 DefArc:TDefinitionArc;
 Elem:TElement;
 ALabel:string;
begin
 for DefArc in Part.DefinitionLink.DefinitionArcs do
  if DefArc.ArcRole='http://xbrl.org/int/dim/arcrole/domain-member' then
   begin
    Elem:=Part.Reader.ElementList.ElementByName(DefArc.ToID);
    if Assigned(Elem) then
     begin
      ALabel:=Part.Reader.TaxonomySchema.LabelLinks.FindLabelForFact(Elem.Href, Elem.Id);
      CreateRow(Elem, ALabel,ParentId);
     end;
   end;
end;

procedure TXbrlBrowserForm.CreateContext(Part: TReportPart;  const ParentId: Variant);
var
 DefArc:TDefinitionArc;
 Elem:TElement;
 ALabel:string;
 FID1:Variant;
 FEntityID:Variant;
 FID2:Variant;
 FID3:Variant;
 FID4:Variant;
begin
 DoOnAddDataSet;
 FID1:=DataSet.FieldByName('AppTemplatesDataId').Value;
 DataSet.Edit;
 DataSet.FieldByName('TagName').AsString:='xbrli:context';
 DataSet.FieldByName('ParentId').Value:=ParentId;
 DataSet.FieldByName('TagType').AsInteger:=cXmlTag;
 DataSet.FieldByName('DatasetName').Clear;
 DataSet.FieldByName('ValueSource').AsInteger:=cConst;
 DataSet.Post;

 DoOnAddDataSet;
 DataSet.FieldByName('AppTemplatesDataId').Value;
 DataSet.Edit;
 DataSet.FieldByName('TagName').AsString:='id';
 DataSet.FieldByName('ParentId').Value:=FID1;
 DataSet.FieldByName('TagType').AsInteger:=cXmlAttrib;
 DataSet.FieldByName('DatasetName').AsString:=Self.CurrentDataSetName;
 DataSet.FieldByName('ValueSource').AsInteger:=cDataField;
 DataSet.FieldByName('Value').AsString:='contextRef';
 DataSet.Post;

 DoOnAddDataSet;
 FEntityID:=DataSet.FieldByName('AppTemplatesDataId').Value;
 DataSet.Edit;
 DataSet.FieldByName('TagName').AsString:='xbrli:entity';
 DataSet.FieldByName('ParentId').Value:=FID1;
 DataSet.FieldByName('TagType').AsInteger:=cXmlTag;
 DataSet.FieldByName('DatasetName').Clear;
 DataSet.FieldByName('ValueSource').AsInteger:=cConst;
 DataSet.Post;

 DoOnAddDataSet;
 FID2:=DataSet.FieldByName('AppTemplatesDataId').Value;
 DataSet.Edit;
 DataSet.FieldByName('TagName').AsString:='xbrli:identifier';
 DataSet.FieldByName('ParentId').Value:=FEntityID;
 DataSet.FieldByName('TagType').AsInteger:=cXmlTag;
 DataSet.FieldByName('DatasetName').AsString:='ReportHeader';
 DataSet.FieldByName('ValueSource').AsInteger:=cDataField;
 DataSet.FieldByName('Value').Value:='OGRN';
 DataSet.Post;

 DoOnAddDataSet;
 DataSet.Edit;
 DataSet.FieldByName('TagName').AsString:='scheme';
 DataSet.FieldByName('ParentId').Value:=FID2;
 DataSet.FieldByName('TagType').AsInteger:=cXmlAttrib;
 DataSet.FieldByName('DatasetName').Clear;
 DataSet.FieldByName('ValueSource').AsInteger:=cConst;
 DataSet.FieldByName('Value').AsString:='http://www.cbr.ru';
 DataSet.Post;

 DoOnAddDataSet;
 FID3:=DataSet.FieldByName('AppTemplatesDataId').Value;
 DataSet.Edit;
 DataSet.FieldByName('TagName').AsString:='xbrli:period';
 DataSet.FieldByName('ParentId').Value:=FID1;
 DataSet.FieldByName('TagType').AsInteger:=cXmlTag;
 DataSet.FieldByName('DatasetName').Clear;
 DataSet.FieldByName('ValueSource').AsInteger:=cConst;
 DataSet.Post;

 DoOnAddDataSet;
 DataSet.Edit;
 DataSet.FieldByName('TagName').AsString:='xbrli:instant';
 DataSet.FieldByName('ParentId').Value:=FID3;
 DataSet.FieldByName('TagType').AsInteger:=cXmlTag;
 DataSet.FieldByName('DatasetName').AsString:='ReportHeader';
 DataSet.FieldByName('ValueSource').AsInteger:=cDataField;
 DataSet.FieldByName('Value').AsString:='StartDate';
 DataSet.Post;

 DoOnAddDataSet;
 FID4:=DataSet.FieldByName('AppTemplatesDataId').Value;
 DataSet.Edit;
 DataSet.FieldByName('TagName').AsString:='xbrli:scenario';
 DataSet.FieldByName('ParentId').Value:=FID1;
 DataSet.FieldByName('TagType').AsInteger:=cXmlTag;
 DataSet.FieldByName('DatasetName').Clear;
 DataSet.FieldByName('ValueSource').AsInteger:=cConst;
 DataSet.Post;

  for DefArc in Part.DefinitionLink.DefinitionArcs do
  if DefArc.ArcRole='http://xbrl.org/int/dim/arcrole/hypercube-dimension' then
   begin
    Elem:=Part.Reader.ElementList.ElementByName(DefArc.ToID);
    if Assigned(Elem) then
     begin
       DoOnAddDataSet;
       DataSet.FieldByName('AppTemplatesDataId').Value;
       DataSet.Edit;
       DataSet.FieldByName('TagName').AsString:=Elem.Name;
       DataSet.FieldByName('ParentId').Value:=FID4;
       DataSet.FieldByName('TagType').AsInteger:=cXmlTag;
       DataSet.FieldByName('DatasetName').AsString:=Self.CurrentDataSetName;
       DataSet.FieldByName('ValueSource').AsInteger:=cDataField;
       DataSet.FieldByName('Value').AsString:=Elem.Name;
       ALabel:=Part.Reader.TaxonomySchema.LabelLinks.FindLabelForFact(Elem.Href, Elem.Id);
       DataSet.FieldByName('Description').AsString:=ALabel;
       DataSet.Post;
     end;
   end;

end;

procedure TXbrlBrowserForm.CreateContextRef(const ParentId: Variant);
const
 S_CONTEXT_REF = 'contextRef';
begin
 DoOnAddDataSet;
 DataSet.Edit;
 DataSet.FieldByName('TagName').AsString:=S_CONTEXT_REF;
 DataSet.FieldByName('ParentId').Value:=ParentId;
 DataSet.FieldByName('TagType').AsInteger:=1; //Xml Attribute
 DataSet.FieldByName('DatasetName').AsString:=CurrentDataSetName;
 DataSet.FieldByName('ValueSource').AsInteger:=1;//Datafield
 DataSet.FieldByName('Value').AsString:=S_CONTEXT_REF;
 DataSet.FieldByName('CreateCondition').AsInteger:=8;//IS NOT NULL
 DataSet.Post;
end;

procedure TXbrlBrowserForm.CreateDecimals(const ParentId: Variant);
const
 S_DECIMALS = 'decimals';
begin
 DoOnAddDataSet;
 DataSet.Edit;
 DataSet.FieldByName('TagName').AsString:=S_DECIMALS;
 DataSet.FieldByName('ParentId').Value:=ParentId;
 DataSet.FieldByName('TagType').AsInteger:=1; //Xml Attribute
 DataSet.FieldByName('DatasetName').AsString:=CurrentDataSetName;
 DataSet.FieldByName('ValueSource').AsInteger:=0;//const
// DataSet.FieldByName('ValueSource').AsInteger:=1;//Datafield
 DataSet.FieldByName('Value').AsString:='0';//S_DECIMALS;
 DataSet.Post;
end;

procedure TXbrlBrowserForm.CreateRow(Elem: TElement; const ALabel: string; const ParentId:Variant);
var
 ADescription:string;
 FLastId:Variant;
begin
 DoOnAddDataSet;
 FLastId:=DataSet.FieldByName('AppTemplatesDataId').Value;
 DataSet.Edit;
 DataSet.FieldByName('TagName').AsString:=Elem.Name;
 DataSet.FieldByName('ParentId').Value:=ParentId;
 DataSet.FieldByName('DatasetName').AsString:=CurrentDataSetName;
 DataSet.FieldByName('ValueSource').AsInteger:=1;//Datafield
 DataSet.FieldByName('Value').AsString:=Elem.Name;
 DataSet.FieldByName('CreateCondition').AsInteger:=8;//IS NOT NULL

 ADescription:=ALabel+#13+
 'Type: '+Elem.AType+#13+
 'Enumeration: '+Elem.EnumDomain+#13+
 'Nilable: '+Elem.Nillable.ToString(TUseBoolStrs.True);

 DataSet.FieldByName('Description').AsString:=ADescription;
 DataSet.Post;
 CreateContextRef(FLastID);
 if IsDecimalsRequired(Elem) then
  CreateDecimals(FLastId);
end;

function TXbrlBrowserForm.CurrentDataSetName: string;
begin
 Result:='DataSet1';
end;

destructor TXbrlBrowserForm.Destroy;
begin
 FPartList.Free;
 inherited;
end;

procedure TXbrlBrowserForm.DoOnAddDataSet;
begin
 if Assigned(Self.OnAddDataSet) then
  OnAddDataSet(Self.DataSet);
end;

procedure TXbrlBrowserForm.ImportData(Part: TReportPart);
var
 FLastId:Variant;
 FBaseId:Variant;
begin
 DoOnAddDataSet;
 FBaseId:=DataSet.FieldByName('AppTemplatesDataId').Value;
 DataSet.Edit;
 DataSet.FieldByName('TagName').AsString:=cbDefinitions.Text;
 DataSet.FieldByName('TagType').AsInteger:=cDataSet;
 DataSet.FieldByName('DataSetName').AsString:=Self.CurrentDataSetName;


 DoOnAddDataSet;
 DataSet.Edit;
 DataSet.FieldByName('ParentId').Value:=FBaseID;
 DataSet.FieldByName('TagName').AsString:='Concepts';
 DataSet.FieldByName('TagType').AsInteger:=cGroup;

 FLastId:=DataSet.FieldByName('AppTemplatesDataId').Value;
 CreateContext(Part,FBaseId);
 CreateConcepts(Part, FLastId);
end;

function TXbrlBrowserForm.IsDecimalsRequired(Elem: TElement): Boolean;
begin
 Result:=(Elem.AType='xbrli:decimalItemType') or (Elem.AType='xbrli:monetaryItemType');
end;

function TXbrlBrowserForm.IsUserRole(Role: TRoleType): Boolean;
begin
 Result:=not Role.Definition.Trim.IsEmpty;
end;

procedure TXbrlBrowserForm.LoadFromReader(Reader: TTaxononmyReader);
var
 DefLink:TDefinitionLink;
 Part:TReportPart;
 Sheet:TTabSheet;
 AName:string;
begin
for DefLink in Reader.TaxonomySchema.DefinitionLinks do
  begin
  if IsUserRole(Reader.TaxonomySchema.RoleByUri(DefLink.Role)) then
    begin
     Sheet:=TTabSheet.Create(pgData);
     Sheet.Parent:=pgData;
     Sheet.PageControl:=Self.pgData;
     Sheet.TabVisible:=False;
     AName:=Reader.TaxonomySchema.RoleByUri(DefLink.Role).Definition;
     Part:=TReportPart.Create(Sheet);
     //Part.DataFrame.memo.Lines.Add('Полное название роли: '+AName);
     Self.FPartList.Add(Part);
     Part.LoadFromArc(DefLink, Reader);
     cbDefinitions.AddItem(AName,Sheet);
    end;
  end;
end;


end.
