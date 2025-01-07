{
  Показывает редактор и отображает в нём не ИД, а текст этого ИД.
  При изменении поля, автоматически меняется и текст.

  Справа есть кнопка, которая позоваляет показать диалог и изменить ИД.
  Нажатие на эту кнопку должно быть перекрыто наследниками.

  Наследники:
   TMiceValuePicker

   TMiceAssetEditor
   TMiceEmitentEditor
   TMiceSchemaEditor
   TMiceClientEditor
}
unit CustomControl.MiceValuePicker.Base;

interface
uses SysUtils, Windows, Messages, Classes, Controls, StdCtrls, cxTextEdit,
     cxButtonEdit, Data.DB, Vcl.DbCtrls, System.Variants,cxEdit,
     cxImageComboBox,
     Mice.Script,
     Common.Images,
     DAC.XDataSet,
     DAC.XParams.Mapper,
     CustomControl.AppObject,
     CustomControl.Interfaces,
     CustomControl.MiceValuePicker.Settings;


type
  TMiceValuePickerBase = class(TcxButtonEdit, IAmLazyControl, IHaveDataBinding, ICanInitFromJson, IHaveScriptSupport)
  private
    FAppObject: TMiceAppObject;
    FInitialized:Boolean;
    FDataLink: TFieldDataLink;
    FDBName: string;
    FAppDialogControlsId:Integer;
    FField:TField;
    FReadOnly: Boolean;
    FClearButtonEnabled: Boolean;
    FClearButton:TcxEditButton;
    FSettings: TMiceValuePickerSettings;
    function DataAvaible:Boolean;
    procedure FindField;
    procedure InternalInitialize;
    function GetAppDialogControlsId: Integer;
    procedure SetAppDialogControlsId(const Value: Integer);
    procedure SetKeyFieldValue(const Value: Variant);
    function GetDataField: string;
    function GetDataSource: TDataSource;
    procedure SetReadOnly(const Value: Boolean);
    procedure SetClearButtonEnabled(const Value: Boolean);
  protected
    FScript:TMiceScripter;
    FKeyFieldValue: Variant;
    FParentObject:IInheritableAppObject;
    procedure CheckBindings; virtual;
    procedure EventDataChange(Sender:TObject);
    procedure EventUpdateData(Sender:TObject);
    procedure UpdateDataField;
    procedure DoChange; override;
    procedure HandleClick(Sender: TObject; AButtonIndex: Integer);
    procedure UpdateText(const AKeyFieldValue:Variant);
    procedure CMGetDataLink(var Msg: TMessage); message CM_GETDATALINK;
    procedure InitDataSet(DataSet:TxDataSet);
    procedure RefreshDataSet;
    procedure Load(AppObject:TMiceAppObject);virtual; abstract;
  public
    procedure LazyInit(ParentObject: IInheritableAppObject);
    procedure ClearField;
    function ExecuteDialog:Boolean; virtual; abstract;
    property AppObject:TMiceAppObject read FAppObject;
    property DBName:string read FDBName write FDBName;
    property AppDialogControlsId: Integer read GetAppDialogControlsId write SetAppDialogControlsId;


    function GetIDataSource:TDataSource;
    function GetIDataField:string;
    procedure SetIDataSource(const Value:TDataSource);
    procedure SetIDataField(const Value:string);
    procedure InitFromJson(const Json:string);
    procedure RegisterScripter(Scripter:TMiceScripter);
    constructor Create(AOwner:TComponent); override;
    destructor Destroy; override;

  published
    property Settings:TMiceValuePickerSettings read FSettings;
    property DataSource:TDataSource read GetDataSource write SetIDataSource;
    property DataField:string read GetDataField write SetIDataField;
    property ReadOnly:Boolean read FReadOnly write SetReadOnly;
    property KeyFieldValue:Variant read FKeyFieldValue write SetKeyFieldValue;
    property ClearButtonEnabled:Boolean read FClearButtonEnabled write SetClearButtonEnabled;
  end;

