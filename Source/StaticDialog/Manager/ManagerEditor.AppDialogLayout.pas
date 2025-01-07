unit ManagerEditor.AppDialogLayout;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, ManagerEditor.Common, cxGraphics,
  cxLookAndFeels, cxLookAndFeelPainters, Vcl.Menus, cxControls, Data.DB,
  cxClasses, dxLayoutContainer, dxLayoutControl, Vcl.StdCtrls, cxButtons,
  System.Generics.Collections, System.Generics.Defaults,
  Vcl.ExtCtrls,
  Dialog.Basic,
  Common.Images,
  Common.Resourcestrings,
  Manager.WindowManager,
  ManagerEditor.AppDialogLayout.JsonView,
  DAC.DatabaseUtils,
  Dialog.Layout.Builder,
  cxContainer, cxEdit, dxLayoutcxEditAdapters, cxTextEdit,
  Dialog.Layout.CustomizationForm,
  StaticDialog.MiceInputBox,
  CustomControl.MiceLayout,
  cxDBEdit, Vcl.Buttons,
  ManagerEditor.AppDialogLayout.FlagEditor;

type
  TManagerEditorAppDialogLayout = class(TCommonManagerDialog)
    Sizeable1: TMenuItem;
    Readonly1: TMenuItem;
    Active1: TMenuItem;
    ShowasJson1: TMenuItem;
    Flags1: TMenuItem;
    procedure FormShow(Sender: TObject);
    procedure bnOKClick(Sender: TObject);
    procedure ShowasJson1Click(Sender: TObject);
    procedure Flags1Click(Sender: TObject);
  private
    FAppDialogsId: Integer;
    FFlagsDataSource:TDataSource;
    FLayoutBuilder:TDialogLayoutBuilder;
    procedure CheckAppDialogsId;
    procedure PopulateItems(Items:TStrings);
    procedure PopulateFields(Items:TStrings);
  protected
    function DialogSaveName:string; override;
    procedure EnterInsertingState; override;
    procedure EnterEditingState; override;
    procedure SynchronizeData(DataSet:TDataSet);
    procedure CheckBeforeSave; override;
    procedure ShowAsJsonText;
    procedure SetFirstTab;
  public
    property AppDialogsId:Integer read FAppDialogsId write FAppDialogsId;
    procedure SaveChanges;override;
    procedure LoadState(LoadPosition, LoadSize:Boolean);override;
    procedure Initialize; override;
    constructor Create(AOwner:TComponent); override;
    destructor Destroy; override;
  end;


implementation

{$R *.dfm}

{ TManagerEditorAppDialogLayout }

procedure TManagerEditorAppDialogLayout.bnOKClick(Sender: TObject);
var
 s:string;
begin
 if (ID<0) then
  begin
   s:=DataSet.FieldByName('Description').AsString;
   if TMiceInputBox.Execute(56,s) then
    begin
      DataSet.FieldByName('Description').AsString:=s;
      inherited;
    end;
  end
   else
  inherited;
end;

procedure TManagerEditorAppDialogLayout.CheckAppDialogsId;
resourcestring
 S_CANNNOT_SAVE_LAYOUT_WITHOUT_DIALOG = 'Cannot save Layout without Dialog attached, AppDialogsId=0';
begin
 if AppDialogsId<=0 then
  raise Exception.Create(S_CANNNOT_SAVE_LAYOUT_WITHOUT_DIALOG);
end;

procedure TManagerEditorAppDialogLayout.CheckBeforeSave;
begin
 CheckAppDialogsId;
 SetFirstTab;
end;

constructor TManagerEditorAppDialogLayout.Create(AOwner: TComponent);
begin
  inherited;
  TableName:='AppDialogsLayout';
  KeyField:='AppDialogsLayoutId';
  AppMainTreeDescriptionField:='Description';
  ImageIndex:= IMAGEINDEX_ITYPE_LAYOUT;
  iType:=iTypeAppDialogLayout;
  DialogLayout.CustomizeFormClass:=TMiceLayoutEditForm;
