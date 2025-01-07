unit CustomControl.MiceGrid;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  cxGraphics, cxControls, cxLookAndFeels, cxLookAndFeelPainters, cxStyles, cxCustomData, cxFilter,
  cxData, cxDataStorage, Data.DB, cxDBData, cxGridLevel,
  cxClasses, cxGridCustomView, cxGridCustomTableView, cxGridTableView,
  cxGridDBTableView, cxGrid, cxGridDBDataDefinitions,cxGridDbBandedTableView,
  ClipBrd,
  Common.Images,
  Vcl.Dialogs,
  CustomControl.MiceGrid.ColorBuilder,
  CustomControl.Interfaces,
  Common.ResourceStrings,
  DAC.XDataSet;

type
 TMiceGrid = class(TcxGrid, IAmLazyControl)
  private
    FMiceGridColors: TMiceGridColors;
    FDBName: string;
    FParentObject: IInheritableAppObject;
    FFindDlg: TFindDialog;
    FLastRow:Integer;
    FLastColumn:Integer;
    FMainView: TcxGridDBBandedTableView;
    function GetFindDialog: TFindDialog;
  protected
    property FindDlg:TFindDialog read GetFindDialog;
    procedure FocusCell(x,y:Integer);
    procedure OnFindExecute(Sender:TObject);
    procedure ViewKeyDown(Sender: TObject; var Key: Word;  Shift: TShiftState);
    procedure ViewChanged(Sender: TcxCustomGrid;  APrevFocusedView, AFocusedView: TcxCustomGridView);
    procedure RefreshDataSet;
    function CellContainText(x, y: Integer; const ASearchText:string):Boolean;
  public
    constructor Create(AOwner:TComponent); override;
    destructor Destroy; override;
    procedure ClearColumns(AView:TcxGridDBBandedTableView);
    procedure FindItem;
    procedure LazyInit(ParentObject: IInheritableAppObject);
    property MiceGridColors:TMiceGridColors read FMiceGridColors;
  published
    property DBName:string read FDBName write FDBName;
 end;

implementation


{ TMiceGrid }


function TMiceGrid.CellContainText(x, y: Integer; const ASearchText:string): Boolean;
var
 CellStr:string;
 AIndex:Integer;
begin
 AIndex:=Self.FMainView.VisibleColumns[y].Index;
 CellStr:=VarToStr(FMainView.DataController.Values[x,AIndex]).ToLower;
 Result:=CellStr.Contains(ASearchText);
end;

procedure TMiceGrid.ClearColumns(AView:TcxGridDBBandedTableView);
var
 x:Integer;
begin
 for x:=AView.ColumnCount-1 downto 0 do
   AView.Columns[x].Free;
end;

constructor TMiceGrid.Create(AOwner: TComponent);
begin
  inherited;
  FMiceGridColors:=TMiceGridColors.Create;
  OnFocusedViewChanged:=ViewChanged;
end;

destructor TMiceGrid.Destroy;
begin
  FMiceGridColors.Free;
  inherited;
end;

procedure TMiceGrid.FindItem;
resourcestring
 E_VIEW_NOT_FOUND = 'No active view found.';
begin
 if not Assigned(FMainView) then
  raise Exception.Create(E_VIEW_NOT_FOUND);

 FLastRow:=FMainView.Controller.FocusedRowIndex;
 FLastColumn:=FMainView.Controller.FocusedColumnIndex;
 FindDlg.Execute(Handle)
end;

procedure TMiceGrid.FocusCell(x, y:Integer);
var
 RecordIndex:Integer;
begin
 RecordIndex:=FMainView.ViewData.Rows[x].RecordIndex;
 FMainView.Controller.FocusedRowIndex:=RecordIndex;
 FMainView.Controller.FocusedColumnIndex:=y;
 FMainView.ViewData.Rows[RecordIndex].Selected:=True;
end;

function TMiceGrid.GetFindDialog: TFindDialog;
begin
if not Assigned(FFindDlg) then
  begin
   FFindDlg:=TFindDialog.Create(Self);
   FFindDlg.OnFind:=OnFindExecute;
   FFindDlg.Options:=[frDown, frHideWholeWord, frDisableMatchCase];
  end;
 Result:=FFindDlg;
end;

procedure TMiceGrid.LazyInit(ParentObject: IInheritableAppObject);
var
 Ctr:TcxGridDBDataController;
 DataSet:TxDataSet;
begin
if Assigned(FParentObject) and (DBName.IsEmpty) then
   DBName:=FParentObject.DBName;

 if Assigned(ActiveView) and (ActiveView.DataController is TcxGridDBDataController)then
  begin
   Ctr:=(ActiveView.DataController as TcxGridDBDataController);
   if Assigned(Ctr.DataSource) and Assigned(Ctr.DataSource.DataSet) then
    begin
     DataSet:=Ctr.DataSource.DataSet as TxDataSet;
     DataSet.DBName:=DBName;
     DataSet.Open;
    end;

  end;
end;

procedure TMiceGrid.OnFindExecute(Sender: TObject);
var
 x:Integer;
 y:Integer;
 ASearchText:string;
begin
 ASearchText:=FindDlg.FindText.ToLower;

 for x:=FLastRow to FMainView.ViewData.RowCount-1 do
  for y:=FLastColumn to FMainView.VisibleColumnCount-1 do
   if CellContainText(x, y, ASearchText) then
    begin
     FocusCell(x,y);

    if x>FMainView.DataController.DataRowCount-1  then
     FLastRow:=0
      else
     FLastRow:=x;

    if y>=FMainView.VisibleColumnCount-1 then
      FLastColumn:=0
       else
      FLastColumn:=y+1;

     Exit;
     end
    else
     FLastColumn:=0;

  MessageBox(FindDlg.Handle,PChar(Format(S_COMMON_CANNOT_FIND_TEXT_FMT,[FindDlg.FindText])), PCHar(S_COMMON_INFORMATION), MB_OK+MB_ICONINFORMATION);
end;

procedure TMiceGrid.RefreshDataSet;
begin

end;

procedure TMiceGrid.ViewChanged(Sender: TcxCustomGrid; APrevFocusedView, AFocusedView: TcxCustomGridView);
begin
 if AFocusedView is TcxGridDBBandedTableView then
  begin
   FMainView:=AFocusedView as TcxGridDBBandedTableView;
   FMainView.OnKeyDown:=ViewKeyDown;
  end;
end;

procedure TMiceGrid.ViewKeyDown(Sender: TObject; var Key: Word;  Shift: TShiftState);
begin
 if (ssCtrl in Shift)   then
  begin
   if (Key=Ord('F')) then
    begin
     FindItem;
     Key:=0;
    end
   else
   if (Key=VK_INSERT) or (Key=Ord('C')) then
    begin
     Clipboard.AsText := VarToStr(FMainVIew.Controller.FocusedColumn.EditValue);
     Key:=0;
    end;
  end;
end;

end.
