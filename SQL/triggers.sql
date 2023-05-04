CREATE OR REPLACE TRIGGER RegistroPersonasT  --Creamos trigger
AFTER INSERT OR UPDATE OR DELETE ON TablaPersona FOR EACH ROW  --Despues de que se inserte un registro de la tabla TablaPersona 
DECLARE
BEGIN
    IF INSERTING THEN --Cuando se inserte una fila:
        INSERT INTO TablaRegistroWeb (FechaRegistro, Accion, IdPersona, IdAnimal, Cuota) VALUES (SYSDATE, 'Se ha registrado una nueva persona en el sistema', :NEW.IdPersona, NULL, NULL); --Insertamos en la tabla TablaRegistroWeb los datos de la persona insertada
    END IF;
EXCEPTION -- Apartado de excepciones
    -- Al tratarse de un trigger con solo operaciones insert, no existen muchas excepciones que se puedan dar.
    -- por lo que decidimos que si se produce una excepcion no esperada, se muestre un mensaje de error.
    WHEN OTHERS THEN    -- Cuando ocurra una excepcion no esperada 
        DBMS_OUTPUT.PUT_LINE('Ha ocurrido un error, revisa tu operacion y comprueba que los datos son correctos'); --Mostramos un mensaje de error

END;
/

-- trigger para insertar en la tabla TablaRegistroWeb cuando se inserte, actualice o borre un registro de la tabla TablaSocio
CREATE OR REPLACE TRIGGER RegistroSociosT
AFTER INSERT OR UPDATE OR DELETE ON TablaSocio FOR EACH ROW
DECLARE
BEGIN
    IF INSERTING THEN
        INSERT INTO TablaRegistroWeb (FechaRegistro, Accion, IdPersona, IdAnimal, Cuota) VALUES (SYSDATE, 'Se ha registrado un nuevo socio en el sistema', :NEW.IdPersona, NULL, :NEW.CuotaMensual);

    ELSIF UPDATING THEN
        INSERT INTO TablaRegistroWeb (FechaRegistro, Accion, IdPersona, IdAnimal, Cuota) VALUES (SYSDATE, 'Se ha actualizado un socio en el sistema', :NEW.IdPersona, NULL, :NEW.CuotaMensual);

    ELSIF DELETING THEN
        INSERT INTO TablaRegistroWeb (FechaRegistro, Accion, IdPersona, IdAnimal, Cuota) VALUES (SYSDATE, 'Se ha borrado un socio en el sistema', :OLD.IdPersona, NULL, NULL);

    END IF;

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Ha ocurrido un error, revisa tu operacion y comprueba que los datos son correctos');
        
END;
/

-- trigger para insertar en la tabla TablaRegistroWeb cuando se inserteun registro de la TablaAdoptante
CREATE OR REPLACE TRIGGER RegistroAdoptantesT
AFTER INSERT ON TablaAdoptante FOR EACH ROW
DECLARE
BEGIN
    INSERT INTO TablaRegistroWeb (FechaRegistro, Accion, IdPersona, IdAnimal, Cuota) VALUES (SYSDATE, 'Se ha registrado un nuevo adoptante en el sistema', :NEW.IdPersona, :NEW.AdoptaId, NULL);

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Ha ocurrido un error, revisa tu operacion y comprueba que los datos son correctos');

END;
/

-- trigger para insertar en la tabla TablaRegistroWeb cuando se inserte un registro de la TablaVoluntario
CREATE OR REPLACE TRIGGER RegistroVoluntariosT
AFTER INSERT OR UPDATE OR DELETE ON TablaVoluntario FOR EACH ROW
DECLARE
BEGIN
    IF INSERTING THEN
        INSERT INTO TablaRegistroWeb (FechaRegistro, Accion, IdPersona, IdAnimal, Cuota) VALUES (SYSDATE, 'Se ha registrado un nuevo voluntario en el sistema', :NEW.IdPersona, :NEW.AcogeId, NULL);
    END IF;

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Ha ocurrido un error, revisa tu operacion y comprueba que los datos son correctos');

END;
/

-- trigger para insertar en la tabla TablaRegistroWeb cuando se inserte, actualice o borre un registro de la tabla tablaadministrador
CREATE OR REPLACE TRIGGER RegistroAdministradoresT
AFTER INSERT OR UPDATE OR DELETE ON TablaAdministrador FOR EACH ROW
BEGIN   
    IF INSERTING THEN
        INSERT INTO TablaRegistroWeb (FechaRegistro, Accion, IdPersona, IdAnimal, Cuota) VALUES (SYSDATE, 'Se ha registrado un nuevo administrador en el sistema', :NEW.IdPersona, NULL, NULL);

    ELSIF UPDATING THEN
        INSERT INTO TablaRegistroWeb (FechaRegistro, Accion, IdPersona, IdAnimal, Cuota) VALUES (SYSDATE, 'Se ha actualizado un administrador en el sistema', :NEW.IdPersona, NULL, NULL);

    ELSIF DELETING THEN
        INSERT INTO TablaRegistroWeb (FechaRegistro, Accion, IdPersona, IdAnimal, Cuota) VALUES (SYSDATE, 'Se ha borrado un administrador en el sistema', :OLD.IdPersona, NULL, NULL);

    END IF;

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Ha ocurrido un error, revisa tu operacion y comprueba que los datos son correctos');

END;
/