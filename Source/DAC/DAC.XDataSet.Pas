unit DAC.XDataSet;

interface
Uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  FireDAC.Stan.Intf,DB,
  FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.Stan.Param, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, FireDAC.UI.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Phys, FireDAC.VCLUI.Wait,
  FireDAC.Stan.StorageJSON,  FireDAC.Stan.StorageXML,
  System.Generics.Collections,
  DAC.ConnectionMngr,
  DAC.XParams.Utils,
  DAC.XDataSetHelper,
  DAC.ProviderNamePattern.Parser,
  DAC.BaseDataSet;


type

 TDataSetCopyEvent = procedure (Source, Dest:TDataSet) of object;

 TXDataSet=class(TBaseDataSet)
  strict private
    FTableName: string;
    FParser:TProviderNamePatternParser;
    FCopyExclusionList:TStringList;
    FOnCopyDataSet: TDataSetCopyEvent;
    FSequenceName: string;
    function GetCopyExclusionList: TStringList;
    function AllowedToCopy(Field:TField):Boolean;
  private
    FHint: string;
    procedure SetProviderNamePattern(const Value: string);
    function GetParser: TProviderNamePatternParser;
    function GetProviderNamePattern: string;
  protected
    procedure OpenCursor(InfoQuery:Boolean); override;
  public
    property CopyExclusionList:TStringList read GetCopyExclusionList;
    property Parser:TProviderNamePatternParser read GetParser;
    constructor Create(AOwner:TComponent); override;
    destructor Destroy; override;
    procedure TryUpdateMasterKey(const FieldName:string; const Value:Variant);
    procedure SetAllRows(Field:TField; const AValue:Variant);
    procedure Execute(ATimes: Integer = 0; AOffset: Integer = 0);override;
    procedure ReQuery;
    procedure CopyRowFrom(DataSet:TDataSet;CopyKeyFieldValue:Boolean);
    procedure LoadFromDataSet(DataSet: TDataSet;CopyKeyFieldValue:Boolean);
    procedure SetContext(const Name, Value:string);
    procedure SaveToList(List:TList<Variant>);
    procedure LoadFromList(List:TList<Variant>);
    function FieldByNameDef(const FieldName:string; DefaultValue:Variant):Variant;
    procedure Clear;
    function NeedSequence:Boolean;
    class procedure CloneRow(DataSet:TDataSet);
 published
    property TableName:string read FTableName write FTableName;
    property ProviderNamePattern:string read GetProviderNamePattern write SetProviderNamePattern;
    property OnCopyDataSet:TDataSetCopyEvent read FOnCopyDataSet write FOnCopyDataSet;
    property SequenceName:string read FSequenceName write FSequenceName;
    property Hint:string read FHint write FHint;
 end;
implementation



{ TXDataSet }


function TXDataSet.AllowedToCopy(Field: TField): Boolean;
begin
 Result:=(Field.ReadOnly=False) and (CopyExclusionList.IndexOf(Field.FieldName)<0);
end;

procedure TXDataSet.Clear;
begin
 Self.First;
 while not Self.Eof do
    Self.Delete;
end;

class procedure TXDataSet.CloneRow(DataSet: TDataSet);
var
 List:TList<Variant>;
 Field:TField;
 x:Integer;
begin
 List:=TList<Variant>.Create;
 try
  for Field in DataSet.Fields do
    List.Add(Field.Value);

  DataSet.Append;

  for x:=0 to List.Count-1 do
  begin
    Field:=DataSet.Fields[x];
    if Field.ReadOnly=False then
     Field.Value:=List[x];
  end;

 finally
  List.Free;
 end;

end;

procedure TXDataSet.CopyRowFrom(DataSet: TDataSet; CopyKeyFieldValue:Boolean);
var
 Field:TField;
 DestField:TField;
begin
for Field in Fields do
 begin
  DestField:=DataSet.FindField(Field.FieldName);
  if Assigned(DestField) and AllowedToCopy(DestField) and ((KeyField.Equals(DestField.FieldName)=False) or (CopyKeyFieldValue=True)) then
   Field.Value:=DestField.Value;
  if Assigned(OnCopyDataSet) then
   OnCopyDataSet(DataSet, Self);
 end;
end;

