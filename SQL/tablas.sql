CREATE TABLE TablaAnimal OF TipoAnimal
(
    CONSTRAINT PK_Animal PRIMARY KEY(IdAnimal),
    CONSTRAINT CE_NombreA CHECK (Nombre IS NOT NULL),
    CONSTRAINT CE_FechaNacimientoA CHECK (FechaNacimiento IS NOT NULL),
    CONSTRAINT CE_GeneroA CHECK (Genero IS NOT NULL),
    CONSTRAINT CE_EspecieA CHECK (Especie IS NOT NULL),
    CONSTRAINT CE_Fecha_llegadaA CHECK (FechaLlegada IS NOT NULL),
    CONSTRAINT CE_MicrochipA CHECK (Microchip IS NOT NULL),
    CONSTRAINT CE_CastradoA CHECK (Castrado IS NOT NULL),
    CONSTRAINT CE_VacunadoA CHECK (Vacunado IS NOT NULL)
);
/

CREATE TABLE TablaPersona OF TipoPersona
(
    CONSTRAINT PK_Persona PRIMARY KEY(IdPersona),
    CONSTRAINT CE_DNIP CHECK (DNI IS NOT NULL),
    CONSTRAINT CE_NombreP CHECK (Nombre IS NOT NULL),
    CONSTRAINT CE_ApellidosP CHECK (Apellidos IS NOT NULL),
    CONSTRAINT CE_TelefonoP CHECK (Telefono IS NOT NULL),
    CONSTRAINT CE_CorreoP CHECK (Correo IS NOT NULL)
);
/

CREATE TABLE TablaVoluntario OF TipoVoluntario
(
    CONSTRAINT FK_Voluntario FOREIGN KEY (IdPersona) REFERENCES TablaPersona(IdPersona)
);
/

CREATE TABLE TablaSocio OF TipoSocio
(
    CONSTRAINT FK_Socio FOREIGN KEY (IdPersona) REFERENCES TablaPersona(IdPersona)
);
/

CREATE TABLE TablaAdoptante OF TipoAdoptante
(
    CONSTRAINT FK_Adoptante FOREIGN KEY (IdPersona) REFERENCES TablaPersona(IdPersona)
);
/

CREATE TABLE TablaAdministrador OF TipoAdministrador
(
    CONSTRAINT FK_Administrador FOREIGN KEY (IdPersona) REFERENCES TablaPersona(IdPersona)
);
/

CREATE TABLE TablaRegistroWeb OF TipoRegistroWeb
(
    CONSTRAINT FK_RegistroWeb FOREIGN KEY (IdPersona) REFERENCES TablaPersona(IdPersona),
    CONSTRAINT FK_RegistroWeb2 FOREIGN KEY (IdAnimal) REFERENCES TablaAnimal(IdAnimal)
);
/