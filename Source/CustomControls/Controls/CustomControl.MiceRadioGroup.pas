unit CustomControl.MiceRadioGroup;

interface
uses SysUtils, Windows, Messages, Classes, Controls, StdCtrls, Data.DB,
     cxGraphics, cxControls, cxLookAndFeels, cxLookAndFeelPainters, cxContainer,
     cxEdit, cxGroupBox, cxRadioGroup, cxDBEdit,
     Common.Images,
     CustomControl.MiceDropDown.ObjectModel,
     CustomControl.Interfaces,
     CustomControl.AppObject,
     Mice.Script.ClassTree,
     Mice.Script,
     DAC.XDataSet,
     DAC.XParams;

type
  TMiceRadioGroup = class(TcxDBRadioGroup, IHaveDataBinding, ICanInitFromJson, IHaveScriptSupport)
  private
    FScript:TMiceScripter;
    FParentDBName: string;
    FAppDialogControlsId:Integer;
    procedure InternalInitialize(AppObject: TMiceAppObject);
    function GetAppDialogControlsId: Integer;
    procedure SetAppDialogControlsId(const Value: Integer);
    function GetIDataSource:TDataSource;
    function GetIDataField:string;
    procedure SetIDataSource(const Value:TDataSource);
    procedure SetIDataField(const Value:string);
    procedure InitFromJson(const Json:string);
    procedure RegisterScripter(Scripter:TMiceScripter);
    procedure InitFromParams(Params:TxParams);
    procedure AddItem(Item: TDropDownItem);
  protected
    procedure DoChange; override;
  public
    class function DevDescription:string;
  published
    property ParentDBName:string read FParentDBName write FParentDBName;
    property AppDialogControlsId: Integer read GetAppDialogControlsId write SetAppDialogControlsId;
    constructor Create(AOwner:TComponent); override;
    destructor Destroy; override;
  end;

implementation

{ TMiceRadioGroup }

procedure TMiceRadioGroup.AddItem(Item: TDropDownItem);
var
 AItem: TcxRadioGroupItem;
begin
 AItem:=Properties.Items.Add;
 AItem.Value:=Item.Value;
 AItem.Caption :=Item.Caption;
 AItem.Tag:=Item.Tag;
end;

constructor TMiceRadioGroup.Create(AOwner: TComponent);
begin
  inherited;
  Properties.Images:=ImageContainer.Images16;
  Properties.ImmediatePost:=True;
end;

destructor TMiceRadioGroup.Destroy;
begin
  inherited;
end;

class function TMiceRadioGroup.DevDescription: string;
resourcestring
 S_DevDescription_TMiceRadioGroup = 'Radio group allows user to pick only one item from the check-list.';
begin
 Result:= S_DevDescription_TMiceRadioGroup;
end;

procedure TMiceRadioGroup.DoChange;
begin
  inherited;
  if Assigned(FScript) then
   FScript.CallOnChange(Self);

  if Assigned(DataBinding.Field) and (DataBinding.Field.DataSet.State in [dsEdit,dsInsert]) then
   DataBinding.Field.Value:=Self.EditingValue;
end;


function TMiceRadioGroup.GetAppDialogControlsId: Integer;
begin
 Result:=Self.FAppDialogControlsId;
end;


function TMiceRadioGroup.GetIDataField: string;
begin
 Result:=Self.DataBinding.DataField;
end;

function TMiceRadioGroup.GetIDataSource: TDataSource;
begin
 Result:=Self.DataBinding.DataSource;
end;

procedure TMiceRadioGroup.InitFromJson(const Json: string);
var
 App:TMiceAppObject;
begin
 App:=TMiceAppObject.Create;
 try
  App.AsJson:=Json;
  InitFromParams(App.Params);
  InternalInitialize(App);
 finally
  App.Free;
 end;
end;


procedure TMiceRadioGroup.InitFromParams(Params: TxParams);
begin
 Properties.Columns:=Params.ParamByNameDef('Columns',1);
end;

procedure TMiceRadioGroup.InternalInitialize(AppObject: TMiceAppObject);
var
 Item: TDropDownItem;
begin
 for Item in AppObject.DropDownItems.Items do
  AddItem(Item);
end;


procedure TMiceRadioGroup.RegisterScripter(Scripter: TMiceScripter);
begin
 FScript:=Scripter;
end;

procedure TMiceRadioGroup.SetAppDialogControlsId(const Value: Integer);
begin
 FAppDialogControlsId:=Value;
end;

procedure TMiceRadioGroup.SetIDataField(const Value: string);
begin
 DataBinding.DataField:=Value;
end;

procedure TMiceRadioGroup.SetIDataSource(const Value: TDataSource);
begin
 DataBinding.DataSource:=Value;
end;


initialization
// TMiceScripter.RegisterClassEventOnClick(TMiceDropDown.ClassName);
 TMiceScripter.RegisterClassEventOnChange(TMiceRadioGroup.ClassName);

end.
