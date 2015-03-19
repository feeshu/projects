DROP TABLE companii_am CASCADE CONSTRAINTS;
DROP TABLE echipaje_am CASCADE CONSTRAINTS;
DROP TABLE avioane_am CASCADE CONSTRAINTS;
DROP TABLE clase_am CASCADE CONSTRAINTS;
DROP TABLE locuri_am CASCADE CONSTRAINTS;
DROP TABLE rezervari_am CASCADE CONSTRAINTS;
DROP TABLE bilete_am CASCADE CONSTRAINTS;
DROP TABLE numar_locuri_am CASCADE CONSTRAINTS;
DROP TABLE clienti_am CASCADE CONSTRAINTS;
DROP TABLE zboruri_am CASCADE CONSTRAINTS;
DROP TABLE rute_am CASCADE CONSTRAINTS;


CREATE TABLE COMPANII_AM(
			id_companie VARCHAR2(5) PRIMARY KEY,
			denumire_companie VARCHAR2(15) NOT NULL,
			numar_telefon NUMBER(10) NOT NULL,
			e_mail VARCHAR2(30) UNIQUE,
			oras_sediu VARCHAR2(15) NOT NULL
			);
			

CREATE TABLE AVIOANE_AM(
			id_avion VARCHAR2(5) PRIMARY KEY,
			id_companie VARCHAR2(5) REFERENCES companii_am(id_companie),
			denumire_avion VARCHAR2(15) NOT NULL			
			);
			
CREATE TABLE ECHIPAJE_AM(
			id_echipaj VARCHAR2(5) PRIMARY KEY,
			id_avion VARCHAR2(5) REFERENCES avioane_am(id_avion),
			numar_membri NUMBER(2) NOT NULL,
			experienta NUMBER(5)
			);			
			
CREATE TABLE CLASE_AM(
			id_clasa VARCHAR2(5) PRIMARY KEY,
			id_avion VARCHAR2(5) REFERENCES avioane_am(id_avion),
			denumire_clasa VARCHAR2(30) NOT NULL,
			servicii VARCHAR2(100)
			);
			
CREATE TABLE LOCURI_AM(
			id_loc VARCHAR2(5) PRIMARY KEY,
			id_avion VARCHAR2(5) REFERENCES avioane_am(id_avion),
			nume_loc VARCHAR2(5) NOT NULL,
			tip_loc VARCHAR2(10) NOT NULL
			);
			
CREATE TABLE REZERVARI_AM(
			id_rezervare VARCHAR2(5) PRIMARY KEY,
			data_rezervare DATE NOT NULL,
			pret NUMBER(5) NOT NULL,
			data_expirare DATE NOT NULL,
			mentiuni VARCHAR2(40),
			CONSTRAINT interval_date CHECK (data_expirare > data_rezervare)
			);
			


CREATE TABLE NUMAR_LOCURI_AM(
			id_numar_loc VARCHAR2(5) PRIMARY KEY,
			id_avion VARCHAR2(5) REFERENCES avioane_am(id_avion),
			nr_locuri_clasa1 NUMBER(3) NOT NULL,
			nr_locuri_clasa2 NUMBER(3) NOT NULL,
			nr_locuri_clasaeco NUMBER(3) NOT NULL
			);
			
CREATE TABLE CLIENTI_AM(
			id_client VARCHAR2(5) PRIMARY KEY,
			nume_client VARCHAR2(15) NOT NULL,
			prenume_client VARCHAR2(15) NOT NULL,
			data_nasterii DATE NOT NULL,
			numar_telefon NUMBER(10),
			adresa VARCHAR2(40)
			);
			
CREATE TABLE ZBORURI_AM(
			id_zbor VARCHAR2(5) PRIMARY KEY,
			id_avion VARCHAR2(5) REFERENCES avioane_am(id_avion),
			denumire_zbor VARCHAR2(15) NOT NULL,
			tip_zbor VARCHAR2(15) NOT NULL,
			data_plecare DATE NOT NULL,
			data_sosire DATE NOT NULL,
			CONSTRAINT chk_tip CHECK (tip_zbor='CU ESCALA' OR tip_zbor='FARA ESCALA'),
			CONSTRAINT chk_date CHECK (data_sosire >= data_plecare)
			);
			
