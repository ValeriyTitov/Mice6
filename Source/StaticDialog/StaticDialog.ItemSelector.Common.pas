unit StaticDialog.ItemSelector.Common;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Dialog.Basic, cxGraphics, Data.DB,
  cxLookAndFeels, cxLookAndFeelPainters, Vcl.Menus, Vcl.StdCtrls, cxButtons,
  Vcl.ExtCtrls, Vcl.ComCtrls, System.Generics.Collections, System.Generics.Defaults,
  cxControls, cxContainer, cxEdit, cxTextEdit, cxMaskEdit,
  cxDropDownEdit, cxImageComboBox,
  DAC.XDataSet,
  Common.Images,
  Common.ResourceStrings,
  Common.VariantUtils, Vcl.WinXCtrls;

type
  TDBAppObject = class
   public
      ImageIndex:Integer;
      ObjectId:Variant;
      Caption:string;
      Category:Integer;
      Description:string;
      function Clone:TDBAppObject;
      class function CloneFrom(P:TDBAppObject):TDBAppObject;
  end;

  TCommonItemSelectorDlg = class(TBasicDialog)
    MainListView: TListView;
    Panel1: TPanel;
    Timer1: TTimer;
    cbCategory: TcxImageComboBox;
    lbCategory: TLabel;
    memoDesc: TMemo;
    lbIDDesc: TLabel;
    lbID: TLabel;
    edSearch: TSearchBox;
    procedure MainListViewChange(Sender: TObject; Item: TListItem; Change: TItemChange);
    procedure MainListViewData(Sender: TObject; Item: TListItem);
    procedure edSearchChange(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure MainListViewDblClick(Sender: TObject);
  private
    FDataSet:TxDataSet;
    FLastTick:Int64;
    FList:TObjectList<TDBAppObject>;
    FFullList:TObjectList<TDBAppObject>;
    FFilterList:TObjectList<TDBAppObject>;
    FCurrentObject: TDBAppObject;
    FCategories:TDictionary<string,integer>;
    FCategoriesList:TList<string>;
    FAllCategory:Integer;
    FDBName: string;
    FDescriptionField: string;
    FCategoryField: string;
    FImageIndexField: string;
    FKeyField: string;
    FCaptionField: string;
    FKeyFieldValue: Variant;

    FFImageIndexField:TField;
    FFDescriptionField:TField;
    FFCategoryField:TField;

    procedure LoadObject(P:TDBAppObject; DataSet:TDataSet);
    procedure SetKeyFieldValue(const Value: Variant);
    function GetKeyFieldValue: Variant;
  protected
    function FindCategory(const CategoryName:string; ImageIndex:Integer):Integer;
    function IsInCategory(P:TDBAppObject;Category:Integer):Boolean; virtual;
    procedure UpdateInformation(P:TDBAppObject); virtual;
    procedure ApplyFilter(const TextFilter:string; Category:Integer); virtual;
    procedure CreateCategories;
  public
    property DataSet:TxDataSet read FDataSet;
    property DBName:string read FDBName write FDBName;
    property CurrentObject:TDBAppObject read FCurrentObject;
    property KeyFieldValue:Variant read GetKeyFieldValue write SetKeyFieldValue;


    property KeyField:string read FKeyField write FKeyField;
    property CaptionField:string read FCaptionField write FCaptionField;
    property ImageIndexField:string read FImageIndexField write FImageIndexField;
    property DescriptionField:string read FDescriptionField write FDescriptionField;
    property CategoryField:string read FCategoryField write FCategoryField;



    function Execute:Boolean; override;
    constructor Create(AOwner:TComponent); override;
    destructor Destroy; override;
  end;


implementation

{$R *.dfm}

procedure TCommonItemSelectorDlg.ApplyFilter(const TextFilter: string;  Category: Integer);
var
 P:TDBAppObject;
begin
 MainListView.Clear;
 FFilterList.Clear;
 for P in FFullList do
  if ((TextFilter='') or (Pos(TextFilter, AnsiLowerCase(P.Caption))>0)) and IsInCategory(P,Category) then
   FFilterList.Add(P.Clone);

FList:=FFilterList;
MainListView.Items.Count:=FList.Count;
end;

procedure TCommonItemSelectorDlg.Timer1Timer(Sender: TObject);
var
 s:string;
begin
 if FLastTick+500<GetTickCount then
  begin
   Timer1.Enabled:=False;
   s:=AnsiLowerCase(Trim(edSearch.Text));
   if (s<>'') or (cbCategory.Properties.Items.Count>1) then
    ApplyFilter(s, cbCategory.ItemIndex)
     else
     begin
      FList:=FFullList;
      MainListView.Items.Count:=FList.Count;
     end;
  end;
end;

constructor TCommonItemSelectorDlg.Create(AOwner: TComponent);
begin
  inherited;
  FFullList:=TObjectList<TDBAppObject>.Create;
  FFilterList:=TObjectList<TDBAppObject>.Create;
  FList:=FFullList;
  FDataSet:=TxDataSet.Create(Self);
  DataSet.DisableControls;
  FCategories:=TDictionary<string,Integer>.Create(TIStringComparer.Ordinal);
  FCategoriesList:=TList<string>.Create(TIStringComparer.Ordinal);
  FAllCategory:=-2;

  ImageIndexField:='ImageIndex';
  CategoryField:='Category';
  DescriptionField:='Description';
  CaptionField:='Caption';
  KeyField:='ObjectId';
end;

procedure TCommonItemSelectorDlg.CreateCategories;
var
 s:string;
 Item:TcxImageComboBoxItem;
begin
 for s in FCategoriesList do
  begin
   Item:=cbCategory.Properties.Items.Add;
   Item.ImageIndex:=Self.FCategories[s];
   Item.Description:=s;
   Item.Value:=FCategoriesList.IndexOf(s);
  end;

if cbCategory.Properties.Items.Count>1 then
 begin
  Item:=cbCategory.Properties.Items.Add;
  Item.ImageIndex:=0;
  Item.Description:=S_COMMON_ALL_BRAKET;
  Item.Value:=FCategoriesList.Count;
  cbCategory.ItemIndex:=Item.Index;
  cbCategory.Properties.OnChange:=edSearchChange;
  FAllCategory:=Item.Index;
 end;

end;

destructor TCommonItemSelectorDlg.Destroy;
begin
  FCategories.Free;
  FFullList.Free;
  FFilterList.Free;
  FCategoriesList.Free;
  inherited;
end;

procedure TCommonItemSelectorDlg.edSearchChange(Sender: TObject);
begin
 FLastTick:=GetTickCount;
 Timer1.Enabled:=True;
end;

function TCommonItemSelectorDlg.Execute: Boolean;
var
 P:TDBAppObject;
begin
 DataSet.DBName:=Self.DBName;
 DataSet.Open;
 DataSet.First;
 FFImageIndexField:=DataSet.FindField(ImageIndexField);
 FFDescriptionField:=DataSet.FindField(DescriptionField);
 FFCategoryField:=DataSet.FindField(CategoryField);

 while not DataSet.Eof do
    begin
     P:=TDBAppObject.Create;
     FFullList.Add(P);
     LoadObject(P,DataSet);
     DataSet.Next;
    end;
 CreateCategories;
 MainListView.Items.Count:=FFullList.Count;
 Result:=inherited Execute;
end;

function TCommonItemSelectorDlg.FindCategory(const CategoryName: string; ImageIndex:Integer):Integer;
begin
 if not FCategories.ContainsKey(CategoryName) then
  begin
   FCategories.Add(CategoryName, ImageIndex);
   Result:=FCategoriesList.Add(CategoryName);
  end
   else
    Result:=FCategoriesList.IndexOf(CategoryName);
end;

procedure TCommonItemSelectorDlg.FormShow(Sender: TObject);
var
 AVisible:Boolean;
begin
  lbID.Caption:='';
  AVisible:=cbCategory.Properties.Items.Count>1;
  lbCategory.Visible:=AVisible;
  cbCategory.Visible:=AVisible;
end;

function TCommonItemSelectorDlg.GetKeyFieldValue: Variant;
begin
 if Assigned(CurrentObject) then
  Result:=CurrentObject.ObjectId
   else
  Result:=NULL;
end;

function TCommonItemSelectorDlg.IsInCategory(P: TDBAppObject; Category:Integer): Boolean;
begin
 Result:=cbCategory.Properties.Items.Count<=1;
 if (Result=False) then
  Result:=(P.Category=Category) or (Category=FAllCategory);
end;

procedure TCommonItemSelectorDlg.LoadObject(P: TDBAppObject; DataSet: TDataSet);
begin
 P.ObjectId:=DataSet.FieldByName(KeyField).Value;
 P.Caption:=DataSet.FieldByName(CaptionField).AsString;

 if Assigned(FFImageIndexField) then
  P.ImageIndex:=DataSet.FieldByName(ImageIndexField).AsInteger
   else
  P.ImageIndex:=IMAGEINDEX_COMMON_ITEM;

 if Assigned(FFDescriptionField) then
  P.Description:=DataSet.FieldByName(DescriptionField).AsString;

 if Assigned(FFCategoryField) and (FFCategoryField.DataType=ftInteger) then
  P.Category:=FindCategory(FFCategoryField.AsString, DataSet.FieldByName(ImageIndexField).AsInteger);
end;

procedure TCommonItemSelectorDlg.MainListViewChange(Sender: TObject; Item: TListItem; Change: TItemChange);
begin
 bnOk.Enabled:=Assigned(Item);
 if Assigned(Item) then
  begin
   FCurrentObject:=TDBAppObject(Item.Data);
   UpdateInformation(FCurrentObject);
  end
   else
    FCurrentObject:=nil;
end;

procedure TCommonItemSelectorDlg.MainListViewData(Sender: TObject; Item: TListItem);
var
 P:TDBAppObject;
begin
if Item.Index<FList.Count then
 begin
  P:=FList[Item.index];
  Item.Caption:=P.Caption;
  Item.ImageIndex:=P.ImageIndex;
  Item.Data:=P;
 end;
end;


procedure TCommonItemSelectorDlg.MainListViewDblClick(Sender: TObject);
begin
 if bnOK.Enabled then
  ModalResult:=mrOK;
end;


procedure TCommonItemSelectorDlg.SetKeyFieldValue(const Value: Variant);
begin
  FKeyFieldValue := Value;
end;

procedure TCommonItemSelectorDlg.UpdateInformation(P: TDBAppObject);
begin
 if VarIsNull(P.ObjectId) then
  lbID.Caption:=S_NULL
   else
  lbID.Caption:=VarToStr(P.ObjectId);
 memoDesc.Text:=P.Description;
end;

{ TAppObject }

function TDBAppObject.Clone: TDBAppObject;
begin
 Result:=CloneFrom(Self);
end;

class function TDBAppObject.CloneFrom(P: TDBAppObject): TDBAppObject;
begin
 Result:=TDBAppObject.Create;
 Result.ObjectId:=P.ObjectId;
 Result.ImageIndex:=P.ImageIndex;
 Result.Category:=P.Category;
 Result.Caption:=P.Caption;
end;


end.
