unit Common.Images.SelectDialog;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Dialog.Basic, cxGraphics,
  cxLookAndFeels, cxLookAndFeelPainters, Vcl.Menus, Vcl.Grids, Vcl.StdCtrls,
  cxButtons, Vcl.ExtCtrls, System.ImageList, Vcl.ImgList,System.Generics.Collections,
  Common.Images, cxControls, cxContainer, cxEdit, cxLabel, cxTextEdit;

type
  TSelectImageDialog = class(TBasicDialog)
    Grid: TDrawGrid;
    Label1: TLabel;
    lbIndex: TLabel;
    Label2: TLabel;
    Panel1: TPanel;
    edSearch: TcxTextEdit;
    Timer1: TTimer;
    Label3: TLabel;
    lbTags: TLabel;
    Preview: TImage;
    bnClear: TcxButton;
    procedure GridDrawCell(Sender: TObject; ACol, ARow: Integer; Rect: TRect;
      State: TGridDrawState);
    procedure GridSelectCell(Sender: TObject; ACol, ARow: Integer; var CanSelect: Boolean);
    procedure Timer1Timer(Sender: TObject);
    procedure edSearchPropertiesChange(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure GridDblClick(Sender: TObject);
    procedure bnClearClick(Sender: TObject);
  strict private
   FSelectedIndex:Integer;
   FImageList:TCustomImageList;
   FMainImageList:TCustomImageList;
   FFilteredImageList:TCustomImageList;
   FLastTick:Int64;
   FRealImageIndexes: TList<Integer>;
  public
   class function Execute(var ImageIndex:Integer):Boolean;  reintroduce;
   class function ExecuteWithClear(var ImageIndex:Integer):Boolean;  reintroduce;
   procedure InitGrid(StoreIndex: Boolean = True);
   function Open(var ImageIndex: Integer): Boolean;
   function GetImageIndex(AIndex:Integer):Integer;
   constructor Create(AOwner:TComponent); override;
   destructor Destroy; override;
  end;


implementation

{$R *.dfm}

type
 THackGrid = class (TDrawGrid)

 end;

constructor TSelectImageDialog.Create(AOwner: TComponent);
begin
 inherited;
 FSelectedIndex:=-1;
 FMainImageList:=ImageContainer.Images16;
 FFilteredImageList:=TImageList.Create(Self);
 FImageList:=FMainImageList;
 FLastTick:=0;
 FRealImageIndexes:=TList<Integer>.Create;
end;

destructor TSelectImageDialog.Destroy;
begin
   FRealImageIndexes.Free;
  inherited;
end;


procedure TSelectImageDialog.edSearchPropertiesChange(Sender: TObject);
begin
 FLastTick:=GetTickCount;
 Timer1.Enabled:=True;
end;

class function TSelectImageDialog.Execute(var ImageIndex: Integer): Boolean;
var
 Dlg: TSelectImageDialog;
begin
 Dlg:=TSelectImageDialog.Create(nil);
 try
  Result:=Dlg.Open(ImageIndex);
 finally
  Dlg.Free;
 end;
end;

class function TSelectImageDialog.ExecuteWithClear(var ImageIndex: Integer): Boolean;
var
 Dlg: TSelectImageDialog;
begin
 Dlg:=TSelectImageDialog.Create(nil);
 try
  Dlg.bnClear.Visible:=True;
  Result:=Dlg.Open(ImageIndex);
 finally
  Dlg.Free;
 end;
end;
procedure TSelectImageDialog.FormResize(Sender: TObject);
begin
  InitGrid;
end;

function TSelectImageDialog.GetImageIndex(AIndex:Integer): Integer;
begin
 if FImageList=FFilteredImageList then
  Result:=FRealImageIndexes[AIndex]
   else
  Result:=AIndex;
end;

procedure TSelectImageDialog.GridDblClick(Sender: TObject);
begin
 ModalResult:=mrOK;
end;

procedure TSelectImageDialog.GridDrawCell(Sender: TObject; ACol, ARow: Integer; Rect: TRect; State: TGridDrawState);
var
  Index: Integer;
  X:Integer;
  Y:Integer;
begin
 Index := ARow * Grid.ColCount + ACol;
 Grid.Canvas.FillRect(Rect);
  begin
   X:=(Rect.Left + Rect.Right) div 2 - FImageList.Width div 2;
   Y:=(Rect.Top + Rect.Bottom) div 2 - FImageList.Height div 2;
    if (gdFocused in State) or (FSelectedIndex=Index) then
     begin
      Grid.Canvas.Pen.Color := clBlack;
      Grid.Canvas.Pen.Width := 2;
      Inc(Rect.Left);
      Inc(Rect.Top);
      Dec(Rect.Bottom);
      Grid.Canvas.Rectangle(Rect);
      FImageList.Draw(Grid.Canvas, X,Y,Index);
    end
      else
       FImageList.Draw(Grid.Canvas, X,Y,Index);
    end;
  end;

procedure TSelectImageDialog.GridSelectCell(Sender: TObject; ACol,  ARow: Integer; var CanSelect: Boolean);
var
  Index: Integer;
  RealIndex:Integer;
begin
 Index := ARow * Grid.ColCount + ACol;
 CanSelect := Index < FImageList.Count;
  IF CanSelect then
   begin
    FSelectedIndex:=Index;
    RealIndex:=GetImageIndex(Index);
    lbIndex.Caption := RealIndex.ToString;
    lbTags.Caption:=ImageContainer.Tags[RealIndex];
    TImageContainer.LoadToImage(Preview,RealIndex);
   end;
end;


procedure TSelectImageDialog.InitGrid(StoreIndex: Boolean);
var
  DrawInfo: TGridDrawInfo;
  VColCount: Integer;
  Index: Integer;
begin
  Index := Grid.Row * Grid.ColCount + Grid.Col;

  with THackGrid(Grid) do
  begin
    CalcDrawInfo(DrawInfo);
    VColCount := ClientWidth div (DrawInfo.Horz.EffectiveLineWidth + DefaultColWidth);
    ColCount := VColCount;
    RowCount := (FImageList.Count-1) div ColCount + 1;
    if StoreIndex then
      try
        MoveColRow(Index mod ColCount, Index div ColCount, True, True);
      except
        MoveColRow(0, 0, True, True);
      end
    else
      MoveColRow(0, 0, True, True);
    Invalidate;
  end;
end;

procedure TSelectImageDialog.bnClearClick(Sender: TObject);
begin
 Self.FSelectedIndex:=-1;
end;

function TSelectImageDialog.Open(var ImageIndex: Integer): Boolean;
begin
  if ImageIndex < 0 then
   ImageIndex := 0;
  InitGrid;

  Grid.Row := (ImageIndex ) div Grid.ColCount;
  Grid.Col := (ImageIndex) mod Grid.ColCount;

  lbIndex.Caption := ImageIndex.ToString;
  Self.FSelectedIndex:=ImageIndex;
  Result := ShowModal = mrOK;
  if Result then
    ImageIndex := GetImageIndex(FSelectedIndex);
end;

procedure TSelectImageDialog.Timer1Timer(Sender: TObject);
begin
 if FLastTick+300<GetTickCount then
  begin
   Timer1.Enabled:=False;
   if Trim(edSearch.Text)='' then
   FImageList:=FMainImageList
    else
      begin
       TImageContainer.FindImages(edSearch.Text,FFilteredImageList,FRealImageIndexes);
       if (FFilteredImageList.Count<>FMainImageList.Count) then
        FImageList:=FFilteredImageList
      end;

  InitGrid;
  end;
end;

end.
