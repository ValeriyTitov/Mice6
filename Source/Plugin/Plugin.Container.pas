unit Plugin.Container;

interface
uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs,dxBar, cxBarEditItem,
  cxGraphics, cxControls, cxLookAndFeels,  cxClasses,cxPC,  dxRibbon,
  System.Generics.Collections,  Data.DB,
  Common.StringUtils,
  Common.LookAndFeel;

type


TPluginContainer = class
  strict private
    FTab: TdxRibbonTab;
    FSheet: TcxTabSheet;
    procedure DestroyToolbars;
  private
    FMethodControls: TList<TdxBarItem>;
    FCommandControls: TList<TdxBarItem>;
    FFilterControls: TList<TdxBarItem>;
    FDocFlowRollBackButton: TdxBarLargeButton;
    FDocFlowPushButton: TdxBarLargeButton;
    FDocFlowDeleteButton: TdxBarLargeButton;
    FCaption: string;
    FTileItem: TObject;
    FBar: TdxBarManager;
    procedure SetCaption(const Value: string);
    procedure SetBar(const Value: TdxBarManager);
  public
    procedure AllControlsToList(List:TList<TdxBarItem>);
    function CreateRibbonGroup(const Caption:string):TdxRibbonTabGroup;
    function FindRibbonGroup(const Caption:string):TdxRibbonTabGroup;
    function FindToolBar(const Caption:string):TdxBar;
    function CreateToolBar(const Caption:string):TdxBar;
    function RibbonGroupByName(const Caption:string):TdxRibbonTabGroup;

    property Tab:TdxRibbonTab read FTab write FTab;
    property Sheet:TcxTabSheet read FSheet write FSheet;
    property TileItem:TObject read FTileItem write FTileItem;
    property Bar:TdxBarManager read FBar write SetBar;
    property CommandControls:TList<TdxBarItem> read FCommandControls;
    property FilterControls:TList<TdxBarItem> read FFilterControls;
    property MethodControls:TList<TdxBarItem> read FMethodControls;

    property DocFlowPushButton:TdxBarLargeButton read FDocFlowPushButton write FDocFlowPushButton;
    property DocFlowDeleteButton: TdxBarLargeButton read FDocFlowDeleteButton write FDocFlowDeleteButton;
    property DocFlowRollBackButton:TdxBarLargeButton read FDocFlowRollBackButton write FDocFlowRollBackButton;
    property Caption:string read FCaption write SetCaption;


    constructor Create;
    destructor Destroy; override;
 end;

implementation


{ TPluginContainer }

procedure TPluginContainer.AllControlsToList(List: TList<TdxBarItem>);
var
 Item:TdxBarItem;
begin
 for Item in CommandControls do
  List.Add(Item);

 for Item in FilterControls do
  List.Add(Item);

 for Item in MethodControls do
  List.Add(Item);
end;

constructor TPluginContainer.Create;
begin
 FCommandControls:=TList<TdxBarItem>.Create;
 FFilterControls:=TList<TdxBarItem>.Create;
 FMethodControls:=TList<TdxBarItem>.Create;
end;


function TPluginContainer.CreateRibbonGroup(const Caption: string): TdxRibbonTabGroup;
begin
 Result:=Self.FindRibbonGroup(Caption);
 if not Assigned(Result) then
  begin
   Result:=Tab.Groups.Add;
   Result.Caption:=Caption;
   Result.ToolBar:=Tab.Ribbon.BarManager.Bars.Add;
   Result.ToolBar.Visible:=True;
  end;
end;

function TPluginContainer.CreateToolBar(const Caption: string): TdxBar;
begin
 Result:=Self.FindToolBar(Caption);
 if not Assigned(Result) then
  begin
   Result:=Self.Bar.AddToolBar;
   Result.Caption:=Caption;
   Result.Visible:=True;
   Result.ShowMark:=False;
   Result.Color:=DefaultLookAndFeel.WindowColor;

   Result.AllowClose:=False;
   Result.AllowCustomizing:=False;
   Result.AllowQuickCustomizing:=False;
   Result.AllowReset:=False;
   Result.BorderStyle:=TdxBarBorderStyle.bbsNone;
   Result.OneOnRow:=False;
   Result.ShowMark:=False;
   Result.SizeGrip:=False;
   Result.Row:=0;
   Result.UseRestSpace:=True;
  end;
end;

destructor TPluginContainer.Destroy;
begin
  FCommandControls.Free;
  FFilterControls.Free;
  FMethodControls.Free;

  if Assigned(Tab) then
   begin
    DestroyToolbars;
    Tab.Free;
   end;
  inherited;
end;

procedure TPluginContainer.DestroyToolbars;
var
 x:integer;
begin
 for x:=Tab.Groups.Count-1 downto 0 do
  Tab.Groups[x].ToolBar.Free;
end;

function TPluginContainer.FindToolBar(const Caption: string): TdxBar;
var
 x:Integer;
begin
 for x:=0 to Bar.Bars.Count-1 do
  if TStringUtils.SameTrimString(Caption,Bar.Bars[x].Caption) then
    Exit(Bar.Bars[x]);

 Result:=nil;
end;
function TPluginContainer.FindRibbonGroup(const Caption: string): TdxRibbonTabGroup;
var
 x:Integer;
begin
 for x:=0 to self.Tab.Groups.Count-1 do
  if TStringUtils.SameTrimString(Caption,Tab.Groups[x].Caption) then
   Exit(Tab.Groups[x]);
  Result:=nil;
end;

function TPluginContainer.RibbonGroupByName(const Caption: string): TdxRibbonTabGroup;
resourcestring
 S_CANNOT_FIND_GROUP = 'Cannot find ribbon group %s';
begin
 Result:=FindRibbonGroup(Caption);
  if not Assigned(Result) then
   raise Exception.CreateFmt(S_CANNOT_FIND_GROUP,[Caption]);
end;

procedure TPluginContainer.SetBar(const Value: TdxBarManager);
begin
  FBar := Value;
end;

procedure TPluginContainer.SetCaption(const Value: string);
begin
 Tab.Caption:=Value;
end;


end.
