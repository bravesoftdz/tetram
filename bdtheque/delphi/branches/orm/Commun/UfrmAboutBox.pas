unit UfrmAboutBox;

{ $D- }
interface

uses
  Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls, Buttons, ExtCtrls, verslabp, ShellAPI, jpeg, Dialogs, UBdtForms,
  Vcl.Imaging.pngimage;

type
  TfrmAboutBox = class(TbdtForm)
    Panel3: TBevel;
    Panel1: TBevel;
    BtnOk: TButton;
    Image1: TImage;
    ImLogo: TImage;
    Label1: TLabel;
    VlTitre: TLabel;
    VlVersion: TfshVersionLabel;
    VlCopyright: TfshVersionLabel;
    LbMemoireLibre: TLabel;
    LbMemoirePhysique: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    LbSysteme: TLabel;
    LbMemoireVirtuelle: TLabel;
    LbMemoireVirtuelleDisponible: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure ImLogoClick(Sender: TObject);
  private
    procedure SetFileName(const Value: TFileName);
    function GetFileName: TFileName;
    { Private declarations }
  public
    property FileName: TFileName read GetFileName write SetFileName;
  end;

implementation

uses Procedures, Math;

resourcestring
  MemoirePhysique = 'Physique';
  MemoirePhysiqueDisponible = 'Physique disponible';
  MemoireVirtuelle = 'Virtuelle';
  MemoireVirtuelleDisponible = 'Virtuelle disponible';
{$R *.DFM}

  // basé sur le code de
  // http://msdn.microsoft.com/en-us/library/ms724429(VS.85).aspx

function GetWindowsVersion: string;
type
  TGNSI = procedure(var lpSystemInfo: TSystemInfo); stdcall;
  TGPI = function(dwOSMajorVersion, dwOSMinorVersion, dwSpMajorVersion, dwSpMinorVersion: DWORD; var pdwReturnedProductType: DWORD): BOOL; stdcall;

  _OSVERSIONINFOEX = record
    dwOSVersionInfoSize: DWORD;
    dwMajorVersion: DWORD;
    dwMinorVersion: DWORD;
    dwBuildNumber: DWORD;
    dwPlatformId: DWORD;
    szCSDVersion: array [0 .. 127] of {$IFDEF UNICODE} WideChar {$ELSE} AnsiChar {$ENDIF};
    wServicePackMajor: WORD;
    wServicePackMinor: WORD;
    wSuiteMask: WORD;
    wProductType: BYTE;
    wReserved: BYTE;
  end;
