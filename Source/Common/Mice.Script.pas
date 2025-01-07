unit Mice.Script;

interface

uses
 System.SysUtils, System.Classes,System.Variants, Data.DB,
 Vcl.Controls,
 Vcl.Forms,
 Mice.Script.ClassTree,
 DAC.XDataSet,
 WinApi.Windows,
 Common.ResourceStrings,
 Common.StringUtils,
 fs_iinterpreter, fs_ipascal,
 fs_isysrtti,
 fs_iformsrtti,
 fs_iextctrlsrtti,
 fs_iexpression,
 fs_idialogsrtti,
 fs_iclassesrtti,
 fs_ibasic,
 fs_iadortti,
 DAC.ObjectModels.MiceUser;


type
 TMiceScripter = class (TfsScript)
  private
    FAppScriptsId: Integer;
    FCompiled:Boolean;
    FErrorLineNumber: Integer;
    FErrorLinePos: Integer;
    function InternalCompile:Boolean;
  public
    procedure RegisterAllFields(DataSet:TDataSet);
    procedure CallProcedure(const Name:string);
    procedure CallOnClick(Sender:TComponent);
    procedure CallOnDblClick(Sender:TComponent);
    procedure CallOnChange(Sender:TComponent);
    procedure AddAllControls(Owner:TForm);
    constructor Create(AOwner:TComponent); override;
    class procedure RegisterClassEvent(const AClassName, Event, Description, Example:string);
    class procedure RegisterClassEventOnChange(const AClassName:string);
    class procedure RegisterClassEventOnClick(const AClassName:string);
    class procedure RegisterClassEventOnDblClick(const AClassName:string);
  published
    property ErrorLineNumber:Integer read FErrorLineNumber;
    property ErrorLinePos:Integer read FErrorLinePos;
    property AppScriptsId:Integer read FAppScriptsId write FAppScriptsId;
    procedure Load;
    procedure CompileGui;
    class function GetScriptText(AppScriptsId:Integer):string;
  end;

 resourcestring
 S_ERROR_AT_LINE_FMT = ' %s at line position: %s';

implementation




{ TMiceScripter }

procedure TMiceScripter.AddAllControls(Owner: TForm);
var
 Control:TControl;
 x:Integer;
begin
 for x:=0 to Owner.ControlCount-1 do
  begin
   Control:=Owner.Controls[x];
   AddObject(Control.Name, Control);
  end;
end;


procedure TMiceScripter.CallOnChange(Sender: TComponent);
var
 SenderRef:Integer;
begin
 SenderRef:=Integer(Sender);
 CallFunction(Sender.Name+'Change',SenderRef);
end;

procedure TMiceScripter.CallOnClick(Sender: TComponent);
var
 SenderRef:Integer;
begin
 SenderRef:=Integer(Sender);
 CallFunction(Sender.Name+'Click',SenderRef);
end;

procedure TMiceScripter.CallOnDblClick(Sender: TComponent);
var
 SenderRef:Integer;
begin
 SenderRef:=Integer(Sender);
 CallFunction(Sender.Name+'DblClick',SenderRef);
end;

procedure TMiceScripter.CallProcedure(const Name: string);
begin
 CallFunction(Name,VarArrayOf([]));
end;

constructor TMiceScripter.Create(AOwner: TComponent);
begin
  inherited;
  Parent := fsGlobalUnit;
  AddObject('CurrentUser',TMiceUser.CurrentUser);
end;


procedure TMiceScripter.CompileGui;
begin
 if FCompiled=False then
  begin
  FCompiled:=InternalCompile;
   if not FCompiled then
      MessageBox(Application.Handle, PChar(Format(S_ERROR_AT_LINE_FMT, [ErrorMsg, ErrorPos])),PCHar(S_COMMON_ERROR),MB_OK+MB_ICONERROR);
  end;
end;

class function TMiceScripter.GetScriptText(AppScriptsId: Integer): string;
var
 DataSet:TxDataSet;
begin
  DataSet:=TxDataSet.Create(nil);
  try
   DataSet.Source:='TMiceScripter.GetScriptText';
   DataSet.ProviderName:='spui_AppGetScript';
   DataSet.SetParameter('AppScriptsId',AppScriptsId);
   DataSet.Open;
   Result:=DataSet.FieldByName('Script').AsString;
  finally
   DataSet.Free;
  end;
end;

function TMiceScripter.InternalCompile: Boolean;
begin
Result:=Compile;
 if not Result then
  begin
   FErrorLineNumber:=StrToIntDef(TStringUtils.LeftFromText(ErrorPos,':','0'),0);
   FErrorLinePos:=StrToIntDef(TStringUtils.RightFromText(ErrorPos,':','0'),0);
  end;
end;

procedure TMiceScripter.Load;
begin
 if AppScriptsId<>0 then
  begin
   FCompiled:=False;
   Lines.Text:=Self.GetScriptText(AppScriptsId);
   CompileGui;
  end;
end;

procedure TMiceScripter.RegisterAllFields(DataSet: TDataSet);
var
 Field:TField;
 AFieldName:string;
