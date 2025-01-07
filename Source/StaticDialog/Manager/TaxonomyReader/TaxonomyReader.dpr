program TaxonomyReader;

uses
  Vcl.Forms,
  TaxonomyReader.LogForm in 'TaxonomyReader.LogForm.pas' {TaxonomyReaderLogForm},
  TaxonomyReader.Reader in 'TaxonomyReader.Reader.pas',
  TaxonomyReader.XBRL.Definitions in 'TaxonomyReader.XBRL.Definitions.pas',
  TaxonomyReader.URIResolver in 'TaxonomyReader.URIResolver.pas' {,
  Taxonomy.XBRL.ObjectModel in 'Taxonomy.XBRL.ObjectModel.pas',
  TaxonomyRader.XBRL.DefinitionLinkbase in 'TaxonomyRader.XBRL.DefinitionLinkbase.pas',
  TaxonomyRader.XBRL.LabelLinkBase in 'TaxonomyRader.XBRL.LabelLinkBase.pas',
  TaxonomyReader.XlinkNode in 'TaxonomyReader.XlinkNode.pas';

{$R *.res},
  Taxonomy.XBRL.ObjectModel in 'Taxonomy.XBRL.ObjectModel.pas',
  TaxonomyRader.XBRL.DefinitionLinkbase in 'TaxonomyRader.XBRL.DefinitionLinkbase.pas',
  TaxonomyRader.XBRL.LabelLinkBase in 'TaxonomyRader.XBRL.LabelLinkBase.pas',
  TaxonomyReader.XlinkNode in 'TaxonomyReader.XlinkNode.pas',
  TaxonomyRader.XBRL.BrowserForm in 'TaxonomyRader.XBRL.BrowserForm.pas' {XbrlBrowserForm},
  TaxonomyRader.XBRL.BrowserForm.DataFrame in 'TaxonomyRader.XBRL.BrowserForm.DataFrame.pas' {DataFrame: TFrame};

{$R *.res}

begin
  ReportMemoryLeaksOnShutdown:=True;
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TTaxonomyReaderLogForm, TaxonomyReaderLogForm);
  Application.CreateForm(TXbrlBrowserForm, XbrlBrowserForm);
  Application.Run;
end.
