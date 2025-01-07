unit Plugin.InfoDialog;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Dialog.Basic, cxGraphics,
  cxLookAndFeels, cxLookAndFeelPainters, Vcl.Menus, Vcl.StdCtrls, cxButtons,
  Vcl.ExtCtrls, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, cxControls, cxContainer,
  cxEdit, cxTextEdit, cxMemo,  System.Generics.Collections, dxBar,
  Plugin.Properties,
  CustomControl.Interfaces,
  DAC.XParams,
  CustomControl.MiceGrid.ColorBuilder,
  Plugin.Container, cxStyles, cxCustomData, cxFilter, cxData, cxDataStorage,
  cxNavigator, dxDateRanges, cxDBData, cxGridCustomTableView, cxGridTableView,
  cxGridDBTableView, cxGridLevel, cxClasses, cxGridCustomView, cxGrid,
  dxBarBuiltInMenu, cxPC;

type
  TPluginInfoDialog = class(TBasicDialog)
    DataSource1: TDataSource;
    ControlsTable: TFDMemTable;
    ControlsTableName: TStringField;
    ControlsTableCaption: TStringField;
    ControlsTableClassName: TStringField;
    ControlsTableAppCmdId: TIntegerField;
    ControlsTableCurrentValue: TStringField;
    cxPageControl1: TcxPageControl;
    cxTabSheet1: TcxTabSheet;
    cxTabSheet2: TcxTabSheet;
    cxGrid1: TcxGrid;
    InfoView: TcxGridDBTableView;
    InfoViewAppCmdId: TcxGridDBColumn;
    InfoViewName: TcxGridDBColumn;
    InfoViewCaption: TcxGridDBColumn;
    InfoViewClassName: TcxGridDBColumn;
    InfoViewCurrentValue: TcxGridDBColumn;
    cxGrid1Level1: TcxGridLevel;
    memInfo: TcxMemo;
    cxTabSheet3: TcxTabSheet;
    procedure InfoViewCustomDrawCell(Sender: TcxCustomGridTableView;
      ACanvas: TcxCanvas; AViewInfo: TcxGridTableDataCellViewInfo;
      var ADone: Boolean);
  private
    procedure PopulateMemoWithControls(List:TList<TdxBarItem>);
    function ItemToString(Item:TdxBarItem):string;
  public
    constructor Create(AOwner:TComponent); override;
    procedure Load(Properties:TPluginProperties);
    procedure LoadItems(Container: TPluginContainer);
  end;

implementation

{$R *.dfm}

{ TPluginInfoDialog }

constructor TPluginInfoDialog.Create(AOwner: TComponent);
begin
  inherited;
  ReadOnly:=True;
end;

procedure TPluginInfoDialog.InfoViewCustomDrawCell(
  Sender: TcxCustomGridTableView; ACanvas: TcxCanvas;
  AViewInfo: TcxGridTableDataCellViewInfo; var ADone: Boolean);
begin
  TMiceGridColors.DefaultDrawGridCell(Sender,ACanvas, AViewInfo, ADone);
end;

function TPluginInfoDialog.ItemToString(Item: TdxBarItem): string;
var
 Params:TxParams;
begin
 Result:='';
 if Supports(Item,ICanManageParams) then
  begin
   Params:=TxParams.Create;
    try
     (Item as ICanManageParams).SetParamsTo(Params);
     Result:=Params.ToString;
    finally
     Params.Free;
    end;
  end;
end;

procedure TPluginInfoDialog.Load(Properties: TPluginProperties);
resourcestring
 S_PLUGININFO_TITLE_FMT = 'Title: %s';
 S_PLUGININFO_DETAIL_TITLE_FMT = 'Detail title : %s';
 S_PLUGININFO_PAGETITLE_FMT = 'Page title (Title+DetailTitle) : %s';
 S_PLUGININFO_KEYFIELD_FMT = 'KeyField: %s';
 S_PLUGININFO_PARENTID_FIELD_FMT = 'ParentId Field: %s';
 S_PLUGININFO_PARAMS_FMT = 'Parameters : %s';

begin
 memInfo.Lines.Add(Format(S_PLUGININFO_TITLE_FMT,[Properties.Title]));
 memInfo.Lines.Add(Format(S_PLUGININFO_DETAIL_TITLE_FMT,[Properties.DetailTitle]));
 memInfo.Lines.Add(Format(S_PLUGININFO_PAGETITLE_FMT,[Properties.PageTitle]));

 memInfo.Lines.Add('');
 memInfo.Lines.Add(Format(S_PLUGININFO_KEYFIELD_FMT,[Properties.KeyField]));
 memInfo.Lines.Add(Format(S_PLUGININFO_PARENTID_FIELD_FMT,[Properties.ParentIdField]));

 memInfo.Lines.Add('');
 memInfo.Lines.Add(Format(S_PLUGININFO_PARAMS_FMT,[Properties.Params.AsString]));
end;

procedure TPluginInfoDialog.LoadItems(Container: TPluginContainer);
var
 List:TList<TdxBarItem>;
begin
 List:=TList<TdxBarItem>.Create;
 try
  Container.AllControlsToList(List);
  PopulateMemoWithControls(List);
 finally
  List.Free;
 end;
end;

procedure TPluginInfoDialog.PopulateMemoWithControls(List:TList<TdxBarItem>);
var
 Item:TdxBarItem;
begin
 ControlsTable.Open;
 for Item in List do
  begin
   ControlsTable.Append;
   ControlsTable.FieldByName('AppCmdId').AsInteger:=Item.Tag;
   ControlsTable.FieldByName('Name').AsString:=Item.Name;
   ControlsTable.FieldByName('ClassName').AsString:=Item.ClassName;
   ControlsTable.FieldByName('Caption').AsString:=Item.Caption;
   ControlsTable.FieldByName('CurrentValue').AsString:=ItemToString(Item);
   ControlsTable.Post;
  end;

//  memInfo.Lines.Add(Item.Name+''+Item.Caption);
end;

end.
