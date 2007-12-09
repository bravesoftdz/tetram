unit Form_AboutBox;
{.$D-}
interface

uses
  Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls, ProceduresBDtk,
  Buttons, ExtCtrls, verslabp, ShellAPI, jpeg, dialogs;

type
  TFrmAboutBox = class(TForm)
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

function GetWindowsVersion: string;
type
  TGNSI = procedure(var lpSystemInfo: TSystemInfo); stdcall;

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
  VER_SUITE_SMALLBUSINESS = $001;
  VER_SUITE_ENTERPRISE = $002;
  VER_SUITE_BACKOFFICE = $004;
  VER_SUITE_COMMUNICATIONS = $008;
  VER_SUITE_TERMINAL = $010;
  VER_SUITE_SMALLBUSINESS_RESTRICTED = $020;
  VER_SUITE_EMBEDDEDNT = $040;
  VER_SUITE_DATACENTER = $080;
  VER_SUITE_SINGLEUSERTS = $100;
  VER_SUITE_PERSONAL = $200;
  VER_SUITE_BLADE = $400;
  VER_SUITE_STORAGE_SERVER = $2000;
  // wProductType
  VER_NT_WORKSTATION = $001;
  VER_NT_DOMAIN_CONTROLLER = $002;
  VER_NT_SERVER = $003;

  SM_SERVERR2 = 89;
  PROCESSOR_ARCHITECTURE_IA64 = 6;
  PROCESSOR_ARCHITECTURE_AMD64 = 9;

  BUFSIZE = 80;
var
  OSVERSIONINFOEX: _OSVERSIONINFOEX;
  OSVERSIONINFO: _OSVERSIONINFO absolute OSVERSIONINFOEX;
  si: SYSTEM_INFO;
  pGNSI: TGNSI;
  bOsVersionInfoEx: Boolean;
  hdlKey: HKEY;
  lRet: LONGINT;
  szProductType: array[0..Pred(BUFSIZE)] of Char;
  dwBufLen: DWORD;