const
  // wSuiteMask
  VER_SUITE_SMALLBUSINESS = $1;
  VER_SUITE_ENTERPRISE = $2;
  VER_SUITE_BACKOFFICE = $4;
  VER_SUITE_COMMUNICATIONS = $8;
  VER_SUITE_TERMINAL = $10;
  VER_SUITE_SMALLBUSINESS_RESTRICTED = $20;
  VER_SUITE_EMBEDDEDNT = $40;
  VER_SUITE_DATACENTER = $80;
  VER_SUITE_SINGLEUSERTS = $100;
  VER_SUITE_PERSONAL = $200;
  VER_SUITE_BLADE = $400;
  VER_SUITE_WH_SERVER = $800;
  VER_SUITE_STORAGE_SERVER = $2000;
  VER_SUITE_COMPUTE_SERVER = $4000;
  // wProductType
  VER_NT_WORKSTATION = $1;
  VER_NT_DOMAIN_CONTROLLER = $2;
  VER_NT_SERVER = $3;
  PRODUCT_BUSINESS = $00000006; // Business
  PRODUCT_BUSINESS_N = $00000010; // Business N
  PRODUCT_CLUSTER_SERVER = $00000012; // HPC Edition
  PRODUCT_DATACENTER_SERVER = $00000008; // Server Datacenter (full installation)
  PRODUCT_DATACENTER_SERVER_CORE = $0000000C; // Server Datacenter (core installation)
  PRODUCT_DATACENTER_SERVER_CORE_V = $00000027; // Server Datacenter without Hyper-V (core installation)
  PRODUCT_DATACENTER_SERVER_V = $00000025; // Server Datacenter without Hyper-V (full installation)
  PRODUCT_ENTERPRISE = $00000004; // Enterprise
  PRODUCT_ENTERPRISE_EVALUATION = $00000048; // Enterprise (evaluation installation)
  PRODUCT_ENTERPRISE_E = $00000046; // Not supported
  PRODUCT_ENTERPRISE_N = $0000001B; // Enterprise N
  PRODUCT_ENTERPRISE_N_EVALUATION = $00000054; // Enterprise N (evaluation installation)
  PRODUCT_ENTERPRISE_SERVER = $0000000A; // Server Enterprise (full installation)
  PRODUCT_ENTERPRISE_SERVER_CORE = $0000000E; // Server Enterprise (core installation)
  PRODUCT_ENTERPRISE_SERVER_CORE_V = $00000029; // Server Enterprise without Hyper-V (core installation)
  PRODUCT_ENTERPRISE_SERVER_IA64 = $0000000F; // Server Enterprise for Itanium-based Systems
  PRODUCT_ENTERPRISE_SERVER_V = $00000026; // Server Enterprise without Hyper-V (full installation)
  PRODUCT_HOME_BASIC = $00000002; // Home Basic
  PRODUCT_HOME_BASIC_E = $00000043; // Not supported
  PRODUCT_HOME_BASIC_N = $00000005; // Home Basic N
  PRODUCT_HOME_PREMIUM = $00000003; // Home Premium
  PRODUCT_HOME_PREMIUM_E = $00000044; // Not supported
  PRODUCT_HOME_PREMIUM_N = $0000001A; // Home Premium N
  PRODUCT_HYPERV = $0000002A; // Microsoft Hyper-V Server
  PRODUCT_MEDIUMBUSINESS_SERVER_MANAGEMENT = $0000001E; // Windows Essential Business Server Management Server
  PRODUCT_MEDIUMBUSINESS_SERVER_MESSAGING = $00000020; // Windows Essential Business Server Messaging Server
  PRODUCT_MEDIUMBUSINESS_SERVER_SECURITY = $0000001F; // Windows Essential Business Server Security Server
  PRODUCT_PROFESSIONAL = $00000030; // Professional
  PRODUCT_PROFESSIONAL_E = $00000045; // Not supported
  PRODUCT_PROFESSIONAL_N = $00000031; // Professional N
  PRODUCT_PROFESSIONAL_WMC = $00000067; // Professional with Media Center
  PRODUCT_SERVER_FOR_SMALLBUSINESS = $00000018; // Windows Server 2008 for Windows Essential Server Solutions
  PRODUCT_SERVER_FOR_SMALLBUSINESS_V = $00000023; // Windows Server 2008 without Hyper-V for Windows Essential Server Solutions
  PRODUCT_SERVER_FOUNDATION = $00000021; // Server Foundation
  PRODUCT_SMALLBUSINESS_SERVER = $00000009; // Windows Small Business Server
  PRODUCT_SMALLBUSINESS_SERVER_PREMIUM = $00000019; // Windows Small Business Server Prenium
  PRODUCT_SOLUTION_EMBEDDEDSERVER = $00000038; // Windows MultiPoint Server
  PRODUCT_STANDARD_EVALUATION_SERVER = $0000004F; // Server Standard (evaluation installation)
  PRODUCT_STANDARD_SERVER = $00000007; // Server Standard (full installation)
  PRODUCT_STANDARD_SERVER_CORE = $0000000D; // Server Standard (core installation)
  PRODUCT_STANDARD_SERVER_CORE_V = $00000028; // Server Standard without Hyper-V (core installation)
  PRODUCT_STANDARD_SERVER_V = $00000024; // Server Standard without Hyper-V (full installation)
  PRODUCT_STARTER = $0000000B; // Starter
  PRODUCT_STARTER_E = $00000042; // Not supported
  PRODUCT_STARTER_N = $0000002F; // Starter N
  PRODUCT_STORAGE_ENTERPRISE_SERVER = $00000017; // Storage Server Enterprise
  PRODUCT_STORAGE_EXPRESS_SERVER = $00000014; // Storage Server Express
  PRODUCT_STORAGE_STANDARD_EVALUATION_SERVER = $00000060; // Storage Server Standard (evaluation installation)
  PRODUCT_STORAGE_STANDARD_SERVER = $00000015; // Storage Server Standard
  PRODUCT_STORAGE_WORKGROUP_SERVER = $00000016; // Storage Server Workgroup
  PRODUCT_STORAGE_WORKGROUP_EVALUATION_SERVER = $0000005F; // Storage Server Workgroup (evaluation installation)
  PRODUCT_UNDEFINED = $00000000; // An unknown product
  PRODUCT_ULTIMATE = $00000001; // Ultimate
  PRODUCT_ULTIMATE_E = $00000047; // Not supported
  PRODUCT_ULTIMATE_N = $0000001C; // Ultimate N
  PRODUCT_WEB_SERVER = $00000011; // Web Server (full installation)
  PRODUCT_WEB_SERVER_CORE = $0000001D; // Web Server (core installation)  SM_SERVERR2 = 89;
  PRODUCT_CORE = $00000065; // // Windows 8
  PRODUCT_CORE_N = $00000062; // // Windows 8 N
  PRODUCT_CORE_COUNTRYSPECIFIC = $00000063; // Windows 8 China
  PRODUCT_CORE_SINGLELANGUAGE = $00000064; // Windows 8 Single Language
  PRODUCT_DATACENTER_EVALUATION_SERVER = $00000050; // Server Datacenter (evaluation installation)
  PRODUCT_MULTIPOINT_STANDARD_SERVER = $0000004C; // Windows MultiPoint Server Standard (full installation)
  PRODUCT_MULTIPOINT_PREMIUM_SERVER = $0000004D; // Windows MultiPoint Server Premium (full installation)
  PROCESSOR_ARCHITECTURE_INTEL = 0;
  PROCESSOR_ARCHITECTURE_IA64 = 6;
  PROCESSOR_ARCHITECTURE_AMD64 = 9;
  BUFSIZE = 80;
