DROP TABLE JUG_NIV_IDIOMA CASCADE CONSTRAINTS;
DROP TABLE HISTORIAL_JUGADOR CASCADE CONSTRAINTS;
DROP TABLE PERSONAL_PLANTA CASCADE CONSTRAINTS;
DROP TABLE JUGADOR CASCADE CONSTRAINTS;
DROP TABLE TRABAJADOR CASCADE CONSTRAINTS;
DROP TABLE CLUB_FUTBOL CASCADE CONSTRAINTS;
DROP TABLE PUESTO CASCADE CONSTRAINTS;
DROP TABLE IDIOMA CASCADE CONSTRAINTS;
DROP TABLE NACIONALIDAD CASCADE CONSTRAINTS;
DROP TABLE ESCUELA_FUTBOL CASCADE CONSTRAINTS;
DROP TABLE ASOCIACION CASCADE CONSTRAINTS;
DROP TABLE COMUNA CASCADE CONSTRAINTS;
DROP TABLE REGION CASCADE CONSTRAINTS;
DROP TABLE PAIS CASCADE CONSTRAINTS;

DROP SEQUENCE SEQ_CLUB_FUTBOL;


--FASE 3

-- PAIS
CREATE TABLE PAIS (
    id_pais     INTEGER NOT NULL,
    nombre_pais VARCHAR2(25) NOT NULL,

    CONSTRAINT PAIS_PK
        PRIMARY KEY (id_pais)
);


-- ASOCIACION
CREATE TABLE ASOCIACION (
    codigo_asociacion INTEGER NOT NULL,
    nombre_asociacion VARCHAR2(50) NOT NULL,
    fecha_creacion    DATE NOT NULL,
    tipo              CHAR(1) NOT NULL,

    CONSTRAINT ASOCIACION_PK
        PRIMARY KEY (codigo_asociacion),

    CONSTRAINT ASOCIACION_FECHA_CK
        CHECK (fecha_creacion >= DATE '1980-12-31')
);

-- ESCUELA_FUTBOL
CREATE TABLE ESCUELA_FUTBOL (
    id_escuela      INTEGER NOT NULL,
    nombre_escuela  VARCHAR2(50) NOT NULL,
    capacidad       INTEGER NOT NULL,
    fecha_fundacion DATE NOT NULL,

    CONSTRAINT ESCUELA_FUTBOL_PK
        PRIMARY KEY (id_escuela)
);


-- IDIOMA
CREATE TABLE IDIOMA (
    nombre_idioma VARCHAR2(15) NOT NULL,
    id_idioma     INTEGER NOT NULL,

    CONSTRAINT IDIOMA_PK
        PRIMARY KEY (id_idioma)
);

-- PUESTO
CREATE TABLE PUESTO (
    id_puesto     INTEGER NOT NULL,
    nombre_puesto VARCHAR2(25) NOT NULL,

    CONSTRAINT PUESTO_PK
        PRIMARY KEY (id_puesto)
);

-- NACIONALIDAD
CREATE TABLE NACIONALIDAD (
    id_nacionalidad NUMBER
        GENERATED ALWAYS AS IDENTITY
        (START WITH 210 INCREMENT BY 2) NOT NULL,

    nombre_nacionalidad VARCHAR2(25) NOT NULL,

    CONSTRAINT NACIONALIDAD_PK
        PRIMARY KEY (id_nacionalidad)
);

-- CLUB FUTBOL
CREATE TABLE CLUB_FUTBOL (
    codigo_club INTEGER NOT NULL,
    nombre_club VARCHAR2(25) NOT NULL,
    patrimonio  NUMBER(15,2),
    direccion   VARCHAR2(50),
    tipo        VARCHAR2(15),

    CONSTRAINT CLUB_FUTBOL_PK
        PRIMARY KEY (codigo_club),

    CONSTRAINT CLUB_FUTBOL_UK
        UNIQUE (nombre_club)
);

CREATE SEQUENCE SEQ_CLUB_FUTBOL
    START WITH 703
    INCREMENT BY 4
    NOCACHE
    NOCYCLE;

-- REGION

CREATE TABLE REGION (
    id_region     INTEGER NOT NULL,
    nombre_region VARCHAR2(40) NOT NULL,
    PAIS_id_pais  INTEGER NOT NULL,

    CONSTRAINT REGION_PK
        PRIMARY KEY (id_region),

    CONSTRAINT REGION_PAIS_FK
        FOREIGN KEY (PAIS_id_pais)
        REFERENCES PAIS (id_pais)
);

-- COMUNA


