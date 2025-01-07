unit ManagerEditor.dfPathFolder.ActionsFrame.CommonDialog;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, ManagerEditor.Common, cxGraphics,
  cxLookAndFeels, cxLookAndFeelPainters, Vcl.Menus, cxControls, Data.DB,
  cxClasses, dxLayoutContainer, dxLayoutControl, Vcl.StdCtrls, cxButtons,
  Vcl.Buttons, Vcl.ExtCtrls,dxLayoutControlAdapters, dxLayoutcxEditAdapters,
  cxContainer, cxEdit, cxTextEdit, cxMaskEdit, cxButtonEdit, Vcl.DBCtrls,
  cxDBEdit, cxMemo,  cxDropDownEdit, cxImageComboBox,System.Generics.Collections,
  Manager.WindowManager,
  Common.Images,
  Common.Images.SelectDialog,
  Common.ResourceStrings,
  CustomControl.MiceSyntaxEdit,
  CustomControl.MiceValuePicker,
  DAC.DatabaseUtils, DAC.XDataSet;

const
 ACTION_TYPE_SEND_MAIL = 0;
 ACTION_TYPE_SEND_STOREDPROC = 1;

type
  TDBMemo = class(TMiceSyntaxEdit)
  end;

  TcxButtonEdit = class (TMiceValuePicker)

  end;

  TCommonDfActionsDialogType = class of TCommonDfActionsDialog;

  TCommonDfActionsDialog = class(TCommonManagerDialog)
    Group_Common: TdxLayoutGroup;
    Group_Properties: TdxLayoutGroup;
    cbActive: TDBCheckBox;
    item_cbActive: TdxLayoutItem;
    edOrderId: TcxDBTextEdit;
    item_edOrderId: TdxLayoutItem;
    Group_Expression: TdxLayoutGroup;
    edCaption: TcxDBTextEdit;
    item_edCaption: TdxLayoutItem;
    Group_GroupOptions: TdxLayoutGroup;
    cbRequiresTransaction: TDBCheckBox;
    item_cbRequiresTransaction: TdxLayoutItem;
    cbRunSynchro: TDBCheckBox;
    item_cbRunSynchro: TdxLayoutItem;
    cbUseExpression: TDBCheckBox;
    item_cbUseExpression: TdxLayoutItem;
    memoExpression: TDBMemo;
    item_memoExpression: TdxLayoutItem;
    cbVisibleToUser: TDBCheckBox;
    item_cbVisibleToUser: TdxLayoutItem;
    memoUserInformation: TcxDBMemo;
    item_memoUserMessage: TdxLayoutItem;
    bnImageIndex: TcxButton;
    item_ImageIndex: TdxLayoutItem;
    Group_User: TdxLayoutGroup;
    Group_Main: TdxLayoutGroup;
    dxLayoutAutoCreatedGroup2: TdxLayoutAutoCreatedGroup;
    ddPushOrRollback: TcxDBImageComboBox;
    Item_ddPushOrRollback: TdxLayoutItem;
    dxLayoutAutoCreatedGroup1: TdxLayoutAutoCreatedGroup;
    Image1: TImage;
    item_Image: TdxLayoutItem;
    Label1: TLabel;
    dxLayoutItem1: TdxLayoutItem;
    dxLayoutAutoCreatedGroup3: TdxLayoutAutoCreatedGroup;
    DetailSource: TDataSource;
    ddOnError: TcxDBImageComboBox;
    Item_ddOnError: TdxLayoutItem;
    procedure cbActiveClick(Sender: TObject);
    procedure cbUseExpressionClick(Sender: TObject);
    procedure bnImageIndexClick(Sender: TObject);
  private
    FDefaultOrderId: Integer;
    FDefaultCaption: string;
    FdfPathFoldersId: Integer;
    FActionType: Variant;
    procedure SetActivity(AValue:Boolean); virtual;
    procedure SetdfPathFoldersId(const Value: Integer);
  protected
    FDataSet:TxDataSet;
    property ActionType:Variant read FActionType write FActionType;
    procedure EnterInsertingState; override;
    procedure EnterEditingState; override;
    procedure SetCbExpressionActivity;
  public
    procedure SynchronizeTree(ItemInserted:Boolean); override;
    procedure Initialize; override;
    property dfPathFoldersId:Integer read FdfPathFoldersId write SetdfPathFoldersId;
    property DefaultOrderId:Integer read FDefaultOrderId write FDefaultOrderId;
    property DefaultCaption:string read FDefaultCaption write FDefaultCaption;
    constructor Create(AOwner:TComponent);override;
    destructor Destroy; override;
    class procedure RegisterActionEditor(ActionType:Integer; AClass:TCommonDfActionsDialogType);
    class function ActionEditorClass(ActionType:Integer):TCommonDfActionsDialogType;
  end;


