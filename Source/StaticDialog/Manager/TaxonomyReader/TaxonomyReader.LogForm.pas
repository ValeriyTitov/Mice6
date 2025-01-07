unit TaxonomyReader.LogForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Xml.xmldom, Xml.XMLIntf,
  Xml.XMLDoc, TaxonomyReader.Reader, Vcl.ExtCtrls,  Data.DB,  FileCtrl,
  Taxonomy.XBRL.ObjectModel, Xml.omnixmldom,
  TaxonomyRader.XBRL.BrowserForm;

type
  TTaxonomyReaderLogForm = class(TForm)
    Panel1: TPanel;
    Memo1: TMemo;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  private
    Reader:TTaxononmyReader;
    FDataSet: TDataSet;
    FFileName: string;
    FLoading:Boolean;
    FOnAddDataSet: TDataSetNotifyEvent;
    procedure BrowseTaxononmy;
    procedure ReadTaxonomy;
    function FindCbr(const Path:string):string;
  public
    property FileName:string read FFileName write FFileName;
    property DataSet:TDataSet read FDataSet write FDataSet;
    property OnAddDataSet:TDataSetNotifyEvent read FOnAddDataSet write FOnAddDataSet;


    class function Execute(const AFileName:string; DataSet:TDataSet; Event:TDataSetNotifyEvent):Boolean;
  end;

var
  TaxonomyReaderLogForm: TTaxonomyReaderLogForm;

implementation

{$R *.dfm}

procedure TTaxonomyReaderLogForm.BrowseTaxononmy;
var
 Dlg:TXbrlBrowserForm;
begin
 Dlg:=TXbrlBrowserForm.Create(nil);
  try
   Dlg.LoadFromReader(Reader);
   Dlg.OnAddDataSet:=Self.OnAddDataSet;
   Dlg.DataSet:=Self.DataSet;
   Dlg.ShowModal;
  finally
   Dlg.Free;
  end;
end;

class function TTaxonomyReaderLogForm.Execute(const AFileName: string;  DataSet: TDataSet; Event:TDataSetNotifyEvent): Boolean;
var
  Dlg:TTaxonomyReaderLogForm;
begin
 Dlg:=TTaxonomyReaderLogForm.Create(nil);
 try
  Dlg.FileName:=AFileName;
  Dlg.DataSet:=DataSet;
  Dlg.OnAddDataSet:=Event;
  Result:=Dlg.ShowModal=mrOK;
 finally
  Dlg.Free;
 end;

end;


function TTaxonomyReaderLogForm.FindCbr(const Path:string): string;
var
 AIndex:Integer;
begin
 AIndex:=Pos('www.cbr.ru',Path);
 if AIndex>0 then
  Result:=IncludeTrailingPathDelimiter(Path.Substring(0,AIndex-1))
   else
  Result:=IncludeTrailingPathDelimiter(ExtractFileDir(Path));
end;


procedure TTaxonomyReaderLogForm.FormActivate(Sender: TObject);
begin
 if (FileName.IsEmpty=False) and (Self.FLoading=False) then
  begin
    Self.FLoading:=True;
    Self.ReadTaxonomy;
    Self.BrowseTaxononmy;
  end;

end;

procedure TTaxonomyReaderLogForm.FormCreate(Sender: TObject);
begin
 Reader:=TTaxononmyReader.Create(Self);
 Self.FLoading:=False;
end;

procedure TTaxonomyReaderLogForm.FormDestroy(Sender: TObject);
begin
 Reader.Free;
end;

procedure TTaxonomyReaderLogForm.ReadTaxonomy;
var
 APath:string;
begin
 APath:=FindCbr(FileName);
 if SelectDirectory('Select a directory', '', APath, []) then
  begin
   Reader.TaxonomyPath:=IncludeTrailingPathDelimiter(APath);
   Reader.Lines:=Memo1.Lines;
   Reader.LoadDocument(FileName);
  end;
end;


end.
