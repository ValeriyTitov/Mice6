unit Manager.WindowManager;

interface
uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, cxGraphics, cxLookAndFeels,
  cxLookAndFeelPainters, Vcl.Menus, Data.DB, Vcl.StdCtrls, cxButtons,
  System.Generics.Collections, System.Generics.Defaults,  Vcl.ExtCtrls,
  Common.ResourceStrings,
  Common.Images,
  Dialog.DB,
  ManagerEditor.Common,
  StaticDialog.MiceInputBox,
  CustomControl.Interfaces;

type
 TWindowManager = class
 strict private
    FWindowList:TList<TCommonManagerDialog>;
    procedure CheckIType(iType:Integer);
    procedure OnFormClose(Sender: TObject;   var Action: TCloseAction);
    procedure InternalEditItem(const iType,ObjectId, AppMainTreeId, ImageIndex: Integer; const ParentId, OwnerObjectId:Variant; Flags:Integer; CloseEvent:TNotifyEvent; DBName:string);
    procedure InternalNewItem(const iType, ParentId, OwnerObjectId, ImageIndex, Flags: Integer;CloseEvent:TNotifyEvent; DBName:string);
    procedure ProcessEditorFlags(Editor:TCommonManagerDialog; Flags:Integer);
    function ProcessInputBox(iType:Integer; var s:string ):Boolean;
    function FindNewEditor(iType:Integer):TCommonManagerDialog;
    function InternalCreateEditor(const iType,ObjectId,AppMainTreeId, ImageIndex :Integer; const ParentId, OwnerObjectId:Variant):TCommonManagerDialog;
    function FindEditor(ObjectId, AppMainTreeId, iType:Integer):TCommonManagerDialog;
    //procedure UpdateMainTree(Dlg:TCommonManagerDialog);

 public

    function FindOrCreateNewEditor(const iType, ParentId, OwnerObjectId, ImageIndex:Integer):TCommonManagerDialog;
    function FindOrCreateEditor(const iType,ObjectId, AppMainTreeId, ImageIndex: Integer; const ParentId, OwnerObjectId:Variant):TCommonManagerDialog;
    procedure ShowEditor(Editor:TCommonManagerDialog; ID:Integer; const PageName:string = '');

    class procedure RegisterEditor(iType:Integer; NewDocClass:TMiceInputBoxClass; EditorClass:TCommonManagerDialogClass; CanEditMultiplyIDs:Boolean);
    procedure EditItem(const iType,ObjectId, AppMainTreeId, ImageIndex: Integer; const ParentId, OwnerObjectId:Variant;CloseEvent:TNotifyEvent; DBName:string);
    procedure EditCommonItem(const iType,ObjectId, AppMainTreeId, ImageIndex: Integer; const ParentId, OwnerObjectId:Variant;CloseEvent:TNotifyEvent);
    procedure NewItem(const iType, ParentId, OwnerObjectId, ImageIndex: Integer; CloseEvent:TNotifyEvent; DBName:string);
    procedure NewCommonItem(const iType, ParentId, OwnerObjectId, ImageIndex: Integer;CloseEvent:TNotifyEvent);
    constructor Create;
    destructor Destroy; override;
 end;

 const
  iTypeTableOnly       =-9;
  iTypeViewOnly        =-8;
  iTypeSequence        =-7;
  iTypeControlColumns  =-6;
  iTypePluginColumms   =-5;
  iTypeAllSQLObjects   =-4;
  iTypeTableOrViews    =-3;
  iTypeStoredProc      =-2;
  iTypeAppColumnsID    =-1;

  iTypeFolder          = 0;
  iTypePlugin          = 1;
  iTypeDialog          = 2;
  iTypeAppDialogLayout = 3;
  iTypeCommonCommand   = 6;
  iTypeCommand         = 7;
  iTypeCommonFilter    = 8;
  iTypeFilter          = 9;
  iTypeCommandGroup    = 10;
  iTypeSQLScript       = 11;
  iTypePascalScript    = 12;
  iTypeCSharpScript    = 13;
  iTypeJsonText        = 14;
  iTypeXMLText         = 15;
  iTypeAppDataSet      = 16;
  iTypeExternalFile    = 17;
  iTypeAppTemplate     = 18;
  iTypeDfClass         = 19;
  iTypeDfTypes         = 20;
  iTypeDfScheme        = 21;
  iTypeDfMethod        = 22;
  iTypeDfPathFolder    = 23;
  iTypeDfRule          = 24;
  iTypeDfAction        = 25;
  iTypeAppReport       = 26;

const
 ColIndex_AppMainTreeId = 0;
 ColIndex_ParentId = 1;
 ColIndex_Caption = 3;
 ColIndex_ObjectId = 4;
 ColIndex_iType = 5;
 ColIndex_DbName = 7;


implementation

type
 TDocumentEditors = class
  strict private
    FEditorClass: TCommonManagerDialogClass;
    FNewDocumentClass: TMiceInputBoxClass;
    FCanEditMultiplyIDs: Boolean;
  public
    property NewDocumentClass:TMiceInputBoxClass read FNewDocumentClass write FNewDocumentClass;
    property EditorClass:TCommonManagerDialogClass read FEditorClass write FEditorClass;
    property CanEditMultiplyIDs:Boolean read FCanEditMultiplyIDs write FCanEditMultiplyIDs;
 end;