procedure TXDataSet.LoadFromDataSet(DataSet: TDataSet; CopyKeyFieldValue:Boolean);
begin
 DataSet.First;
 while not DataSet.Eof do
  begin
   Self.Append;
   CopyRowFrom(DataSet, CopyKeyFieldValue);
   Self.Post;
   DataSet.Next;
  end;
end;

constructor TXDataSet.Create(AOwner: TComponent);
begin
  inherited;

end;

destructor TXDataSet.Destroy;
begin
  FParser.Free;
  FCopyExclusionList.Free;
  inherited;
end;


procedure TXDataSet.Execute(ATimes, AOffset: Integer);
begin
 try
   inherited;

 finally

 end;
end;

function TXDataSet.FieldByNameDef(const FieldName: string;  DefaultValue: Variant): Variant;
var
 F:TField;
begin
F:=FindField(FieldName);
 if Assigned(F) then
  Result:=F.Value
   else
  Result:=DefaultValue;
end;

function TXDataSet.GetCopyExclusionList: TStringList;
begin
 if not Assigned(FCopyExclusionList) then
  FCopyExclusionList:=TStringList.Create;
 Result:=FCopyExclusionList;
end;

function TXDataSet.GetParser: TProviderNamePatternParser;
begin
 if not Assigned(FParser) then
  FParser:=TProviderNamePatternParser.Create;
  Result:=FParser;
end;

function TXDataSet.GetProviderNamePattern: string;
begin
 Result:=Parser.ProviderNamePattern;
end;

procedure TXDataSet.LoadFromList(List: TList<Variant>);
var
 F:TField;
begin
 for F in Fields do
  begin
   if (F.ReadOnly=False) and (F.Index<=List.Count) then
    F.Value:=List[F.Index];
  end;
end;

function TXDataSet.NeedSequence: Boolean;
var
 F:TField;
begin
 F:=FieldByName(KeyField);
 Result:=Assigned(F) and (F.IsNull or (F.AsInteger<0)) and (F.ReadOnly=False) and (SequenceName.Trim.IsEmpty=False) and (ReadOnly=False);
end;

procedure TXDataSet.SaveToList(List: TList<Variant>);
var
 F:TField;
begin
 for F in Fields do
   List.Add(F.Value);
end;

procedure TXDataSet.SetAllRows(Field: TField; const AValue: Variant);
var
 B:TBookMark;
 AControlsDisabled:Boolean;
 FAfterPostEvent:TDataSetNotifyEvent;
begin
 FAfterPostEvent:=AfterPost;
 AfterPost:=nil;
 AControlsDisabled:=ControlsDisabled;
 DisableControls;
 B:=Bookmark;
  try
   First;
    while not EOF do
     begin
      if Field.Value<>AValue then
       begin
        Edit;
        Field.Value:=AValue;
        Post;
       end;
      Next;
     end;
   Bookmark:=B;
  finally
  AfterPost:=FAfterPostEvent;
  if (AControlsDisabled=False) then
   EnableControls;
 end;
end;


procedure TXDataSet.SetContext(const Name, Value: string);
begin
 ExecutionContext.ApplicationContext.AddOrSetValue(Name, Value);
end;



procedure TXDataSet.SetProviderNamePattern(const Value: string);
begin
 if ProviderNamePattern<>Value then
  begin
   Parser.ProviderNamePattern:=Value;
   Parser.Parse;
   Self.ProviderName:=Parser.ProviderName;
  end;
end;

procedure TXDataSet.TryUpdateMasterKey(const FieldName: string;  const Value: Variant);
var
 F:TField;
begin
 F:=FindField(FieldName);
 if Assigned(F) and Active and ((ChangeCount>0) or (State in [dsInsert])) then
  SetAllRows(F, Value);
end;

procedure TXDataSet.OpenCursor(InfoQuery: Boolean);
begin
  try

   inherited;

  finally

  end;
end;


procedure TXDataSet.ReQuery;
var
 ID:Variant;
begin
 if (Active) and (RecordCount>0) then
  begin
   ID:=FieldByName(KeyField).Value;
   Close;
   Open;
   Locate(KeyField,ID,[]);
  end
   else
    begin
     Close;
     Open;
    end;
end;

end.
