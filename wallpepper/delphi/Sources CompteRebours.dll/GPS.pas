unit GPS;

interface

type
  TIntitules = array[0..1] of string;
  TVille = record
    Intitule1, Nom: string;
    Latitude, Longitude: Double;
  end;
  TPays = record
    Nom: string;
    Intitules: TIntitules;
    nVilles: Integer;
    Villes: array[1..95] of TVille;
  end;

const
  Coordonnees: array[0..7] of TPays =
    ( (Nom: 'FRANCE';
       Intitules: ('Départements', 'Villes');
       nVilles: 95;
       Villes:
        ((Intitule1: '01';
          Nom: 'BOURG';
          Latitude: 46.12;
          Longitude: 5.13),
         (Intitule1: '02';
          Nom: 'LAON';
          Latitude: 49.34;
          Longitude: 3.37),
         (Intitule1: '03';
          Nom: 'MOULINS';
          Latitude: 46.34;
          Longitude: 3.20),
         (Intitule1: '04';
          Nom: 'DIGNE';
          Latitude: 44.05;
          Longitude: 6.14),
         (Intitule1: '05';
          Nom: 'GAP';
          Latitude: 44.33;
          Longitude: 6.05),
         (Intitule1: '06';
          Nom: 'NICE';
          Latitude: 43.42;
          Longitude: 7.16),
         (Intitule1: '07';
          Nom: 'PRIVAS';
          Latitude: 44.44;
          Longitude: 4.36),
         (Intitule1: '08';
          Nom: 'MEZIERES';
          Latitude: 49.46;
          Longitude: 4.44),
         (Intitule1: '09';
          Nom: 'FOIX';
          Latitude: 42.57;
          Longitude: 1.35),
         (Intitule1: '10';
          Nom: 'TROYES';
          Latitude: 48.18;
          Longitude: 4.05),
         (Intitule1: '11';
          Nom: 'CARCASSONNE';
          Latitude: 43.13;
          Longitude: 2.21),
         (Intitule1: '12';
          Nom: 'RODEZ';
          Latitude: 44.21;
          Longitude: 2.34),
         (Intitule1: '13';
          Nom: 'MARSEILLE';
          Latitude: 43.18;
          Longitude: 5.22),
         (Intitule1: '14';
          Nom: 'CAEN';
          Latitude: 49.11;
          Longitude: 359.38),
         (Intitule1: '15';
          Nom: 'AURILLAC';
          Latitude: 44.56;
          Longitude: 2.26),
         (Intitule1: '16';
          Nom: 'ANGOULEME';
          Latitude: 45.40;
          Longitude: 0.10),
         (Intitule1: '17';
          Nom: 'LA ROCHELLE';
          Latitude: 46.10;
          Longitude: 358.50),
         (Intitule1: '18';
          Nom: 'BOURGES';
          Latitude: 47.05;
          Longitude: 2.23),
         (Intitule1: '19';
          Nom: 'TULLE';
          Latitude: 45.16;
          Longitude: 1.46),
         (Intitule1: '20';
          Nom: 'AJACCIO';
          Latitude: 41.55;
          Longitude: 8.43),
         (Intitule1: '21';
          Nom: 'DIJON';
          Latitude: 47.20;
          Longitude: 5.02),
         (Intitule1: '22';
          Nom: 'ST-BRIEUX';
          Latitude: 48.31;
          Longitude: 357.15),
         (Intitule1: '23';
          Nom: 'GUERET';
          Latitude: 46.10;
          Longitude: 1.52),
         (Intitule1: '24';
          Nom: 'PERIGUEUX';
          Latitude: 45.12;
          Longitude: 0.44),
         (Intitule1: '25';
          Nom: 'BESANCON';
          Latitude: 47.14;
          Longitude: 6.12),
         (Intitule1: '26';
          Nom: 'VALENCE';
          Latitude: 44.56;
          Longitude: 4.54),
         (Intitule1: '27';
          Nom: 'EVREUX';
          Latitude: 49.03;
          Longitude: 1.11),
         (Intitule1: '28';
          Nom: 'CHARTRES';
          Latitude: 48.27;
          Longitude: 1.30),
         (Intitule1: '29';
          Nom: 'QUIMPER';
          Latitude: 48.00;
          Longitude: 355.54),
         (Intitule1: '30';
          Nom: 'NIMES';
          Latitude: 43.50;
          Longitude: 4.21),
         (Intitule1: '31';
          Nom: 'TOULOUSE';
          Latitude: 43.37;
          Longitude: 1.27),
         (Intitule1: '32';
          Nom: 'AUCH';
          Latitude: 43.30;
          Longitude: 0.36),
         (Intitule1: '33';
          Nom: 'BORDEAUX';
          Latitude: 44.50;
          Longitude: 359.26),
         (Intitule1: '34';
          Nom: 'MONTPELLIER';
          Latitude: 43.36;
          Longitude: 3.53),
         (Intitule1: '35';
          Nom: 'RENNES';
          Latitude: 48.06;
          Longitude: 358.20),
         (Intitule1: '36';
          Nom: 'CHATEAUROUX';
          Latitude: 46.49;
          Longitude: 1.41),
         (Intitule1: '37';
          Nom: 'TOURS';
          Latitude: 47.23;
          Longitude: 0.42),
         (Intitule1: '38';
          Nom: 'GRENOBLE';
          Latitude: 45.11;
          Longitude: 5.43),
         (Intitule1: '39';
          Nom: 'LONS-LE-SAUNIER';
          Latitude: 46.41;
          Longitude: 5.33),
         (Intitule1: '40';
          Nom: 'MONT-DE-MARSAN';
          Latitude: 43.54;
          Longitude: 359.30),
         (Intitule1: '41';
          Nom: 'BLOIS';
          Latitude: 47.36;
          Longitude: 1.20),
         (Intitule1: '42';
          Nom: 'ST-ETIENNE';
          Latitude: 45.26;
          Longitude: 4.23),
         (Intitule1: '43';
          Nom: 'LE PUY';
          Latitude: 45.03;
          Longitude: 3.53),
         (Intitule1: '44';
          Nom: 'NANTES';
          Latitude: 47.14;
          Longitude: 358.25),
         (Intitule1: '45';
          Nom: 'ORLEANS';
          Latitude: 47.54;
          Longitude: 1.54),
         (Intitule1: '46';
          Nom: 'CAHORS';
          Latitude: 44.28;
          Longitude: 0.26),
         (Intitule1: '47';
          Nom: 'AGEN';
          Latitude: 44.12;
          Longitude: 0.38),
         (Intitule1: '48';
          Nom: 'MENDE';
          Latitude: 44.32;
          Longitude: 3.30),
         (Intitule1: '49';
          Nom: 'ANGERS';
          Latitude: 47.29;
          Longitude: 359.28),
         (Intitule1: '50';
          Nom: 'ST-LO';
          Latitude: 49.07;
          Longitude: 358.55),
         (Intitule1: '51';
          Nom: 'CHALONS-S-MARNE';
          Latitude: 48.58;
          Longitude: 4.22),
         (Intitule1: '52';
          Nom: 'CHAUMONT';
          Latitude: 48.07;
          Longitude: 5.08),
         (Intitule1: '53';
          Nom: 'LAVAL';
          Latitude: 48.04;
          Longitude: 359.15),
         (Intitule1: '54';
          Nom: 'NANCY';
          Latitude: 48.42;
          Longitude: 6.12),
         (Intitule1: '55';
          Nom: 'BAR-LE-DUC';
          Latitude: 48.46;
          Longitude: 5.10),
         (Intitule1: '56';
          Nom: 'VANNES';
          Latitude: 47.40;
          Longitude: 357.16),
         (Intitule1: '57';
          Nom: 'METZ';
          Latitude: 49.07;
          Longitude: 6.11),
         (Intitule1: '58';
          Nom: 'NEVERS';
          Latitude: 47.00;
          Longitude: 3.09),
         (Intitule1: '59';
          Nom: 'LILLE';
          Latitude: 50.39;
          Longitude: 3.05),
         (Intitule1: '60';
          Nom: 'BEAUVAIS';
          Latitude: 49.26;
          Longitude: 2.05),
         (Intitule1: '61';
          Nom: 'ALENCON';
          Latitude: 48.25;
          Longitude: 0.05),
         (Intitule1: '62';
          Nom: 'ARRAS';
          Latitude: 50.17;
          Longitude: 2.46),
         (Intitule1: '63';
          Nom: 'CLERMONT-FERRAND';
          Latitude: 45.47;
          Longitude: 3.05),
         (Intitule1: '64';
          Nom: 'PAU';
          Latitude: 43.18;
          Longitude: 359.38),
         (Intitule1: '65';
          Nom: 'TARBES';
          Latitude: 43.14;
          Longitude: 0.05),
         (Intitule1: '66';
          Nom: 'PERPIGNAN';
          Latitude: 42.42;
          Longitude: 2.54),
         (Intitule1: '67';
          Nom: 'STRASBOURG';
          Latitude: 48.35;
          Longitude: 7.45),
         (Intitule1: '68';
          Nom: 'COLMAR';
          Latitude: 48.05;
          Longitude: 7.21),
         (Intitule1: '69';
          Nom: 'LYON';
          Latitude: 45.46;
          Longitude: 4.50),
         (Intitule1: '70';
          Nom: 'VESOUL';
          Latitude: 47.38;
          Longitude: 6.09),
         (Intitule1: '71';
          Nom: 'MACON';
          Latitude: 46.18;
          Longitude: 4.50),
         (Intitule1: '72';
          Nom: 'LE MANS';
          Latitude: 48.00;
          Longitude: 0.12),
         (Intitule1: '73';
          Nom: 'CHAMBERY';
          Latitude: 45.34;
          Longitude: 5.55),
         (Intitule1: '74';
          Nom: 'ANNECY';
          Latitude: 45.54;
          Longitude: 6.07),
         (Intitule1: '75';
          Nom: 'PARIS';
          Latitude: 48.52;
          Longitude: 2.20),
         (Intitule1: '76';
          Nom: 'ROUEN';
          Latitude: 49.26;
          Longitude: 1.05),
         (Intitule1: '77';
          Nom: 'MELUN';
          Latitude: 48.32;
          Longitude: 2.40),
         (Intitule1: '78';
          Nom: 'VERSAILLES';
          Latitude: 48.48;
          Longitude: 2.08),
         (Intitule1: '79';
          Nom: 'NIORT';
          Latitude: 46.19;
          Longitude: 359.33),
         (Intitule1: '80';
          Nom: 'AMIENS';
          Latitude: 49.54;
          Longitude: 2.18),
         (Intitule1: '81';
          Nom: 'ALBI';
          Latitude: 43.56;
          Longitude: 2.08),
         (Intitule1: '82';
          Nom: 'MONTAUBAN';
          Latitude: 44.01;
          Longitude: 1.20),
         (Intitule1: '83';
          Nom: 'TOULON';
          Latitude: 43.07;
          Longitude: 5.55),
         (Intitule1: '84';
          Nom: 'AVIGNON';
          Latitude: 43.56;
          Longitude: 4.48),
         (Intitule1: '85';
          Nom: 'LA-ROCHE-SUR-YON';
          Latitude: 46.38;
          Longitude: 358.30),
         (Intitule1: '86';
          Nom: 'POITIERS';
          Latitude: 46.35;
          Longitude: 0.20),
         (Intitule1: '87';
          Nom: 'LIMOGES';
          Latitude: 45.50;
          Longitude: 1.15),
         (Intitule1: '88';
          Nom: 'EPINAL';
          Latitude: 48.10;
          Longitude: 6.28),
         (Intitule1: '89';
          Nom: 'AUXERRE';
          Latitude: 47.48;
          Longitude: 3.35),
         (Intitule1: '90';
          Nom: 'BELFORT';
          Latitude: 47.38;
          Longitude: 6.52),
         (Intitule1: '91';
          Nom: 'EVRY';
          Latitude: 48.38;
          Longitude: 2.34),
         (Intitule1: '92';
          Nom: 'NANTERRE';
          Latitude: 48.53;
          Longitude: 2.13),
         (Intitule1: '93';
          Nom: 'BOBIGNY';
          Latitude: 48.55;
          Longitude: 2.27),
         (Intitule1: '94';
          Nom: 'CRETEIL';
          Latitude: 48.47;
          Longitude: 2.28),
         (Intitule1: '95';
          Nom: 'PONTOISE';
          Latitude: 49.03;
          Longitude: 2.05)
        )
       ),
 (Nom: 'EUROPE';
       Intitules: ('Pays', 'Villes');
       nVilles: 36;
       Villes:
        ((Intitule1: 'PAYS-BAS';
          Nom: 'AMSTERDAM';
          Latitude: 52.21;
          Longitude: 4.54),
         (Intitule1: 'BELGIQUE';
          Nom: 'ANVERS';
          Latitude: 51.13;
          Longitude: 4.25),
         (Intitule1: 'GRECE';
          Nom: 'ATHENES';
          Latitude: 38.00;
          Longitude: 23.44),
         (Intitule1: 'SUISSE';
          Nom: 'BALE';
          Latitude: 47.33;
          Longitude: 7.36),
         (Intitule1: 'BELGIQUE';
          Nom: 'BASTOGNE';
          Latitude: 50.00;
          Longitude: 5.43),
         (Intitule1: 'SUISSE';
          Nom: 'BERN';
          Latitude: 46.57;
          Longitude: 7.26),
         (Intitule1: 'BELGIQUE';
          Nom: 'BRUGES';
          Latitude: 51.13;
          Longitude: 3.14),
         (Intitule1: 'BELGIQUE';
          Nom: 'BRUXELLES';
          Latitude: 50.50;
          Longitude: 4.21),
         (Intitule1: 'BELGIQUE';
          Nom: 'CHARLEROI';
          Latitude: 50.25;
          Longitude: 4.27),
         (Intitule1: 'BELGIQUE';
          Nom: 'CHIMAY';
          Latitude: 50.04;
          Longitude: 4.21),
         (Intitule1: 'BELGIQUE';
          Nom: 'DINANT';
          Latitude: 50.16;
          Longitude: 4.55),
         (Intitule1: 'IRLANDE';
          Nom: 'DUBLIN';
          Latitude: 53.20;
          Longitude: 353.45),
         (Intitule1: 'BELGIQUE';
          Nom: 'GAND';
          Latitude: 51.02;
          Longitude: 3.42),
         (Intitule1: 'SUISSE';
          Nom: 'GENEVE';
          Latitude: 46.13;
          Longitude: 6.09),
         (Intitule1: 'ECOSSE';
          Nom: 'GLASGOW';
          Latitude: 55.53;
          Longitude: 355.45),
         (Intitule1: 'ANGLETERRE';
          Nom: 'GREENWICH';
          Latitude: 51.30;
          Longitude: 0.00),
         (Intitule1: 'BELGIQUE';
          Nom: 'HASSELL';
          Latitude: 50.55;
          Longitude: 5.22),
         (Intitule1: 'FINLANDE';
          Nom: 'HELSINKI';
          Latitude: 60.08;
          Longitude: 25.00),
         (Intitule1: 'POLOGNE';
          Nom: 'KRAKOW';
          Latitude: 50.03;
          Longitude: 19.55),
         (Intitule1: 'SUISSE';
          Nom: 'LAUSANNE';
          Latitude: 46.32;
          Longitude: 6.39),
         (Intitule1: 'BELGIQUE';
          Nom: 'LIEGE';
          Latitude: 50.40;
          Longitude: 5.35),
         (Intitule1: 'ANGLETERRE';
          Nom: 'LONDON';
          Latitude: 51.30;
          Longitude: 359.54),
         (Intitule1: 'LUXEMBOURG';
          Nom: 'LUXEMBOURG';
          Latitude: 49.36;
          Longitude: 6.09),
         (Intitule1: 'ESPAGNE';
          Nom: 'MADRID';
          Latitude: 40.25;
          Longitude: 356.17),
         (Intitule1: 'ITALIE';
          Nom: 'MILANO';
          Latitude: 45.28;
          Longitude: 9.12),
         (Intitule1: 'RUSSIE';
          Nom: 'MOSKVA';
          Latitude: 55.45;
          Longitude: 37.42),
         (Intitule1: 'BELGIQUE';
          Nom: 'NAMUR';
          Latitude: 50.27;
          Longitude: 4.51),
         (Intitule1: 'NORVEGE';
          Nom: 'OSLO';
          Latitude: 59.56;
          Longitude: 10.45),
         (Intitule1: 'BELGIQUE';
          Nom: 'OOSTENDE';
          Latitude: 51.14;
          Longitude: 2.55),
         (Intitule1: 'POLOGNE';
          Nom: 'POZNAN';
          Latitude: 52.25;
          Longitude: 16.53),
         (Intitule1: 'ITALIE';
          Nom: 'ROMA';
          Latitude: 41.53;
          Longitude: 12.30),
         (Intitule1: 'BELGIQUE';
          Nom: 'SPA';
          Latitude: 50.30;
          Longitude:  5.51),
         (Intitule1: 'SUEDE';
          Nom: 'STOCKHOLM';
          Latitude: 59.20;
          Longitude:  18.05),
         (Intitule1: 'BELGIQUE';
          Nom: 'TOURNAI';
          Latitude: 50.36;
          Longitude:  3.23),
         (Intitule1: 'BELGIQUE';
          Nom: 'VIRTON';
          Latitude: 49.34;
          Longitude:  5.31),
         (Intitule1: 'SUISSE';
          Nom: 'ZURICH';
          Latitude: 47.23;
          Longitude:  8.32),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0)
        )
       ),
 (Nom: 'ETATS-UNIS';
       Intitules: ('Etats', 'Villes');
       nVilles: 20;
       Villes:
        ((Intitule1: 'MASSACHUSETTS';
          Nom: 'BOSTON';
          Latitude: 42.20;
          Longitude: 288.55),
         (Intitule1: 'ILLINOIS';
          Nom: 'CHICAGO';
          Latitude: 41.50;
          Longitude: 272.15),
         (Intitule1: 'OHIO';
          Nom: 'CINCINNATI';
          Latitude: 39.10;
          Longitude: 275.30),
         (Intitule1: 'OHIO';
          Nom: 'CLEVELAND';
          Latitude: 41.30;
          Longitude: 278.19),
         (Intitule1: 'TEXAS';
          Nom: 'DALLAS';
          Latitude: 32.47;
          Longitude: 263.12),
         (Intitule1: 'COLORADO';
          Nom: 'DENVER';
          Latitude: 39.45;
          Longitude: 255.00),
         (Intitule1: 'MICHIGAN';
          Nom: 'DETROIT';
          Latitude: 42.23;
          Longitude: 276.55),
         (Intitule1: 'HAWAII';
          Nom: 'HONOLULU';
          Latitude: 21.19;
          Longitude: 202.10),
         (Intitule1: 'TEXAS';
          Nom: 'HOUSTON';
          Latitude: 29.45;
          Longitude: 264.35),
         (Intitule1: 'INDIANA';
          Nom: 'INDIANAPOLIS';
          Latitude: 39.45;
          Longitude: 273.50),
         (Intitule1: 'KANSAS';
          Nom: 'KANSAS CITY';
          Latitude: 39.05;
          Longitude: 265.23),
         (Intitule1: 'CALIFORNIE';
          Nom: 'LOS ANGELES';
          Latitude: 34.00;
          Longitude: 241.45),
         (Intitule1: 'TENNESSEE';
          Nom: 'MEMPHIS';
          Latitude: 35.10;
          Longitude: 270.00),
         (Intitule1: 'FLORIDE';
          Nom: 'MIAMI';
          Latitude: 25.45;
          Longitude: 279.45),
         (Intitule1: 'LOUISIANE';
          Nom: 'NEW ORLEANS';
          Latitude: 30.00;
          Longitude: 269.57),
         (Intitule1: 'NEW YORK';
          Nom: 'NEW YORK';
          Latitude: 40.40;
          Longitude: 286.10),
         (Intitule1: 'PENSYLVANIE';
          Nom: 'PHILADELPHIA';
          Latitude: 40.00;
          Longitude: 284.50),
         (Intitule1: 'PENSYLVANIE';
          Nom: 'PITTSBURGH';
          Latitude: 40.26;
          Longitude: 280.00),
         (Intitule1: 'CALIFORNIE';
          Nom: 'SAN FRANCISCO';
          Latitude: 37.45;
          Longitude: 237.33),
         (Intitule1: 'DISTRICT de COLOMBIA';
          Nom: 'WASHINGTON';
          Latitude: 38.55;
          Longitude: 283.00),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0)
        )
       ),
 (Nom: 'CANADA';
       Intitules: ('Provinces', 'Villes');
       nVilles: 11;
       Villes:
        ((Intitule1: 'ALBERTA';
          Nom: 'CALGARY';
          Latitude: 51.05;
          Longitude: 245.55),
         (Intitule1: 'ALBERTA';
          Nom: 'EDMONTON';
          Latitude: 53.34;
          Longitude: 246.35),
         (Intitule1: 'ONTARIO';
          Nom: 'HAMILTON';
          Latitude: 43.15;
          Longitude: 280.10),
         (Intitule1: 'ONTARIO';
          Nom: 'KITCHENER';
          Latitude: 43.27;
          Longitude: 279.30),
         (Intitule1: 'QUEBEC';
          Nom: 'MONTREAL';
          Latitude: 45.30;
          Longitude: 286.24),
         (Intitule1: 'ONTARIO';
          Nom: 'OTTAWA';
          Latitude: 45.25;
          Longitude: 284.17),
         (Intitule1: 'QUEBEC';
          Nom: 'QUEBEC';
          Latitude: 46.50;
          Longitude: 288.45),
         (Intitule1: 'ONTARIO';
          Nom: 'SAINT CATHARINES';
          Latitude: 45.24;
          Longitude: 286.26),
         (Intitule1: 'ONTARIO';
          Nom: 'TORONTO';
          Latitude: 43.42;
          Longitude: 280.35),
         (Intitule1: 'COLOMBIE BRITANNIQUE';
          Nom: 'VANCOUVER';
          Latitude: 49.17;
          Longitude: 237.00),
         (Intitule1: 'MANITOBA';
          Nom: 'WINNIPEG';
          Latitude: 49.53;
          Longitude: 262.50),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0)
        )
       ),
 (Nom: 'AMERIQUE DU SUD';
       Intitules: ('Pays', 'Villes');
       nVilles: 4;
       Villes:
        ((Intitule1: 'PEROU';
          Nom: 'LIMA';
          Latitude: -12.06;
          Longitude: 282.57),
         (Intitule1: 'MEXIQUE';
          Nom: 'MEXICO';
          Latitude: 19.25;
          Longitude: 260.50),
         (Intitule1: 'BRESIL';
          Nom: 'RIO DE JANEIRO';
          Latitude: -22.53;
          Longitude: 316.43),
         (Intitule1: 'CHILI';
          Nom: 'SANTIAGO DE CHILI';
          Latitude: -33.30;
          Longitude: 289.20),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0)
        )
       ),
 (Nom: 'AFRIQUE';
       Intitules: ('Pays', 'Villes');
       nVilles: 18;
       Villes:
        ((Intitule1: 'AFRIQUE DU SUD';
          Nom: 'CAPE TOWN';
          Latitude: -33.56;
          Longitude: 18.28),
         (Intitule1: 'ALGERIE';
          Nom: 'ALGER';
          Latitude: 36.50;
          Longitude: 3.00),
         (Intitule1: 'BENIN';
          Nom: 'PORTO-NOVO';
          Latitude: 6.29;
          Longitude: 2.37),
         (Intitule1: 'BURKINA FASO';
          Nom: 'OUAGADOUGOU';
          Latitude: 12.22;
          Longitude: 358.29),
         (Intitule1: 'CAMEROUN';
          Nom: 'YAOUNDE';
          Latitude: 3.52;
          Longitude: 11.31),
         (Intitule1: 'CONGO';
          Nom: 'BRAZZAVILLE';
          Latitude: 4.15;
          Longitude: 15.17),
         (Intitule1: 'COTE D''IVOIRE';
          Nom: 'YAMOUSSOUKRO';
          Latitude: 6.49;
          Longitude: 354.43),
         (Intitule1: 'ABON';
          Nom: 'LIBREVILLE';
          Latitude: 0.23;
          Longitude: 9.27),
         (Intitule1: 'GUINEE-BISSAU';
          Nom: 'BISSAU';
          Latitude: 11.52;
          Longitude: 344.21),
         (Intitule1: 'GUINEE EQUATORIALE';
          Nom: 'MALABO';
          Latitude: 3.45;
          Longitude: 8.48),
         (Intitule1: 'MADAGASCAR';
          Nom: 'MADAGASCAR';
          Latitude: -20.00;
          Longitude: 45.00),
         (Intitule1: 'MALI';
          Nom: 'BAMAKO';
          Latitude: 12.39;
          Longitude: 352.00),
         (Intitule1: 'NIGER';
          Nom: 'NIAMEY';
          Latitude: 13.31;
          Longitude: 2.07),
         (Intitule1: 'REPUBLIQUE CENTRAFRICAINE';
          Nom: 'BANGUI';
          Latitude: 4.22;
          Longitude: 18.35),
         (Intitule1: 'SENEGAL';
          Nom: 'DAKAR';
          Latitude: 14.38;
          Longitude: 342.33),
         (Intitule1: 'TCHAD';
          Nom: 'N''DJAMENA';
          Latitude: 12.07;
          Longitude: 15.03),
         (Intitule1: 'TOGO';
          Nom: 'LOME';
          Latitude: 6.07;
          Longitude: 1.13),
         (Intitule1: 'ZAIRE';
          Nom: 'KINSHASA';
          Latitude: -4.18;
          Longitude: 15.47),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0)
        )
       ),
 (Nom: 'OCEANIE';
       Intitules: ('Pays', 'Villes');
       nVilles: 1;
       Villes:
        ((Intitule1: 'AUSTRALIE';
          Nom: 'SYDNEY';
          Latitude: -33.55;
          Longitude: 151.10),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0)
        )
       ),
 (Nom: 'ASIE';
       Intitules: ('Pays', 'Villes');
       nVilles: 1;
       Villes:
        ((Intitule1: 'JAPON';
          Nom: 'TOKYO';
          Latitude: 35.40;
          Longitude: 139.45),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0),
         (Intitule1: ''; Nom: ''; Latitude: 0; Longitude: 0)
        )
       )
 );

implementation

end.
