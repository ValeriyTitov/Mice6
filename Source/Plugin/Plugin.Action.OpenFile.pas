unit Plugin.Action.OpenFile;

interface
 uses WinApi.Windows, System.SysUtils, System.IOUtils, System.Classes,
      Vcl.Dialogs, Vcl.Controls, Xml.xmldom, Xml.XMLIntf, Xml.XMLDoc,Xml.omnixmldom,
      System.JSON,
      Plugin.Properties,
      DAC.XDataSet;

type
 TPluginActionOpenFile = class
  private
    FFileExt:string;
    FFileName:string;
    FProperties: TPluginProperties;
    FOwner:TWinControl;
    FText:string;
    procedure ValidateFile;
    procedure ReadFileText;
    procedure UploadContent;
    procedure ValidateJson;
    procedure ValidateXml;
    procedure Init;
  public
    function Execute:Boolean;
    property Properties:TPluginProperties read FProperties;
    constructor Create(AOwner:TWinControl; AProperties:TPluginProperties);
    destructor Destroy; override;
 end;

implementation

{ TPluginActionOpenFile }

constructor TPluginActionOpenFile.Create(AOwner:TWinControl; AProperties:TPluginProperties);
begin
 FProperties:=AProperties;
 FOwner:=AOwner;
end;

destructor TPluginActionOpenFile.Destroy;
begin

  inherited;
end;

procedure TPluginActionOpenFile.UploadContent;
var
 Tmp:TxDataSet;
begin
 Tmp:=TxDataSet.Create(nil);
 try
  Tmp.ProviderName:=Properties.CurrentAction.ProviderName;
  if Properties.CurrentAction.DBName.IsEmpty then
   Tmp.DBName:=Properties.DBName
    else
   Tmp.DBName:=Properties.CurrentAction.DBName;
//  Tmp.Params.LoadFromDataSet(Properties.DataSet);

  Tmp.SetParameter(Properties.CurrentAction.ParamName,FText);
  Tmp.SetParameter('FileName',ExtractFileName(FFileName));
  Tmp.SetParameter('FileExt',FFileExt);
  Tmp.SetParameter('FullPath',FFileName);
  Tmp.Execute;
 finally
  Tmp.Free;
 end;
end;

function TPluginActionOpenFile.Execute: Boolean;
var
 Dlg:TOpenDialog;
begin
 Dlg:=TOpenDialog.Create(FOwner);
 try
  Dlg.Filter:=Properties.CurrentAction.OpenFileFilter;
  Result:= Dlg.Execute(FOwner.Handle);
  if Result then
   begin
    FFileName:=Dlg.FileName;
    Init;
    UploadContent;
   end;
 finally
  Dlg.Free;
 end;
end;



procedure TPluginActionOpenFile.Init;
begin
 FFileExt:=ExtractFileExt(FFileName);
 ReadFileText;
 if Properties.CurrentAction.ValidateBeforeOpen then
  ValidateFile;


end;

procedure TPluginActionOpenFile.ReadFileText;
begin
 FText:=TFile.ReadAllText(FFileName, TEncoding.UTF8);
end;

procedure TPluginActionOpenFile.ValidateFile;
begin
 if FFileExt.ToLower=('.json') then
  ValidateJson
 else
  if FFileExt.ToLower=('.xml') then
   ValidateXml;
end;

procedure TPluginActionOpenFile.ValidateJson;
var
 jValue:TJsonValue;
resourcestring
 E_INVALID_JSONFILE_FMT = 'Json file is invalid %s';
begin
 jValue:=TJsonObject.ParseJSONValue(FText);
 if not Assigned(jValue) then
  raise Exception.CreateFmt(E_INVALID_JSONFILE_FMT,[FFileName]);
end;

procedure TPluginActionOpenFile.ValidateXml;
var
  FXml:TXmlDocument;
  x:Integer;
  Node:IXmlNode;
begin
 FXml:=TXmlDocument.Create(FOwner);
 try
   FXml.DOMVendor:=DOMVendors.Find(sOmniXmlVendor);
   FXml.Options := [doNodeAutoIndent];
   FXml.LoadFromXML(FText);
   FXml.Active:=True;
   for x:=0 to FXml.Node.ChildNodes.Count-1 do
    Node:=FXml.Node.ChildNodes[x];

 finally
   FXml.Free;
 end;

end;

end.
