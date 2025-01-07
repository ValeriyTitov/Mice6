unit AppTemplate.FileImport;

interface
 uses
     Data.DB, System.Classes, System.SysUtils, System.Variants,
     DAC.DatabaseUtils,
     VCL.Dialogs;


type
  TAbstractTemplateImport = class(TComponent)
  private
    FDataSet: TDataSet;
    FFileName: string;
    FDialog:TOpenDialog;
    FRootParentId: Variant;
  protected

    function ExecuteDialog:Boolean;virtual;
    procedure CreateNewItem(const Id, ParentId: Variant; TagType: Integer; const NodeName, NodeValue:string; ValueType:Integer);
  public
    property OpenDialog:TOpenDialog read FDialog;
    property FileName:string read FFileName write FFileName;
    property DataSet:TDataSet read FDataSet;
    property RootParentId:Variant read FRootParentId write FRootParentId;
    procedure Exec(Root:Variant);
    procedure Import; virtual; abstract;
    constructor Create(SchemaDataSet:TDataSet);reintroduce;virtual;
    destructor Destroy; override;

    class procedure NewItem(DataSet:TDataSet; const Id, ParentId:Variant; TagType:Integer; const NodeName, NodeValue:string; ValueType:Integer);
    class function NewID:Int64;
  end;




const
 TagTypeNameValue=0;
 TagTypeXmlAttrib=1;
 TagTypeJsonItem=2;
 TagTypeListThroughDataSet=3;
 TagTypeGroup=4;


 ValueTypeJsonString = 0;
 ValueTypeJsonNumber = 1;
 ValueTypeJSONBool = 2;
 ValueTypeJsonNull = 3;
 ValueTypeJsonObject = 4;
 ValueTypeJsonArray = 5;
 ValueTypeJsonXmlTag = 6;


 ValueSourceConstant = 0;
 ValueSourceDataField = 1;
 ValueSourceParameter = 2;
 ValueSourceGlobalSetting = 3;


implementation

var
 FID:Integer =1;

{ TAbstractTemplateImport }

constructor TAbstractTemplateImport.Create(SchemaDataSet: TDataSet);
begin
 inherited Create(nil);
 FDataSet:=SchemaDataSet;
 FDialog:=TOpenDialog.Create(Self);
 FDialog.Filter:='*.*';
end;

destructor TAbstractTemplateImport.Destroy;
begin
  FDialog.Free;
  inherited;
end;


procedure TAbstractTemplateImport.Exec(Root:Variant);
begin
 if ExecuteDialog then
  begin
   RootParentId:=Root;
   Import;
  end;
end;

function TAbstractTemplateImport.ExecuteDialog: Boolean;
begin
 Result:=OpenDialog.Execute;
 if Result then
  FileName:=OpenDialog.FileName;
end;

class function TAbstractTemplateImport.NewID: Int64;
begin
// Result:=FID;
// Inc(FID);
 Result:=TDataBaseUtils.NewAppObjectId(sq_AppTemplatesData);
end;

class procedure TAbstractTemplateImport.NewItem(DataSet:TDataSet;const Id, ParentId: Variant; TagType: Integer; const NodeName, NodeValue:string; ValueType:Integer);
begin
   DataSet.Edit;
   DataSet.Append;
   DataSet.FieldByName('AppTemplatesDataId').AsInteger:=Id;
   DataSet.FieldByName('ParentId').Value:=ParentId;
   DataSet.FieldByName('OrderId').Value:=Id;
   DataSet.FieldByName('Active').AsBoolean:=True;
   DataSet.FieldByName('TagName').AsString:=NodeName;
   if NodeValue<>'' then
    begin
     DataSet.FieldByName('Description').AsString:=NodeValue;
     DataSet.FieldByName('Value').AsString:=NodeValue;
    end;
   DataSet.FieldByName('TagType').AsInteger:=TagType;
   DataSet.FieldByName('ValueType').AsInteger:=ValueType;
   DataSet.FieldByName('ValueSource').AsInteger:=ValueSourceConstant;
   DataSet.FieldByName('CreateCondition').AsInteger:=0;//Always

   DataSet.Post;
end;


procedure TAbstractTemplateImport.CreateNewItem(const Id, ParentId: Variant;  TagType: Integer; const NodeName, NodeValue: string; ValueType:Integer);
begin
 NewItem(DataSet,Id, ParentId,TagType, NodeName, NodeValue, ValueType);
end;




end.
