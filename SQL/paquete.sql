--Paquete para todas las funciones y procedimientos
CREATE OR REPLACE PACKAGE PaqueteGlobal AS
    FUNCTION FAnimalAcogido(para_IdAnimal IN NUMBER) RETURN NUMBER;
    FUNCTION FAnimalAdoptado(para_IdAnimal IN NUMBER) RETURN NUMBER;
    FUNCTION FSumaCuotasMensuales RETURN NUMBER;
    FUNCTION EsAdmin(para_IdPersona IN NUMBER, para_contrasena IN VARCHAR2) RETURN NUMBER;
    FUNCTION EsAdmin2(para_IdPersona IN NUMBER) RETURN NUMBER;
    FUNCTION EsPersona(para_IdPersona IN NUMBER) RETURN NUMBER;
    FUNCTION EsSocio(para_IdPersona IN NUMBER) RETURN NUMBER;

    PROCEDURE AcogerAnimal(para_IdPersona IN NUMBER, para_IdAnimal IN NUMBER, FechaAcogidaEmpezada IN DATE);
    PROCEDURE AdoptarAnimal(para_IdPersona IN NUMBER, para_IdAnimal IN NUMBER, FechaAdopcion IN DATE);
    PROCEDURE FinalizarAcogidaAnimal(para_IdPersona IN NUMBER, para_IdAnimal IN NUMBER, para_FechaAcogidaFinalizada IN DATE);
    PROCEDURE DarDeAltaPersona(para_DNI IN VARCHAR2, para_Nombre IN VARCHAR2, para_Apellidos IN VARCHAR2, para_Telefono IN VARCHAR2, para_Correo IN VARCHAR2);
    PROCEDURE DarDeAltaAnimal(para_Nombre IN VARCHAR2,para_FechaNacimiento IN DATE, para_Genero IN VARCHAR2, para_Especie IN VARCHAR2, para_Fecha_llegada IN DATE, para_Descripcion IN VARCHAR2, para_Microchip IN VARCHAR2, para_Castrado IN VARCHAR2, para_Vacunado IN VARCHAR2, para_Foto IN BLOB);
    PROCEDURE CrearSocio(para_IdPersona IN NUMBER,para_CuentaBancaria IN VARCHAR2, para_Cuota IN NUMBER);
    PROCEDURE ActualizarCuotaSocio(para_IdPersona IN NUMBER, para_Cuota IN NUMBER);
    PROCEDURE DarDeBajaSocio(para_IdPersona IN NUMBER);
    PROCEDURE DarDeAltaAdministrador(para_IdPersona IN NUMBER, para_Contrasena IN VARCHAR2);
    PROCEDURE ActualizarAdministrador(para_IdPersona IN NUMBER,para_Contrasena IN VARCHAR2);
    PROCEDURE DarDeBajaAdministrador(para_IdPersona IN NUMBER);
END;
/

