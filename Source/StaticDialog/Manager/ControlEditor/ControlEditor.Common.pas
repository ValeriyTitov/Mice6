unit ControlEditor.Common;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Dialog.Layout, cxGraphics,
  cxLookAndFeels, cxLookAndFeelPainters, Vcl.Menus, cxControls, Data.DB,
  cxClasses, dxLayoutContainer, dxLayoutControl, Vcl.StdCtrls, cxButtons,
  Vcl.ExtCtrls, cxContainer, cxEdit, dxLayoutcxEditAdapters, cxTextEdit,
  cxDBEdit, cxDropDownEdit, cxMaskEdit, cxButtonEdit, cxImageComboBox,
  System.Generics.Collections, System.Generics.Defaults,
  cxCheckBox,
  Dialog.Layout.ControlList,
  CustomControl.AppObject,
  Common.ResourceStrings,
  DAC.DataSetList,
  DAC.XParams,
  DAC.XDataSet,
  DAC.DataBaseUtils;

type
  TControlEditorClassList = class;
  //DataSet.FieldByName('DBName').AsString;

  TControlEditorBase = class(TBasicLayoutDialog)
    CommonPropertiesGroup: TdxLayoutGroup;
    ExtendedPropertiesGroup: TdxLayoutGroup;
    edControlName: TcxDBButtonEdit;
    edControlName_Item: TdxLayoutItem;
    ControlActivityGroup: TdxLayoutGroup;
    ddEnabledCondition: TcxDBImageComboBox;
    ddEnabledCondition_Item: TdxLayoutItem;
    ddVisibleCondition: TcxDBImageComboBox;
    ddVisibleCondition_Item: TdxLayoutItem;
    AllPropertiesGroup: TdxLayoutGroup;
    RuntimePropertiesGroup: TdxLayoutGroup;
    cbDataField_Item: TdxLayoutItem;
    cbDBName_Item: TdxLayoutItem;
    chbReadOnly: TcxCheckBox;
    chbReadOnly_Item: TdxLayoutItem;
    cbCaption: TcxDBComboBox;
    cbCaption_Item: TdxLayoutItem;
    cbDataField: TcxDBComboBox;
    cbDBName: TcxDBComboBox;
    dxLayoutAutoCreatedGroup1: TdxLayoutAutoCreatedGroup;
    dxLayoutAutoCreatedGroup2: TdxLayoutAutoCreatedGroup;
    procedure cbDataFieldPropertiesInitPopup(Sender: TObject);
    procedure cbCaptionPropertiesInitPopup(Sender: TObject);
    procedure edControlNamePropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
    procedure cbDataFieldExit(Sender: TObject);
    procedure cbDBNamePropertiesChange(Sender: TObject);
  private
    FControlClassName: string;
    FAppDialogsId: Integer;
    FDialogMainTable: string;
    FMiceAppObject:TMiceAppObject;
    FAppDialogDetailTables: TDataSetList;
    FParentDBName: string;
    FParentDataSet: TDataSet;
    function GetTargetDBName: string;
  protected
    function ReadProperty (const Name:string; const DefaultValue:Variant):Variant;
    procedure WriteProperty(const Name:string; const Value,DefaultValue:Variant);
    procedure EnterInsertingState; override;
    procedure Save; virtual;
    procedure Load; virtual;
    procedure EnterEditingState; override;
    procedure DoApplyUpdates; override;
    procedure FindAllTableFields(List:TStrings);
    procedure FindCompleteListOfTables(List:TStrings);
  public
    property ControlClassName:string read FControlClassName write FControlClassName;
    property AppDialogsId:Integer read FAppDialogsId write FAppDialogsId;
    property DialogMainTable:string read FDialogMainTable write FDialogMainTable;
    property ParentDBName:string read FParentDBName write FParentDBName;
    property TargetDBName:string read GetTargetDBName;
    property MiceAppObject:TMiceAppObject read FMiceAppObject;
    property AppDialogDetailTables:TDataSetList read FAppDialogDetailTables;
    property ParentDataSet:TDataSet read FParentDataSet write FParentDataSet;
    constructor Create(AOwner:TComponent); override;
    destructor Destroy; override;
    procedure Initialize; override;
  end;


 TControlEditorClass = class of TControlEditorBase;

 TControlEditorClassList = class
  class procedure RegisterClass(const AClassName:string; AClass:TControlEditorClass);
  class function GetEditorClass(const AClassName:string):TControlEditorClass;
 end;


