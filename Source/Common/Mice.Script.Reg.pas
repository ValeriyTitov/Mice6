unit Mice.Script.Reg;

interface
 uses
   Mice.Script,
   Mice.Report,
   fs_idbrtti,
   fs_isysrtti,
   fs_iinterpreter,
   fs_iclassesrtti,
   fs_iformsrtti,
   fs_itools,
   Vcl.Controls,
   Vcl.Forms,
   System.Classes,
   System.Variants,
   dxLayoutContainer,
   Data.DB,
   FireDAC.Comp.Client,
   FireDAC.Comp.DataSet,
   DAC.BaseDataSet,
   DAC.XDataSet,
   DAC.XParams,
   DAC.ObjectModels.MiceUser,
   CustomControl.MiceButton,
   CustomControl.MiceTextEdit,
   CustomControl.MiceCheckBox,
   CustomControl.MiceLayout,
   CustomControl.MiceDropDown,
   CustomControl.MiceMemo,
   CustomControl.MiceDateEdit,
   CustomControl.MiceAction,
   CustomControl.MiceActionList,
   AppTemplate.Builder,
   Common.ActivityCondition,
   Common.StringUtils,
   Common.DateUtils,
   Common.GlobalSettings,
   Plugin.Base,
   Plugin.Properties,
   Plugin.Grid,
   Plugin.TreeGrid,
   Plugin.Page,
   Plugin.MultiPagePlugin,
   Dialog.Basic,
   Dialog.DB,
   Dialog.Layout,
   Dialog.Adaptive,
   Dialog.Embedded,
   Dialog.MShowMessage,
   Dialog.ShowDataSet;



implementation

var
 LastClass:TfsClassVariable;
 FStingUtilsClass:TObject;
 FGlobalSettingClass:TObject;
 FDateUtilsClass:TObject;

type
 TScriptObject = class
 private
  class function DeleteAllOfV(const s:string; const Args: Variant): string;
  class function ContainsAnyOfV(const s:string; const Args: Variant): Boolean;
 public
  class function TGlobalSettingsCall(Instance: TObject; ClassType: TClass; const MethodName: string; Caller: TfsMethodHelper):Variant;
  class function TxParamsCall(Instance: TObject; ClassType: TClass; const MethodName: string; Caller: TfsMethodHelper):Variant;
  class function TAppTemplateBuilderCall(Instance: TObject; ClassType: TClass; const MethodName: string; Caller: TfsMethodHelper):Variant;
  class function TMiceReportCall(Instance: TObject; ClassType: TClass; const MethodName: string; Caller: TfsMethodHelper):Variant;
  class function TDateUtilsCall(Instance: TObject; ClassType: TClass; const MethodName: string; Caller: TfsMethodHelper):Variant;
  class function TPluginCall(Instance: TObject; ClassType: TClass; const MethodName: string; Caller: TfsMethodHelper):Variant;
  class function TStringUtilsCall(Instance: TObject; ClassType: TClass; const MethodName: string; Caller: TfsMethodHelper):Variant;
  class function TMShowMessageCall(Instance: TObject; ClassType: TClass; const MethodName: string; Caller: TfsMethodHelper):Variant;
  class function TMShowDataSetCall(Instance: TObject; ClassType: TClass; const MethodName: string; Caller: TfsMethodHelper):Variant;
  class function TMiceActionListCall(Instance: TObject; ClassType: TClass; const MethodName: string; Caller: TfsMethodHelper):Variant;
  class function TAdaptiveDialogCall(Instance: TObject; ClassType: TClass; const MethodName: string; Caller: TfsMethodHelper):Variant;
  class function CallMethod(Instance: TObject; ClassType: TClass; const MethodName: string; Caller: TfsMethodHelper): Variant;
  class function GetProp(Instance: TObject; ClassType: TClass; const PropName: string): Variant;
  class procedure SetProp(Instance: TObject; ClassType: TClass; const PropName: string; Value: Variant);
 end;


class function TScriptObject.CallMethod(Instance: TObject; ClassType: TClass; const MethodName: string; Caller: TfsMethodHelper): Variant;
begin
 Result:=NULL;
end;

class function TScriptObject.ContainsAnyOfV(const s: string; const Args: Variant): Boolean;
var
 x:Integer;
 Count:Integer;
 Value:string;
 A:array of string;
begin
if VarIsArray(Args) then
 begin
  x := VarArrayLowBound(Args, 1);
  Count:= VarArrayHighBound(Args, 1);
  SetLength(A, Count+1);
  while x <= Count do
   begin
    Value:=VarToStr(Args[x]);
    A[x] := Value;
    Inc(x);
   end;
  Result:=TStringUtils.ContainsAnyOf(s,A);
 end
  else
 Result:=False;
end;


class function TScriptObject.DeleteAllOfV(const s: string;  const Args: Variant): string;
var
 x:Integer;
 Count:Integer;
 Value:string;
 A:array of string;
