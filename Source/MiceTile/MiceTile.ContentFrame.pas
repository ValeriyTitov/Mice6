unit MiceTile.ContentFrame;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, dxBar, cxClasses,
  cxGraphics, cxControls, cxLookAndFeels, cxLookAndFeelPainters,
  dxStatusBar,
  Common.Images, dxSkinsCore, dxSkinDevExpressDarkStyle;

type
  TTileContentFrame = class(TFrame)
    BarManager: TdxBarManager;
    dxStatusBar1: TdxStatusBar;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

end.
