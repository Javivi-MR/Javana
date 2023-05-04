CREATE OR REPLACE TYPE TipoAnimal AS OBJECT(
    IdAnimal NUMBER,
    Nombre VARCHAR2(50),
    FechaNacimiento DATE,
    Genero VARCHAR2(12),
    Especie VARCHAR2(50),
    FechaLlegada DATE,
    Descripcion VARCHAR2(100),
    Microchip VARCHAR2(2),
    Castrado VARCHAR2(2),
    Vacunado VARCHAR2(2),
    Foto BLOB
);
/

CREATE OR REPLACE TYPE TipoPersona AS OBJECT(
    IdPersona NUMBER,
    DNI VARCHAR2(9),
    Nombre VARCHAR2(50),
    Apellidos VARCHAR2(50),
    Telefono VARCHAR2(9),
    FechaAlta DATE,
    Correo VARCHAR2(50)
);
/

CREATE OR REPLACE TYPE TipoVoluntario AS OBJECT(
    IdPersona NUMBER,
    AcogeId  NUMBER,
    FechaAcogidaEmpezada DATE,
    FechaAcogidaFinalizada DATE
);
/


CREATE OR REPLACE TYPE TipoSocio AS OBJECT(
    IdPersona NUMBER,
    CuentaBancaria VARCHAR2(24),
    CuotaMensual NUMBER(5,2),
    FechaAltaSocio DATE
);
/

CREATE OR REPLACE TYPE TipoAdoptante AS OBJECT(
    IdPersona NUMBER,
    FechaAdopcion DATE,
    AdoptaId NUMBER
);
/

CREATE OR REPLACE TYPE TipoAdministrador AS OBJECT(
    IdPersona NUMBER,
    Contrasena VARCHAR2(50),
    FechaAltaAdmin DATE
);
/

CREATE OR REPLACE TYPE TipoRegistroWeb AS OBJECT(
    FechaRegistro DATE,
    Accion VARCHAR2(100),
    IdPersona NUMBER,
    IdAnimal NUMBER,
    Cuota NUMBER(5,2)
);
/