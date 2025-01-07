{
 Импорт и экспрот мета-объектов(AppObject) Майс в сборку Json.
 Имеет вид:
 <Объект>
         <Таблица1>
          <Поля таблицы в формате ВэбАпи>
          ...
         <Таблица2>
          <Поля таблицы в формате ВэбАпи>
}
unit ImportExport.Manager;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  cxTL,Forms, Vcl.Controls,
  CustomControl.TreeGrid,
  System.IOUtils,
  Manager.WindowManager,
  Common.ResourceStrings,
  Common.StringUtils,
  DAC.XParams,
  DAC.XDataSet,
  StaticDialog.DBNameSelector,
  Dialog.MShowMessage,
  Dialog.ShowDataSet,
  DAC.DataSetList,
  DAC.Data.Convert,
  Data.DB,
  System.NetEncoding,  System.Generics.Collections,
  System.Generics.Defaults, System.JSON,
  ImportExport.Entity,
  ImportExport.Dialogs.ObjectSelection,
  ImportExport.Dialogs.LoadProgress,
  ImportExport.Dialogs.ImportConfirmation,
  Common.VariantUtils,
  ImportExport.ItemLists,
  ImportExport.StatisticList,

  Common.FormatSettings;


type
 TImportExportManager = class
   private
     FTree:TMiceTreeGrid;
     FDataTree:TxDataSet;
     FObjectIDs:TParentIdObjectList;
     FJson:TJsonValue;
     FExportJson:TJsonObject;
     FVersionInfo:TMiceITypeEntity;
     FExportClassList:TObjectList<TMiceITypeEntity>;
     FExportDialog:TAppObjectExportDlg;
     FStatisticList:TImportStatisticList;
     FDefaultDatasetState:Boolean;
     FGlobalDataSetList:TGlobalDataSetList;
     FGlobalUpdateList:TGlobalUpdateList;
     FLoadDlg: TLoadProgressForm;
     procedure HandleImportException(const ErrorMessage:string);
     procedure ImportCorrectJson(AJson:TJsonObject);
     procedure OnBuildAssemblyClick(Sender:TObject);
     procedure OnPreviewClick(Sender:TObject);
     procedure OnSaveAsClick(Sender:TObject);
     procedure CreateImportItem(const Name:string; jDataSets:TJsonObject);
     procedure TryImport(jRoot:TJsonObject);
     procedure DoImport(jRoot:TJsonObject);
     procedure AddToExport(Node: TcxTreeListNode);
     procedure RecursiveExport(Node:TcxTreeListNode);
     function ExecuteDialog:Boolean;
     function TryFindMeta(const JsonPath, Default:string; jObject:TJsonObject):string;
     procedure CheckAllImport;
   public
     procedure Init;
     procedure Import(const Json:string);
     procedure CreateExportPlan(Node: TcxTreeListNode);
     procedure ExportSingleNode(Node: TcxTreeListNode);
     procedure BuildAssembly;
     procedure ApplyUpdatesAll;
     constructor Create(Tree:TMiceTreeGrid);
     destructor Destroy; override;
     class function ExecuteExport(Tree:TMiceTreeGrid;Node: TcxTreeListNode) : Boolean;
     class function ExecuteExportCurrent(Tree:TMiceTreeGrid;Node: TcxTreeListNode) : Boolean;
     class procedure ExecuteImport(const FileName:string; Tree:TMiceTreeGrid);
 end;

implementation

function ShiftIsDown:Boolean;
var
  State: TKeyboardState;
begin
  GetKeyboardState(State);
  Result := ((State[VK_SHIFT] and 128) <> 0);
end;

{ TImportExportManager }


procedure TImportExportManager.CheckAllImport;
var
 Entity: TMiceITypeEntity;
begin
 for Entity in  FExportClassList do
  Entity.ImportCheck;
end;


