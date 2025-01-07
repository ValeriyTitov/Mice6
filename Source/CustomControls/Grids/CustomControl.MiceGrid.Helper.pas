unit CustomControl.MiceGrid.Helper;

interface
uses Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  cxGraphics, cxControls, VCL.Graphics,  cxClasses, cxGridCustomView,
  cxGridCustomTableView, cxGridTableView,cxGridDBBandedTableView,  cxGridDBTableView,
  cxGrid,  Data.DB, cxCheckBox, cxImageComboBox, cxImage, cxBlobEdit, cxTextEdit,
  cxGridBandedTableView,Vcl.Controls, cxEdit,VCL.ImgList,
  Common.Images;

type
 TMiceGridHelper =class
   class procedure InternalSplitSubAccountText(var SubAccount: string);
   class procedure FormatSubAccount(Sender: TcxCustomGridTableItem;  ARecord: TcxCustomGridRecord; var AText: string);
   class procedure GetGraphicClass(AItem: TObject;  ARecordIndex: Integer; APastingFromClipboard: Boolean;  var AGraphicClass: TGraphicClass);
   class function DetectGraphicsClass(V:Variant):TGraphicClass;
   class function DrawIcon(ACanvas: TcxCanvas;  AViewInfo: TcxGridTableDataCellViewInfo; ImageList: TCustomImageList; Column:TcxGridColumn):Boolean;
 end;

implementation

{ TMiceGridHelper }

class function TMiceGridHelper.DetectGraphicsClass(V: Variant): TGraphicClass;
{var
 S: String;
 L: Integer;}
begin
 Result:=nil;
{ L:= Length(V);
 Result:=  TIEGraphicBase;
 If (L<10) then exit;
 S:=V;
 SetLength(S,10);

 If Pos('JFIF',S)>0 then
    Result:=TIEJpegImage
  else
 If Pos('PNG',S)>0 then
    Result:=TIEPNGImage
  else
 If Pos('GIF',S)>0 then
    Result:=TIEGIFImage
  else
 Result:= TIEBMPImage;}
end;

class function TMiceGridHelper.DrawIcon(ACanvas: TcxCanvas;  AViewInfo: TcxGridTableDataCellViewInfo; ImageList: TCustomImageList; Column:TcxGridColumn):Boolean;
const
  alFlags: array [TcxEditHorzAlignment] of Integer = (DT_LEFT, DT_RIGHT, DT_CENTER);
var
  ImageIndex: Integer;
  ARect: TRect;
begin
Result:= ((AViewInfo.Item as TcxCustomGridTableItem).VisibleIndex = 0) and Assigned(ImageList);
if Result then
  begin
    ARect := AViewInfo.ContentBounds;
    ACanvas.FillRect(ARect);

    if Assigned(Column) and (VarType(AViewInfo.GridRecord.Values[Column.Index])=varInteger) then
        ImageIndex := AViewInfo.GridRecord.Values[Column.Index]
         else
        ImageIndex:=-1;

      if (ImageIndex > -1) and (ImageIndex < ImageList.Count) then
      begin
        ImageList.Draw(ACanvas.Canvas, AViewInfo.ClientBounds.Left + 1, AViewInfo.ClientBounds.Top + 1,ImageIndex);
//        ImageList_DrawEx(ImageList.Handle, ImageIndex, ACanvas.Handle, ARect.Left +2,  ARect.Top + (ARect.Bottom - ARect.Top - ImageList.Height) div 2, 0, 0, clNone, clNone, ILD_Transparent);
        ARect.Left := ARect.Left + ImageList.Width + 2;
      end;

      InflateRect(ARect, -4, -1);
      SetBkMode(ACanvas.Handle, TRANSPARENT);
      ACanvas.DrawTexT(AViewInfo.DisplayValue, ARect, cxAlignLeft or cxAlignTop or DT_END_ELLIPSIS or DT_NOPREFIX);
      //WinApi.Windows.DrawText(ACanvas.Handle, PChar(S), Length(S), ARect, alFlags[TAccessProperties(AViewInfo.Properties).Alignment.Horz] or DT_END_ELLIPSIS or DT_NOPREFIX);
      SetBkMode(ACanvas.Handle, OPAQUE);
  end;
end;



class procedure TMiceGridHelper.FormatSubAccount(Sender: TcxCustomGridTableItem; ARecord: TcxCustomGridRecord; var AText: string);
begin
 if AText.Length=20 then
  InternalSplitSubAccountText(AText);
// AText:=TSubAccountColumn.SplitSubAccountText(AText);
end;

class procedure TMiceGridHelper.GetGraphicClass(AItem: TObject;  ARecordIndex: Integer; APastingFromClipboard: Boolean;  var AGraphicClass: TGraphicClass);
var
 AView: TcxGridDBTableView;
 AIndex: Integer;
begin
 AView := TcxGridDBTableView(TcxGridDBColumn(AItem).GridView);
 AIndex := AView.GetColumnByFieldName(TcxGridDBBandedColumn(AItem).DataBinding.Field.FieldName).Index;
 AGraphicClass:=Self.DetectGraphicsClass(AView.DataController.Values[ARecordIndex,AIndex]);
end;

class procedure TMiceGridHelper.InternalSplitSubAccountText(var SubAccount: string);
var
 COA:string;
 Curr:string;
 Key:string;
 Branch:string;
 Acc:string;
begin
 COA:=Copy(SubAccount,1,5);
 Curr:=Copy(SubAccount,6,3);
 Key:= Copy(SubAccount,7,1);
 Branch:=Copy(SubAccount,8,4);
 Acc:=Copy(SubAccount,9,7);
 SetLength(SubAccount,24);
 SubAccount:=COA+' '+Curr+' '+Key+' '+Branch+' '+Acc;
end;


end.