CREATE TABLE RUTE_AM(
			id_ruta VARCHAR2(5) PRIMARY KEY,
			id_zbor VARCHAR2(5) REFERENCES zboruri_am(id_zbor),
			denumire_ruta VARCHAR2(20) NOT NULL
			);
			
CREATE TABLE BILETE_AM(
			id_bilet VARCHAR2(5) PRIMARY KEY,
			id_clasa VARCHAR2(5) REFERENCES clase_am(id_clasa),
			id_rezervare VARCHAR2(5) REFERENCES rezervari_am(id_rezervare),
			id_loc VARCHAR2(5) REFERENCES locuri_am(id_loc),
			id_client VARCHAR2(5) REFERENCES clienti_am(id_client),
			mentiuni_bilet VARCHAR2(40)
			);
			


/* Inserarea datelor in tabelul COMPANII_AM */

INSERT INTO COMPANII_AM VALUES ('TAR1', 'TAROM', '555436223', 'OFFICE@TAROM.RO', 'BUCURESTI');
INSERT INTO COMPANII_AM VALUES ('LUFTH', 'LUFTHANSA', '221234876', 'OFFICE@LUFTHANSA.COM', 'BERLIN');
INSERT INTO COMPANII_AM VALUES ('ALIT', 'ALITALIA', '655789653', 'OFFICE@ALITALIA.IT', 'ROMA');
INSERT INTO COMPANII_AM VALUES ('IBE', 'IBERIA', '222611998', 'OFFICE@IBERIA.COM', 'MADRID');
INSERT INTO COMPANII_AM VALUES ('TURK', 'TURKISHAIRLINES', '999000123', 'OFFICE@TURKISH.COM', 'ISTANBUL');
INSERT INTO COMPANII_AM VALUES ('BLUE', 'BLUE AIR', '485616472', 'OFFICE@BLUEAIR.RO', 'BUCURESTI');
INSERT INTO COMPANII_AM VALUES ('QAT', 'QATAR AIRWAYS', '8887413654', 'OFFICE@QATARAIR.COM', 'QATAR');
INSERT INTO COMPANII_AM VALUES ('ASIA', 'AIRASIA', '4871364589', 'OFFICE@AIRASIA.CN', 'SINGAPORE');
INSERT INTO COMPANII_AM VALUES ('BRIT', 'BRITISH AIRWAYS', '4581246657', 'OFFICE@BRITISHAIR.COM', 'LONDRA');
INSERT INTO COMPANII_AM VALUES ('USA', 'US AIRWAYS', '1145786328', 'OFFICE@USAIRLINES.COM', 'PHOENIX');

/* Inserarea datelor in tabelul AVIOANE_AM */

INSERT INTO AVIOANE_AM VALUES ('AV1', 'TAR1', 'AIRBUS A380');
INSERT INTO AVIOANE_AM VALUES ('AV2', 'LUFTH', 'AIRBUS A380');
INSERT INTO AVIOANE_AM VALUES ('AV3', 'LUFTH', 'BOEING 747');
INSERT INTO AVIOANE_AM VALUES ('AV4', 'ALIT', 'BOEING 747');
INSERT INTO AVIOANE_AM VALUES ('AV5', 'TURK', 'AIRBUS A300');
INSERT INTO AVIOANE_AM VALUES ('AV6', 'BLUE', 'EMBRAER ERJ-195');
INSERT INTO AVIOANE_AM VALUES ('AV7', 'ASIA', 'BOMBARDIER CR90');
INSERT INTO AVIOANE_AM VALUES ('AV8', 'USA', 'BOEING 737-800');
INSERT INTO AVIOANE_AM VALUES ('AV9', 'ALIT', 'AIRBUS A321');
INSERT INTO AVIOANE_AM VALUES ('AV10', 'QAT', 'AIRBUS A319');

/* Inserarea datelor in tabelul NUMAR_LOCURI_AM */