constructor TImportExportManager.Create(Tree:TMiceTreeGrid);
begin
  FDataTree:=TxDataSet.Create(nil);
  FDataTree.ProviderName:='spui_AppMainTreeManager';
  FDataTree.Source:='TImportExportManager.Create';
  FTree:=Tree;
  FObjectIDs:=TParentIdObjectList.Create;
  FExportClassList:=TObjectList<TMiceITypeEntity>.Create;
  FVersionInfo:=TMiceITypeEntity.FindImportExportClass(_ITypeAppNameVersionManager).Create;
  FStatisticList:=TImportStatisticList.Create;
  FGlobalDataSetList:=TGlobalDataSetList.Create;
  FGlobalUpdateList:=TGlobalUpdateList.Create;
  FDefaultDatasetState:=False;
  if ShiftIsDown then
   FDefaultDatasetState:=True;

end;


function TImportExportManager.ExecuteDialog: Boolean;
begin
 FreeAndNil(FExportDialog);
 FExportDialog:=TAppObjectExportDlg.Create(nil);
 FExportDialog.AppObjectList:=Self.FExportClassList;
 FExportDialog.LoadState(True, True);
 FExportDialog.Build;
 FExportDialog.bnPreview.OnClick:=Self.OnPreviewClick;
 FExportDialog.bnBuild.OnClick:=Self.OnBuildAssemblyClick;
 FExportDialog.bnOK.OnClick:=Self.OnSaveAsClick;
 Result:=FExportDialog.ShowModal=mrOk;
 if Result then
  FExportDialog.SaveState;
end;

procedure TImportExportManager.CreateExportPlan(Node: TcxTreeListNode);
begin
 Self.FTree.BeginUpdate;
 try
  Self.RecursiveExport(Node);
 finally
  Self.FTree.EndUpdate;
 end;
end;

procedure TImportExportManager.CreateImportItem(const Name: string; jDataSets: TJsonObject);
var
 AClass:TMiceITypeEntity;
begin
 AClass:=TMiceITypeEntity.FindImportExportClass(Name).Create;
 Self.FExportClassList.Add(AClass);
 AClass.StatisticList:=Self.FStatisticList;
 AClass.JsonDataSets:=jDataSets;
 AClass.ObjectIDs:=FObjectIDs;
 AClass.GlobalDataSetList:=Self.FGlobalDataSetList;
 AClass.GlobalUpdateList:=Self.FGlobalUpdateList;
 AClass.ImportJsonDataSets;
end;

destructor TImportExportManager.Destroy;
begin
  FDataTree.Free;
  FObjectIDs.Free;
  FJson.Free;
  FExportJson.Free;
  FExportClassList.Free;
  FVersionInfo.Free;
  FExportDialog.Free;
  FStatisticList.Free;
  FGlobalDataSetList.Free;
  FGlobalUpdateList.Free;
  FLoadDlg.Free;
  inherited;
end;

procedure TImportExportManager.DoImport(jRoot:TJsonObject);
var
 Name:string;
 jObject:TJsonObject;
 x:Integer;
begin
 for x:=0 to jRoot.Count-1 do
  begin
   Name:=jRoot.Pairs[x].JsonString.Value;
   jObject:=jRoot.Pairs[x].JsonValue as TJsonObject;
   CreateImportItem(Name, jObject);

   FLoadDlg.AddText(TryFindMeta(MetaDataItemPath,Name,jObject),0);
   FLoadDlg.SetProgress(x,jRoot.Count-1);
  end;
end;

class function TImportExportManager.ExecuteExport(Tree:TMiceTreeGrid; Node: TcxTreeListNode): Boolean;
var
 Mngr: TImportExportManager;
begin
 Mngr:=TImportExportManager.Create(Tree);
  try
   Mngr.Init;
   Mngr.CreateExportPlan(Node);
   Result:=Mngr.ExecuteDialog;
  finally
   Mngr.Free;
  end;
end;