resourcestring
 E_VPICK_FIELD_NOT_DEFINED_FMT = 'Required datafield (%s) is not defined in control %s';
 E_VPICK_UNKNOWN_DIALOG_TYPE_FMT ='Unknown dialog type %d';

implementation

{ TMiceValuePickerBase }

procedure TMiceValuePickerBase.CheckBindings;
begin
 if Settings.KeyField.Trim.IsEmpty then
  raise Exception.CreateFmt(E_VPICK_FIELD_NOT_DEFINED_FMT,['KeyField', Name]);

 if Settings.CaptionField.Trim.IsEmpty then
  raise Exception.CreateFmt(E_VPICK_FIELD_NOT_DEFINED_FMT,['CaptionField', Name]);
end;

procedure TMiceValuePickerBase.ClearField;
begin
 KeyFieldValue:=NULL;
 UpdateDataField;
end;

procedure TMiceValuePickerBase.CMGetDataLink(var Msg: TMessage);
begin
if Assigned(FDataLink) then
    Msg.Result := Integer(FDataLink)
  else
    Msg.Result := 0;
end;

constructor TMiceValuePickerBase.Create(AOwner: TComponent);
begin
  inherited;
  Properties.Images:=ImageContainer.Images16;
  FAppObject:=TMiceAppObject.Create;
  FInitialized:=False;
  Properties.OnButtonClick:=HandleClick;
  Properties.Images:=ImageContainer.Images16;
  Properties.ReadOnly:=True;
  FDataLink := TFieldDataLink.Create;
  FDataLink.Control := Self;

  FSettings:=TMiceValuePickerSettings.Create;
  Settings.CaptionField:='Caption';
  Settings.DescriptionField:='Description';
  Settings.ImageIndexField:='ImageIndex';
  Settings.ParentIdField:='ParentId';
end;

function TMiceValuePickerBase.DataAvaible: Boolean;
begin
 Result:=Assigned(DataSource) and Assigned(DataSource.DataSet) and (DataSource.DataSet.Active) and Assigned(DataSource.DataSet.FindField(DataField));
end;

destructor TMiceValuePickerBase.Destroy;
begin
  FSettings.Free;
  FAppObject.Free;
  FDataLink.Free;
  inherited;
end;


procedure TMiceValuePickerBase.DoChange;
begin
  inherited;
  if Assigned(FScript) then
   FScript.CallOnChange(Self);
end;

procedure TMiceValuePickerBase.EventDataChange(Sender: TObject);
begin
 if DataAvaible then
  KeyFieldValue:=Self.DataSource.DataSet.FieldByName(DataField).Value;
end;

procedure TMiceValuePickerBase.EventUpdateData(Sender: TObject);
begin
 UpdateDataField;
end;

procedure TMiceValuePickerBase.FindField;
begin
 if DataAvaible then
  FField:=DataSource.DataSet.FindField(DataField);
end;

function TMiceValuePickerBase.GetAppDialogControlsId: Integer;
begin
 Result:=FAppDialogControlsId;
end;

function TMiceValuePickerBase.GetDataField: string;
begin
 Result:=FDataLink.FieldName;
end;

function TMiceValuePickerBase.GetDataSource: TDataSource;
begin
 Result:=FDataLink.DataSource;
end;

function TMiceValuePickerBase.GetIDataField: string;
begin
 Result:=DataField;
end;

function TMiceValuePickerBase.GetIDataSource: TDataSource;
begin
 Result:=DataSource;
end;

procedure TMiceValuePickerBase.HandleClick(Sender: TObject; AButtonIndex: Integer);
begin
if AButtonIndex=0 then
  ExecuteDialog
    else
  ClearField;
end;

procedure TMiceValuePickerBase.InitFromJson(const Json: string);
begin
 AppObject.AsJson:=Json;
 DBName:=AppObject.Properties.DBName;
 Load(AppObject);
 ClearButtonEnabled:=AppObject.Params.ParamByNameDef('ClearButtonEnabled',False);
 CheckBindings;
