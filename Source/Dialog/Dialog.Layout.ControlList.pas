unit Dialog.Layout.ControlList;

{
Добовление нового контрола:
 1. Создать контрол, так же жолжен быть метод <ClassName>.DevDescription
 2. Создать для нового контрола и новый редактор свойств, наследник от TControlEditorBase
 3. Зарегистрировать контрол в TDialogLayoutControlList.constructor.
 4. Зарегистрировать редактор свойств в секции initialization формы редактора.
}

interface
 uses System.Classes, System.SysUtils, System.Generics.Collections, Controls,
      System.Generics.Defaults, Data.DB,  Forms,
      DAC.XParams,
      DAC.DatabaseUtils,
      Common.StringUtils,
      Common.ResourceStrings,
      CustomControl.MiceButton,
      CustomControl.MiceTextEdit,
      CustomControl.MiceCheckBox,
      CustomControl.MiceDateEdit,
      CustomControl.MiceMemo,
      CustomControl.MiceDropDown,
      CustomControl.MiceEditableGridFrame,
      CustomControl.MiceGridFrame,
      CustomControl.MiceTreeGridFrame,
      CustomControl.MiceCurrencyEdit,
      CustomControl.MiceValuePicker,
      CustomControl.MiceRadioGroup,
      CustomControl.MiceVerticalGrid,
      CustomControl.MiceClientEdit;



 type
  TMiceControl = class of TControl;

  TDialogLayoutControl = class
  strict private
    FControlClass: TMiceControl;
    FImageIndex: Integer;
    FSuggestField: string;
    FSuggestCaption: string;
    FNamePattern: string;
    FDescription: string;
  public
    property ControlClass : TMiceControl read FControlClass write FControlClass;
    property SuggestField:string read FSuggestField write FSuggestField;
    property SuggestCaption:string read FSuggestCaption write FSuggestCaption;
    property ImageIndex:Integer read FImageIndex write FImageIndex;
    property NamePattern : string read FNamePattern write FNamePattern;
    property Description : string read FDescription write FDescription;
  end;

  TDialogLayoutControlList = class(TObjectDictionary<string,TDialogLayoutControl>)
  private
   function ControlExists(DataSet:TDataSet; const FieldName:string):Boolean;
  protected
   function RegisterClass(AControlClass:TMiceControl; const ASuggestField,DefaultNamePrefix:string; ImageIndex:Integer; const Description:string):Integer;
   function FindProperControlForField(AField:TDatabaseColumn):TDialogLayoutControl;
   function FindControlCommonCaption(const DataField:string; Item: TDialogLayoutControl):string;
   procedure SetControlData(DataSet:TDataSet; Item:TDialogLayoutControl; const AFieldName:string; AddTableName:Boolean);
   procedure CreateControlForField(AField:TDatabaseColumn; DataSet:TDataSet;AddTableName:Boolean; const ATableName:string);
  public
   class function DefaultInstance: TDialogLayoutControlList;
   class function CreateControlName(const DataField, ControlClassStr:string):string;
   constructor Create;
   procedure FindControlsForTable(const ATableName, DBName:string; DataSet:TDataSet;AddTableName:Boolean);
  end;

implementation

{ TDialogLayoutControlList }

var
 FDefaultInstance:TDialogLayoutControlList;

procedure TDialogLayoutControlList.CreateControlForField(AField:TDatabaseColumn; DataSet: TDataSet; AddTableName:Boolean; const ATableName:string);
var
 Item: TDialogLayoutControl;
 AColumnName:string;
begin
 if AddTablename then
  AColumnName:=ATableName+'.'+ AField.ColumnName
   else
  AColumnName:=AField.ColumnName;


 Item:=FindProperControlForField(AField);
 if not ControlExists(DataSet,AColumnName) then
  begin
   DataSet.Append;
   DataSet.FieldByName('AppDialogControlsId').AsInteger:=TDataBaseUtils.NewAppObjectId(sq_AppDialogControls);
//   if not ADBName.IsEmpty then
//    DataSet.FieldByName('DBName').AsString:=ADBName;
   SetControlData(DataSet,Item,AColumnName, AddTableName);
  end;
end;

class function TDialogLayoutControlList.CreateControlName(const DataField, ControlClassStr: string): string;
var
 ACompleteFieldName:string;
begin
 ACompleteFieldName:=DataField.Replace('.','');
 Result:=Format(DefaultInstance[ControlClassStr].NamePattern,[ACompleteFieldName]);
end;

function TDialogLayoutControlList.ControlExists(DataSet: TDataSet; const FieldName: string): Boolean;
begin
 Result:=False;
 DataSet.First;
  while not DataSet.Eof do
   begin
    if TStringUtils.SameString(DataSet.FieldByName('DataField').AsString, FieldName) then
       Exit(True);
     DataSet.Next;
   end;
end;

