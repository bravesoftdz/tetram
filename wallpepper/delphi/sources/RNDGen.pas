unit RNDGen;

{| RNDGen 2.1 from 21 Nov 2003
 | Copyright (c) 2000-2002 SoftComplete Development
 | Web    http://www.softcomplete.com
 | Email  support@softcomplete.com
 | True random generator for Delphi and C++ Builder
 |
 | ------------------- History -------------------
 |  2.1 from 21 Nov 2003
 |    - add GetRNDDWORD
 |
 |  2.0 from 5 Oct 2002
 |    - full implementation rewrite
 |
 |  1.2 from 25 Aug 2001
 |    - improved initialization
 |
 |  1.1 from 19 Jun 2001
 |    - add GetRNDByte
 |    - add GetRNDInt (work like delphi random)
 |
 |  1.0 from 11 Dec 2000
 |    Initial release
 |
 |}

interface

uses
  Windows, Messages, SysUtils, Classes;

function MakeRND(Len: integer): string;
procedure FillRND(Buff: Pointer; Len: integer);

function GetRNDByte: Byte;
// create random integer in range 0 <= X < Range
// like standart delphi random
function GetRNDInt(Range: integer = 0): integer;
function GetRNDDWORD: DWORD;

implementation

var
  rotor, { Rotor and ratchet are used to help }
  ratchet, { Continually shuffle the "cards."   }
  avalanche, { Data dependent index. }
  last_plain, { Previous plain text byte. }
  last_cipher: byte; { Previous cipher text byte. }
  cards: array[0..255] of byte; { Array to hold a permutation of all }
  CS: TRTLCriticalSection;
  TimeThread: TThread;

procedure PoolByte(b: Byte);
var
  swaptemp: byte;
begin
  EnterCriticalSection(CS);
  try
    ratchet := (ratchet + cards[rotor]) and $FF;
    inc(rotor);
    swaptemp := cards[last_cipher]; { Round-robin swap. }
    cards[last_cipher] := cards[ratchet];
    cards[ratchet] := cards[last_plain];
    cards[last_plain] := cards[rotor];
    cards[rotor] := swaptemp;
    avalanche := (avalanche + cards[swaptemp]) and $FF;
    last_cipher := b xor
      cards[(cards[ratchet] + cards[rotor]) and $FF] xor
      cards[cards[(cards[last_plain] + cards[last_cipher] +
      cards[avalanche]) and $FF]];
    last_plain := b;
  finally
    LeaveCriticalSection(CS);
  end;
end;

procedure PoolHiTime;
var
  hLast: TLargeInteger;
begin
  QueryPerformanceCounter(hLast);
  PoolByte(hLast and $FF);
end;

procedure PoolInt(Value: integer);
var
  j: integer;
begin
  for j := 1 to 4 do begin
    PoolByte(Value and $FF);
    Value := Value shr 8;
  end;
end;

type
  TTimeThread = class(TThread)
  protected
    procedure Execute; override;
  end;

procedure TTimeThread.Execute;
begin
  FreeOnTerminate := True;
  while not Terminated do begin
    Sleep(20);
    PoolHiTime;
  end;
end;

function GetRNDByte: Byte;
begin
  EnterCriticalSection(CS);
  try
    PoolHiTime;
    Result := last_cipher;
  finally
    LeaveCriticalSection(CS);
  end;
end;

function GetRNDDWORD: DWORD;
begin
  FillRND(@Result, SizeOf(Result));
end;

function GetRNDInt(Range: integer): integer;
begin
  FillRND(@Result, SizeOf(Result));
  Result := Result and $7FFFFFFF; // >= 0
  if Range > 0 then
    Result := Result mod Range;
end;

function MakeRND(Len: integer): string;
var
  i: integer;
begin
  EnterCriticalSection(CS);
  try
    SetLength(Result, Len);
    for i := 1 to Len do begin
      PoolHiTime;
      Result[i] := Chr(last_cipher);
    end;
  finally
    LeaveCriticalSection(CS);
  end;
end;

procedure FillRND(Buff: Pointer; Len: integer);
var
  i: integer;
  p: PByte;
begin
  p := PByte(Buff);
  EnterCriticalSection(CS);
  try
    for i := 1 to Len do begin
      PoolHiTime;
      p^ := last_cipher;
      Inc(p);
    end;
  finally
    LeaveCriticalSection(CS);
  end;
end;

procedure HashInit;
var
  i, j: integer;
  MemStat: TMemoryStatus;
begin
  rotor := 1; { Make sure we start key in a known place. }
  ratchet := 3;
  avalanche := 5;
  last_plain := 7;
  last_cipher := 11;
  j := 255;
  for i := 0 to 255 do { Start with cards all in inverse order. } begin
    cards[i] := j;
    dec(j);
  end;
  MemStat.dwLength := sizeof(TMemoryStatus);
  GlobalMemoryStatus(MemStat);
  PoolInt(MemStat.dwAvailPhys);
  PoolInt(MemStat.dwAvailPageFile);
  PoolInt(MemStat.dwAvailVirtual);
  PoolInt(Round(Date));
  PoolInt(Round(Frac(Now) * $7FFFFFFF));
  for j := 0 to 1000 do
    PoolHiTime;
end;

initialization
  InitializeCriticalSection(CS);
  HashInit;
  TimeThread := TTimeThread.Create(False);

finalization
  TimeThread.Terminate;
  DeleteCriticalSection(CS);

end.

