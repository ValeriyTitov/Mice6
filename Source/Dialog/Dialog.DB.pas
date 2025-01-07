unit Dialog.DB;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Data.DB,  Vcl.ExtCtrls,  cxGraphics, cxLookAndFeels, cxLookAndFeelPainters,
  Vcl.Menus, Vcl.StdCtrls, cxButtons,
  Dialog.Basic,
  DAC.XDataSet,
  DAC.XParams,
  DAC.DataSetList,
  DAC.DataBaseUtils,
  DAC.XParams.Mapper,
  Common.StringUtils,
  CustomControl.Interfaces,
  Common.ResourceStrings;


type
  TBasicDBDialog = class(TBasicDialog,IInheritableAppObject)
    MainSource: TDataSource;
  private
    FDataSet:TXDataSet;
    FTableName: String;
    FParams: TxParams;
    FKeyField: string;
    FDetailDataSets: TDataSetList;
    FDBName: string;
    FParamsMapper:TParamsMapper;
    FState:TDataSetState;
    FParentObject: IInheritableAppObject;
    FSequenceDBName: string;
    procedure SetID(const Value: Int64);
    procedure SetKeyField(const Value: string);
    procedure SetDBName(const Value: string);
    function GetDBName: string;
    function GetParamsMapper:TParamsMapper;
    function GetParentObject:IInheritableAppObject;
    function GetID: Int64;
  protected
    FInitialized: Boolean;
    procedure UpdateMasterDetailKey;
    procedure DoAfterOpen(DataSet:TDataSet);virtual;
    procedure DoAfterInsert(DataSet:TDataSet);virtual;
    procedure DoAfterMasterApplyUpdates;virtual;
    procedure DoAfterDetailApplyUpdates; virtual;
    procedure DoApplyUpdates; virtual;
    procedure EnterInsertingState;virtual;
    procedure EnterEditingState; virtual;
    procedure EnableEditingMode;virtual;
    procedure UpdateReadOnlyState;override;
    procedure CheckInvalidDBSettings; virtual;
    procedure CheckInvalidRecordCount; virtual;
    procedure CloseDetails; virtual;
    procedure Open; virtual;
  public
    procedure Initialize; virtual;
    procedure SetParameter(const ParamName:string; const Value:Variant);
    function AddDetailTable(const ATableName, ProviderPattern, ADBName, Source, SequenceName, SequenceDBName:string):TDataSource;
    function Execute:Boolean; override;
    function Modified:Boolean;
    function FieldByName(const FieldName:string):TField;
    constructor Create(AOwner:TComponent); override;
    destructor Destroy; override;
  published
    property ParamsMapper:TParamsMapper read FParamsMapper;
    property DataSet: TXDataSet read FDataSet;
    property Params:TxParams read FParams;
    property TableName:string read FTableName write FTableName;
    property DetailDataSets:TDataSetList read FDetailDataSets;
    property KeyField:string read FKeyField write SetKeyField;
    property ID:Int64 read GetID write SetID;
    property DBName:string read GetDBName write SetDBName;
    property SequenceDBName:string read FSequenceDBName write FSequenceDBName;
    property ParentObject:IInheritableAppObject read GetParentObject write FParentObject;
    property State: TDataSetState read FState;
    property Initialized:Boolean read FInitialized;
  end;


TBasicDBDlgClass = class of TBasicDBDialog;

const
 DEFAULT_DLG_OPEN_STATEMENT = 'SELECT * FROM [%s] WITH (NOLOCK) WHERE %s=%d';

implementation

{$R *.dfm}

function TBasicDBDialog.AddDetailTable(const ATableName, ProviderPattern, ADBName, Source, SequenceName, SequenceDBName:string):TDataSource;
begin
 Result:=DetailDataSets.CreateDataSource(ATableName, ProviderPattern, ADBName, Source, SequenceName,SequenceDBName);
end;

procedure TBasicDBDialog.CheckInvalidDBSettings;
resourcestring
 E_KEYFIELD_DIALOG_ERROR = 'KeyField is not defined for dialog %s ';
 E_TABLENAME_DIALOG_ERROR = 'TableName not defined for dialog %s';
begin
 if KeyField.Trim.IsEmpty then
    raise Exception.CreateFmt(E_KEYFIELD_DIALOG_ERROR,[ClassName]);
 if TableName.Trim.IsEmpty then
    raise Exception.CreateFmt(E_TABLENAME_DIALOG_ERROR,[ClassName]);
end;

procedure TBasicDBDialog.CheckInvalidRecordCount;
resourcestring
 E_DBDIALOG_INVALID_RECORD_COUNT ='Dialog error: Unique record not found with ID=%d. Returned %d record(s)';
 E_CANNOT_ADD_RECORDS_WHEN_READONLY = 'Cannot add records while dialog is market as readonly.';
var
 ACount:Integer;
 InvalidEdit:Boolean;
 InvalidInsert:Boolean;
begin
 if (ID<0) and (ReadOnly) then
  raise Exception.Create(E_CANNOT_ADD_RECORDS_WHEN_READONLY);
 ACount:=DataSet.RecordCount;
 InvalidEdit:=(FState in [dsEdit, dsBrowse]) and (ACount<>1);
 InvalidInsert:=(FState = dsInsert) and (ACount>0);
 if InvalidEdit or InvalidInsert then
  raise Exception.CreateFmt(E_DBDIALOG_INVALID_RECORD_COUNT, [ID, ACount]);
end;

procedure TBasicDBDialog.CloseDetails;
begin
 DetailDataSets.CloseAll;
end;

constructor TBasicDBDialog.Create(AOwner: TComponent);
resourcestring
 S_DIALOG_MAIN_SOURCE_DESCRIPTION_FMT = '%s.MainTable';