begin
if VarIsArray(Args) then
 begin
  x := VarArrayLowBound(Args, 1);
  Count:= VarArrayHighBound(Args, 1);
  SetLength(A, Count+1);
  while x <= Count do
   begin
    Value:=VarToStr(Args[x]);
    A[x] := Value;
    Inc(x);
   end;
  Result:=TStringUtils.DeleteAllOf(s,A);
 end
  else
 Result:=s;
end;



class function TScriptObject.GetProp(Instance: TObject; ClassType: TClass;  const PropName: string): Variant;
begin
 //свойства типа published можно не добавлять, они добавляются автоматически
{if ClassType = TCustomComboBox then
  begin
    if PropName = 'DROPPEDDOWN' then
      Result := TCustomComboBox(Instance).DroppedDown
 }

  if ClassType = TBasePlugin then
  begin
    if PropName = 'DATASET' then
      Result:=Integer(TBasePlugin(Instance).DataSet);
    end
    else
 Result:=NULL;
end;

class procedure TScriptObject.SetProp(Instance: TObject; ClassType: TClass;  const PropName: String; Value: Variant);
begin
 {
 if ClassType = TControl then
  begin
    if PropName = 'PARENT' then
      TControl(Instance).Parent := TWinControl(frxInteger(Value))
  end
  }
end;

class function TScriptObject.TAdaptiveDialogCall(Instance: TObject; ClassType: TClass; const MethodName: string;  Caller: TfsMethodHelper):Variant;
begin
  if MethodName = 'EXECUTE' then
   Result:=TAdaptiveDialog(Instance).Execute
 else
  if MethodName = 'FIELDBYNAME' then
   Result:=Integer(TAdaptiveDialog(Instance).FieldByName(Caller.Params[0]))
 else
  if MethodName = '_F' then
   Result:=Integer(TAdaptiveDialog(Instance).FieldByName(Caller.Params[0]))
 else
  if MethodName = 'CONTROLHINT' then
   TAdaptiveDialog(Instance).ControlHint(Caller.Params[0],Caller.Params[1],Caller.Params[2])
  else
   Result:=NULL;
end;

class function TScriptObject.TAppTemplateBuilderCall(Instance: TObject;  ClassType: TClass; const MethodName: string;  Caller: TfsMethodHelper): Variant;
begin
 if MethodName='EXECUTE' then
  Result:=TAppTemplateBuilder(Instance).Execute;
end;

class function TScriptObject.TDateUtilsCall(Instance: TObject; ClassType: TClass; const MethodName: string; Caller: TfsMethodHelper): Variant;
begin
if MethodName='TOJSONDATE' then
 Result:=TDateUtils.ToJsonDate(Caller.Params[0])
 else
if MethodName='TOJSONDATETIME' then
 Result:=TDateUtils.ToJsonDateTime(Caller.Params[0])
 else
if MethodName='ENDOFADAY' then
 Result:=TDateUtils.EndOfADay(Caller.Params[0])
 else
if MethodName='STARTOFTHEQUARTER' then
 Result:=TDateUtils.StartOfTheQuarter(Caller.Params[0])
 else
if MethodName='ENDOFTHEQUARTER' then
 Result:=TDateUtils.EndOfTheQuarter(Caller.Params[0])
 else
if MethodName='STARTOFTHEYEAR' then
 Result:=TDateUtils.StartOfTheYear(Caller.Params[0])
 else
if MethodName='ENDOFTHEYEAR' then
 Result:=TDateUtils.EndOfTheYear(Caller.Params[0])
 else
if MethodName='ENDOFAMONTH' then
 Result:=TDateUtils.EndOfAMonth(Caller.Params[0])
 else
if MethodName='STARTOFAMONTH' then
 Result:=TDateUtils.StartOfAMonth(Caller.Params[0])
 else
if MethodName='REMOVETIME' then
 Result:=TDateUtils.RemoveTime(Caller.Params[0])
 else
if MethodName='DATETIMETOSTR' then
 Result:=TDateUtils.DateTimeToStr(Caller.Params[0],Caller.Params[1])
 else
if MethodName='DAYSBETWEEN' then
 Result:=TDateUtils.DaysBetween(Caller.Params[0],Caller.Params[1])
 else
if MethodName='ADDDAYS' then
 Result:=TDateUtils.AddDays(Caller.Params[0],Caller.Params[1])
 else
if MethodName='ADDMONTHS' then
 Result:=TDateUtils.AddMonths(Caller.Params[0],Caller.Params[1])
 else
if MethodName='ADDYEARS' then
 Result:=TDateUtils.AddYears(Caller.Params[0],Caller.Params[1])
 else
if MethodName='TODAY' then
 Result:=TDateUtils.Today
 else
if MethodName='NOW' then
 Result:=TDateUtils.Now
 else
