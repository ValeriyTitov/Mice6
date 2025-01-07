unit ManagerEditor.Script.PascalScript.DataTreeBuilder;

interface
uses Vcl.ComCtrls, Data.DB, System.SysUtils, System.Classes, cxTreeView,
     System.Generics.Collections,
     Dialog.Layout.ControlList,
     Common.Images,
     DAC.XDataSet,
     Mice.Script.ClassTree,
     System.RTTI,
     System.TypInfo;

type
TDataTreeBuilder = class
  private
    FClassList:TStringList;
    FTree:TcxTreeView;
    FExcludeList:TList<string>;
    FInstnaceList:TStringList;

    function CreateEventGroup(Parent:TTreeNode):TTreeNode;
    function CreateMethodGroup(Parent:TTreeNode):TTreeNode;
    function CreatePropertiesGroup(Parent:TTreeNode):TTreeNode;
    function CreateEventEntry(Parent:TTreeNode; Entry:TScriptEntry):TTreeNode;
    function CreatePropertyEntry(Parent:TTreeNode; Entry:TScriptEntry):TTreeNode;
    function CreateMethodEntry(Parent:TTreeNode; Entry:TScriptEntry):TTreeNode;
    function FindImageIndex(const Name:string):Integer;
    procedure PopulateClassMethods(Parent:TTreeNode; const AClassName:string);
    procedure CreateClass(Parent:TTreeNode; const AClassName:string; ImageIndex:Integer);
    procedure PopulateClass(Parent:TTreeNode; List: TObjectList<TScriptEntry>; AddAppEvents:Boolean);
    procedure PopulatePluginFilters(AppPluginsId:Integer);
    procedure PopulateInstanceList(Parent:TTreeNode);
    procedure PopulatePlugin2;
    procedure PopulateDialog(AppDialogsId:Integer);
    procedure PopulateCommand;
    procedure PopulateCommandEvents(Parent:TTreeNode);
    procedure PopulateDialogControls(Parent:TTreeNode;AppDialogsId:Integer);
    procedure PopulateControlItem(Parent:TTreeNode; DataSet:TDataSet);
    procedure PopulateControlEvents(Parent:TTreeNode; const AClassName:string);
    procedure PopulateControlProperties(Parent:TTreeNode; const AClassName:string);
    procedure PopulateControlRtti(Parent:TTreeNode; const AClassName:string);

    procedure PopulateClasses;
    procedure PopulateInstances;
    procedure PopulateOther;
  public
    procedure PopulateTreeForDialog(AppDialogsId:Integer);
    procedure PopulateTreeForPlugin(AppPluginsId:Integer);
    procedure PopulateTreeForCommand(AppCmdId:Integer);

    constructor Create(Tree:TcxTreeView);
    destructor Destroy; override;
end;

implementation

resourcestring
 S_COMMAND = 'Application command';
 S_ACTIVEPLUGIN = 'ActivePlugin';
 S_DIALOG = 'Dialog(Self)';
 S_PLUGIN = 'Plugin(Self)';
 S_EVENTS = 'Events';
 S_METHODS = 'Methods';
 S_PROPERTIES = 'Properties';
 S_CONTROL_RTTI = 'RTTI';
 S_DIALOG_CONTROLS = 'Controls';
 S_PLUGIN_FILTERS = 'Filters';
 S_UTILS = 'Utilites';
 S_CLASSES = 'Classes';
 S_OTHER = 'Other';
 S_INSTANCES = 'Instances';


{ TDataTreeBuilder }

constructor TDataTreeBuilder.Create(Tree:TcxTreeView);
begin
  FClassList:=TStringList.Create;
  FTree:=Tree;
  FExcludeList:=TList<string>.Create;
  FExcludeList.Add(sTBasePlugin);
  FExcludeList.Add(SCommand);
  FExcludeList.Add(SStringUtils);
  FExcludeList.Add(SDateUtils);
  FExcludeList.Add(STMiceUser);
  FExcludeList.Add(STMiceUser);
  FExcludeList.Add(SDialogs);
  FExcludeList.Add(SFunctions);
  FExcludeList.Add(SGlobalSettings);

  FInstnaceList:=TStringList.Create;
  FInstnaceList.Add('StringUtils=TStringUtils');
  FInstnaceList.Add('DateUtils=TDateUtils');
  FInstnaceList.Add('GlobalSettings=TGlobalSettings');
  FInstnaceList.AddObject('CurrentUser=TMiceUser',TOBject(1));
  FInstnaceList.AddObject('ActivePlugin=TBasePlugin',TOBject(1));
