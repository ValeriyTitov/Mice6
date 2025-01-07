unit Common.ResourceStrings;

interface

resourcestring
 S_COMMON_OK='OK';
 S_COMMON_OPEN ='Open';
 S_COMMON_CANCEL='Cancel';
 S_COMMON_CLOSE = 'Close';
 S_COMMON_ERROR = 'Error';
 S_COMMON_ABORT = 'Abort';
 S_COMMON_CAUTION = 'Caution';
 S_COMMON_WARNING = 'Warning';
 S_COMMON_WARNING_EXL = 'Warning!';
 S_COMMON_VALIDATE = 'Validate';
 S_COMMON_INFORMATION = 'Information';
 S_COMMON_DATASET_CONTENTS = 'Dataset contents';
 S_COMMON_CONFIRMATION = 'Confirmation';
 S_COMMON_YES = 'Yes';
 S_COMMON_NO='No';
 S_COMMON_ADD = 'Add';
 S_COMMON_NEW = 'New';
 S_COMMON_NEW_GROUP = 'New group';
 S_COMMON_EDIT = 'Edit';
 S_COMMON_COPY = 'Copy';
 S_COMMON_DELETE = 'Delete';
 S_COMMON_SAVE = 'Save';
 S_COMMON_SAVE_AS = 'Save as...';
 S_COMMON_REFRESH = 'Refresh'; //Перечитать
 S_COMMON_MAIN_MENU = 'Main menu';
 S_COMMON_ACTIVITY = 'Activity';
 S_COMMON_ABORTING = 'Aborting...';
 S_COMMON_OPERATION_CANCELED = 'Operation canceled';
 S_COMMON_UNKNOWN_BRACKETS = '<Unknown>';

 S_COMMON_ADD_HINT = 'Add new item';
 S_COMMON_NEW_HINT = 'Create new item';
 S_COMMON_NEW_GROUP_HINT = 'Create new group';
 S_COMMON_EDIT_HINT = 'Edit selected item';
 S_COMMON_COPY_HINT = 'Copy selected item';
 S_COMMON_DELETE_HINT = 'Delete selected item';
 S_COMMON_REFRESH_HINT = 'Refresh current data'; //Перечитать
 S_COMMON_SAVE_HINT = 'Save current data';
 S_COMMON_SAVE_AS_HINT = 'Save data in seperate location';
 S_COMMON_ACTIVITY_HINT ='Change activity';
 S_COMMMON_ACTION_FIND = 'Find...';
 S_COMMMON_ACTION_FIND_HINT = 'Searchs for an item';
 S_COMMMON_ACTION_FIND_NEXT = 'Find next';
 S_COMMMON_ACTION_FIND_NEXT_HINT = 'Find next';


 S_OPEN_FILE_ALL_OFFICE_DOCUMNETS = 'Common documents(*.doc(x);*.xls(x);*.ppt(x);*.pdf)|*.doc;*.docx;*.xls;*.xlsx;*.ppt;*.pptx;*.pdf';
 S_OPEN_FILE_OLD_OFFICE_DOCUMNETS = 'Generic documents(*.doc;*.xls;*.ppt;*.pdf)|*.doc;*.xls;*.ppt;*.pdf';
 S_OPEN_FILE_NEW_OFFICE_DOCUMNETS = 'Documents(*.docx;*.xlsx;*.pptx;*.pdf)|*.docx;*.xlsx;*.pptx;*.pdf';

 S_OPEN_FILE_FILTER_WORD = 'Microsoft Word files(*.doc;*.docx)|*.doc;*.docx';
 S_OPEN_FILE_FILTER_EXCEL = 'Microsoft Excel files(*.xls;*.xlsx)|*.xlsx; *.xlsx';
 S_OPEN_FILE_FILTER_PDF = 'Portable Document Format(*.pdf)|*.pdf;';
 S_OPEN_FILE_FILTER_XML_COMMON = 'Common xml files|*.xml;*.xsd;*.xbrl;*.xtdd';
 S_OPEN_FILE_FILTER_XML_ONLY = 'Xml files (*.xml)|*.xml';
 S_OPEN_FILE_FILTER_JSON = 'Json files(*.json)|*.json';
 S_OPEN_FILE_FILTER_IMAGES_COMMON = 'Common image files (*.jpg;*.jpeg;*.png;*.gif)|*.jpg;*.jpeg;*.png;*.gif';
 S_OPEN_FILE_FILTER_ALL = 'All files (*.*)|*.*';


 S_CLEAR_HISTORY = 'Clear history';
 S_FILE_NOT_FOUND_FMT = 'File not found: %s';
 S_COMMON_ALL_BRAKET='<All>';
 S_COMMON_NONE_BRAKET='<None>';
 S_COMMON_CHANGE_TYPE ='Change type';
 S_COMMON_NEWDOCUMENT = 'New Document';
 S_COMMON_CHANGES_MUST_BE_SAVED = 'Changes must be saved';

 S_COMMON_CANNOT_FIND_TEXT_FMT = 'Cannot find text "%s"';
 S_COMMON_CLONE_HINT = 'Clone selected items';
 S_COMMON_DUBLICATE_HINT = 'Dublicate selected items';
 S_COMMON_NO_ITEM_SELECTED = 'No item slected';

 S_ROWS_FMT='Rows: %d';
 S_COLUMNS_FMT='Columns: %d';

 S_COMMON_START_PERIOD = 'Start period';
 S_COMMON_END_PERIOD ='End period';
 S_COMMON_PREVIOUS_DATE ='Previous date';
 S_COMMON_CURRENT_DATE ='Current date';
 S_COMMON_DATE='Date';
 S_COMMON_AUTOFILL = 'AutoFill';
 S_COMMON_REARRAGE = 'Rearrage';
 S_COMMON_CLEAR = 'Clear';
 S_COMMON_CLONE = 'Clone';
 S_COMMON_DUBLICATE = 'Dublicate';
 S_COMMON_READONLY = 'Read only';
 S_COMMON_READONLY_BRACKETS = '(Read only)';
 S_COMMON_CAPTION = 'Caption';

 S_DEFAULT_COMMON_LOCATION = 'Common';
 S_DEFAULT_APPCOMMAND_LOCATION = 'Edit';

 S_DF_SCHEMA  = 'Schema';

 S_COMMON_SAVECHANGES_BEFORE_EXIT = 'Save changes before you exit ?';
 S_COMMON_SAVECHANGES_Q = 'Save changes ?';
 S_COMMON_CLOSE_CONFIRMATION = 'Are you sure want to exit without saving changes ?';
 S_COMMON_DELETE_RECORD_CAPTION='Delete confirmation';
 S_COMMON_DELETE_RECORD = 'Delete record';
 S_COMMON_CLEAR_ALL_RECORDS = 'Clear all records';
 S_COMMON_DELETE_RECORD_CONFIRMATION='Are you sure you want to delete record(s) ?';
 S_COMMON_DELETE_CONFIRMATION_FMT='Do you realy want to delete %s ?';
 S_COMMON_DELETE_ITEM_CONFIRMATION='Do you realy want to delete this item ?';
 S_COMMON_DELETE_RECORDS_CONFIRMATION_FMT='Are you sure you want to delete %d record(s) ?';



 S_DOCFLOW_GROUP_NAME = 'Document flow'; //Проводки, документооборот
 S_DOCFLOW_PUSH_BUTTON_CAPTION ='Push'; //Провести документ
 S_DOCFLOW_ROLLBACK_BUTTON_CAPTION ='Rollback'; //Откатить документ
 S_DOCFLOW_PROPERTIES_BUTTON_CAPTION ='Workflow';
 S_DOCFLOW_PUSH_BUTTON_HINT ='Push documents by default route(method)';
 S_DOCFLOW_ROLLBACK_BUTTON_HINT ='Rollback documents';
 S_DOCFLOW_PROPERTIES_BUTTON_HINT ='Workflow properties';

 S_DOCFLOW_TRANS ='Document transactions';
 S_DOCFLOW_TRANS_HINT ='Show document transactions history';
 S_DOCFLOW_SCHEMA ='Schema';
 S_DOCFLOW_SCHEMA_HINT ='Show document schema';
 S_DOCFLOW_ERRORLOG ='Errors';
 S_DOCFLOW_ERRORLOG_HINT ='Show document workflow errors';


 E_RECURSIVE_ERROR_FMT = 'Recursive reference while opening "%s", stack: '#13'%s'#13'=>%s';
 E_CANNOT_FIND_GLOBAL_SETTING_FMT = 'Cannnot find global setting with name "%s". Add it through Mice Manager.';
 E_CANNOT_FIND_DATASET_FMT = 'Cannnot find DataSet "%s"';
 E_CANNOT_FIND_ITEM_FMT = 'Cannnot find item "%s"';
 E_CANNOT_FIND_FIELD_DATASET_FMT = 'Cannnot find field "%s" in DataSet "%s"';
 E_INVALID_JSON = 'Invalid Json';
 E_INVALID_LAYOUT_JSON_FMT = 'Invalid layout Json for AppLayoutsId=%d';

const
 S_NULL = 'NULL';

implementation

end.
