unit ControlEditor.MiceGridFrame;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, ControlEditor.Common, cxGraphics,
  cxLookAndFeels, cxLookAndFeelPainters, Vcl.Menus, cxControls, cxContainer,
  cxEdit, dxLayoutcxEditAdapters, Data.DB, dxLayoutContainer, cxClasses,
  cxDropDownEdit, cxButtonEdit, cxDBEdit, cxCheckBox, cxImageComboBox,
  cxTextEdit, cxMaskEdit, dxLayoutControl, Vcl.StdCtrls, cxButtons, Vcl.ExtCtrls,
  Common.Images,
  Common.StringUtils,
  StaticDialog.AppObjectSelector,
  CustomControl.MiceGrid.ColumnEditor,
  CustomControl.MiceGridFrame,
  CustomControl.MiceGrid.ColorEditor,
  Manager.WindowManager;


type
  TControlEditorMiceGridFrame = class(TControlEditorBase)
    dxLayoutGroup1: TdxLayoutGroup;
    dxLayoutGroup2: TdxLayoutGroup;
    dxLayoutGroup3: TdxLayoutGroup;
    dxLayoutGroup4: TdxLayoutGroup;
    ColorEditor: TMiceGridColorEditorFrame;
    item_ColorFrame: TdxLayoutItem;
    Item_Columns: TdxLayoutItem;
    ColumnEditor: TColumnEditorFrame;
    cbSorting: TcxCheckBox;
    cbGroupBy: TcxCheckBox;
    cbAutoWidth: TcxCheckBox;
    dxLayoutItem1: TdxLayoutItem;
    dxLayoutItem2: TdxLayoutItem;
    dxLayoutItem3: TdxLayoutItem;
    edProviderName: TcxButtonEdit;
    dxLayoutItem4: TdxLayoutItem;
    dxLayoutAutoCreatedGroup3: TdxLayoutAutoCreatedGroup;
    cbShowEditButtons: TcxCheckBox;
    dxLayoutItem5: TdxLayoutItem;
    edAppDialogID: TcxButtonEdit;
    item_edAppDialogID: TdxLayoutItem;
    edAppDialogLayoutsIdFieldName: TcxTextEdit;
    dxLayoutItem6: TdxLayoutItem;
    edKeyField: TcxTextEdit;
    item_KeyField: TdxLayoutItem;
    procedure edProviderNamePropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
    procedure edProviderNamePropertiesChange(Sender: TObject);
    procedure edAppDialogIDPropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);

  private
    FColumns:TDataSet;
    FColors:TDataSet;
    FAppDialogsId:Variant;
    procedure ClearAppDialog;
    procedure SelectAppDialog;
  protected
    procedure Load; override;
    procedure Save; override;
    procedure EnterInsertingState; override;
  public
    constructor Create(AOwner: TComponent); override;
  end;


implementation

{$R *.dfm}

{ TControlEditorMiceGridFrame }

constructor TControlEditorMiceGridFrame.Create(AOwner: TComponent);
begin
  inherited;
  ControlClassName:=TMiceGridFrame.ClassName;
  edProviderName.Hint:=S_DEFAULT_PROVIDER_PATTERN_HINT;

  ColumnEditor.DataSource:=DetailDataSets.CreateDataSource('AppColumns','','','TControlEditorMiceEditableGridFrame.Create','','');
  ColumnEditor.DefaultReadOnlyState:=False;
  FColumns:=ColumnEditor.DataSource.DataSet;

  ColorEditor.DataSource:=DetailDataSets.CreateDataSource('AppGridColors','','','TControlEditorMiceEditableGridFrame.Create','','');
  FColors:=ColorEditor.DataSource.DataSet;
end;


procedure TControlEditorMiceGridFrame.SelectAppDialog;
var
 ID:integer;
 s:string;
begin
 if TAppObjectSelectionDialog.ExecuteDialog(iTypeDialog,ID,s) then
  begin
   edAppDialogID.Text:=s;
   FAppDialogsId:=ID;
  end;
end;


procedure TControlEditorMiceGridFrame.ClearAppDialog;
begin
   edAppDialogID.Text:='';
   FAppDialogsId:=NULL;
end;


procedure TControlEditorMiceGridFrame.edAppDialogIDPropertiesButtonClick(Sender: TObject; AButtonIndex: Integer);
begin
 case AButtonIndex of
  0:SelectAppDialog;
  1:ClearAppDialog
 end;
end;


procedure TControlEditorMiceGridFrame.edProviderNamePropertiesButtonClick(Sender: TObject; AButtonIndex: Integer);
var
 ID:integer;
 s:string;
begin
 if TSysObjectSelectionDialog.ExecuteDialog(iTypeStoredProc,ID,s, cbDBName.Text) then
  edProviderName.Text:=s;
end;

procedure TControlEditorMiceGridFrame.edProviderNamePropertiesChange(Sender: TObject);
var
 AProvider:string;
begin
 AProvider:=TStringUtils.LeftFromText(edProviderName.Text,'@',edProviderName.Text);
 ColumnEditor.ProviderName:=AProvider.Trim;
 ColumnEditor.DBName:=Self.cbDBName.Text;
end;

procedure TControlEditorMiceGridFrame.EnterInsertingState;
begin
  inherited;
  DataSet.FieldByName('ControlName').AsString:='grid';
  DataSet.FieldByName('Caption').AsString:='grid';
  ColumnEditor.DBName:=TargetDBName;
end;

procedure TControlEditorMiceGridFrame.Load;
begin
  inherited;
  edProviderName.Text:=MiceAppObject.Properties.ProviderName;
//  edProviderName.Text:=ReadProperty('ProviderName','');
  edAppDialogID.Text:=ReadProperty('DialogName','');
  FAppDialogsId:=ReadProperty('AppDialogsId',NULL);
  cbShowEditButtons.Checked:=ReadProperty('ShowButtons',False);
  edAppDialogLayoutsIdFieldName.Text:=ReadProperty('AppDialogLayoutsIdFieldName','');


  edKeyField.Text:=ReadProperty('KeyField','');
  cbGroupBy.Checked:=ReadProperty('GroupByBox',False);
  cbAutoWidth.Checked:=ReadProperty('AutoWidth',False);
  cbSorting.Checked:=ReadProperty('Sorting',False);
  ColumnEditor.DBName:=TargetDBName;
end;

procedure TControlEditorMiceGridFrame.Save;
begin
  MiceAppObject.Properties.ProviderName:=edProviderName.Text;
//  WriteProperty('ProviderName',edProviderName.Text, '');

  WriteProperty('KeyField',edKeyField.Text, '');
  WriteProperty('GroupByBox',cbGroupBy.Checked, False);
  WriteProperty('AutoWidth',cbAutoWidth.Checked, False);
  WriteProperty('Sorting',cbSorting.Checked, False);


  WriteProperty('AppDialogsId',FAppDialogsId, NULL);
  WriteProperty('DialogName',edAppDialogID.Text, '');
  WriteProperty('AppDialogLayoutsIdFieldName',edAppDialogLayoutsIdFieldName.Text, '');
  WriteProperty('ShowButtons',cbShowEditButtons.Checked, False);
  inherited;
end;

initialization
 TControlEditorClassList.RegisterClass(TMiceGridFrame.ClassName,  TControlEditorMiceGridFrame);


end.
