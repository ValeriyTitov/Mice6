unit DAC.ObjectModels.ApplyUpdates.Response;

interface

uses
  Winapi.Windows, System.SysUtils, System.Variants, System.Classes,
  FireDAC.Comp.Client, FireDAC.Stan.Option, FireDAC.Stan.Intf, Data.DB,
  System.Generics.Collections, System.Generics.Defaults,System.JSON, Rest.Json,
  DAC.ObjectModels.Exception;

type
 TMiceApplyUpdatesResponse = class(TDictionary<string, string>)
  private
   procedure InternalApplyToDataSet(DataSet:TFDMemTable; const KeyField:string);
  public
   procedure LoadFromJsonString(const s:string);
   procedure LoadFromJsonValue(jValue:TJsonValue);
   procedure LoadFromJsonArray(jArray:TJsonArray);
   procedure ApplyToDataSet(DataSet:TFDMemTable; const KeyField:string);
   constructor Create;
  end;


implementation


{ TMiceNewRows }

procedure TMiceApplyUpdatesResponse.ApplyToDataSet(DataSet: TFDMemTable; const KeyField:string);
var
 ControlsDisabled:Boolean;
 B:TBookMark;
begin
ControlsDisabled:=DataSet.ControlsDisabled;
 if (ControlsDisabled=False) then
  DataSet.DisableControls;
  try
    B:=DataSet.Bookmark;
     InternalApplyToDataSet(DataSet,KeyField);
     try
      DataSet.Bookmark:=B; //убейстесь ап стенку те, кто так придумал.
     except
     end;
 finally
  if (ControlsDisabled=False) then
    DataSet.EnableControls;
  end;
end;

constructor TMiceApplyUpdatesResponse.Create;
begin
  inherited Create(TIStringComparer.Ordinal);
end;

procedure TMiceApplyUpdatesResponse.InternalApplyToDataSet(DataSet: TFDMemTable; const KeyField: string);
var
 s:string;
 FReadOnly:Boolean;
 Field:TField;
begin
//  DataSet.LogChanges:=False;
 Field:=DataSet.FieldByName(KeyField);
 FReadOnly:=Field.ReadOnly;
 Field.ReadOnly:=False;
 try
  for s in Keys do
   if DataSet.Locate(KeyField,s) then
    begin
     DataSet.Edit;
     Field.Value:=Self[s];
     DataSet.Post;
    end;
 finally
  Field.ReadOnly:=FReadOnly;
 end;
end;

procedure TMiceApplyUpdatesResponse.LoadFromJsonArray(jArray: TJsonArray);
var
 jValue : TJsonValue;
 jObject: TJsonObject;
 AKey:string;
 AValue:string;
begin
 for jValue in jArray do
  if jValue is TJsonObject then
   begin
    jObject:=jValue as TJsonObject;
    AKey:=jObject.GetValue('OldID').Value;
    AValue:=jObject.GetValue('NewID').Value;
    if (AKey.IsEmpty=False) and (not ContainsKey(AKey)) then
     Add(AKey,AValue);

   end;
end;

procedure TMiceApplyUpdatesResponse.LoadFromJsonString(const s: string);
var
 jValue:TJsonValue;
begin
 jValue:=TJsonObject.ParseJSONValue(s);
  try
   LoadFromJsonValue(jValue);
  finally
  jValue.Free;
 end;

end;

procedure TMiceApplyUpdatesResponse.LoadFromJsonValue(jValue: TJsonValue);
begin
 EDACException.CheckForException(jValue);
 if jValue is TJsonArray then
  LoadFromJsonArray(jValue as TJsonArray);
end;

end.

