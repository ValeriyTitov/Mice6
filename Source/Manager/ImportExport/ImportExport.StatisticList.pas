unit ImportExport.StatisticList;

interface
uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  System.IOUtils,
  Common.ResourceStrings,
  Common.StringUtils,
  System.NetEncoding,  System.Generics.Collections,
  System.Generics.Defaults, System.JSON,
  Common.VariantUtils,
  Common.FormatSettings,
  ImportExport.JsonToDataSet;


type
 TImportStatisticItem = class
  strict private
    FInsertedCount: Integer;
    FDeletedCount: Integer;
    FChangeCount: Integer;
    FTotalChangeCount:Integer;
  public
    property TotalChangeCount:Integer read FTotalChangeCount write FTotalChangeCount;
    property ChangeCount:Integer read FChangeCount write FChangeCount;
    property InsertedCount:Integer read FInsertedCount write FInsertedCount;
    property DeletedCount:Integer read FDeletedCount write FDeletedCount;
    procedure LoadFromImporter(Importer:TJsonToDataSetConverter);
    constructor Create;
 end;

 TImportStatisticList = class
  private
   FList:TObjectDictionary<string,TImportStatisticItem>;
  public
   property List:TObjectDictionary<string,TImportStatisticItem> read FList;
   constructor Create; virtual;
   destructor Destroy; override;
   procedure SetImportStatistic(const Name:string;ChangeCount,InsertedCount,DeletedCount,CurrentChangeCount:Integer);overload;
   procedure SetImportStatistic(const Name:string; Importer:TJsonToDataSetConverter);overload;
 end;

implementation

{ TImportStatisticList }

constructor TImportStatisticList.Create;
begin
  FList:=TObjectDictionary<string,TImportStatisticItem>.Create([doOwnsValues]);
end;

destructor TImportStatisticList.Destroy;
begin
  FList.Free;
  inherited;
end;

procedure TImportStatisticList.SetImportStatistic(const Name: string; Importer: TJsonToDataSetConverter);
var
 Item:TImportStatisticItem;
begin
 if not FList.ContainsKey(Name) then
  begin
   Item:=TImportStatisticItem.Create;
   FList.Add(Name,Item);
  end;
 Item:=FList[Name];
 Item.LoadFromImporter(Importer);
end;


procedure TImportStatisticList.SetImportStatistic(const Name: string; ChangeCount, InsertedCount, DeletedCount, CurrentChangeCount: Integer);
var
 Item:TImportStatisticItem;
begin
 if not FList.ContainsKey(Name) then
  begin
   Item:=TImportStatisticItem.Create;
   FList.Add(Name,Item);
  end;
 Item:=FList[Name];
 Item.ChangeCount:=Item.ChangeCount+ChangeCount;
 Item.InsertedCount:=Item.InsertedCount+InsertedCount;
 Item.DeletedCount:=Item.DeletedCount+DeletedCount;
end;

{ TImportStatisticItem }

constructor TImportStatisticItem.Create;
begin
 ChangeCount:=0;
 InsertedCount:=0;
 DeletedCount:=0;
end;

procedure TImportStatisticItem.LoadFromImporter(Importer: TJsonToDataSetConverter);
begin
 TotalChangeCount:=Importer.TotalChangeCount+TotalChangeCount;
 ChangeCount:=Importer.ChangeCount+ChangeCount;
 InsertedCount:=Importer.InsertedCount+InsertedCount;
 DeletedCount:=Importer.DeletedCount+DeletedCount;
end;

end.
