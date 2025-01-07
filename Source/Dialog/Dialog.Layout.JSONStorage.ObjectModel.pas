unit Dialog.Layout.JSONStorage.ObjectModel;

interface

uses
 System.Classes, System.SysUtils, System.Variants, System.Generics.Collections,
 System.Generics.Defaults, System.JSON, Rest.Json,
 Common.JsonUtils;


type

 TObjectProperties = class(TObjectDictionary<string,Variant>)
  public
    constructor Create(AOwner:TJsonObject); overload;
    constructor Create; overload;
    destructor Destroy; override;
    procedure ToList(List: TStrings);
    procedure ToJson(JsonObject:TJsonObject);
    procedure LoadFromJson(JsonObject:TJsonObject);
    function ReadProperty(const AName:string):Variant;
 end;

 TLayoutObjectModel = class (TObjectDictionary<string, TObjectProperties>)
 private
    FPathList: TStringList;
    FObjectNameList: TStringList;
    FClassNameList: TStringList;
    procedure CreateLists;
    procedure GetSectionDetail(const ASection: string; var APath, AObjectName, AClassName: string);
    function CreateKey(const AObjectName, AClassName: string):string;
    procedure SplitKey(const Key:string; var AObjectName, AClassName: string);
    procedure ToList(List:TStrings);
    procedure AddItem(Item:TJsonObject);
    procedure LoadFromJson(JsonObject:TJsonArray); overload;

 public
    constructor Create;
    destructor Destroy; override;
    procedure BeginWriteObject(const AObjectName, AClassName: string);
    procedure WriteProperty(const AObjectName, AClassName, AName: string; AValue: Variant);
    procedure ClearObjectData(const AObjectFullName, AClassName: string);
    procedure ReadProperties(const AObjectName, AClassName: string; List: TStrings);
    procedure ReadChildren(const AObjectName, AClassName: string; AChildrenNames,  AChildrenClassNames: TStrings);
    function ReadProperty(const AObjectName, AClassName, AName: string): Variant;
    function ToJsonString:string;
    procedure ToJson(jArray:TJsonArray);
    procedure LoadFromJson(const Json:string); overload;
 end;



implementation


const
 ObjectNameSection = 'ObjectName';
 ClassNameSection = 'ClassName';

{ TJsonLayout }

procedure TLayoutObjectModel.AddItem(Item: TJsonObject);
var
  Obj:TObjectProperties;
  AName:string;
begin
  AName:=CreateKey(Item.GetValue(ObjectNameSection).Value,Item.GetValue(ClassNameSection).Value);
  Obj:=TObjectProperties.Create(Item);
  Self.Add(AName,Obj);
end;


procedure TLayoutObjectModel.BeginWriteObject(const AObjectName, AClassName: string);
var
 Obj:TObjectProperties;
 AKey:string;
begin
  AKey:=CreateKey(AObjectName, AClassName);
  if not ContainsKey(AKey) then
   begin
    Obj:=TObjectProperties.Create;
    Add(AKey,Obj);
   end;
end;


procedure TLayoutObjectModel.ClearObjectData(const AObjectFullName, AClassName: string);
begin

end;

constructor TLayoutObjectModel.Create;
begin
 inherited Create([doOwnsValues]);
end;


procedure TLayoutObjectModel.CreateLists;
var
  ASectionList: TStringList;
  I: Integer;
  APath: string;
  AObjectName: string;
  AClassName: string;
begin
  if (FPathList = nil) or (FObjectNameList = nil) or (FClassNameList = nil) then
  begin
    FPathList := TStringList.Create;
    FObjectNameList := TStringList.Create;
    FClassNameList := TStringList.Create;
    ASectionList := TStringList.Create;
    try
      Self.ToList(ASectionList);
      for I := 0 to ASectionList.Count - 1 do
      begin
        GetSectionDetail(ASectionList[I], APath, AObjectName, AClassName);
        FPathList.Add(UpperCase(APath));
        FObjectNameList.Add(AObjectName);
        FClassNameList.Add(AClassName);
      end;
    finally
      ASectionList.Free;
    end;
  end;
end;

destructor TLayoutObjectModel.Destroy;
begin
  FPathList.Free;
  FObjectNameList.Free;
  FClassNameList.Free;
  inherited;
end;

function TLayoutObjectModel.CreateKey(const AObjectName, AClassName: string): string;
begin
 Result:=AObjectName+':'+AClassName;
end;

procedure TLayoutObjectModel.GetSectionDetail(const ASection: string; var APath,  AObjectName, AClassName: string);
var
  I: Integer;
  AName: string;
begin
  AName := '';
  APath := '';
  AObjectName := '';
  AClassName := '';

  for I := 1 to Length(ASection) do
    if ASection[I] = '/' then
    begin
      APath := APath + AName + '/';
      AName := '';
    end
    else
      if ASection[I] = ':' then
      begin
        AObjectName := AName;
        AName := '';
      end
      else
        AName := AName + ASection[I];
  AClassName := Trim(AName);
