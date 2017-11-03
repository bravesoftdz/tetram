unit UNetICSCompress;

interface

uses
  System.Classes, OverbyteIcsHttpContCod, JclCompression;

type
  THttpCCodzlib = class(THttpContentCoding)
  private
    FStream: TMemoryStream;
  protected
    class function GetActive: Boolean; override;
    class function GetCoding: String; override;
  public
    constructor Create(WriteBufferProc: TWriteBufferProcedure); override;
    destructor Destroy; override;

    procedure Complete; override;
    procedure WriteBuffer(Buffer: Pointer; Count: Integer); override;
  end;

implementation

{ THttpCCodzlib }

procedure THttpCCodzlib.Complete;
var
  Archive: TJclGZipDecompressArchive;
  tmpStream: TMemoryStream;
begin
  tmpStream := TMemoryStream.Create;
  Archive := TJclGZipDecompressArchive.Create(FStream);
  try
    Archive.ListFiles;
    Archive.Items[0].Selected := True;
    Archive.Items[0].Stream := tmpStream;
    Archive.Items[0].OwnsStream := False;
    Archive.ExtractSelected;
    OutputWriteBuffer(tmpStream.Memory, tmpStream.Size);
  finally
    Archive.Free;
    tmpStream.Free;
  end;
end;

constructor THttpCCodzlib.Create(WriteBufferProc: TWriteBufferProcedure);
begin
  inherited;
  FStream := TMemoryStream.Create;
end;

destructor THttpCCodzlib.Destroy;
begin
  FStream.Free;
  inherited;
end;

class function THttpCCodzlib.GetActive: Boolean;
begin
  Result := True;
end;

class function THttpCCodzlib.GetCoding: String;
begin
  Result := 'gzip, deflate';
end;

procedure THttpCCodzlib.WriteBuffer(Buffer: Pointer; Count: Integer);
begin
  FStream.WriteBuffer(Buffer^, Count);
end;

initialization

THttpContCodHandler.RegisterContentCoding(1, THttpCCodzlib);

finalization

THttpContCodHandler.UnregisterAuthenticateClass(THttpCCodzlib);

end.
