unit Mice.Script.ClassTree;

interface
 uses
 System.Classes,
 System.Generics.Collections,
 System.Generics.Defaults;

type
 TEntryType = (etEvent, etProperty, etMethod, etAppEvent);

 TScriptEntry = class
  strict private
    FDescription: string;
    FExample: string;
    FEntryType: TEntryType;
    FCaption: string;
  private
    FDataType: string;
  public
    property Caption:string read FCaption write FCaption;
    property Description:string read FDescription write FDescription;
    property Example:string read FExample write FExample;
    property DataType:string read FDataType write FDataType;
    property EntryType:TEntryType read FEntryType write FEntryType;
    constructor Create(const Caption, Description:string; EntryType:TEntryType);
 end;

 TClassEventsTree = class
  private
    FItems:TObjectDictionary<string, TObjectList<TScriptEntry>>;
    function RegisterItem(const ClassName, Caption, Description:string; EntryType: TEntryType):TScriptEntry;
  public
    procedure AddDialogControl(const ClassName:string);
    procedure RegisterClassEvent(const ClassName, Event, Description, Example:string);
    procedure RegisterAppEvent(const ClassName, Event, Description, Example:string);
    procedure RegisterClassMethod(const ClassName, MethodName, Description, Example:string);
    procedure RegisterClassProperty(const ClassName, PropertyName,  Description, PropertyType : string);
    procedure RegisterClassPropertyVariant(const ClassName, PropertyName, Description:string);
    procedure RegisterClassPropertyBoolean(const ClassName, PropertyName, Description:string);
    procedure RegisterClassPropertyInteger(const ClassName, PropertyName, Description:string);
    procedure RegisterClassPropertyString(const ClassName, PropertyName, Description:string);
    procedure RegisterClassPropertyFloat(const ClassName, PropertyName, Description:string);
    procedure RegisterClassPropertyDateTime(const ClassName, PropertyName, Description:string);
    property Items:TObjectDictionary<string, TObjectList<TScriptEntry>> read FItems;

    constructor Create;
    destructor Destroy; override;
    class function DefaultInstance: TClassEventsTree;
 end;

const
 SCommand = 'Application command';
 SStringUtils = 'TStringUtils';
 SDateUtils = 'TDateUtils';
 SGlobalSettings = 'TGlobalSettings';
 STxParams = 'TxParams';
 STxDataSet = 'TxDataSet';
 STAppTemplate = 'TAppTemplateBuilder';
 STMiceReport = 'TMiceReport';
 SAdaptiveDialog = 'TAdaptiveDialog';
 sTBasePlugin = 'TBasePlugin';
 SFunctions = 'Global functions';
 SDialogs = 'Dialogs';
 STMiceUser = 'TMiceUser';


implementation
var
 FDefaultInstance:TClassEventsTree;

constructor TScriptEntry.Create(const Caption, Description: string; EntryType:TEntryType);
begin
 Self.Caption:=Caption;
 Self.Description:=Description;
 Self.EntryType:=EntryType;
end;



{ TClassEventsTree }

procedure TClassEventsTree.AddDialogControl(const ClassName: string);
begin

end;

constructor TClassEventsTree.Create;
begin
 FItems:=TObjectDictionary<string, TObjectList<TScriptEntry>>.Create([doOwnsValues],TIStringComparer.Ordinal);
end;

class function TClassEventsTree.DefaultInstance: TClassEventsTree;
begin
 if not Assigned(FDefaultInstance) then
  FDefaultInstance:=TClassEventsTree.Create;
 Result:=FDefaultInstance;
end;

destructor TClassEventsTree.Destroy;
begin
 FItems.Free;
 inherited;
end;

procedure TClassEventsTree.RegisterAppEvent(const ClassName, Event, Description, Example: string);
var
 Entry:TScriptEntry;
begin
 Entry:=RegisterItem(ClassName, Event, Description, etAppEvent);
 Entry.Example:=Example;
end;

procedure TClassEventsTree.RegisterClassEvent(const ClassName, Event, Description, Example: string);
var
 Entry:TScriptEntry;
begin
 Entry:=RegisterItem(ClassName, Event, Description, etEvent);
 Entry.Example:=Example;
end;


procedure TClassEventsTree.RegisterClassMethod(const ClassName, MethodName, Description, Example: string);
var
 Entry:TScriptEntry;
begin
 Entry:=RegisterItem(ClassName, MethodName, Description, etMethod);
 Entry.Example:=Example;
end;

procedure TClassEventsTree.RegisterClassProperty(const ClassName, PropertyName,  Description, PropertyType : string);
var
 Entry:TScriptEntry;
begin
 Entry:=RegisterItem(ClassName, PropertyName, Description, etProperty);
 Entry.DataType:=PropertyType;
end;

procedure TClassEventsTree.RegisterClassPropertyBoolean(const ClassName, PropertyName, Description: string);
var
 Entry:TScriptEntry;
begin
 Entry:=RegisterItem(ClassName, PropertyName, Description, etProperty);
 Entry.DataType:='Boolean';
end;

procedure TClassEventsTree.RegisterClassPropertyDateTime(const ClassName, PropertyName, Description: string);
var
 Entry:TScriptEntry;
begin
 Entry:=RegisterItem(ClassName, PropertyName, Description, etProperty);
 Entry.DataType:='Datetime';
end;

procedure TClassEventsTree.RegisterClassPropertyFloat(const ClassName,  PropertyName, Description: string);
var
 Entry:TScriptEntry;
begin
 Entry:=RegisterItem(ClassName, PropertyName, Description, etProperty);
 Entry.DataType:='Double';
end;

procedure TClassEventsTree.RegisterClassPropertyInteger(const ClassName, PropertyName, Description: string);
var
 Entry: TScriptEntry;
begin
 Entry:=RegisterItem(ClassName, PropertyName, Description, TEntryType.etProperty);
 Entry.Caption:=PropertyName;
 Entry.DataType:='Integer';
end;

procedure TClassEventsTree.RegisterClassPropertyString(const ClassName, PropertyName, Description: string);
var
 Entry: TScriptEntry;
begin
 Entry:=RegisterItem(ClassName, PropertyName, Description, etProperty);
 Entry.DataType:='string';
end;

procedure TClassEventsTree.RegisterClassPropertyVariant(const ClassName, PropertyName, Description: string);
var
 Entry: TScriptEntry;
begin
 Entry:=RegisterItem(ClassName, PropertyName, Description, etProperty);
 Entry.DataType:='Variant';
end;

function TClassEventsTree.RegisterItem(const ClassName, Caption, Description:string; EntryType: TEntryType):TScriptEntry;
var
 AList:TObjectList<TScriptEntry>;
begin
 if not Items.ContainsKey(ClassName) then
  Items.Add(ClassName,TObjectList<TScriptEntry>.Create(True));

  Result:=TScriptEntry.Create(Caption, Description,  EntryType);
  AList:=Items[ClassName];
  AList.Add(Result);
end;



initialization

finalization
 FDefaultInstance.Free;

end.
