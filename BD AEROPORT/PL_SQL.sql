/* Crearea tabelului MESAJE */

DROP TABLE mesaje_am CASCADE CONSTRAINTS;

CREATE TABLE MESAJE_AM (
			message_id NUMBER PRIMARY KEY,
			message VARCHAR2(255),
			message_type VARCHAR2(1),
			created_by VARCHAR2(40) NOT NULL,
			created_at DATE NOT NULL
			);
			
			
/* Secventa (1) pentru a genera cheia primara in tabelul MESAJE */ 

CREATE SEQUENCE mesaje_seq_am
START WITH 1
INCREMENT BY 1;

/* Creare (2) secventa pentru AVIOANE_AM*/
CREATE SEQUENCE avioane_seq
minvalue 1
maxvalue 20
START WITH 1
INCREMENT BY 1
cache 30;


/* Vedere (1) a ECHIPAJELOR cu ore experienta >= 2000  */

CREATE OR REPLACE 
VIEW vedere_echipaje AS
SELECT id_echipaj, experienta
FROM echipaje_am
WHERE experienta >= 2000;

SELECT * FROM vedere_echipaje;

/* Vedere (2) a REZERVARILOR cu pretul > 200 */

CREATE OR REPLACE 
VIEW vedere_rezervari AS
SELECT id_rezervare, pret
FROM rezervari_am
WHERE pret > 200;

SELECT * FROM vedere_rezervari;

/* Trigger (1) pentru a modifica pretul unei rezervari */

SET SERVEROUTPUT ON;
CREATE OR REPLACE
TRIGGER modif_pret
BEFORE UPDATE OF pret
ON rezervari_am
FOR EACH ROW
BEGIN
	INSERT INTO rezervari_am_vechi
	VALUES(
		:old.id_rezervare,
		:old.data_rezervare,
		:old.pret,
		:old.data_expirare,
		:old.mentiuni);
END;
/

UPDATE rezervari_am
SET pret = 210
WHERE id_rezervare = 'RE602';

SET SERVEROUTPUT OFF;

/* Cursor (1) pentru echipajele cu mai mult de 3 membri */

DECLARE
CURSOR c_ech RETURN echipaje_am%ROWTYPE IS
	SELECT *
	FROM echipaje_am
	WHERE numar_membri > 3;

BEGIN
	FOR v_cursor IN c_ech 
	LOOP
		DBMS_OUTPUT.PUT_LINE('Echipajul ' || v_cursor.id_echipaj || ' are ' || v_cursor.numar_membri || ' membri.' );
	END LOOP;
END;
/


/* Cursor (2) pentru rezervarile cu pret < 250 */

DECLARE
CURSOR c RETURN rezervari_am%ROWTYPE IS	
	SELECT *
	FROM rezervari_am
	WHERE pret < 250;
	
BEGIN
	FOR i IN c LOOP
		DBMS_OUTPUT.PUT_LINE('Rezervarea ' || i.id_rezervare || ' are pretul ' || i.pret || ' EUR.');
	END LOOP;
END;
/

/* Functie (1) care pentru un anumit avion (id_avion) afiseaza suma locurilor. */

CREATE OR REPLACE 
FUNCTION suma_locuri(v_id avioane_am.id_avion%type)
RETURN NUMBER
IS suma NUMBER(4);

BEGIN
	SELECT (nr_locuri_clasa1 + nr_locuri_clasa2 + nr_locuri_clasaeco)
	INTO suma
	FROM numar_locuri_am 
	WHERE v_id = id_avion;
	RETURN suma;
	EXCEPTION
		WHEN NO_DATA_FOUND THEN	
			INSERT INTO mesaje_am
			VALUES (mesaje_seq_am.NEXTVAL, 'Nu exista niciun avion cu acest ID', 'E', 'Alex', SYSDATE);
END suma_locuri;

SELECT suma_locuri('AV1')
FROM DUAL;


/* Functie (2) care returneaza numarul zborurilor cu escala/fara escala */

CREATE OR REPLACE
FUNCTION zboruri(v_tip zboruri_am.tip_zbor%TYPE)
RETURN NUMBER
IS v_zboruri NUMBER(2);

BEGIN
	SELECT COUNT(id_zbor)
	INTO v_zboruri
	FROM zboruri_am
	WHERE tip_zbor = v_tip;
	RETURN v_zboruri;
	
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			INSERT INTO mesaje_am
			VALUES (mesaje_seq_am.NEXTVAL, 'Nu exista niciun zbor dupa aceasta data', 'E', 'Alex', SYSDATE);
END zboruri;

SELECT zboruri('CU ESCALA') FROM DUAL;


/* Procedura (1) care mareste cu o valoare data ca parametru pretul rezervarilor cu un anumit cod. */