resourcestring
 S_DEFAULT_PROVIDER_PATTERN_HINT = 'Example "spui_ItemList @ItemId=<ItemId>, @ItemType=<Details.ItemType>, @OnDate ='#39'2018-10-29'#39', @IncludingClosed=0"';

implementation
var
 FEditorClassList:TObjectDictionary<string, TControlEditorClass>;

resourcestring
 S_NO_EDITOR_CLASS_REGISTERED_FMT = 'No editor class registered for %s';

{$R *.dfm}
{ TControlEditorBase }

procedure TControlEditorBase.cbCaptionPropertiesInitPopup(Sender: TObject);
var
 DataField:string;
begin
 DataField:=Self.cbDataField.Text;
 if (cbCaption.Properties.Items.Count<=0) and (DataField<>'') then
  TDataBaseUtils.FindCommonCaptionList(DataField,cbCaption.Properties.Items);
end;

procedure TControlEditorBase.cbDataFieldExit(Sender: TObject);
begin
 if DataSet.FieldByName('Caption').AsString.IsEmpty then
  DataSet.FieldByName('Caption').AsString:=cbDataField.Text;

 if DataSet.FieldByName('ControlName').AsString.IsEmpty then
  DataSet.FieldByName('ControlName').AsString:=TDialogLayoutControlList.CreateControlName(cbDataField.Text,ControlClassName);
end;

procedure TControlEditorBase.cbDataFieldPropertiesInitPopup(Sender: TObject);
begin
  inherited;
  if cbDataField.Properties.Items.Count=0 then
   FindAllTableFields(cbDataField.Properties.Items);
end;

procedure TControlEditorBase.cbDBNamePropertiesChange(Sender: TObject);
begin
  inherited;
  //TargetDBName:=cbDBName.Text;
end;

constructor TControlEditorBase.Create(AOwner: TComponent);
begin
  inherited;
  TableName:='AppDialogControls';
  KeyField :='AppDialogControlsId';
  FMiceAppObject:=TMiceAppObject.Create;
  FAppDialogDetailTables:=TDataSetList.Create;
end;

destructor TControlEditorBase.Destroy;
begin
  FMiceAppObject.Free;
  FAppDialogDetailTables.Free;
  inherited;
end;

procedure TControlEditorBase.DoApplyUpdates;
begin
  Save;
//  ShowMessage(DataSet.FieldByName('InitString').AsString);
  inherited;
end;


procedure TControlEditorBase.edControlNamePropertiesButtonClick(Sender: TObject;  AButtonIndex: Integer);
begin
  DataSet.Post;
  DataSet.Edit;
//  DataSet.FieldByName('DataField').AsString:=Self.cbDataField.Text;
  DataSet.FieldByName('ControlName').AsString:=TDialogLayoutControlList.CreateControlName(DataSet.FieldByName('DataField').AsString,ControlClassName);
end;

procedure TControlEditorBase.EnterEditingState;
begin
 inherited;
 Load;
end;

procedure TControlEditorBase.EnterInsertingState;
begin
  inherited;
  Load;
  DataSet.FieldByName('AppDialogControlsId').AsInteger:=TDataBaseUtils.NewAppObjectId(sq_AppDialogControls);
  DataSet.FieldByName('AppDialogsId').AsInteger:=AppDialogsId;
  DataSet.FieldByName('ClassName').AsString:=ControlClassName;
  DataSet.FieldByName('IsReadOnly').AsBoolean:=False;
