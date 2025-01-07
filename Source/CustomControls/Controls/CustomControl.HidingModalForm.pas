unit CustomControl.HidingModalForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs;

type


  THidingModalForm = class(TForm)
  private
     FTopOffset: Integer;
     FLeftOffset: Integer;
     procedure HookControl;
     procedure UnhookControl;
  protected
     procedure DoShow; override;
     procedure DoClose(var Action: TCloseAction); override;
     procedure Activate; override;
     procedure Deactivate; override;
  public
     constructor Create(AOwner:TComponent);override;
  published
     property TopOffset:Integer read FTopOffset write FTopOffset;
     property LeftOffset:Integer read FLeftOffset write FLeftOffset;
  end;

implementation


{$R *.dfm}

var
  PrevMouseHook: HHook = 0;
  PrevWndHook  : HHook = 0;
  FForm : THidingModalForm;

function MouseHookProc(Code: Integer; wParam: Word; lParam: Longint): Longint; stdcall;
var
  pt: TPoint;
begin
  Result := CallNextHookEx(PrevMouseHook, Code, wParam, lParam);
  if (Code >= 0) and Assigned(FForm) and FForm.Active then
    case wParam of
      WM_LBUTTONDOWN, WM_RBUTTONDOWN, WM_LBUTTONDBLCLK, WM_RBUTTONDBLCLK,
      WM_MBUTTONDOWN, WM_MBUTTONDBLCLK,
      WM_NCLBUTTONDOWN, WM_NCLBUTTONDBLCLK, WM_NCRBUTTONDOWN, WM_NCRBUTTONDBLCLK,
      WM_NCMBUTTONDOWN, WM_NCMBUTTONDBLCLK:
       begin
        pt := FForm.ScreenToClient(PMOUSEHOOKSTRUCT(lParam)^.pt);
        if not PtInRect(FForm.ClientRect, pt) then
         begin
          FForm.Close;
          Result := 1;
         end;
        end;
    end;
end;


function GMHookProc(code: Integer; wParam: Word; lParam: Longint): Longint; stdcall;
begin
  Result := CallNextHookEx(PrevWndHook, Code, wParam, lParam);
  if (Code >= 0) and Assigned(FForm) then
    case PMsg(lParam)^.Message of
      // WM_SYSKEYDOWN,
      CM_DEACTIVATE: FForm.Close;
    end;
end;


{ THidingModalForm }

procedure THidingModalForm.Activate;
begin
  inherited;
  HookControl;
end;

constructor THidingModalForm.Create(AOwner:TComponent);
resourcestring
  S_ONLY_ONE_FORM_ALLOWED = 'Only one form allowed :(';
begin
//  if Assigned(FForm) then
   //raise Exception.Create(S_ONLY_ONE_FORM_ALLOWED);
  inherited Create(AOwner);
 // FForm:=Self;
end;

procedure THidingModalForm.Deactivate;
begin
  inherited;
  UnhookControl;
end;

procedure THidingModalForm.DoClose(var Action: TCloseAction);
begin
  inherited;
  UnhookControl;
end;

procedure THidingModalForm.DoShow;
var
 Control:TControl;
begin
  inherited;
  if Assigned(Owner) and (Owner is TControl) then
   begin
    Control:=Owner as TControl;
    SetBounds(Control.Left+LeftOffset,Control.Top+TopOffset, Width, Screen.WorkAreaHeight-Control.Top-TopOffset);
   end;
end;

procedure THidingModalForm.HookControl;
begin
  FForm:=Self;
  PrevMouseHook := SetWindowsHookEx(WH_MOUSE, @MouseHookProc, hInstance, GetCurrentThreadID);
  PrevWndHook   := SetWindowsHookEx(WH_GETMESSAGE, @GMHookProc, hInstance, GetCurrentThreadID);
end;


procedure THidingModalForm.UnhookControl;
begin
  if PrevMouseHook <> 0 then
   UnhookWindowsHookEx(PrevMouseHook);
  if PrevWndHook <> 0 then
   UnhookWindowsHookEx(PrevWndHook);

  PrevMouseHook := 0;
  PrevWndHook   := 0;
end;


end.