//  DialogLayout.Customization:=True;
  DataSet.BeforePost:=SynchronizeData;
  FLayoutBuilder:=TDialogLayoutBuilder.Create(DialogLayout);
  FLayoutBuilder.LayoutType:=TLayoutType.ltDesigner;

  FFlagsDataSource:=AddDetailTable('AppDialogsLayoutFlags','','',ClassName+'.FlagGrid','','');
end;



destructor TManagerEditorAppDialogLayout.Destroy;
begin
  DialogLayout.Customization:=False;
  FLayoutBuilder.Free;
  inherited;
end;

function TManagerEditorAppDialogLayout.DialogSaveName: string;
begin
 Result:='LayoutEditors\AppLayoutsId='+ID.ToString;
end;

procedure TManagerEditorAppDialogLayout.EnterEditingState;
begin
  inherited;
  Sizeable1.Checked:=DataSet.FieldByName('Sizeable').AsBoolean;
  Readonly1.Checked:=DataSet.FieldByName('Readonly').AsBoolean;
  Active1.Checked:=DataSet.FieldByName('Active').AsBoolean;


  if not DataSet.FieldByName('Width').IsNull then
   Width:=DataSet.FieldByName('Width').AsInteger;

  if not DataSet.FieldByName('Height').IsNull then
   Height:=DataSet.FieldByName('Height').AsInteger;

  if not DataSet.FieldByName('Layout').AsString.IsEmpty then
  try
   LoadFromJson(DataSet.FieldByName('Layout').AsString);
  except on E:Exception do
   MessageBox(Handle, PChar(e.Message), PChar(S_COMMON_ERROR), MB_OK+MB_ICONERROR);
  end;

  AppDialogsId:=DataSet.FieldByName('AppDialogsId').AsInteger;
end;

procedure TManagerEditorAppDialogLayout.EnterInsertingState;
resourcestring
 S_DEFAULT_LAYOUT='Default layout';
 S_NEW_GROUP='Main group';

var
 Group:TMiceLayoutGroup;
begin
  inherited;
  DataSet.FieldByName('AppDialogsLayoutId').AsInteger:=TDataBaseUtils.NewAppObjectId(sq_AppDialogsLayout);
  DataSet.FieldByName('Description').AsString:=S_DEFAULT_LAYOUT;
  AppDialogsId:=OwnerObjectId;
  DataSet.FieldByName('AppDialogsId').AsInteger:=AppDialogsId;
  DataSet.FieldByName('Active').AsBoolean:=True;
  DataSet.FieldByName('StreamInput').AsBoolean:=False;
  DataSet.FieldByName('FullAccess').AsBoolean:=False;
  Active1.Checked:=True;
  DialogLayoutGroup_Root.LayoutDirection:=TdxLayoutDirection.ldVertical;

  Group:=DialogLayout.CreateItem(TMiceLayoutGroup,DialogLayoutGroup_Root) as TMiceLayoutGroup;
  Group.Caption:=S_NEW_GROUP;
  Group.ShowCaption:=False;
  Group.ShowBorder:=False;
  Group.AlignHorz:=TdxLayoutAlignHorz.ahClient;
  Group.AlignVert:=TdxLayoutAlignVert.avClient;
end;

procedure TManagerEditorAppDialogLayout.Flags1Click(Sender: TObject);
var
 Dlg:TFlagEditor;
begin
 Dlg:=TFlagEditor.Create(nil);
 try
  Dlg.Width:=800;
  Dlg.Height:=600;
  Dlg.Caption:=Caption;
  Self.PopulateItems(Dlg.FlagsFrame1.ControlNames);
  Self.PopulateFields(Dlg.FlagsFrame1.FieldNames);
  Dlg.FlagsFrame1.MainView.DataController.DataSource:=FFlagsDataSource;
  FFlagsDataSource.DataSet.Open;
  Dlg.Execute;
 finally
  Dlg.Free;
 end;
