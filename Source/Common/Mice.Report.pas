unit Mice.Report;
{$M+}

interface
uses
  Windows, Messages, SysUtils, Variants, Classes, Forms,
  Dialogs,  frxClass, frxPreview, frxDesgn, frxDbSet, frxVariables, Data.DB,
  System.Generics.Collections, System.Generics.Defaults,
  System.IOUtils,
  Common.Registry,
  Common.GlobalSettings,
  Common.ResourceStrings,
  Mice.Report.FileExport,
  DAC.XParams,
  DAC.XDataSet,
  DAC.ObjectModels.MiceUser;

type
 TOnGetReportParams = procedure (Sender: TObject; DataSetID:Integer; Params:TParams) of object;

 TMiceReport = class(TComponent)
  private
    FDataSetList: TObjectDictionary<string, TxDataSet>;
    FReport:TfrxReport;
    FDesigner: TfrxDesigner;
    FParams:TxParams;
    FExportTitle: string;
    FLoaded:Boolean;
    FEdit:Boolean;
    FShowProgress: Boolean;
    function GetFDesigner: TfrxDesigner;
    function OnSaveReport(Report: TfrxReport; SaveAs: Boolean): Boolean;
    procedure AddDataSet(const Name:string; DataSet:TxDataSet);
    procedure OnReportDesignerShow(Sender:TObject);
    procedure SetAppReportsId(const Value: Integer);
    procedure CheckAppReportsId;
    procedure InternalLoadDetail(DataSet:TDataSet);
    procedure TryOpenDataSet(ADataSet:TxDataSet);
    function GetAppReportsId: Integer;
  protected
    property Designer:TfrxDesigner read GetFDesigner;
    procedure LoadFromDataSet(DataSet:TDataSet);
    procedure SaveToDataSet(DataSet:TDataSet);
    procedure LoadDetails;
    procedure RegisterParams;
    procedure Load;
    procedure Save;
    procedure Preview;
  public
    constructor Create(AOwner:TComponent);override;
    destructor Destroy; override;
  published
    property Params:TxParams read FParams;
    property AppReportsId: Integer read GetAppReportsId write SetAppReportsId;
    property ExportTitle: string read FExportTitle write FExportTitle;
    property ShowProgress: Boolean read FShowProgress write FShowProgress;
    procedure SetParameter(const ParamName:string; const ParamValue:Variant);
    procedure Edit;
    procedure ExportToFile(const FileName, Format:string);
    procedure ExportToStream(Stream:TStream; const Format:string);
    function Execute:Boolean;
 end;

implementation


const
 Prov='SELECT * FROM [AppReports] WITH (NOLOCK) WHERE AppReportsId=%d';

resourcestring
 S_REPORT_DESIGNER_CAPTION = 'Report template: %s, AppReportsId = %d';

{ TMiceReport }

procedure TMiceReport.AddDataSet(const Name: string; DataSet: TxDataSet);
var
 frxDB:TfrxDBDataSet;
begin
 frxDB:=TfrxDBDataSet.Create(Self);
 frxDB.UserName:=Name;
 frxDB.DataSet:=DataSet;
 FReport.DataSets.Add(frxDb);
end;

procedure TMiceReport.CheckAppReportsId;
resourcestring
 E_INVALID_AppReportsId = 'Invalid AppReportsId';
begin
 if AppReportsId<=0 then
  raise Exception.Create(E_INVALID_AppReportsId);
end;

constructor TMiceReport.Create(AOwner:TComponent);
begin
  inherited;
  FLoaded:=False;
  FEdit:=False;
  FParams:=TxParams.Create;
  FReport:=TfrxReport.Create(Self);
  FReport.StoreInDFM:=False;
  FReport.IniFile:=RegistryPathReports;
  FReport.EngineOptions.NewSilentMode:=TfrxSilentMode.simReThrow;
  FDataSetList:=TObjectDictionary<string, TxDataSet>.Create([doOwnsValues],TIStringComparer.Ordinal);

