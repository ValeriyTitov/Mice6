unit CustomControl.CommonGrid.ColumnBuilder;

interface
 uses
  System.SysUtils, System.Variants, System.Classes,
  cxGraphics, cxControls, VCL.Graphics,cxCalendar,
  Data.DB, cxCheckBox, cxImageComboBox, cxImage, cxBlobEdit, cxTextEdit, cxEdit,
  cxCurrencyEdit,
  Common.Images,
  Common.LookAndFeel,
  Common.ResourceStrings,
  CustomControl.MiceDropDown.Builder,
  CustomControl.AppObject,
  Common.GlobalSettings,
  CustomControl.MiceBalloons,
  DAC.XDataSet;

type
  TGridType = (gtPlugin, gtDialog);

  TCommonColumnBuilder = class
   private
    FDataSet:TDataSet;
    FGridType: TGridType;
    FParentDBName: string;
   protected

    function ValidCurrencySettings:Boolean;
    procedure PopulateDropDown(Items:TcxImageComboBoxItems; const Json:string);
    procedure PopulateCurrency(Items:TcxImageComboBoxItems; const Json:string);

    procedure SetPropertiesDefault(Properties:TcxCustomEditProperties);
    procedure SetPropertiesCheckBox(Properties:TcxCustomEditProperties);
    procedure SetPropertiesCurrency(Properties:TcxCustomEditProperties);
    procedure SetPropertiesPicture(Properties:TcxCustomEditProperties);
    procedure SetPropertiesPopupPicture(Properties:TcxCustomEditProperties);
    procedure SetPropertiesImageIndex(Properties:TcxCustomEditProperties);
    procedure SetPropertiesSubAccount(Properties:TcxCustomEditProperties);
    procedure SetPropertiesText(Properties:TcxCustomEditProperties);
    procedure SetPropertiesDropDown(Properties:TcxCustomEditProperties);
    procedure SetPropertiesDate(Properties:TcxCustomEditProperties);
    procedure SetPropertiesCurrencyNumber(Properties:TcxCustomEditProperties);

   public
    property ParentDBName:string read FParentDBName write FParentDBName;
    property GridType:TGridType read FGridType write FGridType;
    property DataSet:TDataSet read FDataSet write FDataSet;
    procedure LoadPluginColumns(const AppPluginsId:Integer);
    procedure LoadGridColumns(const AppDialogControlsId:Integer);
    procedure LoadFromDataSet; virtual; abstract;

    constructor Create;
    destructor Destroy; override;
  end;


const
 ColumnSortingDisabled = 3;

implementation

const
 DEFAULT_CURRENCYEDIT_PROVIDER_LOCATION = 'TMiceCurrencyEditor.ProviderName';
 DEFAULT_CURRENCYEDIT_DBNAME_LOCATION = 'TMiceCurrencyEditor.DBName';


{ TCommonColumnBuilder }

constructor TCommonColumnBuilder.Create;
begin
 GridType:=gtPlugin;
end;

destructor TCommonColumnBuilder.Destroy;
begin

  inherited;
end;

procedure TCommonColumnBuilder.LoadGridColumns( const AppDialogControlsId: Integer);
var
 Tmp:TxDataSet;
begin
 Tmp:=TxDataSet.Create(nil);
 try
   Tmp.ProviderName:='spui_AppGetDialogGridColumns';
   Tmp.SetParameter('AppDialogControlsId',AppDialogControlsId);
   Tmp.Source:='TMiceGridColumnBuilder.LoadGridColumns';
   Tmp.Open;
   Self.DataSet:=Tmp;
   Self.LoadFromDataSet;
 finally
   Tmp.Free;
 end;
end;

procedure TCommonColumnBuilder.LoadPluginColumns(const AppPluginsId: Integer);
var
 Tmp:TxDataSet;
begin
 Tmp:=TxDataSet.Create(nil);
 try
   Tmp.ProviderName:='spui_AppGetPluginColumns';
   Tmp.SetParameter('AppPluginsId',AppPluginsId);
   Tmp.Source:='TMiceGridColumnBuilder.LoadPluginColumns';
   Tmp.Open;
   Self.DataSet:=Tmp;
   LoadFromDataSet;
 finally
   Tmp.Free;
 end;
end;

procedure TCommonColumnBuilder.PopulateCurrency(Items: TcxImageComboBoxItems; const Json: string);
var
 Builder:TMiceDropDownBuilder;
 AppObject:TMiceAppObject;
begin
 Builder:=TMiceDropDownBuilder.Create;
 try
  Builder.Items:=Items;
   AppObject:=TMiceAppObject.Create;
   try
//    AppObject.AsJson:=Json;
    AppObject.DropDownItems.AddNone:=False;
    AppObject.DropDownItems.AddAll:=False;


    AppObject.Properties.ProviderName:=TGlobalSettings.DefaultInstance.SettingByName(DEFAULT_CURRENCYEDIT_PROVIDER_LOCATION);
    AppObject.Properties.DBName:=TGlobalSettings.DefaultInstance.SettingByName(DEFAULT_CURRENCYEDIT_DBNAME_LOCATION);
    if AppObject.Properties.DBName.IsEmpty then
      AppObject.Properties.DBName:=ParentDBName;


    Builder.DataSet.Source:='TCommonColumnBuilder.PopulateCurrency';

    Builder.LoadFromAppObject(AppObject);
   finally
    AppObject.Free;
   end;

 finally
  Builder.Free;
 end;
end;

procedure TCommonColumnBuilder.PopulateDropDown(Items: TcxImageComboBoxItems;  const Json: string);
var
 Builder:TMiceDropDownBuilder;
 AppObject:TMiceAppObject;
