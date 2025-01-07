{$M+} // RTTI
unit Common.ActivityCondition;

interface

uses System.SysUtils,System.Variants, DB, DBCtrls, Actions, System.Classes,
     DAC.XDataSet,
     Common.VariantComparator,
     Common.StringUtils;

type
 TActivityCondition = class
  private
    FValue: Variant;
    FEquation: TVariantEquation;
    FFieldName: string;
    FAlwaysEnabled: Boolean;
    FEnabledWhenNoRecords: boolean;
    FEnabledWhenReadOnly: Boolean;
    procedure EquationFromString(const StringValue:string);
    function GetAsString: string;
    procedure SetAsString(const Value: string);
  public
    function EnabledForDataSet(DataSet:TDataSet):Boolean;
    function EnabledForValue(const AValue:Variant):Boolean;
    function ToString:string; override;
    procedure LoadFromDataSet(DataSet:TDataSet);
    constructor Create;
    destructor Destroy; override;
  published
    property FieldName:string read FFieldName write FFieldName;
    property Value:Variant read FValue write FValue;
    property Equation:TVariantEquation read FEquation write FEquation;
    property AlwaysEnabled:Boolean read FAlwaysEnabled write FAlwaysEnabled;
    property EnabledWhenNoRecords:Boolean read FEnabledWhenNoRecords write FEnabledWhenNoRecords;
    property EnabledWhenReadOnly:Boolean read FEnabledWhenReadOnly write FEnabledWhenReadOnly;
    property AsString:string read GetAsString write SetAsString;
 end;

implementation

{ TActivityCondition }

constructor TActivityCondition.Create;
begin
 AlwaysEnabled:=False;
 Equation:=veUnknown;
 FEnabledWhenNoRecords:=false;
 EnabledWhenReadOnly:=True;
end;

destructor TActivityCondition.Destroy;
begin
  inherited;
end;

function TActivityCondition.EnabledForDataSet(DataSet: TDataSet): Boolean;
var
 F:TField;
 HasRecords:Boolean;
 HasDataSet:Boolean;
begin
 if AlwaysEnabled=False then
  begin
   HasDataSet:=Assigned(DataSet);
   HasRecords:=HasDataSet and (DataSet.Active) and (DataSet.RecordCount>0);
   Result:=HasRecords or (HasDataSet and EnabledWhenNoRecords);

   if (EnabledWhenReadOnly=False) and HasDataSet and (DataSet is TxDataSet) then
      Result:=Result and ((DataSet as TxDataSet).ReadOnly=False);

    if Result and (FieldName<>'') and (HasRecords) then
     begin
      F:=DataSet.FindField(FieldName);
      Result:=(Assigned(F) and TVariantComparator.CompareVariant(Self.Value, F.Value, Self.Equation));
     end
  end
   else
  Result:=True
end;

function TActivityCondition.EnabledForValue(const AValue: Variant): Boolean;
begin
 if AlwaysEnabled then
  Result:=True
   else
  Result:=TVariantComparator.CompareVariant(Self.Value, AValue, Self.Equation);
end;

procedure TActivityCondition.EquationFromString(const StringValue: string);
var
 AFieldName:string;
 AEquation:TVariantEquation;
 AValue:string;
 Res:Boolean;

resourcestring
 S_INVALID_EQUATION_STRING = 'Invalid equation string %s';
begin
 Res:=TVariantComparator.FindEquationInString(StringValue, AFieldName, AEquation, AValue);
 if Res then
  begin
   FieldName:=AFieldName;
   Equation:=AEquation;
   Self.Value:=AValue;
  end
   else
    raise Exception.CreateFmt(S_INVALID_EQUATION_STRING, [QuotedStr(StringValue)]);
end;

function TActivityCondition.GetAsString: string;
begin
 case Equation of
  veIsNull, veNotIsNull:Result:=Trim(FieldName+' '+TVariantComparator.EquationToString(Equation));
  veIn, veNotIn:Result:=Trim(FieldName+' '+TVariantComparator.EquationToString(Equation)+' ('+VarToStr(Self.Value)+')');
  veUnknown:Result:=TVariantComparator.EquationToString(Equation)
  else
   Result:=Trim(Self.FieldName+' '+ TVariantComparator.EquationToString(Equation)+' '+VarToStr(Self.Value));
 end;
end;

procedure TActivityCondition.LoadFromDataSet(DataSet: TDataSet);
begin
 if DataSet.FieldByName('EnabledSign').IsNull then
 Equation:=veUnknown
  else
 Equation:=TVariantEquation(DataSet.FieldByName('EnabledSign').AsInteger+1);

 FieldName:=DataSet.FieldByName('EnabledFieldName').AsString;
 Value:=DataSet.FieldByName('EnabledValue').Value;
 AlwaysEnabled:=DataSet.FieldByName('AlwaysEnabled').AsBoolean;
 EnabledWhenNoRecords:=DataSet.FieldByName('EnabledNoRecords').AsBoolean;
end;

procedure TActivityCondition.SetAsString(const Value: string);
begin
 EquationFromString(Value);
end;


function TActivityCondition.ToString: string;
begin
 if AlwaysEnabled then
  Result:='Always enabled'
   else
  Result:=AsString;
end;

end.