end;

procedure TDataTreeBuilder.CreateClass(Parent: TTreeNode; const AClassName: string; ImageIndex: Integer);
var
 Item:TTreeNode;
begin
 Item:=FTree.Items.AddChild(Parent,AClassName);
 Item.ImageIndex:=ImageIndex;
 Item.SelectedIndex:=ImageIndex;
 PopulateClass(Item,TClassEventsTree.DefaultInstance.Items[AClassName], False);
end;

function TDataTreeBuilder.CreateEventEntry(Parent:TTreeNode;Entry: TScriptEntry): TTreeNode;
begin
 Result:=FTree.Items.AddChild(Parent,Entry.Caption);
 Result.ImageIndex:=IMAGEINDEX_SCRIPT_TREE_EVENT_ENTRY;
 Result.SelectedIndex:=Result.ImageIndex;
 Result.Data:=Entry;
end;

function TDataTreeBuilder.CreateEventGroup(Parent: TTreeNode): TTreeNode;
begin
 Result:=FTree.Items.AddChild(Parent,S_EVENTS);
 Result.ImageIndex:=IMAGEINDEX_SCRIPT_TREE_EVENTS_GROUP;
 Result.SelectedIndex:=Result.ImageIndex;
end;

function TDataTreeBuilder.CreateMethodEntry(Parent: TTreeNode; Entry: TScriptEntry): TTreeNode;
begin
 Result:=FTree.Items.AddChild(Parent,Entry.Caption);
 Result.ImageIndex:=IMAGEINDEX_SCRIPT_TREE_METHODS_ENTRY;
 Result.SelectedIndex:=Result.ImageIndex;
 Result.Data:=Entry;
end;

function TDataTreeBuilder.CreateMethodGroup(Parent: TTreeNode): TTreeNode;
begin
 Result:=FTree.Items.AddChild(Parent,S_METHODS);
 Result.ImageIndex:=IMAGEINDEX_SCRIPT_TREE_METHODS_GROUP;
 Result.SelectedIndex:=Result.ImageIndex;
end;

function TDataTreeBuilder.CreatePropertiesGroup(Parent: TTreeNode): TTreeNode;
begin
 Result:=FTree.Items.AddChild(Parent,S_PROPERTIES);
 Result.ImageIndex:=IMAGEINDEX_SCRIPT_TREE_PROPERTIES_GROUP;
 Result.SelectedIndex:=IMAGEINDEX_SCRIPT_TREE_PROPERTIES_GROUP;
end;

function TDataTreeBuilder.CreatePropertyEntry(Parent: TTreeNode; Entry: TScriptEntry): TTreeNode;
begin
 Result:=FTree.Items.AddChild(Parent,Entry.Caption+':'+Entry.DataType);
 Result.ImageIndex:=IMAGEINDEX_SCRIPT_TREE_PROPERTIES_ENTRY;
 Result.SelectedIndex:=IMAGEINDEX_SCRIPT_TREE_PROPERTIES_ENTRY;
 Result.Data:=Entry;
end;

destructor TDataTreeBuilder.Destroy;
begin
  FExcludeList.Free;
  FClassList.Free;
  FInstnaceList.Free;
  inherited;
end;

function TDataTreeBuilder.FindImageIndex(const Name: string): Integer;
begin
 if TDialogLayoutControlList.DefaultInstance.ContainsKey(Name) then
  Result:=TDialogLayoutControlList.DefaultInstance[Name].ImageIndex
   else
  Result:=IMAGEINDEX_QUESTION;
end;

procedure TDataTreeBuilder.PopulateClass(Parent: TTreeNode; List: TObjectList<TScriptEntry>; AddAppEvents:Boolean);
var
 Entry:TScriptEntry;
 Events, Methods, Props:TTreeNode;
