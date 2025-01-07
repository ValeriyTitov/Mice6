unit CustomControl.MiceCurrencyEdit;


interface
uses SysUtils, Windows, Messages, Classes, Controls, StdCtrls, cxTextEdit,
     cxDBEdit, ExtCtrls, cxEdit,Data.DB,
     cxImageComboBox,
     Mice.Script,
     Common.Images,
     CustomControl.MiceDropDown.Builder,
     CustomControl.AppObject,
     CustomControl.Interfaces,
     Common.GlobalSettings;


type
  TMiceCurrencyEdit = class(TcxDBImageComboBox, IAmLazyControl, IHaveDataBinding, ICanInitFromJson, IHaveScriptSupport)
  private
    FScript:TMiceScripter;
    FAppObject: TMiceAppObject;
    FInitialized:Boolean;
    FAppDialogControlsId:Integer;
    FParentObject: IInheritableAppObject;
    procedure InternalInitialize;
    function GetDBName: string;
    procedure SetDBName(const Value: string);
    function GetIDataSource:TDataSource;
    function GetIDataField:string;
    procedure SetIDataSource(const Value:TDataSource);
    procedure SetIDataField(const Value:string);
    procedure InitFromJson(const Json:string);
    procedure RegisterScripter(Scripter:TMiceScripter);
    procedure LazyInit(ParentObject: IInheritableAppObject);
    function GetAppDialogControlsId: Integer;
    procedure SetAppDialogControlsId(const Value: Integer);
    procedure RefreshDataSet;
  protected
    procedure DoChange; override;
  public
    property AppObject:TMiceAppObject read FAppObject;
    property DBName:string read GetDBName write SetDBName;
    property AppDialogControlsId: Integer read GetAppDialogControlsId write SetAppDialogControlsId;

    constructor Create(AOwner:TComponent); override;
    destructor Destroy; override;
    class function DevDescription:string;
  end;
implementation

{ TMiceDropDown }

constructor TMiceCurrencyEdit.Create(AOwner: TComponent);
begin
  inherited;
  Properties.Images:=ImageContainer.Images16;
  FAppObject:=TMiceAppObject.Create;
  FInitialized:=False;
end;

destructor TMiceCurrencyEdit.Destroy;
begin
  FAppObject.Free;
  inherited;
end;

class function TMiceCurrencyEdit.DevDescription: string;
resourcestring
 S_DevDescription_TMiceCurrencyEdit = 'Control which allows user to edit field as currency (USD/RUB/EUR). "TMiceCurrencyEditor.ProviderName" and "TMiceCurrencyEditor.DBName" must be set in Global Setting to make this control to work.';
begin
 Result:= S_DevDescription_TMiceCurrencyEdit;
end;

procedure TMiceCurrencyEdit.DoChange;
begin
  inherited;
  if Assigned(FScript) then
   FScript.CallOnChange(Self);

  if Assigned(DataBinding.Field) and (DataBinding.Field.DataSet.State in [dsEdit,dsInsert]) then
   DataBinding.Field.Value:=Self.EditingValue;
//   Properties.Items[Self.ItemIndex].Value;
end;

function TMiceCurrencyEdit.GetAppDialogControlsId: Integer;
begin
 Result:=FAppDialogControlsId;
end;

function TMiceCurrencyEdit.GetDBName: string;
begin
 Result:=AppObject.Properties.DBName;
end;

function TMiceCurrencyEdit.GetIDataField: string;
begin
 Result:=DataBinding.DataField;
end;

function TMiceCurrencyEdit.GetIDataSource: TDataSource;
begin
 Result:=DataBinding.DataSource;
end;

procedure TMiceCurrencyEdit.InitFromJson(const Json: string);
begin
 Self.AppObject.AsJson:=Json;
end;

procedure TMiceCurrencyEdit.InternalInitialize;
var
 Builder:TMiceDropDownBuilder;
 AGlobalProvider:string;
begin
 Builder:=TMiceDropDownBuilder.Create;
 try
  Builder.Items:=Properties.Items;
  AGlobalProvider:=TGlobalSettings.DefaultInstance.SettingByName('TMiceCurrencyEditor.ProviderName');  //'spui_CurrencyList';
  if DBName.IsEmpty then
   DBName:=TGlobalSettings.DefaultInstance.SettingByName('TMiceCurrencyEditor.DBName');
  AppObject.Properties.ProviderName:=AGlobalProvider;
  AppObject.Properties.DBName:=DBName;
  Builder.LoadFromAppObject(AppObject);
 finally
  Builder.Free;
 end;
end;

procedure TMiceCurrencyEdit.LazyInit(ParentObject: IInheritableAppObject);
begin
 FParentObject:=ParentObject;

 if Assigned(FParentObject) and (DBName.IsEmpty) then
   DBName:=FParentObject.DBName;

 if not FInitialized then
  begin
   InternalInitialize;
   FInitialized:=True;
  end;
end;

procedure TMiceCurrencyEdit.RefreshDataSet;
begin

end;

procedure TMiceCurrencyEdit.RegisterScripter(Scripter: TMiceScripter);
begin
 FScript:=Scripter;
end;

procedure TMiceCurrencyEdit.SetAppDialogControlsId(const Value: Integer);
begin
 FAppDialogControlsId:=Value;
end;

procedure TMiceCurrencyEdit.SetDBName(const Value: string);
begin
 Self.AppObject.Properties.DBName:=Value;
end;

procedure TMiceCurrencyEdit.SetIDataField(const Value: string);
begin
 DataBinding.DataField:=Value;
end;

procedure TMiceCurrencyEdit.SetIDataSource(const Value: TDataSource);
begin
 DataBinding.DataSource:=Value;
end;


initialization
 TMiceScripter.RegisterClassEventOnClick(TMiceCurrencyEdit.ClassName);
 TMiceScripter.RegisterClassEventOnChange(TMiceCurrencyEdit.ClassName);
end.
