unit CustomControl.MiceLayout;

interface

uses
  System.SysUtils, System.Variants, System.Classes, Data.DB,
  dxLayoutContainer, dxLayoutControl,  IniFiles,
  System.Generics.Collections, System.Generics.Defaults;

type
 TMiceLayoutItem = class(TdxLayoutItem)
  private
    FDataField: string;
    FControlName: string;
    FDisplayCaption: string;
    FControlClassName: string;
  protected
    function GetStoredProperties(AProperties: TStrings): Boolean; override;
    procedure GetStoredPropertyValue(const AName: string; var AValue: Variant); override;
    procedure SetStoredPropertyValue(const AName: string; const AValue: Variant); override;
  published
    property DataField:string read FDataField write FDataField;
    property ControlClassName:string read FControlClassName write FControlClassName;
    property ControlName:string read FControlName write FControlName;
    property DisplayCaption:string read FDisplayCaption write FDisplayCaption;
  end;

 TMiceLayoutGroup = class(TdxLayoutGroup)
  protected
   function GetStoredProperties(AProperties: TStrings): Boolean; override;
   procedure GetStoredPropertyValue(const AName: string; var AValue: Variant); override;
   procedure SetStoredPropertyValue(const AName: string; const AValue: Variant); override;
 end;

 TMiceLayoutContainer = class(TdxLayoutControlContainer)
  protected
   function GetDefaultItemClass: TdxLayoutItemClass;override;
   function GetDefaultGroupClass: TdxLayoutGroupClass; override;
 end;


 TMiceLayoutControl = class(TdxLayoutControl)
  protected
   function GetContainerClass: TdxLayoutControlContainerClass; override;
  public
   function FindItem(const Name:string):TdxCustomLayoutItem;
 end;

implementation
const
 s_IamgeIndex = 'ImageIndex';

{ TMiceLayoutControl }

function TMiceLayoutControl.GetContainerClass: TdxLayoutControlContainerClass;
begin
 Result:=TMiceLayoutContainer;
end;

function TMiceLayoutControl.FindItem(const Name: string): TdxCustomLayoutItem;
var
 x:Integer;
begin
 for x:=0 to Self.AbsoluteItemCount-1  do
  if Self.AbsoluteItems[x].Name=Name then
   Exit(AbsoluteItems[x]);
 Result:=nil;
end;

{ TMiceLayoutContainer }

function TMiceLayoutContainer.GetDefaultGroupClass: TdxLayoutGroupClass;
begin
 Result:=TMiceLayoutGroup;
end;

function TMiceLayoutContainer.GetDefaultItemClass: TdxLayoutItemClass;
begin
 Result:=TMiceLayoutItem;
end;

{ TMiceLayoutGroup }

function TMiceLayoutGroup.GetStoredProperties(AProperties: TStrings): Boolean;
begin
 AProperties.Add(s_IamgeIndex);
 Result:=inherited;
end;

procedure TMiceLayoutGroup.GetStoredPropertyValue(const AName: string; var AValue: Variant);
begin
  inherited;
   if AName = s_IamgeIndex then
    AValue := Self.CaptionOptions.ImageIndex;
end;

procedure TMiceLayoutGroup.SetStoredPropertyValue(const AName: string;  const AValue: Variant);
begin
  inherited;
  if AName = s_IamgeIndex then
   CaptionOptions.ImageIndex:=AValue;
end;

{ TMiceLayoutItem }

function TMiceLayoutItem.GetStoredProperties(AProperties: TStrings): Boolean;
begin
 AProperties.Add(s_IamgeIndex);
 Result:=Inherited;
end;

procedure TMiceLayoutItem.GetStoredPropertyValue(const AName: string; var AValue: Variant);
begin
  inherited;
  if AName = s_IamgeIndex then
   AValue := Self.CaptionOptions.ImageIndex;
end;

procedure TMiceLayoutItem.SetStoredPropertyValue(const AName: string; const AValue: Variant);
begin
  inherited;
  if AName = s_IamgeIndex then
   CaptionOptions.ImageIndex:=AValue;
end;

initialization

RegisterClass(TMiceLayoutItem);
RegisterClass(TMiceLayoutGroup);
RegisterClass(TMiceLayoutControl);

end.
