unit Dialog.Adaptive.ControlFlags;

interface
 uses
  System.SysUtils, System.Variants, System.Classes, Data.DB,
  System.Generics.Collections, System.Generics.Defaults,
  Vcl.Controls, dxLayoutContainer,
  DAC.DataSetList,
  Common.ResourceStrings,
  Common.VariantComparator,
  Common.StringUtils,
  CustomControl.Interfaces,
  Dialogs;

 type

  TControlFlag = class
  strict private
    FFieldName: string;
    FValue: Variant;
    FEquation: TVariantEquation;
    FControl: TControl;
    FDataSource: TDataSource;
    FItem: TdxCustomLayoutItem;
  public
    procedure SetFromComponent(Component:TComponent);
    property FieldName:string read FFieldName write FFieldName;
    property Equation:TVariantEquation read FEquation write FEquation;
    property Value:Variant read FValue write FValue;
    property Control : TControl read FControl write FControl;
    property Item:TdxCustomLayoutItem read FItem write FItem;
    property DataSource:TDataSource read FDataSource write FDataSource;
  end;

  TControlFlags = class
    private
     FEnabledList: TObjectList<TControlFlag>;
     FVisibleList: TObjectList<TControlFlag>;
     FDataSetList: TDataSetList;
     FMainSource: TDataSource;
     FLayoutItems: TDictionary<TControl, TdxLayoutItem>;
     procedure UpdateEnabledCondition(Flag:TControlFlag; Field:TField);
     procedure UpdateVisibleCondition(Flag:TControlFlag; Field:TField);
     procedure AddToList(const FieldName: string; Equation: TVariantEquation; const Value: Variant; Component:TComponent; List:TList<TControlFlag>);
    public
     procedure AddEnabledCondition(const FieldName:string; Equation: TVariantEquation; const Value:Variant; Component:TComponent);
     procedure AddVisibleCondition(const FieldName:string; Equation: TVariantEquation; const Value:Variant; Component:TComponent);
     procedure FieldChanged(Sender:TObject;Field:TField);
     procedure DataSetLineChanged(Sender:TObject);
     procedure UpdateAll;
     property MainSource:TDataSource read FMainSource write FMainSource;
     property DataSetList:TDataSetList read FDataSetList write FDataSetList;
     property LayoutItems:TDictionary<TControl, TdxLayoutItem> read FLayoutItems write FLayoutItems;
     constructor Create;
     destructor Destroy; override;
  end;

implementation

{ TControlConditions }

procedure TControlFlags.AddEnabledCondition(const FieldName: string; Equation: TVariantEquation; const Value: Variant; Component:TComponent);
begin
 AddToList(FieldName, Equation, Value, Component, FEnabledList);
end;

procedure TControlFlags.AddVisibleCondition(const FieldName: string;  Equation: TVariantEquation; const Value: Variant; Component:TComponent);
begin
  AddToList(FieldName, Equation, Value, Component, FVisibleList);
end;


procedure TControlFlags.AddToList(const FieldName: string;  Equation: TVariantEquation; const Value: Variant; Component: TComponent;  List: TList<TControlFlag>);
var
 Item:TControlFlag;
 ADataSourceName:string;
 ADataSource:TDataSource;
begin
  ADataSourceName:=TStringUtils.LeftFromDot(FieldName, '');
  if ADataSourceName.Trim.IsEmpty then
   ADataSource:=MainSource
    else
   ADataSource:=DataSetList[ADataSourceName];

  Item:=TControlFlag.Create;
  List.Add(Item);
  Item.DataSource:=ADataSource;
  Item.FieldName:=TStringUtils.RightFromDot(FieldName, FieldName);
  Item.Equation:=Equation;
  Item.Value:=Value;
  Item.SetFromComponent(Component);
end;


constructor TControlFlags.Create;
begin
  FEnabledList:=TObjectList<TControlFlag>.Create;
  FVisibleList:=TObjectList<TControlFlag>.Create;
end;


destructor TControlFlags.Destroy;
begin
 FEnabledList.Free;
 FVisibleList.Free;
 inherited;
end;



procedure TControlFlags.FieldChanged(Sender:TObject; Field: TField);
var
 Flag:TControlFlag;
begin
 for Flag in FEnabledList do
   if (Flag.DataSource=Sender) and (Flag.FieldName=Field.FieldName) then
     UpdateEnabledCondition(Flag, Field);

 for Flag in FVisibleList do
   if (Flag.DataSource=Sender) and (Flag.FieldName=Field.FieldName) then
     UpdateVisibleCondition(Flag, Field);
end;


procedure TControlFlags.DataSetLineChanged(Sender: TObject);
var
 DataSet:TDataSet;
 F:TField;
begin
 DataSet:=(Sender as TDataSource).DataSet;
 if DataSet.Active then
  for F in DataSet.Fields do
   FieldChanged(Sender, F);
end;

procedure TControlFlags.UpdateAll;
var
 Field:TField;
 DataSource:TDataSource;
begin
 for Field in MainSource.DataSet.Fields do
  FieldChanged(MainSource,Field);

  for DataSource in Self.DataSetList.Values do
   if DataSource.DataSet.Active then
    for Field in DataSource.DataSet.Fields do
     FieldChanged(DataSource,Field);
end;

procedure TControlFlags.UpdateEnabledCondition(Flag: TControlFlag;  Field: TField);
var
 AEnabled:Boolean;
begin
 AEnabled:=TVariantComparator.CompareVariant(Flag.Value, Field.Value, Flag.Equation);

 if Assigned(Flag.Control) then
  begin
   Flag.Control.Enabled:=AEnabled;
   if Self.LayoutItems.ContainsKey(Flag.Control) then
    Self.LayoutItems[Flag.Control].Enabled:=AEnabled;
  end
   else
 if Assigned(Flag.Item) then
  Flag.Item.Enabled:=AEnabled;
end;


procedure TControlFlags.UpdateVisibleCondition(Flag: TControlFlag;  Field: TField);
var
 AVisible:Boolean;
begin
 AVisible:=TVariantComparator.CompareVariant(Flag.Value, Field.Value, Flag.Equation);

 if Assigned(Flag.Control) then
  begin
   Flag.Control.Visible:=AVisible;
   if Self.LayoutItems.ContainsKey(Flag.Control) then
    Self.LayoutItems[Flag.Control].Visible:=AVisible;
  end
   else
 if Assigned(Flag.Item) then
  Flag.Item.Visible:=AVisible;
end;

{ TControlCodition }

procedure TControlFlag.SetFromComponent(Component: TComponent);
begin
 if Component is TControl then
  begin
   Item:=nil;
   Control:=(Component as TControl)
  end
 else
 if Component is TdxCustomLayoutItem then
  begin
   Control:=nil;
   Item:=(Component as TdxCustomLayoutItem);
  end;
end;

end.
