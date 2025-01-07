unit ManagerEditor.Common;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, cxGraphics, cxLookAndFeels,
  cxLookAndFeelPainters, Vcl.Menus, Data.DB, Vcl.StdCtrls, cxButtons,
  Vcl.ExtCtrls, cxControls, cxClasses, dxLayoutContainer, dxLayoutControl,
  dxLayoutLookAndFeels,
  Dialog.Layout,
  DAC.XDataSet,
  DAC.DatabaseUtils,
  Common.Images,
  Common.LookAndFeel,
  CustomControl.AppObject,
  MainForm.CaptionUpdater,
  MainForm.TreeRefresher, Vcl.Buttons;

type
  TCommonManagerDialog = class(TBasicLayoutDialog)
    bnAdvanced: TSpeedButton;
    PopupMenu: TPopupMenu;
    miCopyFrom: TMenuItem;
    procedure bnOKClick(Sender: TObject);
    procedure bnCancelClick(Sender: TObject);
    procedure bnAdvancedClick(Sender: TObject);
  private
    FAppMainTreeId: Integer;
    FCanEditMultiplyIDs: boolean;
    FParentId: Variant;
    FImageIndex: Integer;
    FiType: Integer;
    FAppMainTreeDescriptionField: string;
    FOwnerObjectId: Variant;
    FCloseEvent: TNotifyEvent;
    FMiceAppObject:TMiceAppObject;
    function GetAppMainTreeDescriptionField: string;
    function GetMiceAppObject: TMiceAppObject;
  protected
    function GetAppMainTreeDescription: string;
    procedure DoAfterNewTreeItem; virtual;
    procedure DoNewTreeItem;
    procedure DoUpdateTreeItem;
    procedure CheckParentId;
    procedure CheckBeforeSave; virtual;
    procedure SynchronizeTree(ItemInserted:Boolean); virtual;
    class function NewTreeItem(const Description: string; const ParentId:Variant; const iType, ObjectId, ImageIndex:Integer; const ADBName:string = ''):Integer;
  public
    property AppMainTreeDescriptionField:string read GetAppMainTreeDescriptionField write FAppMainTreeDescriptionField;
    property AppMainTreeDescription:string read GetAppMainTreeDescription;
    property iType:Integer read FiType write FiType;
    property ImageIndex:Integer read FImageIndex write FImageIndex;
    property AppMainTreeId:Integer read FAppMainTreeId write FAppMainTreeId;
    property ParentId: Variant read FParentId write FParentId;
    property OwnerObjectId:Variant read FOwnerObjectId write FOwnerObjectId;
    property CanEditMultiplyIDs:boolean read FCanEditMultiplyIDs write FCanEditMultiplyIDs;
    property CloseEvent:TNotifyEvent read FCloseEvent write FCloseEvent;
    property MiceAppObject:TMiceAppObject read GetMiceAppObject;
    procedure EditID(ID:Integer; const PageName:string); virtual;
    procedure CreateParams(var Params: TCreateParams); override;
    procedure DoCloseEvent; virtual;
    procedure SaveChanges; virtual;
    constructor Create(AOwner:TComponent); override;
    destructor Destroy; override;
  end;

 TCommonManagerDialogClass = class of TCommonManagerDialog;

implementation

{$R *.dfm}


{ TCommonManagerDialog }


procedure TCommonManagerDialog.bnAdvancedClick(Sender: TObject);
var
  P:TPoint;
begin
  P.x:=bnAdvanced.Left;
  P.y:=bnAdvanced.Top+bnAdvanced.Height-5;
  P:=bnAdvanced.ClientToScreen(P);
  PopupMenu.Popup(P.x,P.y);
end;


procedure TCommonManagerDialog.bnCancelClick(Sender: TObject);
begin
 Close;
end;

procedure TCommonManagerDialog.bnOKClick(Sender: TObject);
begin
 Close;
end;


procedure TCommonManagerDialog.CheckBeforeSave;
begin

end;

procedure TCommonManagerDialog.CheckParentId;
resourcestring
 S_ParentId_NOT_SET_IN_EDITOR = 'ParentId is not set in %s class';
