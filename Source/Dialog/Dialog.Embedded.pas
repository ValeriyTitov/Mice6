unit Dialog.Embedded;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Dialog.Adaptive, cxGraphics,
  cxLookAndFeels, cxLookAndFeelPainters, Vcl.Menus, cxControls, Data.DB,
  cxClasses, dxLayoutContainer, dxLayoutControl, Vcl.StdCtrls, cxButtons,
  Vcl.ExtCtrls,
  CustomControl.Interfaces;

type
  TEmbeddedDialog = class(TAdaptiveDialog)
  private
    procedure RefreshActiveLazyControls;
  public
    procedure CloseAll;
    procedure RefreshID(NewId:Integer);
    function Execute:Boolean; override;
    procedure Merge(AControl: TWinControl);
    constructor Create(AOwner:TComponent); override;
  end;


implementation

{$R *.dfm}

{ TEmbeddedDialog }

procedure TEmbeddedDialog.Merge(AControl: TWinControl);
begin
  Self.Hide;
  Self.DestroyHandle;
  Self.BorderStyle := bsNone;
  Self.BorderIcons := [];
  Self.Parent := AControl;
  AControl.DisableAlign;
  try
    Self.Align := TAlign.alClient;
    Self.Visible := True;
  finally
    AControl.EnableAlign;
  end;
end;


procedure TEmbeddedDialog.CloseAll;
begin
 DataSet.Close;
 DetailDataSets.CloseAll;
end;

constructor TEmbeddedDialog.Create(AOwner: TComponent);
begin
  inherited;
end;

function TEmbeddedDialog.Execute: Boolean;
begin
 Result:=False;
end;

procedure TEmbeddedDialog.RefreshActiveLazyControls;
var
 ILazy:IAmLazyControl;
begin
 for ILazy in ActiveLazyItems do
  ILazy.RefreshDataSet;
end;

procedure TEmbeddedDialog.RefreshID(NewId:Integer);
begin
 ID:=NewID;
 UpdateMasterDetailKey;
 Open;
 RefreshActiveLazyControls;
end;

end.
