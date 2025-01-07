unit Startup.ProjectList;

interface
 uses System.Generics.Collections, Windows, SysUtils,
      Common.Registry, Classes;

 type
  TProject = class
   public
    ProjectName:string;
    ConnectionString:string;
    AskPassword:boolean;
  end;

  TProjectList = class
  private
    FProjects: TObjectList<TProject>;
    FLastProject: string;
    FSaveUserName: Boolean;
    FLastUserName: string;
    procedure RaiseNoProject(ProjectName:String);
  public
    property SaveUserName:Boolean read FSaveUserName write FSaveUserName;
    property LastProject:string read FLastProject write FLastProject;
    property LastUserName:string read FLastUserName write FLastUserName;
    property Projects : TObjectList<TProject> read FProjects;
    function ProjectByName(ProjectName:String):TProject;
    procedure AddProject(const ProjectName, cs:String; const AskPassword:Boolean);
    procedure SaveProjects;
    procedure LoadProjects;
    procedure SaveCommon;
    procedure LoadCommon;

    constructor Create;
    destructor Destroy; override;
    class function DefaultProject:TProjectList;
   end;


implementation

const
 RegKeyConnectionString = 'ConnectionString';
 RegKeyAskPassword = 'AskPassword';
 RegKeyLastProject = 'LastProject';
 RegKeySaveUserName = 'SaveUserName';
 RegKeyLastUserName = 'LastUserName';
//http://192.168.1.106:55062

var
 DefProject:TProjectList;
{ TProjectList }

procedure TProjectList.AddProject(const ProjectName, cs: String; const AskPassword: Boolean);
var
 P:TProject;
begin
 P:=TProject.Create;
 P.ProjectName:=ProjectName;
 P.ConnectionString:=cs;
 P.AskPassword:=AskPassword;
 Projects.Add(P);
end;

constructor TProjectList.Create;
begin
FProjects:=TObjectList<TProject>.Create;
end;

class function TProjectList.DefaultProject: TProjectList;
begin
 Result:=DefProject;
end;

destructor TProjectList.Destroy;
begin
  FProjects.Free;
  inherited;
end;


procedure TProjectList.LoadCommon;
begin
 SaveUserName:=TProjectRegistry.DefaultInstance.ReadIntDef(RegistryPathProject,RegKeySaveUserName,0)<>0;
 LastProject:=TProjectRegistry.DefaultInstance.ReadStringDef(RegistryPathProject,RegKeyLastProject,'');
 LastUserName:=TProjectRegistry.DefaultInstance.ReadStringDef(RegistryPathProject,RegKeyLastUserName,'');
end;

procedure TProjectList.LoadProjects;
var
 List:TStringList;
 X:Integer;
begin
 List:=TStringList.Create;
  try
   Projects.Clear;
   TProjectRegistry.DefaultInstance.GetKeyNames(RegistryPathProject, List);
    for x:=0 to List.Count-1 do
      AddProject(List[x],
         TProjectRegistry.DefaultInstance.ReadStringDef(RegistryPathProject+List[x],RegKeyConnectionString,''),
         TProjectRegistry.DefaultInstance.ReadIntDef(RegistryPathProject+List[x],RegKeyAskPassword,1)<>0);
  finally
   List.Free;
  end;
 LoadCommon;
end;


function TProjectList.ProjectByName(ProjectName: String): TProject;
var
 X:Integer;
begin
 for x:=0 to Projects.Count-1 do
  begin
   Result:=Projects[x];
   if Result.ProjectName=ProjectName then
    exit;
  end;
 Result:=nil;
 RaiseNoProject(ProjectName);
end;

procedure TProjectList.RaiseNoProject(ProjectName:String);
resourcestring
 S_INVALID_Project_FMT = 'Invalid Project name: %s';
begin
 raise Exception.CreateFmt(S_INVALID_Project_FMT,[ProjectName]);
end;

procedure TProjectList.SaveCommon;
begin
 TProjectRegistry.DefaultInstance.WriteInt(RegistryPathProject,RegKeySaveUserName,Integer(SaveUserName));
 TProjectRegistry.DefaultInstance.WriteString(RegistryPathProject,RegKeyLastProject,LastProject);
 TProjectRegistry.DefaultInstance.WriteString(RegistryPathProject,RegKeyLastUserName,LastUserName);
end;

procedure TProjectList.SaveProjects;
var
 x:Integer;
 Path:string;
begin
TProjectRegistry.DefaultInstance.DeleteKeys(RegistryPathProject);
 for x:=0 to Projects.Count-1 do
  begin
   Path:=RegistryPathProject+Projects[x].ProjectName;
   TProjectRegistry.DefaultInstance.WriteString(Path,RegKeyConnectionString, Projects[x].ConnectionString);
   TProjectRegistry.DefaultInstance.WriteInt(Path,RegKeyAskPassword, Integer(Projects[x].AskPassword));
  end;
SaveCommon;
end;


Initialization
 DefProject:=TProjectList.Create;
finalization
 DefProject.Free;
end.