constructor TDialogLayoutControlList.Create;
begin
 inherited Create([doOwnsValues],TIStringComparer.Ordinal);
 RegisterClass(TMiceGridFrame,'','Grid%s',163,TMiceGridFrame.DevDescription);
 RegisterClass(TMiceTreeGridFrame,'','TreeGrid%s',654,TMiceTreeGridFrame.DevDescription);
 RegisterClass(TMiceEditableGridFrame,'','edGrid%s',212,TMiceEditableGridFrame.DevDescription);
 RegisterClass(TMiceButton,'','btn%s',94, TMiceButton.DevDescription);
 RegisterClass(TMiceTextEdit,'','ed%s',632, TMiceTextEdit.DevDescription);
 RegisterClass(TMiceCheckBox,'','chbox%s',124, TMiceCheckBox.DevDescription);
 RegisterClass(TMiceDateEdit,'','DateEdit%s',169, TMiceDateEdit.DevDescription);
 RegisterClass(TMiceMemo,'','memo%s',506,TMiceMemo.DevDescription);
 RegisterClass(TMiceDropDown,'','dd%s',199, TMiceDropDown.DevDescription);
 RegisterClass(TMiceCurrencyEdit,'CurrencyId','CurrEdit%s',153, TMiceCurrencyEdit.DevDescription);
 RegisterClass(TMiceValuePicker,'','vpick%s',329, TMiceValuePicker.DevDescription);
 RegisterClass(TMiceRadioGroup,'','rg%s',486, TMiceRadioGroup.DevDescription);
 RegisterClass(TMiceVericalGrid,'','VertGrid%s',33, TMiceVericalGrid.DevDescription);
 RegisterClass(TMiceClientEdit,'ClientsId','ce%s',126, TMiceClientEdit.DevDescription);

end;

class function TDialogLayoutControlList.DefaultInstance: TDialogLayoutControlList;
begin
 if not Assigned(FDefaultInstance) then
   FDefaultInstance:=TDialogLayoutControlList.Create;
  Result:= FDefaultInstance;
end;


function TDialogLayoutControlList.FindControlCommonCaption(const DataField: string; Item: TDialogLayoutControl): string;
var
 List:TStringList;
begin
 List:=TStringList.Create;
 try
  TDataBaseUtils.FindCommonCaptionList(DataField,List);
  if List.Count>0 then
   Result:=List[0]
    else
     begin
      if Item.ControlClass=TMiceDateEdit then
       Result:=TMiceDateEdit.FindProperCaption(DataField)
        else
       Result:=DataField;
     end;
 finally
  List.Free;
 end;

end;

procedure TDialogLayoutControlList.FindControlsForTable(const ATableName, DBName: string; DataSet: TDataSet; AddTableName:Boolean);
var
 List:TDataBaseColumnList;
 Column:TDatabaseColumn;
 B:TBookmark;
begin
 B:=DataSet.Bookmark;
 List:=TDataBaseColumnList.Create;
 try
  DataSet.DisableControls;
  TDatabaseUtils.GetTableColumns(ATableName, List, DBName);
  for Column in List do
    CreateControlForField(Column,DataSet, AddTableName, ATableName);
 finally
  List.Free;
  DataSet.EnableControls;
  DataSet.Bookmark:=B;
 end;
end;

function TDialogLayoutControlList.FindProperControlForField(AField:TDatabaseColumn): TDialogLayoutControl;
var
 s:string;
begin
if AField.DataType=ftBoolean then
 Exit(Items[TMiceCheckBox.ClassName]);

if (AField.DataType=ftDate) or (AField.DataType=ftDateTime)  then
 Exit(Items[TMiceDateEdit.ClassName]);

if (AField.DataType=ftString) and (AField.CharacterMaximumLength>255)  then
 Exit(Items[TMiceMemo.ClassName]);

if (AField.DataType=ftInteger) and (AField.ColumnName.ToLower.Contains('curr'))  then
 Exit(Items[TMiceCurrencyEdit.ClassName]);

 Result:=Items[TMiceTextEdit.ClassName];

 for s in Keys do
  if AnsiLowerCase(Items[s].SuggestField).Contains(AnsiLowerCase(AField.ColumnName)) then
     Exit(Items[s]);

end;


function TDialogLayoutControlList.RegisterClass(AControlClass: TMiceControl; const ASuggestField,DefaultNamePrefix: string; ImageIndex: Integer; const Description:string): Integer;
var
 Item:TDialogLayoutControl;
begin
 Item:=TDialogLayoutControl.Create;
 Item.ControlClass:=AControlClass;
 Item.SuggestField:=ASuggestField;
 Item.NamePattern:=DefaultNamePrefix;
 Item.ImageIndex:=ImageIndex;
 Item.Description:=Description;
 Self.Add(AControlClass.ClassName, Item);
 Result:=Count;
end;


procedure TDialogLayoutControlList.SetControlData(DataSet: TDataSet; Item: TDialogLayoutControl; const AFieldName:string; AddTableName:Boolean);
begin
 DataSet.FieldByName('ClassName').AsString:=Item.ControlClass.ClassName;
 DataSet.FieldByName('ControlName').AsString:=CreateControlName(AFieldName,Item.ControlClass.ClassName);
 DataSet.FieldByName('Caption').AsString:=FindControlCommonCaption(AFieldName, Item);
 DataSet.FieldByName('DataField').AsString:=AFieldName;
 DataSet.FieldByName('IsReadOnly').AsBoolean:=False;
 DataSet.Post;
end;



initialization

finalization
 FDefaultInstance.Free;

end.
