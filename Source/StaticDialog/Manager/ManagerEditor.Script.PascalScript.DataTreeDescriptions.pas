unit ManagerEditor.Script.PascalScript.DataTreeDescriptions;

interface
 uses
  Mice.Script.ClassTree,
  Common.StringUtils;

implementation

var
 C:TClassEventsTree;


resourcestring
S_DIALOG_EVENT_BEFORE_POST = 'Occurs when user click OK button, before posting changes to the database.';
S_DIALOG_EVENT_AFTER_POST = 'Occurs after all changes were saved to the database.';
S_DIALOG_EVENT_BEFORE_OPEN = 'Occurs before dialog appear on screen.';
S_DIALOG_EVENT_AFTER_OPEN = 'Occurs after main datatable filled with data.';
S_DIALOG_EVENT_INSERT = 'Occurs when user add new record';
S_DIALOG_EVENT_EDIT = 'Occurs when user edit record';
S_DIALOG_EVENT_ON_DRAGFILES = 'Occurs when user drags files in Dialog. DragAndDropFiles property must be set to True';
S_DIALOG_METHOD_CONTROLHINT_DESC = 'Show balloon hint on specified control. If control not found, OK button used instead';
S_DIALOG_METHOD_FILEDBYNAME_DESC = 'Access current dialog fields as TFiled class';
S_DIALOG_PROPERTY_DRAGANDDROPFILES = 'Allows user to drag files from Windows shell';


S_PLUGIN_PROPERTY_KEYFIELDVALUE = 'Get current Value of KeyField';
S_PLUGIN_EVENT_BEFORE_PUSH = 'Occurs before push docflow document';
S_PLUGIN_EVENT_BEFORE_REFRESH = 'Occurs before refresh data';
S_PLUGIN_EVENT_AFTER_REFRESH = 'Occurs after refresh data';
S_PLUGIN_EVENT_AFTER_PUSH = 'Occurs after pushing docflow document';
S_PLUGIN_EVENT_BEFORE_ROLLBACK = 'Occurs before rollling back docflow document';
S_PLUGIN_EVENT_AFTER_ROLLBACK = 'Occurs after rolling back docflow document';
S_PLUGIN_EVENT_AFTER_BUILD = 'Occurs when after plugin initialize';
S_PLUGIN_METHOD_REFRESH_DATASET = 'Refreshes current data';
S_PLUGIN_METHOD_FORCEREFRESH_DATASET = 'Refreshes current data irregardless of current refresh lock';

S_APPCMD_EVENT_EXECUTE = 'Occures when users executes(clicks) command';


S_DEFAULT_CONSTRUCTOR_DESC = 'Creates an instance of object';
S_DEFAULT_DESTRUCTOR_DESC = 'Destroys an instance of object';
S_DEFAULT_APPPARAMS_DESC  ='Represents collection of TxParams';
S_DEFAULT_APP_SETPARAMETER_DESC = 'Set value for existing parameters or create new one';
S_DEFAULT_SAVE_TO_FILE_DESC = 'Saves current data to file.';
S_DEFAULT_SAVE_TO_STREAM_DESC = 'Saves current data to TStream.';


S_MICEREPORTS_APP_REPORTS_ID_DESC  ='Sets AppReportsId to execute specifed report';
S_MICEREPORTS_EXPORT_TITTLE_DESC = 'Set export title (pdf).';
S_MICEREPORTS_EXECUTE_DESC ='Execute current report(preview).';
S_MICEREPORTS_EDIT_DESC ='Edit current report.';
S_MICEREPORTS_EXPORT_TO_FILE_DESC = 'Saves current report to file. File types: pdf, docx, xlsx, txt, csv, doc, xls';
S_MICEREPORTS_EXPORT_TO_STREAM_DESC = 'Saves current report to TStream. File types: pdf, docx, xlsx, txt, csv, doc, xls';
S_MICEREPORTS_SHOW_PROGRESS_DESC = 'Enables or disables progress bar while loading report(Should be disabled for thread).';


