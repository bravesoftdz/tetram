unit Form_AboutBox;
{.$D-}
interface

uses
  Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls, ProceduresBDtk,
  Buttons, ExtCtrls, verslabp, ShellAPI, jpeg, Dialogs, UBdtForms;

type
  TFrmAboutBox = class(TbdtForm)
    Panel3: TBevel;
    Panel1: TBevel;
    BtnOk: TButton;
    Image1: TImage;
    ImLogo: TImage;
    Label1: TLabel;
    VlTitre: TLabel;
    VlVersion: TfshVersionLabel;
    VlCopyright: TfshVersionLabel;
    LbMemoireVirtuelleDisponible: TLabel;
    LbMemoireVirtuelle: TLabel;
    LbMemoireLibre: TLabel;
    LbMemoirePhysique: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    LbSysteme: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure ImLogoClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

uses Procedures;

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
    szCSDVersion: array[0..127] of AnsiChar;
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

  PRODUCT_BUSINESS = $6; // Business
  PRODUCT_BUSINESS_N = $10; // Business N
  PRODUCT_CLUSTER_SERVER = $12; // HPC Edition
  PRODUCT_DATACENTER_SERVER = $8; // Server Datacenter (full installation)
  PRODUCT_DATACENTER_SERVER_CORE = $C; // Server Datacenter (core installation)
  PRODUCT_DATACENTER_SERVER_CORE_V = $27; // Server Datacenter without Hyper-V (core installation)
  PRODUCT_DATACENTER_SERVER_V = $25; // Server Datacenter without Hyper-V (full installation)
  PRODUCT_ENTERPRISE = $4; // Enterprise
  PRODUCT_ENTERPRISE_N = $1B; // Enterprise N
  PRODUCT_ENTERPRISE_SERVER = $A; // Server Enterprise (full installation)
  PRODUCT_ENTERPRISE_SERVER_CORE = $E; // Server Enterprise (core installation)
  PRODUCT_ENTERPRISE_SERVER_CORE_V = $29; // Server Enterprise without Hyper-V (core installation)
  PRODUCT_ENTERPRISE_SERVER_IA64 = $F; // Server Enterprise for Itanium-based Systems
  PRODUCT_ENTERPRISE_SERVER_V = $26; // Server Enterprise without Hyper-V (full installation)
  PRODUCT_HOME_BASIC = $2; // Home Basic
  PRODUCT_HOME_BASIC_N = $5; // Home Basic N
  PRODUCT_HOME_PREMIUM = $3; // Home Premium
  PRODUCT_HOME_PREMIUM_N = $1A; // Home Premium N
  PRODUCT_HYPERV = $2A; // Server Hyper-V
  PRODUCT_MEDIUMBUSINESS_SERVER_MANAGEMENT = $1E; // Windows Essential Business Server Management Server
  PRODUCT_MEDIUMBUSINESS_SERVER_MESSAGING = $20; // Windows Essential Business Server Messaging Server
  PRODUCT_MEDIUMBUSINESS_SERVER_SECURITY = $1F; // Windows Essential Business Server Security Server
  PRODUCT_SERVER_FOR_SMALLBUSINESS = $18; // Windows Server 2008 for Windows Essential Server Solutions
  PRODUCT_SERVER_FOR_SMALLBUSINESS_V = $23; // Windows Server 2008 without Hyper-V for Windows Essential Server Solutions
  PRODUCT_SMALLBUSINESS_SERVER = $9; // Windows Small Business Server
  PRODUCT_SMALLBUSINESS_SERVER_PREMIUM = $19;
  PRODUCT_STANDARD_SERVER = $7; // Server Standard (full installation)
  PRODUCT_STANDARD_SERVER_CORE = $D; // Server Standard (core installation)
  PRODUCT_STANDARD_SERVER_CORE_V = $28; // Server Standard without Hyper-V (core installation)
  PRODUCT_STANDARD_SERVER_V = $24; // Server Standard without Hyper-V (full installation)
  PRODUCT_STARTER = $B; // Starter
  PRODUCT_STORAGE_ENTERPRISE_SERVER = $17; // Storage Server Enterprise
  PRODUCT_STORAGE_EXPRESS_SERVER = $14; // Storage Server Express
  PRODUCT_STORAGE_STANDARD_SERVER = $15; // Storage Server Standard
  PRODUCT_STORAGE_WORKGROUP_SERVER = $16; // Storage Server Workgroup
  PRODUCT_UNDEFINED = $0; // An unknown product
  PRODUCT_ULTIMATE = $1; // Ultimate
  PRODUCT_ULTIMATE_N = $1C; // Ultimate N
  PRODUCT_WEB_SERVER = $11; // Web Server (full installation)
  PRODUCT_WEB_SERVER_CORE = $1D; // Web Server (core installation)

  SM_SERVERR2 = 89;
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
  szProductType: array[0..Pred(BUFSIZE)] of Char;
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
    if not GetVersionEx(OSVERSIONINFO) then Exit;
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
        if (OSVERSIONINFO.dwMajorVersion = 6) and (OSVERSIONINFO.dwMinorVersion = 0) then
        begin
          if (OSVERSIONINFOEX.wProductType = VER_NT_WORKSTATION) then
            Result := 'Windows Vista'
          else
            Result := 'Windows Server 2008';

          pGPI := GetProcAddress(GetModuleHandle('kernel32.dll'), 'GetProductInfo');
          pGPI(6, 0, 0, 0, dwType);

          case dwType of
            PRODUCT_ULTIMATE: Result := Result + ' Ultimate Edition';
            PRODUCT_HOME_PREMIUM: Result := Result + ' Home Premium Edition';
            PRODUCT_HOME_BASIC: Result := Result + ' Home Basic Edition';
            PRODUCT_ENTERPRISE: Result := Result + ' Enterprise Edition';
            PRODUCT_BUSINESS: Result := Result + ' Business Edition';
            PRODUCT_STARTER: Result := Result + ' Starter Edition';
            PRODUCT_CLUSTER_SERVER: Result := Result + ' Cluster Server Edition';
            PRODUCT_DATACENTER_SERVER: Result := Result + ' Datacenter Edition';
            PRODUCT_DATACENTER_SERVER_CORE: Result := Result + ' Datacenter Edition (core installation)';
            PRODUCT_ENTERPRISE_SERVER: Result := Result + ' Enterprise Edition';
            PRODUCT_ENTERPRISE_SERVER_CORE: Result := Result + ' Enterprise Edition (core installation)';
            PRODUCT_ENTERPRISE_SERVER_IA64: Result := Result + ' Enterprise Edition for Itanium-based Systems';
            PRODUCT_SMALLBUSINESS_SERVER: Result := Result + ' Small Business Server';
            PRODUCT_SMALLBUSINESS_SERVER_PREMIUM: Result := Result + ' Small Business Server Premium Edition';
            PRODUCT_STANDARD_SERVER: Result := Result + ' Standard Edition';
            PRODUCT_STANDARD_SERVER_CORE: Result := Result + ' Standard Edition (core installation)';
            PRODUCT_WEB_SERVER: Result := Result + ' Web Server Edition';
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
          else if (OSVERSIONINFOEX.wProductType = VER_NT_WORKSTATION) and (
            si.wProcessorArchitecture = PROCESSOR_ARCHITECTURE_AMD64) then
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
            end
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
              if Bool(OSVERSIONINFOEX.wSuiteMask and VER_SUITE_ENTERPRISE) then
                Result := Result + ' Server 4.0, Enterprise Edition'
              else
                Result := Result + ' Server';
            end
          end
          else
          begin // Test for specific product on Windows NT 4.0 SP5 and earlier
            dwBufLen := BUFSIZE;
            lRet := RegOpenKeyEx(HKEY_LOCAL_MACHINE, 'SYSTEM\CurrentControlSet\Control\ProductOptions', 0, KEY_QUERY_VALUE, hdlKey);
            if (lRet <> ERROR_SUCCESS) then Exit;
            lRet := RegQueryValueEx(hdlKey, 'ProductType', nil, nil, @szProductType[1], @dwBufLen);
            if ((lRet <> ERROR_SUCCESS) or (dwBufLen > BUFSIZE)) then Exit;
            RegCloseKey(hdlKey);
            if (lstrcmpi('WINNT', szProductType) = 0) then Result := Result + ' Workstation';
            if (lstrcmpi('LANMANNT', szProductType) = 0) then Result := Result + ' Server';
            if (lstrcmpi('SERVERNT', szProductType) = 0) then Result := Result + ' Advanced Server';
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