implementation
var
 FActionsEditors:TDictionary<Integer,TCommonDfActionsDialogType>;

{$R *.dfm}

{ TCommonDfActionsDialog }

class procedure TCommonDfActionsDialog.RegisterActionEditor(ActionType: Integer;  AClass: TCommonDfActionsDialogType);
begin
 FActionsEditors.Add(ActionType, AClass);
end;

class function TCommonDfActionsDialog.ActionEditorClass(ActionType: Integer): TCommonDfActionsDialogType;
begin
 Result:=FActionsEditors[ActionType];
end;

procedure TCommonDfActionsDialog.bnImageIndexClick(Sender: TObject);
var
 AImageIndex:Integer;
begin
 AImageIndex:=DataSet.FieldByName('ImageIndex').AsInteger;
 if TSelectImageDialog.Execute(AImageIndex) then
  begin
   bnImageIndex.OptionsImage.ImageIndex:=AImageIndex;
   DataSet.FieldByName('ImageIndex').AsInteger:=AImageIndex;
  end;
end;

procedure TCommonDfActionsDialog.cbActiveClick(Sender: TObject);
begin
 SetActivity(cbActive.Checked);
end;

procedure TCommonDfActionsDialog.cbUseExpressionClick(Sender: TObject);
begin
 SetCbExpressionActivity;
end;

constructor TCommonDfActionsDialog.Create(AOwner: TComponent);
begin
  inherited;
  TableName:='dfPathFolderActions';
  KeyField:='dfPathFolderActionsid';
  AppMainTreeDescriptionField:='Caption';
  ImageIndex:= IMAGEINDEX_ITYPE_DFPATHFOLDER;
  iType:=iTypeDfAction;
  ImageContainer.LoadToImage(Image1, ImageIndex);

  memoExpression.Syntax:='Sql';
end;

destructor TCommonDfActionsDialog.Destroy;
begin

  inherited;
end;

procedure TCommonDfActionsDialog.EnterEditingState;
begin
  inherited;
  bnImageIndex.OptionsImage.ImageIndex:=DataSet.FieldByName('ImageIndex').AsInteger;
  SetCbExpressionActivity;
end;

procedure TCommonDfActionsDialog.EnterInsertingState;
begin
  inherited;
  DataSet.FieldByName('dfPathFolderActionsId').AsInteger:=TDataBaseUtils.NewAppObjectId(sq_dfPathFolderActions);
  DataSet.FieldByName('dfPathFoldersId').AsInteger:=dfPathFoldersId;
  DataSet.FieldByName('Caption').AsString:=DefaultCaption+' '+DefaultOrderId.ToString;
  DataSet.FieldByName('UseExpression').AsBoolean:=False;
  DataSet.FieldByName('OrderId').AsInteger:=DefaultOrderId*10;
  DataSet.FieldByName('PushOrRollback').AsInteger:=0;
  DataSet.FieldByName('Active').AsBoolean:=True;
  DataSet.FieldByName('VisibleToUser').AsBoolean:=True;
  DataSet.FieldByName('RunSynchro').AsBoolean:=False;
  DataSet.FieldByName('RequiresTransaction').AsBoolean:=False;
  DataSet.FieldByName('ActionType').Value:=ActionType;
  DataSet.FieldByName('ImageIndex').AsInteger:=ImageIndex;
  DataSet.FieldByName('OnError').AsInteger:=0;
  bnImageIndex.OptionsImage.ImageIndex:=ImageIndex;
 SetCbExpressionActivity;
end;

procedure TCommonDfActionsDialog.Initialize;
begin
  inherited;
  DetailDataSets.OpenAll;
  SetActivity(cbActive.Checked);
end;

procedure TCommonDfActionsDialog.SetActivity(AValue: Boolean);
begin
 Group_Main.Enabled:=AValue;
end;

procedure TCommonDfActionsDialog.SetCbExpressionActivity;
begin
 memoExpression.Enabled:=Self.cbUseExpression.Checked;
end;

procedure TCommonDfActionsDialog.SetdfPathFoldersId(const Value: Integer);
begin
 FdfPathFoldersId := Value;
end;

procedure TCommonDfActionsDialog.SynchronizeTree(ItemInserted: Boolean);
begin
 //DoNothing
end;


initialization
 FActionsEditors:=TDictionary<Integer,TCommonDfActionsDialogType>.Create;
finalization
 FActionsEditors.Free;


end.
