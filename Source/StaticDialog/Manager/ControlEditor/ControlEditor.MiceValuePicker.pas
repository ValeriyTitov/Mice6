unit ControlEditor.MiceValuePicker;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, ControlEditor.Common, cxGraphics,
  cxLookAndFeels, cxLookAndFeelPainters, Vcl.Menus, cxControls, cxContainer,
  cxEdit, dxLayoutcxEditAdapters, Data.DB, dxLayoutContainer, cxClasses,
  cxDropDownEdit, cxButtonEdit, cxDBEdit, cxCheckBox, cxTextEdit, cxMaskEdit,
  cxImageComboBox, dxLayoutControl, Vcl.StdCtrls, cxButtons, Vcl.ExtCtrls,
  dxLayoutControlAdapters,
  CustomControl.MiceValuePicker,
  Common.Images,
  StaticDialog.AppObjectSelector;

type
  TControlEditorMiceValuePicker = class(TControlEditorBase)
    edProvider: TcxButtonEdit;
    edProvider_Item: TdxLayoutItem;
    edParentId: TcxTextEdit;
    dxLayoutItem1: TdxLayoutItem;
    edEnabledValue: TcxTextEdit;
    dxLayoutItem2: TdxLayoutItem;
    edImageIndex: TcxTextEdit;
    dxLayoutItem3: TdxLayoutItem;
    edEnabledField: TcxTextEdit;
    dxLayoutItem4: TdxLayoutItem;
    item_DataFields: TdxLayoutGroup;
    edKeyField: TcxTextEdit;
    dxLayoutItem5: TdxLayoutItem;
    edListProviderName: TcxButtonEdit;
    dxLayoutItem6: TdxLayoutItem;
    cbDialogType: TcxImageComboBox;
    dxLayoutItem7: TdxLayoutItem;
    edDescriptionFieldName: TcxTextEdit;
    dxLayoutItem8: TdxLayoutItem;
    bnAuto: TcxButton;
    dxLayoutItem9: TdxLayoutItem;
    cbEnableClearButton: TcxCheckBox;
    dxLayoutItem10: TdxLayoutItem;
    edCaptionField: TcxTextEdit;
    dxLayoutItem11: TdxLayoutItem;
    dxLayoutAutoCreatedGroup3: TdxLayoutAutoCreatedGroup;
    item_TreeGroup: TdxLayoutGroup;
    item_GridReference: TdxLayoutGroup;
    edGridRef: TcxButtonEdit;
    item_edGridReference: TdxLayoutItem;
    procedure edProviderPropertiesButtonClick(Sender: TObject; AButtonIndex: Integer);
    procedure edListProviderNamePropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
    procedure cbDataFieldExit(Sender: TObject);
    procedure cbDialogTypePropertiesChange(Sender: TObject);
    procedure bnAutoClick(Sender: TObject);
    procedure edGridRefPropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
  private
    FTreeFields: Boolean;
    procedure SetTreeFields(const Value: Boolean);
    procedure SetGridReference(const Value:Boolean);
    procedure AutoFill;
  protected
    procedure Load; override;
    procedure Save; override;
    procedure EnterInsertingState; override;
    property TreeFields:Boolean read FTreeFields write SetTreeFields;
  public
    constructor Create(AOwner: TComponent); override;
  end;


implementation

{$R *.dfm}

{ TControlEditorBase2 }

procedure TControlEditorMiceValuePicker.cbDataFieldExit(Sender: TObject);
begin
  inherited;
  if (Trim(edKeyField.Text)='') then
   edKeyField.Text:=cbDataField.Text;
end;

procedure TControlEditorMiceValuePicker.cbDialogTypePropertiesChange( Sender: TObject);
begin
 case cbDialogType.ItemIndex of
  0: TreeFields:=True;
  1: TreeFields:=False;
  2: SetGridReference(True);
 end;
end;

constructor TControlEditorMiceValuePicker.Create(AOwner: TComponent);
begin
  inherited;
  ControlClassName:=TMiceValuePicker.ClassName;
  edListProviderName.Hint:=S_DEFAULT_PROVIDER_PATTERN_HINT;
end;

procedure TControlEditorMiceValuePicker.AutoFill;
begin
  raise Exception.Create('Not implemented');
end;

procedure TControlEditorMiceValuePicker.bnAutoClick(Sender: TObject);
begin
 AutoFill;
