-----------------------------------------
-- David Aguilar López – 1703702
-- Izan Caballer Jimenez – 1710282
-- Lluís Sàrries Mas – 1710615
-- Adrián Valverde Ambrosio - 1707952
-- BBDD UrgènciesPediàtriques
-- Grup432-3
-- 2024-2025
-----------------------------------------
--
-- Aquest script:
--
--        1) Crea les taules de la base de dades d'urgències pediàtriques,
--        2) crea les constraints, i
--        3) hi afegeix els registres. 
--
-- Si ja s'ha executat previament, l'script esborra les taules de la base de 
-- dades i les torna a editar. 
-- De tal manera, cal IGNORAR els missatges d'error que dóna 
-- la primera vegada que s'executa. 
--

DROP TABLE atès CASCADE CONSTRAINTS;
DROP TABLE cicle CASCADE CONSTRAINTS;
DROP TABLE esdeveniments CASCADE CONSTRAINTS;
DROP TABLE malaltia CASCADE CONSTRAINTS;
DROP TABLE medicació CASCADE CONSTRAINTS;
DROP TABLE pacient CASCADE CONSTRAINTS;
DROP TABLE protocol CASCADE CONSTRAINTS;
DROP TABLE treballador CASCADE CONSTRAINTS;
DROP TABLE visites CASCADE CONSTRAINTS;

--COMMIT;

set termout on
prompt 
prompt %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
prompt % 1. Creant les taules:   
prompt %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
prompt 
set termout off


-- Taula atès
-- DROP TABLE atès CASCADE CONSTRAINTS;

CREATE TABLE atès (
    rol        VARCHAR2(50),
    id_pacient VARCHAR2(10) NOT NULL,
    id_t       VARCHAR2(10) NOT NULL,
    data       DATE NOT NULL,
    hora       VARCHAR2(10) NOT NULL
);


-- Taula cicle
-- DROP TABLE cicle CASCADE CONSTRAINTS;

CREATE TABLE cicle (
    "Codi Protocol" VARCHAR2(10) NOT NULL,
    "Número de cicle"        INTEGER NOT NULL,
    "Temps de cicle"         INTERVAL DAY(9) TO SECOND(0) NOT NULL
);


ALTER TABLE cicle ADD CONSTRAINT cicle_pk PRIMARY KEY ( "Número de cicle",
                                                        "Codi Protocol" );

-- Taula esdeveniments
-- DROP TABLE esdeveniments CASCADE CONSTRAINTS;


CREATE TABLE esdeveniments (
    esdeveniment VARCHAR2(4000) NOT NULL,
    data         DATE NOT NULL,
    hora         VARCHAR2(10) NOT NULL
);

ALTER TABLE esdeveniments ADD CONSTRAINT esdeveniments_pk PRIMARY KEY ( data, hora,
                                                                        esdeveniment );

-- Taula malaltia
-- DROP TABLE malaltia CASCADE CONSTRAINTS;

CREATE TABLE malaltia (
    nom        VARCHAR2(50) NOT NULL,
    id VARCHAR2(10) NOT NULL,
    "Te?"      CHAR(1)
);

ALTER TABLE malaltia ADD CONSTRAINT malaltia_pk PRIMARY KEY ( nom,
                                                              id );
-- Taula medicació
-- DROP TABLE medicació CASCADE CONSTRAINTS;

CREATE TABLE medicació (
    nom                      VARCHAR2(50) NOT NULL,
    "Quantitat Fixa"         INTEGER,
    dosi                     INTEGER,
    "Codi Protocol" VARCHAR2(10) NOT NULL
);

COMMENT ON COLUMN medicació.dosi IS
    'Quantitat Fixa * Visites.Pes ';

ALTER TABLE medicació ADD CONSTRAINT medicació_pk PRIMARY KEY ( nom,
                                                                "Codi Protocol" );
-- Taula pacient
-- DROP TABLE pacient CASCADE CONSTRAINTS;

CREATE TABLE pacient (
    id VARCHAR2(10) NOT NULL,
    nom     VARCHAR2(50) NOT NULL,
    cognom  VARCHAR2(50) NOT NULL
);

ALTER TABLE pacient ADD CONSTRAINT pacient_pk PRIMARY KEY ( id );

-- Taula protocol
-- DROP TABLE protocol CASCADE CONSTRAINTS;

CREATE TABLE protocol (
    "Codi Protocol" VARCHAR2(10) NOT NULL,
    "Ritme Aturada" VARCHAR2(20) NOT NULL,
    id_pacient      VARCHAR2(10) NOT NULL
);

