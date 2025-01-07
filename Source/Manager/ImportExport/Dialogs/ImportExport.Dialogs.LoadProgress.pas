unit ImportExport.Dialogs.LoadProgress;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxContainer, cxEdit, cxTextEdit, cxMemo, Vcl.ComCtrls,
  Vcl.ExtCtrls, cxRichEdit;

type
  TLoadProgressForm = class(TForm)
    Panel1: TPanel;
    ProgressBar1: TProgressBar;
    InfoRich: TcxRichEdit;
   procedure AddText(const Text:string;AType:Integer);
   procedure SetProgress(Current, Max:Integer);
  end;

implementation

{$R *.dfm}

{ TLoadProgressForm }

procedure TLoadProgressForm.AddText(const Text: string; AType:Integer);
begin
 if AType>0 then
  begin
   InfoRich.SelAttributes.Color := clRed;
   InfoRich.SelAttributes.Style := [fsBold];
  end;
 InfoRich.Lines.Add(Text)
end;

procedure TLoadProgressForm.SetProgress(Current, Max: Integer);
begin
 if ProgressBar1.Max<>Max then
  Self.ProgressBar1.Max:=Max;
 Self.ProgressBar1.Position:=Current;
end;

end.