end;

procedure TControlEditorBase.FindAllTableFields(List: TStrings);
var
 TableList:TStringList;
 X:Integer;
 ATableName:string;
 ADBName:string;
begin
 TableList:=TStringList.Create;
  try
   FindCompleteListOfTables(TableList);
   for x:=0 to TableList.Count-1 do
    begin
     ATableName:=TableList.Names[x];
     ADBName:=TableList.ValueFromIndex[x];
     if ATableName=DialogMainTable then
      TDataBaseUtils.GetTableColumns(ATableName,'',List, ADBName)
       else
      TDataBaseUtils.GetTableColumns(ATableName,ATableName+'.',List, ADBName)
    end;
  finally
   TableList.Free;
  end;
end;



procedure TControlEditorBase.FindCompleteListOfTables(List: TStrings);
var
 FDataSetList:TDataSetList;
begin
 FDataSetList:=TDataSetList.Create;
  try
   List.Add(DialogMainTable+'='+TargetDBName);
   FDataSetList.LoadForAppDialog(AppDialogsId);
   FDataSetList.ToList(List);
  finally
   FDataSetList.Free;
  end;
end;



function TControlEditorBase.GetTargetDBName: string;
begin
 if DataSet.FieldByName('DBName').AsString.IsEmpty then
  Result:=Self.ParentDBName
   else
  Result:=DataSet.FieldByName('DBName').AsString;
end;

procedure TControlEditorBase.Initialize;
begin
  inherited;
  MiceAppObject.Clear;
end;

procedure TControlEditorBase.Load;
resourcestring
 S_CONTROL_HAS_INVALID_JSON = 'Control has invalid Json';
begin
 if DataSet.FieldByName('InitString').AsString<>'' then
  try
   MiceAppObject.AsJson:=DataSet.FieldByName('InitString').AsString;
  except
   MessageBox(Handle, PChar(S_CONTROL_HAS_INVALID_JSON),PChar(S_COMMON_ERROR),MB_OK+MB_ICONERROR);
  end;

chbReadOnly.Checked:=ReadProperty('Readonly', False);
end;


function TControlEditorBase.ReadProperty(const Name:string; const DefaultValue: Variant): Variant;
begin
 Result:=MiceAppObject.Params.ParamByNameDef(Name,DefaultValue);
end;

procedure TControlEditorBase.Save;
begin
 WriteProperty('Readonly',chbReadOnly.Checked,False);
 WriteProperty('Datafield',DataSet.FieldByName('DataField').AsString, '');
 WriteProperty('DBName', DataSet.FieldByName('DBName').AsString,'');
 DataSet.FieldByName('InitString').AsString:=MiceAppObject.AsJson;
end;


procedure TControlEditorBase.WriteProperty(const Name: string; const Value, DefaultValue: Variant);
begin
 MiceAppObject.Params.SetParameterNoDefault(Name, Value, DefaultValue);
end;

{ TControlEditorClassList }

class function TControlEditorClassList.GetEditorClass(const AClassName: string): TControlEditorClass;
begin
 if (not FEditorClassList.ContainsKey(AClassName)) or (not Assigned(FEditorClassList[AClassName])) then
  raise Exception.CreateFmt(S_NO_EDITOR_CLASS_REGISTERED_FMT,[AClassName]);

 Result:=FEditorClassList[AClassName];
end;

class procedure TControlEditorClassList.RegisterClass(const AClassName: string;  AClass: TControlEditorClass);
begin
if not Assigned(FEditorClassList) then
 FEditorClassList:=TObjectDictionary<string, TControlEditorClass>.Create;
 
 if not FEditorClassList.ContainsKey(AClassName) then
  FEditorClassList.Add(AClassName, AClass);
end;

initialization
 
finalization
 FEditorClassList.Free;
end.
