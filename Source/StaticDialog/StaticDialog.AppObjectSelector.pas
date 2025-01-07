unit StaticDialog.AppObjectSelector;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Dialog.Basic, cxGraphics, Data.DB,
  cxLookAndFeels, cxLookAndFeelPainters, Vcl.Menus, Vcl.StdCtrls, cxButtons,
  Vcl.ExtCtrls, Vcl.ComCtrls, System.Generics.Collections, System.Generics.Defaults,
  cxControls, cxContainer, cxEdit, cxTextEdit, cxMaskEdit,
  cxDropDownEdit, cxImageComboBox,
  DAC.XDataSet,
  Common.Images,
  Common.ResourceStrings,
  StaticDialog.ItemSelector.Common,
  Common.VariantUtils, Vcl.WinXCtrls;

type

  TAppObjectSelectionDialog = class(TCommonItemSelectorDlg)
  public
    constructor Create(AOwner:TComponent); override;
    class function ExecuteDialog(iType:Integer; var ObjectId:Integer; var s:string):Boolean;
  end;

  TSysObjectSelectionDialog = class(TCommonItemSelectorDlg)
  public
    constructor Create(AOwner:TComponent); override;
    class function ExecuteDialog(iType:Integer; var ObjectId:Integer; var s:string; const DBName:string):Boolean;
  end;

implementation


{ TAppObjectSelectionDialog }

constructor TAppObjectSelectionDialog.Create(AOwner: TComponent);
begin
  inherited;
  DataSet.ProviderName:='spui_AppObjectList';
end;

class function TAppObjectSelectionDialog.ExecuteDialog(iType: Integer;  var ObjectId: Integer; var s: string): Boolean;
var
 Dlg:TAppObjectSelectionDialog;
begin
 Dlg:=TAppObjectSelectionDialog.Create(nil);
 try
  Dlg.DataSet.Params.SetParameter('iType',iType);
  Dlg.DataSet.Source:='TAppObjectSelectionDialog.ExecuteDialog';
  Result:=Dlg.Execute;
   if Result then
    begin
     ObjectId:=TVariantUtils.VarToIntDef(Dlg.KeyFieldValue,-1);
     s:=Dlg.CurrentObject.Caption;
    end;
 finally
   Dlg.Free;
 end;
end;

{ TSysObjectSelectionDialog }

constructor TSysObjectSelectionDialog.Create(AOwner: TComponent);
begin
  inherited;
  DataSet.ProviderName:='spsys_SysObjectList';
end;

class function TSysObjectSelectionDialog.ExecuteDialog(iType: Integer; var ObjectId: Integer; var s: string; const DBName: string): Boolean;
var
 Dlg:TSysObjectSelectionDialog;
resourcestring
 S_DLG_CAPTION_SELECT_OBJECT_FROM = 'Select object from %s';
begin
 Dlg:=TSysObjectSelectionDialog.Create(nil);
 try
  Dlg.DataSet.Params.SetParameter('iType',iType);
  Dlg.DataSet.Source:='TSysObjectSelectionDialog.ExecuteDialog';
  Dlg.DBName:=DBName;
  if DBName<>'' then
   Dlg.Caption:=Format(S_DLG_CAPTION_SELECT_OBJECT_FROM,[DBName]);
  Result:=Dlg.Execute;
   if Result then
    begin
     ObjectId:=TVariantUtils.VarToIntDef(Dlg.KeyFieldValue,-1);
     s:=Dlg.CurrentObject.Caption;
    end;
 finally
   Dlg.Free;
 end;
end;

end.
