unit CustomControl.Bar.MiceFileButton;

interface
uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  dxBar, cxClasses, cxButtonEdit, cxImage, cxCheckBox, cxCalendar, cxBarEditItem, Data.DB,
  CustomControl.Interfaces,
  DAC.XParams,
  Plugin.Base,
  Dialogs,
  Common.ResourceStrings,
  Common.LookAndFeel,
  Common.Images,
  System.IOUtils;

type
 TMiceBarFileButton = class(TdxBarLargeButton, ICanManageParams, ICanSaveLoadState)
  private
    FPlugin: TBasePlugin;
    FLoading: Boolean;
    FAutoRefresh: Boolean;
    FParamName: string;
    FFileName: string;
    FOriginalCaption: string;
    FOriginalHint: string;
    FFilterMask: string;
    FRecentFiles: TStringList;
    FMenu:TdxBarPopupMenu;
    FClearButton:TdxBarItem;
    FRecentMenu: Boolean;
    FAppCmdId:Integer;
    procedure DoOnClick(Sender:TObject);
    procedure DoRefresh;
    procedure CheckFile;
    procedure SetFileName(const Value: string);
    procedure RestoreDefaults;
    function CreateOpenDialog:TOpenDialog;
    function ReadAnyFile(const FileName: string): string;
    procedure BuildMenu;
    procedure CreateFileLink(const AFileName:string);
    function CreateItem(const ACaption, AHint:string; ImageIndex:Integer):TdxBarItem;
    procedure OnSubItemClick(Sender:TObject);
    procedure ClearAll(Sender:TObject);
    procedure SetRecentMenu(const Value: Boolean);
    procedure EnableMenu;
    function SaveName:string;

    procedure SetParamsTo(Params:TxParams);

    procedure LoadState(Params:TxParams);
    procedure SaveState(Params:TxParams);

  public
    property Loading:Boolean read FLoading write FLoading;
    property AutoRefresh:Boolean read FAutoRefresh write FAutoRefresh;
    property Plugin:TBasePlugin read FPlugin write FPlugin;
    property ParamName:string read FParamName write FParamName;
    property RecentFiles:TStringList read FRecentFiles;
    procedure LoadFromDataSet(DataSet:TDataSet);


    constructor Create(AOwner:TComponent); override;
    destructor Destroy; override;
    class function CreateDefault(AOwner:TBasePlugin; DataSet:TDataSet):TMiceBarFileButton;
  published
    property FileName:string read FFileName write SetFileName;
    property OriginalCaption:string read FOriginalCaption write FOriginalCaption;
    property OriginalHint:string read FOriginalHint write FOriginalHint;
    property FilterMask:string read FFilterMask write FFilterMask;
    property RecentMenu:Boolean read FRecentMenu write SetRecentMenu;
 end;

implementation

{ TMiceBarDateEdit }



procedure TMiceBarFileButton.CheckFile;
begin

end;

procedure TMiceBarFileButton.ClearAll(Sender:TObject);
var
 x:Integer;
begin
 RecentFiles.Clear;
 FileName:='';
 RestoreDefaults;
 for x:=FMenu.ItemLinks.Count-1 downto 0 do
 if FMenu.ItemLinks[x].Item<>FClearButton then
  FMenu.ItemLinks.Delete(x);
end;

constructor TMiceBarFileButton.Create(AOwner: TComponent);
begin
  inherited;
  Align:=TdxBarItemAlign.iaRight;
  OnClick:=DoOnClick;
  ButtonStyle:=TdxBarButtonStyle.bsDefault;
  FRecentFiles:=TStringList.Create;
end;

class function TMiceBarFileButton.CreateDefault(AOwner: TBasePlugin;  DataSet: TDataSet): TMiceBarFileButton;
begin
 Result:=TMiceBarFileButton.Create(AOwner);
 Result.Plugin:= AOwner;
 Result.LoadFromDataSet(DataSet);
 Result.Loading:=False;
 Result.AutoGrayScale:=False;
 Result.Style:=DefaultLookAndFeel.StyleBarItem;
end;

procedure TMiceBarFileButton.BuildMenu;
var
 x:Integer;
 ACount:Integer;
begin
 ACount:=Self.FRecentFiles.Count-1;
 if ACount>10  then
  ACount:=10;
 if Assigned(FMenu) then
  for x:=0 to ACount do
    CreateFileLink(FRecentFiles[x]);
end;

procedure TMiceBarFileButton.CreateFileLink(const AFileName: string);
var
 ImageIndex:Integer;
begin
 ImageIndex:=TImageContainer.FileExtToImageIndex(ExtractFileExt(AFileName));
 CreateItem(ExtractFileName(AFileName), AFileName,ImageIndex);
end;

function TMiceBarFileButton.CreateItem(const ACaption, AHint: string; ImageIndex:Integer):TdxBarItem;
var
  Link: TdxBarItemLink;
begin
if Assigned(FMenu) then
 begin
   Result:=TdxBarButton.Create(Self);
   Result.Caption:=ACaption;
   Result.Hint:=AHint;
   Result.ImageIndex:=ImageIndex;
   Result.OnClick:=OnSubItemClick;

   Link:=FMenu.ItemLinks.Add;
   Link.Item := Result;
   Link.Item.Category:=0;
 end
  else
   Result:=nil;
end;