end;

procedure TManagerEditorAppDialogLayout.FormShow(Sender: TObject);
begin
 //Left:=(Screen.Width div 2) - Width;
// Top:=(Screen.Height div 2) - (Height div 2);
end;

procedure TManagerEditorAppDialogLayout.Initialize;
resourcestring
 S_LAYOUT_READING_ERROR_DETECTED = 'Layout read error detected. Some items are missing.';
begin
  inherited;
  FLayoutBuilder.AppDialogsId:=Self.AppDialogsId;
  FLayoutBuilder.AppDialogsLayoutId:=Self.ID;
  FLayoutBuilder.Build;
  if FLayoutBuilder.HasMissingItems then
   MessageBox(Handle,PChar(S_LAYOUT_READING_ERROR_DETECTED),PChar(S_COMMON_WARNING),MB_OK+MB_ICONASTERISK);
end;


procedure TManagerEditorAppDialogLayout.LoadState(LoadPosition, LoadSize: Boolean);
begin
  inherited LoadState(True, False);
  DialogLayout.Customization:=False;
  DialogLayout.Customization:=True;
end;

procedure TManagerEditorAppDialogLayout.PopulateFields(Items: TStrings);
begin
 Items.Assign(FLayoutBuilder.DataFields);
end;

procedure TManagerEditorAppDialogLayout.PopulateItems(Items: TStrings);
var
 Control:TControl;
 x:Integer;
begin
 Items.Clear;
 for Control in FLayoutBuilder.ControlList do
  Items.Add(Control.Name);
 for x:=0 to Self.DialogLayout.AbsoluteItemCount-1 do
  begin
   if (DialogLayout.AbsoluteItems[x] is TdxCustomLayoutGroup) then
   Items.Add(DialogLayout.AbsoluteItems[x].Name);
  end;
end;

procedure TManagerEditorAppDialogLayout.SaveChanges;
begin
 FLayoutBuilder.FreeUnusedItems;
 inherited;
 DialogLayout.Customization:=False;
end;

procedure TManagerEditorAppDialogLayout.SetFirstTab;
var
 Group:TdxLayoutGroup;
 x:Integer;
begin
 for x:=0 to DialogLayout.Items.Count-1 do
   if (DialogLayout.Items[x] is TdxLayoutGroup) then
    begin
     Group:=DialogLayout.Items[x] as TdxLayoutGroup;
     if Assigned(Group) then
      DialogLayoutGroup_Root.ItemIndex:=Group.Index;
     Exit;
    end;
end;

procedure TManagerEditorAppDialogLayout.ShowasJson1Click(Sender: TObject);
begin
  ShowAsJsonText;
end;

procedure TManagerEditorAppDialogLayout.ShowAsJsonText;
begin
 DataSet.Edit;
 SaveToJson(DataSet.FieldByName('Layout'));
 if TLayoutJsonViewDlg.ExecuteDlg(DataSet) then
  LoadFromJson(DataSet.FieldByName('Layout').AsString);
end;

procedure TManagerEditorAppDialogLayout.SynchronizeData(DataSet: TDataSet);
begin
 SaveToJson(DataSet.FieldByName('Layout'));
 DataSet.FieldByName('AppDialogsId').AsInteger:=AppDialogsId;
 DataSet.FieldByName('Width').AsInteger:=Width;
 DataSet.FieldByName('Height').AsInteger:=Height;
 DataSet.FieldByName('Sizeable').AsBoolean:=Sizeable1.Checked;
 DataSet.FieldByName('Readonly').AsBoolean:=Readonly1.Checked;
 DataSet.FieldByName('Active').AsBoolean:=Active1.Checked;
end;


initialization
  TWindowManager.RegisterEditor(iTypeAppDialogLayout,nil,TManagerEditorAppDialogLayout,False);

finalization


end.

