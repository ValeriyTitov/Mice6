unit CustomControl.AppObject.Properties;

interface

uses DAC.XParams, System.SysUtils;

type
  TAppObjectProperties = class
  private
    FInitParam: string;
    FStyle: Integer;
    FProviderName: string;
    FDBName: string;
    FOpenFileBehavior: Integer;
    FValidateBeforeOpen: Boolean;
    FFileEncoding: Integer;
    FMinTextLength: Integer;
  public
    property ProviderName:string read FProviderName write FProviderName;
    property DBName:string read FDBName write FDBName;
    property InitParam:string read FInitParam write FInitParam;
    property Style:Integer read FStyle write FStyle;
    property MinTextLength: Integer read FMinTextLength write FMinTextLength;
    property FileEncoding:Integer read FFileEncoding write FFileEncoding;
    property OpenFileBehavior:Integer read FOpenFileBehavior write FOpenFileBehavior;
    property ValidateBeforeOpen:Boolean read FValidateBeforeOpen write FValidateBeforeOpen;
    procedure LoadFromParams(Params:TxParams);
    procedure SaveToParams(Params:TxParams);
    procedure Clear;
  end;

implementation

{ TAppObjectProperties }

procedure TAppObjectProperties.Clear;
begin
 ProviderName:='';
 DBName:='';
 InitParam:='';
 Style:=0;
end;


procedure TAppObjectProperties.LoadFromParams(Params: TxParams);
resourcestring
 S_NO_PARAMS_ASSIGNED = 'TAppObjectProperties: Params collection is not assigned';
begin
 if not Assigned(Params) then
  raise Exception.Create(S_NO_PARAMS_ASSIGNED);

 ProviderName:=Params.ParamByNameDef('ProviderName','');
 DBName:= Params.ParamByNameDef('DBName','');
 InitParam:=Params.ParamByNameDef('InitParam','');
 Style:=Params.ParamByNameDef('Style',0);
 OpenFileBehavior:=Params.ParamByNameDef('OpenFileBehavior',0);
 ValidateBeforeOpen:=Params.ParamByNameDef('ValidateBeforeOpen',False);
 FileEncoding:=Params.ParamByNameDef('FileEncoding',0);
 MinTextLength:=Params.ParamByNameDef('MinTextLength',0);
end;

procedure TAppObjectProperties.SaveToParams(Params: TxParams);
begin
  Params.SetParameterNoDefault('ProviderName',ProviderName,'');
  Params.SetParameterNoDefault('DBName',DBName,'');
  Params.SetParameterNoDefault('InitParam',InitParam,'');
  Params.SetParameterNoDefault('Style',Style, 0);
  Params.SetParameterNoDefault('OpenFileBehavior',OpenFileBehavior, 0);
  Params.SetParameterNoDefault('ValidateBeforeOpen',ValidateBeforeOpen, False);
  Params.SetParameterNoDefault('FileEncoding',FileEncoding, 0);
  Params.SetParameterNoDefault('MinTextLength',MinTextLength, 0);
end;

end.