S_TSTRINGUTILS_SAMESTRING_DESC = 'Compares two strings case insensitive';
S_TSTRINGUTILS_REMOVEDUALSPACES_DESC = 'Returns string without dual spaces ("  ")';
S_TSTRINGUTILS_LEFTFROMDOT_DESC = 'Returns text which is left from dot ".", or default if not found';
S_TSTRINGUTILS_RIGHTFROMDOT_DESC = 'Returns text which is right from dot ".", or default if not found';
S_TSTRINGUTILS_LEFTFROMTEXT_DESC = 'Returns text which is left from specified text or default if not found';
S_TSTRINGUTILS_RIGHTFROMTEXT_DESC = 'Returns text which is left from specified text or default if not found';
S_TSTRINGUTILS_REMOVEBRACKETS_DESC = 'Removes all specified brackets';
S_TSTRINGUTILS_EXTRACTQUITEDTEXT_DESC = 'Extracts quoted text from string';
S_TSTRINGUTILS_CONTAINS_DESC = 'Returns true if string contains specified text';
S_TSTRINGUTILS_PRETTY_DESC = 'Returns pretty string ("HeLlO WoRlD"=>"Hello world") ';
S_TSTRINGUTILS_STARTSWITH_DESC = 'Returns true if string starts with specified text';
S_TSTRINGUTILS_ENDSWITH_DESC = 'Returns true if string ends with specified text';
S_TSTRINGUTILS_POSITION_DESC = 'Returns position(index) of specified text';
S_TSTRINGUTILS_POSITIONFROM_DESC = 'Returns position(index) of specified text from starting index';
S_TSTRINGUTILS_DEQUOTEDELPHISTRING_DESC = 'Returns string with removed #39 char from start and end';
S_TSTRINGUTILS_TOLOWER_DESC = 'Returns lowercase of string';
S_TSTRINGUTILS_TOUPPER_DESC = 'Returns uppercase of string';
S_TSTRINGUTILS_QUOTEDSTR_DESC = 'Returns quoted string (#39)';
S_TSTRINGUTILS_WORDCOUNT_DESC = 'Returns number of words in string';
S_TSTRINGUTILS_EXTRACTWORD_DESC = 'Returns specified word by number in string';
S_TSTRINGUTILS_HASH_DESC = 'Returns string with deleteted characters [ _-#.,!=#9#13#10#39";@]';
S_TSTRINGUTILS_CONTAINSANYOF_DESC = 'Returns true if string contains any of items in specified array';
S_TSTRINGUTILS_DELETEALLOF_DESC = 'Returns string with all items deleted in specified array';

S_TSTRINGUTILS_ISNUMBER_DESC = 'Returns true if string is positive integer';
S_TSTRINGUTILS_SPACECOUNT_DESC = 'Returns count of spaces in string with all double spaces counted as 1';
S_TSTRINGUTILS_STRINGCOUNT_DESC = 'Returns count of one string contained in another one; Ex: StringCount("xexeXe", "xe", True) = 3';
S_TSTRINGUTILS_LENGTH_DESC = 'Return string length';


S_TDATEUTILS_TOJSONDATE_DESC = 'Returns string with yyyy-mm-dd 2020-10-15';
S_TDATEUTILS_TOJSONDATETIME_DESC = 'Returns string with ISO 8601 format : yyyy-mm-dd hh:mm:ss:ms  2012-04-23T18:25:43.511Z';
S_TDATEUTILS_TODAY_DESC = 'Returns local date without time';
S_TDATEUTILS_NOW_DESC = 'Returns local datetime';

