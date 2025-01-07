unit ManagerEditor.Script.Runner.Pascal;

interface
uses
  System.Classes, System.SysUtils,
  ManagerEditor.Script.Runner,
  Common.StringUtils,
  Mice.Script;

type
 TPascalScriptRunner = class (TCustomScriptRunner)
 private
  procedure RunText(Text:TStrings);
  procedure HandleStandartException(const Msg:string);
  procedure RaiseScriptError( Scripter:TMiceScripter);
 public
  function Compile(Text:TStrings):Boolean;
  constructor Create; override;
  procedure Run; override;
//  property OnErrorLine(Sender:TObject)
 end;

implementation

{ TPascalScriptRunner }

function TPascalScriptRunner.Compile(Text: TStrings):Boolean;
var
  Scripter:TMiceScripter;
begin
Result:=False;
  Scripter:=TMiceScripter.Create(nil);
   try
    Scripter.Lines.Assign(Text);
    try
     Result:=Scripter.Compile;
     if Result=False then
      RaiseScriptError(Scripter);
     DoOnSuccess(nil);
    except on E:Exception do
      HandleStandartException(E.Message);
    end;
  finally
    Scripter.Free;
  end;
end;

constructor TPascalScriptRunner.Create;
begin
  inherited;
  Syntax:='Pascal';
  DefaultExtension:='.pas';
end;

procedure TPascalScriptRunner.RaiseScriptError(Scripter: TMiceScripter);
begin
 ErrorLineNumber:=StrToIntDef(TStringUtils.LeftFromText(Scripter.ErrorPos,':','0'),0);
 ErrorLinePos:=StrToIntDef(TStringUtils.RightFromText(Scripter.ErrorPos,':','0'),0);
 raise Exception.Create(Scripter.ErrorMsg);
end;

procedure TPascalScriptRunner.HandleStandartException(const Msg: string);
begin
  InfoLines.Add(Msg);
  DoOnError(Msg);
end;

procedure TPascalScriptRunner.Run;
begin
  inherited;
  try
   RunText(Text);
   InfoLines.Add('OK');
   DoOnSuccess(nil);
  except on E:Exception do
   HandleStandartException(E.Message);
  end;
end;

procedure TPascalScriptRunner.RunText(Text: TStrings);
var
  Scripter:TMiceScripter;
begin
  Scripter:=TMiceScripter.Create(nil);
   try
    Scripter.Lines.Assign(Text);
    if (not Scripter.Compile) or (not Scripter.Run) then
     RaiseScriptError(Scripter);
  finally
    Scripter.Free;
  end;
end;

end.