begin
  Result := '';
  // Try calling GetVersionEx using the OSVERSIONINFOEX structure.
  // If that fails, try using the OSVERSIONINFO structure.
  ZeroMemory(@si, sizeof(SYSTEM_INFO));
  ZeroMemory(@OSVERSIONINFO, sizeof(_OSVERSIONINFOEX));
  OSVERSIONINFO.dwOSVersionInfoSize := sizeof(_OSVERSIONINFOEX);
  bOsVersionInfoEx := GetVersionEx(OSVERSIONINFO);
  if not bOsVersionInfoEx then begin
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
    VER_PLATFORM_WIN32_NT: begin
        // Test for the specific product family.
        Result := 'Unknown Windows';
        if (OSVERSIONINFO.dwMajorVersion = 6) and (OSVERSIONINFO.dwMinorVersion = 0) then
          if (OSVERSIONINFOEX.wProductType = VER_NT_WORKSTATION) then
            Result := 'Windows Vista'
          else
            Result := 'Windows Server "Longhorn"';
        if (OSVERSIONINFO.dwMajorVersion = 5) and (OSVERSIONINFO.dwMinorVersion = 2) then
          if (GetSystemMetrics(SM_SERVERR2) <> 0) then
            Result := 'Windows Server 2003 "R2"'
          else if (OSVERSIONINFOEX.wProductType = VER_NT_WORKSTATION) and (si.wProcessorArchitecture = PROCESSOR_ARCHITECTURE_AMD64) then
            Result := 'Windows XP Professional x64 Edition'
          else
            Result := 'Windows Server 2003';
        if (OSVERSIONINFO.dwMajorVersion = 5) and (OSVERSIONINFO.dwMinorVersion = 1) then Result := 'Windows XP';
        if (OSVERSIONINFO.dwMajorVersion = 5) and (OSVERSIONINFO.dwMinorVersion = 0) then Result := 'Windows 2000';
        if (OSVERSIONINFO.dwMajorVersion <= 4) then Result := 'Windows NT';
        // Test for specific product on Windows NT 4.0 SP6 and later.
        if bOsVersionInfoEx then begin
          // Test for the workstation type.
          if (OSVERSIONINFOEX.wProductType = VER_NT_WORKSTATION) and (si.wProcessorArchitecture <> PROCESSOR_ARCHITECTURE_AMD64) then begin
            if (OSVERSIONINFO.dwMajorVersion = 4) then
              Result := Result + ' Workstation 4.0'
            else if Bool(OSVERSIONINFOEX.wSuiteMask and VER_SUITE_PERSONAL) then
              Result := Result + ' Home Edition'
            else
              Result := Result + ' Professional';
          end
            // Test for the server type.
          else if (OSVERSIONINFOEX.wProductType = VER_NT_SERVER) or (OSVERSIONINFOEX.wProductType = VER_NT_DOMAIN_CONTROLLER) then begin
            if (OSVERSIONINFO.dwMajorVersion = 5) and (OSVERSIONINFO.dwMinorVersion = 2) then
              case si.wProcessorArchitecture of
                PROCESSOR_ARCHITECTURE_IA64: begin
                    if Bool(OSVERSIONINFOEX.wSuiteMask and VER_SUITE_DATACENTER) then
                      Result := Result + ' Datacenter Edition for Itanium-based Systems'
                    else if Bool(OSVERSIONINFOEX.wSuiteMask and VER_SUITE_ENTERPRISE) then
                      Result := Result + ' Enterprise Edition for Itanium-based Systems'
                    else
                      Result := Result + ' Standard Edition for Itanium-based Systems';
                  end;
                PROCESSOR_ARCHITECTURE_AMD64: begin
                    if Bool(OSVERSIONINFOEX.wSuiteMask and VER_SUITE_DATACENTER) then
                      Result := Result + ' Datacenter x64 Edition'
                    else if Bool(OSVERSIONINFOEX.wSuiteMask and VER_SUITE_ENTERPRISE) then
                      Result := Result + ' Enterprise x64 Edition'
                    else
                      Result := Result + ' Standard x64 Edition';
                  end;
                else begin
                  if Bool(OSVERSIONINFOEX.wSuiteMask and VER_SUITE_DATACENTER) then
                    Result := Result + ' Datacenter Edition'
                  else if Bool(OSVERSIONINFOEX.wSuiteMask and VER_SUITE_ENTERPRISE) then
                    Result := Result + ' Enterprise Edition'
                  else if Bool(OSVERSIONINFOEX.wSuiteMask and VER_SUITE_BLADE) then
                    Result := Result + ' Web Edition'
                  else
                    Result := Result + ' Standard Edition';
                end;
              end
            else if (OSVERSIONINFO.dwMajorVersion = 5) and (OSVERSIONINFO.dwMinorVersion = 0) then begin
              if Bool(OSVERSIONINFOEX.wSuiteMask and VER_SUITE_DATACENTER) then
                Result := Result + ' Datacenter Server'
              else if Bool(OSVERSIONINFOEX.wSuiteMask and VER_SUITE_ENTERPRISE) then
                Result := Result + ' Advanced Server'
              else
                Result := Result + ' Server';
            end
            else begin // Windows NT 4.0
              if Bool(OSVERSIONINFOEX.wSuiteMask and VER_SUITE_ENTERPRISE) then
                Result := Result + ' Server 4.0, Enterprise Edition'
              else
                Result := Result + ' Server';
            end;
          end
        end
        else begin // Test for specific product on Windows NT 4.0 SP5 and earlier
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
        // Display service pack (if any) and build number.
        if (OSVERSIONINFO.dwMajorVersion = 4) and (lstrcmpi(OSVERSIONINFO.szCSDVersion, 'Service Pack 6') = 0) then begin
          // Test for SP6 versus SP6a.
          lRet := RegOpenKeyEx(HKEY_LOCAL_MACHINE, 'SOFTWARE\Microsoft\Windows NT\CurrentVersion\Hotfix\Q246009', 0, KEY_QUERY_VALUE, hdlKey);
          if (lRet = ERROR_SUCCESS) then
            Result := Result + Format(' Service Pack 6a (Build %d)', [OSVERSIONINFO.dwBuildNumber and $FFFF])
          else // Windows NT 4.0 prior to SP6a
            Result := Result + Format(' %s (Build %d)', [OSVERSIONINFO.szCSDVersion, OSVERSIONINFO.dwBuildNumber and $FFFF]);
          RegCloseKey(hdlKey);
        end
        else begin
          Result := Result + Format(' %s (Build %d)', [OSVERSIONINFO.szCSDVersion, OSVERSIONINFO.dwBuildNumber and $FFFF]);
        end;
      end;
    // Test for the Windows 95 product family.
    VER_PLATFORM_WIN32_WINDOWS: begin
        if (OSVERSIONINFO.dwMajorVersion = 4) and (OSVERSIONINFO.dwMinorVersion = 0) then begin
          Result := 'Windows 95';
          if (OSVERSIONINFO.szCSDVersion[1] = 'C') or (OSVERSIONINFO.szCSDVersion[1] = 'B') then
            Result := Result + ' OSR2';
        end;
        if (OSVERSIONINFO.dwMajorVersion = 4) and (OSVERSIONINFO.dwMinorVersion = 10) then begin
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
  if v > 1024 then begin
    v := Variant(v / 1024); unite := 'Ko';
  end;
  if v > 1024 then begin
    v := Variant(v / 1024); unite := 'Mo';
  end;
  if v > 1024 then begin
    v := Variant(v / 1024); unite := 'Go';
  end;
  LbMemoirePhysique.Caption := Format(MemoirePhysique + ': %.0n %s', [StrToFloat(IntToStr(v)), unite]);

  v := MemoryStatus.dwAvailPhys;
  unite := 'Octets';
  if v > 1024 then begin
    v := Variant(v / 1024); unite := 'Ko';
  end;
  if v > 1024 then begin
    v := Variant(v / 1024); unite := 'Mo';
  end;
  if v > 1024 then begin
    v := Variant(v / 1024); unite := 'Go';
  end;
  LbMemoireLibre.Caption := Format(MemoirePhysiqueDisponible + ': %.0n %s (%d%%)', [StrToFloat(IntToStr(v)), unite, 100 - MemoryStatus.dwMemoryLoad]);

  v := MemoryStatus.dwTotalVirtual;
  unite := 'Octets';
  if v > 1024 then begin
    v := Variant(v / 1024); unite := 'Ko';
  end;
  if v > 1024 then begin
    v := Variant(v / 1024); unite := 'Mo';
  end;
  if v > 1024 then begin
    v := Variant(v / 1024); unite := 'Go';
  end;
  LbMemoireVirtuelle.Caption := Format(MemoireVirtuelle + ': %.0n %s', [StrToFloat(IntToStr(v)), unite]);

  v := MemoryStatus.dwAvailVirtual;
  unite := 'Octets';
  if v > 1024 then begin
    v := Variant(v / 1024); unite := 'Ko';
  end;
  if v > 1024 then begin
    v := Variant(v / 1024); unite := 'Mo';
  end;
  if v > 1024 then begin
    v := Variant(v / 1024); unite := 'Go';
  end;
  LbMemoireVirtuelleDisponible.Caption := Format(MemoireVirtuelleDisponible + ': %.0n %s', [StrToFloat(IntToStr(v)), unite]);
end;

procedure TFrmAboutBox.ImLogoClick(Sender: TObject);
begin
  ShellExecute(0, nil, 'http://www.tetram.org', nil, nil, SW_NORMAL);
end;

end.