function TMiceBarFileButton.CreateOpenDialog: TOpenDialog;
begin
 Result:=TOpenDialog.Create(nil);
 Result.FileName:=Self.FileName;
 Result.Options:=Result.Options+[ofFileMustExist];
 if FilterMask.Trim.IsEmpty then
  Result.Filter:=S_OPEN_FILE_FILTER_JSON+'|'+S_OPEN_FILE_FILTER_XML_ONLY
   else
  Result.Filter:=FilterMask;
end;

destructor TMiceBarFileButton.Destroy;
begin
  FRecentFiles.Free;
  inherited;
end;


procedure TMiceBarFileButton.DoRefresh;
begin
if (Assigned(Plugin)) and (AutoRefresh) then
  Plugin.RefreshDataSet;
end;



procedure TMiceBarFileButton.EnableMenu;
begin
if not Assigned(FMenu) then
 begin
  FMenu:=TdxBarPopupMenu.Create(Self);
  Self.DropDownEnabled:=True;
  Self.DropDownMenu:=FMenu;
  ButtonStyle:=TdxBarButtonStyle.bsDropDown;
  FClearButton:=CreateItem(S_COMMON_CLEAR,S_CLEAR_HISTORY,IMAGEINDEX_ACTION_CLEAR);
  FClearButton.OnClick:=ClearAll;
 end;
end;

procedure TMiceBarFileButton.DoOnClick(Sender: TObject);
var
 Dlg:TOpenDialog;
begin
 Dlg:=CreateOpenDialog;
 try
  if Dlg.Execute(FPlugin.Handle) then
   begin
    FileName:=Dlg.FileName;
    CheckFile;
    if RecentFiles.IndexOf(FileName)<0 then
     begin
      RecentFiles.Add(FileName);
      CreateFileLink(FileName);
     end;
    DoRefresh;
   end
 finally
  Dlg.Free;
 end;
end;


procedure TMiceBarFileButton.LoadFromDataSet(DataSet: TDataSet);
begin
  if DataSet.FieldByName('ShowCaption').AsBoolean then
     PaintStyle:=psCaptionGlyph;

  ImageIndex:=DataSet.FieldByName('ImageIndex').AsInteger;
  LargeImageIndex:=DataSet.FieldByName('ImageIndex').AsInteger;
  Width:=DataSet.FieldByName('Width').AsInteger;
  AutoRefresh:=DataSet.FieldByName('AutoRefresh').AsBoolean;
  ParamName:=DataSet.FieldByName('ParamName').AsString;
  OriginalCaption:=DataSet.FieldByName('Caption').AsString;
  Hint:=DataSet.FieldByName('Hint').AsString;
  OriginalHint:=DataSet.FieldByName('Hint').AsString;
  FAppCmdId:=DataSet.FieldByName('AppCmdId').AsInteger;
  RecentMenu:=True;
end;



procedure TMiceBarFileButton.LoadState(Params: TxParams);
begin
 Loading:=True;
  try
   FileName:=VarToStr(Params.ParamByNameDef(ParamName,''));
   RecentFiles.Text:=VarToStr(Params.ParamByNameDef(SaveName,''));
   BuildMenu;
  finally
    Loading:=False;
  end;
end;

procedure TMiceBarFileButton.SaveState(Params: TxParams);
begin
 Params.SetParameter(SaveName,RecentFiles.Text);
 Params.SetParameter(ParamName,FileName);
end;


procedure TMiceBarFileButton.OnSubItemClick(Sender: TObject);
var
 Button:TdxBarButton;
 AFileName:string;
begin
 Button:=Sender as TdxBarButton;
 AFileName:=Button.Hint;
 if TFile.Exists(AFileName) then
  begin
   FileName:=AFileName;
   DoRefresh;
  end
   else
    MessageBox(FPlugin.Handle,PCHar(Format(S_FILE_NOT_FOUND_FMT,[AFileName])),PChar(S_COMMON_ERROR), MB_OK+MB_ICONERROR);
end;

function TMiceBarFileButton.ReadAnyFile(const FileName: string): string;
begin
  try
   Result:=TFile.ReadAllText(FileName, TEncoding.UTF8);
  except
   Result:=TFile.ReadAllText(FileName);
  end;
end;


function TMiceBarFileButton.SaveName: string;
begin
 Result:='AppCmdId'+FAppCmdId.ToString+'RecentList';
end;

procedure TMiceBarFileButton.RestoreDefaults;
begin
 Self.Caption:=Self.OriginalCaption;
 Self.Hint:=OriginalHint;
end;

procedure TMiceBarFileButton.SetFileName(const Value: string);
begin
if FFileName<>Value then
 begin
  FFileName := Value;
  if FFileName.Trim.IsEmpty=False then
   begin
    Caption:=ExtractFileName(Value);
    Hint:=Value;
   end
    else
   RestoreDefaults;
 end;
end;


procedure TMiceBarFileButton.SetParamsTo(Params: TxParams);
begin
 if (FileName.Trim.IsEmpty=False) and TFile.Exists(FileName) then
  Params.SetParameter(ParamName, ReadAnyFile(FileName))
   else
  Params.SetParameter(ParamName, NULL)
end;

procedure TMiceBarFileButton.SetRecentMenu(const Value: Boolean);
begin
 FRecentMenu := Value;
 if Value then
  EnableMenu
   else
  ButtonStyle:=bsDefault;
end;


initialization
  dxBarRegisterItem(TMiceBarFileButton, TdxBarLargeButtonControl, True );
end.
