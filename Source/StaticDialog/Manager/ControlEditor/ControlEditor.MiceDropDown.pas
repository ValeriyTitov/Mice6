unit ControlEditor.MiceDropDown;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, ControlEditor.Common, cxGraphics,
  cxLookAndFeels, cxLookAndFeelPainters, Vcl.Menus, cxControls, cxContainer,
  cxEdit, dxLayoutcxEditAdapters, Data.DB, dxLayoutContainer, cxClasses,
  cxDropDownEdit, cxButtonEdit, cxDBEdit, cxCheckBox, cxImageComboBox,
  cxTextEdit, cxMaskEdit, dxLayoutControl, Vcl.StdCtrls, cxButtons, Vcl.ExtCtrls,
  CustomControl.MiceDropDown, CustomControl.MiceDropDown.EditorFrame,
  System.Json,
  Common.JsonUtils;


type
  TControlEditorMiceDropDown = class(TControlEditorBase)
    dxLayoutItem1: TdxLayoutItem;
    ddFrame: TDropDownEditorFrame;
    procedure cbDBNamePropertiesChange(Sender: TObject);
  private
  protected
    procedure Load; override;
    procedure Save; override;
  public
    constructor Create(AOwner:TComponent); override;
  end;


implementation

{$R *.dfm}

{ TControlEditorMiceDropDown }

procedure TControlEditorMiceDropDown.cbDBNamePropertiesChange(Sender: TObject);
begin
  inherited;
  ddFrame.TargetDBName:=TargetDBName;
end;

constructor TControlEditorMiceDropDown.Create(AOwner: TComponent);
begin
  inherited;
  ControlClassName:=TMiceDropDown.ClassName;
  ddFrame.edDDProviderName.Hint:=S_DEFAULT_PROVIDER_PATTERN_HINT;
end;


procedure TControlEditorMiceDropDown.Load;
begin
  inherited;
  ddFrame.TargetDBName:=TargetDBName;
  ddFrame.LoadFromMiceAppObject(MiceAppObject);
end;

procedure TControlEditorMiceDropDown.Save;
begin
  ddFrame.SaveToMiceMiceAppObject(MiceAppObject);
  ddFrame.TargetDBName:=DataSet.FieldByName('DBName').AsString;
  inherited;
end;



initialization
  TControlEditorClassList.RegisterClass(TMiceDropDown.ClassName, TControlEditorMiceDropDown);
end.
