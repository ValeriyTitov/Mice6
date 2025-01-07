unit CustomControl.Bar.CommonObject;

interface
uses
  System.SysUtils, System.Variants, System.Classes,
  dxBar, cxClasses, cxButtonEdit, cxImage, cxCheckBox, cxCalendar, cxBarEditItem, Data.DB,
  CustomControl.Interfaces,
  CustomControl.AppObject,
  DAC.XParams,
  Plugin.Base;

type
  TBarCommonObject = class
   private
   public
    constructor Create(AOwner:TcxBarEditItem);
    destructor Destroy; override;

    procedure LoadFromDataSet(DataSet:TDataSet);
  end;

implementation

{ TBarCommonObject }

constructor TBarCommonObject.Create(AOwner: TcxBarEditItem);
begin

end;

destructor TBarCommonObject.Destroy;
begin

  inherited;
end;


procedure TBarCommonObject.LoadFromDataSet(DataSet: TDataSet);
begin
end;

end.
