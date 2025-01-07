unit Dialog.Basic;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, cxGraphics, Vcl.Menus, Vcl.StdCtrls, cxButtons,
  cxLookAndFeels, cxLookAndFeelPainters, WinApi.ShellApi,
  Common.ResourceStrings,
  Common.Registry,
  Common.LookAndFeel;

type
  TOnDragAndDropFilesEvent = procedure(Sender:TObject; List:TStrings) of object;

  TBasicDialog = class(TForm)
    pnBottomButtons: TPanel;
    bnOK: TcxButton;
    bnCancel: TcxButton;
  private
    FReadOnly: Boolean;
    FSizeable: Boolean;
    FDragAndDropFiles: Boolean;
    FOnDragAndDropFiles: TOnDragAndDropFilesEvent;
    procedure SetSizeable(const Value: boolean);
    procedure SetDragAndDropFiles(const Value: Boolean);
    procedure WMDropFiles(var Msg: TWMDropFiles); message WM_DROPFILES;
  protected
    function DialogSaveName:string; virtual;
    procedure SetReadOnly(const Value: Boolean);
    procedure SetReadOnlyState;virtual;
    procedure SetEditingState;virtual;
    procedure UpdateReadOnlyState;virtual;
  public
    procedure SaveState; virtual;
    procedure LoadState(LoadPosition, LoadSize:Boolean);virtual;
    constructor Create(AOwner:TComponent); override;
    destructor Destroy; override;
    function Execute:Boolean; virtual;
  published
    property ReadOnly: Boolean read FReadOnly write SetReadOnly;
    property Sizeable:Boolean read FSizeable write SetSizeable;
    property DragAndDropFiles:Boolean read FDragAndDropFiles write SetDragAndDropFiles;
    property OnDragAndDropFiles:TOnDragAndDropFilesEvent read FOnDragAndDropFiles write FOnDragAndDropFiles;
  end;


implementation

{$R *.dfm}

{ TBasicModalDialog }

constructor TBasicDialog.Create(AOwner: TComponent);
begin
  inherited;
  bnCancel.Caption:=S_COMMON_CANCEL;
  Color:=DefaultLookAndFeel.WindowColor;
  FDragAndDropFiles:=False;
end;


destructor TBasicDialog.Destroy;
begin
 if DragAndDropFiles then
   DragAcceptFiles(Handle, False);
  inherited;
end;

function TBasicDialog.DialogSaveName: string;
begin
 if Name='' then
  Result:=ClassName
   else
  Result:=Name;
end;

function TBasicDialog.Execute: Boolean;
begin
 Result:=ShowModal=mrOK;
end;

procedure TBasicDialog.LoadState(LoadPosition, LoadSize: Boolean);
begin
 TProjectRegistry.DefaultInstance.LoadForm(DialogSaveName,LoadPosition,LoadSize,Self);
end;

procedure TBasicDialog.SaveState;
begin
 TProjectRegistry.DefaultInstance.SaveForm(DialogSaveName,Self);
end;

procedure TBasicDialog.SetDragAndDropFiles(const Value: Boolean);
begin
if (FDragAndDropFiles<>Value) then
 begin
  FDragAndDropFiles := Value;
  DragAcceptFiles(Handle, Value)
 end;
end;

procedure TBasicDialog.SetEditingState;
begin
 bnOK.Visible:=True;
 bnCancel.Caption:=S_COMMON_CANCEL;
end;


procedure TBasicDialog.SetReadOnlyState;
begin
 bnOK.Visible:=False;
 bnCancel.Caption:=S_COMMON_CLOSE;
end;


procedure TBasicDialog.SetSizeable(const Value: Boolean);
begin
 FSizeable := Value;
  if Value then
   BorderStyle:=bsSizeable
    else
   BorderStyle:=bsDialog;
end;

procedure TBasicDialog.SetReadOnly(const Value: Boolean);
begin
 FReadOnly := Value;
 UpdateReadOnlyState;
end;


procedure TBasicDialog.UpdateReadOnlyState;
begin
if FReadOnly then
  SetReadOnlyState
   else
  SetEditingState;
end;

procedure TBasicDialog.WMDropFiles(var Msg: TWMDropFiles);
var
  DropH: HDROP;
  Count: Integer;
  FileNameLength: Integer;
  FileName: string;
  x: Integer;
  DropPoint: TPoint;
  List:TStringList;
begin
  inherited;
  DropH := Msg.Drop;
  List:=TStringList.Create;
  try
    Count := DragQueryFile(DropH, $FFFFFFFF, nil, 0);
     for x := 0 to Count-1 do
      begin
        FileNameLength := DragQueryFile(DropH, x, nil, 0);
        SetLength(FileName, FileNameLength);
        DragQueryFile(DropH, x, PChar(FileName), FileNameLength + 1);
        List.Add(FileName)
      end;
    if Assigned(OnDragAndDropFiles) then
     OnDragAndDropFiles(Self, List);
    DragQueryPoint(DropH, DropPoint);
  finally
    List.Free;
    DragFinish(DropH);
  end;
  Msg.Result := 0;
end;

end.