var
  OSVERSIONINFOEX: _OSVERSIONINFOEX;
  OSVERSIONINFO: _OSVERSIONINFO absolute OSVERSIONINFOEX;
  si: SYSTEM_INFO;
  pGNSI: TGNSI;
  pGPI: TGPI;
  bOsVersionInfoEx: Boolean;
  hdlKey: HKEY;
  lRet: LONGINT;
  szProductType: array [0 .. Pred(BUFSIZE)] of Char;
  dwBufLen, dwType: DWORD;
begin
  Result := '';
  // Try calling GetVersionEx using the OSVERSIONINFOEX structure.
  // If that fails, try using the OSVERSIONINFO structure.
  ZeroMemory(@si, sizeof(SYSTEM_INFO));
  ZeroMemory(@OSVERSIONINFO, sizeof(_OSVERSIONINFOEX));
  OSVERSIONINFO.dwOSVersionInfoSize := sizeof(_OSVERSIONINFOEX);
  bOsVersionInfoEx := GetVersionEx(OSVERSIONINFO);
  if not bOsVersionInfoEx then
  begin
    OSVERSIONINFO.dwOSVersionInfoSize := sizeof(_OSVERSIONINFO);
    if not GetVersionEx(OSVERSIONINFO) then
      Exit;
  end;

  // Call GetNativeSystemInfo if supported or GetSystemInfo otherwise.
  pGNSI := GetProcAddress(GetModuleHandle('kernel32.dll'), 'GetNativeSystemInfo');
  if Assigned(pGNSI) then
    pGNSI(si)
  else
    GetSystemInfo(si);

  case OSVERSIONINFO.dwPlatformId of
    // Test for the Windows NT product family.
    VER_PLATFORM_WIN32_NT:
      begin
        // Test for the specific product family.
        Result := 'Unknown Windows';

        if (OSVERSIONINFO.dwMajorVersion = 6) then
        begin
          if (OSVERSIONINFO.dwMinorVersion = 0) then
            if (OSVERSIONINFOEX.wProductType = VER_NT_WORKSTATION) then
              Result := 'Windows Vista'
            else
              Result := 'Windows Server 2008';

          if (OSVERSIONINFO.dwMinorVersion = 1) then
            if (OSVERSIONINFOEX.wProductType = VER_NT_WORKSTATION) then
              Result := 'Windows 7'
            else
              Result := 'Windows Server 2008 R2';

          if (OSVERSIONINFO.dwMinorVersion = 2) then
            if (OSVERSIONINFOEX.wProductType = VER_NT_WORKSTATION) then
              Result := 'Windows 8'
            else
              Result := 'Windows Server 2012';

          if (OSVERSIONINFO.dwMinorVersion = 3) then
            if (OSVERSIONINFOEX.wProductType = VER_NT_WORKSTATION) then
              Result := 'Windows 8.1'
            else
              Result := 'Windows Server 2012 R2';

          pGPI := GetProcAddress(GetModuleHandle('kernel32.dll'), 'GetProductInfo');
          pGPI(OSVERSIONINFO.dwMajorVersion, OSVERSIONINFO.dwMinorVersion, 0, 0, dwType);

          case dwType of
            PRODUCT_BUSINESS:
              Result := Result + ' Business Edition';
            PRODUCT_BUSINESS_N:
              Result := Result + ' Business N Edition';

            PRODUCT_CLUSTER_SERVER:
              Result := Result + ' Cluster Server (HPC) Edition';
            PRODUCT_CLUSTER_SERVER_V:
              Result := Result + ' Server Hyper Core V Edition';

            PRODUCT_CORE:
              ;
            PRODUCT_CORE_N:
              Result := Result + ' N';
            PRODUCT_CORE_COUNTRYSPECIFIC:
              ;
            PRODUCT_CORE_SINGLELANGUAGE:
              ;

            PRODUCT_DATACENTER_EVALUATION_SERVER:
              Result := Result + ' Datacenter Edition';
            PRODUCT_DATACENTER_SERVER:
              Result := Result + ' Datacenter Edition';
            PRODUCT_DATACENTER_SERVER_CORE:
              Result := Result + ' Datacenter Edition (core installation)';
            PRODUCT_DATACENTER_SERVER_V:
              Result := Result + ' Datacenter Edition without Hyper-V';
            PRODUCT_DATACENTER_SERVER_CORE_V:
              Result := Result + ' Datacenter Edition without Hyper-V (core installation)';

            PRODUCT_ENTERPRISE:
              Result := Result + ' Enterprise Edition';
            PRODUCT_ENTERPRISE_E:
              Result := Result + ' (not supported)';
            PRODUCT_ENTERPRISE_N_EVALUATION:
              Result := Result + ' Enterprise N Edition';
            PRODUCT_ENTERPRISE_N:
              Result := Result + ' Enterprise N Edition';
            PRODUCT_ENTERPRISE_EVALUATION:
              Result := Result + ' Enterprise N Edition';
            PRODUCT_ENTERPRISE_SERVER:
              Result := Result + ' Enterprise Edition';
            PRODUCT_ENTERPRISE_SERVER_CORE:
              Result := Result + ' Enterprise Edition (core installation)';
            PRODUCT_ENTERPRISE_SERVER_CORE_V:
              Result := Result + ' Enterprise Edition without Hyper-V (core installation)';
            PRODUCT_ENTERPRISE_SERVER_IA64:
              Result := Result + ' Enterprise Edition for Itanium-based Systems';
            PRODUCT_ENTERPRISE_SERVER_V:
              Result := Result + ' Enterprise Edition without Hyper-V';

            PRODUCT_ESSENTIALBUSINESS_SERVER_MGMT:
              Result := Result + ' Essential Server Solution Management Edition';
            PRODUCT_ESSENTIALBUSINESS_SERVER_ADDL:
              Result := Result + ' Essential Server Solution Additional Edition';
            PRODUCT_ESSENTIALBUSINESS_SERVER_MGMTSVC:
              Result := Result + ' Essential Server Solution Management SVC Edition';
            PRODUCT_ESSENTIALBUSINESS_SERVER_ADDLSVC:
              Result := Result + ' Essential Server Solution Additional SVC Edition';

            PRODUCT_HOME_BASIC:
              Result := Result + ' Home Basic Edition';
            PRODUCT_HOME_BASIC_E:
              Result := Result + ' (not supported)';
            PRODUCT_HOME_BASIC_N:
              Result := Result + ' Home Basic N Edition';
            PRODUCT_HOME_PREMIUM:
              Result := Result + ' Home Premium Edition';
            PRODUCT_HOME_PREMIUM_E:
              Result := Result + ' (not supported)';
            PRODUCT_HOME_PREMIUM_N:
              Result := Result + ' Home Premium N Edition';
            PRODUCT_HOME_PREMIUM_SERVER:
              Result := Result + ' Home Server 2011 Edition';
            PRODUCT_HOME_SERVER:
              Result := Result + ' Storage Server 2008 R2 Essentials Edition';

            PRODUCT_HYPERV:
              Result := Result + ' Hyper-V Server Edition';

            PRODUCT_MEDIUMBUSINESS_SERVER_MANAGEMENT:
              Result := Result + ' Essential Business Server Management Server Edition';
            PRODUCT_MEDIUMBUSINESS_SERVER_MESSAGING:
              Result := Result + ' Essential Business Server Messaging Server Edition';
            PRODUCT_MEDIUMBUSINESS_SERVER_SECURITY:
              Result := Result + ' Essential Business Server Security Server Edition';

            PRODUCT_MULTIPOINT_STANDARD_SERVER:
              Result := Result + ' MultiPoint Server Standard Edition';
            PRODUCT_MULTIPOINT_PREMIUM_SERVER:
              Result := Result + ' Windows MultiPoint Server Premium Edition';

            PRODUCT_PROFESSIONAL:
              Result := Result + ' Professional';
            PRODUCT_PROFESSIONAL_E:
              Result := Result + ' (not supported)';
            PRODUCT_PROFESSIONAL_N:
              Result := Result + ' Professional N';
            PRODUCT_PROFESSIONAL_WMC:
              Result := Result + ' Professional with Media Center';

            PRODUCT_SB_SOLUTION_SERVER_EM:
              Result := Result + ' Server For SB Solutions EM Edition';
            PRODUCT_SERVER_FOR_SB_SOLUTIONS:
              Result := Result + ' Server For SB Solutions Edition';
            PRODUCT_SERVER_FOR_SB_SOLUTIONS_EM:
              Result := Result + ' Server For SB Solutions EM Edition';

            PRODUCT_SERVER_FOR_SMALLBUSINESS:
              Result := Result + ' Windows Essential Server Solutions Edition';
            PRODUCT_SERVER_FOR_SMALLBUSINESS_V:
              Result := Result + ' Windows Essential Server Solutions Edition without Hyper-V';

            PRODUCT_SERVER_FOUNDATION:
              Result := Result + ' Server Foundation Edition';

            PRODUCT_SB_SOLUTION_SERVER:
              Result := Result + ' Small Business Server 2011 Essentials Edition';
            PRODUCT_SMALLBUSINESS_SERVER:
              Result := Result + ' Small Business Server Edition';
            PRODUCT_SMALLBUSINESS_SERVER_PREMIUM:
              Result := Result + ' Small Business Server Premium Edition';
            PRODUCT_SMALLBUSINESS_SERVER_PREMIUM_CORE:
              Result := Result + ' Small Business Server Premium Edition (core installation)';

            PRODUCT_SOLUTION_EMBEDDEDSERVER:
              Result := Result + ' MultiPoint Server Edition';

            PRODUCT_STANDARD_EVALUATION_SERVER:
              Result := Result + ' Server Standard Edition';
            PRODUCT_STANDARD_SERVER:
              Result := Result + ' Standard Edition';
            PRODUCT_STANDARD_SERVER_CORE:
              Result := Result + ' Standard Edition (core installation)';
            PRODUCT_STANDARD_SERVER_V:
              Result := Result + ' Server Standard  Edition without Hyper-V';
            PRODUCT_STANDARD_SERVER_CORE_V:
              Result := Result + ' Server Standard Edition without Hyper-V (core installation)';
            PRODUCT_STANDARD_SERVER_SOLUTIONS:
              Result := Result + ' Server Solutions Premium Edition';
            PRODUCT_STANDARD_SERVER_SOLUTIONS_CORE:
              Result := Result + ' Server Solutions Premium Edition (core installation)';

            PRODUCT_STARTER:
              Result := Result + ' Starter Edition';
            PRODUCT_STARTER_E:
              Result := Result + ' (not supported)';
            PRODUCT_STARTER_N:
              Result := Result + ' Starter N Edition';

            PRODUCT_STORAGE_ENTERPRISE_SERVER:
              Result := Result + ' Storage Server Enterprise Edition';
            PRODUCT_STORAGE_ENTERPRISE_SERVER_CORE:
              Result := Result + ' Storage Server Enterprise Edition (core installation)';
            PRODUCT_STORAGE_EXPRESS_SERVER:
              Result := Result + ' Storage Server Express Edition';
            PRODUCT_STORAGE_EXPRESS_SERVER_CORE:
              Result := Result + ' Storage Server Express Edition (core installation)';
            PRODUCT_STORAGE_STANDARD_EVALUATION_SERVER:
              Result := Result + ' Storage Server Standard Edition';
            PRODUCT_STORAGE_STANDARD_SERVER:
              Result := Result + ' Storage Server Standard Edition';
            PRODUCT_STORAGE_STANDARD_SERVER_CORE:
              Result := Result + ' Storage Server Standard Edition (core installation)';
            PRODUCT_STORAGE_WORKGROUP_EVALUATION_SERVER:
              Result := Result + ' Storage Server Workgroup Edition';
            PRODUCT_STORAGE_WORKGROUP_SERVER:
              Result := Result + ' Storage Server Workgroup Edition';
            PRODUCT_STORAGE_WORKGROUP_SERVER_CORE:
              Result := Result + ' Storage Server Workgroup Edition (core installation)';

            PRODUCT_ULTIMATE:
              Result := Result + ' Ultimate Edition';
            PRODUCT_ULTIMATE_E:
              Result := Result + ' (not supported)';
            PRODUCT_ULTIMATE_N:
              Result := Result + ' Ultimate N Edition';

            PRODUCT_WEB_SERVER:
              Result := Result + ' Web Server Edition';
            PRODUCT_WEB_SERVER_CORE:
              Result := Result + ' Web Server Edition (core installation)';
          end;

          if (si.wProcessorArchitecture = PROCESSOR_ARCHITECTURE_AMD64) then
            Result := Result + ', 64-bit'
          else if (si.wProcessorArchitecture = PROCESSOR_ARCHITECTURE_INTEL) then
            Result := Result + ', 32-bit';
        end;
        if (OSVERSIONINFO.dwMajorVersion = 5) and (OSVERSIONINFO.dwMinorVersion = 2) then
        begin
          if (GetSystemMetrics(SM_SERVERR2) <> 0) then
            Result := 'Windows Server 2003 R2'
          else if (OSVERSIONINFOEX.wSuiteMask = VER_SUITE_STORAGE_SERVER) then
            Result := 'Windows Storage Server 2003'
          else if (OSVERSIONINFOEX.wSuiteMask = VER_SUITE_WH_SERVER) then
            Result := 'Windows Home Server'
          else if (OSVERSIONINFOEX.wProductType = VER_NT_WORKSTATION) and (si.wProcessorArchitecture = PROCESSOR_ARCHITECTURE_AMD64) then
            Result := 'Windows XP Professional x64 Edition'
          else
            Result := 'Windows Server 2003';

          // Test for the server type.
          if (OSVERSIONINFOEX.wProductType <> VER_NT_WORKSTATION) then
          begin
            if (si.wProcessorArchitecture = PROCESSOR_ARCHITECTURE_IA64) then
            begin
              if (OSVERSIONINFOEX.wSuiteMask and VER_SUITE_DATACENTER) <> 0 then
                Result := Result + ' Datacenter Edition for Itanium-based Systems'
              else if (OSVERSIONINFOEX.wSuiteMask and VER_SUITE_ENTERPRISE) <> 0 then
                Result := Result + ' Enterprise Edition for Itanium-based Systems';
            end
            else if (si.wProcessorArchitecture = PROCESSOR_ARCHITECTURE_AMD64) then
            begin
              if (OSVERSIONINFOEX.wSuiteMask and VER_SUITE_DATACENTER) <> 0 then
                Result := Result + ' Datacenter x64 Edition'
              else if (OSVERSIONINFOEX.wSuiteMask and VER_SUITE_ENTERPRISE) <> 0 then
                Result := Result + ' Enterprise x64 Edition'
              else
                Result := Result + ' Standard x64 Edition';
            end
            else
            begin
              if (OSVERSIONINFOEX.wSuiteMask and VER_SUITE_COMPUTE_SERVER) <> 0 then
                Result := Result + ' Compute Cluster Edition'
              else if (OSVERSIONINFOEX.wSuiteMask and VER_SUITE_DATACENTER) <> 0 then
                Result := Result + ' Datacenter Edition'
              else if (OSVERSIONINFOEX.wSuiteMask and VER_SUITE_ENTERPRISE) <> 0 then
                Result := Result + ' Enterprise Edition'
              else if (OSVERSIONINFOEX.wSuiteMask and VER_SUITE_BLADE) <> 0 then
                Result := Result + ' Web Edition'
              else
                Result := Result + ' Standard Edition';
            end;
          end;
        end;
        if (OSVERSIONINFO.dwMajorVersion = 5) and (OSVERSIONINFO.dwMinorVersion = 1) then
        begin
          Result := 'Windows XP';
          if (OSVERSIONINFOEX.wSuiteMask and VER_SUITE_PERSONAL) <> 0 then
            Result := Result + ' Home Edition'
          else
            Result := Result + ' Professional';
        end;

        if (OSVERSIONINFO.dwMajorVersion = 5) and (OSVERSIONINFO.dwMinorVersion = 0) then
        begin
          Result := 'Windows 2000';

          if (OSVERSIONINFOEX.wProductType = VER_NT_WORKSTATION) then
            Result := Result + ' Professional'
          else
          begin
            if (OSVERSIONINFOEX.wSuiteMask and VER_SUITE_DATACENTER) <> 0 then
              Result := Result + ' Datacenter Server'
            else if (OSVERSIONINFOEX.wSuiteMask and VER_SUITE_ENTERPRISE) <> 0 then
              Result := Result + ' Advanced Server'
            else
              Result := Result + ' Server';
          end;
        end;

        if (OSVERSIONINFO.dwMajorVersion <= 4) then
        begin
          Result := 'Windows NT';
          // Test for specific product on Windows NT 4.0 SP6 and later.
          if bOsVersionInfoEx then
          begin
            // Test for the workstation type.
            if (OSVERSIONINFOEX.wProductType = VER_NT_WORKSTATION) and (si.wProcessorArchitecture <> PROCESSOR_ARCHITECTURE_AMD64) then
              Result := Result + ' Workstation 4.0'
              // Test for the server type.
            else if (OSVERSIONINFOEX.wProductType = VER_NT_SERVER) or (OSVERSIONINFOEX.wProductType = VER_NT_DOMAIN_CONTROLLER) then
            begin
              if LongBool(OSVERSIONINFOEX.wSuiteMask and VER_SUITE_ENTERPRISE) then
                Result := Result + ' Server 4.0, Enterprise Edition'
              else
                Result := Result + ' Server';
            end;
          end
          else
          begin // Test for specific product on Windows NT 4.0 SP5 and earlier
            dwBufLen := BUFSIZE;
            lRet := RegOpenKeyEx(HKEY_LOCAL_MACHINE, 'SYSTEM\CurrentControlSet\Control\ProductOptions', 0, KEY_QUERY_VALUE, hdlKey);
            if (lRet <> ERROR_SUCCESS) then
              Exit;
            lRet := RegQueryValueEx(hdlKey, 'ProductType', nil, nil, @szProductType[1], @dwBufLen);
            if ((lRet <> ERROR_SUCCESS) or (dwBufLen > BUFSIZE)) then
              Exit;
            RegCloseKey(hdlKey);
            if (lstrcmpi('WINNT', szProductType) = 0) then
              Result := Result + ' Workstation';
            if (lstrcmpi('LANMANNT', szProductType) = 0) then
              Result := Result + ' Server';
            if (lstrcmpi('SERVERNT', szProductType) = 0) then
              Result := Result + ' Advanced Server';
            Result := Result + Format(' %d.%d', [OSVERSIONINFO.dwMajorVersion, OSVERSIONINFO.dwMinorVersion]);
          end;
        end;
        // Display service pack (if any) and build number.
        if (OSVERSIONINFO.dwMajorVersion = 4) and (lstrcmpi(OSVERSIONINFO.szCSDVersion, 'Service Pack 6') = 0) then
        begin
          // Test for SP6 versus SP6a.
          lRet := RegOpenKeyEx(HKEY_LOCAL_MACHINE, 'SOFTWARE\Microsoft\Windows NT\CurrentVersion\Hotfix\Q246009', 0, KEY_QUERY_VALUE, hdlKey);
          if (lRet = ERROR_SUCCESS) then
            Result := Result + Format(' Service Pack 6a (Build %d)', [OSVERSIONINFO.dwBuildNumber and $FFFF])
          else // Windows NT 4.0 prior to SP6a
            Result := Result + Format(' %s (Build %d)', [OSVERSIONINFO.szCSDVersion, OSVERSIONINFO.dwBuildNumber and $FFFF]);
          RegCloseKey(hdlKey);
        end
        else
        begin
          Result := Result + Format(' %s (Build %d)', [OSVERSIONINFO.szCSDVersion, OSVERSIONINFO.dwBuildNumber and $FFFF]);
        end;
      end;
    // Test for the Windows 95 product family.
    VER_PLATFORM_WIN32_WINDOWS:
      begin
        if (OSVERSIONINFO.dwMajorVersion = 4) and (OSVERSIONINFO.dwMinorVersion = 0) then
        begin
          Result := 'Windows 95';
          if (OSVERSIONINFO.szCSDVersion[1] = 'C') or (OSVERSIONINFO.szCSDVersion[1] = 'B') then
            Result := Result + ' OSR2';
        end;
        if (OSVERSIONINFO.dwMajorVersion = 4) and (OSVERSIONINFO.dwMinorVersion = 10) then
        begin
          Result := 'Windows 98';
          if (OSVERSIONINFO.szCSDVersion[1] = 'A') then
            Result := Result + ' SE';
        end;
        if (OSVERSIONINFO.dwMajorVersion = 4) and (OSVERSIONINFO.dwMinorVersion = 90) then
          Result := 'Windows ME';
      end;
    VER_PLATFORM_WIN32s:
      Result := 'Windows Win32s';
  end;
