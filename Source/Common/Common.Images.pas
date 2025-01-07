unit Common.Images;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, System.ImageList, Vcl.ImgList,
  System.Generics.Collections, System.Generics.Defaults, Vcl.ExtCtrls,
  Vcl.StdCtrls, cxGraphics,cxImageComboBox, cxImageList;

type
  TImageContainer = class(TForm)
    memoTags: TMemo;
    Images16: TcxImageList;
    Images32: TcxImageList;
    Label1: TLabel;
  private
    function GetTags: TStrings;
  public
    procedure PopulateImages(Items:TcxImageComboBoxItems);
    property Tags:TStrings read GetTags;
    class procedure FindTags(const TagName:string; IndexList:TList<Integer>);
    class procedure FindImages(const TagNames:string; AImageList:TCustomImageList; List: TList<Integer>);
    class procedure LoadToImage(Image:TImage; ImageIndex:Integer);
    class function DefaultInstance:TImageContainer;
    class function FileExtToImageIndex(const Ext: string): Integer;
  end;

var
  ImageContainer: TImageContainer;

const
 IMAGEINDEX_ACTION_CLEAR = 177;
 IMAGEINDEX_ACTION_DELETE = 207;
 IMAGEINDEX_ACTION_NEW = 416;
 IMAGEINDEX_ACTION_CLONE = 439;
 IMAGEINDEX_ACTION_EDIT = 434;
 IMAGEINDEX_ACTION_COPY = 149;
 IMAGEINDEX_ACTION_CUT = 206;
 IMAGEINDEX_ACTION_SAVE = 504;
 IMAGEINDEX_ACTION_RENAME = 312;
 IMAGEINDEX_ACTION_FIND = 237;
 IMAGEINDEX_ACTION_FIND_NEXT = 202;
 IMAGEINDEX_ACTION_ADD = 437;
 IMAGEINDEX_ACTION_REFRESH = 44;
 IMAGEINDEX_ACTION_ACTIVITY = 124;
 IMAGEINDEX_PLUGIN_INFORMATION = 124;
 IMAGEINDEX_EXPORT_APP_OBJECT = 697;


 IMAGEINDEX_ACTION_DOCFLOW_PUSH = 66;
 IMAGEINDEX_ACTION_DOCFLOW_ROLLBACK = 65;
 IMAGEINDEX_ACTION_DOCFLOW_FLOW = 289;
 IMAGEINDEX_ACTION_DOCFLOW_TRANS = 644;
 IMAGEINDEX_ACTION_DOCFLOW_SCHEMA = 652;
 IMAGEINDEX_ACTION_DOCFLOW_ERRORLOG = 398;

 IMAGEINDEX_COMMAND = 245;
 IMAGEINDEX_FILTER = 691;
 IMAGEINDEX_COMMANDGROUP = 514;
 IMAGEINDEX_FOLDER = 253;

 IMAGEINDEX_COMMON_ITEM = 608;

 IMAGEINDEX_ITYPE_PLUGIN = 464;
 IMAGEINDEX_ITYPE_DIALOG = 181;
 IMAGEINDEX_ITYPE_LAYOUT = 315;
 IMAGEINDEX_ITYPE_BRIEFCASE = 89;
 IMAGEINDEX_ITYPE_NEW_FOLDER = 249;
 IMAGEINDEX_ITYPE_APP_TEMPLATE = 11;
 IMAGEINDEX_ITYPE_APP_DATASET = 86;
 IMAGEINDEX_ITYPE_DFCLASS = 255;
 IMAGEINDEX_ITYPE_DFTYPES = 121;
 IMAGEINDEX_ITYPE_DFSCHEME = 88;
 IMAGEINDEX_ITYPE_DFACTION = 485;
 IMAGEINDEX_ITYPE_DFPATHFOLDER = 601;
 IMAGEINDEX_ITYPE_DFMETHOD = 595;
 IMAGEINDEX_ITYPE_SCRIPT_SQL = 396;
 IMAGEINDEX_ITYPE_SCRIPT_CSHARP = 390;
 IMAGEINDEX_ITYPE_SCRIPT_PASCAL = 392;
 IMAGEINDEX_ITYPE_DFACTION_MAIL = 220;
 IMAGEINDEX_ITYPE_DFACTION_STOREDPROC = 604;



 IMAGEINDEX_SCRIPT_TREE_PROPERTIES_GROUP = 233;
 IMAGEINDEX_SCRIPT_TREE_METHODS_GROUP = 89;
 IMAGEINDEX_SCRIPT_TREE_EVENTS_GROUP = 181;
 IMAGEINDEX_SCRIPT_TREE_CLASSES_GROUP = 184;

 IMAGEINDEX_SCRIPT_TREE_PROPERTIES_ENTRY = 271;
 IMAGEINDEX_SCRIPT_TREE_METHODS_ENTRY = 284;
 IMAGEINDEX_SCRIPT_TREE_EVENT_ENTRY = 686;
 IMAGEINDEX_SCRIPT_TREE_CLASSES_ENTRY = 131;
 IMAGEINDEX_SCRIPT_TREE_OTHER_ENTRY = 267;




 IMAGEINDEX_LEFT_ARROW = 65;
 IMAGEINDEX_RIGHT_ARROW = 66;
 IMAGEINDEX_UP_ARROW= 68;
 IMAGEINDEX_DOWN_ARROW = 67;

 IMAGEINDEX_QUESTION = 79;
 IMAGEINDEX_STOP  = 587;
 IMAGEINDEX_CLOSE = 228;
 IMAGEINDEX_EXIT  = 19;
 IMAGEINDEX_HELP  = 289;
 IMAGEINDEX_HOME  = 266;
 IMAGEINDEX_INFORMATION = 302;


 IMAGEINDEX_MIME_JSON = 381;
 IMAGEINDEX_MIME_XML = 401;
 IMAGEINDEX_MIME_XSD = 402;
 IMAGEINDEX_EXTERNAL_FILE = 442;

 IMAGEINDEX_MIME_ARCHIVE = 352;
 IMAGEINDEX_MIME_DOC_WORD = 444;
 IMAGEINDEX_MIME_DOC_EXCEL = 440;
 IMAGEINDEX_MIME_DOC_PDF = 363;
 IMAGEINDEX_MIME_MEDIA_AUDIO = 384;
 IMAGEINDEX_MIME_MEDIA_VIDEO = 382;
 IMAGEINDEX_MIME_MEDIA_IMAGE = 379;

