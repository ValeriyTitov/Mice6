unit Dialog.Layout;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Dialog.DB, cxGraphics, cxLookAndFeels,
  cxLookAndFeelPainters, Vcl.Menus, Data.DB, Vcl.StdCtrls, cxButtons,
  Vcl.ExtCtrls, cxControls, cxClasses, dxLayoutContainer, dxLayoutControl,
  cxStorage, System.Generics.Collections,
  Common.LookAndFeel,
  Dialog.Layout.JSONStorage,
  Dialog.Layout.JsonStorage.Buffer,
  ClipBrd,
  Common.Images,
  DAC.History.Form,
  CustomControl.Interfaces,
  CustomControl.MiceLayout,
  CustomControl.MiceBalloons;


type
  TdxLayoutControl = class(TMiceLayoutControl)

  end;

  TBasicLayoutDialog = class(TBasicDBDialog)
    DialogLayoutGroup_Root: TdxLayoutGroup;
    DialogLayout: TdxLayoutControl;
    BalloonHint: TBalloonHint;
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    FDialogCaption: string;
    FActiveLazyItems: TList<IAmLazyControl>;
  protected
    property ActiveLazyItems:TList<IAmLazyControl> read FActiveLazyItems;
    procedure UpdateReadOnlyState;override;
    procedure DoAfterOpen(DataSet:TDataSet);override;
    procedure InitLazyControls(AGroup: TdxCustomLayoutGroup);
    procedure InitLazyItem(Item:TdxLayoutItem);virtual;
    procedure AssignOnTabChanges;
    procedure DoOnTabChanging(Sender: TObject; ANewTabIndex: Integer; var Allow: Boolean);
    procedure UpdateCaption;
    procedure LazyInitAll;
    procedure SetHintPoint(const ControlName:string; var Point:TPoint);
  public
    procedure CopyFrom(Dialog:TBasicLayoutDialog; CopyDetails:Boolean=True);
    procedure LoadFromJson(const Json:string);
    procedure SaveToJson(var Json:string); overload;
    procedure SaveToJson(Field:TField); overload;
    procedure FieldNameToClipBoard(Control:TControl);
    constructor Create(AOwner:TComponent); override;
    destructor Destroy; override;
  published
    procedure ControlHint(const ControlName, Title, Description: string);
    property DialogCaption:string read FDialogCaption write FDialogCaption;
  end;

implementation

{$R *.dfm}
type
  TdxLayoutContainerAccess = class(TdxLayoutContainer);
//  TdxLayoutContainerFocusedControllerAccess = class(TdxLayoutContainerFocusedController);


const
 STORAGE_NAME='Self';

{ TBasicLayoutDialog }

procedure TBasicLayoutDialog.AssignOnTabChanges;
var
 X:Integer;
begin
 for x:=0 to ComponentCount-1 do
  if (Components[x] is TdxLayoutGroup) then
     (Components[x] as TdxLayoutGroup).OnTabChanging:=DoOnTabChanging;
end;

procedure TBasicLayoutDialog.SetHintPoint(const ControlName: string;  var Point: TPoint);
var
 WinControl:TWinControl;
begin
 if bnOk.Visible then
  WinControl:=bnOK
   else
  WinControl:=bnCancel;

  Point.X := WinControl.Width div 2;
  Point.Y := WinControl.Top;
  Point:=WinControl.ClientToScreen(Point);
end;

procedure TBasicLayoutDialog.ControlHint(const ControlName, Title, Description: string);
var
 Point:TPoint;
begin
 SetHintPoint(ControlName, Point);
 BalloonHint.Title := Title;
 BalloonHint.Description := Description;
 Balloonhint.ShowHint(Point);
end;

procedure TBasicLayoutDialog.CopyFrom(Dialog: TBasicLayoutDialog; CopyDetails:Boolean=True);
begin
 if DataSet.CopyExclusionList.IndexOf(KeyField)<0 then
  DataSet.CopyExclusionList.Add(KeyField);
 DataSet.CopyRowFrom(Dialog.DataSet,False);
 if CopyDetails then
  begin
   Dialog.LazyInitAll;
   DetailDataSets.ClearDataSets;
   DetailDataSets.CopyFrom(Dialog.DetailDataSets);
  end;
end;

constructor TBasicLayoutDialog.Create(AOwner: TComponent);
begin
  inherited;
  AssignOnTabChanges;
  FActiveLazyItems:=TList<IAmLazyControl>.Create;
end;


destructor TBasicLayoutDialog.Destroy;
begin
  FActiveLazyItems.Free;
  inherited;
end;

procedure TBasicLayoutDialog.DoAfterOpen(DataSet: TDataSet);
begin
  inherited;
  InitLazyControls(Self.DialogLayoutGroup_Root);
end;

procedure TBasicLayoutDialog.DoOnTabChanging(Sender: TObject;  ANewTabIndex: Integer; var Allow: Boolean);
var
 AGroup:TdxLayoutGroup;
begin
 if Sender is TdxLayoutGroup  then
  begin
   AGroup:=(Sender as TdxLayoutGroup);
   if (AGroup.Items[ANewTabIndex] is TdxLayoutGroup) then
     InitLazyControls(AGroup.Items[ANewTabIndex] as TdxLayoutGroup);
    if (AGroup.Items[ANewTabIndex] is TdxLayoutItem) then
     InitLazyItem(AGroup.Items[ANewTabIndex] as TdxLayoutItem);
  end;
end;


procedure TBasicLayoutDialog.FieldNameToClipBoard(Control: TControl);
var
 DataTable:string;
 DataField:string;
 Data:string;
 IDataBind: IHaveDataBinding;