CREATE TABLE COMUNA (
    id_comuna        INTEGER NOT NULL,
    nombre_comuna    VARCHAR2(30),
    REGION_id_region INTEGER NOT NULL,

    CONSTRAINT COMUNA_PK
        PRIMARY KEY (id_comuna),

    CONSTRAINT COMUNA_REGION_FK
        FOREIGN KEY (REGION_id_region)
        REFERENCES REGION (id_region)
);

-- TRABAJADOR
CREATE TABLE TRABAJADOR (
    codigo_inscripcion           INTEGER NOT NULL,
    rut                          VARCHAR2(12) NOT NULL,
    dv                           VARCHAR2(1) NOT NULL,
    p_nombre                     VARCHAR2(35) NOT NULL,
    s_nombre                     VARCHAR2(35),
    p_apellido                   VARCHAR2(35) NOT NULL,
    s_apellido                   VARCHAR2(35),
    sueldo_base                  NUMBER(12,2) NOT NULL,
    fecha_nacimiento             DATE NOT NULL,
    genero                       VARCHAR2(2) NOT NULL,
    estado_civil                 VARCHAR2(10),
    email                        VARCHAR2(50) NOT NULL,
    telefono_movil               VARCHAR2(15) NOT NULL,
    direccion                    VARCHAR2(50) NOT NULL,
    COMUNA_id_comuna             INTEGER NOT NULL,
    NACIONALIDAD_id_nacionalidad INTEGER NOT NULL,

    CONSTRAINT TRABAJADOR_PK
        PRIMARY KEY (codigo_inscripcion),

    CONSTRAINT TRABAJADOR_COMUNA_FK
        FOREIGN KEY (COMUNA_id_comuna)
        REFERENCES COMUNA (id_comuna),

    CONSTRAINT TRABAJADOR_NACIONALIDAD_FK
        FOREIGN KEY (NACIONALIDAD_id_nacionalidad)
        REFERENCES NACIONALIDAD (id_nacionalidad)
);

-- JUGADOR
CREATE TABLE JUGADOR (
    codigo_inscripcion           INTEGER NOT NULL,
    premio_acumulados            NUMBER(12,2) NOT NULL,
    ASOCIACION_codigo_asociacion INTEGER NOT NULL,
    PUESTO_id_puesto             INTEGER NOT NULL,
    año_salida_amateur           INTEGER,
    ESCUELA_FUTBOL_id_escuela    INTEGER,

    CONSTRAINT JUGADOR_PK
        PRIMARY KEY (codigo_inscripcion),

    CONSTRAINT JUGADOR_ASOCIACION_FK
        FOREIGN KEY (ASOCIACION_codigo_asociacion)
        REFERENCES ASOCIACION (codigo_asociacion),

    CONSTRAINT JUGADOR_ESCUELA_FUTBOL_FK
        FOREIGN KEY (ESCUELA_FUTBOL_id_escuela)
        REFERENCES ESCUELA_FUTBOL (id_escuela),

    CONSTRAINT JUGADOR_PUESTO_FK
        FOREIGN KEY (PUESTO_id_puesto)
        REFERENCES PUESTO (id_puesto),

    CONSTRAINT JUGADOR_TRABAJADOR_FK
        FOREIGN KEY (codigo_inscripcion)
        REFERENCES TRABAJADOR (codigo_inscripcion)
      
);

-- PERSONAL PLANTA

CREATE TABLE PERSONAL_PLANTA (
    codigo_inscripcion      INTEGER NOT NULL,
    horas_trabajadas        NUMBER(5,2),
    valor_horas_extras      NUMBER(12,2),
    CLUB_FUTBOL_codigo_club INTEGER NOT NULL,

    CONSTRAINT PERSONAL_PLANTA_PK
        PRIMARY KEY (codigo_inscripcion),

    CONSTRAINT PERSONAL_PLANTA_CLUB_FUTBOL_FK
        FOREIGN KEY (CLUB_FUTBOL_codigo_club)
        REFERENCES CLUB_FUTBOL (codigo_club),

    CONSTRAINT PERSONAL_PLANTA_TRABAJADOR_FK
        FOREIGN KEY (codigo_inscripcion)
        REFERENCES TRABAJADOR (codigo_inscripcion)
       
);

-- HISTORIAL JUGADOR

