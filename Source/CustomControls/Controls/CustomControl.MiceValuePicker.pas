unit CustomControl.MiceValuePicker;

interface
uses SysUtils, Windows, Messages, Classes, Controls, StdCtrls,
     cxButtonEdit, Data.DB, Vcl.DbCtrls, System.Variants,
     Mice.Script,
     DAC.XDataSet,
     DAC.XParams.Mapper,
     CustomControl.AppObject,
     CustomControl.Interfaces,
     CustomControl.MiceValuePicker.Base,
     CustomControl.MiceValuePicker.SelectItemDlg,
     CustomControl.MiceValuePicker.SelectTreeDlg,
     CustomControl.MiceValuePicker.SelectGridDlg;


type
  TMiceValuePicker = class(TMiceValuePickerBase)
  private
    function ExecuteTreeDialog:Boolean;
    function ExecuteItemDialog:Boolean;
    function ExecuteGridDialog:Boolean;
    procedure InitTreeDialog(Dlg:TVPickSelectTreeDialog);
    procedure InitItemDialog(Dlg:TVPickSelectItemDialog);
    procedure InitGridDialog(Dlg:TVPickSelectGridDialog);
 protected
    procedure CheckBindings; override;
    procedure Load(AppObject:TMiceAppObject); override;
  public
    class function DevDescription:string;
    function ExecuteDialog:Boolean;override;
    constructor Create(AOwner:TComponent); override;
    destructor Destroy; override;
  end;
implementation

{ TMiceValuePicker }


procedure TMiceValuePicker.CheckBindings;
begin
 inherited;
 if (Settings.ParentIdField.Trim.IsEmpty) and (Settings.DialogType=0) then
  raise Exception.CreateFmt(E_VPICK_FIELD_NOT_DEFINED_FMT,['ParentIdField', Name]);
end;


constructor TMiceValuePicker.Create(AOwner: TComponent);
begin
  inherited;

end;

destructor TMiceValuePicker.Destroy;
begin
  inherited;

end;

class function TMiceValuePicker.DevDescription: string;
resourcestring
 S_DevDescription_TMiceValuePicker = 'Allows to represent any Id to user-friendly text. Can show one of three dialog types (Item/Tree-Based/Grid) with ability to pick(change) this id.'+
                                     'Stored procedure is required to convert id to text.Repopulates automatically if any of provider-depended fields changed.';
begin
 Result:= S_DevDescription_TMiceValuePicker;
end;

function TMiceValuePicker.ExecuteDialog: Boolean;
begin
 case Settings.DialogType of
  0:Result:=ExecuteTreeDialog;
  1:Result:=ExecuteItemDialog;
  2:Result:=ExecuteGridDialog;
   else
    raise Exception.CreateFmt(E_VPICK_UNKNOWN_DIALOG_TYPE_FMT,[Settings.DialogType]);
 end;
end;

function TMiceValuePicker.ExecuteGridDialog: Boolean;
var
 Dlg:TVPickSelectGridDialog;
begin
 Dlg:=TVPickSelectGridDialog.Create(nil);
 try
  InitGridDialog(Dlg);
  Result:=Dlg.Execute;
   if Result then
    begin
     FKeyFieldValue:=Dlg.KeyFieldValue;
     UpdateDataField;
     UpdateText(FKeyFieldValue);
    end;
 finally
  Dlg.Free;
 end;
end;


function TMiceValuePicker.ExecuteItemDialog: Boolean;
var
 Dlg:TVPickSelectItemDialog;
begin
 Dlg:=TVPickSelectItemDialog.Create(nil);
 try
  InitItemDialog(Dlg);
  Result:=Dlg.Execute;
   if Result then
    begin
     FKeyFieldValue:=Dlg.KeyFieldValue;
     UpdateDataField;
     UpdateText(FKeyFieldValue);
    end;
 finally
  Dlg.Free;
 end;
end;

function TMiceValuePicker.ExecuteTreeDialog: Boolean;
var
 Dlg:TVPickSelectTreeDialog;
begin
 Dlg:=TVPickSelectTreeDialog.Create(nil);
 try
  InitTreeDialog(Dlg);
  Result:=Dlg.Execute;
   if Result then
    begin
     FKeyFieldValue:=Dlg.KeyFieldValue;
     UpdateDataField;
     UpdateText(FKeyFieldValue);
    end;
 finally
  Dlg.Free;
 end;
end;

procedure TMiceValuePicker.InitGridDialog(Dlg: TVPickSelectGridDialog);
begin
 Dlg.AppDialogControlsId:=AppDialogControlsId;
 Dlg.KeyField:=Settings.KeyField;
 Dlg.DataSet.ProviderNamePattern:=Settings.DialogProviderName;
 Dlg.AppDialogControlsIdTargetGrid:=Settings.AppDialogControlsIdTargetGrid;
 Dlg.KeyFieldValue:=Self.KeyFieldValue;
 Dlg.EnabledField:=Settings.EnabledField;
 Dlg.EnabledValue:=Settings.EnabledValue;
 Dlg.DataSet.Source:='TMiceValuePicker.InitGridDialog';

 if Assigned(FParentObject) and Assigned(FParentObject.ParamsMapper) then
   FParentObject.ParamsMapper.MapDataSet(Dlg.DataSet);
end;

procedure TMiceValuePicker.InitItemDialog(Dlg: TVPickSelectItemDialog);
begin
 Dlg.AppDialogControlsId:=AppDialogControlsId;
 Dlg.KeyField:=Settings.KeyField;
 Dlg.KeyFieldValue:=Self.KeyFieldValue;
 Dlg.CaptionField:=Settings.CaptionField;
 Dlg.ImageIndexField:=Settings.ImageIndexField;
 Dlg.DataSet.ProviderNamePattern:=Settings.DialogProviderName;
 Dlg.DataSet.Source:='TMiceValuePicker.InitItemDialog';

 if Assigned(FParentObject) and Assigned(FParentObject.ParamsMapper) then
   FParentObject.ParamsMapper.MapDataSet(Dlg.DataSet);
end;

procedure TMiceValuePicker.InitTreeDialog(Dlg: TVPickSelectTreeDialog);
begin
  Dlg.AppDialogControlsId:=AppDialogControlsId;
  Dlg.TreeView.DataSet.DBName:=DBName;
  Dlg.CaptionField:=Settings.CaptionField;
  Dlg.EnabledField:=Settings.EnabledField;
  Dlg.EnabledValue:=Settings.EnabledValue;
  Dlg.KeyField:=Settings.KeyField;
  Dlg.ParentIdField:=Settings.ParentIdField;
  Dlg.KeyFieldValue:=KeyFieldValue;
  Dlg.ExpandLevel:=Settings.ExpandLevel;
  Dlg.TreeView.DataSet.ProviderName:=Settings.DialogProviderName;
  Dlg.TreeView.DataSet.ProviderNamePattern:=Settings.DialogProviderName;
  Dlg.TreeView.DataSet.Source:='TMiceValuePicker.InitTreeDialog';

  if Assigned(FParentObject) and Assigned(FParentObject.ParamsMapper) then
   FParentObject.ParamsMapper.MapDataSet(Dlg.TreeView.DataSet);
end;


procedure TMiceValuePicker.Load(AppObject: TMiceAppObject);
begin
 Settings.LoadFromParams(AppObject.Params);
end;

initialization
 TMiceScripter.RegisterClassEventOnClick(TMiceValuePicker.ClassName);
 TMiceScripter.RegisterClassEventOnChange(TMiceValuePicker.ClassName);


end.