if MethodName='SECONDSTOTIME' then
 Result:=TDateUtils.SecondsToTime(Caller.Params[0])
 else
 Result:=NULL;
end;

class function TScriptObject.TGlobalSettingsCall(Instance: TObject;  ClassType: TClass; const MethodName: string;  Caller: TfsMethodHelper): Variant;
begin
 if MethodName='SETTINGBYNAME' then
  Result:=TGlobalSettings.DefaultInstance.SettingByName(Caller.Params[0])
 else
 if MethodName='SETTINGEXISTS' then
  Result:=TGlobalSettings.DefaultInstance.SettingExists(Caller.Params[0])
end;

class function TScriptObject.TMiceActionListCall(Instance: TObject; ClassType: TClass; const MethodName: string;  Caller: TfsMethodHelper):Variant;
begin
  Result:=NULL;
end;

class function TScriptObject.TMiceReportCall(Instance: TObject;  ClassType: TClass; const MethodName: string;  Caller: TfsMethodHelper): Variant;
var
 R:TMiceReport;
 StreamRef:Integer;
begin
 R:=Instance as TMiceReport;
 if MethodName='EDIT' then
  R.Edit
 else
 if MethodName='EXECUTE' then
  Result:=R.Execute
 else
 if MethodName='SETPARAMETER' then
  R.SetParameter(Caller.Params[0],Caller.Params[1])
 else
 if MethodName='EXPORTTOFILE' then
  R.ExportToFile(Caller.Params[0],Caller.Params[1])
 else
 if MethodName='EXPORTTOSTREAM' then
  begin
   StreamRef:=Caller.Params[0];
   R.ExportToStream(TStream(StreamRef),Caller.Params[1]);
  end
 else
   Result:=NULL;
end;

class function TScriptObject.TMShowDataSetCall(Instance: TObject;  ClassType: TClass; const MethodName: string;  Caller: TfsMethodHelper): Variant;
var
 ARef:Integer;
begin
 Result:=NULL;
 ARef:=Caller.Params[0];

 if MethodName='SHOWDATASET' then
  TShowDatasetDialog.ShowDataSet(TDataSet(Aref))
  else
 if MethodName='SHOWDATASETEX' then
  TShowDatasetDialog.ShowDataSetEx(TDataSet(Aref),Caller.Params[0],Caller.Params[1],Caller.Params[2]);
end;

class function TScriptObject.TMShowMessageCall(Instance: TObject; ClassType: TClass; const MethodName: string;  Caller: TfsMethodHelper): Variant;
var
 ARef:Integer;
 s:string;
begin
Result:=NULL;
if MethodName='MSHOWMESSAGE' then
 TMessageDialog.MShowMessage(Caller.Params[0])
 else
if MethodName='MSHOWMESSAGELIST' then
 begin
  ARef:=Caller.Params[0];
  TMessageDialog.MShowMessageList(TStrings(ARef))
 end
 else
if MethodName='MSHOWMESSAGEEX' then
 TMessageDialog.MShowMessageEx(Caller.Params[0],Caller.Params[1],Caller.Params[2],Caller.Params[3])
 else
if MethodName='MSHOWMESSAGELISTEX' then
 begin
  ARef:=Caller.Params[0];
  TMessageDialog.MShowMessageListEx(TStrings(ARef),Caller.Params[1],Caller.Params[2],Caller.Params[3])
 end
 else
if MethodName='MINPUTBOX' then
 begin
  s:=Caller.Params[2];
  Result:=TMessageDialog.MInputBox(Caller.Params[0],Caller.Params[1],s,Caller.Params[3]);
  if Result=True then
   Caller.Params[2]:=s;
 end;
end;

class function TScriptObject.TPluginCall(Instance: TObject; ClassType: TClass;  const MethodName: string; Caller: TfsMethodHelper): Variant;
begin
if MethodName='KEYFIELDVALUE' then
 Result:=TBasePlugin(Instance).KeyFieldValue
  else
//if MethodName='DATASET' then Result:=TBasePlugin(Instance).DataSet;
end;

class function TScriptObject.TStringUtilsCall(Instance: TObject;  ClassType: TClass; const MethodName: string;  Caller: TfsMethodHelper): Variant;
begin
if MethodName='SAMESTRING' then
 Result:=TStringUtils.SameString(Caller.Params[0],Caller.Params[1])
  else
if MethodName='REMOVEDUALSPACES' then
 Result:=TStringUtils.RemoveDualSpaces(Caller.Params[0])
  else
if MethodName='LEFTFROMDOT' then
 Result:=TStringUtils.LeftFromDot(Caller.Params[0],Caller.Params[1])
  else
if MethodName='RIGHTFROMDOT' then
 Result:=TStringUtils.RightFromDot(Caller.Params[0],Caller.Params[1])
  else
if MethodName='LEFTFROMTEXT' then
 Result:=TStringUtils.LeftFromText(Caller.Params[0],Caller.Params[1], Caller.Params[2])
  else