CREATE TABLE HISTORIAL_JUGADOR (
    id_historial               INTEGER NOT NULL,
    fecha_inicio               DATE NOT NULL,
    fecha_termino              DATE,
    CLUB_FUTBOL_codigo_club    INTEGER NOT NULL,
    JUGADOR_codigo_inscripcion INTEGER,

    CONSTRAINT HISTORIAL_JUGADOR_PK
        PRIMARY KEY (id_historial),

    CONSTRAINT HIST_JUG_CLUB_FK
        FOREIGN KEY (CLUB_FUTBOL_codigo_club)
        REFERENCES CLUB_FUTBOL (codigo_club),

    CONSTRAINT HISTORIAL_JUGADOR_JUGADOR_FK
        FOREIGN KEY (JUGADOR_codigo_inscripcion)
        REFERENCES JUGADOR (codigo_inscripcion)
);


-- NIVEL IDIOMA JUGADOR
CREATE TABLE JUG_NIV_IDIOMA (
    nivel_dominio              VARCHAR2(15) NOT NULL,
    IDIOMA_id_idioma           INTEGER NOT NULL,
    JUGADOR_codigo_inscripcion INTEGER NOT NULL,

    CONSTRAINT JUG_NIV_IDIOMA_PK
        PRIMARY KEY (IDIOMA_id_idioma, JUGADOR_codigo_inscripcion),

    CONSTRAINT JUG_NIV_IDIOMA_IDIOMA_FK
        FOREIGN KEY (IDIOMA_id_idioma)
        REFERENCES IDIOMA (id_idioma),

    CONSTRAINT JUG_NIV_IDIOMA_JUGADOR_FK
        FOREIGN KEY (JUGADOR_codigo_inscripcion)
        REFERENCES JUGADOR (codigo_inscripcion)
);


-- Fase poblamiento

INSERT INTO PAIS (id_pais, nombre_pais)
VALUES (1, 'CHILE');  -- NECESARIO POR OBLIGACION DE MI MODELO


-- REGION
INSERT INTO REGION (id_region, nombre_region, PAIS_id_pais)
VALUES (1, 'ARICA Y PARINACOTA Y TARAPACA', 1);

INSERT INTO REGION (id_region, nombre_region, PAIS_id_pais)
VALUES (2, 'ANTOFAGASTA', 1);

INSERT INTO REGION (id_region, nombre_region, PAIS_id_pais)
VALUES (3, 'ATACAMA Y COQUIMBO', 1);

INSERT INTO REGION (id_region, nombre_region, PAIS_id_pais)
VALUES (5, 'VALPARAISO', 1);

INSERT INTO REGION (id_region, nombre_region, PAIS_id_pais)
VALUES (8, 'BIOBIO', 1);

INSERT INTO REGION (id_region, nombre_region, PAIS_id_pais)
VALUES (13, 'METROPOLITANA', 1);


INSERT INTO REGION (id_region, nombre_region, PAIS_id_pais)
VALUES (16, 'NUBLE', 1);

COMMIT;


-- COMUNA
INSERT INTO COMUNA (id_comuna, nombre_comuna, REGION_id_region)
VALUES (101, 'Santiago', 13);

INSERT INTO COMUNA (id_comuna, nombre_comuna, REGION_id_region)
VALUES (102, 'Valparaíso', 5);

INSERT INTO COMUNA (id_comuna, nombre_comuna, REGION_id_region)
VALUES (103, 'Concepción', 8);

INSERT INTO COMUNA (id_comuna, nombre_comuna, REGION_id_region)
VALUES (104, 'Antofagasta', 2);

INSERT INTO COMUNA (id_comuna, nombre_comuna, REGION_id_region)
VALUES (105, 'Chillán', 16);

COMMIT;

-- ASOCIACION

INSERT INTO ASOCIACION
    (codigo_asociacion, nombre_asociacion, fecha_creacion, tipo)
VALUES
    (25, 'Asociación de Fútbol de Santiago', TO_DATE('15-05-2001','DD-MM-YYYY'), 'P');

INSERT INTO ASOCIACION
    (codigo_asociacion, nombre_asociacion, fecha_creacion, tipo)
VALUES
    (26, 'Asociación Nacional de Fútbol Amateur', TO_DATE('10-03-1998','DD-MM-YYYY'), 'A');

INSERT INTO ASOCIACION
    (codigo_asociacion, nombre_asociacion, fecha_creacion, tipo)
VALUES
    (27, 'Asociación de Fútbol de Valparaíso', TO_DATE('21-07-1987','DD-MM-YYYY'), 'P');

INSERT INTO ASOCIACION
    (codigo_asociacion, nombre_asociacion, fecha_creacion, tipo)
VALUES
    (28, 'Asociación de Fútbol de Concepción', TO_DATE('30-11-1995','DD-MM-YYYY'), 'A');

