unit CustomControl.MiceSyntaxEdit;

interface
 uses System.SysUtils, System.Classes, Data.DB, Vcl.Controls, WinApi.Windows, Vcl.Menus,
      TextEditor,
      CustomControl.MiceSyntaxEdit.SyntaxStorage,
      Common.StringUtils,
      CustomControl.Interfaces,
      Dialogs;

type
 TMiceSyntaxEdit = class (TDBTextEditor)
  private
    FSyntax: string;
    FDBName: string;
    FBevelOuter: TBevelCut;
    FBevelInner: TBevelCut;
    FBevelKind: TBevelKind;
    FFindDlg:TFindDialog;
    procedure SetSyntax(const Value: string);
    procedure OnFindExecute(Sender:TObject);
    function GetFindDialog: TFindDialog;
    procedure LoadColors(const s:string);
  protected
    procedure LoadSyntax(Syntax:TBCEditorSyntaxItem);
    procedure ExecuteSearchDialog;
    procedure KeyDown(var AKey: Word; AShift: TShiftState); override;
  public
    function FindTextLineIndex(const s:string):Integer;
    procedure FocusLine(LineNumber:Integer);
  published
    constructor Create(AOwner:TComponent); override;
    property Syntax:string read FSyntax write SetSyntax;
    property DBName:string read FDBName write FDBName;
    property BevelInner: TBevelCut index 0 read FBevelInner write FBevelInner default bvRaised;
    property BevelOuter: TBevelCut index 1 read FBevelOuter write FBevelOuter default bvLowered;
    property BevelKind: TBevelKind read FBevelKind write FBevelKind default bkNone;


 end;
implementation

{ TMiceSyntaxEdit }


constructor TMiceSyntaxEdit.Create(AOwner: TComponent);
begin
  inherited;
  CodeFolding.Visible:=True;
  Self.RightMargin.Position:=120;
//  CompletionProposal.Active:=True;
//  CompletionProposal.ShortCut:=TextToShortCut('.');
end;


procedure TMiceSyntaxEdit.ExecuteSearchDialog;
begin
 GetFindDialog.Execute(Handle);
end;

function TMiceSyntaxEdit.FindTextLineIndex(const s: string): Integer;
var
 x:Integer;
begin
 for x:=0 to Lines.Count-1 do
  if Pos(AnsiLowerCase(s),AnsiLowerCase(Lines[x]))>0 then
   Exit(x);
Result:=-1;
end;

procedure TMiceSyntaxEdit.FocusLine(LineNumber: Integer);
var
 i,iStart : Integer;
 iLength  : Integer;
Begin
if LineNumber=Lines.Count then
begin
  iStart:=Length(Text);
  iLength:=0;
end
else
begin
  iLength:=Length(Lines[LineNumber]);
  Dec(LineNumber);
  iStart:=0;
  for I:=0 to LineNumber do
   Inc(iStart,Length(Lines[I]));
end;
 SelectionStart:=iStart;
 SelectionLength:=iLength;
end;

function TMiceSyntaxEdit.GetFindDialog: TFindDialog;
begin
if not Assigned(FFindDlg) then
  begin
   FFindDlg:=TFindDialog.Create(Self);
   FFindDlg.OnFind:=OnFindExecute;
   FFindDlg.Options:=[frDown, frHideWholeWord, frDisableMatchCase];
  end;
 Result:=FFindDlg;
end;

procedure TMiceSyntaxEdit.KeyDown(var AKey: Word; AShift: TShiftState);
begin
  inherited;
{
  if AKey=Ord('.') then
   DoExecuteCompletionProposal;
 }
  if AKey=VK_ESCAPE then
   Search.SearchText:=''
   else
  if (ssCtrl in AShift) and (AKey=Ord('F')) then
   ExecuteSearchDialog;
end;

procedure TMiceSyntaxEdit.LoadColors(const s: string);
var
 Stream:TStringStream;
begin
  Stream:=TStringStream.Create(s);
  try
   Highlighter.Colors.LoadFromStream(Stream);
  finally
    Stream.Free;
  end;
end;

procedure TMiceSyntaxEdit.LoadSyntax(Syntax: TBCEditorSyntaxItem);
begin
 Highlighter.JSON.Text:=Syntax.Syntax;
 Highlighter.LoadFromJson;
 CompletionProposal.Active:=Syntax.CompletionProposalActive;
 if CompletionProposal.Active then
  begin
   CompletionProposal.Trigger.Active:=True;
   CompletionProposal.Trigger.Chars:='.';
  end;

 LoadColors(Syntax.Color)
end;

procedure TMiceSyntaxEdit.OnFindExecute(Sender: TObject);
begin
 if Search.SearchText<>FFindDlg.FindText then
   Search.SearchText:=FFindDlg.FindText
   else
    begin
     if (frDown in FFindDlg.Options) then
      FindNext
       else
      FindPrevious;
    end;
end;

procedure TMiceSyntaxEdit.SetSyntax(const Value: string);
begin
 if FSyntax<>Value then
  begin
    LoadSyntax(TBCEditorSyntaxStorage.GetSyntax(Value));
    FSyntax:=Value;
  end;
end;


end.
