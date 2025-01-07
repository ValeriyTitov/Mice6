unit ControlEditor.MiceTextEdit;


interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, ControlEditor.Common, cxGraphics,
  cxLookAndFeels, cxLookAndFeelPainters, Vcl.Menus, cxControls, cxContainer,
  cxEdit, dxLayoutcxEditAdapters, Data.DB, dxLayoutContainer, cxClasses,
  cxCheckBox, cxDBEdit, cxImageComboBox, cxDropDownEdit, cxTextEdit, cxMaskEdit,
  cxButtonEdit, dxLayoutControl, Vcl.StdCtrls, cxButtons, Vcl.ExtCtrls,
  cxGroupBox, cxRadioGroup, cxMemo,dxLayoutControlAdapters, cxLookupEdit,
  cxDBLookupEdit, cxDBLookupComboBox, dxmdaset,
  Common.StringUtils,
  StaticDialog.AppObjectSelector,
  ControlEditor.MiceTextEdit.TryForm,
  CustomControl.MiceTextEdit;


type
  TControlEditorMiceTextEdit = class(TControlEditorBase)
    edProviderName: TcxButtonEdit;
    edTextEditProviderName_Item: TdxLayoutItem;
    rgAutoCompleteType: TcxRadioGroup;
    rgAutoCompleteType_Item: TdxLayoutItem;
    edEditMask: TcxTextEdit;
    edEditMask_Item: TdxLayoutItem;
    memoAutoCompleteItems: TcxMemo;
    memoAutoCompleteItems_Item: TdxLayoutItem;
    cbTrimOnPost: TcxCheckBox;
    cbTrimOnPost_Item: TdxLayoutItem;
    cbRemoveDualSpaces: TcxCheckBox;
    cbRemoveDualSpaces_Item: TdxLayoutItem;
    cbSpellCheck: TcxCheckBox;
    cbSpellCheck_Item: TdxLayoutItem;
    cbAcceptTabPaste: TcxCheckBox;
    dxLayoutItem1: TdxLayoutItem;
    dxLayoutAutoCreatedGroup5: TdxLayoutAutoCreatedGroup;
    dxLayoutAutoCreatedGroup4: TdxLayoutAutoCreatedGroup;
    gpAutoComplete: TdxLayoutGroup;
    gpEditMask: TdxLayoutGroup;
    cbMaskErrorShowIcon: TcxCheckBox;
    dxLayoutItem3: TdxLayoutItem;
    dxLayoutAutoCreatedGroup3: TdxLayoutAutoCreatedGroup;
    cbMaskErrorAllowLooseFocus: TCheckBox;
    dxLayoutItem4: TdxLayoutItem;
    bnTry: TcxButton;
    dxLayoutItem2: TdxLayoutItem;
    dsPatterns: TDataSource;
    TextEditPatterns: TdxMemData;
    TextEditPatternsPattern: TStringField;
    TextEditPatternsCaption: TStringField;
    cbPatterns: TcxLookupComboBox;
    dxLayoutItem5: TdxLayoutItem;
    dxLayoutAutoCreatedGroup6: TdxLayoutAutoCreatedGroup;
    MemoPatterns: TMemo;
    ddMaskKind: TcxImageComboBox;
    dxLayoutItem6: TdxLayoutItem;
    TextEditPatternsMaskKind: TIntegerField;
    procedure rgAutoCompleteTypePropertiesEditValueChanged(Sender: TObject);
    procedure edTextEditProviderNamePropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
    procedure bnTryClick(Sender: TObject);
    procedure cbPatternsPropertiesChange(Sender: TObject);
    procedure ddMaskKindPropertiesChange(Sender: TObject);
  private
    procedure LoadMaskPatterns;
  protected
    procedure EnterInsertingState; override;
    procedure Load; override;
    procedure Save; override;
  public
    constructor Create(AOwner:TComponent); override;
  end;


implementation

{$R *.dfm}

{ TControlEditorBase1 }


procedure TControlEditorMiceTextEdit.bnTryClick(Sender: TObject);
begin
 Save;
 TMiceTextEditTryForm.ExecuteDlg(MiceAppObject.Params);
end;

procedure TControlEditorMiceTextEdit.cbPatternsPropertiesChange(Sender: TObject);
var
 AText:string;
begin
  if not VarIsNull(cbPatterns.EditValue) then
   begin
    AText:=VarToStr(cbPatterns.EditValue);
    if TextEditPatterns.Locate('Caption',cbPatterns.Text,[]) then
     ddMaskKind.EditValue:=TextEditPatterns.FieldByName('MaskKind').Value;
    edEditMask.Text:=AText;
   end;