implementation

{$R *.dfm}
var
 FCommonExtensions: TDictionary<string, Integer>;

{ TImageContainer }

class function TImageContainer.DefaultInstance: TImageContainer;
begin
 Result:=ImageContainer;
end;

class function TImageContainer.FileExtToImageIndex(const Ext: String): Integer;
var
 Key:string;
begin
 Key:=ExtractFileExt(Ext);
 {if (Key.IsEmpty=False) and (Key.StartsWith('.')=False) then
  Key:='.'+Key;
 }
 if FCommonExtensions.ContainsKey(Key) then
  Result:= FCommonExtensions[Key]
   else
  Result:=IMAGEINDEX_ACTION_NEW;
end;

class procedure TImageContainer.FindImages(const TagNames: string;  AImageList: TCustomImageList;  List: TList<Integer>);
var
 AList:TCustomImageList;
 x:Integer;
begin
 AImageList.Clear;
 AList:=ImageContainer.Images16;
 FindTags(TagNames,List);
  for x:=0 to List.Count-1 do
   AImageList.AddImage(AList,List[x]);
end;

class procedure TImageContainer.FindTags(const TagName: string;  IndexList: TList<Integer>);
var
 x:Integer;
 s:string;
 List:TStrings;
begin
 IndexList.Clear;
 List:=ImageContainer.memoTags.Lines;
 s:=AnsiLowerCase(TagName);
 for x:=0 to List.Count-1 do
  if Pos(s,List[x])>0 then
    IndexList.Add(x);
end;

function TImageContainer.GetTags: TStrings;
begin
 Result:=memoTags.Lines;
end;

