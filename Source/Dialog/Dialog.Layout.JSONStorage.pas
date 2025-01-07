unit Dialog.Layout.JSONStorage;

interface
 uses System.SysUtils, System.Json, REST.Json, cxStorage, System.Classes,
      System.Variants, System.JSON.Writers, System.JSON.Types,
      System.Generics.Collections, System.Generics.Defaults,
      Dialog.Layout.JSONStorage.ObjectModel,
      Dialog.Layout.JsonStorage.Buffer,
      Common.JsonUtils;


type
 TMiceJsonReader = class(TcxCustomReader)
  private
    FStorageName:string;
    FJsonLayout:TLayoutObjectModel;
  public
    constructor Create(const AStorageName: string; AStorageStream: TStream); override;
    destructor Destroy; override;
    procedure ReadProperties(const AObjectName, AClassName: string; AProperties: TStrings); override;
    function ReadProperty(const AObjectName, AClassName, AName: string): Variant; override;
    procedure ReadChildren(const AObjectName, AClassName: string; AChildrenNames, AChildrenClassNames: TStrings); override;
  end;

  TMiceJsonWriter = class(TcxCustomWriter)
  private
    FStorageName:string;
    FJsonLayout:TLayoutObjectModel;
  protected
    procedure EndWrite; override;
    procedure ClearObjectData(const AObjectFullName, AClassName: string); override;
  public
    constructor Create(const AStorageName: string; AStream: TStream; AReCreate: Boolean = True); overload; override;
    destructor Destroy; override;
    procedure BeginWriteObject(const AObjectName, AClassName: string); override;
    procedure WriteProperty(const AObjectName, AClassName, AName: string; AValue: Variant); override;
  end;


implementation

{ TMiceJsonWriter }

constructor TMiceJsonWriter.Create(const AStorageName: string; AStream: TStream;  AReCreate: Boolean);
begin
  inherited;
  FStorageName:=AStorageName;
  FJsonLayout:=TLayoutObjectModel.Create;
end;

destructor TMiceJsonWriter.Destroy;
begin
  FJsonLayout.Free;
  inherited;
end;

procedure TMiceJsonWriter.BeginWriteObject(const AObjectName,  AClassName: string);
begin
  FJsonLayout.BeginWriteObject(AObjectName, AClassName);
end;

procedure TMiceJsonWriter.ClearObjectData(const AObjectFullName, AClassName: string);
begin
 FJsonLayout.ClearObjectData(AObjectFullName,AClassName);
end;

procedure TMiceJsonWriter.EndWrite;
begin
  inherited;
  TDialogLayoutStorageBuffer.DefaultInstance.Add(FStorageName,FJsonLayout.ToJsonString);
end;

procedure TMiceJsonWriter.WriteProperty(const AObjectName, AClassName,  AName: string; AValue: Variant);
begin
 FJsonLayout.WriteProperty(AObjectName, AClassName,  AName, AValue);
end;


{ TMiceJsonReader }

constructor TMiceJsonReader.Create(const AStorageName: string; AStorageStream: TStream);
begin
  inherited;
  FStorageName:=AStorageName;
  FJsonLayout:=TLayoutObjectModel.Create;
  try
   FJsonLayout.LoadFromJson(TDialogLayoutStorageBuffer.DefaultInstance[FStorageName]);
  except
   TJsonUtils.RaiseParseError;
  end;
end;

destructor TMiceJsonReader.Destroy;
begin
  FJsonLayout.Free;
  inherited;
end;

procedure TMiceJsonReader.ReadChildren(const AObjectName, AClassName: string;  AChildrenNames, AChildrenClassNames: TStrings);
begin
 FJsonLayout.ReadChildren(AObjectName,AClassName,AChildrenNames,AChildrenClassNames);
end;

procedure TMiceJsonReader.ReadProperties(const AObjectName, AClassName: string;   AProperties: TStrings);
begin
 FJsonLayout.ReadProperties(AObjectName, AClassName, AProperties);
end;

function TMiceJsonReader.ReadProperty(const AObjectName, AClassName,   AName: string): Variant;
begin
 Result:=FJsonLayout.ReadProperty(AObjectName, AClassName,AName);
end;


end.
