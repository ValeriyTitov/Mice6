unit CustomControl.AutoCompleteTextEdit;

interface

uses SysUtils, Windows, Messages, Classes, Controls, StdCtrls, cxTextEdit,
     cxDBEdit, ExtCtrls, CustomControl.AutoCompleteDropDown, cxMaskEdit, Data.DB;


type
  TAutoCompleteType = (actOff, actFixed, actDynamic);

  TAutoComleteTextEdit = class(TcxDBMaskEdit, IHaveDropDown)
  private
    FDropped: Boolean;
    FApplyingText:Boolean;
    FItems: TStringList;
    FMaxDropDownItems: Integer;
    FOnDelayedChange: TNotifyEvent;
    FTimer:TTimer;
    FLastTick:Int64;
    FDelayChangeInterval: Word;
    FAutoCompleteType: TAutoCompleteType;
    procedure InternalShowDropDown(Count:Integer);
    procedure InternalCreateTimer;
    procedure SetAutoCompleteType(const Value: TAutoCompleteType);
  protected
    FDropDown: TDropDownListBox;
    procedure PopulateFixedList;
    procedure PopulateDynamicList(const AText:string; Items:TStrings); virtual;
    procedure TryHandleUserInput;
    procedure WMMouseWheel(var M: TWMMouseWheel); message WM_MOUSEWHEEL;
    procedure CMExit(var M: TCMExit); message CM_EXIT;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure KeyPress(var Key: Char); override;
    procedure SendKeyToDropDown(var Key:Word);
    procedure DoChange; override;
    procedure DoOnDelayedChange; virtual;
    procedure HandleTimer(Sender:TObject);
    procedure ClearDropDown;
    procedure DoApplyText(DropDownItems:TStrings;ItemIndex:Integer); virtual;
    function GetInnerEditClass: TControlClass;override;
    function AllowedToShow:Boolean;
    function Editable:Boolean;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure ShowDropDown;
    procedure HideDropDown(ApplyText:Boolean);
    property Dropped:Boolean read FDropped;
  published
    property AutoCompleteType:TAutoCompleteType read FAutoCompleteType write SetAutoCompleteType;
    property Items: TStringList read FItems;
    property DelayChangeInterval:Word read FDelayChangeInterval write FDelayChangeInterval;
    property MaxDropDownItems:Integer read FMaxDropDownItems write FMaxDropDownItems;
    property OnDelayedChange:TNotifyEvent read FOnDelayedChange write FOnDelayedChange;
  end;


implementation

type
 TInterceptKeyTextEdit = class(TcxCustomInnerTextEdit) //Для перехвата ENTER в модальном окне с TButton.Defualt:=True
  private
    procedure CNKeyDown(var Message: TWMKeyDown); message CN_KEYDOWN;
    function OwnerHasDropDownOpened:Boolean;
 end;

{ TInterceptKeyTextEdit }
procedure TInterceptKeyTextEdit.CNKeyDown(var Message: TWMKeyDown);
begin
  if OwnerHasDropDownOpened=False then
   inherited;
end;

function TInterceptKeyTextEdit.OwnerHasDropDownOpened: Boolean;
begin
 Result:=(Owner is TAutoComleteTextEdit) and (Owner as TAutoComleteTextEdit).Dropped=True;
end;

{ TAutoCompleteTextEdit }

constructor TAutoComleteTextEdit.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FDropDown:=TDropDownListBox.Create(Self);
  FItems:=TStringList.Create;
  DelayChangeInterval:=750;
  FDropped:=False;
  FApplyingText:=False;
  MaxDropDownItems:=7;
  AutoCompleteType:=actOff;
  Properties.Alignment.Horz:=taLeftJustify;
end;

destructor TAutoComleteTextEdit.Destroy;
begin
 FItems.Free;
 ClearDropDown;
 inherited Destroy;
end;


function TAutoComleteTextEdit.AllowedToShow: Boolean;
begin
 Result:=(AutoCompleteType<>actOff) and (Properties.ReadOnly=False) and (Focused) and Editable;
end;

procedure TAutoComleteTextEdit.DoApplyText(DropDownItems:TStrings;ItemIndex:Integer);
begin
 Text:=DropDownItems[ItemIndex];
end;

procedure TAutoComleteTextEdit.ClearDropDown;
var
 x:Integer;
begin
 for x:=0 to FDropDown.Items.Count-1 do
  FDropDown.Items.Objects[x].Free;

  FDropDown.Items.Clear;
end;

procedure TAutoComleteTextEdit.CMExit(var M: TCMExit);
begin
 inherited;
 HideDropDown(False);
end;

procedure TAutoComleteTextEdit.DoChange;
begin
 inherited DoChange;
 if (FApplyingText=False) then
  begin
   TryHandleUserInput;
   if (AutoCompleteType=actFixed) then
    begin
      ClearDropDown;
      PopulateFixedList;
      ShowDropDown;
    end;
  end;
end;


procedure TAutoComleteTextEdit.DoOnDelayedChange;
begin
 If Assigned(OnDelayedChange) then
  OnDelayedChange(Self);

 if AllowedToShow and (AutoCompleteType=actDynamic) then
  begin
   HideDropDown(False);
   Self.PopulateDynamicList(Self.Text, Self.FDropDown.Items);
   ShowDropDown;
  end;