if MethodName='RIGHTFROMTEXT' then
 Result:=TStringUtils.RightFromText(Caller.Params[0],Caller.Params[1], Caller.Params[2])
  else
if MethodName='REMOVEBRACKETS' then
 Result:=TStringUtils.RemoveBrackets(Caller.Params[0],Caller.Params[1], Caller.Params[2])
  else
if MethodName='EXTRACTQUOTEDTEXT' then
 Result:=TStringUtils.ExtractQuotedText(Caller.Params[0],Caller.Params[1], Caller.Params[2])
  else
if MethodName='CONTAINS' then
 Result:=TStringUtils.Contains(Caller.Params[0],Caller.Params[1], Caller.Params[2])
  else
if MethodName='STARTSWITH' then
 Result:=TStringUtils.StartsWith(Caller.Params[0],Caller.Params[1], Caller.Params[2])
  else
if MethodName='ENDSWITH' then
 Result:=TStringUtils.EndsWith(Caller.Params[0],Caller.Params[1], Caller.Params[2])
  else
if MethodName='POSITION' then
 Result:=TStringUtils.Position(Caller.Params[0],Caller.Params[1], Caller.Params[2])
  else
if MethodName='POSITIONFROM' then
 Result:=TStringUtils.PositionFrom(Caller.Params[0],Caller.Params[1], Caller.Params[2], Caller.Params[3])
  else
if MethodName='DEQUOTEDELPHISTRING' then
 Result:=TStringUtils.DeQuoteDelphiString(Caller.Params[0])
  else
if MethodName='QUOTEDSTR' then //QuotedStr
 Result:=TStringUtils.QuotedStr(Caller.Params[0])
  else
if MethodName='TOLOWER' then
 Result:=TStringUtils.ToLower(Caller.Params[0])
  else
if MethodName='TOUPPER' then
 Result:=TStringUtils.ToUpper(Caller.Params[0])
  else
if MethodName='WORDCOUNT' then
 Result:=TStringUtils.WordCount(Caller.Params[0])
  else
if MethodName='EXTRACTWORD' then
 Result:=TStringUtils.ExtractWord(Caller.Params[0],Caller.Params[1])
  else
if MethodName='DELETEALLOF' then
 Result:=Self.DeleteAllOfV(Caller.Params[0],Caller.Params[1])
  else
if MethodName='CONTAINSANYOF' then
 Result:=Self.ContainsAnyOfV(Caller.Params[0],Caller.Params[1])
  else
if MethodName='HASH' then
 Result:=TStringUtils.Hash(Caller.Params[0])
 else
if MethodName='ISNUMBER' then
 Result:=TStringUtils.IsNumber(Caller.Params[0])
 else
if MethodName='SPACECOUNT' then
 Result:=TStringUtils.SpaceCount(Caller.Params[0])
 else
if MethodName='STRINGCOUNT' then
 Result:=TStringUtils.StringCount(Caller.Params[0],Caller.Params[1], Caller.Params[2])
 else
if MethodName='LENGTH' then
 Result:=TStringUtils.Length(Caller.Params[0])
 else
if MethodName='LEADINGZEROES' then
 Result:=TStringUtils.LeadingZeros(Caller.Params[0],Caller.Params[1])
  else
 Result:=NULL;
end;

class function TScriptObject.TxParamsCall(Instance: TObject; ClassType: TClass;  const MethodName: string; Caller: TfsMethodHelper): Variant;
var
 ARef:Integer;
begin
Result:=NULL;
 if MethodName='SETPARAMETER' then
  TxParams(Instance).SetParameter(Caller.Params[0],Caller.Params[1])
 else
 if MethodName='PARAMBYNAME' then
  Result:=Integer(TxParams(Instance).ParamByName(Caller.Params[0]))
 else
 if MethodName='PARAMBYNAMEDEF' then
  Result:=TxParams(Instance).ParamByNameDef(Caller.Params[0],Caller.Params[0])
 else
  if MethodName='LOADFROMDATASET' then
  begin
   ARef:=Caller.Params[0];
   TxParams(Instance).LoadFromDataSet(TDataSet(ARef));
  end
  else
 if MethodName='LOADFROMDATASETLIST' then
  begin
   ARef:=Caller.Params[0];
   TxParams(Instance).LoadFromDataSetList(TDataSet(ARef),Caller.Params[1],Caller.Params[2]);
  end
  else
 if MethodName='LOADFROMPARAMS' then
  begin
   ARef:=Caller.Params[0];
   TxParams(Instance).LoadFromParams(TParams(ARef));
  end
  else
 if MethodName='SETPARAMETERNODEFAULT' then
  TxParams(Instance).SetParameterNoDefault(Caller.Params[0],Caller.Params[1],Caller.Params[2])
   else
  if MethodName='TOSTRING' then
   Result:=TxParams(Instance).ToString;
end;

