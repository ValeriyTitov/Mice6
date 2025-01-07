unit DAC.ObjectModels.Exception;

interface

uses
 System.SysUtils, System.Json, DAC.ObjectModels.DataSetMessage;

type
 EDACException = class(Exception)
  private
    FLineNumber: Integer;
    FExceptionClassName: string;
    FSQLNativeError: Integer;
 public
    property SQLNativeError:Integer read FSQLNativeError write FSQLNativeError;
    property LineNumber:Integer read FLineNumber write FLineNumber;
    property ExceptionClassName:string read FExceptionClassName write FExceptionClassName;
    procedure FromJson(jObject:TJsonObject);

    class procedure CheckForException(jValue:TJsonValue);
    class procedure CheckForExceptionWithMessages(jValue:TJsonValue; Messages:TMiceDataSetMessageList);
    class procedure RaiseException(jException:TJsonObject);
 end;

implementation

{ EDACException }

class procedure EDACException.CheckForException(jValue: TJsonValue);
var
  jException:TJsonObject;
begin
 if jValue.TryGetValue('Exception',jException) then
   RaiseException(jException);
end;

class procedure EDACException.CheckForExceptionWithMessages(jValue: TJsonValue;  Messages: TMiceDataSetMessageList);
var
  jException:TJsonObject;
  jMessages:TJsonArray;
begin
 if jValue.TryGetValue('Exception',jException) then
  begin
   if jException.TryGetValue('Messages',jMessages) and Assigned(Messages) then
    Messages.FromJson(jMessages);
   RaiseException(jException);
  end;
end;

procedure EDACException.FromJson(jObject: TJsonObject);
var
 jExceptionClassName:TJSONValue;
 jMessage:TJSONValue;
 jLineNumber:TJSONNumber;
 jSQLNativeError:TJSONNumber;
begin
 if jObject.TryGetValue('ErrorMessage',jMessage) then
  Self.Message:=jMessage.Value;

 if jObject.TryGetValue('ExceptionClassName',jExceptionClassName) then
  Self.ExceptionClassName:=jExceptionClassName.Value;

 if jObject.TryGetValue('LineNumber',jLineNumber) then
  Self.LineNumber:=jLineNumber.Value.ToInteger;

 if jObject.TryGetValue('SQLNativeError',jSQLNativeError) then
  Self.SQLNativeError:=jSQLNativeError.Value.ToInteger;

// if jObject.TryGetValue('Messages',jMessage) then
//  Self.Message:=jMessage.Value;

end;

class procedure EDACException.RaiseException(jException: TJsonObject);
var
 Msg:string;
 jValue:TJSONValue;
resourcestring
 S_UNKNOWN_APPSERVER_EXCEPTION = 'Unknown exception thrown by Application server';
begin
 if jException.TryGetValue('ErrorMessage',jValue) then
  Msg:=jValue.Value
   else
  Msg:=S_UNKNOWN_APPSERVER_EXCEPTION;
 raise EDACException.Create(Msg);
end;



end.