end;

constructor TControlEditorMiceTextEdit.Create(AOwner: TComponent);
begin
  inherited;
  ControlClassName:=TMiceTextEdit.ClassName;
  edProviderName.Hint:=S_DEFAULT_PROVIDER_PATTERN_HINT;
  LoadMaskPatterns;
end;

procedure TControlEditorMiceTextEdit.ddMaskKindPropertiesChange(Sender: TObject);
begin
 Self.edEditMask.Text:='';
end;

procedure TControlEditorMiceTextEdit.edTextEditProviderNamePropertiesButtonClick(Sender: TObject; AButtonIndex: Integer);
var
 x:Integer;
 s:string;
begin
  if TSysObjectSelectionDialog.ExecuteDialog(-2, x,s, TargetDBName) then
    edProviderName.Text:=s;
end;

procedure TControlEditorMiceTextEdit.EnterInsertingState;
begin
  inherited;
  cbTrimOnPost.Checked:=True;
  cbRemoveDualSpaces.Checked:=True;
  rgAutoCompleteType.ItemIndex:=0; //Autocomplete: none
end;

procedure TControlEditorMiceTextEdit.Load;
begin
 inherited;
 ddMaskKind.EditValue:=ReadProperty('MaskKind',2);
 cbRemoveDualSpaces.Checked:=ReadProperty('RemoveDualSpaces',True);
 cbTrimOnPost.Checked:=ReadProperty('StringTrim',True);
 cbSpellCheck.Checked:=ReadProperty('SpellCheck',False);
 edEditMask.Text:=ReadProperty('EditMask','');
 edProviderName.Text:=ReadProperty('ProviderName','');
 rgAutoCompleteType.ItemIndex:=ReadProperty('AutoCompleteType',0);
 memoAutoCompleteItems.Lines.Text:=ReadProperty('AutoCompleteItems','');
 cbAcceptTabPaste.Checked:=ReadProperty('AcceptTabPaste',False);
 cbMaskErrorShowIcon.Checked:=ReadProperty('MaskErrorShowIcon',True);
 cbMaskErrorAllowLooseFocus.Checked:=ReadProperty('MaskErrorAllowLooseFocus',True);
end;

procedure TControlEditorMiceTextEdit.LoadMaskPatterns;
var
 x:Integer;
 ACaption:string;
 APattern:string;
 ARegType:Integer;
begin
 TextEditPatterns.Open;
 for x:=0 to MemoPatterns.Lines.Count-1 do
  if not MemoPatterns.Lines[0].Trim.IsEmpty then
    begin
     ARegType:=StrToIntDef(TStringUtils.LeftFromText(MemoPatterns.Lines.Names[x],'@','0'),0);
     ACaption:=TStringUtils.RightFromText(MemoPatterns.Lines.Names[x],'@','<NONE>');
     APattern:=MemoPatterns.Lines.ValueFromIndex[x];

     TextEditPatterns.AppendRecord([NULL, APattern, ACaption, ARegType]);
   end;
end;

procedure TControlEditorMiceTextEdit.rgAutoCompleteTypePropertiesEditValueChanged(Sender: TObject);
begin
 memoAutoCompleteItems.Enabled:=Self.rgAutoCompleteType.ItemIndex=1;
end;

procedure TControlEditorMiceTextEdit.Save;
begin
 MiceAppObject.Properties.ProviderName:=Trim(edProviderName.Text);
 WriteProperty('RemoveDualSpaces',cbRemoveDualSpaces.Checked, True);
 WriteProperty('StringTrim',cbTrimOnPost.Checked, True);
 WriteProperty('SpellCheck',cbSpellCheck.Checked, False);
 WriteProperty('EditMask',Trim(edEditMask.Text),'');
 WriteProperty('ProviderName',Trim(edProviderName.Text),'');
 WriteProperty('AutoCompleteType',rgAutoCompleteType.ItemIndex,0);
 WriteProperty('AutoCompleteItems',Trim(memoAutoCompleteItems.Lines.Text),'');
 WriteProperty('AcceptTabPaste',cbAcceptTabPaste.Checked,False);
 WriteProperty('MaskKind',ddMaskKind.EditValue,2);
 WriteProperty('MaskErrorShowIcon',cbMaskErrorShowIcon.Checked,True);
 WriteProperty('MaskErrorAllowLooseFocus',cbMaskErrorAllowLooseFocus.Checked,True);
 inherited;
end;


initialization
  TControlEditorClassList.RegisterClass(TMiceTextEdit.ClassName, TControlEditorMiceTextEdit);

end.
