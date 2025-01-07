unit Plugin.List;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, dxRibbonSkins, dxRibbonCustomizationForm, cxClasses,
  dxRibbon, dxStatusBar, dxRibbonStatusBar, dxBar, System.Generics.Collections, cxPC, DB,
  Plugin.Base,
  Common.StringUtils;

type
TPluginList = class(TObjectList<TBasePlugin>)
strict private
public
  constructor Create;
  destructor Destroy; override;
  function PluginByID(const PluginID:Integer):TBasePlugin;
  function PluginExists(const PluginID:Integer):boolean;
end;

implementation

{ TPluginList }

constructor TPluginList.Create;
begin
 inherited Create(True);
end;

destructor TPluginList.Destroy;
begin
  inherited;
end;

function TPluginList.PluginByID(const PluginID: Integer): TBasePlugin;
var
 Plugin:TBasePlugin;
begin
for Plugin in Self do
  if  Plugin.Properties.AppPluginsId=PluginID then
     Exit(Plugin);
 Result:=nil;
end;

function TPluginList.PluginExists(const PluginID: Integer): boolean;
begin
 Result:=Assigned(PluginByID(PluginID));
end;

end.