ALTER TABLE protocol ADD CONSTRAINT protocol_pk PRIMARY KEY ( "Codi Protocol" );

-- Taula treballador
-- DROP TABLE treballador CASCADE CONSTRAINTS;

CREATE TABLE treballador (
    id_t    VARCHAR2(10) NOT NULL,
    nom     VARCHAR2(50) NOT NULL,
    cognom  VARCHAR2(50) NOT NULL,
    id_tcai VARCHAR2(10),
    id_tl   VARCHAR2(10)
);

ALTER TABLE treballador ADD CONSTRAINT treballador_pk PRIMARY KEY ( id_t );

-- Taula visites
-- DROP TABLE visites CASCADE CONSTRAINTS;

CREATE TABLE visites (
    data          DATE NOT NULL,
    hora          VARCHAR2(10) NOT NULL,
    pes           FLOAT,
    edat          FLOAT,
    "Temps Total" INTERVAL DAY(9) TO SECOND(0)
);

ALTER TABLE visites ADD CONSTRAINT visites_pk PRIMARY KEY ( data, hora );


set termout on
prompt
prompt %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
prompt % 2. Afegint les restriccions -constraints-: Claus foranes
prompt %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
prompt 
set termout off


-- Referència cicle --> protocol
ALTER TABLE cicle
    ADD CONSTRAINT cicle_protocol_fk FOREIGN KEY ( "Codi Protocol" )
        REFERENCES protocol ( "Codi Protocol" );

-- Referència ates --> visites
ALTER TABLE atès
    ADD CONSTRAINT data_fk FOREIGN KEY ( data, hora )
        REFERENCES visites ( data, hora );

-- Referència esdeveniments --> visites
ALTER TABLE esdeveniments
    ADD CONSTRAINT data_fkv2 FOREIGN KEY ( data, hora )
        REFERENCES visites ( data, hora );

-- Referència atès --> pacient
ALTER TABLE atès
    ADD CONSTRAINT id_pacient_fk FOREIGN KEY ( id_pacient )
        REFERENCES pacient ( id );

-- Referència malaltia --> pacient
ALTER TABLE malaltia
    ADD CONSTRAINT id_fkv1 FOREIGN KEY ( id )
        REFERENCES pacient ( id );

-- Referència protocol --> pacient
ALTER TABLE protocol
    ADD CONSTRAINT id_pacient_fkv2 FOREIGN KEY ( id_pacient )
        REFERENCES pacient ( id );

-- Referència atès --> treballador
ALTER TABLE atès
    ADD CONSTRAINT id_t_fk FOREIGN KEY ( id_t )
        REFERENCES treballador ( id_t );

-- Referència treballador --> treballador
ALTER TABLE treballador
    ADD CONSTRAINT id_tcai_fk FOREIGN KEY ( id_tcai )
        REFERENCES treballador ( id_t );

-- Referència treballador --> treballador
ALTER TABLE treballador
    ADD CONSTRAINT id_tl_fk FOREIGN KEY ( id_tl )
        REFERENCES treballador ( id_t );

-- Referència medicacio --> protocol
ALTER TABLE medicació
    ADD CONSTRAINT "Ritme Aturada_fkv2" FOREIGN KEY ( "Codi Protocol" )
        REFERENCES protocol ( "Codi Protocol" );


set termout on
prompt
prompt %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
prompt % 3. Afegint Registres a les Taules
prompt %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
prompt 
set termout off

INSERT INTO pacient (id, nom, cognom) 
VALUES ('P0001', 'María', 'Vázquez');

INSERT INTO visites (data, hora, pes, edat, "Temps Total") 
VALUES (TO_DATE('2024/12/21', 'YYYY-MM-DD'), '09:30:00', 25, 1.4, INTERVAL '1' HOUR);

INSERT INTO visites (data, hora, pes, edat, "Temps Total") 
VALUES (TO_DATE('2024/12/21', 'YYYY-MM-DD'), '10:30:00', 25, 1.4, INTERVAL '1' HOUR);

INSERT INTO treballador (id_t, nom, cognom, id_tcai, id_tl) 
VALUES ('T003', 'Juan', 'Garcia', '', 'T003');

INSERT INTO treballador (id_t, nom, cognom, id_tcai, id_tl) 
VALUES ('T001', 'Joan', 'Perez', 'T001', 'T003');

INSERT INTO protocol ("Ritme Aturada", id_pacient, "Codi Protocol") 
VALUES ('Desfibrilable', 'P0001', 'Pr0001');

INSERT INTO cicle ("Codi Protocol", "Número de cicle", "Temps de cicle") 
VALUES ('Pr0001', 1,INTERVAL '2' MINUTE );