{
   IF Assigned(OnGetReportParams) and Assigned(DataSet) then
     OnGetReportParams(Self,DataSetID,DataSet.Params);
}
end;

destructor TMiceReport.Destroy;
begin
  FParams.Free;
  FDataSetList.Free;
  inherited;
end;

procedure TMiceReport.Edit;
begin
 FEdit:=True;
 CheckAppReportsId;
 Load;
 Designer;
 FReport.DesignReport(True);
end;

function TMiceReport.Execute: Boolean;
begin
 FEdit:=False;
 Load;
 Preview;
 Result:=True;
end;

procedure TMiceReport.ExportToFile(const FileName, Format: string);
var
 AFilter:TFrxCustomExportFilter;
begin
 Load;
 AFilter:=TMiceReportExport.DefaultInstance.FileExtToFilter(Format);
// AFilter.ShowProgress:=False;
 AFilter.FileName:=FileName;
 AFilter.ShowDialog:=False;
 AFilter.ExportTitle:=Self.ExportTitle;
 TMiceReportExport.DefaultInstance.Subject:='';//
 TMiceReportExport.DefaultInstance.Author:=TMiceUser.CurrentUser.FullName;


 if FReport.PrepareReport(True) then
  FReport.Export(AFilter);
end;

procedure TMiceReport.ExportToStream(Stream: TStream; const Format: string);
var
 AFilter:TFrxCustomExportFilter;
begin
 Load;
 AFilter:=TMiceReportExport.DefaultInstance.FileExtToFilter(Format);

 AFilter.FileName:='FileName';
 AFilter.ShowDialog:=False;
 AFilter.ExportTitle:=Self.ExportTitle;
 AFilter.Stream:=Stream;
 TMiceReportExport.DefaultInstance.Subject:='';//
 TMiceReportExport.DefaultInstance.Author:=TMiceUser.CurrentUser.FullName;

 if FReport.PrepareReport(True) then
  FReport.Export(AFilter);
end;

function TMiceReport.GetAppReportsId: Integer;
begin
 Result:=Params.ParamByNameDef('AppReportsId',0);
end;

function TMiceReport.GetFDesigner: TfrxDesigner;
begin
 if not Assigned(FDesigner) then
  begin
   FDesigner:=TfrxDesigner.Create(Self);
   FDesigner.CloseQuery:=True;
   FDesigner.OnSaveReport:=OnSaveReport;
   FDesigner.OnShow:=OnReportDesignerShow;
  end;
 Result:=FDesigner;
end;

procedure TMiceReport.InternalLoadDetail(DataSet: TDataSet);
var
 ANewDataSet:TxDataSet;
 AName:string;
begin
 while not DataSet.Eof do
  begin
   AName:=DataSet.FieldByName('DataSetName').AsString;
   if not FDataSetList.ContainsKey(Name) then
    begin
     ANewDataSet:=TxDataSet.Create(Self);
     FDataSetList.Add(AName, ANewDataSet);
     ANewDataSet.ProviderName:=DataSet.FieldByName('ProviderName').AsString;
     ANewDataSet.DBName:=DataSet.FieldByName('DBName').AsString;
     if FEdit then
     ANewDataSet.Source:='TMiceReport.InternalLoadDetail (All params is NULL)'
      else
     ANewDataSet.Source:='TMiceReport.InternalLoadDetail';
     TryOpenDataSet(ANewDataSet);
     AddDataSet(AName,ANewDataSet)
    end;
    DataSet.Next;
  end;
end;

procedure TMiceReport.Load;
var
 Tmp:TxDataSet;
begin
 FReport.ShowProgress:=Self.ShowProgress;
 CheckAppReportsId;
 if FLoaded then
  Exit;

 Tmp:=TxDataSet.Create(nil);
  try
   Tmp.ProviderName:='spui_AppGetReportDetails';
   Tmp.SetParameter('AppReportsId',AppReportsId);
   Tmp.Source:='TMiceReport.Load';
   Tmp.Open;
   LoadDetails;
   LoadFromDataSet(Tmp);
   RegisterParams;
   FLoaded:=True;
  finally
   Tmp.Free;
  end;
