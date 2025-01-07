unit CustomControl.MiceVerticalGrid;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxStyles, cxEdit, cxInplaceContainer, cxVGrid,
  cxDBVGrid, Data.DB,
  CustomControl.AppObject,
  Common.ResourceStrings,
  Common.Images,
  DAC.XParams,
  DAC.XDataSet,
  DAC.DataSetList,
  Mice.Script,
  CustomControl.Interfaces,
  CustomControl.MiceGrid.ColorBuilder,
  CustomControl.MiceActionList;


type
 TMiceVericalGrid = class(TcxDBVerticalGrid, IHaveScriptSupport, ICanInitFromJson, IAmLazyControl, IHaveDataBinding, IHaveColumns)
  private
    FScript: TMiceScripter;
    FDataSet: TxDataSet;
    FDataSource: TDataSource;
    FParentDBName: string;
    FAppDialogControlsId: Integer;
    function GetAppDialogControlsId: Integer;
    procedure SetAppDialogControlsId(const Value: Integer);
    function GetIDataSource:TDataSource;
    function GetIDataField:string;
    procedure SetIDataSource(const Value:TDataSource);
    procedure SetIDataField(const Value:string);
 public
    procedure InitFromJson(const Json:string);
    procedure InitFromParams(Params:TxParams);
    procedure RegisterScripter(Scripter:TMiceScripter);
    procedure LazyInit(ParentObject: IInheritableAppObject);
    procedure RefreshDataSet;
    procedure BuildColumns(const AppDialogControlsId:Integer; BuildRightNow: Boolean);
    constructor Create(AOwner:TComponent); override;
    destructor Destroy; override;
    class function DevDescription:string;
 published
    property AppDialogControlsId:Integer read GetAppDialogControlsId write SetAppDialogControlsId;
    property DataSet:TxDataSet read FDataSet;
    property ParentDBName:string read FParentDBName write FParentDBName;
 end;

implementation

{ TMiceVericalGrid }

procedure TMiceVericalGrid.BuildColumns(const AppDialogControlsId: Integer;  BuildRightNow: Boolean);
begin
 (Add(TcxDBEditorRow) as TcxDBEditorRow).Properties.Caption:='Hello';
 (Add(TcxCategoryRow) as TcxDBEditorRow).Properties.Caption:='World!';
end;

constructor TMiceVericalGrid.Create(AOwner: TComponent);
begin
  inherited;
  FDataSet:=TxDataSet.Create(Self);
  FDataSource:=TDataSource.Create(Self);
  FDataSource.DataSet:=FDataSet;
end;

destructor TMiceVericalGrid.Destroy;
begin

  inherited;
end;

class function TMiceVericalGrid.DevDescription: string;
resourcestring
 S_DevDescription_TMiceVericalGrid = 'Allows to create grid where each row represents a datafield. Allows to group those fields.';
begin
 Result:= S_DevDescription_TMiceVericalGrid;
end;

function TMiceVericalGrid.GetAppDialogControlsId: Integer;
begin
 Result:=FAppDialogControlsId;
end;

function TMiceVericalGrid.GetIDataField: string;
begin
  Result:=''
end;

procedure TMiceVericalGrid.SetIDataField(const Value: string);
begin

end;


function TMiceVericalGrid.GetIDataSource: TDataSource;
begin
 Result:=Self.DataController.DataSource;
end;

procedure TMiceVericalGrid.InitFromJson(const Json: string);
var
 App:TMiceAppObject;
begin
 App:=TMiceAppObject.Create;
 try
  App.AsJson:=Json;
  InitFromParams(App.Params);
 finally
  App.Free;
 end;
end;

procedure TMiceVericalGrid.InitFromParams(Params: TxParams);
begin

end;

procedure TMiceVericalGrid.LazyInit(ParentObject: IInheritableAppObject);
begin

end;

procedure TMiceVericalGrid.RefreshDataSet;
begin

end;

procedure TMiceVericalGrid.RegisterScripter(Scripter: TMiceScripter);
begin
 FScript:=Scripter;
end;

procedure TMiceVericalGrid.SetAppDialogControlsId(const Value: Integer);
begin
 FAppDialogControlsId:=Value;
end;

procedure TMiceVericalGrid.SetIDataSource(const Value: TDataSource);
begin
 DataController.DataSource:=Value;
end;


initialization
 //TMiceScripter.RegisterClassEventOnClick(TMiceTextEdit.ClassName);
// TMiceScripter.RegisterClassEventOnChange(TMiceTextEdit.ClassName);


// TClassEventsTree.DefaultInstance.RegisterClassPropertyInteger(TMiceTextEdit.ClassName,'MaxDropDownItems', S_PROP_DESC_MICETEXTEDIT_MAXDROPDOWNITEMS);



end.
