

#define nwjsApp "..\bundle\app"
#define b2dIsoPath "..\bundle\boot2docker.iso"
#define virtualBoxCommon "..\bundle\common.cab"
#define virtualBoxMsi "..\bundle\VirtualBox_amd64.msi"

[Setup]
AppName=FIRST LEGO League - Scoring System
AppVersion=0.1
DefaultDirName=C:\FLL_ScoringSystem
ArchitecturesAllowed=x64
ArchitecturesInstallIn64BitMode=x64

[Components]
Name: "Basic"; Description: "Basic installation" ; Types: full custom; Flags: fixed
Name: "Plugin_1"; Description: "Plugin 1 for the system" ; Types: full custom;
Name: "Plugin_2"; Description: "Plugin 2 for the system" ; Types: full custom;
Name: "Plugin_3"; Description: "Plugin 3 for the system" ; Types: full custom;
Name: "Plugin_4"; Description: "Plugin 4 for the system" ; Types: full custom;

[Files]
Source: "{#virtualBoxCommon}"; DestDir: "{app}\installers\virtualbox"; Components: "Basic";
Source: "{#virtualBoxMsi}"; DestDir: "{app}\installers\virtualbox"; DestName: "virtualbox.msi"; Components: "Basic"; AfterInstall: RunInstallVirtualBox();
Source: "{#b2dIsoPath}"; DestDir: "{app}"; Flags: ignoreversion; Components: "Basic";
Source: "{#nwjsApp}\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs; Components: "Basic";

[Code]
procedure RunInstallVirtualBox();
var
  ResultCode: Integer;
begin
  WizardForm.FilenameLabel.Caption := 'installing VirtualBox'
  if not Exec(ExpandConstant('msiexec'), ExpandConstant('/qn /i "{app}\installers\virtualbox\virtualbox.msi" /norestart'), '', SW_HIDE, ewWaitUntilTerminated, ResultCode) then
    MsgBox('virtualbox install failure', mbInformation, MB_OK);
end;