end;

procedure TMiceValuePickerBase.InternalInitialize;
begin
 FDataLink.OnDataChange := EventDataChange;
 FDataLink.OnUpdateData := EventUpdateData;
 EventDataChange(nil);
end;

procedure TMiceValuePickerBase.LazyInit(ParentObject: IInheritableAppObject);
begin
 if not FInitialized then
  begin
   FParentObject:=ParentObject;
   if Assigned(FParentObject) and (DBName.IsEmpty) then
    DBName:=FParentObject.DBName;

   InternalInitialize;
   FInitialized:=True;
  end;
end;


procedure TMiceValuePickerBase.InitDataSet(DataSet: TxDataSet);
begin
 DataSet.DBName:=Self.DBName;
 if Name='' then
  DataSet.Source:='TMiceValuePickerBase.UpdateText'
       else
  DataSet.Source:=Self.Name+'.UpdateText';

 DataSet.ProviderNamePattern:=AppObject.Properties.ProviderName;

 if Assigned(FParentObject) and Assigned(FParentObject.ParamsMapper) then
  FParentObject.ParamsMapper.MapDataSet(DataSet);
end;


procedure TMiceValuePickerBase.UpdateText(const AKeyFieldValue:Variant);
var
 Tmp:TxDataSet;
begin
Tmp:=TxDataSet.Create(nil);
 try
   InitDataSet(Tmp);
   Tmp.OpenOrExecute;
   if Tmp.Locate(Settings.KeyField,AKeyFieldValue,[]) then
     Text:=Tmp.FieldByName(Settings.CaptionField).AsString
      else
     Text:=VarToStr(AKeyFieldValue);
  finally
   Tmp.Free;
 end;
end;

procedure TMiceValuePickerBase.RefreshDataSet;
begin

end;

procedure TMiceValuePickerBase.RegisterScripter(Scripter: TMiceScripter);
begin
 FScript:=Scripter;
end;

procedure TMiceValuePickerBase.SetAppDialogControlsId(const Value: Integer);
begin
 FAppDialogControlsId:=Value;
end;


procedure TMiceValuePickerBase.SetClearButtonEnabled(const Value: Boolean);
begin
  FClearButtonEnabled := Value;

  if (not Assigned(FClearButton)) and (Value=True) then
   begin
    FClearButton:=Properties.Buttons.Add;
    FClearButton.ImageIndex:=IMAGEINDEX_ACTION_CLEAR;
    FClearButton.Kind:=bkGlyph;
    FClearButton.Enabled:=not ReadOnly;
   end;

 if Assigned(FClearButton) then
  FClearButton.Visible:=Value;
end;

procedure TMiceValuePickerBase.SetIDataField(const Value: string);
begin
 FDataLink.FieldName:=Value;
end;

procedure TMiceValuePickerBase.SetIDataSource(const Value: TDataSource);
begin
 if DataSource<>Value then
    FDataLink.DataSource:=Value;
 if Assigned(DataSource.DataSet) and (DataSource.DataSet is TxDataSet) then
   ReadOnly:=(DataSource.DataSet as TxDataSet).ReadOnly;
end;

procedure TMiceValuePickerBase.SetKeyFieldValue(const Value: Variant);
begin
 if FKeyFieldValue<>Value then
  begin
   FKeyFieldValue:=Value;
   UpdateText(FKeyFieldValue);
  end;
end;

procedure TMiceValuePickerBase.SetReadOnly(const Value: Boolean);
begin
  FReadOnly := Value;
  Properties.Buttons.Items[0].Enabled:=not Value;
  if Assigned(FClearButton) then
   FClearButton.Enabled:=not Value;
end;

procedure TMiceValuePickerBase.UpdateDataField;
begin
 FindField;
 if Assigned(FField) and (FField.DataSet.State in [dsEdit,dsInsert]) and (ReadOnly=False) then
  FField.Value:=FKeyFieldValue;
end;

end.