class function TImportExportManager.ExecuteExportCurrent(Tree: TMiceTreeGrid; Node: TcxTreeListNode): Boolean;
var
 Mngr: TImportExportManager;
begin
 Mngr:=TImportExportManager.Create(Tree);
  try
   Mngr.Init;
   Mngr.ExportSingleNode(Node);
   Result:=Mngr.ExecuteDialog;
  finally
   Mngr.Free;
  end;
end;

class procedure TImportExportManager.ExecuteImport(const FileName:string; Tree:TMiceTreeGrid);
var
 Mngr: TImportExportManager;
begin
  Mngr:=TImportExportManager.Create(Tree);
  try
   Mngr.Init;
   Mngr.Import(TFile.ReadAllText(FileName, TEncoding.UTF8));
  finally
   Mngr.Free;
  end;
end;

procedure TImportExportManager.ExportSingleNode(Node: TcxTreeListNode);
begin
 Self.AddToExport(Node);
end;


procedure TImportExportManager.HandleImportException(const ErrorMessage: string);
begin
 FLoadDlg.Close;
 FLoadDlg.AddText(ErrorMessage,1);
 FLoadDlg.ShowModal;
end;

procedure TImportExportManager.ApplyUpdatesAll;
var
 G:TGlobalUpdateList;
begin
 G:=FGlobalUpdateList;
 G.CalculateTotal;
 G.ProgressForm:=FLoadDlg;
 Self.FLoadDlg.Show;


 G.ApplyUpdates('AppMainTree');
 G.ApplyUpdates('AppScripts');
 G.ApplyUpdates('AppTemplates');
 G.ApplyUpdates('AppTemplatesData');
 G.ApplyUpdates('AppTemplatesDataSets');

 G.ApplyUpdates('AppPlugins');
 G.ApplyUpdates('AppDialogs');
 G.ApplyUpdates('AppDialogControls');
 G.ApplyUpdates('AppDialogDetailTables');
 G.ApplyUpdates('AppDialogsLayout');
 G.ApplyUpdates('AppDialogsLayoutFlags');
 G.ApplyUpdates('AppColumns');
 G.ApplyUpdates('AppGridColors');
 G.ApplyUpdates('AppCmd');
 G.ApplyUpdates('AppCmdParams');
 G.ApplyUpdates('AppPluginsCommonCmd');

 G.ApplyUpdates('dfClasses');
 G.ApplyUpdates('dfTypes');
 G.ApplyUpdates('dfPathFolders');
 G.ApplyUpdates('dfPathFolderActions');
 G.ApplyUpdates('dfPathFolderRules');
 G.ApplyUpdates('dfMethods');

 G.ApplyDelete(G.DeleteQueueDfMethods); //Delete methods first
 G.ApplyDelete(G.DeleteQueueDfPathFolders); //Delete pathfolders second


 G.ApplyUpdates('AppDataSets');
 G.ApplyUpdates('AppBinaryFiles');
end;

procedure TImportExportManager.BuildAssembly;
var
  ExportClass:TMiceITypeEntity;
  x:Integer;
begin
 FreeAndNil(FExportJson);
 FExportJson:=TJsonObject.Create;

 FVersionInfo.DoExport(FExportJson);

 for x:=0 to FExportClassList.Count-1 do
  begin
   ExportClass:=FExportClassList[x];
   ExportClass.DoExport(Self.FExportJson);
   Self.FExportDialog.SetProgress(x,FExportClassList.Count-1);
  end;
end;

procedure TImportExportManager.AddToExport(Node: TcxTreeListNode);
var
 ExportClass:TMiceITypeEntity;
 AppName:string;
 ParentId:Variant;
