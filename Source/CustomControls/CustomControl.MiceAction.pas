unit CustomControl.MiceAction;

interface
 uses Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
      System.Classes, Vcl.ActnList,Data.DB, VCL.Menus,
      CustomControl.AppObject,
      Common.ActivityCondition;

 type
  TActionType = (atNone, atExecuteDialog, atExecuteScript, atExecuteOpenPlugin, atExecutePluginMethod, atExecuteStoredProc, atExecuteAppTemplate, atExecuteOpenFile, atPrintReport);

  TMultiSelectBehavior = (msbNone, msbStandart, msbCreateJsonArray);

  TMiceAction = class (TAction)
  strict private
    FActivityCondition: TActivityCondition;
    FID: Integer;
    FProviderName: string;
    FPluginMethod: String;
    FRunAppPluginsId: Integer;
    FRunAppDialogsId: Integer;
    FRunAppScriptsId: integer;
    FRunAppTemlatesID: Integer;
    FDialogPlacement: Integer;
    FActionType: TActionType;
    FCommandType: Integer;
    FAutoRefresh: Boolean;
    FContinueOnError: Boolean;
    FOriginalHotKey: string;
    procedure SetHotKey(const Value: string);
    function GetHotKey: string;
    procedure LoadAppObject(DataSet:TDataSet);
  private
    FMultiSelectBehavior: TMultiSelectBehavior;
    FShowDialogBeforeExecute: Boolean;
    FDBName: string;
    FParamName: string;
    FOpenFileFilter: string;
    FAppDialogShowBehavior: Integer;
    FValidateBeforeOpen: Boolean;
    FFileEncoding: Integer;
    FRunAppReportsId: Integer;
    procedure SetFileEncoding(const Value: Integer);
    procedure SetValidateBeforeOpen(const Value: Boolean);
  public
    procedure LoadFromDataSet(DataSet:TDataSet);
    property ActivityCondition:TActivityCondition read FActivityCondition;
    property ID:Integer read FID write FID;
    constructor Create(AOwner:TComponent); override;
    destructor Destroy; override;
    property ValidateBeforeOpen:Boolean read FValidateBeforeOpen write SetValidateBeforeOpen;
    property FileEncoding:Integer read FFileEncoding write SetFileEncoding;
    property RunAppDialogsId:Integer read FRunAppDialogsId write FRunAppDialogsId;
    property AppDialogShowBehavior:Integer read FAppDialogShowBehavior write FAppDialogShowBehavior;
    property OpenFileFilter:string read FOpenFileFilter write FOpenFileFilter;
    property ParamName:string read FParamName write FParamName;
    property RunAppScriptsId:integer read FRunAppScriptsId write FRunAppScriptsId;
    property RunAppPluginsId:Integer read FRunAppPluginsId write FRunAppPluginsId;
    property RunAppTemlatesID:Integer read FRunAppTemlatesID write FRunAppTemlatesID;
    property RunAppReportsId:Integer read FRunAppReportsId write FRunAppReportsId;
    property AutoRefresh:Boolean read FAutoRefresh write FAutoRefresh;
    property ProviderName:string read FProviderName write FProviderName;
    property DBName:string read FDBName write FDBName;
    property PluginMethod:String read FPluginMethod write FPluginMethod;
    property DialogPlacement:Integer read FDialogPlacement write FDialogPlacement;
    property ActionType:TActionType read FActionType write FActionType;
    property CommandType:Integer read FCommandType write FCommandType;
    property ContinueOnError:Boolean read FContinueOnError write FContinueOnError;
    property MultiSelectBehavior:TMultiSelectBehavior read FMultiSelectBehavior write FMultiSelectBehavior;
    property HotKey:string read GetHotKey write SetHotKey;
    property OriginalHotKey:string read FOriginalHotKey write FOriginalHotKey;
    property ShowDialogBeforeExecute:Boolean read FShowDialogBeforeExecute write FShowDialogBeforeExecute;
  end;

