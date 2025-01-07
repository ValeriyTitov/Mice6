unit AppTemplate.Builder.Xbrl;

interface
uses  Data.DB, System.Classes, System.SysUtils, System.Variants,
      cxDBTL, cxTL,
      AppTemplate.Builder.Abstract,
      DAC.XDataSet;

type
 TAppTemplateBuilderXbrl = class(TAbstractAppTemplateBuilder)
  private

  public
    procedure Execute; override;
    constructor Create; override;
 end;

implementation


{ TAppTemplateBuilderXbrl }

constructor TAppTemplateBuilderXbrl.Create;
begin
  inherited;

end;

procedure TAppTemplateBuilderXbrl.Execute;
begin
  inherited;
  raise Exception.Create('Not implemented in '+ClassName);
end;

end.
