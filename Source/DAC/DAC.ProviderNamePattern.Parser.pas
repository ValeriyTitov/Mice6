unit DAC.ProviderNamePattern.Parser;


interface
uses System.SysUtils,
     System.Classes,
     System.Generics.Collections,
     Common.StringUtils,
     DAC.XParams,
     DAC.XParams.Utils,
     DAC.XDataSetHelper;

type
 TDependEntity = class
  strict private
    FName: string;
    FSource: string;
    FValue: string;
    FIsExternalSource: Boolean;
  public
    property Name:string read FName write FName;
    property Value:string read FValue write FValue;
    property Source:string read FSource write FSource;
    property IsExternalSource:Boolean read FIsExternalSource write FIsExternalSource;
    function ItemName:string;
    function ShortItemName:string;
 end;

 TProviderNamePatternParser = class
  private
   FIsStoredProc:Boolean;
   FProviderName: string;
   FProviderNamePattern: string;
   FDependenciesList:TObjectList<TDependEntity>;
   procedure FindParamsDependencies;
   procedure FindTextDependencies;
   procedure PopulateByList(List:TStringList);
   procedure PopulateByList2(List:TStringList);
  public
   procedure Parse;
   property ProviderName:string read FProviderName;
   property ProviderNamePattern:string read FProviderNamePattern write FProviderNamePattern;
   property DependenciesList:TObjectList<TDependEntity> read FDependenciesList;
   property IsStoredProc:Boolean read FIsStoredProc;
   constructor Create;
   destructor Destroy; override;
 end;

implementation

{ TProviderNamePatternParser }

constructor TProviderNamePatternParser.Create;
begin
 FIsStoredProc:=True;
 FDependenciesList:=TObjectList<TDependEntity>.Create;
end;

destructor TProviderNamePatternParser.Destroy;
begin
  FDependenciesList.Free;
  inherited;
end;

procedure TProviderNamePatternParser.FindParamsDependencies;
var
 List:TStringList;
begin
 List:=TStringList.Create;
 try
  List.StrictDelimiter:=True;
  List.Delimiter:=',';
  List.DelimitedText:=TStringUtils.RightFromText(ProviderNamePattern,'@',ProviderNamePattern).Trim;
  PopulateByList(List);
 finally
  List.Free;
 end;
end;

procedure TProviderNamePatternParser.FindTextDependencies;
var
 List:TStringList;
begin
 FProviderName:=ProviderNamePattern;
 List:=TStringList.Create;
 try
  List.StrictDelimiter:=True;
  List.Delimiter:='<';
  List.DelimitedText:=ProviderNamePattern;
  PopulateByList2(List);
 finally
  List.Free;
 end;
end;

procedure TProviderNamePatternParser.Parse;
begin
 FDependenciesList.Clear;
 FProviderName:=TStringUtils.LeftFromText(ProviderNamePattern,'@',ProviderNamePattern).Trim;
 FIsStoredProc:=TxDataSetHelper.ProviderIsStoredProc(FProviderName);
 if FIsStoredProc then
  FindParamsDependencies
   else
  FindTextDependencies;
end;

procedure TProviderNamePatternParser.PopulateByList(List: TStringList);
var
 AName:string;
 Candidate:string;
 x:Integer;
 Item:TDependEntity;
begin
 for x:=0 to List.Count-1 do
  begin
    AName:=List.Names[x].Trim;
    if (AName.IsEmpty=False) then
     begin
      Item:=TDependEntity.Create;
      FDependenciesList.Add(Item);
      Item.Name:=TParamUtils.NormalizeParamName(AName);
      Candidate:=List.ValueFromIndex[x].Trim;
      Item.IsExternalSource:=Candidate.StartsWith('<') and Candidate.EndsWith('>');
      if Item.IsExternalSource then
       Candidate:=TStringUtils.RemoveBrackets(Candidate,'<','>');
      Item.Source:=TStringUtils.LeftFromDot(Candidate,'').Trim;
      Item.Value:=AnsiDequotedStr(TStringUtils.RightFromDot(Candidate,Candidate).Trim,DelphiQuoteChar);
     end;
  end;
end;




procedure TProviderNamePatternParser.PopulateByList2(List: TStringList);
var
 AName:string;
 EndIndex:Integer;
 Candidate:string;
 x:Integer;
 Item:TDependEntity;
begin
 for x:=0 to List.Count-1 do
  begin
    AName:= List[x].Trim;
    EndIndex:=AName.IndexOf('>');
    if (AName.IsEmpty=False) and (EndIndex>1) then
     begin
      Item:=TDependEntity.Create;
      FDependenciesList.Add(Item);
      Candidate:=AName.Substring(0,EndIndex);
      Item.IsExternalSource:=True;
      Item.Source:=TStringUtils.LeftFromDot(Candidate,'').Trim;
      Item.Value:=TStringUtils.RightFromDot(Candidate,Candidate);
     end;
  end;
end;


{ TDependEntity }

function TDependEntity.ItemName: string;
begin
 Result:='<'+ShortItemName+'>';
end;

function TDependEntity.ShortItemName: string;
begin
if Source.IsEmpty then
   Result:=Value
    else
   Result:=Source+'.'+Value;

end;

end.
