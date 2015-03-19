/* 1. Sa se afiseze numarul clientilor nascuti dupa 01-Jan-1980. */

SELECT COUNT(id_client) AS numar_clienti
FROM clienti_am
WHERE data_nasterii > '01-Jan-1980';

/* 2. Sa se afiseze avioanele ce au mai mult de 250 de locuri. */

SELECT a.id_avion, a.denumire_avion, n.nr_locuri_clasa1 + n.nr_locuri_clasa2 + n.nr_locuri_clasaeco as nr_locuri
FROM avioane_am a, numar_locuri_am n
WHERE a.id_avion = n.id_avion
AND n.nr_locuri_clasa1 + n.nr_locuri_clasa2 + n.nr_locuri_clasaeco > 250;

/* 3. Top 3 echipaje cu cei mai multi membri. */

SELECT aux.id_echipaj, aux.numar_membri, aux.experienta
FROM   (SELECT id_echipaj, numar_membri, experienta
		FROM echipaje_am
		ORDER BY numar_membri DESC) aux
WHERE rownum <= 3;

/* 4. Clientul care a rezervat biletul cu pretul cel mai mare. */

SELECT aux.nume_client, aux.prenume_client, aux.pret
FROM (SELECT c.nume_client, c.prenume_client, r.pret
      FROM clienti_am c, rezervari_am r, bilete_am b
      WHERE c.id_client = b.id_client
      AND b.id_rezervare = r.id_rezervare
      ORDER BY r.pret DESC) aux
WHERE rownum = 1;

/* 5. Pentru fiecare client sa se afiseze numele, prenumele si adresa, mentionand daca este adult sau minor.*/

SELECT nume_client, prenume_client, adresa, 
CASE WHEN SYSDATE - data_nasterii < 216 then 'MINOR'
	 ELSE 'ADULT'
	 END AS "VARSTA"
FROM clienti_am;

/* 6. Sa se afiseze, pentru fiecare rezervare, numarul de luni ramase pana la expirarea acesteia si clientul ce ii corespunde. */

SELECT r.id_rezervare, ROUND(MONTHS_BETWEEN(r.data_expirare,SYSDATE)) as NR_LUNI_EXPIRARE, (c.nume_client || ' ' || c.prenume_client) as NUME
FROM rezervari_am r, clienti_am c, bilete_am b 
WHERE r.id_rezervare = b.id_rezervare
AND b.id_client = c.id_client
ORDER BY NR_LUNI_EXPIRARE DESC;

/* 7. Sa se afiseze, pentru fiecare client, locul, tipul locului si ruta pe care zboara. */

SELECT (c.nume_client || ' ' || c.prenume_client) as NUME, l.nume_loc, l.tip_loc, r.denumire_ruta
FROM locuri_am l, rute_am r, clienti_am c, bilete_am b, avioane_am a, zboruri_am z 
WHERE c.id_client = b.id_client
AND b.id_loc = l.id_loc 
AND l.id_avion = a.id_avion
AND a.id_avion = z.id_avion
AND r.id_zbor = z.id_zbor;

/* 8. Sa se afiseze clientii al caror prenume incepe cu litera A si clasa la care calatoresc. */
 
SELECT c.nume_client, c.prenume_client, cl.denumire_clasa
FROM clienti_am c, clase_am cl, bilete_am b
WHERE SUBSTR(prenume_client, 0, 1) = 'A'
AND c.id_client = b.id_client
AND b.id_clasa = cl.id_clasa;

/* 9. Sa se afiseze media locurilor de la clasa 1 din avioanele ce au peste 50 de locuri la clasa economica. */

SELECT AVG(nr_locuri_clasa1) AS "MEDIA LOCURILOR"
FROM numar_locuri_am
WHERE nr_locuri_clasa1 IN (SELECT nr_locuri_clasaeco
							FROM numar_locuri_am
							GROUP BY nr_locuri_clasaeco
							HAVING nr_locuri_clasaeco > 50);
							
/* 10.  Sa se afiseze toate detaliile despre clientul cu ID_CLIENT = C08. */

SELECT * 
FROM clienti_am c, bilete_am b, rezervari_am r
WHERE c.id_client = b.id_client
AND b.id_rezervare = r.id_rezervare
AND c.id_client = 'C05';

/* 11. Sa se afiseze biletul cel mai ieftin rezervat in intervalul noiembrie 2014 - decembrie 2014. */

