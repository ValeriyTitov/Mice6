unit ManagerEditor.Filter;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, ManagerEditor.Common, cxGraphics,
  cxLookAndFeels, cxLookAndFeelPainters, Vcl.Menus, cxControls, Data.DB,
  cxClasses, dxLayoutContainer, dxLayoutControl, Vcl.StdCtrls, cxButtons,
  Vcl.ExtCtrls,dxLayoutcxEditAdapters, cxContainer, cxEdit,
  cxTextEdit, cxDBEdit, cxMemo, cxMaskEdit, cxDropDownEdit, cxImageComboBox,
  cxCheckBox, dxBarBuiltInMenu, cxPC, cxButtonEdit,dxLayoutControlAdapters,
  Common.Images,
  Common.Images.SelectDialog,
  DAC.XDataSet,
  DAC.DataBaseUtils,
  CustomControl.Interfaces,
  Common.ResourceStrings,
  CustomControl.AppObject,
  Manager.WindowManager,
  Params.SourceSelectorFrame,
  CustomControl.MiceDropDown.EditorFrame, Vcl.Buttons, cxSpinEdit;

type
  TcxPageControl = class(CxPC.TcxPageControl, IAmLazyControl)
   procedure LazyInit(ParentObject: IInheritableAppObject);
   procedure RefreshDataSet;
  end;

  TManagerEditorFilter = class(TCommonManagerDialog)
    Tab0: TdxLayoutGroup;
    Label1: TLabel;
    dxLayoutItem1: TdxLayoutItem;
    Image1: TImage;
    Image1_Item: TdxLayoutItem;
    edAppCmdId: TcxDBTextEdit;
    edAppCmdId_item: TdxLayoutItem;
    dxLayoutAutoCreatedGroup2: TdxLayoutAutoCreatedGroup;
    dxLayoutSeparatorItem1: TdxLayoutSeparatorItem;
    edName: TcxDBTextEdit;
    edName_Item: TdxLayoutItem;
    edLocation: TcxDBTextEdit;
    edLocation_Item: TdxLayoutItem;
    Tab1: TdxLayoutGroup;
    memoDescr: TcxDBMemo;
    memoDescr_Item: TdxLayoutItem;
    edHint: TcxDBTextEdit;
    edHint_Item: TdxLayoutItem;
    edCreateOrder: TcxDBTextEdit;
    edCreateOrder_Item: TdxLayoutItem;
    dxLayoutGroup1: TdxLayoutGroup;
    dxLayoutGroup2: TdxLayoutGroup;
    edEnabledFieldName: TcxDBTextEdit;
    edEnabledFieldName_Item: TdxLayoutItem;
    edEnabledValue: TcxDBTextEdit;
    edEnabledValue_Item: TdxLayoutItem;
    dxLayoutAutoCreatedGroup4: TdxLayoutAutoCreatedGroup;
    edEnabledSign: TcxDBImageComboBox;
    edEnabledSign_Item: TdxLayoutItem;
    edCaption: TcxDBTextEdit;
    edCaption_Item: TdxLayoutItem;
    chboxAlwaysEnabled: TcxDBCheckBox;
    chboxAlwaysEnabled_Item: TdxLayoutItem;
    dxLayoutAutoCreatedGroup7: TdxLayoutAutoCreatedGroup;
    ddFilterType: TcxDBImageComboBox;
    ddFilterType_Item: TdxLayoutItem;
    Image2: TImage;
    dxLayoutItem3: TdxLayoutItem;
    dxLayoutSeparatorItem2: TdxLayoutSeparatorItem;
    Tab2: TdxLayoutGroup;
    dxLayoutGroup3: TdxLayoutGroup;
    pgFilterType: TcxPageControl;
    pgActionType_Item: TdxLayoutItem;
    ATab0: TcxTabSheet;
    ATab1: TcxTabSheet;
    ATab2: TcxTabSheet;
    ATab3: TcxTabSheet;
    ATab4: TcxTabSheet;
    ATab5: TcxTabSheet;
    cbEnabledWhenNoRecords: TcxDBCheckBox;
    dxLayoutItem2: TdxLayoutItem;
    ATab6: TcxTabSheet;
    ATab7: TcxTabSheet;
    Panel1: TPanel;
    Label2: TLabel;
    cxDBTextEdit1: TcxDBTextEdit;
    cxDBTextEdit3: TcxDBTextEdit;
    cxDBTextEdit4: TcxDBTextEdit;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Panel3: TPanel;
    Label6: TLabel;
    Label9: TLabel;
    cxDBTextEdit5: TcxDBTextEdit;
    Panel4: TPanel;
    Label7: TLabel;
    Label11: TLabel;
    cxDBTextEdit6: TcxDBTextEdit;
    Panel5: TPanel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    cxDBTextEdit10: TcxDBTextEdit;
    cxDBTextEdit11: TcxDBTextEdit;
    cxDBTextEdit12: TcxDBTextEdit;
    cxDBTextEdit13: TcxDBTextEdit;
    Label16: TLabel;
    Panel6: TPanel;
    Label17: TLabel;
    Label20: TLabel;
    cxDBTextEdit14: TcxDBTextEdit;
    Panel7: TPanel;
    Label21: TLabel;
    Label24: TLabel;
    cxDBTextEdit18: TcxDBTextEdit;
    cxDBTextEdit21: TcxDBTextEdit;
    Label25: TLabel;
    Panel2: TPanel;
    Label26: TLabel;
    Label27: TLabel;
    cxDBTextEdit22: TcxDBTextEdit;
    Panel8: TPanel;
    Label28: TLabel;
    Label29: TLabel;
    cxDBTextEdit23: TcxDBTextEdit;
    ddEdit: TDropDownEditorFrame;
    bnImageIndex: TcxButton;
    dxLayoutItem4: TdxLayoutItem;
    edWidth: TcxDBTextEdit;
    item_Width: TdxLayoutItem;
    dxLayoutAutoCreatedGroup3: TdxLayoutAutoCreatedGroup;
    ddCheckBoxStyle: TcxImageComboBox;
    Label8: TLabel;
    cbAutoRefresh: TcxDBCheckBox;
    item_AutoRefresh: TdxLayoutItem;
    ATab8: TcxTabSheet;
    Panel9: TPanel;
    Label10: TLabel;
    Label22: TLabel;
    cxDBTextEdit2: TcxDBTextEdit;
    dxLayoutAutoCreatedGroup1: TdxLayoutAutoCreatedGroup;
    seMinTextLength: TcxSpinEdit;
    Label18: TLabel;
    procedure ddExecuteActionPropertiesChange(Sender: TObject);
    procedure chboxAlwaysEnabledClick(Sender: TObject);
    procedure edEnabledSignPropertiesChange(Sender: TObject);
    procedure pgFilterTypePageChanging(Sender: TObject; NewPage: TcxTabSheet;
      var AllowChange: Boolean);
    procedure bnImageIndexClick(Sender: TObject);
  private
    FCmdParams:TxDataSet;
    FCmdParamsDs:TDataSource;
    FOpening:Boolean;
    FAppPluginsId: Variant;
    procedure UpdateActivityCondition(Value:Boolean);
    procedure UpdateSign(Value:Integer);
    procedure SaveInitString;
    procedure LoadInitString;
  protected
    procedure EnterInsertingState; override;
    procedure EnterEditingState; override;
  public
    property AppPluginsId:Variant read FAppPluginsId write FAppPluginsId;
    procedure Initialize; override;
    procedure SaveChanges; override;
    constructor Create(AOwner:TComponent);override;
    destructor Destroy; override;
  end;

  TManagerEditorCommonFilter = class(TManagerEditorFilter)
  protected
   procedure EnterInsertingState; override;
   procedure SynchronizeTree(ItemInserted:Boolean); override;
  public
   procedure Initialize; override;
   constructor Create(AOwner:TComponent);override;
  end;

