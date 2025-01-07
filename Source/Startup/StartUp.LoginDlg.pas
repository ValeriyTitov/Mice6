unit StartUp.LoginDlg;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, cxGraphics, cxLookAndFeels, cxLookAndFeelPainters,
  StdCtrls, cxButtons, cxControls, cxContainer, cxEdit, cxLabel,
  cxMaskEdit, cxDropDownEdit, cxTextEdit, ExtCtrls, Menus,
  cxImageComboBox, dxGDIPlusClasses,
  cxCheckBox,System.ImageList,
  Vcl.ImgList,
  Winapi.ShellAPI,
  StartUp.ProjectSettingsDlg,
  Startup.ProjectList,
  DAC.ConnectionMngr,
  Common.Config.ApplicationSettings,
  Common.ResourceStrings,
  Common.ExeVersion, dxActivityIndicator,
  Thread.Basic;

type
  TStartupLoginDialog = class(TForm)
    Image1: TImage;
    MainLogo: TImage;
    imSettings: TImage;
    bnOK: TcxButton;
    bnCancel: TcxButton;
    edPassword: TcxTextEdit;
    edUserName: TcxTextEdit;
    cxLabel1: TcxLabel;
    cxLabel2: TcxLabel;
    cxLabel3: TcxLabel;
    lbSettings: TcxLabel;
    lbVersion: TcxLabel;
    cbSaveUserName: TcxCheckBox;
    cbProject: TcxImageComboBox;
    ImageList1: TImageList;
    lbMailToTitov: TcxLabel;
    lbTitov: TcxLabel;
    lbTitle1: TcxLabel;
    Activity: TdxActivityIndicator;
    Timer1: TTimer;
    procedure Image1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormShow(Sender: TObject);
    procedure lbSettingsClick(Sender: TObject);
    procedure lbSettingsMouseEnter(Sender: TObject);
    procedure lbSettingsMouseLeave(Sender: TObject);
    procedure bnOKClick(Sender: TObject);
    procedure lbMailToTitovClick(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure bnCancelClick(Sender: TObject);
    procedure cbProjectPropertiesChange(Sender: TObject);
  private
    FConnectionJson:string;
    function AddProjectItem(const Description, cs:string;AskPassword:Boolean; const ImageIndex: Integer):Integer;
    procedure CenterControl(Control:TWinControl);
    procedure SetPassword(const Value: string);
    procedure SetSaveUserName(const Value: Boolean);
    procedure SetUserName(const Value: String);
    function GetPassword: string;
    function GetSaveUserName: Boolean;
    function GetUserName: string;
    function GetLastProject: string;
    procedure SetLastProject(const Value: string);
    procedure SetAskPasswordState(const Value:Boolean);
    procedure DisableButtons;
    procedure EnableButtons;
    function GetConnectionString: string;
    procedure FindLastProject(ProjectName:string);
    procedure LoadDropDownProjects;
    procedure UpdateDropDownChange;
    procedure Load;
    procedure Save;
    procedure StartAnimation;
    procedure StopAnimation;
    procedure HandleError(Sender:TObject);
    procedure HandleSuccess(Sender:TObject);
    procedure SaveApplicationSettings;
  public
    property UserName:String read GetUserName write SetUserName;
    property SaveUserName:Boolean read GetSaveUserName write SetSaveUserName;
    property Password:string read GetPassword write SetPassword;
    property LastProject:string read GetLastProject write SetLastProject;
    procedure TryConnect;
    property ConnectionString:string read GetConnectionString;
    function ProgramVersion:string;
    class function Execute:Boolean;
  end;

implementation

{$R *.dfm}


resourcestring
 S_STARTUP_LOGIN_DIALOG_CAPTION  ='Logon to Mice';
 S_STARTUP_LOGIN_DIALOG_CAPTION_MANAGER  ='Logon to Mice Manager';
 S_LB_VERSION_CAPTION_FMT ='Version %s';

const
  S_AUTHOR_FMT ='%d, Valeriy Titov';

procedure TStartupLoginDialog.Image1MouseDown(Sender: TObject; Button: TMouseButton;Shift: TShiftState; X, Y: Integer);
const
  SC_DRAGMOVE = $F012;
begin
 if Button = mbLeft then
  begin
    ReleaseCapture;
    Perform(WM_SYSCOMMAND, SC_DRAGMOVE, 0);
  end;
end;

procedure TStartupLoginDialog.lbSettingsClick(Sender: TObject);
begin
 If TProjectSettingsDlg.Execute then
   LoadDropDownProjects;
end;

procedure TStartupLoginDialog.lbSettingsMouseEnter(Sender: TObject);
begin
 lbSettings.Style.TextColor:=clBlack;
end;

procedure TStartupLoginDialog.lbSettingsMouseLeave(Sender: TObject);
begin
 lbSettings.Style.TextColor:=clTeal;
end;

procedure TStartupLoginDialog.Load;
begin
 TProjectList.DefaultProject.LoadProjects;
 SaveUserName:= TProjectList.DefaultProject.SaveUserName;
 if SaveUserName then
  UserName:= TProjectList.DefaultProject.LastUserName;
 LoadDropDownProjects;
end;

procedure TStartupLoginDialog.LoadDropDownProjects;
var
 P:TProject;
begin
 cbProject.Properties.Items.Clear;
 for P in  TProjectList.DefaultProject.Projects do
  AddProjectItem(P.ProjectName,P.ConnectionString,P.AskPassword,1);

 FindLastProject(TProjectList.DefaultProject.LastProject);
 UpdateDropDownChange;
end;

function TStartupLoginDialog.ProgramVersion: string;
begin
 Result:=TExeVerion.GetSelfVersion;
end;

procedure TStartupLoginDialog.Save;
var
 P:TProjectList;
begin
 P:=TProjectList.DefaultProject;

 P.LastProject:=Self.GetLastProject;
 P.SaveUserName:=Self.SaveUserName;
 if SaveUserName then
  P.LastUserName:=Self.UserName
   else
  P.LastUserName:='';

  P.SaveCommon;
end;

procedure TStartupLoginDialog.SaveApplicationSettings;
resourcestring
 E_SERVER_ADDRESS_IS_EMPTY = 'Server address is empty';
begin
 ApplicationSettings.LoadFromString(ConnectionString);
 ApplicationSettings.ProjectName:=LastProject;
 if ApplicationSettings.ServerAddress.Trim.IsEmpty then
  raise Exception.Create(E_SERVER_ADDRESS_IS_EMPTY);
 if TProjectList.DefaultProject.ProjectByName(LastProject).AskPassword then
  begin
   ApplicationSettings.UserName:=Self.UserName;
   ApplicationSettings.Password:=Self.Password;
  end;
 end;

procedure TStartupLoginDialog.SetAskPasswordState(const Value: Boolean);
begin
 Self.edPassword.Enabled:=Value;
 Self.edUserName.Enabled:=Value;
 Self.cbSaveUserName.Enabled:=Value;
end;

procedure TStartupLoginDialog.SetLastProject(const Value: string);
begin
 //FindLastProject(Value);
end;


procedure TStartupLoginDialog.SetPassword(const Value: string);
begin
 edPassword.Text:=Value;
end;

procedure TStartupLoginDialog.SetSaveUserName(const Value: Boolean);
begin
  self.cbSaveUserName.Checked:=Value;
end;

procedure TStartupLoginDialog.SetUserName(const Value: String);
begin
 edUserName.Text:=Value;
end;

procedure TStartupLoginDialog.StartAnimation;
begin
 Self.Timer1.Enabled:=True;
 end;

procedure TStartupLoginDialog.StopAnimation;
begin
 Self.Timer1.Enabled:=False;
 Self.Activity.Active:=False;
end;

procedure TStartupLoginDialog.Timer1Timer(Sender: TObject);
begin
 Activity.Active:=True;
 Timer1.Enabled:=False;
end;

procedure TStartupLoginDialog.TryConnect;
begin
 SaveApplicationSettings;
 DisableButtons;
 StartAnimation;
 ConnectionManager.CheckConnectionAsync(HandleError,HandleSuccess);
end;

procedure TStartupLoginDialog.UpdateDropDownChange;
begin
 if cbProject.ItemIndex>=0 then
  begin
   SetAskPasswordState(Boolean(cbProject.Properties.Items[cbProject.ItemIndex].Tag));
   bnOK.Enabled:=cbProject.ItemIndex>=0;
  end;
end;

function TStartupLoginDialog.AddProjectItem(const Description, cs: string; AskPassword: Boolean; const ImageIndex: Integer):Integer;
var
 Item: TcxImageComboBoxItem;
begin
 Item:=cbProject.Properties.Items.Add;
 Item.Description:=Description;
 Item.Value:=CS;
 Item.Tag:=Integer(AskPassword);
 Item.ImageIndex:=ImageIndex;
 Result:=Item.Index;
end;

procedure TStartupLoginDialog.bnCancelClick(Sender: TObject);
begin
 ConnectionManager.AbortConnection;
 ReportMemoryLeaksOnShutDown:=False;
end;

procedure TStartupLoginDialog.bnOKClick(Sender: TObject);
begin
 TryConnect;
end;

procedure TStartupLoginDialog.cbProjectPropertiesChange(Sender: TObject);
begin
 UpdateDropDownChange;
end;

procedure TStartupLoginDialog.CenterControl(Control: TWinControl);
begin
 Control.Left:=(Width div 2) - (Control.Width div 2);
end;

procedure TStartupLoginDialog.EnableButtons;
begin
 Self.bnOK.Enabled:=True;
 Self.lbSettings.Enabled:=True;
 Self.cbProject.Enabled:=True;
 UpdateDropDownChange;
end;

procedure TStartupLoginDialog.DisableButtons;
begin
 Self.bnOK.Enabled:=False;
 Self.lbSettings.Enabled:=False;

 Self.edPassword.Enabled:=False;
 Self.edUserName.Enabled:=False;
 Self.cbSaveUserName.Enabled:=False;
 Self.cbProject.Enabled:=False;

end;

procedure TStartupLoginDialog.lbMailToTitovClick(Sender: TObject);
const
 MailTo='mailto:Titov.vb@mail.ru?subject=Mice6,%20version%20<ver>&body=Dear%20Valery,%20';
begin
// ShellExecute(Handle,'MailTo','Titov.vb@mail.ru','','',0);
 ShellExecute(Handle, 'open', PWideChar(StringReplace(MailTo,'<ver>',ProgramVersion,[])),nil, nil, SW_SHOWNORMAL);
end;



class function TStartupLoginDialog.Execute: Boolean;
var
 Dlg:TStartupLoginDialog;
begin
Application.CreateForm(TStartupLoginDialog, Dlg);
 try
  Dlg.Load;
  Dlg.Caption:=S_STARTUP_LOGIN_DIALOG_CAPTION;
  Result:=Dlg.ShowModal=mrOK;
  if Result then
   Dlg.Save;
 finally
   Dlg.Free;
 end;
end;

procedure TStartupLoginDialog.FindLastProject(ProjectName: string);
var
 X:Integer;
 Item: TcxImageComboBoxItem;
begin
 if ProjectName='' then Exit;

 for x:=0 to cbProject.Properties.Items.Count-1 do
  begin
    Item:=cbProject.Properties.Items[x];
    if Item.Description=ProjectName then
     begin
      cbProject.ItemIndex:=X;
      exit;
     end;
  end;
 cbProject.ItemIndex:=AddProjectItem(ProjectName,'',False,3);
end;

procedure TStartupLoginDialog.FormShow(Sender: TObject);
begin
 lbVersion.Caption:=Format(S_LB_VERSION_CAPTION_FMT,[ProgramVersion]);
 lbTitov.Caption:=Format(S_AUTHOR_FMT,[2024]);
 CenterControl(lbVersion);
 CenterControl(lbMailToTitov);
 CenterControl(lbTitov);
 CenterControl(lbTitle1);
end;


function TStartupLoginDialog.GetConnectionString: string;
begin
{ if TProjectList.DefaultProject.ProjectByName(LastProject).AskPassword then
  Result:=GenerateConnectionString
   else
 }
  Result:=TProjectList.DefaultProject.ProjectByName(LastProject).ConnectionString;
end;

function TStartupLoginDialog.GetLastProject: string;
begin
 Result:='';
 if cbProject.ItemIndex<cbProject.Properties.Items.Count then
  Result:=cbProject.Properties.Items[cbProject.ItemIndex].Description;
end;

function TStartupLoginDialog.GetPassword: string;
begin
 Result:=edPassword.Text;
end;

function TStartupLoginDialog.GetSaveUserName: Boolean;
begin
 Result:=cbSaveUserName.Checked;
end;

function TStartupLoginDialog.GetUserName: string;
begin
 Result:=edUserName.Text;
end;

procedure TStartupLoginDialog.HandleError(Sender: TObject);
var
 Msg:PChar;
begin
 Self.StopAnimation;
 EnableButtons;
 ConnectionManager.ClearThread;
 Msg:=PChar((Sender as TBasicThread).ErrorMessage);
 MessageBox(Handle,Msg,PCHar(S_COMMON_ERROR), MB_OK+MB_ICONSTOP);
end;

procedure TStartupLoginDialog.HandleSuccess(Sender: TObject);
begin
 ConnectionManager.ClearThread;
 FConnectionJson:=ConnectionManager.ConnectionResult;
 ConnectionManager.SetMetaConnection(FConnectionJson);
 ModalResult:=mrOK;
end;

end.