INSERT INTO medicació (nom, "Quantitat Fixa", dosi, "Codi Protocol") 
VALUES ('Adrenalina', 0.01, NULL, 'Pr0001');

INSERT INTO malaltia (nom, "Te?", id) 
VALUES ('Hipoxia', 'S', 'P0001');
INSERT INTO malaltia (nom, "Te?", id) 
VALUES ('Hipotermia', 'S', 'P0001');
INSERT INTO malaltia (nom, "Te?", id) 
VALUES ('Hipotasemia', 'S', 'P0001');
INSERT INTO malaltia (nom, "Te?", id) 
VALUES ('Hipovolemia', 'S', 'P0001');
INSERT INTO malaltia (nom, "Te?", id) 
VALUES ('Taponamiento', 'S', 'P0001');
INSERT INTO malaltia (nom, "Te?", id) 
VALUES ('Neumotórax a Tensión', 'S', 'P0001');
INSERT INTO malaltia (nom, "Te?", id) 
VALUES ('Trombosis', 'S', 'P0001');
INSERT INTO malaltia (nom, "Te?", id) 
VALUES ('Tóxicos', 'S', 'P0001');

INSERT INTO esdeveniments (esdeveniment, data, hora)
VALUES ('Ingrès UCI', TO_DATE('2024/12/21', 'YYYY-MM-DD'), '09:30:00');

INSERT INTO esdeveniments (esdeveniment, data, hora)
VALUES ('Sortida UCI', TO_DATE('2024/12/21', 'YYYY-MM-DD'), '10:30:00');

INSERT INTO atès (rol, id_pacient, id_t, data, hora) 
VALUES ('Pediatra', 'P0001', 'T003', TO_DATE('2024/12/21', 'YYYY-MM-DD'), '09:30:00');

INSERT INTO atès (rol, id_pacient, id_t, data, hora) 
VALUES ('Infermer', 'P0001', 'T001', TO_DATE('2024/12/21', 'YYYY-MM-DD'), '09:30:00');

INSERT INTO pacient (id, nom, cognom) 
VALUES ('P0002', 'Ángel', 'Martínez');

INSERT INTO visites (data, hora, pes, edat, "Temps Total") 
VALUES (TO_DATE('2024-12-22', 'YYYY-MM-DD'), '09:30:00', 25, 1.4, INTERVAL '1' HOUR);

INSERT INTO visites (data, hora, pes, edat, "Temps Total") 
VALUES (TO_DATE('2024-12-22', 'YYYY-MM-DD'), '10:30:00', 25, 1.4, INTERVAL '1' HOUR);

INSERT INTO treballador (id_t, nom, cognom, id_tcai, id_tl) 
VALUES ('T004', 'Juan', 'Garcia', '', 'T004');

INSERT INTO treballador (id_t, nom, cognom, id_tcai, id_tl) 
VALUES ('T005', 'Joan', 'Perez', 'T005', 'T004');

INSERT INTO protocol ("Ritme Aturada", id_pacient, "Codi Protocol") 
VALUES ('Desfibrilable', 'P0002', 'Pr0002');

INSERT INTO cicle ("Codi Protocol", "Número de cicle", "Temps de cicle") 
VALUES ('Pr0002', 1,INTERVAL '2' MINUTE );

INSERT INTO medicació (nom, "Quantitat Fixa", dosi, "Codi Protocol") 
VALUES ('Adrenalina', 0.01, NULL, 'Pr0002');

INSERT INTO malaltia (nom, "Te?", id) 
VALUES ('Hipoxia', 'N', 'P0002');
INSERT INTO malaltia (nom, "Te?", id) 
VALUES ('Hipotermia', 'N', 'P0002');
INSERT INTO malaltia (nom, "Te?", id) 
VALUES ('Hipotasemia', 'S', 'P0002');
INSERT INTO malaltia (nom, "Te?", id) 
VALUES ('Hipovolemia', 'N', 'P0002');
INSERT INTO malaltia (nom, "Te?", id) 
VALUES ('Taponamiento', 'S', 'P0002');
INSERT INTO malaltia (nom, "Te?", id) 
VALUES ('Neumotórax a Tensión', 'N', 'P0002');
INSERT INTO malaltia (nom, "Te?", id) 
VALUES ('Trombosis', 'S', 'P0002');
INSERT INTO malaltia (nom, "Te?", id) 
VALUES ('Tóxicos', 'N', 'P0002');

INSERT INTO esdeveniments (esdeveniment, data, hora) 
VALUES ('Ingrès UCI', TO_DATE('2024-12-22', 'YYYY-MM-DD'), '09:30:00');