begin
 Events:=nil;
 Methods:=nil;
 Props:=nil;
 for Entry in List do
  case Entry.EntryType of
   etEvent:    begin
                 if not Assigned(Events) then
                  Events:=CreateEventGroup(Parent);
                  CreateEventEntry(Events,Entry);
               end;
   etProperty: begin
                 if not Assigned(Props) then
                  Props:=CreatePropertiesGroup(Parent);
                 CreatePropertyEntry(Props,Entry);
               end;
   etMethod: begin
               if not Assigned(Methods) then
                Methods:=CreateMethodGroup(Parent);
               CreateMethodEntry(Methods,Entry);
              end;
   etAppEvent: if AddAppEvents then
                begin
                 if not Assigned(Events) then
                  Events:=CreateEventGroup(Parent);
                   CreateEventEntry(Events,Entry);
                end;
  end;
end;

procedure TDataTreeBuilder.PopulateClassMethods(Parent: TTreeNode; const AClassName: string);
var
  Entry:TScriptEntry;
begin
  if TClassEventsTree.DefaultInstance.Items.ContainsKey(AClassName) then
   for Entry in TClassEventsTree.DefaultInstance.Items[AClassName] do
    if Entry.EntryType=TEntryType.etMethod then
     CreateMethodEntry(Parent,Entry);
end;

procedure TDataTreeBuilder.PopulateCommand;
var
 Item:TTreeNode;
begin
 Item:=FTree.Items.Add(nil,S_COMMAND);
 Item.ImageIndex:=245;
 Item.SelectedIndex:=245;
 PopulateCommandEvents(Item);
end;

procedure TDataTreeBuilder.PopulateCommandEvents(Parent: TTreeNode);
var
 Item:TTreeNode;
 Entry: TScriptEntry;
begin
  Item:=Self.CreateEventGroup(Parent);
  if TClassEventsTree.DefaultInstance.Items.ContainsKey(SCommand) then
   for Entry in TClassEventsTree.DefaultInstance.Items[SCommand] do
    if Entry.EntryType=TEntryType.etAppEvent then
     CreateEventEntry(Item, Entry);
end;

procedure TDataTreeBuilder.PopulateControlEvents(Parent: TTreeNode; const AClassName: string);
var
 Entry:TScriptEntry;
begin
if TClassEventsTree.DefaultInstance.Items.ContainsKey(AClassName) then
 for Entry in TClassEventsTree.DefaultInstance.Items[AClassName] do
  if Entry.EntryType=TEntryType.etEvent then
    CreateEventEntry(Parent, Entry);
end;

procedure TDataTreeBuilder.PopulateControlItem(Parent: TTreeNode; DataSet: TDataSet);
var
 AClassName:string;
 AName:string;
 AIndex:Integer;
 Item:TTreeNode;
 Item2:TTreeNode;
 AOwner:TTreeNode;
begin
 AClassName:=DataSet.FieldByName('ClassName').AsString;
 AIndex:=FClassList.IndexOf(AClassName);
 if AIndex<0 then
  begin
   Item:=FTree.Items.AddChild(Parent,AClassName);
   Item.ImageIndex:=FindImageIndex(AClassName);
   Item.SelectedIndex:=Item.ImageIndex;

   PopulateControlProperties(Item,AClassName);
   PopulateControlRtti(Item, AClassName);


   AIndex:=FClassList.AddObject(AClassName, Item);
  end;
 AOwner:=FClassList.Objects[AIndex] as TTreeNode;


 AName:=DataSet.FieldByName('ControlName').AsString;
 Item2:=FTree.Items.AddChild(AOwner,AName);
 Item2.ImageIndex:=AOwner.ImageIndex;
 Item2.SelectedIndex:=AOwner.ImageIndex;
 PopulateControlEvents(Item2, AClassName);
end;

procedure TDataTreeBuilder.PopulateControlProperties(Parent: TTreeNode; const AClassName: string);
var
 Item:TTreeNode;
 Entry: TScriptEntry;
begin
  Item:=CreatePropertiesGroup(Parent);
  if TClassEventsTree.DefaultInstance.Items.ContainsKey(AClassName) then
   for Entry in TClassEventsTree.DefaultInstance.Items[AClassName] do
    if Entry.EntryType=TEntryType.etProperty then
     CreatePropertyEntry(Item,Entry);