end;

procedure TControlEditorMiceValuePicker.edGridRefPropertiesButtonClick(Sender: TObject; AButtonIndex: Integer);
var
 s:string;
 ObjectId:Integer;
begin
 if TAppObjectSelectionDialog.ExecuteDialog(-7, ObjectId, s) then
  edGridRef.Text:=ObjectId.ToString;
end;

procedure TControlEditorMiceValuePicker.edListProviderNamePropertiesButtonClick(  Sender: TObject; AButtonIndex: Integer);
var
 s:string;
 ObjectId:Integer;
begin
 s:=edListProviderName.Text;
 if TSysObjectSelectionDialog.ExecuteDialog(-2,ObjectId,s, TargetDBName) then
  edListProviderName.Text:=s;
end;

procedure TControlEditorMiceValuePicker.edProviderPropertiesButtonClick(Sender: TObject; AButtonIndex: Integer);
var
 s:string;
 ObjectId:Integer;
begin
 s:=edProvider.Text;
 if TSysObjectSelectionDialog.ExecuteDialog(-2,ObjectId,s, TargetDBName) then
  edProvider.Text:=s;
end;

procedure TControlEditorMiceValuePicker.EnterInsertingState;
begin
  inherited;
  edParentId.Text:='ParentId';
  edImageIndex.Text:='ImageIndex';
  edDescriptionFieldName.Text:='Description';
  cbDialogType.ItemIndex:=0;
end;

procedure TControlEditorMiceValuePicker.Load;
begin
  inherited;
  edProvider.Text:=ReadProperty('ProviderName','');
  edParentId.Text:=ReadProperty('ParentIdField','');
  edImageIndex.Text:=ReadProperty('ImageIndexField','');
  edEnabledField.Text:=ReadProperty('EnabledField','');
  edEnabledValue.Text:=ReadProperty('EnabledValue','');
  edCaptionField.Text:=ReadProperty('CaptionField','');

  edListProviderName.Text:=ReadProperty('DialogProviderName','');
  edKeyField.Text:=ReadProperty('KeyField','');
  edDescriptionFieldName.Text:=ReadProperty('DescriptionFieldName','');
  cbDialogType.ItemIndex:=ReadProperty('DialogType',0);
  cbEnableClearButton.Checked:=ReadProperty('ClearButtonEnabled',0);;
  edGridRef.Text:=ReadProperty('AppDialogControlsIdTargetGrid',0);
end;

procedure TControlEditorMiceValuePicker.Save;
begin
  MiceAppObject.Properties.ProviderName:=edProvider.Text;

  WriteProperty('CaptionField',edCaptionField.Text,'');
  WriteProperty('ProviderName',edProvider.Text,'');
  WriteProperty('ParentIdField',edParentId.Text,'');
  WriteProperty('ImageIndexField',edImageIndex.Text,'');
  WriteProperty('EnabledField',edEnabledField.Text,'');
  WriteProperty('EnabledValue',edEnabledValue.Text,'');
  WriteProperty('DialogProviderName',edListProviderName.Text,'');
  WriteProperty('KeyField',edKeyField.Text,'');
  WriteProperty('DescriptionFieldName',edDescriptionFieldName.Text,'');
  WriteProperty('DialogType',cbDialogType.ItemIndex,-1);
  WriteProperty('ClearButtonEnabled',cbEnableClearButton.Checked,False);
  WriteProperty('AppDialogControlsIdTargetGrid',StrToIntDef(edGridRef.Text,0),0);

  inherited;
end;

procedure TControlEditorMiceValuePicker.SetGridReference(const Value: Boolean);
begin
 item_TreeGroup.Enabled:=not Value;
 item_DataFields.Enabled:=Value;
 item_GridReference.Enabled:=Value;
end;

procedure TControlEditorMiceValuePicker.SetTreeFields(const Value: Boolean);
begin
  FTreeFields := Value;
  item_TreeGroup.Enabled:=Value;
  edParentId.Enabled:=Value;
  edEnabledField.Enabled:=Value;
  edEnabledValue.Enabled:=Value;
  item_DataFields.Enabled:=True;
  item_GridReference.Enabled:=False;
end;

initialization
 TControlEditorClassList.RegisterClass(TMiceValuePicker.ClassName,  TControlEditorMiceValuePicker);

end.