end;

function formatSize(bytes: DWORDLONG; fmt: string = '%.2f'): string;
const
  units: array [0 .. 4] of string = ('o', 'Ko', 'Mo', 'Go', 'To');
var
  b: double;
  e: integer;
begin
  b := bytes;
  // On gére le cas des tailles de fichier négatives
  if (b > 0) then
  begin
    e := trunc(logn(1024, b));
    // Si on n'a pas l'unité on retourne en To
    e := min(high(units), e);
    b := b / Power(1024, e);
  end
  else
  begin
    b := 0;
    e := 0;
  end;
  Result := Format(fmt + ' %s', [b, units[e]]);
end;

procedure TfrmAboutBox.FormCreate(Sender: TObject);
const
  FC: array [1 .. 2] of integer = (31, 16);
  W: array [1 .. 2] of integer = (90, 72);
  H: array [1 .. 2] of integer = (76, 51);
  Inter: array [1 .. 2] of integer = (50, 100);
  Back: array [1 .. 2] of TColor = (clGray, clWhite);
var
  MemoryStatus: TMemoryStatusEx;
begin
  Image1.Picture.Bitmap.LoadFromResourceName(HInstance, 'ABOUT');

  LbSysteme.Caption := GetWindowsVersion;
{$IFDEF WIN32}
  VlVersion.InfoSuffix := '(x86)';
{$ENDIF}
{$IFDEF WIN64}
  VlVersion.InfoSuffix := '(x64)';
{$ENDIF}
  MemoryStatus.dwLength := sizeof(MemoryStatus);
  GlobalMemoryStatusEx(MemoryStatus);

  LbMemoirePhysique.Caption := MemoirePhysique + ': ' + formatSize(MemoryStatus.ullTotalPhys);
  LbMemoireLibre.Caption := MemoirePhysique + ': ' + formatSize(MemoryStatus.ullAvailPhys) + Format(' (%d%%)', [100 - MemoryStatus.dwMemoryLoad]);
  LbMemoireVirtuelle.Caption := MemoireVirtuelle + ': ' + formatSize(MemoryStatus.ullTotalVirtual);
  LbMemoireVirtuelleDisponible.Caption := MemoireVirtuelleDisponible + ': ' + formatSize(MemoryStatus.ullAvailVirtual);
end;

function TfrmAboutBox.GetFileName: TFileName;
begin
  Result := VlVersion.FileName;
end;

procedure TfrmAboutBox.ImLogoClick(Sender: TObject);
begin
  ShellExecute(0, nil, 'http://www.tetram.org', nil, nil, SW_NORMAL);
end;

procedure TfrmAboutBox.SetFileName(const Value: TFileName);
begin
  VlVersion.FileName := Value;
  VlCopyright.FileName := Value;
end;

end.
