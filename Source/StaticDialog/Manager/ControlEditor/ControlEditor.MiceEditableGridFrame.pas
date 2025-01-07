unit ControlEditor.MiceEditableGridFrame;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, ControlEditor.Common, cxGraphics,
  cxLookAndFeels, cxLookAndFeelPainters, Vcl.Menus, cxControls, cxContainer,
  cxEdit, dxLayoutcxEditAdapters, Data.DB, dxLayoutContainer, cxClasses,
  cxDropDownEdit, cxButtonEdit, cxDBEdit, cxCheckBox, cxImageComboBox,
  cxTextEdit, cxMaskEdit, dxLayoutControl, Vcl.StdCtrls, cxButtons, Vcl.ExtCtrls,
  CustomControl.MiceEditableGridFrame,
  CustomControl.MiceGrid.ColumnEditor,
  DAC.XDataSet,
  CustomControl.MiceGrid.ColorEditor;

type
  TControlEditorMiceEditableGridFrame = class(TControlEditorBase)
    grpMain: TdxLayoutGroup;
    grpColumns: TdxLayoutGroup;
    ColumnEditor: TColumnEditorFrame;
    item_ColumnEditor: TdxLayoutItem;
    cbDataSource: TcxComboBox;
    item_cbDataSource: TdxLayoutItem;
    cbGroupBy: TcxCheckBox;
    dxLayoutItem1: TdxLayoutItem;
    cbAutoWidth: TcxCheckBox;
    dxLayoutItem2: TdxLayoutItem;
    cbSorting: TcxCheckBox;
    dxLayoutItem3: TdxLayoutItem;
    dxLayoutAutoCreatedGroup3: TdxLayoutAutoCreatedGroup;
    Colors: TdxLayoutGroup;
    dxLayoutItem4: TdxLayoutItem;
    ColorEditor: TMiceGridColorEditorFrame;
    procedure cbDataSourcePropertiesChange(Sender: TObject);
  protected
    FColumns:TDataSet;
    procedure Load; override;
    procedure Save; override;
    procedure EnterInsertingState; override;
  public
    constructor Create(AOwner: TComponent); override;
  end;


implementation

{$R *.dfm}

{ TControlEditorMiceEditableGridFrame }

procedure TControlEditorMiceEditableGridFrame.cbDataSourcePropertiesChange(Sender: TObject);
var
 ADataSet:TxDataSet;
 AName:string;
begin
 if cbDataSource.Text<>'' then
  begin
   AName:=cbDataSource.Text;
   ADataSet:=(AppDialogDetailTables[AName].DataSet as TxDataSet);

   if ADataSet.ProviderNamePattern.Trim.IsEmpty then
    ColumnEditor.ProviderName:=ADataSet.TableName
     else
    ColumnEditor.ProviderName:=ADataSet.ProviderNamePattern;

   if ADataSet.DBName.Trim.IsEmpty then
   ColumnEditor.DBName:=ParentDBName
     else
   ColumnEditor.DBName:=ADataSet.DBName;


   if DataSet.FieldByName('ControlName').AsString='grid' then
    DataSet.FieldByName('ControlName').AsString:='grid'+AName;
   if DataSet.FieldByName('Caption').AsString.IsEmpty then
    DataSet.FieldByName('Caption').AsString:=AName;
  end;
end;

constructor TControlEditorMiceEditableGridFrame.Create(AOwner: TComponent);
begin
  inherited;
  ControlClassName:=TMiceEditableGridFrame.ClassName;
  ColumnEditor.DataSource:=DetailDataSets.CreateDataSource('AppColumns','','','TControlEditorMiceEditableGridFrame.Create','','');
  FColumns:=ColumnEditor.DataSource.DataSet;
  ColumnEditor.DefaultReadOnlyState:=False;
  ColorEditor.DataSource:=DetailDataSets.CreateDataSource('AppGridColors','','','TControlEditorMiceEditableGridFrame.Create','','');
end;

procedure TControlEditorMiceEditableGridFrame.EnterInsertingState;
begin
  inherited;
  DataSet.FieldByName('ControlName').AsString:='egrid';
  DataSet.FieldByName('Caption').AsString:='egrid';
  ColumnEditor.DBName:=TargetDBName;
end;

procedure TControlEditorMiceEditableGridFrame.Load;
begin
  inherited;
  AppDialogDetailTables.ToList(cbDataSource.Properties.Items);
  cbDataSource.Text:=ReadProperty('DataSourceName','');
  cbGroupBy.Checked:=ReadProperty('GroupByBox',False);
  cbAutoWidth.Checked:=ReadProperty('AutoWidth',False);
  cbSorting.Checked:=ReadProperty('Sorting',False);
  ColumnEditor.DBName:=TargetDBName;
end;

procedure TControlEditorMiceEditableGridFrame.Save;
begin
  WriteProperty('DataSourceName',cbDataSource.Text, '');
  WriteProperty('GroupByBox',cbGroupBy.Checked, False);
  WriteProperty('AutoWidth',cbAutoWidth.Checked, False);
  WriteProperty('Sorting',cbSorting.Checked, False);
  inherited;
end;


initialization
 TControlEditorClassList.RegisterClass(TMiceEditableGridFrame.ClassName,  TControlEditorMiceEditableGridFrame);

end.
