unit Plugin.Page;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Plugin.Base, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, Data.DB, cxSplitter,
  Plugin.SideTreeFilter, Vcl.ExtCtrls, Vcl.StdCtrls,
  CustomControl.MiceActionList, dxBar, cxClasses, cxContainer, cxEdit,
  dxFormattedLabel;

type
  TPagePlugin = class(TBasePlugin)
    lbCaption: TLabel;
    lbDescription: TdxFormattedLabel;
  protected
    procedure Build; override;
    procedure CheckKeyField;override;
  public
    constructor Create(AOwner:TComponent); override;
    destructor Destroy; override;
    procedure ForceRefreshDataSet; override;
  end;

implementation

{$R *.dfm}

{ TPagePlugin }

procedure TPagePlugin.Build;
begin
  inherited;
//  Self.Params.SetParameter('UserName','xexexe');
  lbCaption.Caption:=ParamsMapper.ReplaceTextVars(Properties.Title);
  lbDescription.Caption:=ParamsMapper.ReplaceTextVars(Properties.Description);

  Actions.ActionByName(ACTION_NAME_ADD_RECORD).OnExecute:=nil;
  Actions.ActionByName(ACTION_NAME_EDIT_RECORD).OnExecute:=nil;
  Actions.ActionByName(ACTION_NAME_DELETE_RECORD).OnExecute:=nil;
  Actions.ActionByName(ACTION_NAME_VIEW_RECORD).OnExecute:=nil;


//  Properties.ReadOnly:=True; //Disable actions
end;

procedure TPagePlugin.CheckKeyField;
begin
//
end;

constructor TPagePlugin.Create(AOwner: TComponent);
begin
  inherited;

end;

destructor TPagePlugin.Destroy;
begin
  inherited;
end;


procedure TPagePlugin.ForceRefreshDataSet;
begin
  PopulateParams;
  if not (DataSet.ProviderName.Trim.IsEmpty) then
   DataSet.Open;
  Self.lbCaption.Caption:=ParamsMapper.ReplaceTextVars(Properties.Title);
  Self.lbDescription.Caption:=ParamsMapper.ReplaceTextVars(Properties.Description);
end;

end.
