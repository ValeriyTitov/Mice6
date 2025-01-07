unit TaxonomyReader.URIResolver;

interface
uses
 System.SysUtils, System.Classes;

type
  TURIResolver = class
  private
    FTaxonomyPath: string;
    public
     function Resolve(const Path, URI:String):string;virtual;
     property TaxonomyPath:string read FTaxonomyPath write FTaxonomyPath;
     constructor Create;
  end;

implementation
const
DEFAULT_TAXONOMY_PATH = 'E:\Tax\';
{ TURIResolver }

constructor TURIResolver.Create;
begin
 TaxonomyPath:=DEFAULT_TAXONOMY_PATH;
end;

function TURIResolver.Resolve(const Path, URI: String): string;
begin
   if URI.StartsWith('http://') then
    Result:=StringReplace(TaxonomyPath+URI.Substring(7),'/','\',[rfReplaceAll])
     else
   Result:=ExpandFileName(IncludeTrailingPathDelimiter(ExtractFilePath(Path)) + URI);
end;




end.