begin
  inherited;
  FParams:=TxParams.Create;
  FDataSet:=TXDataSet.Create(Self);
  DataSet.AfterOpen:=DoAfterOpen;
  DataSet.AfterInsert:=DoAfterInsert;
  DataSet.Source:=Format(S_DIALOG_MAIN_SOURCE_DESCRIPTION_FMT,[ClassName]);
  MainSource.DataSet:=DataSet;

  FParamsMapper:=TParamsMapper.Create;
  FParamsMapper.AddSource(DataSet,'');
  FParamsMapper.AddSource(Params,'');

  FTableName:='';
  FDetailDataSets:=TDataSetList.Create;
  FDetailDataSets.ParamsMapper:=FParamsMapper;
  FState:=dsInactive;
end;

destructor TBasicDBDialog.Destroy;
begin
  FDetailDataSets.Free;
  FParams.Free;
  ParamsMapper.Free;
  inherited;
end;


procedure TBasicDBDialog.DoAfterDetailApplyUpdates;
begin

end;

procedure TBasicDBDialog.DoAfterInsert(DataSet: TDataSet);
begin
end;

procedure TBasicDBDialog.DoAfterMasterApplyUpdates;
begin

end;

procedure TBasicDBDialog.DoAfterOpen(DataSet: TDataSet);
begin
end;

procedure TBasicDBDialog.DoApplyUpdates;
begin
 if not ReadOnly then
  begin
   DataSet.ApplyUpdatesIfChanged;
   if ID<=0 then
    ID:=DataSet.FieldByName(KeyField).AsInteger; //Identity
   DoAfterMasterApplyUpdates;

   DetailDataSets.MasterKeyField:=KeyField;
   DetailDataSets.MasterID:=ID;
   DetailDataSets.ApplyUpdatesAll;
   DoAfterDetailApplyUpdates;
  end;
end;

procedure TBasicDBDialog.EnterEditingState;
begin
 FState:=dsEdit;
 DataSet.Edit;
end;

procedure TBasicDBDialog.EnterInsertingState;
begin
 FState:=dsInsert;
 DataSet.Append;
 if DataSet.NeedSequence then
  begin
   DataSet.FieldByName(KeyField).Value:=TDataBaseUtils.GetNextSequenceValue(DataSet.SequenceName, SequenceDBName);
   ID:=DataSet.FieldByName(KeyField).Value;
  end;
end;

procedure TBasicDBDialog.EnableEditingMode;
begin
 if (ID=-1) then
  EnterInsertingState
   else
  EnterEditingState;
end;

function TBasicDBDialog.Execute: Boolean;
begin
 Initialize;
 Result:=inherited Execute;
  if (Result) and (not ReadOnly) then
   DoApplyUpdates;
end;

function TBasicDBDialog.FieldByName(const FieldName: string): TField;
var
 AName:string;
begin
 AName:=TStringUtils.LeftFromDot(FieldName,'');
 if AName.IsEmpty then
  Result:=Self.DataSet.FieldByName(FieldName)
   else
  Result:=DetailDataSets.FieldByName(FieldName);
end;

function TBasicDBDialog.GetDBName: string;
begin
  Result := FDBName;
end;

function TBasicDBDialog.GetID: Int64;
begin
 Result:=Params.ParamByNameDef('ID',0);
end;

function TBasicDBDialog.GetParamsMapper: TParamsMapper;
begin
 Result:=Self.ParamsMapper;
end;

function TBasicDBDialog.GetParentObject: IInheritableAppObject;
begin
 Result:=FParentObject;
end;

procedure TBasicDBDialog.Initialize;
begin
  Open;
  FInitialized:=True;
end;


function TBasicDBDialog.Modified: Boolean;
begin
 Result:=DataSet.Modified or DetailDataSets.Modified;
end;


procedure TBasicDBDialog.Open;
begin
 if Assigned(FParentObject) and (DBName.IsEmpty) then
   DBName:=FParentObject.DBName;

 DataSet.Close;
 CloseDetails;
 FState:=dsInactive;
 CheckInvalidDBSettings;
 DataSet.ProviderName:=Format(DEFAULT_DLG_OPEN_STATEMENT,[TableName, KeyField, ID]);
 DataSet.Open;
 FState:=dsBrowse;
 if not ReadOnly then
  EnableEditingMode;
 CheckInvalidRecordCount;
end;

procedure TBasicDBDialog.SetDBName(const Value: string);
begin
 FDBName:=Value;
 DataSet.DBName:=Value;
end;

procedure TBasicDBDialog.SetID(const Value: Int64);
begin
 SetParameter('ID',Value);
 UpdateMasterDetailKey;
end;


procedure TBasicDBDialog.SetKeyField(const Value: string);
begin
 if FKeyField<>Value then
  begin
   FKeyField := Value;
   DetailDataSets.MasterKeyField:=Value;
   FDataSet.KeyField:=Value;
  end;
end;

procedure TBasicDBDialog.SetParameter(const ParamName: string; const Value: Variant);
begin
 Params.SetParameter(ParamName,Value);
 if TStringUtils.SameString(ParamName,'ID')
 or TStringUtils.SameString(ParamName,'AppDialogsId')
 or TStringUtils.SameString(ParamName,'AppDialogsId') then
  DataSet.SetContext(ParamName,VarToStr(Value));
end;




procedure TBasicDBDialog.UpdateMasterDetailKey;
begin
  DetailDataSets.MasterID:=ID;
end;

procedure TBasicDBDialog.UpdateReadOnlyState;
begin
  inherited;
  DataSet.ReadOnly:=ReadOnly;
  DetailDataSets.Readonly:=ReadOnly;
end;

end.
