unit CustomControl.MiceClientEdit;

interface

uses SysUtils, Windows, Messages, Classes, Controls, StdCtrls, cxTextEdit,
     cxButtonEdit, Data.DB, Vcl.DbCtrls, System.Variants,cxEdit,
     cxImageComboBox,
     Mice.Script,
     Common.Images,
     DAC.XDataSet,
     DAC.XParams.Mapper,
     CustomControl.MiceValuePicker.Base,
     CustomControl.AppObject,
     CustomControl.Interfaces,
     CustomControl.MiceValuePicker.Settings;

type
 TMiceClientEdit = class(TMiceValuePickerBase)
 protected
   procedure CheckBindings; override;
   procedure Load(AppObject:TMiceAppObject);override;
 public
   class function DevDescription:string;
   function ExecuteDialog:Boolean; override;
   constructor Create(AOwner:TComponent); override;
   destructor Destroy; override;
 end;


implementation


{ TMiceClientEdit }

procedure TMiceClientEdit.CheckBindings;
begin
  inherited;

end;

constructor TMiceClientEdit.Create(AOwner: TComponent);
begin
  inherited;

end;

destructor TMiceClientEdit.Destroy;
begin

  inherited;
end;

class function TMiceClientEdit.DevDescription: string;
resourcestring
 S_DevDescription_TMiceClientEdit = 'Allows to display and change client associated with datafield';
begin
 Result:= S_DevDescription_TMiceClientEdit;
end;

function TMiceClientEdit.ExecuteDialog: Boolean;
begin
 raise Exception.Create('Not implemented');
end;

procedure TMiceClientEdit.Load(AppObject: TMiceAppObject);
begin
//  inherited;

end;

end.