SELECT b.id_bilet, r.denumire_ruta, rez.pret
FROM locuri_am l, rute_am r, clienti_am c, bilete_am b, avioane_am a, zboruri_am z, rezervari_am rez 
WHERE c.id_client = b.id_client
AND b.id_loc = l.id_loc 
AND l.id_avion = a.id_avion
AND a.id_avion = z.id_avion
AND r.id_zbor = z.id_zbor
AND rez.id_rezervare = b.id_rezervare
AND rez.pret = (SELECT min(pret)
					FROM rezervari_am)
AND rez.data_rezervare BETWEEN TO_DATE('01-NOV-2014') AND TO_DATE('31-DEC-2014');

/* 12. Sa se afiseze cele mai ieftine 5 bilete si rutele acestora. */

SELECT aux.id_bilet, aux.denumire_ruta, aux.pret
FROM (SELECT b.id_bilet, r.denumire_ruta, rez.pret 
		FROM locuri_am l, rute_am r, clienti_am c, bilete_am b, avioane_am a, zboruri_am z, rezervari_am rez 
		WHERE c.id_client = b.id_client
		AND b.id_loc = l.id_loc 
		AND l.id_avion = a.id_avion
		AND a.id_avion = z.id_avion
		AND r.id_zbor = z.id_zbor
		AND rez.id_rezervare = b.id_rezervare
		ORDER BY rez.pret) aux
WHERE rownum <= 5;

/* 13. Sa se afiseze numarul clientilor din fiecare oras. */

SELECT adresa, count(id_client) as NR_PERSOANE
FROM clienti_am
GROUP BY adresa
ORDER BY NR_PERSOANE DESC;

/* 14. Sa se afiseze echipajele cu minim 4 membri, minim 1500 ore experienta, iar pentru fiecare echipaj avionul corespunzator si compania aeriana ce il detine. */

SELECT e.id_echipaj, e.numar_membri, a.denumire_avion, c.denumire_companie
FROM echipaje_am e, avioane_am a, companii_am c
WHERE e.numar_membri >= 4
AND e.experienta >= 1500
AND e.id_avion = a.id_avion
AND a.id_companie = c.id_companie
ORDER BY e.numar_membri DESC;

/* 15. Sa se afiseze cel mai lung zbor si avionul corespunzator acestuia. */

SELECT aux.id_zbor, aux.denumire_zbor, aux.denumire_avion, (aux.DURATA_ZBOR || ' ' || 'ore') as DURATA
FROM (SELECT z.id_zbor, z.denumire_zbor, a.denumire_avion, (z.data_sosire - z.data_plecare)*24 as DURATA_ZBOR
		FROM zboruri_am z, avioane_am a
		WHERE z.id_avion = a.id_avion
		ORDER BY DURATA_ZBOR DESC) aux
WHERE rownum = 1;

/* 16. Sa se afiseze timpul ramas pana la expirarea fiecarei rezervari, clientul corespunzator si numarul acestuia de telefon. */

SELECT aux.id_rezervare, (aux.TIMP_RAMAS_L || ' ' || 'luni') as LUNI, (aux.TIMP_RAMAS_Z || ' ' || 'zile') as ZILE, (aux.TIMP_RAMAS_H || ' ' || 'ore') as ORE, aux.nume_client, aux.prenume_client, aux.numar_telefon
FROM (SELECT r.id_rezervare, ROUND((r.data_expirare - SYSDATE)/30) as TIMP_RAMAS_L, ROUND(r.data_expirare - SYSDATE) as TIMP_RAMAS_Z, ROUND((r.data_expirare - SYSDATE)*24) as TIMP_RAMAS_H, c.nume_client, c.prenume_client, c.numar_telefon
		FROM rezervari_am r, clienti_am c, bilete_am b
		WHERE b.id_client = c.id_client
		AND b.id_rezervare = r.id_rezervare
		ORDER BY TIMP_RAMAS_L) aux;
		
/* 17. Sa se afiseze numarul de avioane din dotarea fiecarei companii, denumirea companiei si e-mail-ul acesteia. */

SELECT c.denumire_companie, COUNT(a.id_avion) as FLOTA, c.e_mail
FROM companii_am c, avioane_am a
WHERE c.id_companie = a.id_companie
GROUP BY c.denumire_companie, c.e_mail
ORDER BY FLOTA DESC;




