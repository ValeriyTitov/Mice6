unit Plugin.PivotGrid;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Plugin.Base, Data.DB, cxGraphics,
  cxControls, cxLookAndFeels, cxLookAndFeelPainters, cxClasses, cxCustomData,
  cxStyles, cxEdit, cxCustomPivotGrid, cxDBPivotGrid, cxSplitter,
  Plugin.SideTreeFilter, Vcl.ExtCtrls;

type
  TPivotPlugin = class(TBasePlugin)
    PivotGrid: TcxDBPivotGrid;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

end.
