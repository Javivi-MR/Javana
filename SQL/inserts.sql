INSERT INTO TablaAnimal VALUES (secIdAnimal.NEXTVAL,'Bola de Nieve',TO_DATE('01/01/2023', 'dd/mm/yyyy'),'Femenino','Felino',SYSDATE,'Una tricolor algo glotona. Se lleva bien con gatos y perros.','SI','SI','SI',EMPTY_BLOB());
INSERT INTO TablaAnimal VALUES (secIdAnimal.NEXTVAL,'Elvis',TO_DATE('15/01/2023', 'dd/mm/yyyy'),'Masculino','Felino',SYSDATE,'A Botas le gusta hablar. Simpático y juguetón, es un adorable gato deseoso de mimos.','SI','SI','SI',EMPTY_BLOB());
INSERT INTO TablaAnimal VALUES (secIdAnimal.NEXTVAL,'Nala',TO_DATE('03/01/2023', 'dd/mm/yyyy'),'Femenino','Canino',SYSDATE,'Le encante los juguetes y corretear por los jardines.','SI','SI','SI',EMPTY_BLOB());
INSERT INTO TablaAnimal VALUES (secIdAnimal.NEXTVAL,'Toy',TO_DATE('16/01/2023', 'dd/mm/yyyy'),'Masculino','Canino',SYSDATE,'Algo torpe cuando tiene mucha energia. Muy amigable con los niños.','SI','SI','SI',EMPTY_BLOB());
INSERT INTO TablaAnimal VALUES (secIdAnimal.NEXTVAL,'Bellota',TO_DATE('16/01/2023', 'dd/mm/yyyy'),'Masculino','Roedor',SYSDATE,'Ardilla sociable y cañera.','SI','SI','SI',EMPTY_BLOB());

--ahora insertamos en la tabla de personas ahora con fecha de alta
INSERT INTO TablaPersona VALUES (secIdPersona.NEXTVAL,'12345678A','Juan','Perez','123456789',SYSDATE,'juan@gmail.com');

--ahora insertamos en la tabla de administrador
INSERT INTO TablaAdministrador VALUES (1,'admin',TO_DATE('16/01/2023', 'dd/mm/yyyy'));