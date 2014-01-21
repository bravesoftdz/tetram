unit TestICUNumberFormat;
{

  Cas de test DUnit Delphi
  ----------------------
  Cette unité contient une classe cas de test de squelette générée par l'expert Cas de test.
  Modifiez le code généré pour configurer et appeler correctement les méthodes de l'unité 
  en cours de test.

}

interface

uses
  TestFramework, System.Classes, ICUNumberFormatter, unum, System.SysUtils;

type
  // Méthodes de test pour la classe TICUNumberFormat

  TestTICUNumberFormat = class(TTestCase)
  strict private
    FICUNumberFormat: IICUNumberFormatter;
  public
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure TestAsNaturalInteger;
    procedure TestAsNaturalDouble;
    procedure TestAsNaturalCurrency;
    procedure TestAsNaturalCurrencyCode;
  end;

implementation

procedure TestTICUNumberFormat.SetUp;
begin
end;

procedure TestTICUNumberFormat.TearDown;
begin
end;

procedure TestTICUNumberFormat.TestAsNaturalInteger;
var
  Value: Integer;
begin
  Value := 153;

  FICUNumberFormat := TICUNumberFormatter.Create('fr-FR', UNUM_SPELLOUT);
  CheckEquals('cent cinquante-trois', FICUNumberFormat.Format(Value));
  FICUNumberFormat := TICUNumberFormatter.Create('en-US', UNUM_SPELLOUT);
  CheckEquals('one hundred fifty-three', FICUNumberFormat.Format(Value));
end;

procedure TestTICUNumberFormat.TestAsNaturalDouble;
var
  Value: Double;
begin
  Value := 153.459;

  FICUNumberFormat := TICUNumberFormatter.Create('fr-FR', UNUM_SPELLOUT);
  CheckEquals('cent cinquante-trois virgule quatre cinq neuf', FICUNumberFormat.Format(Value));
  FICUNumberFormat := TICUNumberFormatter.Create('en-US', UNUM_SPELLOUT);
  CheckEquals('one hundred fifty-three point four five nine', FICUNumberFormat.Format(Value));
end;

procedure TestTICUNumberFormat.TestAsNaturalCurrency;
var
  Value: Currency;
begin
  Value := 153.45;

  FICUNumberFormat := TICUNumberFormatter.Create('fr-FR', UNUM_SPELLOUT);
  CheckEquals('cent cinquante-trois virgule quatre cinq', FICUNumberFormat.Format(Value));
  FICUNumberFormat := TICUNumberFormatter.Create('en-US', UNUM_SPELLOUT);
  CheckEquals('one hundred fifty-three point four five', FICUNumberFormat.Format(Value));
end;

procedure TestTICUNumberFormat.TestAsNaturalCurrencyCode;
var
  Value: Currency;
begin
  Value := 153.45;

  FICUNumberFormat := TICUNumberFormatter.Create('fr-FR', UNUM_SPELLOUT);
  CheckEquals('cent cinquante-trois virgule quatre cinq', FICUNumberFormat.Format(Value, 'USD'));
  FICUNumberFormat := TICUNumberFormatter.Create('en-US', UNUM_SPELLOUT);
  CheckEquals('one hundred fifty-three point four five', FICUNumberFormat.Format(Value, 'EUR'));
end;

initialization
  // Enregistrer tous les cas de test avec l'exécuteur de test
  RegisterTest(TestTICUNumberFormat.Suite);
end.

