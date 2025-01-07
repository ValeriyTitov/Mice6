unit CustomControl.MiceValuePicker.Settings;

interface
 uses DAC.XParams,
      System.SysUtils;

 type
 TMiceValuePickerSettings = class
  private
    FDescriptionField: string;
    FParentIdField: string;
    FImageIndexField: string;
    FKeyField: string;
    FEnabledField: string;
    FExpandLevel: Integer;
    FEnabledValue: variant;
    FCaptionField: string;
    FAppDialogControlsIdTargetGrid: Integer;
    FCategoryField: string;
    FDialogType: Integer;
    FDialogProviderName: string;
  public
    property KeyField:string read FKeyField write FKeyField;
    property CaptionField:string read FCaptionField write FCaptionField;
    property ImageIndexField:string read FImageIndexField write FImageIndexField;
    property DescriptionField:string read FDescriptionField write FDescriptionField;
    property ExpandLevel:Integer read FExpandLevel write FExpandLevel;
    property EnabledField:string read FEnabledField write FEnabledField;
    property EnabledValue:variant read FEnabledValue write FEnabledValue;
    property ParentIdField:string read FParentIdField write FParentIdField;
    property AppDialogControlsIdTargetGrid: Integer read FAppDialogControlsIdTargetGrid write FAppDialogControlsIdTargetGrid;
    property CategoryField:string read FCategoryField write FCategoryField;
    property DialogProviderName:string read FDialogProviderName write FDialogProviderName;
    property DialogType:Integer read FDialogType write FDialogType;

    procedure LoadFromParams(Params:TxParams);
 end;

implementation

{ TMiceValuePickerSettings }

procedure TMiceValuePickerSettings.LoadFromParams(Params: TxParams);
begin
 EnabledField:=Params.ParamByNameDef('EnabledField','');
 EnabledValue:=Params.ParamByNameDef('EnabledValue','');
 ExpandLevel:=Params.ParamByNameDef('ExpandLevel',3);
 KeyField:=Params.ParamByNameDef('KeyField','');
 CaptionField:=Params.ParamByNameDef('CaptionField','');
 DescriptionField:=Params.ParamByNameDef('DescriptionField','');
 DialogProviderName:=Params.ParamByNameDef('DialogProviderName','');
 DialogType:=Params.ParamByNameDef('DialogType',-1);
 ParentIdField:=Params.ParamByNameDef('ParentIdField','');
 AppDialogControlsIdTargetGrid:=Params.ParamByNameDef('AppDialogControlsIdTargetGrid',0);
end;

end.