end;

procedure TMiceReport.LoadDetails;
var
 Tmp:TxDataSet;
begin
 Tmp:=TxDataSet.Create(nil);
  try
   Tmp.ProviderName:='spui_AppGetReportDataSets';
   Tmp.SetParameter('AppReportsId',AppReportsId);
   Tmp.Source:='TMiceReport.LoadDetails';
   Tmp.Open;
   InternalLoadDetail(Tmp);
  finally
   Tmp.Free;
  end;
end;


procedure TMiceReport.LoadFromDataSet(DataSet:TDataSet);
var
 Stream:TStream;
begin
 Stream:=DataSet.CreateBlobStream(DataSet.FieldByName('ReportData'),bmRead);
  try
   if not DataSet.FieldByName('ReportData').IsNull then
    FReport.LoadFromStream(Stream);
    FReport.FileName:=DataSet.FieldByName('Caption').AsString;
   finally
    Stream.Free;
   end;
end;

procedure TMiceReport.SaveToDataSet(DataSet:TDataSet);
var
  Stream:TMemoryStream;
begin
 Stream:=TMemoryStream.Create;
  try
   FReport.SaveToStream(Stream);
   (DataSet.FieldByName('ReportData') as TBlobField).LoadFromStream(Stream);
  finally
   Stream.Free;
  end;
end;


procedure TMiceReport.OnReportDesignerShow(Sender: TObject);
begin
If (Sender is TForm) then
   (Sender as TForm).Caption:=Format(S_REPORT_DESIGNER_CAPTION,[FReport.FileName, AppReportsId]);
end;

function TMiceReport.OnSaveReport(Report: TfrxReport; SaveAs: Boolean): Boolean;
begin
 Save;
 Result:=True;
end;

procedure TMiceReport.Preview;
begin
 FEdit:=False;
 if FReport.PrepareReport(True) then
  FReport.ShowPreparedReport;
end;

procedure TMiceReport.RegisterParams;
var
 R:TfrxVariable;
 P:TParam;
 X:Integer;
begin
 for x := 0 to Params.Count-1 do
  begin
   P:=Params[x];
   R:=FReport.Variables.Add;
   R.DisplayName:=P.Name;
   R.Name:=P.Name;
   R.Value:=P.Value;
  end;
end;

procedure TMiceReport.Save;
var
 Tmp:TxDataSet;
begin
CheckAppReportsId;
Tmp:=TxDataSet.Create(nil);
  try
   Tmp.ProviderName:=Format(Prov,[AppReportsId]);
   Tmp.Open;
   Tmp.Edit;
   SaveToDataSet(Tmp);
   Tmp.Post;
   Tmp.ApplyUpdates(-1);
  finally
    Tmp.Free;
  end;
end;

procedure TMiceReport.SetAppReportsId(const Value: Integer);
begin
 Params.SetParameter('AppReportsId',Value);
end;

procedure TMiceReport.SetParameter(const ParamName: string;  const ParamValue: Variant);
begin
 Self.Params.SetParameter(ParamName,ParamValue);
end;

procedure TMiceReport.TryOpenDataSet(ADataSet: TxDataSet);
begin
 if FEdit then
  ADataSet.GetParameters(True);

 ADataSet.Params.LoadFromParams(Params);
 try
  ADataSet.Open;
 except on E:Exception do //Fast Report глотает ошибку и просто ничего не показывает.
  begin
   //if ShowProgress then
//    MessageBox(0, PChar(E.Message), PChar(S_COMMON_ERROR), MB_OK+MB_ICONERROR);
   raise;
  end;
 end;
end;

initialization
 RegisterClass(TfrxDBDataset);

end.

