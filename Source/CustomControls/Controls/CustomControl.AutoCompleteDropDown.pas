unit CustomControl.AutoCompleteDropDown;

interface
uses SysUtils, Windows, Messages, Classes, Controls, StdCtrls, Forms;

type
  IHaveDropDown = interface
    ['{DB4435AC-3B5A-4541-9C7E-37A42202CC9C}']
    procedure ShowDropDown;
    procedure HideDropDown(ApplyText:Boolean);
  end;

  TDropDownListBox = class(TListBox)
  protected
    procedure WMActivateApp(var M: TMessage); message WM_ACTIVATEAPP;
    procedure WMMouseMove(var M: TWMMouseMove); message WM_MOUSEMOVE;
    procedure WMLButtonUp(var M: TWMLButtonUp); message WM_LBUTTONUP;
    procedure CreateParams(var Params: TCreateParams); override;
    procedure HideDropDown(ApplyText:Boolean);
  public
    procedure UpdateItemIndex;
  end;

implementation

procedure TDropDownListBox.HideDropDown(ApplyText:Boolean);
begin
 if Assigned(Owner) and Supports(Owner,IHaveDropDown) and (Visible)then
    (Owner as IHaveDropDown).HideDropDown(True);
end;

procedure TDropDownListBox.UpdateItemIndex;
var
 P: TPoint;
 I: Integer;
begin
 GetCursorPos(P);
 P:=ScreenToClient(P);
 I:=ItemAtPos(P, True);
 if I<>-1 then
  ItemIndex:=I;
end;

procedure TDropDownListBox.WMLButtonUp(var M: TWMLButtonUp);
begin
inherited;
 if (ItemIndex<>-1) then
  HideDropDown(True);
end;

procedure TDropDownListBox.WMMouseMove(var M: TWMMouseMove);
begin
 inherited;
 UpdateItemIndex;
end;

procedure TDropDownListBox.CreateParams(var Params: TCreateParams);
begin
 inherited CreateParams(Params);
 Params.ExStyle:=WS_EX_TOOLWINDOW;
 Params.WndParent:=GetDesktopWindow;
 Params.Style:=WS_CHILD or WS_BORDER or WS_CLIPSIBLINGS or WS_OVERLAPPED or WS_VSCROLL or LBS_NOINTEGRALHEIGHT;
end;

procedure TDropDownListBox.WMActivateApp(var M: TMessage);
begin
 inherited;
 HideDropDown(False);
end;

end.