end;

procedure TDataTreeBuilder.PopulateControlRtti(Parent: TTreeNode; const AClassName: string);
var
 Item:TTreeNode;
 LContext: TRttiContext;
 LType: TRttiType;
 LMethod: TRttiMethod;
 LProperty: TRttiProperty;
 Child, Child1, Child2: TTreeNode;
 ParentClassName:string;

begin
if TDialogLayoutControlList.DefaultInstance.ContainsKey(AClassName) then
 begin
 {
    оличество свойств специально ограничено только текущим контролом и его перентом.
   »наче получаетс€ очень много свойств, от каждого наследника.
   ќт TObject до ClassName
 }

  LContext := TRttiContext.Create;
  try
   Item:=FTree.Items.AddChild(Parent,S_CONTROL_RTTI);
   Item.ImageIndex:=483;
   Item.SelectedIndex:=483;

   Child1:=FTree.Items.AddChild(Item, S_METHODS);
   Child1.ImageIndex:=284;
   Child1.SelectedIndex:=284;
   Child1.Data:=nil;

   Child2:=FTree.Items.AddChild(Item, S_PROPERTIES);
   Child2.ImageIndex:=284;
   Child2.SelectedIndex:=284;
   Child2.Data:=nil;

   LType := LContext.GetType(TDialogLayoutControlList.DefaultInstance[AClassName].ControlClass);
   ParentClassName:=TDialogLayoutControlList.DefaultInstance[AClassName].ControlClass.ClassParent.ClassName;
   for LMethod in LType.GetMethods do
    if (LMethod.Visibility=TMemberVisibility.mvPublic) and ((LMethod.Parent.ToString=AClassName)  or (ParentClassName=LMethod.Parent.ToString)) then
     begin
      Child:=FTree.Items.AddChild(Child1, LMethod.Parent.ToString +'.'+LMethod.ToString);
      Child.ImageIndex:=12;
      Child.SelectedIndex:=12;
      Child.Data:=nil;
     end;

   for LProperty in LType.GetProperties do
     if (LProperty.Visibility=TMemberVisibility.mvPublished) and ((LProperty.Parent.ToString=AClassName) or (LProperty.Parent.ToString=ParentClassName)) then
      begin
       Child:=FTree.Items.AddChild(Child2, LProperty.Parent.ToString+'.'+ LProperty.ToString);
       Child.ImageIndex:=87;
       Child.SelectedIndex:=87;
       Child.Data:=nil;
      end;

  finally
    LContext.Free;
  end;
 end;

end;

procedure TDataTreeBuilder.PopulateDialog(AppDialogsId:Integer);
var
 Item:TTreeNode;
 AControls:TTreeNode;
begin
 Item:=FTree.Items.Add(nil,S_DIALOG);
 Item.ImageIndex:=181;
 Item.SelectedIndex:=181;
 PopulateClass(Item, TClassEventsTree.DefaultInstance.Items[SAdaptiveDialog], True);

 AControls:=FTree.Items.AddChild(Item,S_DIALOG_CONTROLS);
 AControls.ImageIndex:=313;
 AControls.SelectedIndex:=313;
 PopulateDialogControls(AControls, AppDialogsId);
end;


procedure TDataTreeBuilder.PopulateDialogControls(Parent: TTreeNode; AppDialogsId: Integer);
var
 DataSet:TxDataSet;
begin
  DataSet:=TxDataSet.Create(nil);
  try
   DataSet.ProviderName:='spui_AppDialogControlList';
   DataSet.SetParameter('AppDialogsId', AppDialogsId);
   DataSet.Source:='TDataTreeBuilder.PopulateTree';
   DataSet.Open;
   while not DataSet.Eof do
    begin
     PopulateControlItem(Parent, DataSet);
     DataSet.Next;
    end;
   finally
    DataSet.Free;
  end;
end;

procedure TDataTreeBuilder.PopulateInstanceList(Parent: TTreeNode);
var
 Item:TTreeNode;
 x:Integer;
 AClassName:string;