implementation

{ TMiceAction }

constructor TMiceAction.Create(AOwner: TComponent);
begin
  inherited;
  FActivityCondition:=TActivityCondition.Create;
  FActionType:=atNone;
  ID:=0;
end;

destructor TMiceAction.Destroy;
begin
  FActivityCondition.Free;
  inherited;
end;

function TMiceAction.GetHotKey: string;
begin
 Result:=ShortCutToText(ShortCut);
end;

procedure TMiceAction.LoadAppObject(DataSet:TDataSet);
var
 Obj:TMiceAppObject;
begin
 Obj:=TMiceAppObject.Create;
   try
    Obj.AsJson:=DataSet.FieldByName('InitString').AsString;
    ValidateBeforeOpen:=Obj.Properties.ValidateBeforeOpen;
    FileEncoding:=Obj.Properties.FileEncoding;
   finally
    Obj.Free;
   end;
end;

procedure TMiceAction.LoadFromDataSet(DataSet: TDataSet);
begin
 //Тут нельзя делать  ActivityCondition.LoadFromDataSet(DataSet);
 //т.к. внутренние экшены плагина перезатрутся установленными.

 Caption:=DataSet.FieldByName('Caption').AsString;
 ImageIndex:=DataSet.FieldByName('ImageIndex').AsInteger;
 ID:=DataSet.FieldByName('AppCmdId').AsInteger;
 RunAppDialogsId:=DataSet.FieldByName('RunAppDialogsId').AsInteger;
 RunAppPluginsId:=DataSet.FieldByName('RunAppPluginsId').AsInteger;
 RunAppScriptsId:=DataSet.FieldByName('RunAppScriptsId').AsInteger;
 RunAppTemlatesID:=DataSet.FieldByName('RunAppTemplatesId').AsInteger;
 RunAppReportsId:=DataSet.FieldByName('RunAppReportsId').AsInteger;
 PluginMethod:=DataSet.FieldByName('PluginMethod').AsString;
 ProviderName:=DataSet.FieldByName('SPValue').AsString;
 DBName:=DataSet.FieldByName('SPValue1').AsString;
 OpenFileFilter:=DataSet.FieldByName('SPValue2').AsString;

 AutoRefresh:=DataSet.FieldByName('AutoRefresh').AsBoolean;
 DialogPlacement:=DataSet.FieldByName('RunAppDialogPlacement').AsInteger;
 AppDialogShowBehavior:=DataSet.FieldByName('AppDialogShowBehavior').AsInteger;
 ParamName:=DataSet.FieldByName('ParamName').AsString;

 Hint:=DataSet.FieldByName('Hint').AsString;
 if Hint='' then
  Hint:=DataSet.FieldByName('Name').AsString + ' ('+ActivityCondition.ToString+')';

 ActionType:=TActionType(DataSet.FieldByName('ActionType').AsInteger);
 AutoCheck:=DataSet.FieldByName('CommandType').AsInteger=1;
// HotKey:=DataSet.FieldByName('ShortCut').AsString;
 OriginalHotKey:=DataSet.FieldByName('ShortCut').AsString;;

 ContinueOnError:=DataSet.FieldByName('ContinueOnError').AsBoolean;;
 MultiSelectBehavior:=TMultiSelectBehavior(DataSet.FieldByName('MultiSelectBehavior').AsInteger);

 if not DataSet.FieldByName('InitString').AsString.IsEmpty then
  LoadAppObject(DataSet);
end;


procedure TMiceAction.SetFileEncoding(const Value: Integer);
begin
  FFileEncoding := Value;
end;

procedure TMiceAction.SetHotKey(const Value: string);
begin
 ShortCut:=TextToShortCut(Value);
end;

procedure TMiceAction.SetValidateBeforeOpen(const Value: Boolean);
begin
  FValidateBeforeOpen := Value;
end;

end.