INSERT INTO esdeveniments (esdeveniment, data, hora)
VALUES ('Sortida UCI', TO_DATE('2024-12-22', 'YYYY-MM-DD'), '10:30:00');

INSERT INTO atès (rol, id_pacient, id_t, data, hora) 
VALUES ('Pediatra', 'P0002', 'T004', TO_DATE('2024-12-22', 'YYYY-MM-DD'),'09:30:00');

INSERT INTO atès (rol, id_pacient, id_t, data, hora) 
VALUES ('Infermer', 'P0002', 'T005', TO_DATE('2024-12-22', 'YYYY-MM-DD'), '09:30:00');

INSERT INTO protocol ("Ritme Aturada", id_pacient, "Codi Protocol") 
VALUES ('No Desfibrilable', 'P0002', 'Pr0003');

INSERT INTO cicle ("Codi Protocol", "Número de cicle", "Temps de cicle") 
VALUES ('Pr0003', 2 ,INTERVAL '2' MINUTE );

INSERT INTO medicació (nom, "Quantitat Fixa", dosi, "Codi Protocol") 
VALUES ('Adrenalina', 0.01, NULL, 'Pr0003');

INSERT INTO medicació (nom, "Quantitat Fixa", dosi, "Codi Protocol") 
VALUES ('Amiodarona', 0.05, NULL, 'Pr0003');

INSERT INTO pacient (id, nom, cognom) 
VALUES ('P0004', 'Martí', 'Sánchez');

INSERT INTO visites (data, hora, pes, edat, "Temps Total") 
VALUES (TO_DATE('2024-12-24', 'YYYY-MM-DD'), '09:30:00', 28, 1.5, INTERVAL '1' HOUR);

INSERT INTO visites (data, hora, pes, edat, "Temps Total") 
VALUES (TO_DATE('2024-12-24', 'YYYY-MM-DD'), '10:30:00', 28, 1.5, INTERVAL '1' HOUR);

INSERT INTO esdeveniments (esdeveniment, data, hora)
VALUES ('Ingrès UCI', TO_DATE('2024-12-24', 'YYYY-MM-DD'), '09:30:00');

INSERT INTO esdeveniments (esdeveniment, data, hora)
VALUES ('Sortida UCI', TO_DATE('2024-12-24', 'YYYY-MM-DD'),'10:30:00');

INSERT INTO treballador (id_t, nom, cognom, id_tcai, id_tl) 
VALUES ('T008', 'Miguel', 'Fernández', '', 'T008');

INSERT INTO treballador (id_t, nom, cognom, id_tcai, id_tl) 
VALUES ('T009', 'Beatriz', 'Rodríguez', 'T009', 'T008');

INSERT INTO protocol ("Ritme Aturada", id_pacient, "Codi Protocol") 
VALUES ('Desfibrilable', 'P0004', 'Pr0004');

INSERT INTO cicle ("Codi Protocol", "Número de cicle", "Temps de cicle") 
VALUES ('Pr0004', 1, INTERVAL '2' MINUTE);

INSERT INTO malaltia (nom, "Te?", id) 
VALUES ('Hipoxia', 'N', 'P0004');
INSERT INTO malaltia (nom, "Te?", id) 
VALUES ('Hipotermia', 'N', 'P0004');
INSERT INTO malaltia (nom, "Te?", id) 
VALUES ('Hipotasemia', 'N', 'P0004');
INSERT INTO malaltia (nom, "Te?", id) 
VALUES ('Hipovolemia', 'N', 'P0004');
INSERT INTO malaltia (nom, "Te?", id) 
VALUES ('Taponamiento', 'N', 'P0004');
INSERT INTO malaltia (nom, "Te?", id) 
VALUES ('Neumotórax a Tensión', 'N', 'P0004');
INSERT INTO malaltia (nom, "Te?", id) 
VALUES ('Trombosis', 'N', 'P0004');
INSERT INTO malaltia (nom, "Te?", id) 
VALUES ('Tóxicos', 'N', 'P0004');

INSERT INTO atès (rol, id_pacient, id_t, data, hora) 
VALUES ('Pediatra', 'P0004', 'T008', TO_DATE('2024-12-24', 'YYYY-MM-DD'), '09:30:00');

INSERT INTO atès (rol, id_pacient, id_t, data, hora) 
VALUES ('Infermer', 'P0004', 'T009', TO_DATE('2024-12-24', 'YYYY-MM-DD'), '09:30:00');

INSERT INTO pacient (id, nom, cognom) 
VALUES ('P0005', 'Cristina', 'Rose');

