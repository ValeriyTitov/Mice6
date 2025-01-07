unit ManagerDialog.ExternalFile;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Dialog.Basic, cxGraphics,
  cxLookAndFeels, cxLookAndFeelPainters, Vcl.Menus, cxControls, cxContainer,
  cxEdit, cxGroupBox, cxRadioGroup, Vcl.StdCtrls, cxButtons, Vcl.ExtCtrls,
  cxMemo, cxTextEdit,
  Common.DBFile,
  Common.ShellUtils,
  Common.ResourceStrings,
  Common.Images;

type
  TExternalFileDlg = class(TBasicDialog)
    Panel1: TPanel;
    infoMemo: TcxMemo;
    Panel2: TPanel;
    rbSaveAs: TcxRadioButton;
    rbSaveAndExecute: TcxRadioButton;
    Label1: TLabel;
    rbSaveAndBrowse: TcxRadioButton;
    Image1: TImage;
    procedure Label1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure rbSaveAndExecuteDblClick(Sender: TObject);
  private
    FFileName:string;
    FUser:string;
    FDescription:string;
    FDate:TDateTime;
    FSize:Int64;
    FFullPath:string;
    FAppBinaryFilesID: Integer;
    FDBName: string;
    function GetActionType: Integer;
    function CreateFilePath(const AFileName:string):string;
    procedure GetFileInfo;
    procedure UpdateMemo;
  public
    procedure Init;
    procedure SaveAndBrowse;
    procedure SaveAndExecute;
    procedure SaveDlg;
    property ActionType:Integer read GetActionType;
    property AppBinaryFilesID:Integer read FAppBinaryFilesID write FAppBinaryFilesID;
    property DBName:string read FDBName write FDBName;
    class procedure ShowDialog(AppBinaryFilesID:Integer);
    class function NewFileDlg(var FileName:string; var AppBinaryFilesId:Integer; const DBName:string):Boolean;
  end;


implementation

{$R *.dfm}

{ TExternalFileActionDlg }

function TExternalFileDlg.CreateFilePath(const AFileName: string): string;
var
 Path:string;
begin
 Path:=TShellUtils.MiceFolder;
 if Trim(AFileName)<>'' then
  Result:=Path+ExtractFileName(AFileName)
   else
  Result:=Path+'AppBinaryFilesID_'+AppBinaryFilesID.ToString;
end;

procedure TExternalFileDlg.FormCreate(Sender: TObject);
begin
  inherited;
  TImageContainer.LoadToImage(Image1,198);
end;

function TExternalFileDlg.GetActionType: Integer;
begin
 if rbSaveAndExecute.Checked then
  Result:=0 else
  if rbSaveAndBrowse.Checked then
   Result:=1
    else
    Result:=2;
end;

procedure TExternalFileDlg.GetFileInfo;
var
 AUser:string;
 ADescription:string;
 ADate:TDateTime;
 ASize:Int64;
begin
 FFileName:=TDBFile.GetAppBinaryFileDetails(AppBinaryFilesID,DBName, ASize,AUser,ADescription,ADate);
 FUser:=AUser;
 FDescription:=ADescription;
 FDate:=ADate;
 FSize:=ASize;
end;

procedure TExternalFileDlg.Init;
begin
 GetFileInfo;
 Self.Label1.Hint:=TShellUtils.MiceFolder;
 FFullPath:=CreateFilePath(FFileName);
 UpdateMemo;

end;

procedure TExternalFileDlg.Label1Click(Sender: TObject);
begin
  TShellUtils.ShellOpenFolder(TShellUtils.MiceFolder);
end;

class function TExternalFileDlg.NewFileDlg(var FileName: string;  var AppBinaryFilesId: Integer; const DBName:string): Boolean;
begin
 Result:=TDBFile.FileToAppBinaryFilesDlg(FileName, AppBinaryFilesID);
 FileName:=ExtractFileName(FileName);
end;

procedure TExternalFileDlg.rbSaveAndExecuteDblClick(Sender: TObject);
begin
 ModalResult:=mrOK;
end;

procedure TExternalFileDlg.SaveDlg;
var
 s:string;
begin
 s:=FFileName;
 TDBFile.FileFromAppBinaryFilesDlg(s,AppBinaryFilesID);
end;




procedure TExternalFileDlg.SaveAndBrowse;
begin
 if not FileExists(FFullPath) then
  TDBFile.FileFromAppBinaryFiles(FFullPath,AppBinaryFilesID);
 TShellUtils.ShellSelectFile(FFullPath);
end;

procedure TExternalFileDlg.SaveAndExecute;
begin
 if not FileExists(FFullPath) then
  TDBFile.FileFromAppBinaryFiles(FFullPath,AppBinaryFilesID);
 TShellUtils.ShellExecuteSafe(FFullPath,'');
end;

class procedure TExternalFileDlg.ShowDialog(AppBinaryFilesID: Integer);
var
 Dlg:TExternalFileDlg;
begin
 Dlg:=TExternalFileDlg.Create(nil);
 try
  Dlg.AppBinaryFilesID:=AppBinaryFilesID;
  Dlg.Init;
  if Dlg.Execute then
    case Dlg.ActionType of
     0: Dlg.SaveAndExecute;
     1: Dlg.SaveAndBrowse;
     2: Dlg.SaveDlg;
    end;
 finally
  Dlg.Free;
 end;
end;

procedure TExternalFileDlg.UpdateMemo;
begin
 infoMemo.Clear;
 infoMemo.Lines.Add(Format('Name: %s',[FFileName]));
 infoMemo.Lines.Add(Format('Size: %d bytes',[FSize]));
 infoMemo.Lines.Add(Format('Description: %s',[FDescription]));
 infoMemo.Lines.Add(Format('User: %s',[FUser]));
 infoMemo.Lines.Add(Format('Date: %s',[DateToStr(FDate)]));
 infoMemo.Lines.Add(Format('Default save path: %s',[FFullPath]));
end;

end.