end;

function TAutoComleteTextEdit.Editable: Boolean;
var
 DataSet:TDataSet;
begin
 DataSet:=Self.DataBinding.DataSource.DataSet;
 Result:=Assigned(DataSet) and (DataSet.State in [dsEdit, dsInsert]) and Assigned(DataBinding.Field) and (DataBinding.Field.ReadOnly=False);
end;

function TAutoComleteTextEdit.GetInnerEditClass: TControlClass;
begin
 Result:=TInterceptKeyTextEdit;
end;

procedure TAutoComleteTextEdit.HandleTimer(Sender: TObject);
begin
 if (GetTickCount >= FLastTick+DelayChangeInterval) then
  begin
   If Assigned(FTimer)then
    FTimer.Enabled:=False;
   DoOnDelayedChange;
  end;
end;

procedure TAutoComleteTextEdit.HideDropDown(ApplyText: Boolean);
var
 x: Integer;
begin
ShowWindow(FDropDown.Handle, SW_HIDE);
if ApplyText then
  begin
  x:=FDropDown.ItemIndex;
  if x<>-1 then
    begin
     FApplyingText:=True;
     DoApplyText(FDropDown.Items, x);
     FApplyingText:=False;
     SelStart:=Length(Text);
     SelLength:=Length(Text);
    end;
  end;
FDropped:=False;
end;

procedure TAutoComleteTextEdit.InternalShowDropDown(Count:Integer);
var
 P:TPoint;
begin
 If Count>MaxDropDownItems then
  Count:=MaxDropDownItems;
  FDropped:=True;
  P.X:=1;
  P.Y:=Height-1;
  P:=ClientToScreen(P);
  SetWindowPos(FDropDown.Handle, HWND_TOPMOST, P.X, P.Y, Width-GetSystemMetrics(SM_CXVSCROLL)-2, Count*FDropDown.ItemHeight+2, SWP_SHOWWINDOW);
end;

procedure TAutoComleteTextEdit.KeyDown(var Key: Word; Shift: TShiftState);
begin
if (FDropped) then
 case Key of
  VK_ESCAPE: HideDropDown(False);
  VK_RETURN: HideDropDown(True);
  VK_UP, VK_DOWN, VK_NEXT, VK_PRIOR: SendKeyToDropDown(Key);
  else
   inherited KeyDown(Key, Shift);
 end
  else
 inherited KeyDown(Key, Shift)
end;

procedure TAutoComleteTextEdit.KeyPress(var Key: Char);
begin
 if ((Ord(Key)=VK_RETURN) or (Ord(Key)=VK_ESCAPE)) then
  Key:=#0;

 inherited KeyPress(Key);
end;

procedure TAutoComleteTextEdit.PopulateDynamicList(const AText: string; Items:TStrings);
begin
 ClearDropDown;
end;

procedure TAutoComleteTextEdit.PopulateFixedList;
var
 x: Integer;
begin
 for x:=0 to FItems.Count-1 do
  If Pos(AnsiLowerCase(Self.Text), AnsiLowerCase(FItems[x]))>0 then
   FDropDown.Items.Add(FItems[x]);
end;


procedure TAutoComleteTextEdit.SendKeyToDropDown(var Key: Word);
var
 M: TWMKeyDown;
begin
  FillChar(M, SizeOf(M), 0);
  M.Msg:=WM_KEYDOWN;
  M.CharCode:=Key;
  SendMessage(FDropDown.Handle, TMessage(M).Msg, TMessage(M).WParam, TMessage(M).LParam);
  FillChar(M, SizeOf(M), 0);
  M.Msg:=WM_KEYUP;
  M.CharCode:=Key;
  SendMessage(FDropDown.Handle, TMessage(M).Msg, TMessage(M).WParam, TMessage(M).LParam);
  Key:=0;
end;

procedure TAutoComleteTextEdit.ShowDropDown;
begin
if not AllowedToShow then
 Exit;

if (Text='') or (FDropDown.Items.Count=0) then
  HideDropDown(False)
   else
  InternalShowDropDown(FDropDown.Items.Count);
end;

procedure TAutoComleteTextEdit.TryHandleUserInput;
begin
 if AllowedToShow then
  begin
   FLastTick:=GetTickCount;
   FTimer.Enabled:=Assigned(OnDelayedChange) or (AutoCompleteType=actDynamic);
  end;
end;

procedure TAutoComleteTextEdit.WMMouseWheel(var M: TWMMouseWheel);
begin
 TMessage(M).Result:=SendMessage(FDropDown.Handle, TMessage(M).Msg, TMessage(M).WParam, TMessage(M).LParam);
 FDropDown.UpdateItemIndex
end;

procedure TAutoComleteTextEdit.InternalCreateTimer;
begin
If not Assigned(FTimer) then
 begin
  FTimer:=TTimer.Create(Self);
  FTimer.OnTimer:=HandleTimer;
  FTimer.Interval:=300;
  FTimer.Enabled:=False;
  FLastTick:=GetTickCount;
 end;
end;

procedure TAutoComleteTextEdit.SetAutoCompleteType(const Value: TAutoCompleteType);
begin
  FAutoCompleteType := Value;
  if Value<>actOff then
   InternalCreateTimer;
end;



end.
