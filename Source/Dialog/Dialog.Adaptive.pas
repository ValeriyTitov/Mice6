unit Dialog.Adaptive;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Dialog.Layout, cxGraphics,
  cxLookAndFeels, cxLookAndFeelPainters, Vcl.Menus, cxControls, Data.DB,
  cxClasses, dxLayoutContainer, dxLayoutControl, Vcl.StdCtrls, cxButtons,
  System.Generics.Collections,
  Vcl.ExtCtrls,
  DAC.XDataSet,
  Mice.Script,
  CustomControl.Interfaces,
  Dialog.Adaptive.ControlFlags,
  Common.ResourceStrings,
  Common.VariantComparator,
  Dialog.Adaptive.FieldMonitor,
  Dialog.Adaptive.Helper;

type
  TAdaptiveDialog = class(TBasicLayoutDialog)
    procedure bnOKClick(Sender: TObject);
    procedure MainSourceDataChange(Sender: TObject; Field: TField);
  private
    FScriptInitializeed:Boolean;
    FHasDetailsTables:Boolean;
    FHasFlags:Boolean;
    FFieldMonitor:TFieldMonitor;
    FHelper:TAdaptiveDialogHelper;
    FScript:TMiceScripter;
    FControlFlags:TControlFlags;
    FAllowedToClose:Boolean;
    FLogProviderName: string;
    function CallScript(Instance: TObject; ClassType: TClass; const MethodName: String; var Params: Variant): Variant;
    function GetAppDialogsId: Integer;
    function GetAppLayoutsID: Integer;
    function GetDocFlow: Boolean;
    procedure InitScript;
    procedure RegisterLayoutItems(AGroup: TdxCustomLayoutGroup);
    procedure SetAppDialogsId(const Value: Integer);
    procedure SetAppLayoutsID(const Value: Integer);
    procedure SetDocFlow(const Value: Boolean);
    procedure CreateLayout;
    procedure LoadLayoutFromDataSet(DataSet:TDataSet);
    procedure GetProperties;
  protected
    function DialogSaveName:string; override;
    function ItemByName(const Name:string):TComponent;
    procedure NotifyDocFlowLog(dfMethodsId:Integer);
    procedure FindDocFlowLayout(DocumentsId, dfClassesId, dfTypesId, dfPathFoldersId:Integer);
    procedure ApplyInitializationParams;
    procedure EnterInsertingState;override;
    procedure EnterEditingState; override;
    procedure DoApplyUpdates; override;
    procedure DoAfterOpen(DataSet:TDataSet); override;
    procedure LoadLayoutFlags;
    procedure LoadComponentCondition(DataSet:TDataSet);
    procedure HandleDragAndDrop(Sender:TObject; List:TStrings);
    procedure MonitorFieldChange(Field:TField);
    procedure MonitorDataScroll(DataSet:TDataSet);
    procedure Open; override;
    procedure DoAfterMasterApplyUpdates; override;
  public
    procedure Initialize; override;
    constructor Create(AOwner:TComponent); override;
    destructor Destroy; override;
    function Execute:Boolean; override;
    property Script:TMiceScripter read FScript;
    property LogProviderName:string read FLogProviderName write FLogProviderName;
  published
    property AppDialogsId:Integer read GetAppDialogsId write SetAppDialogsId;
    property AppLayoutsID:Integer read GetAppLayoutsID write SetAppLayoutsID;
    property DocFlow:Boolean read GetDocFlow write SetDocFlow;
  end;

implementation

{$R *.dfm}
resourcestring
 E_CANNOT_FIND_LAYOUT_FMT = 'Cannot find any active layout for AppDialogsId=%d, AppLayoutsID=%d';
 E_CANNOT_FIND_LAYOUT_FOR_FOLDER_FMT ='Layout not defined for state "%s" with dfPathFoldersId=%d';

{ TAdaptiveDialog }

procedure TAdaptiveDialog.InitScript;
begin
 if FScript.Lines.Count>0 then
  begin
   FScript.RegisterAllFields(DataSet);
   FScript.AddAllControls(Self);
   FScript.AddObject('Self',Self);
   FScript.AddMethod('function FieldByName(const s:string):TField', CallScript);
   FScript.AddMethod('function _F(const s:string):TField', CallScript);

   RegisterLayoutItems(DialogLayout.Items);
   if not FScript.Compile then
    MessageBox(Handle,PChar(Format(S_ERROR_AT_LINE_FMT, [FScript.ErrorMsg, FScript.ErrorPos])), PChar(S_COMMON_ERROR),MB_OK+MB_ICONERROR)
     else
    FScriptInitializeed:=True;
  end;
