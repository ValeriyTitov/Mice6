unit ControlEditor.ClientEdit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, ControlEditor.Common, cxGraphics,
  cxLookAndFeels, cxLookAndFeelPainters, Vcl.Menus, cxControls, cxContainer,
  cxEdit, dxLayoutcxEditAdapters, Data.DB, dxLayoutContainer, cxClasses,
  cxButtonEdit, cxDBEdit, cxCheckBox, cxTextEdit, cxMaskEdit, cxDropDownEdit,
  cxImageComboBox, dxLayoutControl, Vcl.StdCtrls, cxButtons, Vcl.ExtCtrls,
  CustomControl.MiceClientEdit;


type
  TControlEditorClientEdit = class(TControlEditorBase)
  end;


implementation

{$R *.dfm}

initialization
 TControlEditorClassList.RegisterClass(TMiceClientEdit.ClassName,  TControlEditorClientEdit);


end.
