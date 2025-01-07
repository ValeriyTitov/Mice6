unit CustomControl.Interfaces;

interface
uses
 System.Classes,
 System.Generics.Collections,
 Data.DB,
 DAC.XParams,
 DAC.XParams.Mapper,
 DAC.DataSetList,
 DAC.XDataSet,
 Mice.Script;

type

 ICanSaveLoadState = interface
   ['{A80AFB50-95BE-4991-BC22-CB238A95A625}']
    procedure SaveState(Params:TxParams);
    procedure LoadState(Params:TxParams);
 end;

 ICanManageParams = interface
   ['{B1A5C7DD-777E-41E9-AFD1-DEB7D064E88D}']
   procedure SetParamsTo(Params:TxParams);
 end;

 IHaveDataBinding = interface
   ['{4308A591-021F-44A2-8990-F9997FC9CF3A}']
   function GetAppDialogControlsId:Integer;
   function GetIDataSource:TDataSource;
   function GetIDataField:string;
   procedure SetIDataSource(const Value:TDataSource);
   procedure SetIDataField(const Value:string);
   procedure SetAppDialogControlsId(const Value:Integer);

   property IDataSource:TDataSource read GetIDataSource write SetIDataSource;
   property IDataField:string read GetIDataField write SetIDataField;
   property AppDialogControlsId: Integer read GetAppDialogControlsId write SetAppDialogControlsId;
 end;



  IInheritableAppObject = interface
   ['{D651DF31-167C-4FB0-9184-043576D486D9}']
   function GetParamsMapper:TParamsMapper;
   function GetDBName:string;
   function GetParentObject: IInheritableAppObject;

   property DBName:string read GetDBName;
   property ParamsMapper:TParamsMapper read GetParamsMapper;
   property ParentObject:IInheritableAppObject read GetParentObject;
 end;


 IAmLazyControl=interface
   ['{732A75ED-18D3-42DE-8109-71A5E25FBF4F}']
  procedure LazyInit(ParentObject: IInheritableAppObject);
  procedure RefreshDataSet;
 end;


 IMayDependOnDialog = interface
   ['{C50858F3-AA9C-414F-8258-9447367FE8EE}']
   procedure NotifyDialogChanged;
   function GetDataSet:TxDataSet;
 end;


 ICanInitFromJson = interface
  ['{2341067A-80E0-4E1F-AA63-A9A8B6E151C5}']
  procedure InitFromJson(const Json:string);
 end;


 IHaveScriptSupport = interface
  ['{D4B95250-13E1-456C-BA49-F68B27DAC11A}']
   procedure RegisterScripter(Scripter:TMiceScripter);
 end;

 ICanHaveExternalDataSource = interface
   ['{62CB66FA-F898-4305-AE94-7D7B3E099DCC}']
   procedure SetDataSetList(DataSetList:TDataSetList);
 end;

 IHaveColumns = interface
   ['{D68D4A06-0CF3-47AE-992A-FA3C3F12EE75}']
   procedure BuildColumns(const AppDialogControlsId:Integer; BuildRightNow: Boolean);
 end;


implementation

end.