end;


function TAdaptiveDialog.ItemByName(const Name: string): TComponent;
begin
 Result:=Self.FHelper.LayoutBuilder.FindControl(Name);
 if not Assigned(Result) then
  Result:=DialogLayout.FindItem(Name);
end;

procedure TAdaptiveDialog.ApplyInitializationParams;
var
 F:TField;
 P:TParam;
begin
if (ReadOnly=False) then
 for F in Self.DataSet.Fields do
  begin
    P:=Params.FindParam(F.FieldName);
    if Assigned(P) and (F.ReadOnly=False) then
     F.Value:=P.Value;
  end;
// DataSet.FieldByName('dfTypesId').AsInteger:=Params.ParamByName('dfTypesId').AsInteger;
// DataSet.FieldByName('dfPathFoldersId').AsInteger:=Params.ParamByName('dfPathFoldersId').AsInteger;
// DataSet.FieldByName('dfEventsId').AsInteger:=Params.ParamByName('dfEventsId').AsInteger;
end;

procedure TAdaptiveDialog.bnOKClick(Sender: TObject);
begin
  DoApplyUpdates;
  if FAllowedToClose then
   ModalResult:=mrOK;
end;

function TAdaptiveDialog.CallScript(Instance: TObject; ClassType: TClass;  const MethodName: String; var Params: Variant): Variant;
begin
 if (MethodName='FIELDBYNAME') or (MethodName='_F') then
  Result:=Integer(Self.FieldByName(Params[0]))
   else
  Result:=NULL;
end;

constructor TAdaptiveDialog.Create(AOwner: TComponent);
begin
  inherited;
  FHelper:=TAdaptiveDialogHelper.Create(Self.DialogLayout);
  FHelper.LayoutBuilder.OwnerDataSource:=MainSource;
  FHelper.LayoutBuilder.OwnerDataSetList:=DetailDataSets;
  FScript:=TMiceScripter.Create(Self);
  FHelper.LayoutBuilder.Scripter:=Self.FScript;
  FControlFlags:=TControlFlags.Create;
  FControlFlags.MainSource:=Self.MainSource;
  FControlFlags.DataSetList:=Self.DetailDataSets;
  FControlFlags.LayoutItems:=FHelper.LayoutBuilder.LayoutItems;
  FFieldMonitor:=TFieldMonitor.Create;
  OnDragAndDropFiles:=HandleDragAndDrop;
  DetailDataSets.OnFieldChange:=MonitorFieldChange;
  DetailDataSets.AfterScroll:=MonitorDataScroll;
  FAllowedToClose:=True;
  FScriptInitializeed:=False;
end;


destructor TAdaptiveDialog.Destroy;
begin
  FFieldMonitor.Free;
  FControlFlags.Free;
  FHelper.Free;
  inherited;
end;


function TAdaptiveDialog.DialogSaveName: string;
begin
 Result:='AdaptiveDialogs\AppDialogsId='+Self.AppDialogsId.ToString+'@AppLayoutsId='+Self.AppLayoutsID.ToString;
end;

procedure TAdaptiveDialog.DoAfterMasterApplyUpdates;
begin
  inherited;
  if (DocFlow) and (State=dsInsert) and (LogProviderName.IsEmpty=False) then
    NotifyDocFlowLog(0);
end;

procedure TAdaptiveDialog.DoAfterOpen(DataSet:TDataSet);
begin
  inherited;
  FControlFlags.UpdateAll;
  DetailDataSets.AssignFieldChangeEvents(DataSet);
  if (FScriptInitializeed=False) then
   InitScript;
end;

procedure TAdaptiveDialog.DoApplyUpdates;
var
 AResult:Variant;
