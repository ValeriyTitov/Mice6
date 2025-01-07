unit CustomControl.MiceTextEdit;

interface

uses SysUtils, Windows, Messages, Classes, Controls, StdCtrls, cxTextEdit,
     cxDBEdit, ExtCtrls, Data.DB, CustomControl.AutoCompleteTextEdit, cxEdit,
     CustomControl.Interfaces,
     CustomControl.AppObject,
     Common.LookAndFeel,
     cxMaskEdit,
     Mice.Script.ClassTree,
     Mice.Script,
     DAC.XDataSet,
     DAC.XParams;


type

  TMiceTextEdit = class(TAutoComleteTextEdit, IHaveDataBinding, ICanInitFromJson, IHaveScriptSupport, IAmLazyControl)
  private
    FSpellCheck: Boolean;
    FStringTrim: Boolean;
    FRemoveDualSpaces: Boolean;
    FProviderName: string;
    FDBName: string;
    FScript:TMiceScripter;
    FAppDialogControlsId:Integer;
    FParentObject: IInheritableAppObject;
    procedure LoadData(DataSet:TDataSet; const AText: string; Items: TStrings);
    function GetIDataSource:TDataSource;
    function GetIDataField:string;
    procedure SetIDataSource(const Value:TDataSource);
    procedure SetIDataField(const Value:string);
    procedure InitFromJson(const Json:string);
    procedure RegisterScripter(Scripter:TMiceScripter);
    procedure LazyInit(ParentObject: IInheritableAppObject);
    function GetAppDialogControlsId: Integer;
    procedure SetAppDialogControlsId(const Value: Integer);
    procedure SetMaskKind(const Value: Integer);
    function GetMaskKind: Integer;
    procedure SetEditMask(const Value: string);
    function GetEditMask: string;
  protected
    function AllowedToEdit:Boolean;
    procedure InitFromParams(Params:TxParams);
    procedure PopulateDynamicList(const AText:string; Items:TStrings);override;
    procedure CallScriptOnChange;
    procedure DoApplyText(DropDownItems:TStrings;ItemIndex:Integer); override;
    procedure DoExit;override;
    procedure RefreshDataSet;
  public
    procedure DoRemoveDualSpaces;
    procedure DoStringTrim;
    class function DevDescription:string;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property ProviderName:string read FProviderName write FProviderName;
    property DBName:string read FDBName write FDBName;
    property SpellCheck:Boolean read FSpellCheck write FSpellCheck;
    property StringTrim:Boolean read FStringTrim write FStringTrim;
    property RemoveDualSpaces:Boolean read FRemoveDualSpaces write FRemoveDualSpaces;
    property AppDialogControlsId: Integer read GetAppDialogControlsId write SetAppDialogControlsId;
    property MaskKind:Integer read GetMaskKind write SetMaskKind;
    property EditMask:string read GetEditMask write SetEditMask;
  end;


implementation

function TMiceTextEdit.AllowedToEdit: Boolean;
var
 Tmp:TDataSet;
begin
 Result:=Assigned(DataBinding.Field);
 if Result then
  begin
    Tmp:=(DataBinding.DataSource.DataSet);
    Result:=(Tmp.State in [dsInsert,dsEdit]) and (DataBinding.Field.ReadOnly=False);
  end;
end;

procedure TMiceTextEdit.CallScriptOnChange;
begin
 if Assigned(FScript) then
  FScript.CallOnChange(Self);
end;

constructor TMiceTextEdit.Create(AOwner: TComponent);
begin
  inherited;
  if DefaultLookAndFeel.Theme<>TMiceColorTheme.mctWhiteTheme then
   Self.Color:=DefaultLookAndFeel.ControlColor;
end;

destructor TMiceTextEdit.Destroy;
begin

  inherited;
end;

class function TMiceTextEdit.DevDescription: string;
resourcestring
 S_DevDescription_TMiceTextEdit = 'Simple text editor. Has some extended properties - Edit mask, AutoComplete and so on.';
begin
 Result:= S_DevDescription_TMiceTextEdit;
