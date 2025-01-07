unit ManagerEditor.Script.Runner.Xml;

interface

uses
  System.Classes, System.SysUtils, Data.DB,
  Xml.xmldom, Xml.XMLIntf, Xml.XMLDoc, msxmldom,
  ManagerEditor.Script.Runner;

type
  TXmlScriptRunner = class (TCustomScriptRunner)
   private
    FOwner:TComponent;
    FStream:TStringStream;
    procedure InternalExecute;
   protected
    procedure DoOnSuccess(DataSet:TDataSet); override;
    procedure DoOnError(const Msg:string); override;
   public
    function Format:string;override;
    procedure Run; override;
    constructor Create; override;
    destructor Destroy; override;
   end;
implementation

{ TXmlScriptRunner }


constructor TXmlScriptRunner.Create;
begin
  inherited;
  Syntax:='Xml';
  DefaultExtension:='.xml';
  FOwner:=TComponent.Create(nil);
end;

destructor TXmlScriptRunner.Destroy;
begin
  FOwner.Free;
  inherited;
end;

procedure TXmlScriptRunner.DoOnError(const Msg: string);
begin
  InfoLines.Add(Msg);
  inherited;
end;

procedure TXmlScriptRunner.DoOnSuccess(DataSet: TDataSet);
begin
  InfoLines.Add('Validation succsessfull');
  inherited;
end;

function TXmlScriptRunner.Format: string;
begin
 try
  Result:=FormatXMLData(Text.Text);
  DoOnSuccess(nil);
 except on E:Exception do
  begin
   Result:=Text.Text;
   DoOnError(E.Message);
  end;
 end;
end;

procedure TXmlScriptRunner.InternalExecute;
var
 FXml:TXMLDocument;
begin
FXml:=TXMLDocument.Create(FOwner);
 try
  try
    FXml.Active:=False;
    FXml.LoadFromStream(FStream);
    FXml.Encoding:='UTF-8';
    FXml.Active:=True;
    DoOnSuccess(nil);
   except on E:Exception do
    DoOnError(E.Message);
   end;
 finally
  FXml.Free;
 end;

end;

procedure TXmlScriptRunner.Run;
begin
  inherited;
  FStream:=TStringStream.Create(Text.Text);
  try
   InternalExecute;
  finally
    FStream.Free;
  end;
end;

end.