INSERT INTO NUMAR_LOCURI_AM VALUES ('NR1', 'AV1', 75, 75, 50);
INSERT INTO NUMAR_LOCURI_AM VALUES ('NR2', 'AV2', 100, 100, 100);
INSERT INTO NUMAR_LOCURI_AM VALUES ('NR3', 'AV3', 50, 50, 30);
INSERT INTO NUMAR_LOCURI_AM VALUES ('NR4', 'AV4', 150, 75, 50);
INSERT INTO NUMAR_LOCURI_AM VALUES ('NR5', 'AV5', 70, 70, 70);
INSERT INTO NUMAR_LOCURI_AM VALUES ('NR6', 'AV6', 115, 80, 70);
INSERT INTO NUMAR_LOCURI_AM VALUES ('NR7', 'AV7', 90, 100, 50);
INSERT INTO NUMAR_LOCURI_AM VALUES ('NR8', 'AV8', 150, 50, 30);
INSERT INTO NUMAR_LOCURI_AM VALUES ('NR9', 'AV9', 140, 75, 60);
INSERT INTO NUMAR_LOCURI_AM VALUES ('NR10', 'AV10', 80, 70, 70);

/* Inserarea datelor in tabelul ECHIPAJE_AM */

INSERT INTO ECHIPAJE_AM VALUES('ECH1', 'AV1', 4, 3000);
INSERT INTO ECHIPAJE_AM VALUES('ECH2', 'AV2', 5, 2700);
INSERT INTO ECHIPAJE_AM VALUES('ECH3', 'AV3', 4, 1500);
INSERT INTO ECHIPAJE_AM VALUES('ECH4', 'AV4', 3, 1000);
INSERT INTO ECHIPAJE_AM VALUES('ECH5', 'AV5', 5, 2100);
INSERT INTO ECHIPAJE_AM VALUES('ECH6', 'AV6', 3, 1350);
INSERT INTO ECHIPAJE_AM VALUES('ECH7', 'AV7', 4, 800);
INSERT INTO ECHIPAJE_AM VALUES('ECH8', 'AV8', 5, 2300);
INSERT INTO ECHIPAJE_AM VALUES('ECH9', 'AV9', 3, 1300);
INSERT INTO ECHIPAJE_AM VALUES('ECH10', 'AV10', 3, 2000);

/* Inserarea datelor in tabelul ZBORURI_AM */

INSERT INTO ZBORURI_AM VALUES('RO100', 'AV1', 'BUCMSK', 'FARA ESCALA', '02-JUN-2015', '02-JUN-2015');
INSERT INTO ZBORURI_AM VALUES('RO702', 'AV4', 'BUCBER', 'CU ESCALA', '05-JUL-2015', '06-JUL-2015');
INSERT INTO ZBORURI_AM VALUES('RO350', 'AV2', 'BUCMUN', 'CU ESCALA', '10-AUG-2015', '10-AUG-2015');
INSERT INTO ZBORURI_AM VALUES('RO176', 'AV3', 'BUCPRA', 'FARA ESCALA', '06-JUN-2015', '06-JUN-2015');
INSERT INTO ZBORURI_AM VALUES('RO55', 'AV5', 'BUCHEL', 'CU ESCALA', '10-OCT-2015', '13-OCT-2015');
INSERT INTO ZBORURI_AM VALUES('RO222', 'AV10', 'BUCQAT', 'CU ESCALA', '20-MAR-2015', '21-MAR-2015');
INSERT INTO ZBORURI_AM VALUES('RO780', 'AV6', 'BUCPAR', 'FARA ESCALA', '19-FEB-2015', '19-FEB-2015');
INSERT INTO ZBORURI_AM VALUES('RO412', 'AV9', 'BUCMIL', 'FARA ESCALA', '26-JAN-2015', '26-JAN-2015');
INSERT INTO ZBORURI_AM VALUES('RO974', 'AV8', 'BUCMIA', 'CU ESCALA', '10-APR-2015', '11-APR-2015');
INSERT INTO ZBORURI_AM VALUES('RO324', 'AV7', 'BUCTOK', 'CU ESCALA', '20-DEC-2015', '21-DEC-2015');

/* Inserarea datelor in tabelul RUTE_AM */