begin
 FocusControl(bnOK); // Иначе не срабатывает ОнЕхит и данные не записываются в ДатаСет
 if (not ReadOnly) and Modified then
  begin
   AResult := VarArrayOf([True]);
   FScript.CallFunction1('BeforePost',AResult);
   if (VarIsNull(AResult)=False) and (AResult[0]=True) then
    begin
     FAllowedToClose:=True;
     inherited;
     FScript.CallProcedure('AfterPost');
    end
     else
       FAllowedToClose:=False;
  end;
end;

procedure TAdaptiveDialog.EnterEditingState;
begin
  inherited;
  FScript.CallProcedure('EnterEditingState');
end;

procedure TAdaptiveDialog.EnterInsertingState;
begin
  inherited;
  ApplyInitializationParams;
  FScript.CallProcedure('EnterInsertingState');
end;

function TAdaptiveDialog.Execute: Boolean;
begin
 UpdateMasterDetailKey;
 Initialize;
 if Sizeable then
  LoadState(False, True);

 Result:=ShowModal=mrOK;

 if ((Sizeable) and (Result or ReadOnly)) then
  SaveState;
end;

procedure TAdaptiveDialog.FindDocFlowLayout(DocumentsId, dfClassesId,  dfTypesId, dfPathFoldersId: Integer);
var
 Tmp:TxDataSet;
begin
 Tmp:=TxDataSet.Create(nil);
 try
  Tmp.DBName:=Self.DBName;
  Tmp.ProviderName:='spui_AppDialogFindLayout';
  Tmp.SetParameter('DocumentsId',Id);
  Tmp.SetParameter('dfClassesId',dfClassesId);
  Tmp.SetParameter('dfPathFoldersId',dfPathFoldersId);
  Tmp.SetParameter('dfTypesId',dfTypesId);
  Tmp.Source:='TAdaptiveDialog.FindDocFlowLayout';
  Tmp.Open;
  if Tmp.RecordCount<=0 then
   raise Exception.CreateFmt(E_CANNOT_FIND_LAYOUT_FMT,[AppDialogsId, AppLayoutsID]);
  if AppLayoutsID<=0 then
   AppLayoutsID:=Tmp.FieldByName('AppDialogsLayoutIdEdit').AsInteger;

  if AppLayoutsID<=0 then
   raise Exception.CreateFmt(E_CANNOT_FIND_LAYOUT_FOR_FOLDER_FMT,[Tmp.FieldByName('Caption').AsString, dfPathFoldersId]);

  ReadOnly:=not Tmp.FieldByName('AllowEdit').AsBoolean;
 finally
  Tmp.Free;
 end;
end;

function TAdaptiveDialog.GetAppDialogsId: Integer;
begin
 Result:=Params.ParamByNameDef('AppDialogsId',0);
end;

function TAdaptiveDialog.GetAppLayoutsID: Integer;
begin
 Result:=Params.ParamByNameDef('AppLayoutsID',0);
end;

function TAdaptiveDialog.GetDocFlow: Boolean;
begin
 Result:=Params.ParamByNameDef('DocFlow',False);
end;

procedure TAdaptiveDialog.GetProperties;
var
 Tmp:TxDataSet;
resourcestring
 E_DIALOG_NOT_FOUND_FMT = 'Cannot find Adaptive Dialog with AppDialogsId=%d';
begin
 Tmp:=TxDataSet.Create(nil);
 try
  Tmp.ProviderName:='spui_AppDialogGetProperties';
  Tmp.SetParameter('AppDialogsId',AppDialogsId);
  Tmp.Source:='TAdaptiveDialog.GetProperties';
  Tmp.Open;
  if Tmp.RecordCount<>1 then
   raise Exception.CreateFmt(E_DIALOG_NOT_FOUND_FMT,[AppDialogsId]);

  KeyField:=Tmp.FieldByName('KeyField').AsString;
  TableName:=Tmp.FieldByName('TableName').AsString;
  DialogCaption:=Tmp.FieldByName('Caption').AsString;
  FScript.Lines.Text:=Tmp.FieldByName('Script').AsString;
  SequenceDBName:=Tmp.FieldByName('SequenceDBName').AsString;

  if (DBName.IsEmpty) then
   DBName:=Tmp.FieldByName('DBName').AsString;

  if Assigned(ParentObject) then
   Self.DBName:=ParentObject.DBName;

  if SequenceDBName.IsEmpty then
   SequenceDBName:=Self.DBName;

  FHasDetailsTables:=Tmp.FieldByName('HasDetailsTables').AsBoolean;
  DataSet.SequenceName:=Tmp.FieldByName('SequenceName').AsString;
 finally
  Tmp.Free;
 end;