initialization
 fsGlobalUnit.AddClass(TMiceLayoutItem,  'TMiceLayoutItem');
 fsGlobalUnit.AddClass(TMiceLayoutGroup, 'TMiceLayoutGroup');
 fsGlobalUnit.AddClass(TdxLayoutLabeledItem,      'TdxLayoutLabeledItem');
 fsGlobalUnit.AddClass(TdxLayoutSplitterItem,     'TdxLayoutSplitterItem');
 fsGlobalUnit.AddClass(TdxLayoutAutoCreatedGroup, 'TdxLayoutAutoCreatedGroup');
 fsGlobalUnit.AddClass(TdxLayoutSeparatorItem,    'TdxLayoutSeparatorItem');
 fsGlobalUnit.AddClass(TdxLayoutEmptySpaceItem,   'TdxLayoutEmptySpaceItem');

 fsGlobalUnit.AddClass(TMiceButton,      'TMiceButton');
 fsGlobalUnit.AddClass(TMiceTextEdit,    'TMiceTextEdit');
 fsGlobalUnit.AddClass(TMiceCheckBox,    'TMiceCheckBox');
 fsGlobalUnit.AddClass(TMiceDropDown,    'TMiceDropDown');
 fsGlobalUnit.AddClass(TMiceMemo,        'TMiceMemo');
 fsGlobalUnit.AddClass(TMiceDateEdit,    'TMiceDateEdit');


 fsGlobalUnit.AddClass(TControl,    'TComponent');
 fsGlobalUnit.AddClass(TMiceUser,'TObject');
 LastClass:=fsGlobalUnit.AddClass(TAppTemplateBuilder,'TComponent');
 LastClass.AddMethod('function Execute:Boolean',TScriptObject.TAppTemplateBuilderCall);


 fsGlobalUnit.AddClass(TBasicDialog,       'TForm');
 fsGlobalUnit.AddClass(TBasicDBDialog,     'TBasicDialog');
 fsGlobalUnit.AddClass(TBasicLayoutDialog, 'TBasicDBDialog');

 LastClass:=fsGlobalUnit.AddClass(TAdaptiveDialog,    'TBasicLayoutDialog');
 LastClass.AddMethod('function Execute: Boolean', TScriptObject.TAdaptiveDialogCall);
 LastClass.AddMethod('function FieldByName(const FieldName:string):TField;', TScriptObject.TAdaptiveDialogCall);
 LastClass.AddMethod('procedure ControlHint(const ControlName, Title, Description: string);', TScriptObject.TAdaptiveDialogCall);
