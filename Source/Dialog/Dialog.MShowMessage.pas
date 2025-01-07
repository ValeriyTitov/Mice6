unit Dialog.MShowMessage;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Dialog.Basic, cxGraphics,
  cxLookAndFeels, cxLookAndFeelPainters, Vcl.Menus, Vcl.StdCtrls, cxButtons,
  Vcl.ExtCtrls, cxControls, cxContainer, cxEdit, cxTextEdit, cxMemo,
  Common.Images,
  Common.ResourceStrings,
  System.Generics.Collections, System.Generics.Defaults, dxBarBuiltInMenu, cxPC,
  Vcl.DBCtrls, Data.DB, dxmdaset,
  CustomControl.MiceSyntaxEdit, Vcl.StdActns, System.Actions, Vcl.ActnList;

type
  TDBMemo = class (TMiceSyntaxEdit)

  end;

  TMessageDialog = class(TBasicDialog)
    pnTop: TPanel;
    Image: TImage;
    lbInfo: TLabel;
    lbRows: TLabel;
    pgTextStyle: TcxPageControl;
    TabSimpleText: TcxTabSheet;
    TabJsonText: TcxTabSheet;
    TabXmlText: TcxTabSheet;
    Memo: TcxMemo;
    dsText: TdxMemData;
    DataSource: TDataSource;
    MemoJson: TDBMemo;
    MemoXml: TDBMemo;
    dsTextTextHolder: TMemoField;
    ActionList1: TActionList;
    EditSelectAll1: TEditSelectAll;
    PopupMenu1: TPopupMenu;
    SelectAll1: TMenuItem;
    EditCopy1: TEditCopy;
    Copy1: TMenuItem;
    procedure MemoPropertiesChange(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure pgTextStylePageChanging(Sender: TObject; NewPage: TcxTabSheet;
      var AllowChange: Boolean);
  private
    FImageIndex: Integer;
    FSaveName: string;
    procedure SetLabelCaption(const Value: string);
    function GetLabelCaption: string;
    procedure SetImageIndex(const Value: Integer);
    procedure UpdateRowCount;
    procedure SetSaveName(const Value: string);
    procedure SetDataText;
  protected
    function DialogSaveName:string; override;
    procedure DetectText;
  published
    property LabelCaption:string read GetLabelCaption write SetLabelCaption;
    property ImageIndex:Integer read FImageIndex write SetImageIndex;
    property SaveName:string read FSaveName write SetSaveName;
    constructor CreateDefault(const WindowCaption, LabelCaption: string; AImageIndex: Integer; AReadOnly:Boolean);
    constructor Create(AOwner:TComponent); override;
    destructor Destroy; override;
    class procedure MShowMessage(const Msg:string);
    class procedure MShowMessageEx(const Msg, WindowCaption, LabelCaption:string; ImageIndex:Integer);
    class procedure MShowMessageList(List:TStrings);
    class procedure MShowMessageListEx(List:TStrings;const WindowCaption, LabelCaption:string;ImageIndex:Integer);
    class function MInputBox(const WindowCaption, LabelCaption: string; var s: string; ImageIndex:Integer):Boolean;
  end;

  procedure MShowMessage(const Msg:string);
implementation

{$R *.dfm}

 procedure MShowMessage(const Msg:string);
 begin
  TMessageDialog.MShowMessage(Msg);
 end;

{ TMShowMessageDlg }


constructor TMessageDialog.Create(AOwner: TComponent);
begin
  inherited;
  SaveName:='Default';
  MemoJson.Syntax:='json';
  MemoXml.Syntax:='xml';
  Self.pgTextStyle.Properties.HideTabs:=True;

//   TBCEditorSyntaxStorage.RegisterSyntax('SQL',FForm.SQLSyntax.Text, FForm.SQLColor.Text);
//   TBCEditorSyntaxStorage.RegisterSyntax('html',FForm.HtmlSyntax.Text, FForm.htmlColor.Text);
//   TBCEditorSyntaxStorage.RegisterSyntax('css',FForm.CssSyntax.Text, FForm.cssColor.Text);
  UpdateRowCount;
end;

constructor TMessageDialog.CreateDefault(const WindowCaption, LabelCaption: string; AImageIndex: Integer; AReadOnly: Boolean);
begin
 Create(Application);
 lbInfo.Caption:=LabelCaption;
 Caption:=WindowCaption;
 pnTop.Visible:=LabelCaption.Trim.IsEmpty=False;
 ImageIndex:=AImageIndex;
 ReadOnly:=AReadOnly;
 Memo.Properties.ReadOnly:=AReadOnly;
 TImageContainer.LoadToImage(Image, ImageIndex);
end;

destructor TMessageDialog.Destroy;
begin
  inherited;
end;

procedure TMessageDialog.DetectText;
var
 FText:string;
begin
 FText:=Memo.Lines.Text.Substring(0,20).Trim;
 if FText.StartsWith('[') or FText.StartsWith('{')  then
  Self.pgTextStyle.ActivePage:=TabJsonText
  else
 if FText.StartsWith('<') or FText.StartsWith('!')  then
  Self.pgTextStyle.ActivePage:=TabXmlText;
end;

function TMessageDialog.DialogSaveName: string;
begin
// Result:='AdaptiveDialogs\AppDialogsId='+Self.AppDialogsId.ToString+'@AppLayoutsId='+Self.AppLayoutsID.ToString;
 Result:='MShowMessage\'+SaveName;
end;

procedure TMessageDialog.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  inherited;
  SaveState;
end;

function TMessageDialog.GetLabelCaption: string;
begin
 Result:=lbInfo.Caption;
end;

procedure TMessageDialog.MemoPropertiesChange(Sender: TObject);
begin
 UpdateRowCount;
end;

class function TMessageDialog.MInputBox(const WindowCaption, LabelCaption: string; var s: string; ImageIndex:Integer): Boolean;
var
 Dlg:TMessageDialog;
begin
 Dlg:=TMessageDialog.CreateDefault(WindowCaption, LabelCaption, ImageIndex, False);
 try
  Dlg.SaveName:='MInputBox';
  Dlg.LoadState(False,True);
  Dlg.Memo.Lines.Text:=s;
  Result:=Dlg.ShowModal=mrOk;
  if Result then
   s:=Dlg.Memo.Lines.Text;
 finally
  Dlg.Free;
 end;
end;

class procedure TMessageDialog.MShowMessage(const Msg: string);
begin
 MShowMessageEx(Msg, Application.Title, S_COMMON_INFORMATION, IMAGEINDEX_INFORMATION);
end;

class procedure TMessageDialog.MShowMessageEx(const Msg, WindowCaption, LabelCaption: string; ImageIndex: Integer);
var
 Dlg:TMessageDialog;
begin
 Dlg:=TMessageDialog.CreateDefault(WindowCaption, LabelCaption, ImageIndex, True);
 try
  Dlg.SaveName:='MShowMessageEx';
  Dlg.LoadState(False,True);
  Dlg.Memo.Lines.Text:=Msg;
  Dlg.DetectText;
  Dlg.ShowModal;
 finally
  Dlg.Free;
 end;
end;


class procedure TMessageDialog.MShowMessageList(List: TStrings);
begin
 MShowMessageListEx(List, Application.Title, S_COMMON_INFORMATION, IMAGEINDEX_INFORMATION);
end;

class procedure TMessageDialog.MShowMessageListEx(List: TStrings; const WindowCaption, LabelCaption: string; ImageIndex: Integer);
var
 Dlg:TMessageDialog;
begin
  Dlg:=TMessageDialog.CreateDefault(WindowCaption, LabelCaption, ImageIndex, True);
 try
  Dlg.SaveName:='MShowMessageListEx';
  Dlg.LoadState(False,True);
  Dlg.Memo.Lines.Assign(List);
  Dlg.DetectText;
  Dlg.ShowModal;
 finally
  Dlg.Free;
 end;
end;

procedure TMessageDialog.pgTextStylePageChanging(Sender: TObject;  NewPage: TcxTabSheet; var AllowChange: Boolean);
begin
  SetDataText;
end;

procedure TMessageDialog.SetDataText;
begin
if Self.dsText.Active=False then
 begin
  Self.dsText.Open;
  Self.dsText.Edit;
  Self.dsText.FieldByName('TextHolder').AsString:=Self.Memo.Lines.Text;
  Self.dsText.Post;
  Self.dsText.ReadOnly:=True;
 end;
end;

procedure TMessageDialog.SetImageIndex(const Value: Integer);
begin
  FImageIndex := Value;
  Image.Picture.Bitmap:=nil;
  ImageContainer.Images32.GetBitmap(Value,Image.Picture.Bitmap);
  FImageIndex := Value;
end;

procedure TMessageDialog.SetLabelCaption(const Value: string);
begin
  lbInfo.Caption:=Value;
end;

procedure TMessageDialog.SetSaveName(const Value: string);
begin
  FSaveName := Value;
end;


procedure TMessageDialog.UpdateRowCount;
begin
 lbRows.Caption:=Format(S_ROWS_FMT,[Memo.Lines.Count]);
 if (ReadOnly=False) then
  bnOK.Enabled:=Self.Memo.Lines.Count<>0;
end;

end.
