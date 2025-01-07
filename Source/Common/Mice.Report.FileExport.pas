unit Mice.Report.FileExport;

interface

uses
  SysUtils, Classes, frxClass, frxExportDOCX, frxExportCSV, frxExportText,
  System.Generics.Collections, System.Generics.Defaults,
  frxExportXLSX, frxExportPDF,  frxDCtrl, frxGradient, frxChBox, frxCross,
  frxBarcode, frxOLE, frxRich, frxGZip;

type
  TMiceReportExport = class(TDataModule)
    DOCXExport: TfrxDOCXExport;
    XLSXExport: TfrxXLSXExport;
    PDFExport: TfrxPDFExport;
    CSVExport: TfrxCSVExport;
    TxtExport: TfrxSimpleTextExport;
  private
    FExportFormats: TDictionary<string, TFrxCustomExportFilter>;
    FAuthor: string;
    FSubject: string;
    procedure SetAuthor(const Value: string);
    procedure SetSubject(const Value: string);
  public
    constructor Create(AOwner:TComponent); override;
    destructor Destroy; override;
    property Author:string read FAuthor write SetAuthor;
    property Subject:string read FSubject write SetSubject;
    function FileExtToFilter(const FileExtension:string):TFrxCustomExportFilter;
    class function DefaultInstance:TMiceReportExport;
  end;


implementation

var
  FDefaulInstance: TMiceReportExport;

{$R *.dfm}
{ TMiceReportExport }

constructor TMiceReportExport.Create(AOwner: TComponent);
begin
  inherited;
  FExportFormats:=TDictionary<string, TFrxCustomExportFilter>.Create(TIStringComparer.Ordinal);
  FExportFormats.Add('pdf',PDFExport);
  FExportFormats.Add('docx',DOCXExport);
  FExportFormats.Add('xlsx',XLSXExport);
  FExportFormats.Add('txt',TxtExport);
  FExportFormats.Add('csv',CSVExport);
  FExportFormats.Add('doc',DOCXExport);
  FExportFormats.Add('xls',XLSXExport);

  FExportFormats.Add('.pdf',PDFExport);
  FExportFormats.Add('.docx',DOCXExport);
  FExportFormats.Add('.xlsx',XLSXExport);
  FExportFormats.Add('.txt',TxtExport);
  FExportFormats.Add('.csv',CSVExport);
  FExportFormats.Add('.doc',DOCXExport);
  FExportFormats.Add('.xls',XLSXExport);
end;

class function TMiceReportExport.DefaultInstance: TMiceReportExport;
begin
 Result:=FDefaulInstance;
end;

destructor TMiceReportExport.Destroy;
begin
  FExportFormats.Free;
  inherited;
end;

function TMiceReportExport.FileExtToFilter( const FileExtension: string): TFrxCustomExportFilter;
resourcestring
  E_UNKNOWN_EXPORT_FORMAT_FMT = 'Unknow export format : %s';
begin
 if FExportFormats.ContainsKey(FileExtension) then
  Result:=FExportFormats[FileExtension]
   else
  raise Exception.CreateFmt(E_UNKNOWN_EXPORT_FORMAT_FMT, [FileExtension]);
end;

procedure TMiceReportExport.SetAuthor(const Value: string);
begin
  FAuthor := Value;
  PDFExport.Author:=Value;
end;

procedure TMiceReportExport.SetSubject(const Value: string);
begin
  FSubject := Value;
  PDFExport.Subject:=Value;
end;

initialization
 FDefaulInstance:=TMiceReportExport.Create(nil);

finalization
 FDefaulInstance.Free;

end.