// LastClass.AddMethod('function _F(const FieldName:string):TField;', TScriptObject.CallMethod);
 fsGlobalUnit.AddClass(TEmbeddedDialog,    'TAdaptiveDialog');


 fsGlobalUnit.AddClass(TMessageDialog,    'TBasicDialog');
 fsGlobalUnit.AddMethod('procedure MShowMessage(const Msg:string)',TScriptObject.TMShowMessageCall);
 fsGlobalUnit.AddMethod('procedure MShowMessageList(List:TStrings);',TScriptObject.TMShowMessageCall);
 fsGlobalUnit.AddMethod('procedure MShowMessageEx(const Msg, WindowCaption, LabelCaption:string; ImageIndex:Integer)',TScriptObject.TMShowMessageCall);
 fsGlobalUnit.AddMethod('procedure MShowMessageListEx(List:TStrings;const WindowCaption, LabelCaption:string;ImageIndex:Integer)',TScriptObject.TMShowMessageCall);
 fsGlobalUnit.AddMethod('function MInputBox(const WindowCaption, LabelCaption: string; var s: string; ImageIndex:Integer):Boolean',TScriptObject.TMShowMessageCall);

 fsGlobalUnit.AddClass(TShowDatasetDialog,    'TBasicDialog');
 fsGlobalUnit.AddMethod('procedure ShowDataSet(DataSet:TDataSet);',TScriptObject.TMShowDataSetCall);
 fsGlobalUnit.AddMethod('procedure ShowDataSetEx(DataSet:TDataSet; const WindowCaption, LabelCaption:string; AImageIndex:Integer);',TScriptObject.TMShowDataSetCall);


 LastClass:=fsGlobalUnit.AddClass(TMiceReport, 'TComponent');
 LastClass.AddMethod('function Execute;',TScriptObject.TMiceReportCall);
 LastClass.AddMethod('procedure Edit;',TScriptObject.TMiceReportCall);
 LastClass.AddMethod('procedure ExportToStream(Stream:TStream; const Format:string);',TScriptObject.TMiceReportCall);
 LastClass.AddMethod('procedure ExportToFile(const FileName, Format:string);',TScriptObject.TMiceReportCall);
 LastClass.AddMethod('procedure SetParameter(const ParamName: string;  const ParamValue: Variant);',TScriptObject.TMiceReportCall);

 LastClass:=fsGlobalUnit.AddClass(TStringUtils, '');
 LastClass.AddMethod('function SameString(const Str1, Str2:string):Boolean;',TScriptObject.TStringUtilsCall);
 LastClass.AddMethod('function RemoveDualSpaces(const s:string):string;',TScriptObject.TStringUtilsCall);
 LastClass.AddMethod('function LeftFromDot(const s, Default: string):string;',TScriptObject.TStringUtilsCall);
 LastClass.AddMethod('function RightFromDot(const s, Default: string):string;',TScriptObject.TStringUtilsCall);
 LastClass.AddMethod('function LeftFromText(const s, Pattern, Default: string):string;',TScriptObject.TStringUtilsCall);
 LastClass.AddMethod('function RightFromText(const s, Pattern, Default: string):string;',TScriptObject.TStringUtilsCall);
 LastClass.AddMethod('function DeQuoteDelphiString(const s:string):string;',TScriptObject.TStringUtilsCall);
 LastClass.AddMethod('function Pretty(const s1:string):string;',TScriptObject.TStringUtilsCall);
 LastClass.AddMethod('function RemoveBrackets(const s:string; StartBracket, EndBracket:string):string;',TScriptObject.TStringUtilsCall);
 LastClass.AddMethod('function Contains(const s1, s2:string; IgnoreCase:Boolean):Boolean;',TScriptObject.TStringUtilsCall);
 LastClass.AddMethod('function EndsWith(const s1, s2:string;IgnoreCase:Boolean):Boolean;',TScriptObject.TStringUtilsCall);
 LastClass.AddMethod('function StartsWith(const s1, s2:string;IgnoreCase:Boolean):Boolean;',TScriptObject.TStringUtilsCall);
 LastClass.AddMethod('function Position(const s1, s2:string;IgnoreCase:Boolean):Integer;',TScriptObject.TStringUtilsCall);
 LastClass.AddMethod('function PositionFrom(const s1, s2:string;IgnoreCase:Boolean; StartIndex:Integer):Integer;',TScriptObject.TStringUtilsCall);
 LastClass.AddMethod('function ToLower(const s1:string):string;',TScriptObject.TStringUtilsCall);
 LastClass.AddMethod('function ToUpper(const s1:string):string;',TScriptObject.TStringUtilsCall);
 LastClass.AddMethod('function QuotedStr(const s1:string):string;',TScriptObject.TStringUtilsCall);
 LastClass.AddMethod('function WordCount(const s1:string):Integer;',TScriptObject.TStringUtilsCall);
 LastClass.AddMethod('function ExtractWord(const s1:string; WordNumber:Integer):string;',TScriptObject.TStringUtilsCall);
 LastClass.AddMethod('function DeleteAllOf(const s: string; const Args: array of string): string;',TScriptObject.TStringUtilsCall);
 LastClass.AddMethod('function ContainsAnyOf(const s: string; const Args: array of string): Boolean;',TScriptObject.TStringUtilsCall);
 LastClass.AddMethod('function Hash(const s:string):string;',TScriptObject.TStringUtilsCall);
 LastClass.AddMethod('function IsNumber(const s:string):Boolean;',TScriptObject.TStringUtilsCall);
 LastClass.AddMethod('function SpaceCount(const s:string):Integer;',TScriptObject.TStringUtilsCall);
 LastClass.AddMethod('function StringCount(s,s1:string; IgnoreCase:Boolean):Integer;',TScriptObject.TStringUtilsCall);
 LastClass.AddMethod('function Length(const s1:string):Integer;',TScriptObject.TStringUtilsCall);
 LastClass.AddMethod('function LeadingZeros(AValue:Integer; TotalLength: Word):string;',TScriptObject.TStringUtilsCall);


 FStingUtilsClass:=TStringUtils.Create;
 fsGlobalUnit.AddObject('StringUtils',FStingUtilsClass);

 LastClass:=fsGlobalUnit.AddClass(TDateUtils, '');
 LastClass.AddMethod('function ToJsonDate(const D:TDateTime):string;',TScriptObject.TDateUtilsCall);
 LastClass.AddMethod('function ToJsonDateTime(const D:TDateTime):string;',TScriptObject.TDateUtilsCall);
 LastClass.AddMethod('function EndOfADay(const D:TDateTime):TDateTime;',TScriptObject.TDateUtilsCall);
 LastClass.AddMethod('function StartOfTheQuarter(const D:TDateTime):TDateTime;',TScriptObject.TDateUtilsCall);
 LastClass.AddMethod('function EndOfTheQuarter (const D:TDateTime):TDateTime;',TScriptObject.TDateUtilsCall);
 LastClass.AddMethod('function StartOfTheYear(const D:TDateTime):TDateTime;',TScriptObject.TDateUtilsCall);
 LastClass.AddMethod('function EndOfTheYear(const D:TDateTime):TDateTime;',TScriptObject.TDateUtilsCall);
 LastClass.AddMethod('function StartOfAMonth(const D:TDateTime):TDateTime;',TScriptObject.TDateUtilsCall);
 LastClass.AddMethod('function EndOfAMonth(const D:TDateTime):TDateTime;',TScriptObject.TDateUtilsCall);
 LastClass.AddMethod('function RemoveTime(const D:TDateTime):TDateTime;',TScriptObject.TDateUtilsCall);
 LastClass.AddMethod('function DateTimeToStr(const D:TDateTime; const AFormat:string):string;',TScriptObject.TDateUtilsCall);
 LastClass.AddMethod('function DaysBetween(const D1, D2:TDateTime):Integer;',TScriptObject.TDateUtilsCall);
 LastClass.AddMethod('function AddDays(const D1:TDateTime; Amount:Integer):TDateTime;',TScriptObject.TDateUtilsCall);
 LastClass.AddMethod('function AddMonths(const D1:TDateTime; Amount:Integer):TDateTime;',TScriptObject.TDateUtilsCall);
 LastClass.AddMethod('function AddYears(const D1:TDateTime; Amount:Integer):TDateTime;',TScriptObject.TDateUtilsCall);
 LastClass.AddMethod('function Today:TDate;',TScriptObject.TDateUtilsCall);
 LastClass.AddMethod('function Now:TDateTime;',TScriptObject.TDateUtilsCall);
 LastClass.AddMethod('function SecondsToTime(const Seconds:Integer):string;',TScriptObject.TDateUtilsCall);

 FDateUtilsClass:=TDateUtils.Create;
 fsGlobalUnit.AddObject('DateUtils',FDateUtilsClass);



 LastClass:=fsGlobalUnit.AddClass(TxParams, 'TParams');
 LastClass.AddMethod('procedure SetParameter(const ParamName:string; const ParamValue:Variant);', TScriptObject.TxParamsCall);
 LastClass.AddMethod('procedure SetParameterNoDefault(const ParamName:string; const ParamValue, DefaultValue:Variant);', TScriptObject.TxParamsCall);
 LastClass.AddMethod('procedure LoadFromDataSet(DataSet:TDataSet);', TScriptObject.TxParamsCall);
 LastClass.AddMethod('procedure LoadFromDataSetList(DataSet:TDataSet; const NameField,ValueField:string);', TScriptObject.TxParamsCall);
 LastClass.AddMethod('procedure LoadFromParams(Params:TParams);', TScriptObject.TxParamsCall);
 LastClass.AddMethod('function ParamByName(const Value: string): TParam;', TScriptObject.TxParamsCall);
 LastClass.AddMethod('function ParamByNameDef(const ParamName: string;  const Default: Variant): Variant;', TScriptObject.TxParamsCall);
 LastClass.AddMethod('function ToString:string;', TScriptObject.TxParamsCall);


 LastClass:=fsGlobalUnit.AddClass(TGlobalSettings, 'TObject');
 LastClass.AddMethod('function SettingByName(const Value: string): string;', TScriptObject.TGlobalSettingsCall);
 LastClass.AddMethod('function SettingExists(const Value: string): Boolean;', TScriptObject.TGlobalSettingsCall);

 FGlobalSettingClass:=TGlobalSettings.Create;
 fsGlobalUnit.AddObject('GlobalSettings',FGlobalSettingClass);


 fsGlobalUnit.AddClass(TFDDataSet,  'TDataSet');
 fsGlobalUnit.AddClass(TFDAdaptedDataSet,  'TFDDataSet');
 fsGlobalUnit.AddClass(TFDCustomMemTable,  'TFDAdaptedDataSet');
 fsGlobalUnit.AddClass(TFDMemTable,  'TFDCustomMemTable');
 fsGlobalUnit.AddClass(TBaseDataSet,  'TFDMemTable');
 fsGlobalUnit.AddClass(TxDataSet,     'TBaseDataSet');



 fsGlobalUnit.AddClass(TFrame,    '');
 LastClass:=fsGlobalUnit.AddClass(TBasePlugin,     'TFrame');
 LastClass.AddMethod('function KeyFieldValue: Integer', TScriptObject.TPluginCall);