S_TXPARAMS_ASQUERYSTRING_DESC = 'Set or get parameters as Query string ?Name=User&Value=42';
S_TXPARAMS_ASSTRING_DESC = 'Set or get parameters as SQL string @Name=User, @Value=42';
S_TXPARAMS_ASJSON_DESC = 'Set or get parameters as Json string {"Name"="User";"Value"=42}';
S_TXPARAMS_LOADFROMDATASET_DESC = 'Load parameters from dataset with setting fieldname as paramname';
S_TXPARAMS_LOADFROMDATASETLIST_DESC = 'Load parameters from dataset in while not eof loop';
S_TXPARAMS_SETPARAMETER_DESC = 'Add new paramater or sets value for exsisting one';
S_TXPARAMS_PARAMBYNAMEDEF_DESC = 'Returns default value if specified parameter was not found';


S_GLOBALSETTINGS_SETTING_BY_NAME_DESC = 'Returns value of setting';
S_GLOBALSETTINGS_SETTING_EXISTS_DESC = 'Returns true if setting exists';

S_DIALOG_SHOWMESSAGE_DESC ='Shows a message';
S_TMESSAGE_DIALOG_MSHOWMESSAGE_DESC = 'Shows a message with ability to copy text';
S_TMESSAGE_DIALOG_MSHOWMESSAGEEX_DESC = 'Shows extended message dialog with ability to copy text';
S_TMESSAGE_DIALOG_MINPUTBOX_DESC = 'Prompts for user input in text area';
S_TSHOWDATASET_DESC = 'Show contents of specified dataset';
S_TSHOWDATASETEX_DESC = 'Show contents of specified dataset with extended properties';

procedure RegClass(AClassName:string);
begin
 C.RegisterClassMethod(AClassName,'Create',S_DEFAULT_CONSTRUCTOR_DESC,'constructor Create;');
 C.RegisterClassMethod(AClassName,'Free',S_DEFAULT_DESTRUCTOR_DESC,'destructor Free;');
end;

procedure RegClassA(AClassName:string); //AOwner:TComponent)
begin
 C.RegisterClassMethod(AClassName,'Create',S_DEFAULT_CONSTRUCTOR_DESC,'constructor Create(AOwner:TComponent);');
 C.RegisterClassMethod(AClassName,'Free',S_DEFAULT_DESTRUCTOR_DESC,'destructor Free;');
end;


initialization
 C:=TClassEventsTree.DefaultInstance;


  {Adaptive Dialog}
  C.RegisterAppEvent(SAdaptiveDialog, 'BeforePost', S_DIALOG_EVENT_BEFORE_POST , 'procedure BeforePost(var SaveChanges:Boolean);');
  C.RegisterAppEvent(SAdaptiveDialog,'AfterPost',  S_DIALOG_EVENT_AFTER_POST ,  'procedure AfterPost;');
  C.RegisterAppEvent(SAdaptiveDialog,'AfterOpen',  S_DIALOG_EVENT_AFTER_OPEN ,  'procedure AfterOpen;');
  C.RegisterAppEvent(SAdaptiveDialog,'EnterInsertingState',  S_DIALOG_EVENT_INSERT ,  'procedure EnterInsertingState;');
  C.RegisterAppEvent(SAdaptiveDialog,'EnterEditingState',  S_DIALOG_EVENT_EDIT ,  'procedure EnterEditingState;');
  C.RegisterAppEvent(SAdaptiveDialog,'OnDragAndDropFiles',  S_DIALOG_EVENT_ON_DRAGFILES ,  'procedure OnDragAndDropFiles(Sender:TObject; List:TStrings);');
  C.RegisterClassMethod(SAdaptiveDialog,'ControlHint',  S_DIALOG_METHOD_CONTROLHINT_DESC ,'procedure ControlHint(const ControlName, Title, Description: string)');
  C.RegisterClassMethod(SAdaptiveDialog,'FieldByName',  S_DIALOG_METHOD_FILEDBYNAME_DESC ,'function FieldByName(const FieldName:string):TField');
  C.RegisterClassMethod(SAdaptiveDialog,'_F',  S_DIALOG_METHOD_FILEDBYNAME_DESC ,'function _F(const FieldName:string):TField');
  C.RegisterClassPropertyBoolean(SAdaptiveDialog,'DragAndDropFiles', S_DIALOG_PROPERTY_DRAGANDDROPFILES);