INSERT INTO visites (data, hora, pes, edat, "Temps Total") 
VALUES (TO_DATE('2024-12-25', 'YYYY-MM-DD'), '09:30:00', 29, 1.7, INTERVAL '1' HOUR);

INSERT INTO visites (data, hora, pes, edat, "Temps Total") 
VALUES (TO_DATE('2024-12-25', 'YYYY-MM-DD'), '10:30:00', 29, 1.7, INTERVAL '1' HOUR);

INSERT INTO esdeveniments (esdeveniment, data, hora)
VALUES ('Ingrès UCI', TO_DATE('2024-12-25', 'YYYY-MM-DD'), '09:30:00');

INSERT INTO esdeveniments (esdeveniment, data, hora)
VALUES ('Sortida UCI', TO_DATE('2024-12-25', 'YYYY-MM-DD'),'10:30:00');

INSERT INTO treballador (id_t, nom, cognom, id_tcai, id_tl) 
VALUES ('T010', 'Javier', 'Sánchez', '', 'T010');

INSERT INTO treballador (id_t, nom, cognom, id_tcai, id_tl) 
VALUES ('T011', 'María', 'Jiménez', 'T011', 'T010');

INSERT INTO protocol ("Ritme Aturada", id_pacient, "Codi Protocol") 
VALUES ('Desfibrilable', 'P0005', 'Pr0005');

INSERT INTO cicle ("Codi Protocol", "Número de cicle", "Temps de cicle") 
VALUES ('Pr0005', 1, INTERVAL '4' MINUTE);

INSERT INTO malaltia (nom, "Te?", id) 
VALUES ('Hipoxia', 'N', 'P0005');
INSERT INTO malaltia (nom, "Te?", id) 
VALUES ('Hipotermia', 'N', 'P0005');
INSERT INTO malaltia (nom, "Te?", id) 
VALUES ('Hipotasemia', 'N', 'P0005');
INSERT INTO malaltia (nom, "Te?", id) 
VALUES ('Hipovolemia', 'N', 'P0005');
INSERT INTO malaltia (nom, "Te?", id) 
VALUES ('Taponamiento', 'N', 'P0005');
INSERT INTO malaltia (nom, "Te?", id) 
VALUES ('Neumotórax a Tensión', 'N', 'P0005');
INSERT INTO malaltia (nom, "Te?", id) 
VALUES ('Trombosis', 'N', 'P0005');
INSERT INTO malaltia (nom, "Te?", id) 
VALUES ('Tóxicos', 'N', 'P0005');

INSERT INTO atès (rol, id_pacient, id_t, data, hora) 
VALUES ('Pediatra', 'P0005', 'T010', TO_DATE('2024-12-25', 'YYYY-MM-DD'),'09:30:00');

INSERT INTO atès (rol, id_pacient, id_t, data, hora) 
VALUES ('Infermer', 'P0005', 'T011', TO_DATE('2024-12-25', 'YYYY-MM-DD'),'09:30:00');

INSERT INTO pacient (id, nom, cognom) 
VALUES ('P0006', 'Xavier', 'Pons');

INSERT INTO visites (data, hora, pes, edat, "Temps Total") 
VALUES (TO_DATE('2024-12-26', 'YYYY-MM-DD'),'09:30:00', 33, 1.8, INTERVAL '1' HOUR);

INSERT INTO visites (data, hora, pes, edat, "Temps Total") 
VALUES (TO_DATE('2024-12-26', 'YYYY-MM-DD'),'10:30:00', 33, 1.8, INTERVAL '1' HOUR);

INSERT INTO esdeveniments (esdeveniment, data, hora)
VALUES ('Ingrès UCI', TO_DATE('2024-12-26', 'YYYY-MM-DD'), '09:30:00');

INSERT INTO esdeveniments (esdeveniment, data, hora)
VALUES ('Sortida UCI', TO_DATE('2024-12-26', 'YYYY-MM-DD'),'10:30:00');

INSERT INTO treballador (id_t, nom, cognom, id_tcai, id_tl) 
VALUES ('T012', 'Luis', 'García', '', 'T012');

INSERT INTO treballador (id_t, nom, cognom, id_tcai, id_tl) 
VALUES ('T013', 'Patricia', 'Álvarez', 'T013', 'T012');

INSERT INTO protocol ("Ritme Aturada", id_pacient, "Codi Protocol") 
VALUES ('No Desfibrilable', 'P0006', 'Pr0006');

INSERT INTO cicle ("Codi Protocol", "Número de cicle", "Temps de cicle") 
VALUES ('Pr0006', 1, INTERVAL '5' MINUTE);

