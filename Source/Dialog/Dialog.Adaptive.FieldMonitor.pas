unit Dialog.Adaptive.FieldMonitor;


{
  ќшибка в ƒевЁкспресс.
  ≈сли к TcxGrid прив€зан DataSource, то OnDataChange вызываетс€ 2 раза при DataSet.EnableControls;

}

interface

uses Data.DB, System.SysUtils, System.Generics.Collections, System.Generics.Defaults,
     DAC.ProviderNamePattern.Parser,
     Common.StringUtils,
     CustomControl.Interfaces,
     Common.ResourceStrings;



type
  TNotifyControlList = class(TList<IMayDependOnDialog>)
   private
     FFieldName:string;
   public
     procedure NotifyAll;
     constructor Create(const FieldName:string);
   end;


 TFieldMonitor = class
  private
    FProcessing:TList<string>;
    FMonitoringFields:TObjectDictionary<string,TNotifyControlList>;
    FMonitoringDataSet:TObjectDictionary<string,TNotifyControlList>;
    procedure InternalAddControlField(List:TNotifyControlList;const IControl: IMayDependOnDialog);
    procedure InternalAddListField(const FieldName:string; const IControl: IMayDependOnDialog);
    procedure InternalAddControlDataSet(List:TNotifyControlList;const IControl: IMayDependOnDialog);
    procedure InternalAddListDataSet(const DataSetName:string; const IControl: IMayDependOnDialog);
  public
    procedure FieldChanged(const DataSetName:string);
    procedure DataSetLineChanged(const DataSetName:string);
    procedure AddFieldMonitor(const IControl:IMayDependOnDialog);
    constructor Create;
    destructor Destroy; override;
 end;

implementation

{ TFieldMonitor }

procedure TFieldMonitor.FieldChanged(const DataSetName:string);
begin
if FProcessing.Contains(DataSetName) then
 raise Exception.CreateFmt(E_RECURSIVE_ERROR_FMT,[DataSetName, TStringUtils.ListToString(FProcessing), DataSetName]);
  try
    FProcessing.Add(DataSetName);
    if FMonitoringFields.ContainsKey(DataSetName) then
     FMonitoringFields[DataSetName].NotifyAll;
  finally
    FProcessing.Remove(DataSetName);
  end;
end;


procedure TFieldMonitor.AddFieldMonitor(const IControl: IMayDependOnDialog);
var
 Item:TDependEntity;
begin
for Item in IControl.GetDataSet.Parser.DependenciesList do
 if Item.IsExternalSource then
  begin
   if FMonitoringFields.ContainsKey(Item.ShortItemName) then
    InternalAddControlField(FMonitoringFields[Item.ShortItemName], IControl)
     else
    InternalAddListField(Item.ShortItemName,IControl);

   if FMonitoringDataSet.ContainsKey(Item.Source) then
    InternalAddControlDataSet(FMonitoringDataSet[Item.Source], IControl)
     else
    InternalAddListDataSet(Item.Source,IControl);
  end;
end;

constructor TFieldMonitor.Create;
begin
 FProcessing:=TList<string>.Create;
 FMonitoringFields:=TObjectDictionary<string,TNotifyControlList>.Create([doOwnsValues],TIStringComparer.Ordinal);
 FMonitoringDataSet:=TObjectDictionary<string,TNotifyControlList>.Create([doOwnsValues],TIStringComparer.Ordinal);
end;

procedure TFieldMonitor.DataSetLineChanged(const DataSetName:string);
begin
if FProcessing.Contains(DataSetName) then
 raise Exception.CreateFmt(E_RECURSIVE_ERROR_FMT,[DataSetName, TStringUtils.ListToString(FProcessing), DataSetName]);
  try
    FProcessing.Add(DataSetName);
    if FMonitoringDataSet.ContainsKey(DataSetName) then
     FMonitoringDataSet[DataSetName].NotifyAll;
  finally
     FProcessing.Remove(DataSetName);
  end;
end;

destructor TFieldMonitor.Destroy;
begin
  FProcessing.Free;
  FMonitoringFields.Free;
  FMonitoringDataSet.Free;
  inherited;
end;

procedure TFieldMonitor.InternalAddControlDataSet(List: TNotifyControlList;  const IControl: IMayDependOnDialog);
begin
 if not List.Contains(IControl) then
  List.Add(IControl);
end;

procedure TFieldMonitor.InternalAddControlField(List: TNotifyControlList; const IControl: IMayDependOnDialog);
begin
 if not List.Contains(IControl) then
  List.Add(IControl);
end;

procedure TFieldMonitor.InternalAddListDataSet(const DataSetName: string; const IControl: IMayDependOnDialog);
var
 List:TNotifyControlList;
begin
  List:=TNotifyControlList.Create(DataSetName);
  List.Add(IControl);
  FMonitoringDataSet.Add(DataSetName,List);
end;

procedure TFieldMonitor.InternalAddListField(const FieldName:string; const IControl: IMayDependOnDialog);
var
 List:TNotifyControlList;
begin
  List:=TNotifyControlList.Create(FieldName);
  List.Add(IControl);
  FMonitoringFields.Add(FieldName,List);
end;


{ TNotifyControlList }

constructor TNotifyControlList.Create(const FieldName:string);
begin
 inherited Create;
 FFieldName:=FieldName;
end;

procedure TNotifyControlList.NotifyAll;
var
 IControl:IMayDependOnDialog;
begin
 for IControl in Self do
  IControl.NotifyDialogChanged;
end;

end.