implementation

const
 TMICE_CHECKBOX = 0;
 TMICE_EDIT     = 1;
 TMICE_DROPDOWN = 2;

{$R *.dfm}
constructor TManagerEditorFilter.Create(AOwner: TComponent);
begin
  inherited;
  pgFilterType.Properties.HideTabs:=True;
  FOpening:=True;
  TableName:='AppCmd';
  KeyField:='AppCmdId';
  ImageIndex:= IMAGEINDEX_FILTER;
  iType:=iTypeFilter;
  AppMainTreeDescriptionField:='Caption';

  TImageContainer.LoadToImage(Image1,514);
  TImageContainer.LoadToImage(Image2,691);
  FCmdParamsDs:=DetailDataSets.CreateDataSource('AppCmdParams','','','TManagerEditorCommand.CommandParams','','');
  FCmdParams:=FCmdParamsDs.DataSet as TxDataSet;
end;

procedure TManagerEditorFilter.bnImageIndexClick(Sender: TObject);
var
 AImageIndex:Integer;
begin
 AImageIndex:=DataSet.FieldByName('ImageIndex').AsInteger;
 if TSelectImageDialog.Execute(AImageIndex) then
  begin
   bnImageIndex.OptionsImage.ImageIndex:=AImageIndex;
   DataSet.FieldByName('ImageIndex').AsInteger:=AImageIndex;
   ImageIndex:=AImageIndex;
  end;