// C.RegisterAppEvent('BeforeOpen', S_DIALOG_EVENT_BEFORE_OPEN , 'procedure BeforeOpen;');

  {ActivePlugin}
  C.RegisterClassPropertyInteger(sTBasePlugin,'KeyFieldValue',S_PLUGIN_PROPERTY_KEYFIELDVALUE);
  C.RegisterClassProperty(sTBasePlugin,'Properties','','TPluginProperties');
  C.RegisterClassMethod(sTBasePlugin,'RefreshDataSet',S_PLUGIN_METHOD_REFRESH_DATASET,'procedure RefreshDataSet;');
  C.RegisterClassMethod(sTBasePlugin,'ForceRefreshDataSet',S_PLUGIN_METHOD_FORCEREFRESH_DATASET,'procedure ForceRefreshDataSet;');
  C.RegisterAppEvent(sTBasePlugin, 'BeforePushDocument',S_PLUGIN_EVENT_BEFORE_PUSH,'procedure BeforePushDocument(var Allow:Boolean; DataSet:TDataSet; DocumentsId, dfPathFoldersIdSource, dfMethodsIdTarget, dfEventsId: Integer);');
  C.RegisterAppEvent(sTBasePlugin, 'AfterPushDocument',S_PLUGIN_EVENT_AFTER_PUSH,'procedure AfterPushDocument(DataSet:TDataSet; DocumentsId, dfPathFoldersId: Integer);');
  C.RegisterAppEvent(sTBasePlugin, 'BeforeRollbackDocument',S_PLUGIN_EVENT_BEFORE_ROLLBACK,'BeforeRollbackDocument(var Allow:Boolean; DataSet:TDataSet; DocumentsId, dfPathFoldersIdSource, dfMethodsIdTarget, dfEventsId: Integer);');
  C.RegisterAppEvent(sTBasePlugin, 'AfterRollbackDocument',S_PLUGIN_EVENT_AFTER_ROLLBACK,'procedure AfterRollbackDocument(DataSet:TDataSet; DocumentsId, dfPathFoldersId: Integer);');
  C.RegisterAppEvent(sTBasePlugin, 'AfterBuild',S_PLUGIN_EVENT_AFTER_BUILD,'procedure AfterBuild;');
  C.RegisterAppEvent(sTBasePlugin, 'BeforeOpen',S_PLUGIN_EVENT_BEFORE_REFRESH,'procedure BeforeOpen;');
  C.RegisterAppEvent(sTBasePlugin, 'AfterOpen',S_PLUGIN_EVENT_AFTER_REFRESH,'procedure AfterOpen;');


  {AppCmd}
  C.RegisterAppEvent(SCommand, 'Execute', S_APPCMD_EVENT_EXECUTE,'procedure Execute;');

  {TMiceUser}
  C.RegisterClassPropertyString(STMiceUser, 'UserId','');
  C.RegisterClassPropertyString(STMiceUser, 'FullName','');
  C.RegisterClassPropertyString(STMiceUser, 'LoginName','');
  C.RegisterClassProperty(STMiceUser, 'RoleList','','TStringList');
  C.RegisterClassMethod(STMiceUser,'IsInRole','','function IsInRole(const RoleName:string):Boolean;');

  RegClass(sTxParams);
  C.RegisterClassMethod(sTxParams,'LoadFromDataSet',S_TXPARAMS_LOADFROMDATASET_DESC,'procedure LoadFromDataSet(DataSet:TDataSet);');
  C.RegisterClassMethod(sTxParams,'LoadFromDataSetList',S_TXPARAMS_LOADFROMDATASETLIST_DESC,'procedure LoadFromDataSetList(DataSet:TDataSet; const NameField,ValueField:string);');
  C.RegisterClassMethod(sTxParams,'SetParameter',S_TXPARAMS_SETPARAMETER_DESC,'procedure SetParameter(const ParamName:string; const ParamValue:Variant);');
  C.RegisterClassMethod(sTxParams,'ParamByNameDef',S_TXPARAMS_PARAMBYNAMEDEF_DESC,'function ParamByNameDef(const ParamName:string; const Default:Variant):Variant;');
  C.RegisterClassProperty(sTxParams,'AsQueryString',S_TXPARAMS_ASQUERYSTRING_DESC,'AsQueryString:string');
  C.RegisterClassProperty(sTxParams,'AsString',S_TXPARAMS_ASSTRING_DESC,'AsString:string');
  C.RegisterClassProperty(sTxParams,'AsJson',S_TXPARAMS_ASJSON_DESC,'AsJson:string ');

  RegClassA(sTxDataSet);
  C.RegisterClassMethod(sTxDataSet,'SetParameter',S_DEFAULT_APP_SETPARAMETER_DESC,'procedure SetParameter(const ParamName:string; const ParamValue:Variant);');
  C.RegisterClassMethod(sTxDataSet,'Open','','procedure Open;');
  C.RegisterClassMethod(sTxDataSet,'OpenOrExecute','','procedure OpenOrExecute;');
  C.RegisterClassProperty(sTxDataSet,'Params',S_DEFAULT_APPPARAMS_DESC,'Params:TxParams');
  C.RegisterClassProperty(sTxDataSet,'ProviderName','','ProviderName:string');
  C.RegisterClassProperty(sTxDataSet,'ProviderNamePattern','','ProviderNamePattern:string');
  C.RegisterClassProperty(sTxDataSet,'DBName','','DBName:string');


  RegClassA(STMiceReport);
  C.RegisterClassMethod(STMiceReport,'SetParameter',S_DEFAULT_APP_SETPARAMETER_DESC,'procedure SetParameter(const ParamName:string; const ParamValue:Variant);');
  C.RegisterClassMethod(STMiceReport,'Edit',S_MICEREPORTS_EDIT_DESC,'procedure Edit;');
  C.RegisterClassMethod(STMiceReport,'Execute',S_MICEREPORTS_EXECUTE_DESC,'procedure Execute;');
  C.RegisterClassMethod(STMiceReport,'ExportToFile',S_MICEREPORTS_EXPORT_TO_FILE_DESC,'procedure ExportToFile(const FileName, FileType:string);');
  C.RegisterClassMethod(STMiceReport,'ExportStream',S_MICEREPORTS_EXPORT_TO_STREAM_DESC,'procedure ExportToStream(Stream:TStream; const FileType:string);');
  C.RegisterClassProperty(STMiceReport,'Params',S_DEFAULT_APPPARAMS_DESC,sTxParams);
  C.RegisterClassPropertyInteger(STMiceReport,'AppReportsId',S_MICEREPORTS_APP_REPORTS_ID_DESC);
  C.RegisterClassPropertyString(STMiceReport,'ExportTitle',S_MICEREPORTS_EXPORT_TITTLE_DESC);
  C.RegisterClassPropertyBoolean(STMiceReport,'ShowProgress',S_MICEREPORTS_SHOW_PROGRESS_DESC);


  RegClass(STAppTemplate);
