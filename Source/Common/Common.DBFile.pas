unit Common.DBFile;

interface

uses
 WinAPI.Windows, System.Classes, System.SysUtils, Data.DB, Vcl.Dialogs,
 System.UITypes,
 Common.ResourceStrings,
 DAC.DatabaseUtils,
 DAC.XDataSet;

 type
 TDBFile = class
   private
    FFileName: string;
    FTableName: string;
    FBlobField: string;
    FKeyField: string;
    FID: Integer;
    FDBName: string;
    procedure FileToBlobField(const FileName: string; Field: TField);
    procedure StreamToBlobField(Stream: TStream; Field: TField);
   public
    property FileName:string read FFileName write FFileName;
    property DBName:string read FDBName write FDBName;
    property TableName:string read FTableName write FTableName;
    property BlobField:string read FBlobField write FBlobField;
    property KeyField: string read FKeyField write FKeyField;
    property ID:Integer read FID write FID;
    function LoadToTable:Integer;
    procedure LoadFromTable;

    class procedure FileFromAppBinaryFiles(const AFileName:string; ID:Integer);
    class function FileToAppBinaryFiles(const AFileName:string; var AppBinaryFilesId: Integer):Integer;
    class function FileToAppBinaryFilesDlg(var AFileName:string; var AppBinaryFilesId:Integer):Boolean;
    class function FileFromAppBinaryFilesDlg(var AFileName:string; AppBinaryFilesId:Integer):Boolean;
    class function GetAppBinaryFileDetails(AppBinaryFilesId:Integer; const DBName:string; out Size:Int64; out UserName, Description:string; out ADate:TDateTime):string;
 end;

implementation


{ TDBFile }
const
 DataQueryFmt = 'SELECT * FROM [%s] WITH (NOLOCK) WHERE [%s] = %d';



class procedure TDBFile.FileFromAppBinaryFiles(const AFileName: string; ID:Integer);
var
 DBFile:TDBFile;
begin
 DBFile:=TDBFile.Create;
  try
   DBFile.FileName:=AFileName;
   DBFile.BlobField:='AData';
   DBFile.TableName:='AppBinaryFiles';
   DBFile.KeyField:='AppBinaryFilesId';
   DBFile.ID:=ID;
   DBFile.LoadFromTable;
  finally
   DBFile.Free;
 end;
end;

class function TDBFile.FileFromAppBinaryFilesDlg(var AFileName: string; AppBinaryFilesId:Integer): Boolean;
var
 Dlg:TSaveDialog;
begin
 Dlg:=TSaveDialog.Create(nil);
 try
  Dlg.FileName:=AFileName;
  Dlg.Filter:=S_OPEN_FILE_FILTER_ALL;
  Dlg.Options:=Dlg.Options+[ofOverwritePrompt];
  Result:=Dlg.Execute;
  if Result then
   begin
    FileFromAppBinaryFiles(Dlg.FileName, AppBinaryFilesId);
    AFileName:=Dlg.FileName;
   end;
 finally
  Dlg.Free;
 end;
end;

class function TDBFile.FileToAppBinaryFiles(const AFileName: string; var AppBinaryFilesId: Integer): Integer;
var
 DBFile:TDBFile;
begin
 DBFile:=TDBFile.Create;
  try
   DBFile.FileName:=AFileName;
   DBFile.BlobField:='AData';
   DBFile.TableName:='AppBinaryFiles';
   DBFile.KeyField:='AppBinaryFilesId';
   DBFile.ID:=AppBinaryFilesId;
   Result:=DBFile.LoadToTable;
  finally
   DBFile.Free;
 end;
end;

class function TDBFile.FileToAppBinaryFilesDlg(var AFileName: string; var AppBinaryFilesId: Integer): Boolean;
var
 Dlg:TOpenDialog;
begin
 Dlg:=TOpenDialog.Create(nil);
 try
  Dlg.FileName:=AFileName;
  Dlg.Filter:=S_OPEN_FILE_FILTER_ALL;
  Result:=Dlg.Execute;
  if Result then
   begin
    AppBinaryFilesId:=FileToAppBinaryFiles(Dlg.FileName, AppBinaryFilesId);
    AFileName:=Dlg.FileName;
   end;
 finally
  Dlg.Free;
 end;