end;

procedure TManagerEditorFilter.chboxAlwaysEnabledClick(Sender: TObject);
begin
 UpdateActivityCondition(not chboxAlwaysEnabled.Checked);
end;

procedure TManagerEditorFilter.ddExecuteActionPropertiesChange(Sender: TObject);
var
 AIndex:Integer;
begin
 AIndex:=Self.ddFilterType.ItemIndex;
 pgFilterType.ActivePageIndex:=AIndex;
end;

destructor TManagerEditorFilter.Destroy;
begin
  inherited;
end;


procedure TManagerEditorFilter.edEnabledSignPropertiesChange(Sender: TObject);
begin
 UpdateSign(edEnabledSign.ItemIndex);
end;


procedure TManagerEditorFilter.EnterEditingState;
begin
  inherited;
  AppPluginsId:=DataSet.FieldByName('AppPluginsId').Value;
  LoadInitString;
  edAppCmdId.Enabled:=False;
  UpdateActivityCondition(not chboxAlwaysEnabled.Checked);
  UpdateSign(edEnabledSign.ItemIndex);
end;

procedure TManagerEditorFilter.EnterInsertingState;
begin
  inherited;
  AppPluginsId:=OwnerObjectId;
  DataSet.FieldByName('AppCmdId').AsInteger:=TDataBaseUtils.NewAppObjectId(sq_AppCmd);
  DataSet.FieldByName('CommandType').AsInteger:=0;
  DataSet.FieldByName('AppPluginsId').Value:=AppPluginsId;
  DataSet.FieldByName('ImageIndex').AsInteger:=ImageIndex;
  DataSet.FieldByName('iType').AsInteger:=iTypeFilter;
  DataSet.FieldByName('ActionType').AsInteger:=0;
  DataSet.FieldByName('Location').AsString:=S_DEFAULT_COMMON_LOCATION;
  DataSet.FieldByName('AlwaysEnabled').AsBoolean:=True;
  DataSet.FieldByName('Name').AsString:='NewFilter'+DataSet.FieldByName('AppCmdId').AsString;
  DataSet.FieldByName('Caption').AsString:=DataSet.FieldByName('Name').AsString;
  //DataSet.FieldByName('Group').AsInteger:=0;
  DataSet.FieldByName('AppearsOn').AsInteger:=0;
  DataSet.FieldByName('Width').AsInteger:=80;
  DataSet.FieldByName('CreateOrder').AsInteger:=100;
  DataSet.FieldByName('EnabledSign').AsInteger:=0;
  DataSet.FieldByName('FullAccess').AsBoolean:=True;
  DataSet.FieldByName('Active').AsBoolean:=True;
  DataSet.FieldByName('EnabledNoRecords').AsBoolean:=False;
  DataSet.FieldByName('AutoRefresh').AsBoolean:=True;
 // DataSet.FieldByName('Name').AsString:='NewCommand'+' '+DataSet.FieldByName('AppCmdId').AsString;
