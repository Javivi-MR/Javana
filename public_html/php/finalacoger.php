<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="author" content="MindMeetings">
    <meta name="description" content="Mindmeetings es la web con la que podras realizar reserva para salas de estudio, recreo...">
    <meta name="keywords" content="Reserva, salas, estudio, recreo, reuniones, conferencias, cursos, eventos">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Finaliza tu acogida</title>
    <link rel="stylesheet" type="text/css" href="../css/general.css">
    <link rel="stylesheet" type="text/css" href="../css/adoptar.css">
    <link rel="stylesheet" href="//code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css">
    <script src="https://code.jquery.com/jquery-1.12.4.js"></script>
    <script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>
    <script src="../js/CambiarInfo.js"></script>
    <script src="../js/SeleccionFecha.js"></script>
</head>
<body>
    <header id="Main-Header">  <!-- Encabezado de la pagina (Reservado para la barra de navegacion principal)-->
        <nav class="BarraNavDiv">
            <div class="ImagenLogoDiv">
                <a href="../index.html" aria-label="Imagen del logo"> <!-- Link para la imagen del logo -->
                    <img src="../images/logo.png" alt="Imagen del logo" class="ImagenLogo" height="100">
                </a>
            </div>
            <ul class="ListaBarraNav"> <!-- -Lista de opciones de la barra de navegacion -->
                <li> <a href="../index.html" class="ElementoBarraNav" aria-label="Inicio">Inicio</a></li> <!-- Opcion Inicio -->
                <li> <a href="../registro.html" class="ElementoBarraNav" aria-label="Registrarse">Registrarse</a></li>
                <li> <a href="./adoptar.php" class="ElementoBarraNav" aria-label="Salas">Adoptar</a></li>  <!-- Opcion Salas -->
                <li> <a href="../socios.html" class="ElementoBarraNav" aria-label="Reservar">Socio</a></li> <!-- Opcion Reservar -->
                <li> <a href="../colaborar.html" class="ElementoBarraNav" aria-label="Contacto">Colaborar</a></li> <!-- Opcion Contacto -->
            </ul>
        </nav>
    </header>   <!-- FIN Encabezado de la pagina -->

    <main>  <!-- Cuerpo de la pagina (añadir ultimas conferencias y porque nosotros) -->
        <div class="TituloDiv">
            <h2>Pon una fecha de finalizacion de acogida a un animal: </h2>
        </div>
        <div class="BloquePrincipalDiv">
            <div class="ImagenInfoDiv"> <!-- Div para la imagen e info-->
                <div class="ImagenDiv"> <!-- Div para la imagen-->
                    <img src="../images/Acogida.png" alt="sala1img" id="ImagenSala">
                </div>
                <div class="TextoInfDiv">   <!-- Div para el texto inferior a la imagen -->
                    <p id="inf1">¡Registrate en el sistema para poder realizar acciones!</p>
                    <p id="inf2"></p>
                </div>
            </div>
            <div class="TituloFormularioDiv">     <!-- Div para el formulario -->
                <div class="TituloFormDiv"> <!-- Div para el formulario y titulo de la sala -->
                    <h3 id="TituloSala">Formulario de adopción</h3>   <!-- Titulo de la sala -->
                </div>    
                <div class="FormularioDiv">
                    <form action="./finalacogido.php" method="POST" id="formulario" onsubmit="return DatosValidos()"> <!-- ¡CUIDADO! reservado.html está puesto como algo meramente ilustrativo, hay que preguntar que poner -->
                        <div class="InputDiv">
                            <label for="Id">Id Registro:</label>
                            <input type="text" name="Id" size="30" id="Id" required> <!-- Introducir Nombre -->
                        </div>
                        <div class="InputDiv">
                            <label for="DNI">DNI:</label>
                            <input type="text" name="DNI" size="30" id="DNI" required>   <!-- Introducir Apellidos -->
                        </div>
                        <div class="InputDiv">
                            <label for="Fecha">Fecha de finalizacion:</label>
                            <input type="text" name="Fecha" size="30" id="Fecha" required>   <!-- Introducir Apellidos -->
                        </div>
                        <div class="InputDiv">
                            <label for="animales">Animal Acogido:</label>
                            <select name="animales" id="animales">
                    <?php
                        $db_user = 'javivimol';
                        $db_pass = 'admin';
                        $db_conn_str = '(DESCRIPTION=(ADDRESS_LIST=(ADDRESS=(PROTOCOL=TCP)(HOST=localhost)(PORT=1521)))(CONNECT_DATA=(SERVICE_NAME=XEPDB1)))';
                              
                        // Establecer la conexión
                        $conn = oci_connect($db_user, $db_pass, $db_conn_str);
                        echo"entra";
                    
                        // Verificar si la conexión fue exitosa
                        if (!$conn) 
                        {
                            $err = oci_error();
                            trigger_error(htmlentities($err['message'], ENT_QUOTES), E_USER_ERROR);
                        }
                        else
                        {
                            
                            $plsql = "SELECT IdAnimal, Nombre FROM TablaAnimal WHERE IdAnimal IN (SELECT AcogeId FROM TablaVoluntario WHERE FECHAACOGIDAFINALIZADA IS NULL)";

                            $stmt = oci_parse($conn, $plsql);

                            // Ejecutar la consulta
                            $flag2 = oci_execute($stmt);

                            while ($row = oci_fetch_array($stmt, OCI_ASSOC+OCI_RETURN_NULLS))
                            {
                                foreach ($row as $item)
                                {
                                    if (is_object($item) && get_class($item) === 'OCILob') {
                                        // Si el valor es un objeto OCILob, cargar los datos en una variable string y mostrarla
                                        //si el valor es un numero
                                        if(is_numeric($item))
                                        {
                                            $data = $item->load();
                                            $resultado = "<option value='$data'>";
                                        }
                                        else
                                        {
                                            $data = $item->load();
                                            $resultado .= "$data</option>";
                                            echo $resultado;
                                            $resultado = "";
                                        }
                                        $data = $item->load();
                                        echo "<option value='$data'>$data</option>";
                                    } else {
                                        if(is_numeric($item))
                                        {
                                            $resultado = "<option value='$item'>";
                                        }
                                        else
                                        {
                                            $resultado .= "$item</option>";
                                            echo $resultado;
                                            $resultado = "";
                                        }
                                    }
                                }
                            }  
                        }
                    ?>
                    </select>
                </div>
                <input type="submit" name="Enviar" id="enviar" value="Finalizar acogida" class="form-submit-button">  <!-- Introducir boton de enviar -->
                </form>
            </div>
                <!--informacion acerca de los datos -->
                <p class="InfoExtra">*Al pulsar el botón de "Acoger" acepta los términos y condiciones de la página, además del tratamiento de sus datos.</p>     
            </div>
        </div>
    </main>

    <footer id="footer"> <!-- Barra inferior (Para contacto y redes sociales) -->
        <div class="ContactoDiv">   <!-- Div para el contacto-->
            Teléfono: 626 47 18 22 <br>
            Correo electrónico: <a href="mailto:contactoayuda@MindMeetings.com" id="CorreoContacto" aria-label="Correo">contactoayuda@MindMeetings.com</a> <br> <!-- Correo de contacto con mailto -->
            Dirección: Av. Universidad de Cádiz, 10, 11519 Puerto Real, Cádiz
        </div>

        <div class="CopyDiv">   <!-- Div para el copy-->
            &copy; Javana 2023 <p></p>
        </div>

        <div class="RedesSocialesDiv">  <!-- Div para las redes sociales-->  
            <div class="RedesSocialesTexto">    <!-- Texto -->
                Síguenos en nuestras redes sociales
            </div>
            <div class="RedesSocialesImagenesDiv">
                <a href="https://www.instagram.com/" aria-label="Instagram">   <!-- insta -->
                    <img src="../images/insta.png" alt="RedesSocialesInstaImg" id="insta" height="50">
                </a>
                <a href="https://facebook.com/" aria-label="Facebook">        <!-- Face -->
                    <img src="../images/face.png" alt="RedesSocialesFaceImg" id="face" height="50">
                </a>
                <a href="https://twitter.com/" aria-label="Twitter">         <!-- Twit -->
                    <img src="../images/twit.png" alt="RedesSocialesTwitImg" id="twit" height="50">
                </a>
            </div>
        </div>
    </footer>   <!-- Fin de Barra inferior -->

</body>
</html>