begin
 for x:=0 to FInstnaceList.Count-1 do
   begin
    Item:=FTree.Items.AddChild(Parent,FInstnaceList.Names[x]);
    Item.ImageIndex:=184;
    Item.SelectedIndex:=184;
    AClassName:=FInstnaceList.ValueFromIndex[x];
    if FInstnaceList.Objects[x]=nil then
     PopulateClassMethods(Item,AClassName)
      else
     PopulateClass(Item,TClassEventsTree.DefaultInstance.Items[AClassName], False);
   end;
end;

procedure TDataTreeBuilder.PopulateInstances;
var
 Item:TTreeNode;
begin
 Item:=FTree.Items.Add(nil,S_INSTANCES);
 Item.ImageIndex:=182;
 Item.SelectedIndex:=182;
 PopulateInstanceList(Item);
end;

procedure TDataTreeBuilder.PopulateOther;
var
 Item:TTreeNode;
 Root:TTreeNode;

begin
 Root:=FTree.Items.Add(nil,S_OTHER);
 Root.ImageIndex:=IMAGEINDEX_SCRIPT_TREE_OTHER_ENTRY;
 Root.SelectedIndex:=IMAGEINDEX_SCRIPT_TREE_OTHER_ENTRY;

 Item:=FTree.Items.AddChild(Root,sDialogs);
 Item.ImageIndex:=184;
 Item.SelectedIndex:=184;
 PopulateClassMethods(Item,sDialogs);

 CreateClass(Root,sFunctions,IMAGEINDEX_SCRIPT_TREE_CLASSES_ENTRY);
end;

procedure TDataTreeBuilder.PopulatePlugin2;
var
 Item:TTreeNode;
begin
 Item:=FTree.Items.Add(nil,S_PLUGIN);
 Item.ImageIndex:=181;
 Item.SelectedIndex:=181;
 PopulateClass(Item, TClassEventsTree.DefaultInstance.Items[sTBasePlugin],True);
end;




procedure TDataTreeBuilder.PopulatePluginFilters(AppPluginsId:Integer);
var
 DataSet:TxDataSet;
 Item:TTreeNode;
begin
 DataSet:=TxDataSet.Create(nil);
  try
   DataSet.ProviderName:='spui_AppGetPluginCommands';
   DataSet.SetParameter('AppPluginsId', AppPluginsId);
   DataSet.Source:='TDataTreeBuilder.PopulateTreeForPlugin';
   DataSet.Open;
   Item:=FTree.Items.Add(nil,S_PLUGIN_FILTERS);
   Item.ImageIndex:=313;
   Item.SelectedIndex:=313;
   while not DataSet.Eof do
    begin
     // Self.PopulateControlItem(Tree, Item, DataSet);
      DataSet.Next;
    end;
  finally
   DataSet.Free;
  end;
end;

procedure TDataTreeBuilder.PopulateTreeForCommand(AppCmdId: Integer);
begin
 PopulateCommand;
 PopulateClasses;
 PopulateInstances;
 PopulateOther;
end;

procedure TDataTreeBuilder.PopulateTreeForDialog(AppDialogsId: Integer);
begin
  PopulateDialog(AppDialogsId);
  PopulateClasses;
  PopulateInstances;
  PopulateOther;
end;

procedure TDataTreeBuilder.PopulateTreeForPlugin(AppPluginsId: Integer);
begin
  PopulatePlugin2;
  PopulatePluginFilters(AppPluginsId);
  PopulateClasses;
  PopulateInstances;
  PopulateOther;
end;

procedure TDataTreeBuilder.PopulateClasses;
var
 Item:TTreeNode;
 s:string;
begin
 Item:=FTree.Items.Add(nil,S_CLASSES);
 Item.ImageIndex:=IMAGEINDEX_SCRIPT_TREE_CLASSES_GROUP;
 Item.SelectedIndex:=IMAGEINDEX_SCRIPT_TREE_CLASSES_GROUP;
 for s in TClassEventsTree.DefaultInstance.Items.Keys do
  if not TDialogLayoutControlList.DefaultInstance.ContainsKey(s) and (not FExcludeList.Contains(s)) then
   CreateClass(Item,s,IMAGEINDEX_SCRIPT_TREE_CLASSES_ENTRY);
end;

end.
