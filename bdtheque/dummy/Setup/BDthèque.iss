#ifndef SrcBin
#define SrcBin = "Win32" 
#define outputSuffix = "-x86" 
#endif

[Languages]
Name: fr; MessagesFile: compiler:Languages\French.isl

[Setup]
AppVersion={#GetFileVersion("..\..\delphi\trunk\deploy\Win64\BD.exe")}
AppName=BDTheque
AppVerName=BDTheque {#SetupSetting("AppVersion")}
AppMutex=TetramCorpBDMutex
AppPublisher=Teträm Corp
AppPublisherURL=http://www.tetram.org
AppSupportURL=http://forums.tetram.org
AppUpdatesURL=http://www.tetram.org
UninstallDisplayIcon={app}\BD.exe
DefaultDirName={pf}\Teträm Corp\BDTheque
DefaultGroupName=Teträm Corp\BDTheque
PrivilegesRequired=poweruser
AppCopyright=Teträm Corp © 1997-2008
AppID={{A86E29B5-D1EE-431F-A5BF-E4A10D36CBDC}
LicenseFile=..\..\..\documentation\LicenceFreeWare.rtf
WindowVisible=false
BackColor=$008080FF
WizardImageBackColor=clBlack
OutputBaseFilename=BDTheque-setup-{#SetupSetting("AppVersion")}{#outputSuffix}
MinVersion=0,5.0.2195
EnableDirDoesntExistWarning=true
AllowUNCPath=false
AppendDefaultDirName=false
ShowLanguageDialog=yes
InternalCompressLevel=Ultra
SolidCompression=true
Compression=lzma/Ultra
VersionInfoVersion={#SetupSetting("AppVersion")}
VersionInfoCompany=Teträm Corp
VersionInfoTextVersion={#SetupSetting("AppVersion")}
WizardImageFile=fond.bmp
WizardSmallImageFile=SetupModernSmall19.bmp
LanguageDetectionMethod=locale
SetupLogging=true
OutputDir=Output

; pour le moment on n'active pas: il faut trouver un moyen de savoir si la maj est en mode 32bit malgré qu'on soit sur un OS 64bit
;ArchitecturesInstallIn64BitMode=x64

[Tasks]
Name: desktopicon; Description: Créer un raccourci sur le &bureau; GroupDescription: Raccourcis supplémentaires:
Name: interneticon; Description: Créer un raccourci vers le site de Teträm Corp; GroupDescription: Raccourcis supplémentaires:

[Files]
; NOTE: Don't use "Flags: ignoreversion" on any shared system files

Source: ..\..\delphi\trunk\deploy\{#SrcBin}\BD.exe; DestDir: {app}; Flags: ignoreversion
Source: ..\..\delphi\trunk\deploy\{#SrcBin}\BDScript.exe; DestDir: {app}; Flags: ignoreversion
Source: ..\..\delphi\trunk\deploy\{#SrcBin}\BDPic.dll; DestDir: {app}; Flags: ignoreversion
Source: ..\..\delphi\trunk\deploy\{#SrcBin}\fbembed.dll; DestDir: {app}; Flags: ignoreversion
Source: ..\..\delphi\trunk\deploy\{#SrcBin}\firebird.msg; DestDir: {app}; Flags: ignoreversion
Source: ..\..\delphi\trunk\deploy\{#SrcBin}\ib_util.dll; DestDir: {app}; Flags: ignoreversion
Source: ..\..\delphi\trunk\deploy\{#SrcBin}\UDF\BDT_UDF.dll; DestDir: {app}\UDF; Flags: ignoreversion
Source: ..\..\delphi\trunk\deploy\{#SrcBin}\icuuc30.dll; DestDir: {app}; Flags: ignoreversion
Source: ..\..\delphi\trunk\deploy\{#SrcBin}\icuin30.dll; DestDir: {app}; Flags: ignoreversion
Source: ..\..\delphi\trunk\deploy\{#SrcBin}\icudt30.dll; DestDir: {app}; Flags: ignoreversion
Source: ..\..\delphi\trunk\deploy\{#SrcBin}\icuuc52.dll; DestDir: {app}; Flags: ignoreversion
Source: ..\..\delphi\trunk\deploy\{#SrcBin}\icuin52.dll; DestDir: {app}; Flags: ignoreversion
Source: ..\..\delphi\trunk\deploy\{#SrcBin}\icudt52.dll; DestDir: {app}; Flags: ignoreversion
Source: ..\..\delphi\trunk\deploy\{#SrcBin}\ssleay32.dll; DestDir: {app}; Flags: ignoreversion
Source: ..\..\delphi\trunk\deploy\{#SrcBin}\libeay32.dll; DestDir: {app}; Flags: ignoreversion
Source: ..\..\delphi\trunk\deploy\{#SrcBin}\intl\fbintl.dll; DestDir: {app}\Intl; Flags: ignoreversion
Source: ..\..\delphi\trunk\deploy\{#SrcBin}\intl\fbintl.conf; DestDir: {app}\Intl; Flags: ignoreversion
Source: ..\..\delphi\trunk\deploy\{#SrcBin}\msvcp80.dll; DestDir: {app}; Flags: ignoreversion
Source: ..\..\delphi\trunk\deploy\{#SrcBin}\msvcr80.dll; DestDir: {app}; Flags: ignoreversion
Source: ..\..\delphi\trunk\deploy\{#SrcBin}\Microsoft.VC80.CRT.manifest; DestDir: {app}; Flags: ignoreversion
Source: ..\..\delphi\trunk\deploy\{#SrcBin}\msvcp90.dll; DestDir: {app}; Flags: ignoreversion
Source: ..\..\delphi\trunk\deploy\{#SrcBin}\msvcr90.dll; DestDir: {app}; Flags: ignoreversion
Source: ..\..\delphi\trunk\deploy\{#SrcBin}\Microsoft.VC90.CRT.manifest; DestDir: {app}; Flags: ignoreversion
Source: ..\..\delphi\trunk\deploy\{#SrcBin}\msvcp100.dll; DestDir: {app}; Flags: ignoreversion
Source: ..\..\delphi\trunk\deploy\{#SrcBin}\msvcr100.dll; DestDir: {app}; Flags: ignoreversion
Source: ..\..\delphi\trunk\deploy\{#SrcBin}\Microsoft.VC100.CRT.manifest; DestDir: {app}; Flags: ignoreversion
Source: ..\..\delphi\trunk\deploy\{#SrcBin}\7z_x86.dll; DestDir: {app}; Flags: ignoreversion
Source: ..\..\delphi\trunk\deploy\{#SrcBin}\7z_x64.dll; DestDir: {app}; Flags: ignoreversion

Source: What's New.txt; DestDir: {app}; Flags: ignoreversion
Source: Base vide\BD.GDB; DestDir: {userappdata}\TetramCorp\BDTheque; Flags: onlyifdoesntexist ignoreversion; Check: FirstInstall
Source: ..\..\delphi\trunk\deploy\scripts\*.bds; DestDir: {commonappdata}\TetramCorp\BDTheque\Scripts; Flags: ignoreversion promptifolder; 
Source: ..\..\delphi\trunk\deploy\scripts\*.bdu; DestDir: {commonappdata}\TetramCorp\BDTheque\Scripts; Flags: ignoreversion promptifolder
Source: ..\..\delphi\trunk\deploy\WebServer\interface.zip; DestDir: {commonappdata}\TetramCorp\BDTheque\WebServer; Flags: ignoreversion
Source: ..\..\delphi\trunk\deploy\WebServer\Site par défaut.zip; DestDir: {commonappdata}\TetramCorp\BDTheque\WebServer; Flags: ignoreversion
Source: ..\..\delphi\trunk\deploy\WebServer\BDthequeWeb.zip; DestDir: {commonappdata}\TetramCorp\BDTheque\WebServer; Flags: ignoreversion

[Dirs]
Name: {commonappdata}\TetramCorp

[INI]
Filename: {app}\BD.url; Section: InternetShortcut; Key: URL; String: http://www.tetram.org; Tasks: interneticon

[Icons]
Name: {group}\BDTheque; Filename: {app}\BD.exe; IconIndex: 0
Name: {group}\BDTheque on the Web; Filename: {app}\BD.url; Tasks: interneticon
Name: {group}\Désinstaller BDTheque; Filename: {uninstallexe}
Name: {userdesktop}\BDTheque; Filename: {app}\BD.exe; Tasks: desktopicon; IconIndex: 0

[Run]
Filename: {app}\BD.exe; Description: Lancer BDTheque; Flags: nowait postinstall skipifsilent
Filename: {app}\What's New.txt; Flags: nowait shellexec skipifdoesntexist postinstall skipifsilent
;Filename: {tmp}\vcredist_x86.exe; Flags: skipifdoesntexist; Parameters: /q; MinVersion: 0,5.01.2600; OnlyBelowVersion: 0,5.01.2600sp1
;Filename: {tmp}\vcredist_x86.exe; Flags: skipifdoesntexist; Parameters: /q; MinVersion: 0,5.02.3790; OnlyBelowVersion: 0,5.02.3790

[UninstallDelete]
Type: files; Name: {app}\BD.url
Type: files; Name: {app}\BD.ini
Type: files; Name: {app}\*.lck
Type: files; Name: {app}\firebird.log
;Type: files; Name: {app}\msvcr71.dll
;Type: files; Name: {app}\msvcp71.dll
Type: filesandordirs; Name: {app}\WebServer

[LangOptions]
LanguageName=French
LanguageID=$040C

[_ISTool]
UseAbsolutePaths=false

[InstallDelete]
Name: {app}\UDF\VDO_UDF.dll; Type: files
Name: {app}\BDws.dll; Type: files

[CustomMessages]
CustomFormCaption=BDTheque est déjà installé
CustomFormDescription=Le programme d'installation a détecté que BDTheque est déjà installé sur cet ordinateur.
UninstallRegKey=SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{A86E29B5-D1EE-431F-A5BF-E4A10D36CBDC}_is1

[ThirdParty]
CompileLogMethod=append

[Code]
  var
    CanUpdate, IsUpdate: Boolean;
    Label2: TLabel;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;

  function FirstInstall: Boolean;
  begin
    Result := not IsUpdate;
  end;

  procedure CustomForm_Activate(Page: TWizardPage);
  begin
  end;

  function CustomForm_ShouldSkipPage(Page: TWizardPage): Boolean;
  begin
    Result := False;
  end;

  function CustomForm_BackButtonClick(Page: TWizardPage): Boolean;
  begin
    Result := True;
  end;

  function CustomForm_NextButtonClick(Page: TWizardPage): Boolean;
  begin
    Result := True;
    IsUpdate := RadioButton2.Checked;
  end;

  procedure CustomForm_CancelButtonClick(Page: TWizardPage; var Cancel, Confirm: Boolean);
  begin
  end;

  function CustomForm_CreatePage(PreviousPageId: Integer): Integer;
  var
    Page: TWizardPage;
  begin
    Page := CreateCustomPage(
      PreviousPageId,
      ExpandConstant('{cm:CustomFormCaption}'),
      ExpandConstant('{cm:CustomFormDescription}')
    );

    { Label2 }
    Label2 := TLabel.Create(Page);
    with Label2 do
    begin
      Parent := Page.Surface;
      Left := ScaleX(24);
      Top := ScaleY(40);
      Width := ScaleX(366);
      Height := ScaleY(58);
      AutoSize := False;
      Caption := 'Selectionnez l''action que vous voulez effectuer et cliquer sur Suivant pour continuer.';
      WordWrap := True;
    end;

    { RadioButton1 }
    RadioButton1 := TRadioButton.Create(Page);
    with RadioButton1 do
    begin
      Parent := Page.Surface;
      Left := ScaleX(120);
      Top := ScaleY(136);
      Width := ScaleX(113);
      Height := ScaleY(17);
      Caption := 'Installer de nouveau';
      TabOrder := 0;
    end;

    { RadioButton2 }
    RadioButton2 := TRadioButton.Create(Page);
    with RadioButton2 do
    begin
      Parent := Page.Surface;
      Left := ScaleX(120);
      Top := ScaleY(112);
      Width := ScaleX(113);
      Height := ScaleY(17);
      Caption := 'Mettre à jour';
      Checked := True;
      TabOrder := 1;
      TabStop := True;
    end;


    with Page do
    begin
      OnActivate := @CustomForm_Activate;
      OnNextButtonClick := @CustomForm_NextButtonClick;
    end;

    Result := Page.ID;
  end;

  procedure InitializeWizard();
  var
    CurVersion: string;
  begin
    IsUpdate := False;
    CanUpdate := RegQueryStringValue(HKLM, ExpandConstant('{cm:UninstallRegKey}'), 'DisplayVersion', CurVersion) and (CurVersion <> '');
    if CanUpdate then
      CustomForm_CreatePage(wpLicense);
  end;

  function ShouldSkipPage(PageID: Integer): Boolean;
  begin
    Result := ((PageID = wpSelectDir) or (PageID = wpSelectProgramGroup)) and CanUpdate and IsUpdate;
  end;

[InnoIDE_Settings]
LogFileOverwrite=false

