unit ManagerEditor.dfMethod;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, ManagerEditor.Common, cxGraphics,
  cxLookAndFeels, cxLookAndFeelPainters, Vcl.Menus, cxControls, Data.DB,
  cxClasses, dxLayoutContainer, dxLayoutControl, Vcl.StdCtrls, cxButtons,
  dxflchrt,cxContainer, cxEdit, dxLayoutcxEditAdapters, dxLayoutControlAdapters,
  Vcl.DBCtrls, cxTextEdit,  cxDBEdit, cxMaskEdit, cxDropDownEdit, cxMemo,
  Vcl.ExtCtrls,Vcl.Buttons,
  Manager.WindowManager,
  DAC.DatabaseUtils,
  DAC.xDataSet,
  Common.Images,
  Common.Images.SelectDialog,
  Common.ResourceStrings,
  CustomControl.MiceSyntaxEdit,
  CustomControl.MiceFlowChart.FlowObjects,
  Permissions.Frame;

type
  TDBMemo = class(TMiceSyntaxEdit)
  end;

  TManagerEditorDfMethod = class(TCommonManagerDialog)
    Tab0: TdxLayoutGroup;
    Tab1: TdxLayoutGroup;
    Tab2: TdxLayoutGroup;
    Tab3: TdxLayoutGroup;
    edCaption: TcxDBTextEdit;
    item_edCaption: TdxLayoutItem;
    cbActive: TDBCheckBox;
    dxLayoutItem1: TdxLayoutItem;
    Image1: TImage;
    dxLayoutItem2: TdxLayoutItem;
    Label1: TLabel;
    dxLayoutItem3: TdxLayoutItem;
    CommonGroup: TdxLayoutGroup;
    cbAllowRollBack: TDBCheckBox;
    item_cbAllowRollBack: TdxLayoutItem;
    cbDefaultRoute: TDBCheckBox;
    item_cbDefaultRoute: TdxLayoutItem;
    ddCodeName: TcxDBComboBox;
    item_ddCodeName: TdxLayoutItem;
    bnImageIndex: TcxButton;
    dxLayoutItem6: TdxLayoutItem;
    cbAllowFromDesktop: TDBCheckBox;
    item_cbAllowFromDesktop: TdxLayoutItem;
    dxLayoutAutoCreatedGroup2: TdxLayoutAutoCreatedGroup;
    InfoMemo: TcxDBMemo;
    item_InfoMemo: TdxLayoutItem;
    Group_All: TdxLayoutGroup;
    item_PermissionsFrame: TdxLayoutItem;
    PermissionsFrame1: TPermissionsFrame;
    cbUseExpression: TDBCheckBox;
    item_cbUseExpression: TdxLayoutItem;
    edUserMessage: TcxDBTextEdit;
    item_UserMessage: TdxLayoutItem;
    memo_Expression: TDBMemo;
    item_memoExpression: TdxLayoutItem;
    Group_Expression: TdxLayoutGroup;
    dxLayoutAutoCreatedGroup1: TdxLayoutAutoCreatedGroup;
    procedure bnImageIndexClick(Sender: TObject);
    procedure cbActiveClick(Sender: TObject);
    procedure cbUseExpressionClick(Sender: TObject);
  private
    FMethod: TMiceFlowConnector;
    procedure SetActivity(AValue:Boolean);
    procedure UpdateGroupActivity;
  public
    property Method:TMiceFlowConnector read FMethod write FMethod;
    procedure SaveMethod;
    procedure SynchronizeTree(ItemInserted:Boolean); override;
    procedure Initialize; override;
    constructor Create(AOwner:TComponent);override;
    destructor Destroy; override;
  end;


implementation

{$R *.dfm}

{ TManagerEditorDpMethod }

procedure TManagerEditorDfMethod.bnImageIndexClick(Sender: TObject);
var
 AIndex:Integer;
begin
 AIndex:=DataSet.FieldByName('ImageIndex').AsInteger;
 if TSelectImageDialog.Execute(AIndex) then
  begin
   DataSet.FieldByName('ImageIndex').AsInteger:=AIndex;
   bnImageIndex.OptionsImage.ImageIndex:=AIndex;
  end;
end;

procedure TManagerEditorDfMethod.cbActiveClick(Sender: TObject);
begin
 SetActivity(cbActive.Checked);

end;

procedure TManagerEditorDfMethod.cbUseExpressionClick(Sender: TObject);
begin
 UpdateGroupActivity;
end;

constructor TManagerEditorDfMethod.Create(AOwner: TComponent);
begin
  inherited;
  TableName:='dfMethods';
  KeyField:='dfMethodsId';
  AppMainTreeDescriptionField:='Caption';
  ImageIndex:= IMAGEINDEX_ITYPE_DFMETHOD;
  iType:=iTypeDfMethod;
  ImageContainer.LoadToImage(Image1, ImageIndex);
end;

destructor TManagerEditorDfMethod.Destroy;
begin

  inherited;
end;

procedure TManagerEditorDfMethod.Initialize;
begin
  inherited;
  bnImageIndex.OptionsImage.ImageIndex:=DataSet.FieldByName('ImageIndex').AsInteger;
//  SetFolderFontStyle(DataSet.FieldByName('FontStyle').AsInteger);
  SetActivity(cbActive.Checked);
end;

procedure TManagerEditorDfMethod.SaveMethod;
begin
 Method.LoadFromDataSet(Self.DataSet);
end;

procedure TManagerEditorDfMethod.SetActivity(AValue: Boolean);
begin
 Group_All.Enabled:=AValue;
 Group_Expression.Enabled:=cbUseExpression.Checked and AValue;
end;

procedure TManagerEditorDfMethod.SynchronizeTree(ItemInserted: Boolean);
begin
 //DoNothing;
end;


procedure TManagerEditorDfMethod.UpdateGroupActivity;
begin
 Group_Expression.Enabled:=cbUseExpression.Checked;
end;

initialization
  TWindowManager.RegisterEditor(iTypeDfMethod,nil,TManagerEditorDfMethod, False);
finalization


end.
