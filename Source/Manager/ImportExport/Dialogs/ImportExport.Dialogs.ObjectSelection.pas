unit ImportExport.Dialogs.ObjectSelection;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Dialog.Basic, cxGraphics,
  cxLookAndFeels, cxLookAndFeelPainters, Vcl.Menus, Vcl.StdCtrls, cxButtons,
  Vcl.ExtCtrls, dxBarBuiltInMenu, cxControls, cxPC,
  ImportExport.Dialogs.ObjectFrame,
  DAC.XDataSet,
  Common.Images,
  Common.ResourceStrings,
  ImportExport.Entity,
  System.NetEncoding,  System.Generics.Collections,
  System.Generics.Defaults, System.JSON, cxContainer, cxEdit, cxProgressBar;

type
  TAppObjectExportDlg = class(TBasicDialog)
    pgMain: TcxPageControl;
    Panel1: TPanel;
    Image1: TImage;
    lbDescription: TLabel;
    bnPreview: TcxButton;
    ExportDialog: TSaveDialog;
    bnBuild: TcxButton;
    Progress: TcxProgressBar;
    lbCount: TLabel;
  private
    FFinishedOnce:Boolean;
    FFrameList:TDictionary<string,TAppObjectExportFrame>;
    FAppObjectList:TObjectList<TMiceITypeEntity>;
    procedure SelectionChanged;
    procedure CreateEntity(Entity:TMiceITypeEntity);
    procedure OnSelectionChanged(Sender:TObject);
    function CreateTab(Entity:TMiceITypeEntity):TcxTabSheet;
    function GetSelectedCount:Integer;
  public
    procedure SetProgress(Current, Max:Integer);
    procedure Start;
    procedure Finish;
    procedure Build;
    property AppObjectList:TObjectList<TMiceITypeEntity> read FAppObjectList write FAppObjectList;
    class function Execute(AppObjectList:TObjectList<TMiceITypeEntity>):Boolean; reintroduce;
    constructor Create(AOwner:TComponent); override;
    destructor Destroy; override;
  end;

implementation

{$R *.dfm}

{ TAppObjectExportDlg }

procedure TAppObjectExportDlg.Build;
var
 Entity:TMiceITypeEntity;
begin
 for Entity in AppObjectList do
  Self.CreateEntity(Entity);
 SelectionChanged;
end;

constructor TAppObjectExportDlg.Create(AOwner: TComponent);
begin
  inherited;
  FFinishedOnce:=False;
  ImageContainer.LoadToImage(Self.Image1, IMAGEINDEX_EXPORT_APP_OBJECT);
  FFrameList:=TDictionary<string,TAppObjectExportFrame>.Create;
  bnCancel.Caption:=S_COMMON_CLOSE;
end;

procedure TAppObjectExportDlg.CreateEntity(Entity: TMiceITypeEntity);
begin
 if FFrameList.ContainsKey(Entity.Name) then
 FFrameList[Entity.Name].Init(Entity)
  else
 CreateTab(Entity);
end;


function TAppObjectExportDlg.CreateTab(Entity: TMiceITypeEntity): TcxTabSheet;
var
 Frame:TAppObjectExportFrame;
begin
 Result:=TcxTabSheet.Create(pgMain);
 Result.Caption:=Entity.Name;
 Result.Name:=Entity.Name;
 Result.PageControl:=Self.pgMain;
 Frame:=TAppObjectExportFrame.Create(Result);
 FFrameList.Add(Entity.Name, Frame);
 Frame.Init(Entity);
 Frame.OnSelectionChanged:=Self.OnSelectionChanged;
 Frame.Parent:=Result;
end;

destructor TAppObjectExportDlg.Destroy;
begin
  FFrameList.Free;
  inherited;
end;

class function TAppObjectExportDlg.Execute(AppObjectList: TObjectList<TMiceITypeEntity>): Boolean;
var
 Dlg:TAppObjectExportDlg;
begin
 Dlg:=TAppObjectExportDlg.Create(nil);
 try
  Dlg.AppObjectList:=AppObjectList;
  Dlg.LoadState(True, True);
  Dlg.Build;
  Result:=Dlg.ShowModal=mrOk;
  if Result then
   Dlg.SaveState;
 finally
  Dlg.Free;
 end;
end;


procedure TAppObjectExportDlg.Finish;
begin
 FFinishedOnce:=True;
 Self.bnPreview.Enabled:=bnBuild.Enabled;
 Self.bnOK.Enabled:=bnBuild.Enabled;
end;

function TAppObjectExportDlg.GetSelectedCount: Integer;
var
 s:string;
begin
Result:=0;
 for s in FFrameList.Keys do
  Result:=Result+FFrameList[s].SelectedCount;
end;

procedure TAppObjectExportDlg.OnSelectionChanged(Sender: TObject);
begin
 Self.SelectionChanged
end;

procedure TAppObjectExportDlg.SetProgress(Current, Max: Integer);
begin
 Self.Progress.Properties.Max:=Max;
 Self.Progress.Position:=Current;
 Application.ProcessMessages;
end;

procedure TAppObjectExportDlg.Start;
begin
 Self.bnPreview.Enabled:=False;
 Self.bnOK.Enabled:=False;
 Self.Progress.Visible:=True;
end;

procedure TAppObjectExportDlg.SelectionChanged;
resourcestring
 S_SELECT_ITEM_COUNT_LABEL_FMT = '%d items selected';
begin
 bnBuild.Enabled:=(GetSelectedCount>0);
 Self.bnPreview.Enabled:=bnBuild.Enabled and FFinishedOnce;
 Self.bnOK.Enabled:=bnBuild.Enabled and FFinishedOnce;
 Self.lbCount.Caption:=Format(S_SELECT_ITEM_COUNT_LABEL_FMT,[GetSelectedCount]);
end;

end.
