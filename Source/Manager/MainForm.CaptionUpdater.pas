unit MainForm.CaptionUpdater;

interface

uses
     System.Classes, System.SysUtils, System.Variants, Data.DB,
     CustomControl.MiceAction,
     CustomControl.MiceActionList,
     Common.VariantComparator,
     Common.ResourceStrings,
     Common.Images,
     StaticDialog.MiceInputBox,
     DAC.xDataSet;

type
 TCaptionUpdater = class
   strict private
    FObjectId: Integer;
    FAppMainTreeId: Integer;
    FDBName: string;
    FiType: Integer;
    FCaption: string;
    function ShowDialog:Boolean;
    procedure SetiType(const Value: Integer);
   public
    property AppMainTreeId:Integer read FAppMainTreeId write FAppMainTreeId;
    property Caption:string read FCaption write FCaption;
    property iType:Integer read FiType write SetiType;
    property ObjectId:Integer read FObjectId write FObjectId;
    property DBName:string read FDBName write FDBName;
    function Execute:Boolean;
    procedure UpdateAppObjectCaption;

    class procedure UpdateAppMainTreeCaption(const AppMainTreeId: Integer; const NewCaption: string);
    class procedure UpdateTreeItemImageIndex(const AppMainTreeId, NewImageIndex:Integer);
    class procedure UpdateAppMainTreeUseOn(const AppMainTreeId: Integer; UseOnMainTree:Boolean);

    class function ExecuteDlg(const AppMainTreeId,ObjectId, iType:Integer; var CurrentCaption:string;const DBName:string):Boolean;
 end;

resourcestring
 S_ENTER_NEW_NAME ='Enter new name:';
 S_RENAME_ITEM ='Rename item';
 S_RENAME_ITEM_HINT ='Rename item and application object';
 S_CANNNOT_CHANGE_CAPTION = 'Cannot change caption for iType=%d';

implementation

{ TCaptionUpdater }


function TCaptionUpdater.Execute: Boolean;
const
 iTypeFolder = 0;
begin
 Result:=ShowDialog;
 if Result then
  begin
   if iType<>iTypeFolder then
    UpdateAppObjectCaption;
   UpdateAppMainTreeCaption(AppMainTreeId, Caption);
  end;
end;

class function TCaptionUpdater.ExecuteDlg(const AppMainTreeId, ObjectId, iType: Integer; var CurrentCaption:string; const DBName:string): Boolean;
var
 Updater:TCaptionUpdater;
begin
 Updater:=TCaptionUpdater.Create;
 try
  Updater.iType:=iType;
  Updater.AppMainTreeId:=AppMainTreeId;
  Updater.ObjectId:=ObjectId;
  Updater.Caption:=CurrentCaption;
  Updater.DBName:=DBName;
  Result:=Updater.Execute;
  if Result then
   CurrentCaption:=Updater.Caption;
 finally
  Updater.Free;
 end;

end;

procedure TCaptionUpdater.SetiType(const Value: Integer);
begin
 if Value in [0,1,2,3,7,9,11,12,13,14,15,16,17] then
  FiType := Value
   else
  raise Exception.CreateFmt(S_CANNNOT_CHANGE_CAPTION,[Value])
end;

function TCaptionUpdater.ShowDialog: Boolean;
var
 s:string;
begin
 s:=Caption;
 Result:=TMiceInputBox.Execute(IMAGEINDEX_ACTION_RENAME,s, S_ENTER_NEW_NAME, S_RENAME_ITEM);
 if Result then
   Caption:=s;
end;


procedure TCaptionUpdater.UpdateAppObjectCaption;
var
 DataSet:TxDataSet;
begin
 DataSet:=TxDataSet.Create(nil);
 try
  DataSet.DBName:=Self.DBName;
  DataSet.ProviderName:='spui_AppUpdateObjectCaption';
  DataSet.SetParameter('iType',iType);
  DataSet.SetParameter('Caption',Caption);
  DataSet.SetParameter('ObjectId',ObjectId);
  DataSet.Source:='TCaptionUpdater.UpdateAppObjectCaption';
  DataSet.Execute;
 finally
   DataSet.Free;
 end;

end;


class procedure TCaptionUpdater.UpdateTreeItemImageIndex(const AppMainTreeId,  NewImageIndex: Integer);
var
 DataSet:TxDataSet;
begin
DataSet:=TxDataSet.Create(nil);
 try
  DataSet.ProviderName:='spui_AppTreeUpdateItemImageIndex';
  DataSet.SetParameter('AppMainTreeId',AppMainTreeId);
  DataSet.SetParameter('ImageIndex',NewImageIndex);
  DataSet.Source:='TMainFormActions.UpdateTreeItemImageIndex';
  DataSet.Execute;
 finally
   DataSet.Free;
 end;
end;

class procedure TCaptionUpdater.UpdateAppMainTreeCaption(const AppMainTreeId: Integer; const NewCaption: string);
var
 DataSet:TxDataSet;
begin
DataSet:=TxDataSet.Create(nil);
 try
  DataSet.ProviderName:='spui_AppTreeUpdateItemCaption';
  DataSet.SetParameter('AppMainTreeId',AppMainTreeId);
  DataSet.SetParameter('Description',NewCaption);
  DataSet.Source:='TCaptionUpdater.UpdateAppMainTreeCaption';
  DataSet.Execute;
 finally
   DataSet.Free;
 end;
end;


class procedure TCaptionUpdater.UpdateAppMainTreeUseOn( const AppMainTreeId: Integer; UseOnMainTree: Boolean);
var
 DataSet:TxDataSet;
begin
DataSet:=TxDataSet.Create(nil);
 try
  DataSet.ProviderName:='spui_AppUpdateUseOnMainTree';
  DataSet.SetParameter('AppMainTreeId',AppMainTreeId);
  DataSet.SetParameter('UseOnMainTree',UseOnMainTree);
  DataSet.Source:='TCaptionUpdater.UpdateAppMainTreeUseOn';
  DataSet.Execute;
 finally
   DataSet.Free;
 end;
end;

end.
