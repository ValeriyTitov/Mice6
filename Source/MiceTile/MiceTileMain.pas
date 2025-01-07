unit MiceTileMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, cxButtons,
  cxPC,Vcl.ExtCtrls,   System.Actions,  Vcl.ActnList, Data.DB,
  cxGraphics, cxControls, dxBar, cxClasses,  dxStatusBar, cxLookAndFeels,
  cxLookAndFeelPainters,
  dxBarBuiltInMenu,
  DAC.XParams.Utils,
  DAC.XDataSet,
  DAC.XParams,
  DAC.History.Form,
  DAC.ConnectionMngr,
  DAC.ObjectModels.MiceUser,
  Common.Images,
  Common.StringUtils,
  Common.DateUtils,
  Common.ResourceStrings,
  Plugin.Base,
  Plugin.List,
  Plugin.TileBuilder,
  Mice.Report,
  Common.LookAndFeel,
  Common.Registry,
  Common.GlobalSettings,
  CustomControl.PluginTree, Vcl.Menus, dxCustomTileControl, dxTileControl;


type
  TMiceMainTileForm = class(TForm)
    pnTop: TPanel;
    MainButton: TcxButton;
    bnTheme: TButton;
    dxTile: TdxTileControl;
    gWorkPlace: TdxTileControlGroup;
    gActiveItems: TdxTileControlGroup;
    dxTileActionBarItem1: TdxTileControlActionBarItem;
    dxTileActionBarItem2: TdxTileControlActionBarItem;
    ThemePopupMenu: TPopupMenu;
    miWhiteTheme: TMenuItem;
    miBlackTheme: TMenuItem;
    miSkyBlueTheme: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure MainButtonClick(Sender: TObject);
    procedure miBlackThemeClick(Sender: TObject);
    procedure bnThemeClick(Sender: TObject);
    procedure miWhiteThemeClick(Sender: TObject);
    procedure miSkyBlueThemeClick(Sender: TObject);
  private
    FPluginBuilder:TPluginTileBuilder;
    FPluginTree:TPluginTree;
    FDestroyingPlugin:Boolean;
    procedure SaveState;
    procedure LoadState;
    procedure OnPluginTreeDblClick(DataSet:TDataSet);
  public
    constructor Create(AOwner:TComponent); override;
    destructor Destroy; override;
  end;

var
  MiceMainTileForm: TMiceMainTileForm;

implementation

{$R *.dfm}

procedure TMiceMainTileForm.miBlackThemeClick(Sender: TObject);
begin
dxTile.Style.GradientBeginColor:=clSoftBlack;
pnTop.Color:=clSoftBlack;
Self.gWorkPlace.Caption.Font.Color:=clWhite;
Self.gActiveItems.Caption.Font.Color:=clWhite;
Self.dxTile.Title.Font.Color:=clWhite;
Self.dxTile.Title.TabsTextColor:=clWhite;
DefaultLookAndFeel.Theme:=TMiceColorTheme.mctDarkTheme;
dxBarMakeInactiveImagesDingy:=False;
end;

procedure TMiceMainTileForm.miSkyBlueThemeClick(Sender: TObject);
begin
dxTile.Style.GradientBeginColor:=clSkyBlue;
pnTop.Color:=clWhite;
Self.gWorkPlace.Caption.Font.Color:=clBlack;
Self.gActiveItems.Caption.Font.Color:=clBlack;
Self.dxTile.Title.Font.Color:=clBlack;
Self.dxTile.Title.TabsTextColor:=clBlack;
DefaultLookAndFeel.Theme:=TMiceColorTheme.mctWhiteTheme;
dxBarMakeInactiveImagesDingy:=False;
end;


procedure TMiceMainTileForm.miWhiteThemeClick(Sender: TObject);
begin
dxTile.Style.GradientBeginColor:=clWhite;
pnTop.Color:=clWhite;
Self.gWorkPlace.Caption.Font.Color:=clBlack;
Self.gActiveItems.Caption.Font.Color:=clBlack;
Self.dxTile.Title.Font.Color:=clBlack;
Self.dxTile.Title.TabsTextColor:=clBlack;
DefaultLookAndFeel.Theme:=TMiceColorTheme.mctWhiteTheme;
dxBarMakeInactiveImagesDingy:=False;
end;



procedure TMiceMainTileForm.bnThemeClick(Sender: TObject);
begin
ThemePopupMenu.Popup(0,0);
end;

constructor TMiceMainTileForm.Create(AOwner: TComponent);
begin
  inherited;

end;

destructor TMiceMainTileForm.Destroy;
begin
  SaveState;
  FPluginBuilder.Free;
  FPluginTree.Free;
  inherited;
end;

procedure TMiceMainTileForm.FormCreate(Sender: TObject);
begin
  FPluginBuilder:=TPluginTileBuilder.Create(Self.dxTile);
  FPluginTree:=TPluginTree.Create(Self);
  FPluginTree.OnDblClick:=OnPluginTreeDblClick;
  FPluginTree.TopOffset:=60;
  try
   FPluginTree.UpdateTree;
  except On E:Exception do
   MessageBox(Handle, PChar('PluginTree: '+E.Message),PChar(S_COMMON_ERROR),MB_OK+MB_ICONERROR);
  end;
//  UpdateAll;
  FDestroyingPlugin:=False;
  LoadState;
end;

procedure TMiceMainTileForm.LoadState;
begin
 TProjectRegistry.DefaultInstance.LoadForm(ClassName,False, True, Self);
 FPluginTree.PluginTreeList.Path:=TProjectRegistry.DefaultInstance.ReadStringDef(TProjectRegistry.DefaultInstance.DialogPath(ClassName),RegKeyLastPath,'');
end;

procedure TMiceMainTileForm.MainButtonClick(Sender: TObject);
begin
 FPluginTree.ShowModal;
end;

procedure TMiceMainTileForm.OnPluginTreeDblClick(DataSet: TDataSet);
var
 AppPluginsId:Integer;
 Plugin:TBasePlugin;
 AImageIndex:Integer;
begin
 try
  AppPluginsId:=DataSet.FieldByName('AppPluginsId').AsInteger;
  AImageIndex:=DataSet.FieldByName('ImageIndex').AsInteger;
  if GetKeyState(VK_SHIFT)>=0 then
   begin
    Plugin:=FPluginBuilder.CreatePluginById(AppPluginsId);
    (Plugin.Container.TileItem as TdxTileControlItem).Glyph.ImageIndex:=AImageIndex;
    Plugin.LoadState;
    if Plugin.Properties.RefreshAfterCreate then
      Plugin.RefreshDataSet;
   end
    else
   FPluginBuilder.CreatePluginByIdLazy(AppPluginsId).LoadState;

 finally
//  UpdateAll;
 end;
end;


procedure TMiceMainTileForm.SaveState;
begin
 TProjectRegistry.DefaultInstance.WriteString(TProjectRegistry.DefaultInstance.DialogPath(ClassName),RegKeyLastPath,FPluginTree.PluginTreeList.Path);
 TProjectRegistry.DefaultInstance.SaveForm(ClassName, Self);
end;

end.