INSERT INTO malaltia (nom, "Te?", id) 
VALUES ('Hipoxia', 'S', 'P0006');
INSERT INTO malaltia (nom, "Te?", id) 
VALUES ('Hipotermia', 'N', 'P0006');
INSERT INTO malaltia (nom, "Te?", id) 
VALUES ('Hipotasemia', 'N', 'P0006');
INSERT INTO malaltia (nom, "Te?", id) 
VALUES ('Hipovolemia', 'N', 'P0006');
INSERT INTO malaltia (nom, "Te?", id) 
VALUES ('Taponamiento', 'S', 'P0006');
INSERT INTO malaltia (nom, "Te?", id) 
VALUES ('Neumotórax a Tensión', 'N', 'P0006');
INSERT INTO malaltia (nom, "Te?", id) 
VALUES ('Trombosis', 'N', 'P0006');
INSERT INTO malaltia (nom, "Te?", id) 
VALUES ('Tóxicos', 'N', 'P0006');

INSERT INTO atès (rol, id_pacient, id_t, data, hora) 
VALUES ('Pediatra', 'P0006', 'T012', TO_DATE('2024-12-26', 'YYYY-MM-DD'), '09:30:00');

INSERT INTO atès (rol, id_pacient, id_t, data, hora) 
VALUES ('Infermer', 'P0006', 'T013', TO_DATE('2024-12-26', 'YYYY-MM-DD'), '09:30:00');

INSERT INTO pacient (id, nom, cognom) 
VALUES ('P0007', 'Álex', 'Carrasco');

INSERT INTO visites (data, hora, pes, edat, "Temps Total") 
VALUES (TO_DATE('2024-12-27', 'YYYY-MM-DD'), '09:30:00', 34, 1.9, INTERVAL '1' HOUR);
INSERT INTO visites (data, hora, pes, edat, "Temps Total") 
VALUES (TO_DATE('2024-12-27', 'YYYY-MM-DD'), '10:30:00', 34, 1.9, INTERVAL '1' HOUR);


INSERT INTO treballador (id_t, nom, cognom, id_tcai, id_tl) 
VALUES ('T014', 'José', 'Mora', '', 'T014');

INSERT INTO treballador (id_t, nom, cognom, id_tcai, id_tl) 
VALUES ('T015', 'María', 'Torres', 'T015', 'T014');

INSERT INTO treballador (id_t, nom, cognom, id_tcai, id_tl) 
VALUES ('T016', 'Pedro', 'González', 'T015', 'T014');

INSERT INTO treballador (id_t, nom, cognom, id_tcai, id_tl) 
VALUES ('T017', 'Ana', 'López', 'T015', 'T014');

INSERT INTO treballador (id_t, nom, cognom, id_tcai, id_tl) 
VALUES ('T018', 'Luis', 'Sánchez', 'T015', 'T014');

INSERT INTO treballador (id_t, nom, cognom, id_tcai, id_tl) 
VALUES ('T019', 'Laura', 'Fernández', 'T015', 'T014');

INSERT INTO treballador (id_t, nom, cognom, id_tcai, id_tl) 
VALUES ('T020', 'Carlos', 'Martín', 'T015', 'T014');

INSERT INTO protocol ("Ritme Aturada", id_pacient, "Codi Protocol") 
VALUES ('Desfibrilable', 'P0007', 'Pr0007');

INSERT INTO cicle ("Codi Protocol", "Número de cicle", "Temps de cicle") 
VALUES ('Pr0007', 1, INTERVAL '2' MINUTE);

INSERT INTO cicle ("Codi Protocol", "Número de cicle", "Temps de cicle") 
VALUES ('Pr0007', 2, INTERVAL '3' MINUTE);

INSERT INTO cicle ("Codi Protocol", "Número de cicle", "Temps de cicle") 
VALUES ('Pr0007', 3, INTERVAL '4' MINUTE);

INSERT INTO medicació (nom, "Quantitat Fixa", dosi, "Codi Protocol") 
VALUES ('Adrenalina', 0.01, NULL, 'Pr0007');