var
  FEditorsList:TObjectDictionary<Integer,TDocumentEditors>;

{ TEditManager }

procedure TWindowManager.CheckIType(iType:integer);
resourcestring
  S_NO_EDITOR_REGISTERED = 'No editor registered for iType=%d';
begin
 if not FEditorsList.ContainsKey(iType) then
  raise Exception.CreateFmt(S_NO_EDITOR_REGISTERED, [iType]);
end;

constructor TWindowManager.Create;
begin
  inherited Create;
  FWindowList:=TList<TCommonManagerDialog>.Create;
end;

function TWindowManager.InternalCreateEditor(const iType, ObjectId, AppMainTreeId, ImageIndex:Integer; const ParentId, OwnerObjectId:Variant): TCommonManagerDialog;
begin
 Result:=FEditorsList[iType].EditorClass.Create(Application);
 FWindowList.Add(Result);
// Result.ParentWindow:=0;
 Result.ID:=ObjectId;
 Result.AppMainTreeId:=AppMainTreeId;
 Result.ParentId:=ParentId;
 Result.ImageIndex:=ImageIndex;
 Result.OwnerObjectId:=OwnerObjectId;
 Result.OnClose:=OnFormClose;
 Result.LoadState(True, Result.Sizeable);
end;


function TWindowManager.FindOrCreateNewEditor(const iType, ParentId,  OwnerObjectId, ImageIndex: Integer): TCommonManagerDialog;
begin
CheckIType(iType);
Result:=FindNewEditor(iType);
if not Assigned(Result) then
   Result:=InternalCreateEditor(iType,-1,-1,ImageIndex, ParentId, OwnerObjectId);

Result.ParentId:=ParentId;
Result.OwnerObjectId:=OwnerObjectId;
end;

destructor TWindowManager.Destroy;
begin
  FWindowList.Free;
  inherited;
end;

procedure TWindowManager.InternalEditItem(const iType, ObjectId,  AppMainTreeId, ImageIndex: Integer; const ParentId, OwnerObjectId:Variant; Flags:Integer; CloseEvent:TNotifyEvent; DBName:string);
var
 Editor:TCommonManagerDialog;
begin
 Editor:=FindEditor(ObjectId,AppMainTreeId, iType);
 if not Assigned(Editor) then
  begin
   Editor:=InternalCreateEditor(iType, ObjectId, AppMainTreeId, ImageIndex, ParentId, OwnerObjectId);
   try
    Editor.CloseEvent:=CloseEvent;
    Editor.DBName:=DBName;
    ProcessEditorFlags(Editor,Flags);
    Editor.Initialize;
   except
    FWindowList.Remove(Editor);
    Editor.Free;
    raise;
   end;
  end;

 if Editor.CanEditMultiplyIDs then
  Editor.EditID(ObjectId,'');

 Editor.Show;
end;



procedure TWindowManager.InternalNewItem(const iType, ParentId, OwnerObjectId, ImageIndex, Flags: Integer;CloseEvent:TNotifyEvent; DBName:string);
var
 Editor:TCommonManagerDialog;
 s:string;
begin
 s:='';
if ProcessInputBox(iType,s) then
 begin
  Editor:=FindNewEditor(iType);
   if not Assigned(Editor) then
    begin
     Editor:=InternalCreateEditor(iType,-1,-1,ImageIndex, ParentId, OwnerObjectId);
     Editor.DBName:=DBName;
     Editor.CloseEvent:=CloseEvent;
     Editor.SetParameter('InputString', s);
     ProcessEditorFlags(Editor,Flags);
     Editor.Initialize;
    end;
  if Editor.CanEditMultiplyIDs then
   Editor.EditID(-1,s);
  Editor.Show;
 end;
end;

procedure TWindowManager.EditCommonItem(const iType, ObjectId, AppMainTreeId,  ImageIndex: Integer; const ParentId, OwnerObjectId: Variant;CloseEvent:TNotifyEvent);
begin
  CheckIType(iType);
  InternalEditItem(iType, ObjectId, AppMainTreeId, ImageIndex, ParentId, OwnerObjectId, 1, CloseEvent, '');
end;

procedure TWindowManager.EditItem(const iType, ObjectId, AppMainTreeId, ImageIndex: Integer; const ParentId, OwnerObjectId:Variant;CloseEvent:TNotifyEvent; DBName:string);
begin
  CheckIType(iType);
  InternalEditItem(iType, ObjectId, AppMainTreeId, ImageIndex, ParentId, OwnerObjectId, 0, CloseEvent, DBName)
end;


function TWindowManager.FindEditor(ObjectId, AppMainTreeId, iType: Integer): TCommonManagerDialog;
var
 Editor: TCommonManagerDialog;
