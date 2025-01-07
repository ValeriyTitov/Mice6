unit ManagerEditor.dfTypes;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, ManagerEditor.Common, cxGraphics,
  cxLookAndFeels, cxLookAndFeelPainters, Vcl.Menus, cxControls, Data.DB,
  cxClasses, dxLayoutContainer, dxLayoutControl, Vcl.StdCtrls, cxButtons,
  Vcl.ExtCtrls, dxLayoutcxEditAdapters, cxContainer, cxEdit, cxDBEdit,
  cxTextEdit, cxMaskEdit, cxDropDownEdit, cxImageComboBox,

  Common.Images,
  Common.ResourceStrings,
  StaticDialog.AppObjectSelector,
  DAC.XDataSet,
  DAC.DataBaseUtils,
  CustomControl.MiceDropDown.Builder,
  Manager.WindowManager, Vcl.Buttons;


type
  TManagerEditorDfTypes = class(TCommonManagerDialog)
    Image1: TImage;
    dxLayoutItem1: TdxLayoutItem;
    dxLayoutGroup1: TdxLayoutGroup;
    dxLayoutGroup2: TdxLayoutGroup;
    Label1: TLabel;
    dxLayoutItem2: TdxLayoutItem;
    ddDfClasses: TcxDBImageComboBox;
    item_dfClassesId: TdxLayoutItem;
    eddfTypesId: TcxDBTextEdit;
    item_eddfTypesId: TdxLayoutItem;
    dxLayoutAutoCreatedGroup1: TdxLayoutAutoCreatedGroup;
    edCaption: TcxDBTextEdit;
    item_edCaption: TdxLayoutItem;
    edShortName: TcxDBTextEdit;
    item_edShortName: TdxLayoutItem;
  private
    FdfClassesId: Integer;
  protected
    procedure DoAfterNewTreeItem; override;
    procedure EnterInsertingState; override;
    procedure EnterEditingState; override;
    procedure PopulateDropDown;
  public
    constructor Create(AOwner:TComponent);override;
    destructor Destroy; override;
    property dfClassesId:Integer read FdfClassesId write FdfClassesId;
  end;

implementation

{$R *.dfm}

{ TManagerEditorDfTypes }

constructor TManagerEditorDfTypes.Create(AOwner: TComponent);
begin
  inherited;
  TImageContainer.LoadToImage(Image1,IMAGEINDEX_ITYPE_DFTYPES);
  TableName:='dfTypes';
  KeyField:='dfTypesId';
  AppMainTreeDescriptionField:='Caption';
  ImageIndex:= IMAGEINDEX_ITYPE_DFTYPES;
  iType:=iTypeDfTypes;
end;

destructor TManagerEditorDfTypes.Destroy;
begin

  inherited;
end;


procedure TManagerEditorDfTypes.DoAfterNewTreeItem;
begin
  inherited;
  NewTreeItem(S_DF_SCHEMA,Self.AppMainTreeId,iTypeDfScheme,Self.ID,IMAGEINDEX_ITYPE_DFSCHEME, DBName);
end;

procedure TManagerEditorDfTypes.EnterEditingState;
begin
  inherited;
  dfClassesId:=DataSet.FieldByName('dfClassesId').AsInteger;
  PopulateDropDown;
end;

procedure TManagerEditorDfTypes.EnterInsertingState;
begin
  inherited;
  dfClassesId:=OwnerObjectId;
  PopulateDropDown;
  DataSet.FieldByName('dfTypesId').AsInteger:=TDataBaseUtils.NewAppObjectId(sq_dfTypes);
  DataSet.FieldByName('Caption').AsString:=DataSet.FieldByName('dfTypesId').AsString+'.'+ddDfClasses.Text;
  DataSet.FieldByName('FullAccess').AsBoolean:=True;
  DataSet.FieldByName('CanAddFromDesktop').AsBoolean:=True;
  eddfTypesId.Enabled:=True;
end;

procedure TManagerEditorDfTypes.PopulateDropDown;
var
 Builder:TMiceDropDownBuilder;
begin
  Builder:=TMiceDropDownBuilder.Create;
  try
   Builder.DataSet.ProviderName:='spui_AppDfClassesList';
   Builder.DataSet.SetParameter('dfClassesId',dfClassesId);
   Builder.DataSet.DBName:=Self.DBName;
   Builder.Items:=ddDfClasses.Properties.Items;
   Builder.Build;
   if ddDfClasses.Properties.Items.Count>0 then
    ddDfClasses.ItemIndex:=0;
  finally
   Builder.Free;
  end;
end;



initialization
   TWindowManager.RegisterEditor(iTypeDfTypes,nil,TManagerEditorDfTypes, False);


end.