end;

procedure TAdaptiveDialog.HandleDragAndDrop(Sender: TObject; List: TStrings);
var
 AParams:Variant;
begin
 if (not ReadOnly) then
  begin
   AParams := VarArrayOf([Integer(Sender), Integer(List)]);
   FScript.CallFunction1('OnDragAndDropFiles',AParams);
  end;
end;

procedure TAdaptiveDialog.Initialize;
var
 ADataSource:TDataSource;
 Control:TControl;
begin
  GetProperties;
  UpdateCaption;
  FHelper.AppDialogsId:=AppDialogsId;

  if (FHasDetailsTables=True) then
   DetailDataSets.LoadForAppDialog(AppDialogsId);

  for ADataSource in DetailDataSets.Values do
   ADataSource.OnDataChange:=MainSourceDataChange;


  CreateLayout;
  FHelper.BuildControls;

  AssignOnTabChanges;

  if (FHasFlags=True) then
   LoadLayoutFlags;



  for Control in Self.FHelper.LayoutBuilder.DependedControls do
   FFieldMonitor.AddFieldMonitor(Control as IMayDependOnDialog);
//  FScript.CallProcedure('BeforeOpen');


  Self.Open;

end;

procedure TAdaptiveDialog.LoadComponentCondition(DataSet: TDataSet);
var
 Component:TComponent;
 FlagType:Integer;
 Equation:TVariantEquation;
 AFieldName:string;
 ComparationValue:Variant;
begin
 Component:=ItemByName(DataSet.FieldByName('ItemName').AsString);
  if not Assigned(Component) then
   raise Exception.CreateFmt(E_CANNOT_FIND_ITEM_FMT,[DataSet.FieldByName('ItemName').AsString])
    else
     begin
      FlagType:=DataSet.FieldByName('FlagType').AsInteger;
      Equation:=TVariantEquation(DataSet.FieldByName('Equation').AsInteger);
      AFieldName:=DataSet.FieldByName('FieldName').AsString;
      ComparationValue:=DataSet.FieldByName('ComparationValue').Value;
       case FlagType of
         1:FControlFlags.AddVisibleCondition(AFieldName,Equation,ComparationValue, Component);
         2:FControlFlags.AddEnabledCondition(AFieldName,Equation,ComparationValue, Component);
       end;
     end
end;

procedure TAdaptiveDialog.LoadLayoutFlags;
var
 DataSet:TxDataSet;
begin
 DataSet:=TxDataSet.Create(nil);
 try
  DataSet.ProviderName:='spui_AppDialogGetLayoutFlags';
  DataSet.SetParameter('AppDialogsLayoutId',AppLayoutsID);
  DataSet.Source:='TAdaptiveDialog.LoadControlConditions;';
  DataSet.Open;
  while not DataSet.Eof do
   begin
    LoadComponentCondition(DataSet);
    DataSet.Next;
   end;
 finally
   DataSet.Free;
 end;
end;

procedure TAdaptiveDialog.LoadLayoutFromDataSet(DataSet: TDataSet);
begin
 FHasFlags:=DataSet.FieldByName('HasFlags').AsBoolean;

 if not DataSet.FieldByName('Width').IsNull then
   Width:=DataSet.FieldByName('Width').AsInteger;

  if not DataSet.FieldByName('Height').IsNull then
   Height:=DataSet.FieldByName('Height').AsInteger;

  Sizeable:=DataSet.FieldByName('Sizeable').AsBoolean;

  if Assigned(Params.FindParam('Readonly')) then
   ReadOnly:=Params.ParamByName('ReadOnly').AsBoolean
    else
   ReadOnly:=(DocFlow=False) and DataSet.FieldByName('ReadOnly').AsBoolean;

  LoadFromJson(DataSet.FieldByName('Layout').AsString);

  if AppLayoutsID<=0 then
   AppLayoutsID:=DataSet.FieldByName('AppDialogsLayoutId').AsInteger;
end;

procedure TAdaptiveDialog.MainSourceDataChange(Sender: TObject; Field: TField);
var
 AName:string;
 Source:string;