INSERT INTO malaltia (nom, "Te?", id) 
VALUES ('Hipoxia', 'N', 'P0007');
INSERT INTO malaltia (nom, "Te?", id) 
VALUES ('Hipotermia', 'N', 'P0007');
INSERT INTO malaltia (nom, "Te?", id) 
VALUES ('Hipotasemia', 'S', 'P0007');
INSERT INTO malaltia (nom, "Te?", id) 
VALUES ('Hipovolemia', 'S', 'P0007');
INSERT INTO malaltia (nom, "Te?", id) 
VALUES ('Taponamiento', 'N', 'P0007');
INSERT INTO malaltia (nom, "Te?", id) 
VALUES ('Neumotórax a Tensión', 'N', 'P0007');
INSERT INTO malaltia (nom, "Te?", id) 
VALUES ('Trombosis', 'N', 'P0007');
INSERT INTO malaltia (nom, "Te?", id) 
VALUES ('Tóxicos', 'S', 'P0007');

INSERT INTO esdeveniments (esdeveniment, data, hora)
VALUES ('Ingrès UCI', TO_DATE('2024-12-27', 'YYYY-MM-DD'), '09:30:00');

INSERT INTO esdeveniments (esdeveniment, data, hora)
VALUES ('Sortida UCI', TO_DATE('2024-12-27', 'YYYY-MM-DD'),'10:30:00');

INSERT INTO atès (rol, id_pacient, id_t, data, hora) 
VALUES ('Pediatra', 'P0007', 'T014', TO_DATE('2024-12-27', 'YYYY-MM-DD'), '09:30:00');

INSERT INTO atès (rol, id_pacient, id_t, data, hora) 
VALUES ('Infermer', 'P0007', 'T015', TO_DATE('2024-12-27', 'YYYY-MM-DD'), '09:30:00');

INSERT INTO atès (rol, id_pacient, id_t, data, hora) 
VALUES ('Pediatra', 'P0007', 'T016', TO_DATE('2024-12-27', 'YYYY-MM-DD'), '09:30:00');

INSERT INTO atès (rol, id_pacient, id_t, data, hora) 
VALUES ('Infermer', 'P0007', 'T017', TO_DATE('2024-12-27', 'YYYY-MM-DD'), '09:30:00');

INSERT INTO atès (rol, id_pacient, id_t, data, hora) 
VALUES ('Pediatra', 'P0007', 'T018', TO_DATE('2024-12-27', 'YYYY-MM-DD'), '09:30:00');

INSERT INTO atès (rol, id_pacient, id_t, data, hora) 
VALUES ('Infermer', 'P0007', 'T019', TO_DATE('2024-12-27', 'YYYY-MM-DD'), '09:30:00');

INSERT INTO atès (rol, id_pacient, id_t, data, hora) 
VALUES ('Infermer', 'P0007', 'T020', TO_DATE('2024-12-27', 'YYYY-MM-DD'), '09:30:00');

INSERT INTO pacient (id, nom, cognom) 
VALUES ('P0008', 'Marta', 'Fernández');

INSERT INTO visites (data, hora, pes, edat, "Temps Total") 
VALUES (TO_DATE('2024-12-28', 'YYYY-MM-DD'), '08:30:00', 30, 2.2, INTERVAL '1' HOUR);
INSERT INTO visites (data, hora, pes, edat, "Temps Total") 
VALUES (TO_DATE('2024-12-28', 'YYYY-MM-DD'), '09:30:00', 30, 2.2, INTERVAL '1' HOUR);

INSERT INTO protocol ("Ritme Aturada", id_pacient, "Codi Protocol") 
VALUES ('No Desfibrilable', 'P0008', 'Pr0008');

INSERT INTO cicle ("Codi Protocol", "Número de cicle", "Temps de cicle") 
VALUES ('Pr0008', 1, INTERVAL '2' MINUTE);

INSERT INTO cicle ("Codi Protocol", "Número de cicle", "Temps de cicle") 
VALUES ('Pr0008', 2, INTERVAL '4' MINUTE);

INSERT INTO cicle ("Codi Protocol", "Número de cicle", "Temps de cicle") 
VALUES ('Pr0008', 3, INTERVAL '5' MINUTE);

INSERT INTO medicació (nom, "Quantitat Fixa", dosi, "Codi Protocol") 
VALUES ('Adrenalina', 0.05, NULL, 'Pr0008');

INSERT INTO malaltia (nom, "Te?", id) 
VALUES ('Hipoxia', 'N', 'P0008');
INSERT INTO malaltia (nom, "Te?", id) 
VALUES ('Hipotermia', 'N', 'P0008');
INSERT INTO malaltia (nom, "Te?", id) 
VALUES ('Hipotasemia', 'N', 'P0008');
INSERT INTO malaltia (nom, "Te?", id) 
VALUES ('Hipovolemia', 'N', 'P0008');
INSERT INTO malaltia (nom, "Te?", id) 
VALUES ('Taponamiento', 'N', 'P0008');
INSERT INTO malaltia (nom, "Te?", id) 
VALUES ('Neumotórax a Tensión', 'N', 'P0008');
INSERT INTO malaltia (nom, "Te?", id) 
VALUES ('Trombosis', 'N', 'P0008');
INSERT INTO malaltia (nom, "Te?", id) 
VALUES ('Tóxicos', 'N', 'P0008');