begin
CheckIType(iType);
Result:=nil;
 for Editor in FWindowList do
  if ((Editor.ID=ObjectId) and (Editor.AppMainTreeId=AppMainTreeId))
  or ((Editor.iType=iType) and (Editor.CanEditMultiplyIDs=True))
  or ((Editor.iType in [iTypeCommonCommand, iTypeCommonFilter]) and (Editor.ID=ObjectId)) then
     Exit(Editor);
end;

function TWindowManager.FindNewEditor(iType: Integer): TCommonManagerDialog;
var
 Editor:TCommonManagerDialog;
begin
Result:=nil;
 for Editor in FWindowList do
  if (Editor.iType=iType) then
   Exit(Editor);
end;

function TWindowManager.FindOrCreateEditor(const iType, ObjectId,  AppMainTreeId, ImageIndex: Integer; const ParentId,  OwnerObjectId: Variant): TCommonManagerDialog;
begin
CheckiType(iType);
Result:=FindEditor(ObjectId,AppMainTreeId, iType);
 if not Assigned(Result) then
   Result:=InternalCreateEditor(iType, ObjectId, AppMainTreeId, ImageIndex, ParentId, OwnerObjectId);

Result.ParentId:=ParentId;
Result.OwnerObjectId:=OwnerObjectId;
Result.AppMainTreeId:=AppMainTreeId;
Result.ImageIndex:=ImageIndex;
end;


procedure TWindowManager.NewCommonItem(const iType, ParentId, OwnerObjectId,  ImageIndex: Integer;CloseEvent:TNotifyEvent);
begin
  CheckIType(iType);
  InternalNewItem(iType, ParentId, OwnerObjectId, ImageIndex,1, CloseEvent,'');
end;

procedure TWindowManager.NewItem(const iType, ParentId, OwnerObjectId, ImageIndex: Integer;CloseEvent:TNotifyEvent; DBName:string);
begin
  CheckIType(iType);
  InternalNewItem(iType, ParentId, OwnerObjectId, ImageIndex,0, CloseEvent, DBName);
end;

procedure TWindowManager.OnFormClose(Sender: TObject; var Action: TCloseAction);
var
 Dlg:TCommonManagerDialog;
begin
Dlg:=Sender as TCommonManagerDialog;
if (Dlg.ReadOnly) or (Dlg.CanEditMultiplyIDs) then
 Dlg.SaveState;

if (Dlg.ModalResult=mrOK) then
  try
   Action:=TCloseAction.caNone;  //Не закрываем окно, пока не сохраним.
   Dlg.SaveChanges;
   Dlg.DoCloseEvent;
   Dlg.SaveState;
   FWindowList.Remove(Dlg);
   Action:=TCloseAction.caFree;
   except on E:Exception do
    MessageBox(Application.Handle,PChar(E.Message), PChar(S_COMMON_ERROR), MB_OK + MB_ICONSTOP);
   end
   else
    begin
     FWindowList.Remove(Dlg);
     Action:=TCloseAction.caFree;
    end;
end;



procedure TWindowManager.ProcessEditorFlags(Editor: TCommonManagerDialog;  Flags: Integer);
begin
 case Flags of
  1:Editor.ReadOnly:=False;
 end;

end;

function TWindowManager.ProcessInputBox(iType: Integer; var s:string):Boolean;
var
 Dlg:TMiceInputBoxClass;
begin
 Dlg:=FEditorsList[iType].NewDocumentClass;
 Result:=not Assigned(Dlg) or Dlg.Execute(IMAGEINDEX_ITYPE_SCRIPT_CSHARP, s);
end;

class procedure TWindowManager.RegisterEditor(iType: Integer;  NewDocClass:TMiceInputBoxClass; EditorClass: TCommonManagerDialogClass; CanEditMultiplyIDs:Boolean);
resourcestring
  S_EDITOR_ALREADY_REGISTERED = 'Cannot register %s. Editor already registered for iType=%d';
var
 Editor:TDocumentEditors;
begin
 if not Assigned(FEditorsList) then //Лучше делать здесь, что бы не было AV в initialization
  FEditorsList:=TObjectDictionary<Integer,TDocumentEditors>.Create([doOwnsValues]);

if not FEditorsList.ContainsKey(iType) then
 begin
  Editor:=TDocumentEditors.Create;
  Editor.NewDocumentClass:=NewDocClass;
  Editor.EditorClass:=EditorClass;
  Editor.CanEditMultiplyIDs:=CanEditMultiplyIDs;
  FEditorsList.Add(iType, Editor)
 end
   else
  MessageBox(Application.Handle, PChar(Format(S_EDITOR_ALREADY_REGISTERED,[EditorClass.ClassName, iType])), PChar(S_COMMON_ERROR), MB_OK+MB_ICONERROR);
end;


procedure TWindowManager.ShowEditor(Editor: TCommonManagerDialog; ID:Integer; const PageName:string = '');
begin
 try
  Editor.Initialize;
 except
  FWindowList.Remove(Editor);
  raise;
 end;

 if Editor.CanEditMultiplyIDs then
   Editor.EditID(ID ,PageName);
  Editor.Show;
end;


initialization


finalization
  FEditorsList.Free;
end.