end;

procedure TMiceTextEdit.DoApplyText(DropDownItems:TStrings;ItemIndex:Integer);
var
 Params:TxParams;
 DataSet:TDataSet;
begin
 inherited;
 Params:=DropDownItems.Objects[ItemIndex] as TxParams;
 DataSet:=DataBinding.DataSource.DataSet;
 if Assigned(DataSet) and Assigned(Params) and AllowedToShow then
  Params.TryApplyToDataSet(DataSet);
end;

procedure TMiceTextEdit.DoExit;
begin
{ if AllowedToEdit then
   begin
    if RemoveDualSpaces then
     DoRemoveDualSpaces;
    if StringTrim then
     DoStringTrim;
   end;}
  inherited;
end;

procedure TMiceTextEdit.PopulateDynamicList(const AText: string; Items: TStrings);
var
 DataSet:TxDataSet;
 F:TField;
begin
 inherited;
 DataSet:=TxDataSet.Create(nil);
 try
  F:=DataBinding.Field;
  if Assigned(F) then
   begin
    DataSet.ProviderNamePattern:=Self.ProviderName;
    DataSet.DBName:=Self.DBName;
    DataSet.Source:='TMiceTextEdit.PopulateDynamicList';
    DataSet.Params.LoadFromDataSet(DataBinding.DataSource.DataSet);
    DataSet.SetParameter(F.FieldName, AText);
    DataSet.Open;
    LoadData(DataSet,AText,Items);
   end;
 finally
  DataSet.Free;
 end;
end;

function TMiceTextEdit.GetAppDialogControlsId: Integer;
begin
 Result:=Self.FAppDialogControlsId;
end;

function TMiceTextEdit.GetEditMask: string;
begin
 Result:=Properties.EditMask;
end;

function TMiceTextEdit.GetIDataField: string;
begin
 Result:=DataBinding.DataField;
end;

function TMiceTextEdit.GetIDataSource: TDataSource;
begin
 Result:=DataBinding.DataSource;
end;


function TMiceTextEdit.GetMaskKind: Integer;
begin
 Result:=Integer(Properties.MaskKind);
end;

procedure TMiceTextEdit.InitFromJson(const Json: string);
var
 App:TMiceAppObject;
begin
 App:=TMiceAppObject.Create;
 try
  App.AsJson:=Json;
  InitFromParams(App.Params);
 finally
  App.Free;
 end;
end;

procedure TMiceTextEdit.InitFromParams(Params: TxParams);
begin
 Self.Properties.ValidateOnEnter:=True;
 if Assigned(Params.FindParam('AutoCompleteItems')) then
  Items.Text:=Params.FindParam('AutoCompleteItems').AsString;

 if Assigned(Params.FindParam('AutoCompleteType')) then
  AutoCompleteType:=TAutoCompleteType(Params.FindParam('AutoCompleteType').AsInteger)
   else
  AutoCompleteType:=actOff;

 if Assigned(Params.FindParam('RemoveDualSpaces')) then
  RemoveDualSpaces:=Params.FindParam('RemoveDualSpaces').AsBoolean
   else
  RemoveDualSpaces:=True;

 if Assigned(Params.FindParam('StringTrim')) then
  StringTrim:=Params.FindParam('StringTrim').AsBoolean
   else
  StringTrim:=True;

 if Assigned(Params.FindParam('SpellCheck')) then
  SpellCheck:=Params.FindParam('SpellCheck').AsBoolean
   else
  SpellCheck:=False;

 if Assigned(Params.FindParam('ProviderName')) then
  ProviderName:=Params.FindParam('ProviderName').AsString;

 if Assigned(Params.FindParam('DBName')) then
  DBName:=Params.FindParam('DBName').AsString;

 if Assigned(Params.FindParam('EditMask')) and (not Params.FindParam('EditMask').AsString.Trim.IsEmpty) then
  begin
   if Assigned(Params.FindParam('MaskKind')) then
    Properties.MaskKind:=TcxEditMaskKind(Params.FindParam('MaskKind').AsInteger)
     else
    Properties.MaskKind:=TcxEditMaskKind.emkRegExprEx;

   Properties.EditMask:=Params.FindParam('EditMask').AsString;
   Properties.ValidationOptions:=[evoShowErrorIcon,evoAllowLoseFocus];

   if Assigned(Params.FindParam('MaskErrorShowIcon')) then
    if (Params.FindParam('MaskErrorShowIcon').AsBoolean=False) then
     Properties.ValidationOptions:=Properties.ValidationOptions-[evoShowErrorIcon];

   if Assigned(Params.FindParam('MaskErrorAllowLooseFocus')) then
    if (Params.FindParam('MaskErrorAllowLooseFocus').AsBoolean=False) then
     Properties.ValidationOptions:=Properties.ValidationOptions-[evoAllowLoseFocus];
  end;