class procedure TImageContainer.LoadToImage(Image: TImage; ImageIndex: Integer);
begin
 Image.Picture.Bitmap:=nil;
 Image.Transparent:=True;
// Image.Stretch:=True;
 if Image.Width=16 then
  ImageContainer.Images16.GetBitmap(ImageIndex,Image.Picture.Bitmap)
   else
  ImageContainer.Images32.GetBitmap(ImageIndex,Image.Picture.Bitmap);
end;

procedure TImageContainer.PopulateImages(Items: TcxImageComboBoxItems);
var
 x:Integer;
 Item:TcxImageComboBoxItem;
begin
 for x:=0 to Images16.Count - 1 do
  begin
   Item:=Items.Add;
   Item.ImageIndex:=x;
   Item.Value:=x;
   Item.Description:=x.ToString;
  end;
end;

initialization
  ImageContainer:=TImageContainer.Create(nil);
  FCommonExtensions:=TDictionary<string, Integer>.Create(TIStringComparer.Ordinal);
  FCommonExtensions.Add('.rar',  IMAGEINDEX_MIME_ARCHIVE);
  FCommonExtensions.Add('.zip',  IMAGEINDEX_MIME_ARCHIVE);
  FCommonExtensions.Add('.7z',   IMAGEINDEX_MIME_ARCHIVE);
  FCommonExtensions.Add('.xml',  IMAGEINDEX_MIME_XML);
  FCommonExtensions.Add('.mp3',  IMAGEINDEX_MIME_MEDIA_AUDIO);
  FCommonExtensions.Add('.ogg',  IMAGEINDEX_MIME_MEDIA_AUDIO);
  FCommonExtensions.Add('.avi',  IMAGEINDEX_MIME_MEDIA_VIDEO);
  FCommonExtensions.Add('.mpg',  IMAGEINDEX_MIME_MEDIA_VIDEO);
  FCommonExtensions.Add('.mkv',  IMAGEINDEX_MIME_MEDIA_VIDEO);
  FCommonExtensions.Add('.flv',  IMAGEINDEX_MIME_MEDIA_VIDEO);
  FCommonExtensions.Add('.mp4',  IMAGEINDEX_MIME_MEDIA_VIDEO);
  FCommonExtensions.Add('.s3m',  IMAGEINDEX_MIME_MEDIA_VIDEO);
  FCommonExtensions.Add('.pdf',  IMAGEINDEX_MIME_DOC_PDF);
  FCommonExtensions.Add('.doc',  IMAGEINDEX_MIME_DOC_WORD);
  FCommonExtensions.Add('.docx', IMAGEINDEX_MIME_DOC_WORD);
  FCommonExtensions.Add('.xls',  IMAGEINDEX_MIME_DOC_EXCEL);
  FCommonExtensions.Add('.xlsx', IMAGEINDEX_MIME_DOC_EXCEL);
  FCommonExtensions.Add('.json', IMAGEINDEX_MIME_JSON);
  FCommonExtensions.Add('.xsd',  IMAGEINDEX_MIME_XSD);
  FCommonExtensions.Add('.bmp',  IMAGEINDEX_MIME_MEDIA_IMAGE);
  FCommonExtensions.Add('.jpg',  IMAGEINDEX_MIME_MEDIA_IMAGE);
  FCommonExtensions.Add('.jpeg', IMAGEINDEX_MIME_MEDIA_IMAGE);
  FCommonExtensions.Add('.png',  IMAGEINDEX_MIME_MEDIA_IMAGE);
  FCommonExtensions.Add('.tif',  IMAGEINDEX_MIME_MEDIA_IMAGE);
  FCommonExtensions.Add('.tiff', IMAGEINDEX_MIME_MEDIA_IMAGE);
  FCommonExtensions.Add('.tga',  IMAGEINDEX_MIME_MEDIA_IMAGE);
  FCommonExtensions.Add('.gif',  IMAGEINDEX_MIME_MEDIA_IMAGE);
  FCommonExtensions.Add('.pcx',  IMAGEINDEX_MIME_MEDIA_IMAGE);

finalization
  ImageContainer.Free;
  FCommonExtensions.Free;
end.