begin
 AppName:=TMiceITypeEntity.iTypeToAppName(Node.Values[ColIndex_iType]);
 ExportClass:=TMiceITypeEntity.FindImportExportClass(AppName).Create;
 FExportClassList.Add(ExportClass);
 ExportClass.ObjectId:=Node.Values[ColIndex_ObjectId];
 ExportClass.AppMainTreeId:=Node.Values[ColIndex_AppMainTreeId];
 ExportClass.Caption:=Node.Values[ColIndex_Caption];
 ExportClass.DBName:=VarToStr(Node.Values[ColIndex_DBName]);
 ExportClass.AppMainTreePath:=FTree.PathTo(Node);
 ExportClass.DefaultDatasetState:=FDefaultDatasetState;

 if Assigned(Node.Parent) then
  ParentId:=Node.Parent.Values[ColIndex_ObjectId]
   else
  ParentId:=0;

 if VarIsNull(ParentId) then
  ParentId:=0;

 ExportClass.ObjectIdParent:=ParentId;
 ExportClass.Populate;
end;


procedure TImportExportManager.RecursiveExport(Node: TcxTreeListNode);
var
 ANode:TcxTreeListNode;
 X:Integer;
begin
 if TMiceITypeEntity.CanExportIType(Node.Values[ColIndex_iType]) then
  begin
  Self.AddToExport(Node);
  if Node.HasChildren then
   for x:=0 to Node.Count-1 do
     begin
      ANode:=Node.Items[x];
      RecursiveExport(ANode);
     end;
  end;
end;

function TImportExportManager.TryFindMeta(const JsonPath, Default: string; jObject: TJsonObject): string;
begin
 if Assigned(jObject) and (jObject.TryGetValue(JsonPath, Result)=False) then
  Result:=Default;
end;

procedure TImportExportManager.TryImport(jRoot: TJsonObject);
begin
 try
  ImportCorrectJson(jRoot);
 except on E:Exception do
  HandleImportException(E.Message);
 end;

 end;

procedure TImportExportManager.Import(const Json: string);
begin
 if not Assigned(FLoadDlg) then
  FLoadDlg:=TLoadProgressForm.Create(nil);
 FLoadDlg.Show;

 FJson.Free;
 FJson:=TJSONValue.ParseJSONValue(Json);

 if Assigned(FJson) and (FJson is TJsonObject) then
  TryImport(FJson as TJsonObject)
   else
  raise Exception.Create(E_INVALID_JSON);
end;

procedure TImportExportManager.ImportCorrectJson(AJson: TJsonObject);
resourcestring
 S_IMPORT_FINISHED = 'Import process completed successfully.';
begin
 DoImport(FJson as TJsonObject);
 CheckAllImport;

 if TImportConfirmDialog.Execute(Self.FStatisticList) then
  begin
   Self.ApplyUpdatesAll;
   MessageBox(Application.Handle,PChar(S_IMPORT_FINISHED),PChar(S_COMMON_INFORMATION),MB_OK+MB_ICONINFORMATION);
  end;
end;

procedure TImportExportManager.Init;
begin
 FDataTree.Open;
 FObjectIDs.LoadFromDataSet(FDataTree,'AppMainTree','AppMainTreeId');
end;

procedure TImportExportManager.OnBuildAssemblyClick(Sender: TObject);
begin
 FExportDialog.Start;
 BuildAssembly;
 FExportDialog.Finish;
end;

procedure TImportExportManager.OnPreviewClick(Sender: TObject);
begin
 MShowMessage(FExportJson.Format());
end;

procedure TImportExportManager.OnSaveAsClick(Sender: TObject);
var
 s:string;
begin
 if FExportDialog.ExportDialog.Execute(FExportDialog.Handle) then
  begin
   s:=FExportDialog.ExportDialog.FileName;
   if not s.ToLower.EndsWith('.json') then
    s:=s+'.json';
   TFile.WriteAllText(s,FExportJson.Format, TEncoding.UTF8);
   FExportDialog.bnCancel.ModalResult:=mrOk;
  end
   else
  FExportDialog.bnCancel.ModalResult:=mrCancel;
end;

end.