//  AppTemplate.Builder
//  C.RegisterClassMethod(STAppTemplate,'SetParameter',S_DEFAULT_APP_SETPARAMETER_DESC,'procedure SetParameter(const ParamName:string; const ParamValue:Variant);');
  C.RegisterClassProperty(STAppTemplate,'Params',S_DEFAULT_APPPARAMS_DESC,sTxParams);
  C.RegisterClassPropertyInteger(STAppTemplate,'AppTemplatesId','');
  C.RegisterClassPropertyString(STAppTemplate,'FileName','');
  C.RegisterClassPropertyString(STAppTemplate,'DBName','');
  C.RegisterClassPropertyBoolean(STAppTemplate,'AutoClose','');
  C.RegisterClassPropertyBoolean(STAppTemplate,'HandleErrors','');
  C.RegisterClassPropertyBoolean(STAppTemplate,'HadError','');
  C.RegisterClassPropertyBoolean(STAppTemplate,'UserAbort','');
  C.RegisterClassMethod(STAppTemplate,'Execute','','function Execute:Boolean');

  RegClass(SAdaptiveDialog);
  C.RegisterClassMethod(SAdaptiveDialog,'SetParameter',S_DEFAULT_APP_SETPARAMETER_DESC,'procedure SetParameter(const ParamName:string; const ParamValue:Variant);');
  C.RegisterClassProperty(SAdaptiveDialog,'Params',S_DEFAULT_APPPARAMS_DESC,sTxParams);
  C.RegisterClassPropertyString(SFunctions,'ExceptionMessage','');
  C.RegisterClassPropertyString(SFunctions,'ExceptionClassName','');
  C.RegisterClassMethod(SFunctions,'RaiseException','','RaiseException(Param: String)');



  C.RegisterClassMethod(SDialogs,'-OpenFile','','function OpenFileDialogExecute(const FileName, FileMask:string):Boolean');
  C.RegisterClassMethod(SDialogs,'-SaveFile','','function SaveFileDialogExecute(const FileName, FileMask:string):Boolean');
  C.RegisterClassMethod(SDialogs,'-SelectDirectory','','function SelectDirectoryDialogExecute(DirName :string):Boolean');
  C.RegisterClassMethod(SDialogs,'-TMiceInputBox','','class function Execute(ImageIndex: Integer;  var s: string; const LabelText:string=''; const Caption: string=''):Boolean;');
  C.RegisterClassMethod(SDialogs,'-MessageBox','','function MessageBox():Integer');
  C.RegisterClassMethod(SDialogs,'ShowMessage',S_DIALOG_SHOWMESSAGE_DESC,'procedure ShowMessageList(const Msg:string)');
  C.RegisterClassMethod(SDialogs,'MShowMessage',S_TMESSAGE_DIALOG_MSHOWMESSAGE_DESC,'procedure MShowMessage(const Msg:string);');
  C.RegisterClassMethod(SDialogs,'MShowMessageEx',S_TMESSAGE_DIALOG_MSHOWMESSAGEEX_DESC,'procedure MShowMessageEx(const Msg, WindowCaption, LabelCaption:string; ImageIndex:Integer);');
  C.RegisterClassMethod(SDialogs,'MShowMessageList',S_TMESSAGE_DIALOG_MSHOWMESSAGE_DESC,'procedure MShowMessageList(List:TStrings);');
  C.RegisterClassMethod(SDialogs,'MShowMessageListEx',S_TMESSAGE_DIALOG_MSHOWMESSAGEEX_DESC,'procedure MShowMessageListEx(List:TStrings;const WindowCaption, LabelCaption:string;ImageIndex:Integer);');
  C.RegisterClassMethod(SDialogs,'MInputBox',S_TMESSAGE_DIALOG_MINPUTBOX_DESC,'function MInputBox(const WindowCaption, LabelCaption: string; var s: string; ImageIndex:Integer):Boolean;');
  C.RegisterClassMethod(SDialogs,'ShowDataSet',S_TSHOWDATASET_DESC,'procedure ShowDataSet(DataSet:TDataSet);');
  C.RegisterClassMethod(SDialogs,'ShowDataSetEx',S_TSHOWDATASETEX_DESC,'procedure ShowDataSetEx(DataSet:TDataSet; const WindowCaption, LabelCaption:string; AImageIndex:Integer);');


  {-----------------------------------------------Helper classes---------------------------------------------------}

  {StringUtils}
  C.RegisterClassMethod(SStringUtils,'SameString',S_TSTRINGUTILS_SAMESTRING_DESC,'SameString(const Str1, Str2:string):Boolean');
  C.RegisterClassMethod(SStringUtils,'RemoveDualSpaces',S_TSTRINGUTILS_REMOVEDUALSPACES_DESC,'RemoveDualSpaces(const s:string):string');
  C.RegisterClassMethod(SStringUtils,'LeftFromDot',S_TSTRINGUTILS_LEFTFROMDOT_DESC,'LeftFromDot(const s, Default: string):string;');
  C.RegisterClassMethod(SStringUtils,'RightFromDot',S_TSTRINGUTILS_RIGHTFROMDOT_DESC,'RightFromDot(const s, Default: string):string;');
  C.RegisterClassMethod(SStringUtils,'LeftFromText',S_TSTRINGUTILS_LEFTFROMTEXT_DESC,'LeftFromText(const s, Pattern, Default: string):string;');
  C.RegisterClassMethod(SStringUtils,'RightFromText',S_TSTRINGUTILS_RIGHTFROMTEXT_DESC,'RightFromText(const s, Pattern, Default: string):string;');
  C.RegisterClassMethod(SStringUtils,'RemoveBrackets',S_TSTRINGUTILS_REMOVEBRACKETS_DESC,'RemoveBrackets(const s:string; StartBracket, EndBracket:string):string;');
  C.RegisterClassMethod(SStringUtils,'ExtractQuotedText',S_TSTRINGUTILS_EXTRACTQUITEDTEXT_DESC,'ExtractQuotedText(const s:string; const QuoteChar1, QuoteChar2:string):string;');
  C.RegisterClassMethod(SStringUtils,'Pretty',S_TSTRINGUTILS_PRETTY_DESC,'Pretty(const s1:string):string;');
  C.RegisterClassMethod(SStringUtils,'Contains',S_TSTRINGUTILS_CONTAINS_DESC,'Contains(const s1, s2: string; IsCaseSensitive: Boolean): Boolean;');
  C.RegisterClassMethod(SStringUtils,'StartsWith',S_TSTRINGUTILS_STARTSWITH_DESC,'StartsWith(const s1, s2:string):Boolean');
  C.RegisterClassMethod(SStringUtils,'EndsWith',S_TSTRINGUTILS_ENDSWITH_DESC,'EndsWith(const s1, s2:string):Boolean');
  C.RegisterClassMethod(SStringUtils,'Position',S_TSTRINGUTILS_POSITION_DESC,'Position(const s1, s2:string;IgnoreCase:Boolean):Integer;');
  C.RegisterClassMethod(SStringUtils,'PositionFrom',S_TSTRINGUTILS_POSITIONFROM_DESC,'PositionFrom(const s1, s2:string;IgnoreCase:Boolean; StartIndex:Integer):Integer');
  C.RegisterClassMethod(SStringUtils,'ToLower',S_TSTRINGUTILS_TOLOWER_DESC,'ToLower(const s1:string):string');
  C.RegisterClassMethod(SStringUtils,'ToUpper',S_TSTRINGUTILS_TOUPPER_DESC,'ToUpper(const s1:string):string');
  C.RegisterClassMethod(SStringUtils,'QuotedStr',S_TSTRINGUTILS_QUOTEDSTR_DESC,'QuotedStr(const s1:string):string');
  C.RegisterClassMethod(SStringUtils,'WordCount',S_TSTRINGUTILS_WORDCOUNT_DESC,'WordCount(const s:string):Integer');
  C.RegisterClassMethod(SStringUtils,'ExtractWord',S_TSTRINGUTILS_EXTRACTWORD_DESC,'ExtractWord(const s:string; WordNumber:Integer):string');
  C.RegisterClassMethod(SStringUtils,'DeleteAllOf',S_TSTRINGUTILS_DELETEALLOF_DESC,'DeleteAllOf(const s:string; const Args: array of string): string');
  C.RegisterClassMethod(SStringUtils,'ContainsAnyOf',S_TSTRINGUTILS_CONTAINSANYOF_DESC,'ContainsAnyOf(const s:string; const Args: array of string): Boolean');
  C.RegisterClassMethod(SStringUtils,'Hash',S_TSTRINGUTILS_HASH_DESC,'Hash(const s:string): string');
  C.RegisterClassMethod(SStringUtils,'IsNumber',S_TSTRINGUTILS_ISNUMBER_DESC,'IsNumber(const s:string):Boolean');
  C.RegisterClassMethod(SStringUtils,'SpaceCount',S_TSTRINGUTILS_SPACECOUNT_DESC,'SpaceCount(const s:string):Integer');
  C.RegisterClassMethod(SStringUtils,'StringCount',S_TSTRINGUTILS_STRINGCOUNT_DESC,'StringCount(s,s1:string; IgnoreCase:Boolean):Integer');
  C.RegisterClassMethod(SStringUtils,'Length',S_TSTRINGUTILS_LENGTH_DESC,'Length(const s1:string):Integer;');


  {DateUtils}
  C.RegisterClassMethod(SDateUtils,'ToJsonDate','','ToJsonDate(const D:TDateTime):string');
  C.RegisterClassMethod(SDateUtils,'ToJsonDateTime','','ToJsonDateTime(const D:TDateTime):string');
  C.RegisterClassMethod(SDateUtils,'EndOfADay','','EndOfADay(const D:TDateTime):TDateTime');
  C.RegisterClassMethod(SDateUtils,'StartOfTheQuarter','','StartOfTheQuarter(const D:TDateTime):TDateTime;');
  C.RegisterClassMethod(SDateUtils,'EndOfTheQuarter','','EndOfTheQuarter (const D:TDateTime):TDateTime;');
  C.RegisterClassMethod(SDateUtils,'StartOfTheYear','','StartOfTheYear(const D:TDateTime):TDateTime;');
  C.RegisterClassMethod(SDateUtils,'EndOfTheYear','','EndOfTheYear(const D:TDateTime):TDateTime;');
  C.RegisterClassMethod(SDateUtils,'StartOfAMonth','','StartOfAMonth(const D:TDateTime):TDateTime;');
  C.RegisterClassMethod(SDateUtils,'EndOfAMonth','','EndOfAMonth(const D:TDateTime):TDateTime;');
  C.RegisterClassMethod(SDateUtils,'RemoveTime','','RemoveTime(const D:TDateTime):TDateTime;');
  C.RegisterClassMethod(SDateUtils,'DateTimeToStr','','DateTimeToStr(const D:TDateTime; const AFormat:string):string');
  C.RegisterClassMethod(SDateUtils,'DaysBetween','','DaysBetween(const D1, D2:TDateTime):Integer');
  C.RegisterClassMethod(SDateUtils,'AddDays','','AddDays(const D1:TDateTime; Amount:Integer):TDateTime;');
  C.RegisterClassMethod(SDateUtils,'AddMonths','','AddMonths(const D1:TDateTime; Amount:Integer):TDateTime;');
  C.RegisterClassMethod(SDateUtils,'AddYears','','AddYears(const D1:TDateTime; Amount:Integer):TDateTime;');
  C.RegisterClassMethod(SDateUtils,'Today',S_TDATEUTILS_TODAY_DESC,'Today:TDate');
  C.RegisterClassMethod(SDateUtils,'Now',S_TDATEUTILS_NOW_DESC,'Now:TDateTime');


  C.RegisterClassMethod(SGlobalSettings,'SettingByName',S_GLOBALSETTINGS_SETTING_BY_NAME_DESC,'SettingByName(const Name:string):string;');
  C.RegisterClassMethod(SGlobalSettings,'SettingExists',S_GLOBALSETTINGS_SETTING_EXISTS_DESC,'SettingExists(const Name:string):Boolean;');




end.
