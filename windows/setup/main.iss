

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

[Dirs]
Name: "{app}\data"
Name: "{app}\components"

[Files]
Source: "{#virtualBoxCommon}"; DestDir: "{app}\installers"; Components: "Basic";
Source: "{#virtualBoxMsi}"; DestDir: "{app}\installers"; DestName: "virtualbox.msi"; Components: "Basic";
Source: "{#b2dIsoPath}"; DestDir: "{app}"; Flags: ignoreversion; Components: "Basic";
Source: "{#nwjsApp}\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs; Components: "Basic";

[Run]

Filename: "msiexec.exe"; StatusMsg: "Installing VirtualBox..."; \
    Parameters: "/i ""{app}\installers\virtualbox.msi""   \
               INSTALLDIR=""{app}\virtualbox""            \
               VBOX_INSTALLDESKTOPSHORTCUT=0              \
               VBOX_INSTALLQUICKLAUNCHSHORTCUT=0          \
               VBOX_REGISTERFILEEXTENSIONS=0              \
               /qb /norestart                             "

Filename: "{app}\virtualbox\VBoxManage"; Flags: runhidden; \
    Parameters: "createvm              \
                 --basefolder {app}\vm \
                 --name FLLscoring     \
                 --register            "

  Filename: "{app}\virtualbox\VBoxManage"; Flags: runhidden; \
      Parameters: "modifyvm FLLscoring       \
                   --firmware bios           \
                   --bioslogofadein off      \
                   --bioslogofadeout off     \
                   --bioslogodisplaytime 0   \
                   --biosbootmenu disabled   \
                   --ostype Linux26_64       \
                   --cpus 1                  \
                   --memory 1024             \
                   --acpi on                 \
                   --ioapic on               \
                   --rtcuseutc on            \
                   --natdnshostresolver1 off \
                   --natdnsproxy1 off        \
                   --cpuhotplug off          \
                   --pae on                  \
                   --hpet on                 \
                   --hwvirtex on             \
                   --nestedpaging on         \
                   --largepages on           \
                   --vtxvpid on              \
                   --accelerate3d off        \
                   --audio none              \
                   --boot1 dvd               "

Filename: "{app}\virtualbox\VBoxManage"; Flags: runhidden; \
    Parameters: "modifyvm FLLscoring  \
                 --nic1 nat           \
                 --nictype1 Am79C973  \
                 --cableconnected1 on "

Filename: "{app}\virtualbox\VBoxManage"; Flags: runhidden; \
    Parameters: "storagectl FLLscoring \
                 --name SATA           \
                 --add sata            \
                 --hostiocache on      "

Filename: "{app}\virtualbox\VBoxManage"; Flags: runhidden; \
    Parameters: "storageattach FLLscoring      \
                 --storagectl SATA             \
                 --port 0                      \
                 --device 0                    \
                 --type dvddrive               \
                 --medium {app}/boot2docker.iso"

Filename: "{app}\virtualbox\VBoxManage"; Flags: runhidden; \
    Parameters: "createhd --filename {app}/vm/disk.vdi --size 32768"

Filename: "{app}\virtualbox\VBoxManage"; Flags: runhidden; \
    Parameters: "storageattach FLLscoring  \
                 --storagectl SATA         \
                 --port 1                  \
                 --device 0                \
                 --type hdd                \
                 --medium {app}/vm/disk.vdi"

Filename: "{app}\virtualbox\VBoxManage"; Flags: runhidden; \
    Parameters: "guestproperty set FLLscoring /VirtualBox/GuestAdd/SharedFolders/MountPrefix /"

Filename: "{app}\virtualbox\VBoxManage"; Flags: runhidden; \
    Parameters: "guestproperty set FLLscoring /VirtualBox/GuestAdd/SharedFolders/MountDir /"

Filename: "{app}\virtualbox\VBoxManage"; Flags: runhidden; \
    Parameters: "sharedfolder add FLLscoring --name data --hostpath {app}\data --automount"

Filename: "{app}\virtualbox\VBoxManage"; Flags: runhidden; \
    Parameters: "sharedfolder add FLLscoring --name components --hostpath {app}\components --automount"

[UninstallRun]
Filename: "{app}\virtualbox\VBoxManage"; Parameters: "unregistervm FLLscoring --delete"; Flags: runhidden
Filename: "msiexec"; Parameters: "/uninstall {app}\installers\virtualbox.msi"

[UninstallDelete]
Type: filesandordirs; Name: "{app}\vm"
Type: filesandordirs; Name: "{app}\data"