INSERT INTO RUTE_AM VALUES('R1', 'RO100', 'BUCURESTI-MOSCOVA');
INSERT INTO RUTE_AM VALUES('R2', 'RO702', 'BUCURESTI-BERLIN');
INSERT INTO RUTE_AM VALUES('R3', 'RO350', 'BUCURESTI-MUNCHEN');
INSERT INTO RUTE_AM VALUES('R4', 'RO176', 'BUCURESTI-PRAGA');
INSERT INTO RUTE_AM VALUES('R5', 'RO55', 'BUCURESTI-HELSINKI');
INSERT INTO RUTE_AM VALUES('R6', 'RO222', 'BUCURESTI-QATAR');
INSERT INTO RUTE_AM VALUES('R7', 'RO780', 'BUCURESTI-PARIS');
INSERT INTO RUTE_AM VALUES('R8', 'RO412', 'BUCURESTI-MILANO');
INSERT INTO RUTE_AM VALUES('R9', 'RO974', 'BUCURESTI-MIAMI');
INSERT INTO RUTE_AM VALUES('R10', 'RO324', 'BUCURESTI-TOKYO');

/* Inserarea datelor in tabelul CLASE_AM */

INSERT INTO CLASE_AM VALUES('CL101', 'AV1', 'CLASA 1', 'CATERING, TV, MINIBAR');
INSERT INTO CLASE_AM VALUES('CL102', 'AV1', 'CLASA 2', 'CATERING, MINIBAR');
INSERT INTO CLASE_AM VALUES('CL10E', 'AV3', 'CLASA ECONOMIC', 'CATERING');
INSERT INTO CLASE_AM VALUES('CL111', 'AV2', 'CLASA 1 VIP', 'CATERING, TV, MINIBAR, MASAJ');
INSERT INTO CLASE_AM VALUES('CL112', 'AV4', 'CLASA 2 VIP', 'TV, MINIBAR, CATERING');
INSERT INTO CLASE_AM VALUES('CL11X', 'AV9', 'CLASA 1 EXTRA', 'CATERING, TV, MINIBAR, WI-FI');
INSERT INTO CLASE_AM VALUES('CL00B', 'AV10', 'CLASA BUSSINESS', 'WI-FI, TV, CATERING');
INSERT INTO CLASE_AM VALUES('CL00F', 'AV7', 'CLASA FIDEL', 'CATERING, WI-FI, MINIBAR');
INSERT INTO CLASE_AM VALUES('CL11E', 'AV2', 'CLASA ECONOMIC+', 'CATERING, TV');
INSERT INTO CLASE_AM VALUES('CL12E', 'AV6', 'CLASA ECONOMIC FIDEL', 'TV, CATERING, WI-FI');

/* Inserarea datelor in tabelul LOCURI_AM */

INSERT INTO LOCURI_AM VALUES('LA01', 'AV1', 'A01', 'STANDARD');
INSERT INTO LOCURI_AM VALUES('LB12', 'AV2', 'B12', 'VIP');
INSERT INTO LOCURI_AM VALUES('LE23', 'AV3', 'E23', 'STANDARD');
INSERT INTO LOCURI_AM VALUES('LC10', 'AV3', 'C10', 'STANDARD');
INSERT INTO LOCURI_AM VALUES('LD20', 'AV1', 'D20', 'VIP');
INSERT INTO LOCURI_AM VALUES('LC15', 'AV5', 'C15', 'VIP');
INSERT INTO LOCURI_AM VALUES('LH10', 'AV7', 'H10', 'STANDARD');
INSERT INTO LOCURI_AM VALUES('LI09', 'AV10', 'I09', 'STANDARD');
INSERT INTO LOCURI_AM VALUES('LA20', 'AV7', 'A20', 'VIP');
INSERT INTO LOCURI_AM VALUES('LE06', 'AV8', 'E06', 'STANDARD');

/* Inserarea datelor in tabelul CLIENTI_AM */