begin
 AddObject('DataSet',DataSet);
 for Field in DataSet.Fields do
  begin
   AFieldName:='_'+Field.FieldName;
   if IsValidIdent(AFieldName) then
    AddObject(AFieldName, Field);
  end;
end;



class procedure TMiceScripter.RegisterClassEvent(const AClassName, Event,  Description, Example: string);
begin
 TClassEventsTree.DefaultInstance.RegisterClassEvent(AClassName, Event, Description, Example);
end;

class procedure TMiceScripter.RegisterClassEventOnClick(const AClassName:string);
resourcestring
 S_EVENT_DESCRIPTION_ONCLICK= 'Occurs when user clicks on control';
begin
 TMiceScripter.RegisterClassEvent(AClassName, 'OnClick', S_EVENT_DESCRIPTION_ONCLICK , 'procedure %sClick(Sender:TObject);');
end;


class procedure TMiceScripter.RegisterClassEventOnDblClick(const AClassName: string);
resourcestring
 S_EVENT_DESCRIPTION_ONDBLCLICK= 'Occurs when user double clicks on control';
begin
 TMiceScripter.RegisterClassEvent(AClassName, 'OnDblClick', S_EVENT_DESCRIPTION_ONDBLCLICK, 'procedure %sDblClick(Sender:TObject);');
end;

class procedure TMiceScripter.RegisterClassEventOnChange(const AClassName:string);
resourcestring
 S_EVENT_DESCRIPTION_ONCHANGE= 'Occurs when user change control';
begin
 TMiceScripter.RegisterClassEvent(AClassName, 'OnChange', S_EVENT_DESCRIPTION_ONCHANGE, 'procedure %sChange(Sender:TObject);');
end;

{


Доступ к переменным из программы
 Для получения/установки значения переменных скрипта, используйте свойство
TfsScript.Variables.
val := fsScript1.Variables['i'];
fsScript1.Variables['i'] := 10;


Вызов функции из программы
 Для вызова скриптовой функции используйте метод TfsScript.CallFunction.
Первый параметр это имя вызываемой функции, второй - это параметры функции.
val := fsScript1.CallFunction('ScriptFunc', VarArrayOf(['hello', 1]));
// вызовет 'function ScriptFunc(s: String; i: Integer)'



Добавление процедуры в скрипт
 Для добавления процедуры/функции в скрипт выполните следующие действия:
- Создайте обработчик - функцию TfsCallMethodEvent.
- Вызовите метод TfsScript.AddMethod. Первый параметр - это синтаксис функции
(обратите внимание - синтаксис, независимо от используемого вами языка, должен
быть паскалевским!), второй - ссылка на обработчик TfsCallMethodEvent.

procedure TForm1.DelphiFunc(s: String; i: Integer);
begin
 ShowMessage(s + ', ' + IntToStr(i));
end;

function TForm1.CallMethod(Instance: TObject; ClassType: TClass; const MethodName: String; var Params: Variant): Variant;
begin
 DelphiFunc(Params[0], Params[1]);
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
 fsScript1.AddMethod('procedure DelphiFunc(s: String; i: Integer)', CallMethod);
 if fsScript1.Compile then
 fsScript1.Execute else
 ShowMessage(fsScript1.ErrorMsg);
end;



Добавление функции с параметром class
Поскольку все параметры представляются как массив типа Variant, вам надо
преобразовать их в объекты.
fsScript1.AddMethod('procedure HideButton(Button: TButton)',CallMethod);

function TForm1.CallMethod(Instance: TObject; ClassType: TClass; const MethodName: String;  var Params: Variant): Variant;
begin
 TButton(Integer(Params[0])).Hide;
end;

Добавление функции, возвращающей значение типа class
 Поскольку значения, возвращаемые дескриптором метода, это массив типа
Variant, вам надо преобразовать результаты типа TObject к Variant.
fsScript1.AddMethod('function MainForm: TForm', CallMethod);

function TForm1.CallMethod(Instance: TObject; ClassType: TClass; const MethodName: String;  var Params: Variant): Variant;
begin
 Result := Integer(Form1);
end;

Добавление константы в скрипт
 Для добавления в скрипт константы вызовите метод TfsScript.AddConst. Первый
параметр - это наименование константы, второй - тип (должен быть одним из
стандартных типов), третий - значение.

procedure TForm1.Button1Click(Sender: TObject);
begin
 fsScript1.AddConst('pi', 'Extended', 3.14159);
end;






Добавление объекта в скрипт
 Для добавления объекта в скрипт вызовите метод TfsScript.AddObject. Первый
параметр это имя объекта, второй - собственно, объект.
fsScript1.AddObject('Button1', Button1);
 Если добавляемый объект имеет незарегистрированный класс, то предварительно
надо зарегистрировать его:
fsScript1.AddClass(TForm1, 'TForm');
fsScript1.AddObject('Form1', Self);
 Вы также можете использовать метод fsGlobalUnit.AddForm для добавления
формы или модуля данных вместе со всеми дочерними компонентами:
fsGlobalUnit.AddForm(Form1);
 В этом случае регистрировать класс формы с помощью AddClass не требуется.
Теперь вы можете обращаться к элементам формы из скрипта:
 Form1.Button1.Caption := '...'

}

end.
