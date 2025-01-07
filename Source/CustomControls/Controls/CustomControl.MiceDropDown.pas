unit CustomControl.MiceDropDown;

interface
uses SysUtils, Windows, Messages, Classes, Controls, StdCtrls, cxTextEdit,
     cxDBEdit, ExtCtrls, cxEdit,Data.DB,
     cxImageComboBox,
     Mice.Script,
     Common.Images,
     Common.LookAndFeel,
     CustomControl.MiceDropDown.Builder,
     CustomControl.AppObject,
     CustomControl.Interfaces;


type
  TMiceDropDown = class(TcxDBImageComboBox, IAmLazyControl, IHaveDataBinding, ICanInitFromJson, IHaveScriptSupport)
  private
    FScript:TMiceScripter;
    FAppObject: TMiceAppObject;
    FInitialized:Boolean;
    FParentObject:IInheritableAppObject;
    FAppDialogControlsId:Integer;
    procedure InternalInitialize;
    procedure SetDBName(const Value: string);
    function GetDBName: string;
    function GetAppDialogControlsId: Integer;
    procedure SetAppDialogControlsId(const Value: Integer);
    function GetIDataSource:TDataSource;
    function GetIDataField:string;
    procedure SetIDataSource(const Value:TDataSource);
    procedure SetIDataField(const Value:string);
    procedure InitFromJson(const Json:string);
    procedure RegisterScripter(Scripter:TMiceScripter);
    procedure LazyInit(ParentObject: IInheritableAppObject);
    procedure RefreshDataSet;
  protected
    procedure DoChange; override;
  public
    class function DevDescription:string;
  published
    property AppObject:TMiceAppObject read FAppObject;
    property DBName:string read GetDBName write SetDBName;
    property AppDialogControlsId: Integer read GetAppDialogControlsId write SetAppDialogControlsId;
    constructor Create(AOwner:TComponent); override;
    destructor Destroy; override;
  end;
implementation

{ TMiceDropDown }

constructor TMiceDropDown.Create(AOwner: TComponent);
begin
  inherited;
  if DefaultLookAndFeel.Theme<>TMiceColorTheme.mctWhiteTheme then
   Self.Color:=DefaultLookAndFeel.ControlColor;

  Properties.Images:=ImageContainer.Images16;
  FAppObject:=TMiceAppObject.Create;
  Properties.Alignment.Horz:=taLeftJustify;
  FInitialized:=False;
end;

destructor TMiceDropDown.Destroy;
begin
  FAppObject.Free;
  inherited;
end;

class function TMiceDropDown.DevDescription: string;
resourcestring
 S_DevDescription_TMiceDropDown = 'Control which allows user to select only one item from the drop down. Can have dynamic(stored procedure) or static(fixed) items. Repopulates automatically if any of provider-depended fields changed.';
begin
 Result:= S_DevDescription_TMiceDropDown;
end;

procedure TMiceDropDown.DoChange;
begin
  inherited;
  if Assigned(FScript) then
   FScript.CallOnChange(Self);

  if Assigned(DataBinding.Field) and (DataBinding.Field.DataSet.State in [dsEdit,dsInsert]) then
   DataBinding.Field.Value:=Self.EditingValue;
//   Properties.Items[Self.ItemIndex].Value;
end;

function TMiceDropDown.GetAppDialogControlsId: Integer;
begin
 Result:=Self.FAppDialogControlsId;
end;

function TMiceDropDown.GetDBName: string;
begin
 Result:=Self.AppObject.Properties.DBName;
end;

function TMiceDropDown.GetIDataField: string;
begin
 Result:=DataBinding.DataField;
end;

function TMiceDropDown.GetIDataSource: TDataSource;
begin
 Result:=DataBinding.DataSource;
end;

procedure TMiceDropDown.InitFromJson(const Json: string);
begin
 Self.AppObject.AsJson:=Json;
end;

procedure TMiceDropDown.InternalInitialize;
var
 Builder:TMiceDropDownBuilder;
begin
 Builder:=TMiceDropDownBuilder.Create;
 try
  Builder.DataSet.Close;
  Builder.DataSet.ProviderNamePattern:=AppObject.Properties.ProviderName;
  if Assigned(FParentObject) and Assigned (FParentObject.ParamsMapper) then
   FParentObject.ParamsMapper.MapDataSet(Builder.DataSet);

  Builder.DataSet.DBName:=Self.DBName;
  Builder.Items:=Properties.Items;
  Builder.LoadFromAppObject(AppObject);
 finally
  Builder.Free;
 end;
end;

procedure TMiceDropDown.LazyInit(ParentObject: IInheritableAppObject);
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

procedure TMiceDropDown.RefreshDataSet;
begin

end;

procedure TMiceDropDown.RegisterScripter(Scripter: TMiceScripter);
begin
 FScript:=Scripter;
end;

procedure TMiceDropDown.SetAppDialogControlsId(const Value: Integer);
begin
 Self.FAppDialogControlsId:=Value;
end;

procedure TMiceDropDown.SetDBName(const Value: string);
begin
  AppObject.Properties.DBName:=Value;
end;

procedure TMiceDropDown.SetIDataField(const Value: string);
begin
 DataBinding.DataField:=Value;
end;

procedure TMiceDropDown.SetIDataSource(const Value: TDataSource);
begin
 DataBinding.DataSource:=Value;
end;

initialization
// TMiceScripter.RegisterClassEventOnClick(TMiceDropDown.ClassName);
 TMiceScripter.RegisterClassEventOnChange(TMiceDropDown.ClassName);
end.