resourcestring
 S_CANNOT_FIND_DATABINDING_FMT = 'Canont find databinding for %s';
 S_DATA_COPIED_TO_CLIPBOARD_FMT = '"%s" is in clipboard.';
begin
 if  Supports(Control.Parent, IHaveDataBinding, IDataBind) or Supports(Control, IHaveDataBinding, IDataBind) then
  begin
   if IDataBind.IDataSource=MainSource then
    DataTable:=TableName
     else
    DataTable:=DetailDataSets.NameOf(IDataBind.IDataSource);

    DataField:=IDataBind.IDataField;
    Data:=DataTable+'.'+DataField;
    Clipboard.AsText:=Data;
    TMiceBalloons.Show(Control.Parent.Name,string.Format(S_DATA_COPIED_TO_CLIPBOARD_FMT,[Data]))
  end
   else
    TMiceBalloons.Show(Control.Parent.Name, string.Format(S_CANNOT_FIND_DATABINDING_FMT,[Control.ClassName]));
end;


procedure TBasicLayoutDialog.FormKeyDown(Sender: TObject; var Key: Word;  Shift: TShiftState);
begin
if Assigned(ActiveControl) and Assigned(ActiveControl.Parent) and (ssCtrl in Shift) then
   case Key of
    VK_F1:FieldNameToClipBoard(ActiveControl);
    VK_F12:TSQLHistoryForm.ShowHistory;
  end
end;

procedure TBasicLayoutDialog.InitLazyControls(AGroup: TdxCustomLayoutGroup);
var
 x: Integer;
 Group:TdxCustomLayoutGroup;
begin
 for x:=0 to AGroup.Count - 1 do
  if AGroup.Items[x] is TdxCustomLayoutGroup  then
   begin
     Group:=AGroup.Items[x] as TdxCustomLayoutGroup;
     InitLazyControls(Group);
     if AGroup.LayoutDirection=ldTabbed then
     Exit;
   end
   else
  if (AGroup.Items[x] is TdxLayoutItem) then
   begin
    InitLazyItem(AGroup.Items[x] as TdxLayoutItem);
    if AGroup.LayoutDirection=ldTabbed then
     Exit;
   end;
end;

procedure TBasicLayoutDialog.InitLazyItem(Item: TdxLayoutItem);
var
 ILazy:IAmLazyControl;
begin
 if Supports(Item.Control,IAmLazyControl, ILazy) then
  begin
   ILazy.LazyInit(Self);
   if not ActiveLazyItems.Contains(ILazy) then
    ActiveLazyItems.Add(ILazy);
  end;
end;

procedure TBasicLayoutDialog.LazyInitAll;
var
 x:Integer;
 Item:TdxLayoutItem;
begin
 for x:=0 to DialogLayout.AbsoluteItemCount-1 do
  if DialogLayout.AbsoluteItems[x] is TdxLayoutItem then
    begin
     Item:=DialogLayout.AbsoluteItems[x] as TdxLayoutItem;
     InitLazyItem(Item);
    end;
end;

procedure TBasicLayoutDialog.LoadFromJson(const Json: string);
var
 AKey:string;
begin
 AKey:=TDialogLayoutStorageBuffer.NewKey;
  try
   TDialogLayoutStorageBuffer.DefaultInstance.Add(AKey,Json);
   DialogLayout.Container.RestoreFromStorage(AKey,TMiceJsonReader,STORAGE_NAME);
  finally
   if TDialogLayoutStorageBuffer.DefaultInstance.ContainsKey(AKey) then
    TDialogLayoutStorageBuffer.DefaultInstance.Remove(AKey);
  end;
end;


procedure TBasicLayoutDialog.SaveToJson(Field: TField);
var
 AKey:string;
begin
  AKey:=TDialogLayoutStorageBuffer.NewKey;
  try
   DialogLayout.Container.StoreToStorage(AKey,TMiceJsonWriter,True,STORAGE_NAME);
   Field.AsString:=TDialogLayoutStorageBuffer.DefaultInstance[AKey];
  finally
   if TDialogLayoutStorageBuffer.DefaultInstance.ContainsKey(AKey) then
    TDialogLayoutStorageBuffer.DefaultInstance.Remove(AKey);
  end;
end;

procedure TBasicLayoutDialog.UpdateCaption;
resourcestring
 S_EDIT_MODE = '%s (Id = %d)';
 S_INSERT_MODE = '%s (Insert)';
 S_READONLY_MODE ='%s (Id = %d, Readonly)';
begin
 if ID<0 then
  Caption:=string.Format(S_INSERT_MODE, [DialogCaption])
   else
    begin
     if ReadOnly then
       Caption:=string.Format(S_READONLY_MODE, [DialogCaption,ID])
        else
       Caption:=string.Format(S_EDIT_MODE, [DialogCaption, ID])
    end;
end;

procedure TBasicLayoutDialog.UpdateReadOnlyState;
begin
  inherited;
  Self.SetParameter('ReadOnly',Self.ReadOnly);
  UpdateCaption;
end;

procedure TBasicLayoutDialog.SaveToJson(var Json: string);
var
 AKey:string;
begin
  AKey:=TDialogLayoutStorageBuffer.NewKey;
  try
   DialogLayout.Container.StoreToStorage(AKey,TMiceJsonWriter,True,STORAGE_NAME);
   Json:=TDialogLayoutStorageBuffer.DefaultInstance[AKey];
  finally
   if TDialogLayoutStorageBuffer.DefaultInstance.ContainsKey(AKey) then
    TDialogLayoutStorageBuffer.DefaultInstance.Remove(AKey);
  end;
end;



end.
