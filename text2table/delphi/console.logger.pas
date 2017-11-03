unit console.logger;

interface

uses
  SysUtils;

type
  ConsoleString = type AnsiString(850);
  TLogLevel = (llError, llInfo);

  ILogger = interface
    procedure Trace(const Msg: string; Level: TLogLevel); overload;
    procedure Trace(const Msg: string; const Params: array of const; Level: TLogLevel); overload;
    procedure Info(const Msg: string = ''); overload;
    procedure Info(const Msg: string; const Params: array of const); overload;
    procedure Error(const Msg: string = ''); overload;
    procedure Error(const Msg: string; const Params: array of const); overload;
    procedure Progress(const Msg: string); overload;
    procedure Progress(const Msg: string; const Params: array of const); overload;
  end;

  TAbstractLogger = class(TInterfacedObject, ILogger)
  public
    procedure Trace(const Msg: string; Level: TLogLevel); overload; virtual; abstract;
    procedure Trace(const Msg: string; const Params: array of const; Level: TLogLevel); overload; virtual;
    procedure Info(const Msg: string = ''); overload; virtual;
    procedure Info(const Msg: string; const Params: array of const); overload; virtual;
    procedure Error(const Msg: string = ''); overload; virtual;
    procedure Error(const Msg: string; const Params: array of const); overload; virtual;
    procedure Progress(const Msg: string); overload; virtual; abstract;
    procedure Progress(const Msg: string; const Params: array of const); overload;
  end;

  TConsoleLogger = class(TAbstractLogger)
  public
    procedure Trace(const Msg: string; Level: TLogLevel); override;
    procedure Progress(const Msg: string); override;
  end;

implementation

{ TAbstractLogger }

procedure TAbstractLogger.Trace(const Msg: string; const Params: array of const; Level: TLogLevel);
begin
  Trace(Format(Msg, Params), Level);
end;

procedure TAbstractLogger.Info(const Msg: string);
begin
  Trace(Msg, llInfo);
end;

procedure TAbstractLogger.Info(const Msg: string; const Params: array of const);
begin
  Trace(Msg, Params, llInfo);
end;

procedure TAbstractLogger.Progress(const Msg: string; const Params: array of const);
begin
  Progress(Format(Msg, Params));
end;

procedure TAbstractLogger.Error(const Msg: string; const Params: array of const);
begin
  Trace(Msg, Params, llError);
end;

procedure TAbstractLogger.Error(const Msg: string);
begin
  Trace(Msg, llError);
end;

{ TConsoleLogger }

procedure TConsoleLogger.Progress(const Msg: string);
begin
  Write(Msg, StringOfChar(' ', 80 - (Length(Msg) + 1)), #13);
end;

procedure TConsoleLogger.Trace(const Msg: string; Level: TLogLevel);
begin
  if Level = llError then
    WriteLn(ErrOutput, ConsoleString(Msg))
  else
    WriteLn(ConsoleString(Msg));
end;

end.
