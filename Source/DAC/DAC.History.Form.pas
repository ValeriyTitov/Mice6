unit DAC.History.Form;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, DAC.History, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, cxCustomData, cxStyles, cxTL,
  cxTextEdit, cxTLdxBarBuiltInMenu, cxInplaceContainer, dxStatusBar,
  System.UITypes,
  DAC.ObjectModels.DataSetMessage,
  Vcl.Menus, ClipBrd, cxDataControllerConditionalFormattingRulesManagerDialog;

//  Common.Images;

type
  TSQLHistoryForm = class(TForm)
    HistoryList: TcxTreeList;
    colDBName: TcxTreeListColumn;
    colSQL: TcxTreeListColumn;
    colEntry: TcxTreeListColumn;
    colTime: TcxTreeListColumn;
    colRowCount: TcxTreeListColumn;
    colSource: TcxTreeListColumn;
    colInfo: TcxTreeListColumn;
    StatusBar: TdxStatusBar;
    colStatus: TcxTreeListColumn;
    PopupMenu: TPopupMenu;
    Clearhistory1: TMenuItem;
    colAddedOn: TcxTreeListColumn;
    Copy1: TMenuItem;
    procedure HistoryListCustomDrawDataCell(Sender: TcxCustomTreeList;
      ACanvas: TcxCanvas; AViewInfo: TcxTreeListEditCellViewInfo;
      var ADone: Boolean);
    procedure HistoryListSelectionChanged(Sender: TObject);
    procedure Clearhistory1Click(Sender: TObject);
    procedure Copy1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    FHadChilds:Boolean;
    procedure CreateEntry(Entry:TSQLHistoryEntry);
    procedure AddChilds(Node: TcxTreeListNode; Entry:TSQLHistoryEntry);
  public
   procedure Fill;
   class procedure ShowHistory;
  end;


implementation

{$R *.dfm}

{ TSQLHistoryForm }


procedure TSQLHistoryForm.AddChilds(Node: TcxTreeListNode; Entry: TSQLHistoryEntry);
var
 Msg:TMiceDataSetMessage;
 Child: TcxTreeListNode;
resourcestring
 S_LINE_NUMBER_FMT = 'Line number: %d';
 S_CODE_FMT = 'Code: %d';
begin
 FHadChilds:=True;
 for Msg in Entry.Messages do
  begin
   Child:=Node.AddChild;
//   Child.Values[0]:=Entry.DBName;
//   Child.Values[1]:=TimeToStr(Entry.DateTimeAdded);
   Child.Values[2]:=Msg.AMessage;
   Child.Values[3]:=Format(S_LINE_NUMBER_FMT,[Msg.LineNumber]);
//   Child.Values[4]:=Entry.TimeToComplete;
//   Child.Values[5]:=Entry.RecordCount;
   Child.Values[6]:=Ord(etDataSetMessage);
   Child.Values[7]:=Format(S_CODE_FMT,[Msg.Code]);
   Child.Values[8]:=S_etDataSetMessage;
  end;
end;

procedure TSQLHistoryForm.Clearhistory1Click(Sender: TObject);
begin
 TSQLExecutionHistory.Clear;
 HistoryList.Clear;
end;

procedure TSQLHistoryForm.Copy1Click(Sender: TObject);
begin
 if Assigned(HistoryList.FocusedNode) then
  ClipBoard.AsText:=VarToStr(HistoryList.FocusedNode.Values[2]);
end;

procedure TSQLHistoryForm.CreateEntry(Entry:TSQLHistoryEntry);
var
  Node: TcxTreeListNode;
begin
 Node:=HistoryList.Add;
 Node.Values[0]:=Entry.DBName;
 Node.Values[1]:=TimeToStr(Entry.DateTimeAdded);
 Node.Values[2]:=Entry.Command;
 Node.Values[3]:=Entry.Source;
 Node.Values[4]:=Entry.TimeToComplete;
 Node.Values[5]:=Entry.RecordCount;
 Node.Values[6]:=Entry.Status;
 Node.Values[7]:=Entry.Info;
 Node.Values[8]:=Entry.ToString;
 if Assigned(Entry.Messages) then
   AddChilds(Node, Entry);
end;

procedure TSQLHistoryForm.Fill;
var
 x:integer;
begin
 try
  TSQLExecutionHistory.EnterSection;
   for x:=TSQLExecutionHistory.HistoryList.Count-1 downto 0 do
    CreateEntry(TSQLExecutionHistory.HistoryList[x]);
  if FHadChilds then
   HistoryList.OptionsView.TreeLineStyle:=tllsDot
    else
   HistoryList.OptionsView.TreeLineStyle:=tllsNone;
 finally
  TSQLExecutionHistory.LeaveSection;
 end;
end;

procedure TSQLHistoryForm.FormCreate(Sender: TObject);
begin
 FHadChilds:=False;
end;

procedure TSQLHistoryForm.HistoryListCustomDrawDataCell(Sender: TcxCustomTreeList; ACanvas: TcxCanvas;  AViewInfo: TcxTreeListEditCellViewInfo; var ADone: Boolean);
var
 Status :TCommandStatus;
begin
if AViewInfo.Selected then
 ACanvas.Brush.Color:=($CFCFCF);

  Status:=AViewInfo.Node.Values[6];
   case Status of
    etUnknown, etError, etCanceled: begin ACanvas.Font.Color:=clRed; ACanvas.Font.Style:=[fsBold] end;
    etCanceling: ACanvas.Font.Color:=clRed;
    etJustCreated, etRunning:ACanvas.Font.Color:=clSkyBlue;
    etDirectQuery:ACanvas.Font.Color:=clRed;
    etJustLocallyCached:ACanvas.Font.Color:=clBlack;
    etLoadedFromLocalCache: ACanvas.Font.Color:=clGreen;
    etJustAppServerCached: ACanvas.Font.Color:=clBlack;
    etAppServerCache : ACanvas.Font.Color:=clGreen;
    etDataScript : ACanvas.Font.Color:=clBlue;
   end;
end;

procedure TSQLHistoryForm.HistoryListSelectionChanged(Sender: TObject);
var
 ANode:TcxTreeListNode;
resourcestring
 S_SQLHISTORYFORM_SOURCE='Source: %s';

begin
 ANode:=Self.HistoryList.FocusedNode;
 if Assigned(ANode) then
  begin
   StatusBar.Panels[1].Text:=VarToStr(ANode.Values[7]);
   StatusBar.Panels[0].Text:=Format(S_SQLHISTORYFORM_SOURCE,[VarToStr(ANode.Values[3])]);
  end;
end;

class procedure TSQLHistoryForm.ShowHistory;
var
 Form:TSQLHistoryForm;
begin
 Form:=TSQLHistoryForm.Create(nil);
 try
  Form.Fill;
  Form.ShowModal;
 finally
   Form.Free;
 end;

end;

end.
