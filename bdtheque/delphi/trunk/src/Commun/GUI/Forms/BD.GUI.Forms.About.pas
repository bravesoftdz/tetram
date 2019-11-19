unit BD.GUI.Forms.About;

{ $D- }
interface

uses
  Winapi.Windows, System.SysUtils, System.Classes, Vcl.Graphics, Vcl.Forms, Vcl.Controls, Vcl.StdCtrls, Vcl.Buttons, Vcl.ExtCtrls, verslabp, Winapi.ShellAPI, Vcl.Imaging.jpeg, Vcl.Dialogs, BD.GUI.Forms,
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
    LbMemoireVirtuelle: TLabel;
    LbMemoireVirtuelleDisponible: TLabel;
    VlFullVersion: TfshVersionLabel;
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

uses
  BD.Utils.GUIUtils, System.Math;

resourcestring
  MemoirePhysique = 'Physique';
  MemoirePhysiqueDisponible = 'Physique disponible';
  MemoireVirtuelle = 'Virtuelle';
  MemoireVirtuelleDisponible = 'Virtuelle disponible';
{$R *.DFM}

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