// LastClass.AddProperty('DataSet','TxDataSet',TScriptObject.GetProp, nil);

 fsGlobalUnit.AddClass(TGridPlugin,     'TBasePlugin');
 fsGlobalUnit.AddClass(TTreeGridPlugin, 'TBasePlugin');
 fsGlobalUnit.AddClass(TPagePlugin,     'TBasePlugin');
 fsGlobalUnit.AddClass(TMultiPagePlugin,'TBasePlugin');

 fsGlobalUnit.AddClass(TActivityCondition,     'TObject');
 fsGlobalUnit.AddClass(TMiceAction,     'TAction');
 LastClass:=fsGlobalUnit.AddClass(TMiceActionList, 'TObjectDictionary');
 LastClass.AddMethod('function ActionByName(const ActionNaame:string) : TMiceAction', TScriptObject.TMiceActionListCall);
 LastClass.AddMethod('function ActionByID(AppCmdId:Integer) : TMiceAction', TScriptObject.TMiceActionListCall);


// LastClass.AddMethod('function Execute: Boolean', TScriptObject.CallMethod);

 fsGlobalUnit.AddClass(TPluginProperties,    'TPluginProperties');




 {


Доступ к переменным из программы
 Для получения/установки значения переменных скрипта, используйте свойство
TfsScript.Variables.
val := fsScript1.Variables['i'];
fsScript1.Variables['i'] := 10;


Вызов функции из программы
 Для вызова скриптовой функции используйте метод TfsScript.CallFunction.
Первый параметр это имя вызываемой функции, второй - это параметры функции.
val := fsScript1.CallFunction('ScriptFunc', VarArrayOf(['hello', 1]));
// вызовет 'function ScriptFunc(s: String; i: Integer)'



Добавление процедуры в скрипт
 Для добавления процедуры/функции в скрипт выполните следующие действия:
- Создайте обработчик - функцию TfsCallMethodEvent.
- Вызовите метод TfsScript.AddMethod. Первый параметр - это синтаксис функции
(обратите внимание - синтаксис, независимо от используемого вами языка, должен
быть паскалевским!), второй - ссылка на обработчик TfsCallMethodEvent.

procedure TForm1.DelphiFunc(s: String; i: Integer);
begin
 ShowMessage(s + ', ' + IntToStr(i));
end;

function TForm1.CallMethod(Instance: TObject; ClassType: TClass; const MethodName: String; var Params: Variant): Variant;
begin
 DelphiFunc(Params[0], Params[1]);
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
 fsScript1.AddMethod('procedure DelphiFunc(s: String; i: Integer)', CallMethod);
 if fsScript1.Compile then
 fsScript1.Execute else
 ShowMessage(fsScript1.ErrorMsg);
end;



Добавление функции с параметром class
Поскольку все параметры представляются как массив типа Variant, вам надо
преобразовать их в объекты.
fsScript1.AddMethod('procedure HideButton(Button: TButton)',CallMethod);

function TForm1.CallMethod(Instance: TObject; ClassType: TClass; const MethodName: String;  var Params: Variant): Variant;
begin
 TButton(Integer(Params[0])).Hide;
end;

Добавление функции, возвращающей значение типа class
 Поскольку значения, возвращаемые дескриптором метода, это массив типа
Variant, вам надо преобразовать результаты типа TObject к Variant.
fsScript1.AddMethod('function MainForm: TForm', CallMethod);

function TForm1.CallMethod(Instance: TObject; ClassType: TClass; const MethodName: String;  var Params: Variant): Variant;
begin
 Result := Integer(Form1);
end;

Добавление константы в скрипт
 Для добавления в скрипт константы вызовите метод TfsScript.AddConst. Первый
параметр - это наименование константы, второй - тип (должен быть одним из
стандартных типов), третий - значение.

procedure TForm1.Button1Click(Sender: TObject);
begin
 fsScript1.AddConst('pi', 'Extended', 3.14159);
end;






Добавление объекта в скрипт
 Для добавления объекта в скрипт вызовите метод TfsScript.AddObject. Первый
параметр это имя объекта, второй - собственно, объект.
fsScript1.AddObject('Button1', Button1);
 Если добавляемый объект имеет незарегистрированный класс, то предварительно
надо зарегистрировать его:
fsScript1.AddClass(TForm1, 'TForm');
fsScript1.AddObject('Form1', Self);
 Вы также можете использовать метод fsGlobalUnit.AddForm для добавления
формы или модуля данных вместе со всеми дочерними компонентами:
fsGlobalUnit.AddForm(Form1);
 В этом случае регистрировать класс формы с помощью AddClass не требуется.
Теперь вы можете обращаться к элементам формы из скрипта:
 Form1.Button1.Caption := '...'

}



{
Присвоить событие в скрипте:

procedure ButtonClick(Sender:TObject);
begin
 ShowMessage('Hello event!');
end;

procedure bnCreateNewButtonClick(Sender:TObject);
var
 f: TForm;
 b: TButton;
begin
 f := TForm.Create(nil);
 try
 f.Caption := 'Test it!';
 f.BorderStyle := bsDialog;
 f.Position := poScreenCenter;
 b := TButton.Create(f);
 b.Name := 'Button1';
 b.Parent := f;
 b.SetBounds(10, 10, 75, 25);
 b.Caption := 'Test';
 b.OnClick := @ButtonClick;//  same as b.OnClick := 'ButtonClick'
 //b.OnMouseMove := @ButtonMouseMove;
 f.ShowModal;
 finally
  f.Free;
 end;
end;



}
finalization
 FStingUtilsClass.Free;
 FDateUtilsClass.Free;
 FGlobalSettingClass.Free;
end.