INSERT INTO esdeveniments (esdeveniment, data, hora)
VALUES ('Ingrès UCI', TO_DATE('2024-12-28', 'YYYY-MM-DD'), '08:30:00');

INSERT INTO esdeveniments (esdeveniment, data, hora)
VALUES ('Sortida UCI', TO_DATE('2024-12-28', 'YYYY-MM-DD'),'09:30:00');

INSERT INTO atès (rol, id_pacient, id_t, data, hora) 
VALUES ('Pediatra', 'P0008', 'T020', TO_DATE('2024-12-28', 'YYYY-MM-DD'), '08:30:00');

INSERT INTO atès (rol, id_pacient, id_t, data, hora) 
VALUES ('Infermer', 'P0008', 'T017', TO_DATE('2024-12-28', 'YYYY-MM-DD'), '08:30:00');

INSERT INTO atès (rol, id_pacient, id_t, data, hora) 
VALUES ('Pediatra', 'P0008', 'T003', TO_DATE('2024-12-28', 'YYYY-MM-DD'),'08:30:00');

INSERT INTO atès (rol, id_pacient, id_t, data, hora) 
VALUES ('Infermer', 'P0008', 'T001', TO_DATE('2024-12-28', 'YYYY-MM-DD'),'08:30:00');

INSERT INTO atès (rol, id_pacient, id_t, data, hora) 
VALUES ('Pediatra', 'P0008', 'T004', TO_DATE('2024-12-28', 'YYYY-MM-DD'),'08:30:00');

INSERT INTO atès (rol, id_pacient, id_t, data, hora) 
VALUES ('Infermer', 'P0008', 'T019', TO_DATE('2024-12-28', 'YYYY-MM-DD'), '08:30:00');

INSERT INTO atès (rol, id_pacient, id_t, data, hora) 
VALUES ('Infermer', 'P0008', 'T005', TO_DATE('2024-12-28', 'YYYY-MM-DD'), '08:30:00');

INSERT INTO treballador (id_t, nom, cognom, id_tcai, id_tl) 
VALUES ('T021', 'Josep', 'Pedrerol', '', '');

INSERT INTO visites (data, hora, pes, edat, "Temps Total") 
VALUES (TO_DATE('2024/11/21', 'YYYY-MM-DD'), '09:30:00', 20, 1.4, INTERVAL '1' HOUR);

INSERT INTO visites (data, hora, pes, edat, "Temps Total") 
VALUES (TO_DATE('2024/11/21', 'YYYY-MM-DD'), '10:30:00', 20, 1.4, INTERVAL '1' HOUR);

INSERT INTO treballador (id_t, nom, cognom, id_tcai, id_tl) 
VALUES ('T022', 'Luis', 'Escobar', '', 'T022');

INSERT INTO treballador (id_t, nom, cognom, id_tcai, id_tl) 
VALUES ('T023', 'Francisco', 'Iglesias', 'T023', 'T022');

INSERT INTO protocol ("Ritme Aturada", id_pacient, "Codi Protocol") 
VALUES ('Desfibrilable', 'P0004', 'Pr0011');

INSERT INTO cicle ("Codi Protocol", "Número de cicle", "Temps de cicle") 
VALUES ('Pr0011', 1,INTERVAL '2' MINUTE );

INSERT INTO medicació (nom, "Quantitat Fixa", dosi, "Codi Protocol") 
VALUES ('Descàrrega', 4, NULL, 'Pr0011');

INSERT INTO esdeveniments (esdeveniment, data, hora)
VALUES ('Ingrès UCI', TO_DATE('2024/11/21', 'YYYY-MM-DD'), '09:30:00');

INSERT INTO esdeveniments (esdeveniment, data, hora)
VALUES ('Sortida UCI', TO_DATE('2024/11/21', 'YYYY-MM-DD'), '10:30:00');

INSERT INTO atès (rol, id_pacient, id_t, data, hora) 
VALUES ('Pediatra', 'P0004', 'T022', TO_DATE('2024/11/21', 'YYYY-MM-DD'), '09:30:00');

INSERT INTO atès (rol, id_pacient, id_t, data, hora) 
VALUES ('Infermer', 'P0004', 'T023', TO_DATE('2024/11/21', 'YYYY-MM-DD'), '09:30:00');