end;


procedure TLayoutObjectModel.LoadFromJson(JsonObject: TJsonArray);
var
 x:Integer;
begin
 for x:=0 to JsonObject.Count-1 do
  AddItem(JsonObject.Items[x] as TJsonObject);
end;

procedure TLayoutObjectModel.LoadFromJson(const Json: string);
var
 Tmp:TJsonArray;
begin
Tmp:=TJsonObject.ParseJSONValue(Json) as TJsonArray;
 try
  LoadFromJson(Tmp);
 finally
  Tmp.Free;
 end;
end;

procedure TLayoutObjectModel.ReadChildren(const AObjectName, AClassName: string;  AChildrenNames, AChildrenClassNames: TStrings);
var
  I: Integer;
  AParentPath: string;
begin
  CreateLists;

  if AObjectName <> '' then
    AParentPath := UpperCase(AObjectName) + '/'
  else
    AParentPath := UpperCase(AObjectName);

  for I := 0 to FPathList.Count - 1 do
  begin
    if FPathList[I] = AParentPath then
    begin
      AChildrenNames.Add(FObjectNameList[I]);
      AChildrenClassNames.Add(FClassNameList[I]);
    end;
  end;
end;

procedure TLayoutObjectModel.ReadProperties(const AObjectName, AClassName: string;  List: TStrings);
var
 AKey:string;
begin
 AKey:=CreateKey(AObjectName, AClassName);
 if ContainsKey(AKey) then
   Self[AKey].ToList(List);

end;

function TLayoutObjectModel.ReadProperty(const AObjectName, AClassName,  AName: string): Variant;
var
 AKey:string;
begin
 AKey:=CreateKey(AObjectName, AClassName);
 if ContainsKey(AKey) then
   Result:=Self[AKey].ReadProperty(AName)
    else
   Result:=Null;
end;

procedure TLayoutObjectModel.SplitKey(const Key:string; var AObjectName, AClassName:string);
var
 AIndex:Integer;
begin
 AIndex:=Key.IndexOf(':');
 AObjectName:=Key.Substring(0, AIndex);
 AClassName:=Key.Substring(AIndex+1)
end;

procedure TLayoutObjectModel.ToJson(jArray: TJsonArray);
var
 s:string;
 Obj:TJsonObject;
 AObjectName:string;
 AClassName:string;
begin
 for s in Keys do
  begin
   Self.SplitKey(s, AObjectName, AClassName);
   Obj:=TJsonObject.Create;
   Obj.AddPair(ObjectNameSection, AObjectName);
   Obj.AddPair(ClassNameSection,AClassName);
   Self[s].ToJson(Obj);
   jArray.Add(Obj);
  end;
end;

function TLayoutObjectModel.ToJsonString: string;
var
 jArray:TJsonArray;
begin
jArray:=TJsonArray.Create;
 try
   Self.ToJson(jArray);
   Result:=TJsonUtils.Format(jArray);
 finally
   jArray.Free;
 end;
end;


procedure TLayoutObjectModel.ToList(List: TStrings);
var
 s:string;
begin
for s in Keys do
     List.Add(s);
end;

procedure TLayoutObjectModel.WriteProperty(const AObjectName, AClassName, AName: string; AValue: Variant);
var
 Obj:TObjectProperties;
 AKey:string;
begin
 AKey:=CreateKey(AObjectName, AClassName);
 Obj:=Self[AKey];
 Obj.Add(AName,AValue);
end;


{ TObjectProperties }

constructor TObjectProperties.Create(AOwner: TJsonObject);
begin
 inherited Create;
 LoadFromJson(AOwner);
end;

constructor TObjectProperties.Create;
begin
 inherited Create;
end;

destructor TObjectProperties.Destroy;
begin

  inherited;
end;

procedure TObjectProperties.LoadFromJson(JsonObject: TJsonObject);
var
 x:Integer;
 AName:string;
 AValue:Variant;
begin
 inherited Create;
 for x:=0 to JsonObject.Count-1 do
   begin
    AName:=JsonObject.Pairs[x].JsonString.Value;
    if (AName<>ObjectNameSection) and (AName<>ClassNameSection) then
     begin
      AValue:=JsonObject.Pairs[x].JsonValue.Value;
      AddOrSetValue(AName,AValue);
     end;
   end;
end;

function TObjectProperties.ReadProperty(const AName: string): Variant;
begin
 if Self.ContainsKey(AName) then
  Result:=Self[AName]
   else
  Result:=Null;
end;

procedure TObjectProperties.ToJson(JsonObject: TJsonObject);
var
 s:string;
begin
for s in Keys do
 JsonObject.AddPair(s,VarToStr(Self[s]));
end;

procedure TObjectProperties.ToList(List: TStrings);
var
 s:string;
begin
for s in Keys do
     List.Add(s);
end;

end.
