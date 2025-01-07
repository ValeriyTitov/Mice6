unit ControlEditor.MiceTreeGridFrame;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, ControlEditor.Common, cxGraphics,
  cxLookAndFeels, cxLookAndFeelPainters, Vcl.Menus, cxControls, cxContainer,
  cxEdit, dxLayoutcxEditAdapters, Data.DB, dxLayoutContainer, cxClasses,
  cxDropDownEdit, cxButtonEdit, cxDBEdit, cxCheckBox, cxImageComboBox,
  cxTextEdit, cxMaskEdit, dxLayoutControl, Vcl.StdCtrls, cxButtons, Vcl.ExtCtrls,
  CustomControl.MiceTreeGridFrame, CustomControl.MiceGrid.ColumnEditor,
  CustomControl.MiceGrid.ColorEditor,
  StaticDialog.AppObjectSelector,
  Manager.WindowManager;

type
  TControlEditorMiceTreeGridFrame = class(TControlEditorBase)
    dxLayoutGroup1: TdxLayoutGroup;
    dxLayoutGroup2: TdxLayoutGroup;
    dxLayoutGroup3: TdxLayoutGroup;
    edKeyField: TcxTextEdit;
    Item_KeyField: TdxLayoutItem;
    edParentIdField: TcxTextEdit;
    Item_ParentIdField: TdxLayoutItem;
    ColorEditor: TMiceGridColorEditorFrame;
    Item_ColorEditor: TdxLayoutItem;
    Item_ColumnEditor: TdxLayoutItem;
    ColumnEditor: TColumnEditorFrame;
    edProviderName: TcxButtonEdit;
    Item_edProviderName: TdxLayoutItem;
    edOrderIdField: TcxTextEdit;
    item_OrderIdField: TdxLayoutItem;
    edImageIndexField: TcxTextEdit;
    Item_ImageIndexField: TdxLayoutItem;
    cbAutoWidth: TcxCheckBox;
    cbSorting: TcxCheckBox;
    dxLayoutItem1: TdxLayoutItem;
    dxLayoutItem2: TdxLayoutItem;
    dxLayoutAutoCreatedGroup3: TdxLayoutAutoCreatedGroup;
    procedure edProviderNamePropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
    procedure edProviderNamePropertiesChange(Sender: TObject);
  private
    FColumns:TDataSet;
    FColors:TDataSet;
  protected
    procedure Load; override;
    procedure Save; override;
    procedure EnterInsertingState; override;
  public
    constructor Create(AOwner: TComponent); override;
  end;


implementation

{$R *.dfm}

{ TControlEditorMiceTreeGridFrame }

constructor TControlEditorMiceTreeGridFrame.Create(AOwner: TComponent);
begin
  inherited;
  ControlClassName:=TMiceTreeGridFrame.ClassName;

  edProviderName.Hint:=S_DEFAULT_PROVIDER_PATTERN_HINT;

  ColumnEditor.DataSource:=DetailDataSets.CreateDataSource('AppColumns','','','TControlEditorMiceEditableGridFrame.Create','','');
  ColumnEditor.DefaultReadOnlyState:=False;
  FColumns:=ColumnEditor.DataSource.DataSet;

  ColorEditor.DataSource:=DetailDataSets.CreateDataSource('AppGridColors','','','TControlEditorMiceEditableGridFrame.Create','','');
  FColors:=ColorEditor.DataSource.DataSet;

end;

procedure TControlEditorMiceTreeGridFrame.edProviderNamePropertiesButtonClick(Sender: TObject; AButtonIndex: Integer);
var
 ID:integer;
 s:string;
begin
 if TSysObjectSelectionDialog.ExecuteDialog(iTypeStoredProc,ID,s, cbDBName.Text) then
  edProviderName.Text:=s;
end;

procedure TControlEditorMiceTreeGridFrame.edProviderNamePropertiesChange(Sender: TObject);
begin
 ColumnEditor.ProviderName:=edProviderName.Text;
 ColumnEditor.DBName:=Self.cbDBName.Text;
end;

procedure TControlEditorMiceTreeGridFrame.EnterInsertingState;
begin
  inherited;
  DataSet.FieldByName('ControlName').AsString:='TreeGrid';
  DataSet.FieldByName('Caption').AsString:='TreeGrid';
  ColumnEditor.DBName:=TargetDBName;
end;

procedure TControlEditorMiceTreeGridFrame.Load;
begin
  inherited;
  edProviderName.Text:=MiceAppObject.Properties.ProviderName;

  edKeyField.Text:=ReadProperty('KeyField','');
  edParentIdField.Text:=ReadProperty('ParentIdField','');
  edOrderIdField.Text:=ReadProperty('OrderIdField','');
  edImageIndexField.Text:=ReadProperty('ImageIndexField','');
  cbSorting.Checked:=ReadProperty('Sorting',False);
  cbAutoWidth.Checked:=ReadProperty('AutoWidth',False);
  ColumnEditor.DBName:=TargetDBName;

end;

procedure TControlEditorMiceTreeGridFrame.Save;
begin
  MiceAppObject.Properties.ProviderName:= edProviderName.Text;
  WriteProperty('KeyField',edKeyField.Text,'');
  WriteProperty('ParentIdField',edParentIdField.Text,'');
  WriteProperty('OrderIdField',edOrderIdField.Text,'');
  WriteProperty('ImageIndexField',edImageIndexField.Text,'');
  WriteProperty('AutoWidth',cbAutoWidth.Checked, False);
  WriteProperty('Sorting',cbSorting.Checked, False);

  inherited;
end;



initialization
 TControlEditorClassList.RegisterClass(TMiceTreeGridFrame.ClassName,  TControlEditorMiceTreeGridFrame);


end.