INSERT INTO ASOCIACION
    (codigo_asociacion, nombre_asociacion, fecha_creacion, tipo)
VALUES
    (29, 'Asociación de Fútbol de Antofagasta', TO_DATE('25-06-2003','DD-MM-YYYY'), 'P');

INSERT INTO ASOCIACION
    (codigo_asociacion, nombre_asociacion, fecha_creacion, tipo)
VALUES
    (30, 'Asociación de Fútbol de Temuco', TO_DATE('12-01-2010','DD-MM-YYYY'), 'A');

INSERT INTO ASOCIACION
    (codigo_asociacion, nombre_asociacion, fecha_creacion, tipo)
VALUES
    (31, 'Asociación de Fútbol de Rancagua', TO_DATE('08-09-1999','DD-MM-YYYY'), 'P');

INSERT INTO ASOCIACION
    (codigo_asociacion, nombre_asociacion, fecha_creacion, tipo)
VALUES
    (32, 'Asociación de Fútbol de Puerto Montt', TO_DATE('20-04-2005','DD-MM-YYYY'), 'A');

INSERT INTO ASOCIACION
    (codigo_asociacion, nombre_asociacion, fecha_creacion, tipo)
VALUES
    (33, 'Asociación de Fútbol de La Serena', TO_DATE('14-08-2012','DD-MM-YYYY'), 'P');

INSERT INTO ASOCIACION
    (codigo_asociacion, nombre_asociacion, fecha_creacion, tipo)
VALUES
    (34, 'Asociación de Fútbol de Chillán', TO_DATE('01-12-2018','DD-MM-YYYY'), 'A');

COMMIT;

-- NACIONALIDAD

INSERT INTO NACIONALIDAD (nombre_nacionalidad)
VALUES ('Chilena');

INSERT INTO NACIONALIDAD (nombre_nacionalidad)
VALUES ('Argentina');

INSERT INTO NACIONALIDAD (nombre_nacionalidad)
VALUES ('Peruana');

INSERT INTO NACIONALIDAD (nombre_nacionalidad)
VALUES ('Boliviana');

INSERT INTO NACIONALIDAD (nombre_nacionalidad)
VALUES ('Brasileña');

-- CLUBES

INSERT INTO CLUB_FUTBOL
    (codigo_club, nombre_club, patrimonio, direccion, tipo)
VALUES
    (SEQ_CLUB_FUTBOL.NEXTVAL,  'Colo-Colo',  500000000,  'Av. Marathon 5300',  'Profesional');

INSERT INTO CLUB_FUTBOL
    (codigo_club, nombre_club, patrimonio, direccion, tipo)
VALUES
    (SEQ_CLUB_FUTBOL.NEXTVAL, 'Universidad de Chile',450000000, 'Av. El Parrón 0931', 'Profesional');

INSERT INTO CLUB_FUTBOL
    (codigo_club, nombre_club, patrimonio, direccion, tipo)
VALUES
    (SEQ_CLUB_FUTBOL.NEXTVAL, 'Deportes Antofagasta', 180000000, 'Avenida Angamos 01606', 'Profesional');

INSERT INTO CLUB_FUTBOL
    (codigo_club, nombre_club, patrimonio, direccion, tipo)
VALUES
    (SEQ_CLUB_FUTBOL.NEXTVAL, 'Huachipato',220000000,'Avenida Desiderio García 909','Profesional');

INSERT INTO CLUB_FUTBOL
    (codigo_club, nombre_club, patrimonio, direccion, tipo)
VALUES
    (SEQ_CLUB_FUTBOL.NEXTVAL, 'Ñublense', 170000000,'Avenida Pedro Aguirre Cerda 1003','Profesional');

COMMIT;



-- FASE 4

-- INFORME 1

 SELECT
  'ID:' || codigo_asociacion AS ASOCIACION,nombre_asociacion AS asociacion, fecha_creacion AS CREADA, tipo AS TIPO
FROM ASOCIACION
WHERE tipo = 'P' AND fecha_creacion > DATE '2000-12-31'
ORDER BY fecha_creacion DESC;

-- INFORME 2
SELECT
    codigo_club AS CLUB,
    nombre_club AS "NOMBRE CLUB",
    patrimonio AS "PATRIMONIO EN PESOS",
    patrimonio / 955 AS "PATRIMONIO EN DOLARES"
FROM CLUB_FUTBOL
WHERE nombre_club LIKE '%a%'
  AND patrimonio > 200000000
  AND tipo = 'Profesional'
ORDER BY codigo_club DESC;