procedure TFrmAboutBox.FormCreate(Sender: TObject);
const
  FC: array[1..2] of Integer = (31, 16);
  W: array[1..2] of Integer = (90, 72);
  H: array[1..2] of Integer = (76, 51);
  Inter: array[1..2] of Integer = (50, 100);
  Back: array[1..2] of TColor = (clGray, clWhite);
var
  MemoryStatus: TMemoryStatus;
  v: DWord;
  unite: string;
begin
  ChargeImage(Image1, 'ABOUT');

  LbSysteme.Caption := GetWindowsVersion;

  MemoryStatus.dwLength := sizeof(MemoryStatus);
  GlobalMemoryStatus(MemoryStatus);

  v := MemoryStatus.dwTotalPhys;
  unite := 'Octets';
  if v > 1024 then
  begin
    v := Variant(v / 1024);
    unite := 'Ko';
  end;
  if v > 1024 then
  begin
    v := Variant(v / 1024);
    unite := 'Mo';
  end;
  if v > 1024 then
  begin
    v := Variant(v / 1024);
    unite := 'Go';
  end;
  LbMemoirePhysique.Caption := Format(MemoirePhysique + ': %.0n %s', [StrToFloat(IntToStr(v)), unite]);

  v := MemoryStatus.dwAvailPhys;
  unite := 'Octets';
  if v > 1024 then
  begin
    v := Variant(v / 1024);
    unite := 'Ko';
  end;
  if v > 1024 then
  begin
    v := Variant(v / 1024);
    unite := 'Mo';
  end;
  if v > 1024 then
  begin
    v := Variant(v / 1024);
    unite := 'Go';
  end;
  LbMemoireLibre.Caption := Format(MemoirePhysiqueDisponible + ': %.0n %s (%d%%)', [StrToFloat(IntToStr(v)), unite, 100 - MemoryStatus.dwMemoryLoad]);

  v := MemoryStatus.dwTotalVirtual;
  unite := 'Octets';
  if v > 1024 then
  begin
    v := Variant(v / 1024);
    unite := 'Ko';
  end;
  if v > 1024 then
  begin
    v := Variant(v / 1024);
    unite := 'Mo';
  end;
  if v > 1024 then
  begin
    v := Variant(v / 1024);
    unite := 'Go';
  end;
  LbMemoireVirtuelle.Caption := Format(MemoireVirtuelle + ': %.0n %s', [StrToFloat(IntToStr(v)), unite]);

  v := MemoryStatus.dwAvailVirtual;
  unite := 'Octets';
  if v > 1024 then
  begin
    v := Variant(v / 1024);
    unite := 'Ko';
  end;
  if v > 1024 then
  begin
    v := Variant(v / 1024);
    unite := 'Mo';
  end;
  if v > 1024 then
  begin
    v := Variant(v / 1024);
    unite := 'Go';
  end;
  LbMemoireVirtuelleDisponible.Caption := Format(MemoireVirtuelleDisponible + ': %.0n %s', [StrToFloat(IntToStr(v)), unite]);
end;

procedure TFrmAboutBox.ImLogoClick(Sender: TObject);
begin
  ShellExecute(0, nil, 'http://www.tetram.org', nil, nil, SW_NORMAL);
end;

end.