end;

procedure TManagerEditorFilter.Initialize;
begin
 FOpening:=True;
 inherited;
 bnImageIndex.OptionsImage.ImageIndex:=DataSet.FieldByName('ImageIndex').AsInteger;
 FOpening:=False;
end;


procedure TManagerEditorFilter.LoadInitString;
begin
 MiceAppObject.AsJson:=DataSet.FieldByName('InitString').AsString;
 ddEdit.LoadFromMiceAppObject(MiceAppObject);
 ddCheckBoxStyle.ItemIndex:=MiceAppObject.Properties.Style;
 seMinTextLength.Value:=MiceAppObject.Properties.MinTextLength;
end;

procedure TManagerEditorFilter.pgFilterTypePageChanging(Sender: TObject; NewPage: TcxTabSheet; var AllowChange: Boolean);
var
 Control:TControl;
 x:Integer;
begin
if FOpening=False then
 for x:=0 to NewPage.ControlCount-1 do
  begin
   Control:=NewPage.Controls[x];
   if Supports(Control,IAmLazyControl) then
   (Control as IAmLazyControl).LazyInit(nil);
  end;
end;


procedure TManagerEditorFilter.SaveChanges;
begin
  SaveInitString;
  inherited;
end;

procedure TManagerEditorFilter.UpdateActivityCondition(Value: Boolean);
begin
 edEnabledFieldName.Enabled:=Value;
 edEnabledSign.Enabled:=Value;
 edEnabledValue.Enabled:=Value;
 cbEnabledWhenNoRecords.Enabled:=Value;
 UpdateSign(edEnabledSign.ItemIndex)
end;

procedure TManagerEditorFilter.SaveInitString;
begin
 ddEdit.SaveToMiceMiceAppObject(MiceAppObject);
 MiceAppObject.Properties.Style:=ddCheckBoxStyle.ItemIndex;
 MiceAppObject.Properties.MinTextLength:=seMinTextLength.Value;

 MiceAppObject.WriteNullIfEmpty(DataSet.FieldByName('InitString'));
end;

procedure TManagerEditorFilter.UpdateSign(Value: Integer);
begin
 edEnabledValue.Enabled:=(not chboxAlwaysEnabled.Checked) and ((Value<>6) and (Value<>7)) ;
end;

{ TcxPageControl }

procedure TcxPageControl.LazyInit(ParentObject: IInheritableAppObject);
var
 Allow:Boolean;
begin
 if Assigned(OnPageChanging) and Assigned(ActivePage) then
  begin
   Allow:=True;
   OnPageChanging(Self,ActivePage, Allow);
  end;
end;

procedure TcxPageControl.RefreshDataSet;
begin

end;

{ TManagerEditorCommonFilter }

constructor TManagerEditorCommonFilter.Create(AOwner: TComponent);
begin
  inherited;
  iType:=iTypeCommonFilter;
  ReadOnly:=True;
end;

procedure TManagerEditorCommonFilter.EnterInsertingState;
begin
  inherited;
  DataSet.FieldByName('iType').AsInteger:=iTypeCommonFilter;
  DataSet.FieldByName('AppPluginsId').Clear;
end;

procedure TManagerEditorCommonFilter.Initialize;
begin
  inherited;
  if ReadOnly then
   begin
    Caption:=Caption+S_COMMON_READONLY_BRACKETS;
    Label1.Caption:=Label1.Caption+S_COMMON_READONLY_BRACKETS;
    bnImageIndex.Enabled:=False;
   end;
end;

procedure TManagerEditorCommonFilter.SynchronizeTree(ItemInserted: Boolean);
begin
// do nothing
end;

initialization
  TWindowManager.RegisterEditor(iTypeFilter,nil,TManagerEditorFilter, False);
  TWindowManager.RegisterEditor(iTypeCommonFilter,nil,TManagerEditorCommonFilter, False);
finalization

end.