begin
 Builder:=TMiceDropDownBuilder.Create;
 try
  Builder.Items:=Items;
   AppObject:=TMiceAppObject.Create;
   try
    AppObject.AsJson:=Json;

    if AppObject.Properties.DBName.Trim.IsEmpty then
     AppObject.Properties.DBName:=ParentDBName;

     Builder.DataSet.Source:='TCommonColumnBuilder.PopulateDropDown';
    Builder.LoadFromAppObject(AppObject);
   finally
    AppObject.Free;
   end;

 finally
  Builder.Free;
 end;
end;


procedure TCommonColumnBuilder.SetPropertiesCheckBox(Properties: TcxCustomEditProperties);
begin
// (Result.Properties as TcxCheckBoxProperties).ValueChecked:=1;
// (Result.Properties as TcxCheckBoxProperties).ValueUnchecked:=0;
// (Result.Properties as TcxCheckBoxProperties).ValueGrayed:=NULL;
end;

procedure TCommonColumnBuilder.SetPropertiesCurrency(Properties: TcxCustomEditProperties);
var
 P:TcxImageComboBoxProperties;
resourcestring
 S_INVALID_CURRENCY_SETTING = 'Invalid currency editor setting, make sure to set following values in Global Settings:'#13'%s'#13'%s';
begin
 P:=(Properties as TcxImageComboBoxProperties);
 P.Images:=ImageContainer.Images16;
 if ValidCurrencySettings then
  PopulateCurrency(P.Items, DataSet.FieldByName('InitString').AsString)
   else
  TMiceBalloons.Show(S_COMMON_ERROR, Format(S_INVALID_CURRENCY_SETTING,[DEFAULT_CURRENCYEDIT_PROVIDER_LOCATION, DEFAULT_CURRENCYEDIT_DBNAME_LOCATION]));
end;

procedure TCommonColumnBuilder.SetPropertiesCurrencyNumber(Properties: TcxCustomEditProperties);
var
 P:TcxCurrencyEditProperties;
begin
 P:=(Properties as TcxCurrencyEditProperties);
 P.DisplayFormat:=',0.00;-,0.00';
end;

procedure TCommonColumnBuilder.SetPropertiesDate(Properties: TcxCustomEditProperties);
var
 P: TcxDateEditProperties;
begin
 P:=(Properties as TcxDateEditProperties);
 P.ShowTime:=False;
end;

procedure TCommonColumnBuilder.SetPropertiesDefault(Properties: TcxCustomEditProperties);
begin
 if Assigned(Properties) then
  begin
   Properties.ReadOnly:=DataSet.FieldByName('Readonly').AsBoolean;
   Properties.Alignment.Horz:=TAlignment(DataSet.FieldByName('Align').AsInteger);
  end;
end;

procedure TCommonColumnBuilder.SetPropertiesDropDown(Properties: TcxCustomEditProperties);
var
 P:TcxImageComboBoxProperties;
begin
 P:=(Properties as TcxImageComboBoxProperties);
 P.Images:=ImageContainer.Images16;
 PopulateDropDown(P.Items, DataSet.FieldByName('InitString').AsString);
end;

procedure TCommonColumnBuilder.SetPropertiesImageIndex(Properties: TcxCustomEditProperties);
var
 x:integer;
 Item: TcxImageComboBoxItem;
 P: TcxImageComboBoxProperties;
begin
// Result.Options.Editing:=False;
 P:=(Properties as TcxImageComboBoxProperties);
 P.Images := ImageContainer.Images16;
 for x:=0 to P.Images.Count - 1 do
  begin
   Item := P.Items.Add as TcxImageComboBoxItem;
   Item.ImageIndex := x;
   Item.Value := x;
  end;

end;

procedure TCommonColumnBuilder.SetPropertiesText(Properties: TcxCustomEditProperties);
begin
end;

function TCommonColumnBuilder.ValidCurrencySettings: Boolean;
begin
 Result:=TGlobalSettings.DefaultInstance.SettingExists(DEFAULT_CURRENCYEDIT_PROVIDER_LOCATION) and TGlobalSettings.DefaultInstance.SettingExists(DEFAULT_CURRENCYEDIT_DBNAME_LOCATION);
end;

procedure TCommonColumnBuilder.SetPropertiesPicture(Properties: TcxCustomEditProperties);
var
 P:TcxImageProperties;
begin
 P:=Properties as TcxImageProperties;
 P.OnGetGraphicClass := nil; //TMiceGridHelper.GetGraphicClass;
 P.GraphicClass := nil;
 P.ReadOnly :=DataSet.FieldByName('Readonly').ReadOnly;
 P.Alignment.Horz:=TAlignment(DataSet.FieldByName('Align').AsInteger);
end;

procedure TCommonColumnBuilder.SetPropertiesPopupPicture(Properties: TcxCustomEditProperties);
var
 P:TcxBLOBEditProperties;
begin
 P:=Properties as TcxBLOBEditProperties;
 P.BlobEditKind := bekPict;
 P.OnGetGraphicClass:= nil; //TMiceGridHelper.GetGraphicClass;
 P.PictureGraphicClass := nil;
end;

procedure TCommonColumnBuilder.SetPropertiesSubAccount(Properties: TcxCustomEditProperties);
var
 p:TcxTextEditProperties;
begin
 P:=Properties as TcxTextEditProperties;
 if Assigned(P) then;
 
// Result.OnGetDisplayText:= TMiceGridHelper.FormatSubAccount;
end;

end.
