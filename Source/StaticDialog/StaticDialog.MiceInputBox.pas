unit StaticDialog.MiceInputBox;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxContainer, cxEdit, Vcl.Menus, cxLabel, Vcl.StdCtrls,
  cxButtons, cxTextEdit, Vcl.ExtCtrls,
  Common.Images,
  CustomControl.Interfaces;

type
  TMiceInputBox = class;

  TMiceInputBoxClass = class of TMiceInputBox;

  TMiceInputBox = class(TForm)
    Image: TImage;
    edText: TcxTextEdit;
    bnOK: TcxButton;
    bnCancel: TcxButton;
    lbText: TcxLabel;
    Timer1: TTimer;
    procedure edTextPropertiesChange(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
  private
    FTicks:Int64;
    FImageIndex: Integer;
    FOnDelayedChange: TNotifyEvent;
    procedure SetText(const Value: string);
    function GetText: string;
    procedure SetImageIndex(const Value: Integer);
  protected
    procedure DoOnDelayedChanged; virtual;
  public
    property Text:string read GetText write SetText;
    property ImageIndex:Integer read FImageIndex write SetImageIndex;
    property OnDelayedChange:TNotifyEvent read FOnDelayedChange write FOnDelayedChange;
    class function Execute(ImageIndex: Integer;  var s: string; const LabelText:string=''; const Caption: string=''):Boolean; virtual;
    class function ExecuteAsClass(ImageIndex: Integer;  var s: string; AClass : TMiceInputBoxClass; const LabelText:string=''; const Caption: string=''):Boolean;
  end;


implementation

{$R *.dfm}

{ TMiceInputBox }

procedure TMiceInputBox.DoOnDelayedChanged;
begin
 if Assigned(OnDelayedChange) then
  OnDelayedChange(Self);
end;

procedure TMiceInputBox.edTextPropertiesChange(Sender: TObject);
begin
if Trim(edText.Text)<>'' then
 begin
  FTicks:=GetTickCount;
   if Assigned(OnDelayedChange) then
    Timer1.Enabled:=True
     else
    bnOK.Enabled:=Text<>'';
 end;
end;

class function TMiceInputBox.Execute(ImageIndex: Integer;  var s: string; const LabelText:string=''; const Caption: string=''): Boolean;
begin
 Result:=ExecuteAsClass(ImageIndex,s, TMiceInputBox, LabelText,Caption);
end;

class function TMiceInputBox.ExecuteAsClass(ImageIndex: Integer; var s: string;  AClass: TMiceInputBoxClass; const LabelText, Caption: string): Boolean;
var
 Dlg:TMiceInputBox;
begin
 Dlg:=AClass.Create(nil);
  try
   if LabelText<>'' then
   Dlg.lbText.Caption:=LabelText;
   Dlg.Text:=s;
   if Caption<>'' then
   Dlg.Caption:=Caption;
   Dlg.ImageIndex:=ImageIndex;
   Result:=Dlg.ShowModal=mrOk;
    if Result then
      s:=Dlg.Text;
  finally
   Dlg.Free;
  end;
end;


function TMiceInputBox.GetText: string;
begin
 Result:=Self.edText.Text;
end;


procedure TMiceInputBox.SetImageIndex(const Value: Integer);
begin
  Image.Picture.Bitmap:=nil;
  ImageContainer.Images32.GetBitmap(Value,Image.Picture.Bitmap);
  FImageIndex := Value;
end;


procedure TMiceInputBox.SetText(const Value: string);
begin
  edText.Text := Value;
end;

procedure TMiceInputBox.Timer1Timer(Sender: TObject);
begin
 if (FTicks+500<GetTickCount) then
  begin
    Self.Timer1.Enabled:=False;
    Self.DoOnDelayedChanged;
  end;

end;

end.