end;


procedure TDBFile.FileToBlobField(const FileName: string; Field: TField);
var
 Stream:TFileStream;
begin
 Stream:=TFileStream.Create(FileName, fmOpenRead);
 try
  StreamToBlobField(Stream,Field);
 finally
   Stream.Free;
 end;
end;


class function TDBFile.GetAppBinaryFileDetails(AppBinaryFilesId: Integer; const DBName:string; out Size:Int64; out UserName, Description:string; out ADate:TDateTime):string;
var
 DataSet:TxDataSet;
resourcestring
  E_APPDBFILE_NOT_FOUND_FMT = 'Cannot find file with @AppBinaryFilesId=%d';
begin
 DataSet:=TxDataSet.Create(nil);
 try
  DataSet.Source:='TDBFile.GetAppBinaryFileDetails';
  DataSet.ProviderName:='spui_AppFileDetails';
  DataSet.SetParameter('AppBinaryFilesId',AppBinaryFilesId);
  DataSet.Open;
  if DataSet.IsEmpty then
   raise Exception.CreateFmt(E_APPDBFILE_NOT_FOUND_FMT,[AppBinaryFilesId]);

  Result:=DataSet.FieldByName('FileName').AsString;
  Size:=DataSet.FieldByName('Size').AsInteger;
  Description:=DataSet.FieldByName('Description').AsString;
 finally
  DataSet.Free;
 end;
end;

procedure TDBFile.LoadFromTable;
var
 DataSet:TxDataSet;
 Field:TField;
resourcestring
  S_CANNOT_SAVE_FROM_BLOBFIELD_FMT = 'Cannot save file from table specified (%s.%s)';
begin
 DataSet:=TxDataSet.Create(nil);
 try
  DataSet.Source:='TDBFile.LoadFromTable';
  DataSet.ProviderName:=string.Format(DataQueryFmt, [TableName, KeyField, ID]);
  DataSet.DBName:=DBName;
  DataSet.Open;
  Field:=DataSet.FieldByName(BlobField);
  if not Assigned(Field) or (Field.IsNull) or (Field.IsBlob=False) then
   raise Exception.CreateFmt(S_CANNOT_SAVE_FROM_BLOBFIELD_FMT, [TableName,BlobField])
    else
  (Field as TBlobField).SaveToFile(FileName);

 finally
  DataSet.Free;
 end;
end;




procedure TDBFile.StreamToBlobField(Stream: TStream; Field: TField);
resourcestring
 S_FIELD_IS_NOT_BLOB_FMT = 'Cannotload data into field [%s]. Invalid field type';
begin
 if Assigned(Field) and (Field.IsBlob) then
  begin
   Field.Clear;
   Stream.Seek(0,0);
  (Field as TBlobField).LoadFromStream(Stream);
  end
   else
  raise Exception.CreateFmt(S_FIELD_IS_NOT_BLOB_FMT,[Field.FieldName]);
end;

function TDBFile.LoadToTable: Integer;
var
 DataSet:TxDataSet;
 NewName:string;
begin
 DataSet:=TxDataSet.Create(nil);
 try
  DataSet.Source:='TDBFile.LoadToTable';
  DataSet.ProviderName:=string.Format(DataQueryFmt, [TableName, KeyField, ID]);
  DataSet.DBName:=DBName;
  DataSet.Open;
   if ID<0 then
    begin
     DataSet.Append;
     DataSet.FieldByName(KeyField).AsInteger:=TDataBaseUtils.NewAppObjectId(sq_AppBinaryFiles);
    end
     else
    DataSet.Edit;
  FileToBlobField(FileName, DataSet.FieldByName(BlobField));

  if Assigned(DataSet.FindField('FileName')) then
   begin
    NewName:=ExtractFileName(FileName);
    NewName:=Trim(ChangeFileExt(NewName,''))+Trim(ExtractFileExt(NewName));
    DataSet.FieldByName('FileName').AsString:=NewName;
   end;
  DataSet.ApplyUpdatesIfChanged;
  Result:=DataSet.FieldByName(KeyField).AsInteger;
 finally
  DataSet.Free;
 end;

end;

end.