end;


procedure TMiceTextEdit.LazyInit(ParentObject: IInheritableAppObject);
begin
 FParentObject:=ParentObject;
 if Assigned(FParentObject) and (DBName.IsEmpty) then
   DBName:=FParentObject.DBName;
end;

procedure TMiceTextEdit.LoadData(DataSet: TDataSet; const AText: string;  Items: TStrings);
var
 ACount:Integer;
 ItemParams:TxParams;
 ItemName:string;
 Field:TField;
begin
 DataSet.DisableControls;
 ACount:=0;
 Field:=DataSet.FindField('DisplayText');
 if not Assigned(Field) then
  Field:=DataSet.FieldByName(DataBinding.Field.FieldName);

 while not (DataSet.Eof) and (ACount< MaxDropDownItems)  do
  begin
   ItemName:=Field.AsString;
   ItemParams:=TxParams.Create;
   ItemParams.LoadFromDataSet(DataSet);
   Items.AddObject(ItemName,ItemParams);
   Inc(ACount);
   DataSet.Next;
  end;

end;

procedure TMiceTextEdit.RefreshDataSet;
begin

end;

procedure TMiceTextEdit.RegisterScripter(Scripter: TMiceScripter);
begin
 FScript:=Scripter;
end;


procedure TMiceTextEdit.DoRemoveDualSpaces;
var
 AText:string;
begin
 AText:=DataBinding.Field.AsString;
 while AText.Contains('  ') do
  AText:=AText.Replace('  ',' ');
 DataBinding.Field.AsString:=AText;
end;

procedure TMiceTextEdit.DoStringTrim;
var
 AText:string;
begin
 AText:=DataBinding.Field.AsString.Trim;
 DataBinding.Field.AsString:=AText;
end;

procedure TMiceTextEdit.SetAppDialogControlsId(const Value: Integer);
begin
 Self.FAppDialogControlsId:=Value;
end;

procedure TMiceTextEdit.SetEditMask(const Value: string);
begin
   Properties.EditMask:=Value;
end;

procedure TMiceTextEdit.SetIDataField(const Value: string);
begin
 DataBinding.DataField:=Value;
end;

procedure TMiceTextEdit.SetIDataSource(const Value: TDataSource);
begin
 DataBinding.DataSource:=Value;
end;


procedure TMiceTextEdit.SetMaskKind(const Value: Integer);
begin
 Properties.MaskKind:=TcxEditMaskKind(Value);
end;

resourcestring
S_PROP_DESC_MICETEXTEDIT_MAXDROPDOWNITEMS = 'Maximum amount of items to be displayed.';


initialization
 TMiceScripter.RegisterClassEventOnClick(TMiceTextEdit.ClassName);
 TMiceScripter.RegisterClassEventOnChange(TMiceTextEdit.ClassName);


 TClassEventsTree.DefaultInstance.RegisterClassPropertyInteger(TMiceTextEdit.ClassName,'MaxDropDownItems', S_PROP_DESC_MICETEXTEDIT_MAXDROPDOWNITEMS);
 TClassEventsTree.DefaultInstance.AddDialogControl(TMiceTextEdit.ClassName);

end.