begin
 Source:=DetailDataSets.NameOf(Sender as TDataSource);
 if Assigned(Field) then
  begin
   if Source.IsEmpty then
     AName:=Field.FieldName
       else
     AName:=Source+'.'+Field.FieldName;
   FControlFlags.FieldChanged(Sender, Field);
   FFieldMonitor.FieldChanged(AName);
  end
   else
    begin
       FControlFlags.DataSetLineChanged(Sender);
       FFieldMonitor.DataSetLineChanged(Source);
    end;
end;

procedure TAdaptiveDialog.MonitorDataScroll(DataSet: TDataSet);
begin

end;

procedure TAdaptiveDialog.MonitorFieldChange(Field: TField);
begin

end;

procedure TAdaptiveDialog.NotifyDocFlowLog(dfMethodsId:Integer);
var
 DataSet:TxDataSet;
begin
 DataSet:=TxDataSet.Create(nil);
  try
   DataSet.ProviderName:=LogProviderName;
   DataSet.Source:='TAdaptiveDialog.NotifyDocFlowLog';
   DataSet.Params.LoadFromDataSet(Self.DataSet);
   if dfMethodsId<=0 then
    DataSet.SetParameter('dfMethodsId',NULL)
     else
    DataSet.SetParameter('dfMethodsId',dfMethodsId);
   DataSet.SetParameter('DocumentsId',ID);
   DataSet.DBName:=Self.DBName;
   DataSet.OpenOrExecute;
  finally
   DataSet.Free;
  end;
end;

procedure TAdaptiveDialog.Open;
begin
  inherited;
  FScript.CallProcedure('AfterOpen');
end;

procedure TAdaptiveDialog.RegisterLayoutItems(AGroup: TdxCustomLayoutGroup);
var
 x: Integer;
 Control:TControl;
 Group:TdxCustomLayoutGroup;
 Item:TdxLayoutItem;
begin
 for x:=0 to AGroup.Count - 1 do
  if AGroup.Items[x] is TdxCustomLayoutGroup  then
   begin
     Group:=AGroup.Items[x] as TdxCustomLayoutGroup;
     FScript.AddObject(Group.Name, Group);
     RegisterLayoutItems(Group);
   end
   else
  if (AGroup.Items[x] is TdxLayoutItem) then
   begin
    Item:=(AGroup.Items[x] as TdxLayoutItem);
    Control:=Item.Control;
    if Assigned(Control) then
     FScript.AddObject(Control.Name, Control);
    FScript.AddObject(Item.Name, Item);
   end
    else
   if (AGroup.Items[x] is TdxLayoutLabeledItem) then
    FScript.AddObject(AGroup.Items[x].Name, AGroup.Items[x] as TdxLayoutLabeledItem);
end;

procedure TAdaptiveDialog.CreateLayout;
var
 DataSet:TxDataSet;
begin
 DataSet:=TxDataSet.Create(nil);
 try
  DataSet.ProviderName:='spui_AppDialogGetLayout';
  DataSet.Source:='TAdaptiveDialog.RestoreLayout';
  DataSet.SetParameter('AppDialogsId',AppDialogsId);
  if DocFlow then
   FindDocFlowLayout(Id,Params.ParamByNameDef('dfClassesId',-1),Params.ParamByNameDef('dfTypesId',-1),Params.ParamByNameDef('dfPathFoldersId',-1));

  if (AppLayoutsID>0) then
   DataSet.SetParameter('AppDialogsLayoutId',AppLayoutsID);

  DataSet.Open;
  if DataSet.IsEmpty then
   raise Exception.CreateFmt(E_CANNOT_FIND_LAYOUT_FMT,[AppDialogsId, AppLayoutsID]);

  LoadLayoutFromDataSet(DataSet);
 finally
  DataSet.Free;
 end;
end;

procedure TAdaptiveDialog.SetAppDialogsId(const Value: Integer);
begin
  SetParameter('AppDialogsId',Value);
end;

procedure TAdaptiveDialog.SetAppLayoutsID(const Value: Integer);
begin
  SetParameter('AppLayoutsID',Value);
end;

procedure TAdaptiveDialog.SetDocFlow(const Value: Boolean);
begin
  SetParameter('DocFlow',Value);
end;


end.
