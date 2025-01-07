unit ManagerEditor.dfClass;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, ManagerEditor.Common, cxGraphics,
  cxLookAndFeels, cxLookAndFeelPainters, Vcl.Menus, cxControls, Data.DB,
  cxClasses, dxLayoutContainer, dxLayoutControl, Vcl.StdCtrls, cxButtons,
  dxLayoutcxEditAdapters, cxContainer, cxEdit, cxMaskEdit, cxButtonEdit,
  cxDBEdit, cxTextEdit, Vcl.ExtCtrls,Vcl.Buttons, dxLayoutControlAdapters, Vcl.DBCtrls,
  Common.Images,
  Common.ResourceStrings,
  StaticDialog.AppObjectSelector,
  DAC.DataBaseUtils,
  Manager.WindowManager;

type
  TManagerEditorDfClass = class(TCommonManagerDialog)
    Image1: TImage;
    item_Image: TdxLayoutItem;
    dxLayoutGroup1: TdxLayoutGroup;
    dxLayoutGroup2: TdxLayoutGroup;
    eddfClassesId: TcxDBTextEdit;
    item_eddfClassesId: TdxLayoutItem;
    dxLayoutGroup3: TdxLayoutGroup;
    edCaption: TcxDBTextEdit;
    item_edCaption: TdxLayoutItem;
    edAppDialogsId: TcxDBButtonEdit;
    item_edAppDialogsId: TdxLayoutItem;
    edMainDataTable: TcxDBButtonEdit;
    edDataView: TcxDBButtonEdit;
    item_edMainDataTable: TdxLayoutItem;
    item_edDataView: TdxLayoutItem;
    Label1: TLabel;
    dxLayoutItem1: TdxLayoutItem;
    edKeyField: TcxDBTextEdit;
    item_KeyField: TdxLayoutItem;
    chboxEnableEventSystem: TDBCheckBox;
    dxLayoutItem2: TdxLayoutItem;
    edRoutingKey: TcxDBTextEdit;
    item_edRoutingKey: TdxLayoutItem;
    edProgressProviderName: TcxDBButtonEdit;
    item_edProgressProviderName: TdxLayoutItem;
    edHistoryProviderName: TcxDBButtonEdit;
    item_edHistoryProviderName: TdxLayoutItem;
    procedure edAppDialogsIdPropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
    procedure edMainDataTablePropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
    procedure edDataViewPropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
    procedure edMainDataTableExit(Sender: TObject);
    procedure edProgressProviderNamePropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
    procedure edHistoryProviderNamePropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
  protected
    procedure EnterInsertingState; override;
    procedure EnterEditingState; override;

  public
    constructor Create(AOwner:TComponent);override;
    destructor Destroy; override;
  end;

implementation

{$R *.dfm}

{ TManagerEditorDfClass }

constructor TManagerEditorDfClass.Create(AOwner: TComponent);
begin
  inherited;
  TImageContainer.LoadToImage(Image1,IMAGEINDEX_ITYPE_DFCLASS);
  TableName:='dfClasses';
  KeyField:='dfClassesId';
  AppMainTreeDescriptionField:='Caption';
  ImageIndex:= IMAGEINDEX_ITYPE_DFCLASS;
  iType:=iTypeDFClass;
end;

destructor TManagerEditorDfClass.Destroy;
begin

  inherited;
end;


procedure TManagerEditorDfClass.edAppDialogsIdPropertiesButtonClick( Sender: TObject; AButtonIndex: Integer);
var
 ID:integer;
 s:string;
begin
 if TAppObjectSelectionDialog.ExecuteDialog(iTypeDialog,ID,s) then
  DataSet.FieldByName('AppDialogsId').AsInteger:=ID;
end;

procedure TManagerEditorDfClass.edDataViewPropertiesButtonClick(Sender: TObject;  AButtonIndex: Integer);
var
 ID:integer;
 s:string;
begin
 if TSysObjectSelectionDialog.ExecuteDialog(iTypeViewOnly,ID,s,DBName) then
  DataSet.FieldByName('DataView').AsString:=s;
end;


procedure TManagerEditorDfClass.edHistoryProviderNamePropertiesButtonClick(Sender: TObject; AButtonIndex: Integer);
var
 ID:integer;
 s:string;
begin
 if TSysObjectSelectionDialog.ExecuteDialog(iTypeStoredProc,ID,s,DBName) then
  DataSet.FieldByName('HistoryProviderName').AsString:=s;
end;

procedure TManagerEditorDfClass.edMainDataTableExit(Sender: TObject);
begin
 if (edKeyField.Text='') and (edMainDataTable.Text<>'') then
    DataSet.FieldByName('KeyField').AsString:=DataSet.FieldByName('MainTable').AsString+'Id';
end;

procedure TManagerEditorDfClass.edMainDataTablePropertiesButtonClick(Sender: TObject; AButtonIndex: Integer);
var
 ID:integer;
 s:string;
begin
 if TSysObjectSelectionDialog.ExecuteDialog(iTypeTableOrViews,ID,s,DBName) then
  DataSet.FieldByName('MainTable').AsString:=s;
end;


procedure TManagerEditorDfClass.edProgressProviderNamePropertiesButtonClick(Sender: TObject; AButtonIndex: Integer);
var
 ID:integer;
 s:string;
begin
 if TSysObjectSelectionDialog.ExecuteDialog(iTypeStoredProc,ID,s,DBName) then
  DataSet.FieldByName('LogProviderName').AsString:=s;
end;


procedure TManagerEditorDfClass.EnterEditingState;
begin
  inherited;
end;

procedure TManagerEditorDfClass.EnterInsertingState;
begin
  inherited;
  DataSet.FieldByName('dfClassesId').AsInteger:=TDataBaseUtils.NewAppObjectId(sq_dfClasses);
  DataSet.FieldByName('Caption').AsString:='New dfClass '+DataSet.FieldByName('dfClassesId').AsString;
  DataSet.FieldByName('FullAccess').AsBoolean:=True;
  DataSet.FieldByName('CanAddFromDesktop').AsBoolean:=True;
  DataSet.FieldByName('EnableDfEvents').AsBoolean:=False;
  DataSet.FieldByName('RoutingKey').AsString:='['+DataSet.FieldByName('dfClassesId').AsString+']';
  eddfClassesId.Enabled:=True;
end;

initialization
   TWindowManager.RegisterEditor(iTypeDFClass,nil,TManagerEditorDfClass, False);

end.