begin
  inherited;
  if VarIsNull(ParentId) then
   raise Exception.CreateFmt(S_ParentId_NOT_SET_IN_EDITOR,[ClassName]);
end;

constructor TCommonManagerDialog.Create(AOwner: TComponent);
begin
  inherited;
  DataSet.Source:=ClassName+'.MainTable';
  FCanEditMultiplyIDs:=False;
  Sizeable:=True;
end;

procedure TCommonManagerDialog.CreateParams(var Params: TCreateParams);
begin
  inherited;
  //Params.WndParent:=0;
end;

destructor TCommonManagerDialog.Destroy;
begin
  FMiceAppObject.Free;
  inherited;
end;

procedure TCommonManagerDialog.DoAfterNewTreeItem;
begin

end;

procedure TCommonManagerDialog.DoCloseEvent;
begin
 if Assigned(CloseEvent) then
  CloseEvent(Self);
end;

procedure TCommonManagerDialog.DoNewTreeItem;
begin
 AppMainTreeId:=NewTreeItem(AppMainTreeDescription, ParentId, iType, ID,ImageIndex);
 DoAfterNewTreeItem;
 TMainFormTreeRefresher.DefaultInstance.ItemInserted(AppMainTreeId,ParentId,AppMainTreeDescription,iType, ID,ImageIndex);
end;

procedure TCommonManagerDialog.EditID(ID: Integer; const PageName:string);
resourcestring
  S_EDITOR_NOT_SUPPORT_MULTIPLY_DOCUMENTS = 'Editor does not support editing multiply documents in same window';
begin
 if FCanEditMultiplyIDs=False then
  raise Exception.Create(S_EDITOR_NOT_SUPPORT_MULTIPLY_DOCUMENTS);
end;


function TCommonManagerDialog.GetAppMainTreeDescription: string;
begin
 Result:=Self.DataSet.FieldByName(AppMainTreeDescriptionField).AsString;
end;

function TCommonManagerDialog.GetAppMainTreeDescriptionField: string;
resourcestring
 S_APP_DESCRIPTION_NOT_DEFINED_IN = 'AppMainTree description is not defined in %s';
begin
 if FAppMainTreeDescriptionField.Trim.IsEmpty then
  raise Exception.CreateFmt(S_APP_DESCRIPTION_NOT_DEFINED_IN,[ClassName]);
 Result:=FAppMainTreeDescriptionField;
end;

function TCommonManagerDialog.GetMiceAppObject: TMiceAppObject;
begin
 if not Assigned(FMiceAppObject) then
  FMiceAppObject:=TMiceAppObject.Create;
  Result:=FMiceAppObject;
end;

class function TCommonManagerDialog.NewTreeItem(const Description: string; const ParentId: Variant; const iType, ObjectId, ImageIndex: Integer; const ADBName:string = ''): Integer;
begin
 Result:=TDataBaseUtils.NewTreeItem(Description, ParentId, iType, ObjectId, ImageIndex, ADBName);
end;

procedure TCommonManagerDialog.SaveChanges;
var
 OldID:Integer;
begin
  try
   CheckBeforeSave;
   if ID<=0 then
    CheckParentId;
   OldID:=ID;
   DoApplyUpdates;
   SynchronizeTree((OldID<=0) and (ID>0));

  except
   ModalResult:=mrNone;
   raise;
  end;
end;

procedure TCommonManagerDialog.SynchronizeTree(ItemInserted: Boolean);
begin
  if ItemInserted then
   DoNewTreeItem
    else
   DoUpdateTreeItem;
end;

procedure TCommonManagerDialog.DoUpdateTreeItem;
begin
  TCaptionUpdater.UpdateAppMainTreeCaption(AppMainTreeId,AppMainTreeDescription);
  TCaptionUpdater.UpdateTreeItemImageIndex(AppMainTreeId, ImageIndex);
  TMainFormTreeRefresher.DefaultInstance.ItemUpdated(AppMainTreeId, ParentId,AppMainTreeDescription, ImageIndex);
end;


end.