INSERT INTO CLIENTI_AM VALUES('C01', 'MARIN', 'ALEXANDRU', '21-MAR-1994', '487512356', 'OTOPENI');
INSERT INTO CLIENTI_AM VALUES('C02', 'STEFAN', 'COSMIN', '19-OCT-1985', '784561238', 'BUCURESTI');
INSERT INTO CLIENTI_AM VALUES('C03', 'CRACIUN', 'ALIN', '21-JUN-1990', '789456325', 'TIMISOARA');
INSERT INTO CLIENTI_AM VALUES('C04', 'IACOB', 'ANDREEA', '25-AUG-1970', '2345673333', 'ORADEA');
INSERT INTO CLIENTI_AM VALUES('C05', 'MORAR', 'CLAUDIU', '10-JAN-1979', '223156643', 'TIMISOARA');
INSERT INTO CLIENTI_AM VALUES('C06', 'MAXIM', 'MIHAELA', '25-SEP-1968', '2364128794', 'CLUJ-NAPOCA');
INSERT INTO CLIENTI_AM VALUES('C07', 'CHIRITA', 'CONSTANTIN', '02-AUG-1982', '1256473298', 'ALBA IULIA');
INSERT INTO CLIENTI_AM VALUES('C08', 'DOBRE', 'GEORGE', '06-FEB-1992', '8842365147', 'BRASOV');
INSERT INTO CLIENTI_AM VALUES('C09', 'DINITA', 'CLAUDIA', '13-DEC-1978', '7741365487', 'ALEXANDRIA');
INSERT INTO CLIENTI_AM VALUES('C10', 'DUMITRU', 'ALEXANDRA', '15-APR-1995', '133457841', 'PLOIESTI');

/* Inserarea datelor in tabelul REZERVARI_AM */

INSERT INTO REZERVARI_AM VALUES('RE100', '20-DEC-2014', 150, '30-MAY-2015', '-');
INSERT INTO REZERVARI_AM VALUES('RE231', '10-OCT-2014', 230, '20-JUN-2015', '1 BILET GRATUIT');
INSERT INTO REZERVARI_AM VALUES('RE210', '23-DEC-2014', 170, '21-JUL-2015', 'DUS-INTORS');
INSERT INTO REZERVARI_AM VALUES('RE300', '25-SEP-2014', 300, '30-MAY-2015', 'ESCALA LA PARIS');
INSERT INTO REZERVARI_AM VALUES('RE301', '26-NOV-2014', 350, '01-JUN-2015', '-');
INSERT INTO REZERVARI_AM VALUES('RE602', '05-DEC-2014', 220, '05-JUN-2015', 'CAZARE HOTEL INCLUSA');
INSERT INTO REZERVARI_AM VALUES('RE771', '10-DEC-2014', 230, '23-SEP-2015', 'ESCALA LA ROMA');
INSERT INTO REZERVARI_AM VALUES('RE355', '23-OCT-2014', 400, '18-APR-2015', '-');
INSERT INTO REZERVARI_AM VALUES('RE912', '25-NOV-2014', 110, '28-AUG-2015', 'ESCALA LA BERLIN');
INSERT INTO REZERVARI_AM VALUES('RE410', '26-DEC-2014', 290, '15-FEB-2015', '-');

/* Inserarea datelor in tabelul BILETE_AM */

INSERT INTO BILETE_AM VALUES('B1095', 'CL101', 'RE100', 'LE23', 'C01', '-');
INSERT INTO BILETE_AM VALUES('B2022', 'CL101', 'RE231', 'LA01', 'C03', '-');
INSERT INTO BILETE_AM VALUES('B1111', 'CL10E', 'RE210', 'LC10', 'C05', 'BAGAJ DE MANA');
INSERT INTO BILETE_AM VALUES('B5400', 'CL111', 'RE300', 'LB12', 'C02', '-');
INSERT INTO BILETE_AM VALUES('B5401', 'CL112', 'RE301', 'LD20', 'C04' , '-');
INSERT INTO BILETE_AM VALUES('B7021', 'CL12E', 'RE602', 'LC15', 'C06', '-');
INSERT INTO BILETE_AM VALUES('B1952', 'CL10E', 'RE771', 'LH10', 'C08', '-');
INSERT INTO BILETE_AM VALUES('B3341', 'CL10E', 'RE355', 'LI09', 'C07', 'BAGAJ DE MANA');
INSERT INTO BILETE_AM VALUES('B9123', 'CL111', 'RE912', 'LA20', 'C10', '-');
INSERT INTO BILETE_AM VALUES('B6302', 'CL102', 'RE410', 'LE06', 'C09' , '-');