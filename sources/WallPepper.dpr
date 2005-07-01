program WallPepper;

{$R 'TRAV.res' 'TRAV.RC'}

uses
  Forms,
  Windows,
  SysUtils,
  Dialogs,
  ComObj,
  Form_Main in 'Form_Main.pas' {Fond},
  Divers in '..\..\..\Common\Divers.pas',
  UOldOptions in '..\Sources wpconf.dll\UOldOptions.pas',
  UOptions in '..\Sources wpconf.dll\UOptions.pas',
  UInterfacePlugIn in '..\SDK\UInterfacePlugIn.pas',
  UInterfaceChange in '..\SDK\UInterfaceChange.pas',
  CheckVersionNet in '..\..\..\Common\CheckVersionNet.pas' {frmVerifUpgrade},
  RNDGen in 'RNDGen.pas';

{$R *.RES}

begin
  Application.Title := 'WallPepper';
  if not Bool(CreateMutex(nil, True, 'TetramCorpWallPepperMutex')) then
    RaiseLastOSError
  else
    if GetLastError = ERROR_ALREADY_EXISTS then begin
      ShowMessage('Une instance de WallPepper est déjà ouverte!');
      Exit;
    end;

  Application.Initialize;
  ShowWindow(Application.Handle, SW_Hide);
  Application.ShowMainForm := False;
  Application.CreateForm(TFond, Fond);
  HideFormOnTaskBar(Fond.Handle);
  (Fond as IEvenements).DemarrageWP;
  Application.Run;
end.