CREATE OR REPLACE
PROCEDURE marire_pret(id_rez VARCHAR2, marire NUMBER)
IS pret_curent NUMBER;
	lipsa_rezervare EXCEPTION;
	BEGIN
		SELECT pret
		INTO pret_curent
		FROM rezervari_am
		WHERE id_rez = id_rezervare;
		IF id_rez NOT LIKE 'R%' THEN
			RAISE lipsa_rezervare;
		ELSE UPDATE rezervari_am SET pret = pret + marire
			WHERE id_rez = id_rezervare;
		END IF;
		
		EXCEPTION
		WHEN lipsa_rezervare THEN
			INSERT INTO mesaje_am
			VALUES (mesaje_seq_am.NEXTVAL, 'Nu exista rezervarea specificata', 'E', 'Alex', SYSDATE);
	END marire_pret;
	
EXECUTE marire_pret('RO355', 10);


/* Procedura (2) care primeste ca parametru pretul unui bilet si il mareste cu 20% daca valoarea acestuia este <100 si cu 10% daca pretul >=100 */

CREATE OR REPLACE
PROCEDURE marire(p_pret IN OUT NUMBER)
IS 
BEGIN
	IF p_pret < 100 THEN p_pret := 1.2*p_pret;
		ELSIF p_pret >=100 THEN p_pret:=1.1*p_pret;
	END IF;
END;

DECLARE
v_pret rezervari_am.pret%TYPE := &p_pret;

BEGIN
  DBMS_OUTPUT.PUT_LINE('Pretul initial este ' || v_pret);
  marire(v_pret);
  DBMS_OUTPUT.PUT_LINE('Pretul marit este ' || v_pret);  
END;
/


/* Pachet (1) care permite prin intermediul a doua functii calculul numarului de clienti ce detin bilete cu pret > 200 si calculul sumei biletelor acestora */

CREATE OR REPLACE PACKAGE pachet_bilete AS
	FUNCTION f_numar(v_pret rezervari_am.pret%TYPE)
		RETURN NUMBER;
	FUNCTION f_suma(v_pret rezervari_am.pret%TYPE)
		RETURN NUMBER;
END pachet_bilete;
/

CREATE OR REPLACE PACKAGE BODY pachet_bilete AS
	FUNCTION f_numar(v_pret rezervari_am.pret%TYPE)
		RETURN NUMBER IS numar NUMBER;
	BEGIN
		SELECT COUNT(*) INTO numar
		FROM rezervari_am
		WHERE pret > v_pret;
	RETURN numar;
	END f_numar;
	
	FUNCTION f_suma(v_pret rezervari_am.pret%TYPE)
		RETURN NUMBER IS suma NUMBER;
	BEGIN
		SELECT SUM(pret)
		INTO suma
		FROM rezervari_am
		WHERE pret > v_pret;
	RETURN suma;
	END f_suma;
END pachet_bilete;
/

BEGIN
	DBMS_OUTPUT.PUT_LINE('Numarul de clienti este ' || pachet_bilete.f_numar(200));
	DBMS_OUTPUT.PUT_LINE('Suma preturilor biletelor este ' || pachet_bilete.f_suma(200));
END;
/


/* Pachet (2) cu ajutorul caruia sa se obtina pretul maxim inregistrat pentru clientii dintr-un anumit oras si lista clientilor care au cumparat bilete cu preturi mai mari sau egale decat acel maxim. */

CREATE OR REPLACE
PACKAGE pachet_preturi AS
	CURSOR c_pret(nr NUMBER) RETURN clienti_am%ROWTYPE;
	FUNCTION f_max (v_oras clienti_am.adresa%TYPE) RETURN NUMBER;
END pachet_preturi;
/

CREATE OR REPLACE PACKAGE BODY pachet_preturi AS

CURSOR c_pret(nr NUMBER) RETURN clienti_am%ROWTYPE
	IS
	SELECT c.id_client, c.nume_client, c.prenume_client, c.data_nasterii, c.numar_telefon, c.adresa
	FROM rezervari_am r, bilete_am b, clienti_am c 
	WHERE r.pret >= nr
	AND c.id_client = b.id_client
	AND b.id_rezervare = r.id_rezervare;
	
FUNCTION f_max (v_oras clienti_am.adresa%TYPE) RETURN NUMBER IS
	maxim NUMBER;
BEGIN
	SELECT MAX(pret)
	INTO maxim
	FROM rezervari_am r, bilete_am b, clienti_am c 
	WHERE UPPER(c.adresa) = UPPER(v_oras)
	AND c.id_client = b.id_client
	AND b.id_rezervare = r.id_rezervare;
	RETURN maxim;
END f_max;
END pachet_preturi;
/

DECLARE
	oras 	clienti_am.adresa%TYPE := 'Timisoara';
	val_max NUMBER;
	lista	clienti_am%ROWTYPE;

BEGIN
	val_max := pachet_preturi.f_max(oras);
	FOR v_cursor IN pachet_preturi.c_pret(val_max) LOOP
		DBMS_OUTPUT.PUT_LINE(v_cursor.nume_client || ' ' || v_cursor.prenume_client);
	END LOOP;
END;
/
		
	

