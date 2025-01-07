unit CustomControl.MiceSyntaxEdit.SyntaxStorage;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, System.Generics.Collections,
  Vcl.StdCtrls, System.Generics.Defaults;

type
  TSyntaxStorageForm = class(TForm)
    SQLSyntax: TMemo;
    PascalColor: TMemo;
    PascalSyntax: TMemo;
    JSColor: TMemo;
    JSSyntax: TMemo;
    XMLColor: TMemo;
    XMLSyntax: TMemo;
    SQLColor: TMemo;
    JsonColor: TMemo;
    JsonSyntax: TMemo;
    CSharpColor: TMemo;
    CSharpSyntax: TMemo;
    htmlSyntax: TMemo;
    htmlColor: TMemo;
    cssSyntax: TMemo;
    cssColor: TMemo;
    PgSQLSyntax: TMemo;
    PgSQLColors: TMemo;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

TBCEditorSyntaxItem = class
  strict private
    FSyntax: string;
    FColor: string;
    FCompletionProposalShortCut: string;
    FCompletionProposalActive: Boolean;
  public
    property Syntax:string read FSyntax write FSyntax;
    property Color:string read FColor write FColor;
    property CompletionProposalActive: Boolean read FCompletionProposalActive write FCompletionProposalActive;
    property CompletionProposalShortCut: string read FCompletionProposalShortCut write FCompletionProposalShortCut;
    constructor Create(const ASyntax, AColor: string);
  end;

  TBCEditorSyntaxStorage = class
   public
    class function GetSyntax(const SyntaxName:string):TBCEditorSyntaxItem;
    class procedure RegisterSyntax(const SyntaxName, SyntaxJson, ColorJson:string);
  end;

implementation

var
 FStorage:TObjectDictionary<string,TBCEditorSyntaxItem>;
 FForm: TSyntaxStorageForm;

 {$R *.dfm}

{ TBCEditorSyntaxItem }

constructor TBCEditorSyntaxItem.Create(const ASyntax, AColor: string);
begin
 FSyntax:=ASyntax;
 FColor:=AColor;
 CompletionProposalActive:=False;
 CompletionProposalShortCut:=string.empty;
end;

{ TBCEditorSyntaxStorage }

class function TBCEditorSyntaxStorage.GetSyntax(const SyntaxName: string): TBCEditorSyntaxItem;
begin
if FStorage.ContainsKey(SyntaxName) then
  Result:=FStorage[SyntaxName]
   else
  raise Exception.CreateFmt('Cannot find syntax "%s"',[SyntaxName]);
end;

class procedure TBCEditorSyntaxStorage.RegisterSyntax(const SyntaxName,  SyntaxJson, ColorJson: string);
begin
 if FStorage.ContainsKey(SyntaxName) then
  raise Exception.CreateFmt('Syntax named %s already registered',[SyntaxName])
   else
  FStorage.Add(SyntaxName, TBCEditorSyntaxItem.Create(SyntaxJson, ColorJson));
end;

initialization
FForm:=TSyntaxStorageForm.Create(nil);
 try
   FStorage:=TObjectDictionary<string,TBCEditorSyntaxItem>.Create([doOwnsValues], TIStringComparer.Ordinal);
   TBCEditorSyntaxStorage.RegisterSyntax('SQL',FForm.SQLSyntax.Text, FForm.SQLColor.Text);
   TBCEditorSyntaxStorage.RegisterSyntax('Pascal',FForm.PascalSyntax.Text, FForm.PascalColor.Text);
   TBCEditorSyntaxStorage.RegisterSyntax('JavaScript',FForm.JSSyntax.Text, FForm.JSColor.Text);
   TBCEditorSyntaxStorage.RegisterSyntax('Json',FForm.JsonSyntax.Text, FForm.JsonColor.Text);
   TBCEditorSyntaxStorage.RegisterSyntax('Xml',FForm.XMLSyntax.Text, FForm.XMLColor.Text);
   TBCEditorSyntaxStorage.RegisterSyntax('C#',FForm.CSharpSyntax.Text, FForm.CSharpColor.Text);
   TBCEditorSyntaxStorage.RegisterSyntax('html',FForm.HtmlSyntax.Text, FForm.htmlColor.Text);
   TBCEditorSyntaxStorage.RegisterSyntax('css',FForm.CssSyntax.Text, FForm.cssColor.Text);
   FStorage['SQL'].CompletionProposalActive:=True;
   FStorage['Pascal'].CompletionProposalActive:=True;
   FStorage['C#'].CompletionProposalActive:=True;

 finally
  FForm.Free;
 end;



finalization
 FStorage.Free;

end.
