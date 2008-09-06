unit IDHashMap;

interface

uses
  SysUtils, Math;

type
  TIDHashMap = class;

  THashEntry = record
    HID: Cardinal;
    HKey: Integer;
    HEintrag: boolean;
    HDelete: boolean;
    HHashMap: TIDHashMap;
  end;

  TIDHashMap = class(TObject)
  private
    fEntrys: array of THashEntry;
    fRand: Cardinal;
    fSize: Cardinal;
    procedure SetSize(const Value: Cardinal);
    { Private-Deklarationen }
  protected
    { Protected-Deklarationen }
  public
    constructor Create;
    destructor Destroy; override;
    procedure InsertID(ID: Cardinal; Key: Integer);
    function FindKey(ID: Cardinal; var Key: Integer): boolean;
    procedure DeleteKey(ID: Cardinal);
    procedure ClearList;
    property Size: Cardinal read fSize write SetSize;
    { Public-Deklarationen }
  end;

implementation

{ TIDHashMap }

procedure TIDHashMap.ClearList;
var
  Dummy: Integer;
begin
  for Dummy := 0 to fSize - 1 do
  begin
    with fEntrys[Dummy] do
    begin
      HEintrag := false;
      HDelete := false;
      if HHashMap <> nil then
      begin
        HHashMap.Free;
        HHashMap := nil;
      end;
    end;
  end;
end;

constructor TIDHashMap.Create;
begin
  fRand := round(random * High(Cardinal));
  Size := 59;
end;

procedure TIDHashMap.DeleteKey(ID: Cardinal);
var
  Hash: Cardinal;
begin
  Hash := (ID + fRand) mod fSize;
  with fEntrys[Hash] do
  begin
    if HEintrag then
    begin
      if HID = ID then
      begin
        HDelete := true;
      end
      else
      begin
        if HHashMap <> nil then
          HHashMap.DeleteKey(ID);
      end;
    end;
  end;
end;

destructor TIDHashMap.Destroy;
begin
  ClearList;
  inherited;
end;

function TIDHashMap.FindKey(ID: Cardinal; var Key: Integer): boolean;
var
  Hash: Cardinal;
begin
  Key := 0;
  result := true;
  Hash := (ID + fRand) mod fSize;
  with fEntrys[Hash] do
  begin
    if HEintrag then
    begin
      if HID = ID then
      begin
        if not HDelete then
        begin
          Key := HKey;
          exit;
        end;
      end
      else
      begin
        if HHashMap <> nil then
        begin
          result := HHashMap.FindKey(ID, Key);
          exit;
        end;
      end;
    end;
  end;
  result := false;
end;

procedure TIDHashMap.InsertID(ID: Cardinal; Key: Integer);
var
  Hash: Cardinal;
begin
  Hash := (ID + fRand) mod fSize;
  with fEntrys[Hash] do
  begin
    if HEintrag then
    begin
      if not HDelete then
      begin
        if ID = HID then
          raise Exception.Create('Valeur existe déjà');
        if HHashMap = nil then
        begin
          HHashMap := TIDHashMap.Create;
          HHashMap.Size := max(7, fSize div 2);
        end;
        HHashMap.InsertID(ID, Key);
        exit;
      end
      else
        HDelete := false;
    end;
    HID := ID;
    HKey := Key;
    HEintrag := true;
  end;
end;

procedure TIDHashMap.SetSize(const Value: Cardinal);
begin
  ClearList;
  fSize := Value;
  SetLength(fEntrys, fSize);
end;

end.

