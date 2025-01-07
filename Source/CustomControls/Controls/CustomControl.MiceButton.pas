unit CustomControl.MiceButton;

interface
 uses
 Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, cxGraphics, Vcl.Menus, Vcl.StdCtrls, cxButtons,
  cxLookAndFeels, cxLookAndFeelPainters,
  Mice.Script.ClassTree,
  CustomControl.AppObject,
  Common.ResourceStrings,
  Common.Images,
  DAC.XParams,
  Mice.Script,
  CustomControl.Interfaces;

 type
  TMiceButton = class(TcxButton, IHaveScriptSupport, ICanInitFromJson)
   private
    FScript:TMiceScripter;
    procedure SetImageIndex(const Value: Integer);
    function GetImageIndex: Integer;
   protected
    procedure CallScript;
   public
    procedure InitFromJson(const Json:string);
    procedure InitFromParams(Params:TxParams);
    procedure Click; override;
    procedure RegisterScripter(Scripter:TMiceScripter);
    constructor Create(AOwner:TComponent); override;
    class function DevDescription:string;
   published
    property ImageIndex:Integer read GetImageIndex write SetImageIndex;
  end;

implementation

{ TMiceButton }

procedure TMiceButton.CallScript;
begin
 if Assigned(FScript) then
  FScript.CallOnClick(Self);
end;


procedure TMiceButton.Click;
begin
  inherited;
  CallScript;
end;

constructor TMiceButton.Create(AOwner: TComponent);
begin
 inherited;
 OptionsImage.Images:=ImageContainer.Images16;
end;

class function TMiceButton.DevDescription: string;
resourcestring
 S_DevDescription_TMiceButton = 'Button which user can click. Has image index. Event "OnClick" is triggered in dialog script.';
begin
 Result:= S_DevDescription_TMiceButton;
end;

function TMiceButton.GetImageIndex: Integer;
begin
 Result:=Self.OptionsImage.ImageIndex;
end;

procedure TMiceButton.InitFromJson(const Json: string);
var
 App:TMiceAppObject;
begin
 App:=TMiceAppObject.Create;
 try
  App.AsJson:=Json;
  InitFromParams(App.Params);
 finally
  App.Free;
 end;
end;

procedure TMiceButton.InitFromParams(Params: TxParams);
begin
 ImageIndex:=Params.ParamByNameDef('ImageIndex',-1);
end;

procedure TMiceButton.RegisterScripter(Scripter: TMiceScripter);
begin
 FScript:=Scripter;
end;

procedure TMiceButton.SetImageIndex(const Value: Integer);
begin
  OptionsImage.ImageIndex := Value;
end;



resourcestring
S_PROP_DESC_MICEBUTTON_IMAGEINDEX = 'Represents current image index, -1 to disable, 0 to empty';

initialization
 TMiceScripter.RegisterClassEventOnClick(TMiceButton.ClassName);


 TClassEventsTree.DefaultInstance.RegisterClassPropertyInteger(TMiceButton.ClassName,'ImageIndex', S_PROP_DESC_MICEBUTTON_IMAGEINDEX);

end.