CREATE OR REPLACE PACKAGE BODY PaqueteGlobal AS
    FUNCTION FAnimalAcogido(para_IdAnimal IN NUMBER) RETURN NUMBER 
    IS
    n NUMBER;
    BEGIN
        SELECT COUNT(*) into n FROM TablaVoluntario v WHERE v.AcogeId = para_IdAnimal AND (v.FechaAcogidaFinalizada IS NULL OR v.FechaAcogidaFinalizada > SYSDATE);
        return n;
    END;
    
    FUNCTION FAnimalAdoptado(para_IdAnimal IN NUMBER) RETURN NUMBER 
    IS
    n NUMBER;
    BEGIN
        SELECT COUNT(*) INTO n FROM TablaAdoptante a WHERE a.AdoptaId = para_IdAnimal AND a.FechaAdopcion IS NOT NULL;
        return n;
    END;

    FUNCTION FSumaCuotasMensuales RETURN NUMBER 
    IS
    nSumaCuotasMensuales NUMBER;
    BEGIN
        SELECT SUM(CuotaMensual) INTO nSumaCuotasMensuales FROM TablaSocio;
        RETURN nSumaCuotasMensuales;
    END;

    FUNCTION EsAdmin(para_IdPersona IN NUMBER, para_contrasena IN VARCHAR2) RETURN NUMBER
    IS
        n NUMBER;
    BEGIN
        SELECT COUNT(*) INTO n FROM TABLAADMINISTRADOR WHERE idPersona = para_IdPersona AND Contrasena = para_contrasena;

        RETURN n;
    END;

    FUNCTION EsAdmin2(para_IdPersona IN NUMBER) RETURN NUMBER
    IS
        n NUMBER;
    BEGIN
        SELECT COUNT(*) INTO n FROM TABLAADMINISTRADOR WHERE idPersona = para_IdPersona;

        RETURN n;
    END;

    FUNCTION EsPersona(para_IdPersona IN NUMBER) RETURN NUMBER
    IS
        n NUMBER;
    BEGIN
        SELECT COUNT(*) INTO n FROM TablaPersona WHERE idPersona = para_IdPersona;

        RETURN n;
    END;
    FUNCTION EsSocio(para_IdPersona IN NUMBER) RETURN NUMBER
    IS
        n NUMBER;
    BEGIN
        SELECT COUNT(*) INTO n FROM TablaSocio WHERE idPersona = para_IdPersona;

        RETURN n;
    END;


    PROCEDURE AcogerAnimal(para_IdPersona IN NUMBER, para_IdAnimal IN NUMBER, FechaAcogidaEmpezada IN DATE) IS
    n1 NUMBER;
    n2 NUMBER;
    n3 NUMBER;
    AnimalYaAcogido EXCEPTION;
    AnimalYaAdoptado EXCEPTION;
    NoRegistrado EXCEPTION;
    BEGIN
        n1:= FAnimalAcogido(para_IdAnimal);
        n2:= FAnimalAdoptado(para_IdAnimal);
        n3:= EsPersona(para_IdPersona);
        IF(n1 > 0) THEN
            RAISE AnimalYaAcogido;
        ELSIF(n2 > 0) THEN
            RAISE AnimalYaAdoptado;
        ELSIF(n3 = 0) THEN
            RAISE NoRegistrado;
        ELSE    
            INSERT INTO TablaVoluntario (IdPersona,AcogeId,FechaAcogidaEmpezada,FechaAcogidaFinalizada) VALUES (para_IdPersona, para_IdAnimal, FechaAcogidaEmpezada, NULL);
        END IF;

    EXCEPTION
        
        WHEN AnimalYaAcogido THEN
            DBMS_OUTPUT.PUT_LINE('El animal se encuentra acogido por otro voluntario');
            RAISE_APPLICATION_ERROR(-20500,'El animal se encuentra acogido por otro voluntario');
        WHEN AnimalYaAdoptado THEN
            DBMS_OUTPUT.PUT_LINE('El animal ya ha sido adoptado');
            RAISE_APPLICATION_ERROR(-20501,'El animal ya ha sido adoptado');
        WHEN NoRegistrado THEN
            DBMS_OUTPUT.PUT_LINE('La persona no esta registrada');
            RAISE_APPLICATION_ERROR(-20509,'La persona no esta registrada');
    END;

    PROCEDURE AdoptarAnimal(para_IdPersona IN NUMBER, para_IdAnimal IN NUMBER, FechaAdopcion IN DATE) IS
    n1 NUMBER;
    n2 NUMBER;
    n3 NUMBER;
    AnimalYaAdoptado EXCEPTION;
    NoRegistrado EXCEPTION;
    BEGIN
        n1:= FAnimalAcogido(para_IdAnimal);
        n2:= FAnimalAdoptado(para_IdAnimal);
        n3:= EsPersona(para_IdPersona);
        IF(n1 > 0) THEN
            UPDATE TablaVoluntario SET FechaAcogidaFinalizada = FechaAdopcion WHERE acogeId = para_idAnimal;
            INSERT INTO TablaAdoptante (IdPersona,AdoptaId,FechaAdopcion) VALUES (para_IdPersona, para_IdAnimal, FechaAdopcion);
        ELSIF(n2 > 0) THEN
            RAISE AnimalYaAdoptado;
        ELSIF(n3 = 0) THEN
            RAISE NoRegistrado;
        ELSE    
            INSERT INTO TablaAdoptante (IdPersona,AdoptaId,FechaAdopcion) VALUES (para_IdPersona, para_IdAnimal, FechaAdopcion);
        END IF;
    EXCEPTION
        WHEN AnimalYaAdoptado THEN
            DBMS_OUTPUT.PUT_LINE('El animal ya ha sido adoptado');
            RAISE_APPLICATION_ERROR(-20501,'El animal ya ha sido adoptado');
        WHEN NoRegistrado THEN
            DBMS_OUTPUT.PUT_LINE('La persona no esta registrada');
            RAISE_APPLICATION_ERROR(-20509,'La persona no esta registrada');
    END;

    PROCEDURE FinalizarAcogidaAnimal(para_IdPersona IN NUMBER, para_IdAnimal IN NUMBER, para_FechaAcogidaFinalizada IN DATE) IS
    n1 NUMBER;
    n2 NUMBER;
    FechaAdop DATE;
    AnimalNoAcogido EXCEPTION;
    AnimalYaAdoptado EXCEPTION;
    BEGIN
        SELECT COUNT(*) INTO n1 FROM TablaVoluntario v WHERE v.IdPersona = para_IdPersona AND v.AcogeId = para_IdAnimal AND v.FechaAcogidaFinalizada IS NULL;
        SELECT COUNT(*) INTO n2 FROM TablaAdoptante a WHERE a.AdoptaId = para_IdAnimal AND a.FechaAdopcion IS NOT NULL;
        IF(n2 > 0) THEN
            SELECT FechaAdopcion INTO FechaAdop FROM TablaAdoptante a WHERE a.AdoptaId = para_IdAnimal AND a.FechaAdopcion IS NOT NULL;
            IF (para_FechaAcogidaFinalizada < FechaAdop) THEN
                UPDATE TablaVoluntario SET FechaAcogidaFinalizada = para_FechaAcogidaFinalizada WHERE acogeId = para_idAnimal;
            ELSE
                UPDATE TablaVoluntario SET FechaAcogidaFinalizada = FechaAdop WHERE acogeId = para_idAnimal;
                RAISE AnimalYaAdoptado;
            END IF;
        ELSIF(n1 = 0) THEN
            RAISE AnimalNoAcogido;
        ELSE    
            UPDATE TablaVoluntario SET FechaAcogidaFinalizada = para_FechaAcogidaFinalizada WHERE acogeId = para_idAnimal AND IdPersona = para_IdPersona AND FechaAcogidaFinalizada IS NULL;
        END IF;
    EXCEPTION
        WHEN AnimalNoAcogido THEN
            DBMS_OUTPUT.PUT_LINE('El animal no se encuentra acogido');
            RAISE_APPLICATION_ERROR(-20503,'El animal no estaba acogido por la persona');
        WHEN AnimalYaAdoptado THEN
            DBMS_OUTPUT.PUT_LINE('El animal ya ha sido adoptado y ya no se encontrara acogido para ese entonces');
            RAISE_APPLICATION_ERROR(-20501,'El animal ya ha sido adoptado');          
    END;

    PROCEDURE DarDeAltaPersona(para_DNI IN VARCHAR2, para_Nombre IN VARCHAR2, para_Apellidos IN VARCHAR2, para_Telefono IN VARCHAR2, para_Correo IN VARCHAR2) IS
    n1 NUMBER;
    PersonaYaExiste EXCEPTION;
    BEGIN
        SELECT COUNT(*) INTO n1 FROM TablaPersona p WHERE p.DNI = para_DNI;
        IF(n1 > 0) THEN
            RAISE PersonaYaExiste;
        ELSE
            INSERT INTO TablaPersona (IdPersona,DNI,Nombre,Apellidos,Telefono,FechaAlta,Correo) VALUES (secIdPersona.nextval, para_DNI, para_Nombre, para_Apellidos, para_Telefono, SYSDATE, para_Correo);
        END IF;
    EXCEPTION
        WHEN PersonaYaExiste THEN
            DBMS_OUTPUT.PUT_LINE('La persona ya existe');
            RAISE_APPLICATION_ERROR(-20504,'La persona ya existe');
    END;

    PROCEDURE DarDeAltaAnimal(para_Nombre IN VARCHAR2,para_FechaNacimiento IN DATE, para_Genero IN VARCHAR2, para_Especie IN VARCHAR2, para_Fecha_llegada IN DATE, para_Descripcion IN VARCHAR2, para_Microchip IN VARCHAR2, para_Castrado IN VARCHAR2, para_Vacunado IN VARCHAR2, para_Foto IN BLOB) IS
    n1 NUMBER;
    AnimalYaExiste EXCEPTION;
    BEGIN
        SELECT COUNT(*) INTO n1 FROM TablaAnimal a WHERE a.Nombre = para_Nombre AND a.FechaNacimiento = para_FechaNacimiento;
        IF(n1 > 0) THEN
            RAISE AnimalYaExiste;
        ELSE
            INSERT INTO TablaAnimal (IdAnimal,Nombre,FechaNacimiento,Genero,Especie,FechaLlegada,Descripcion,Microchip,Castrado,Vacunado,Foto) VALUES (secIdAnimal.nextval, para_Nombre, para_FechaNacimiento, para_Genero, para_Especie, para_Fecha_llegada, para_Descripcion, para_Microchip, para_Castrado, para_Vacunado, para_Foto);
        END IF;
    EXCEPTION
        WHEN AnimalYaExiste THEN
            DBMS_OUTPUT.PUT_LINE('El animal ya existe');
            RAISE_APPLICATION_ERROR(-20505,'El animal ya existe');
    END;

    PROCEDURE CrearSocio(para_IdPersona IN NUMBER,para_CuentaBancaria IN VARCHAR2, para_Cuota IN NUMBER) IS
    n1 NUMBER;
    PersonaYaEsSocio EXCEPTION;
    BEGIN
        n1 := EsSocio(para_IdPersona);
        IF(n1 > 0) THEN
            RAISE PersonaYaEsSocio;
        ELSE
            INSERT INTO TablaSocio (IdPersona,CuentaBancaria,CuotaMensual,FechaAltaSocio) VALUES (para_IdPersona,para_CuentaBancaria, para_Cuota, SYSDATE);
        END IF;
    EXCEPTION
        WHEN PersonaYaEsSocio THEN
            DBMS_OUTPUT.PUT_LINE('La persona ya es socio');
            RAISE_APPLICATION_ERROR(-20506,'La persona ya es socio');
    END;

    PROCEDURE ActualizarCuotaSocio(para_IdPersona IN NUMBER, para_Cuota IN NUMBER) IS
    n1 NUMBER;
    PersonaNoEsSocio EXCEPTION;
    BEGIN
        n1 := EsSocio(para_IdPersona);
        IF(n1 = 0) THEN
            RAISE PersonaNoEsSocio;
        ELSE
            UPDATE TablaSocio SET CuotaMensual = para_Cuota WHERE IdPersona = para_IdPersona;
        END IF;
    EXCEPTION
        WHEN PersonaNoEsSocio THEN
            DBMS_OUTPUT.PUT_LINE('La persona no es socio');
            RAISE_APPLICATION_ERROR(-20507,'La persona no es socio');
    END;

    PROCEDURE DarDeBajaSocio(para_IdPersona IN NUMBER) IS
    n1 NUMBER;
    PersonaNoEsSocio EXCEPTION;
    BEGIN
        n1 := EsSocio(para_IdPersona);
        IF(n1 = 0) THEN
            RAISE PersonaNoEsSocio;
        ELSE
            DELETE FROM TablaSocio WHERE IdPersona = para_IdPersona;
        END IF;
    EXCEPTION
        WHEN PersonaNoEsSocio THEN
            DBMS_OUTPUT.PUT_LINE('La persona no es socio');
            RAISE_APPLICATION_ERROR(-20507,'La persona no es socio');
    END;

    PROCEDURE DarDeAltaAdministrador(para_IdPersona IN NUMBER, para_Contrasena IN VARCHAR2) IS
    n1 NUMBER;
    n2 NUMBER;
    AdminYaExiste EXCEPTION;
    NoRegistrado EXCEPTION;
    BEGIN
        n1 := EsAdmin2(para_IdPersona);
        n2 := EsPersona(para_IdPersona);
        IF(n1 > 0) THEN
            RAISE AdminYaExiste;
        ELSIF(n2 = 0) THEN
            RAISE NoRegistrado;
        ELSE
            INSERT INTO TablaAdministrador (IdPersona,Contrasena,FechaAltaAdmin) VALUES (para_IdPersona, para_Contrasena, SYSDATE);
        END IF;
    EXCEPTION
        WHEN AdminYaExiste THEN
            DBMS_OUTPUT.PUT_LINE('El admin ya existe');
            RAISE_APPLICATION_ERROR(-20508,'El admin ya existe');
        WHEN NoRegistrado THEN
            DBMS_OUTPUT.PUT_LINE('La persona no esta registrada');
            RAISE_APPLICATION_ERROR(-20509,'La persona no esta registrada');
    END;

    PROCEDURE ActualizarAdministrador(para_IdPersona IN NUMBER,para_Contrasena IN VARCHAR2) IS
    n1 NUMBER;
    n2 NUMBER;
    AdminNoExiste EXCEPTION;
    NoRegistrado EXCEPTION;
    BEGIN
        n1 := EsAdmin2(para_IdPersona);
        n2 := EsPersona(para_IdPersona);
        IF(n1 = 0) THEN
            RAISE AdminNoExiste;
        ELSIF(n2 = 0) THEN
            RAISE NoRegistrado;
        ELSE
            UPDATE TABLAADMINISTRADOR SET Contrasena = para_Contrasena WHERE IdPersona = para_IdPersona;
        END IF;
    EXCEPTION
        WHEN AdminNoExiste THEN
            DBMS_OUTPUT.PUT_LINE('El admin No existe');
            RAISE_APPLICATION_ERROR(-20510,'El admin No existe');
        WHEN NoRegistrado THEN
            DBMS_OUTPUT.PUT_LINE('La persona no esta registrada');
            RAISE_APPLICATION_ERROR(-20509,'La persona no esta registrada');
    END;

    PROCEDURE DarDeBajaAdministrador(para_IdPersona IN NUMBER) IS
    n1 NUMBER;
    n2 NUMBER;
    AdminNoExiste EXCEPTION;
    NoRegistrado EXCEPTION;
    BEGIN
        n1 := EsAdmin2(para_IdPersona);
        n2 := EsPersona(para_IdPersona);
        IF(n1 = 0) THEN
            RAISE AdminNoExiste;
        ELSIF(n2 = 0) THEN
            RAISE NoRegistrado;
        ELSE
            DELETE FROM TABLAADMINISTRADOR WHERE IdPersona = para_IdPersona;
        END IF;
    EXCEPTION
        WHEN AdminNoExiste THEN
            DBMS_OUTPUT.PUT_LINE('El admin No existe');
            RAISE_APPLICATION_ERROR(-20510,'El admin No existe');
        WHEN NoRegistrado THEN
            DBMS_OUTPUT.PUT_LINE('La persona no esta registrada');
            RAISE_APPLICATION_ERROR(-20509,'La persona no esta registrada');
    END;

END;
/
