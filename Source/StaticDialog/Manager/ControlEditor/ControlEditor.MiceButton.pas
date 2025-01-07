unit ControlEditor.MiceButton;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, ControlEditor.Common, cxGraphics,
  cxLookAndFeels, cxLookAndFeelPainters, Vcl.Menus, cxControls, cxContainer,
  cxEdit, dxLayoutcxEditAdapters, Data.DB, dxLayoutContainer, cxClasses,
  cxDropDownEdit, cxButtonEdit, cxDBEdit, cxCheckBox, cxImageComboBox,
  cxTextEdit, cxMaskEdit, dxLayoutControl, Vcl.StdCtrls, cxButtons,
  Vcl.ExtCtrls,
  CustomControl.MiceButton,
  Common.Images,
  Common.Images.SelectDialog,
  dxLayoutControlAdapters;

type
  TControlEditorMiceButton = class(TControlEditorBase)
    btnSelectImage: TcxButton;
    item_btnSelectImage: TdxLayoutItem;
    procedure btnSelectImageClick(Sender: TObject);
  protected
    procedure Load; override;
    procedure Save; override;
    procedure EnterInsertingState; override;
  public
    constructor Create(AOwner: TComponent); override;
  end;

implementation

{$R *.dfm}
{ TControlEditorMiceButton }

procedure TControlEditorMiceButton.btnSelectImageClick(Sender: TObject);
var
 ImageIndex:Integer;
begin
 ImageIndex:=btnSelectImage.OptionsImage.ImageIndex;
 if TSelectImageDialog.Execute(ImageIndex) then
  begin
   if ImageIndex=0  then ImageIndex:=-1;
    btnSelectImage.OptionsImage.ImageIndex:=ImageIndex;
  end;
end;

constructor TControlEditorMiceButton.Create(AOwner: TComponent);
begin
  inherited;
  ControlClassName := TMiceButton.ClassName;
end;

procedure TControlEditorMiceButton.EnterInsertingState;
var
 ANewName:string;
begin
  inherited;
  ANewName:='Button'+ParentDataSet.RecordCount.ToString;;
  DataSet.FieldByName('ControlName').AsString:=ANewName;
  DataSet.FieldByName('Caption').AsString:=ANewName;
end;

procedure TControlEditorMiceButton.Load;
begin
  inherited;
  btnSelectImage.OptionsImage.ImageIndex:=ReadProperty('ImageIndex',-1);
end;

procedure TControlEditorMiceButton.Save;
begin
  WriteProperty('ImageIndex',btnSelectImage.OptionsImage.ImageIndex,-1);
  inherited;
end;

initialization
TControlEditorClassList.RegisterClass(TMiceButton.ClassName,  TControlEditorMiceButton);

end.
