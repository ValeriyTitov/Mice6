unit Dialog.Adaptive.Helper;

interface
uses
  System.Classes, System.SysUtils,dxLayoutControl,
  Vcl.Controls,
  DAC.XParams,
  DAC.XDataSet,
  CustomControl.MiceLayout,
  Dialog.Layout.Builder;

type
  TAdaptiveDialogHelper = class
  private
    FAppDialogsId:Integer;
    FLayoutBuilder:TDialogLayoutBuilder;
    FAppDialogsLayoutId: Integer;
  public
    procedure BuildControls;
    property LayoutBuilder:TDialogLayoutBuilder read FLayoutBuilder;
    property AppDialogsId:Integer read FAppDialogsId write FAppDialogsId;
    property AppDialogsLayoutId:Integer read FAppDialogsLayoutId write FAppDialogsLayoutId;
    constructor Create(LayoutPane:TMiceLayoutControl);
    destructor Destroy; override;
  end;
implementation

{ TAdaptiveDialogHelper }

procedure TAdaptiveDialogHelper.BuildControls;
begin
 FLayoutBuilder.AppDialogsId:=FAppDialogsId;
 FLayoutBuilder.Build;
end;

constructor TAdaptiveDialogHelper.Create(LayoutPane: TMiceLayoutControl);
begin
 FLayoutBuilder:=TDialogLayoutBuilder.Create(LayoutPane);
end;

destructor TAdaptiveDialogHelper.Destroy;
begin
  FLayoutBuilder.Free;
  inherited;
end;



end.
