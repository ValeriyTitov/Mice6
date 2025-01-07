unit ImportExport.AppDialog;

interface
 uses
  System.SysUtils, System.Variants, System.Classes,
  System.Generics.Defaults, System.JSON,Data.DB,
  DAC.XDataSet,
  Manager.WindowManager,
  ImportExport.Entity,
  DAC.Data.Convert,
  CustomControl.Interfaces,
  System.Generics.Collections,
  Dialog.Layout.ControlList;

 type
  TMiceAppDialogEntity = class(TMiceITypeEntity)
  private
    procedure InitColumnList;
  protected
    function AppendDetailsRequired(DataSet:TxDataSet):Boolean;override;
    procedure FindAppScript(DataSet:TDataSet);
    procedure SetFieldProperties(DataSet:TDataSet);
    procedure BeforeOpenColumns(DataSet:TDataSet);
    procedure BeforeOpenColors(DataSet:TDataSet);
  public
    procedure DoExport(JsonRootObject:TJsonObject);override;
    procedure ImportJsonDataSets; override;
    procedure Populate; override;
    constructor Create; override;
    destructor Destroy; override;
 end;


implementation

var
FIHaveColumnsList: TList<string>;

{ TMiceDialogEntity }

procedure TMiceAppDialogEntity.BeforeOpenColors(DataSet: TDataSet);
begin
 UpdateDetailsProviderNameOnExport('AppDialogControls','AppDialogControlsId','AppGridColors');
end;

procedure TMiceAppDialogEntity.BeforeOpenColumns(DataSet: TDataSet);
begin
 UpdateDetailsProviderNameOnExport('AppDialogControls','AppDialogControlsId','AppColumns');
end;

function TMiceAppDialogEntity.AppendDetailsRequired(DataSet: TxDataSet): Boolean;
begin
 Result:=FIHaveColumnsList.Contains(DataSet.FieldByName('ClassName').AsString);
end;

constructor TMiceAppDialogEntity.Create;
begin
  inherited;
  Name:=ITypeAppNameDialog;
  KeyField:='AppDialogsId';
  KeyFieldPath:='AppDialogs[0].'+KeyField;
  InitColumnList;
end;

destructor TMiceAppDialogEntity.Destroy;
begin

  inherited;
end;

procedure TMiceAppDialogEntity.DoExport(JsonRootObject: TJsonObject);
begin
  DataSetByName('AppDialogs').AfterOpen:=FindAppScript;
  DataSetByName('AppScripts').AfterOpen:=FindAppScript;
  DataSetByName('AppDialogControls').AfterOpen:=SetFieldProperties;
  DataSetByName('AppGridColors').BeforeOpen:=BeforeOpenColors;
  DataSetByName('AppColumns').BeforeOpen:=BeforeOpenColumns;

  inherited;
end;

procedure TMiceAppDialogEntity.FindAppScript(DataSet: TDataSet);
begin
  if not DataSet.FieldByName('AppScriptsId').IsNull then
   SetNewProvider('AppScripts','AppScriptsId',DataSet.FieldByName('AppScriptsId').AsInteger);
end;

procedure TMiceAppDialogEntity.ImportJsonDataSets;
begin
 Populate;
 TryImportObject('AppMainTree','AppMainTreeId','AppMainTree[0].AppMainTreeId');
 TryImportObject('AppScripts','AppScriptsId','AppScripts[0].AppScriptsId');
 TryImportObject('AppDialogs','AppDialogsId','AppDialogs[0].AppDialogsId');
 TryImportObject('AppDialogControls','AppDialogsId','AppDialogControls[0].AppDialogsId');
 TryImportObject('AppDialogDetailTables','AppDialogsId','AppDialogDetailTables[0].AppDialogsId');

 TryImportDetails('AppColumns','AppDialogControlsId',True);
 TryImportDetails('AppGridColors','AppDialogControlsId',True);

end;

procedure TMiceAppDialogEntity.InitColumnList;
var
 s:string;
begin
 if not Assigned(FIHaveColumnsList) then
  begin
    FIHaveColumnsList:=TList<string>.Create;
    for s in TDialogLayoutControlList.DefaultInstance.Keys do
     if Supports(TDialogLayoutControlList.DefaultInstance[s].ControlClass,IHaveColumns) then
      FIHaveColumnsList.Add(s);
  end;
end;

procedure TMiceAppDialogEntity.Populate;
begin
if Self.DataSets.Count=0 then
 begin
  AddDataSet('AppMainTree','AppMainTreeId','AppMainTreeId','', S_IMPORTEXPORT_TABLEHINT_APPMAINTREE, AppMainTreeId);
  AddDataSet('AppDialogs',KeyField,KeyField, '',S_IMPORTEXPORT_TABLEHINT_DIALOG,ObjectId);
  AddDataSet('AppDialogControls','AppDialogControlsId',KeyField,'',S_IMPORTEXPORT_TABLEHINT_DIALOG_CONTROLS,ObjectId);
  AddDataSet('AppDialogDetailTables','AppDialogDetailTablesId',KeyField,'',S_IMPORTEXPORT_TABLEHINT_DIALOG_DETAIL_TABLES,ObjectId);
  AddDataSet('AppColumns','AppColumnsId','AppDialogControlsId','',S_IMPORTEXPORT_TABLEHINT_DIALOG_COLUMNS,-1);
  AddDataSet('AppGridColors','AppGridColorsId','AppDialogControlsId','',S_IMPORTEXPORT_TABLEHINT_DIALOG_COLORS,-1);
  AddDataSet('AppScripts','AppScriptsId','AppScriptsId', '',S_IMPORTEXPORT_TABLEHINT_SCRIPT_PLUGIN,-1);
 end;

end;



procedure TMiceAppDialogEntity.SetFieldProperties(DataSet: TDataSet);
begin
 DataSet.FieldByName('InitString').EditMask:=S_FIELD_CONTAINTS_JSON_TEXT;
end;

initialization
 TMiceITypeEntity.RegisterImportExportClass(ITypeAppNameDialog, TMiceAppDialogEntity)

finalization
 FIHaveColumnsList.Free;

end.
