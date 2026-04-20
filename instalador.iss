#define MyAppName "Bot WhatsApp"
#define MyAppVersion "1.0"
#define MyAppPublisher "Tu Nombre o Empresa"
#define MyAppURL "https://tuwebsite.com"
#define MySourceDir "C:\Users\cr0_a\Documents\mi-bot-cliente"

[Setup]
AppId={{B1234567-ABCD-1234-EFGH-123456789012}
AppName={#MyAppName}
AppVersion={#MyAppVersion}
AppPublisher={#MyAppPublisher}
AppPublisherURL={#MyAppURL}
DefaultDirName={autopf}\BotWhatsApp
DefaultGroupName={#MyAppName}
AllowNoIcons=yes
OutputDir={#MySourceDir}\instalador
OutputBaseFilename=Setup_BotWhatsApp
Compression=lzma
SolidCompression=yes
WizardStyle=modern

[Languages]
Name: "spanish"; MessagesFile: "compiler:Languages\Spanish.isl"

[Tasks]
Name: "desktopicon"; Description: "Crear icono en el escritorio"; GroupDescription: "Iconos adicionales:"

[Files]
Source: "{#MySourceDir}\src\*"; DestDir: "{app}\src"; Flags: ignoreversion recursesubdirs
Source: "{#MySourceDir}\panel\*"; DestDir: "{app}\panel"; Flags: ignoreversion recursesubdirs
Source: "{#MySourceDir}\config.json"; DestDir: "{app}"; Flags: ignoreversion
Source: "{#MySourceDir}\package.json"; DestDir: "{app}"; Flags: ignoreversion
Source: "{#MySourceDir}\node_modules\*"; DestDir: "{app}\node_modules"; Flags: ignoreversion recursesubdirs
Source: "C:\Program Files\nodejs\node.exe"; DestDir: "{app}\node"; Flags: ignoreversion

[Icons]
Name: "{group}\Bot WhatsApp - Panel"; Filename: "{app}\iniciar.bat"
Name: "{group}\Desinstalar Bot WhatsApp"; Filename: "{uninstallexe}"
Name: "{commondesktop}\Bot WhatsApp"; Filename: "{app}\iniciar.bat"; Tasks: desktopicon

[Run]
Filename: "{app}\iniciar.bat"; Description: "Iniciar Bot WhatsApp ahora"; Flags: nowait postinstall skipifsilent

[Code]
procedure CurStepChanged(CurStep: TSetupStep);
var
  BatContent: string;
begin
  if CurStep = ssPostInstall then
  begin
    BatContent :=
      '@echo off' + #13#10 +
      'cd /d "%~dp0"' + #13#10 +
      'SET NODE_EXE=%~dp0node\node.exe' + #13#10 +
      'IF NOT EXIST "%NODE_EXE%" SET "NODE_EXE=C:\Program Files\nodejs\node.exe"' + #13#10 +
      'IF NOT EXIST "%NODE_EXE%" SET "NODE_EXE=C:\Program Files (x86)\nodejs\node.exe"' + #13#10 +
      'IF NOT EXIST "%~dp0logs" mkdir "%~dp0logs"' + #13#10 +
      'start "" /min cmd /c ""%NODE_EXE%" "%~dp0src\app.js" > "%~dp0logs\bot.log" 2>&1"' + #13#10 +
      'timeout /t 4 /nobreak > nul' + #13#10 +
      'start "" /min cmd /c ""%NODE_EXE%" "%~dp0panel\server.js" > "%~dp0logs\panel.log" 2>&1"' + #13#10 +
      'timeout /t 5 /nobreak > nul' + #13#10 +
      'start "" "http://localhost:3001"' + #13#10;

    SaveStringToFile(ExpandConstant('{app}\iniciar.bat'), BatContent, False);
    CreateDir(ExpandConstant('{app}\logs'));
  end;
end;