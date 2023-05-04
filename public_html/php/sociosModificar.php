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
    <title>Resultado</title>
    <link rel="stylesheet" type="text/css" href="../css/resultado.css">
    <link rel="stylesheet" href="//code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css">
    <script src="https://code.jquery.com/jquery-1.12.4.js"></script>
    <script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>
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

    <!-- A traves de php mostra el id asignado o en otro caso el error -->

    <?php
    class OCIException extends \Exception {} //poder usar excepciones del tipo OCI
    error_reporting(E_ERROR | E_PARSE);
    
    if($_POST)
    {
        // Configurar las variables de conexión
        $db_user = 'javivimol';
        $db_pass = 'admin';
        $db_conn_str = '(DESCRIPTION=(ADDRESS_LIST=(ADDRESS=(PROTOCOL=TCP)(HOST=localhost)(PORT=1521)))(CONNECT_DATA=(SERVICE_NAME=XEPDB1)))';
    
        // Establecer la conexión
        $conn = oci_connect($db_user, $db_pass, $db_conn_str);
    
        // Verificar si la conexión fue exitosa
        if (!$conn) {
            $err = oci_error();
            trigger_error(htmlentities($err['message'], ENT_QUOTES), E_USER_ERROR);
        }
        else {
            // Preparar la consulta
            $Id = $_POST['Id'];
            $DNI = $_POST['DNI'];
            $Cuota = $_POST['Cuota'];
            try
            {
                $plsql = "SELECT * FROM TablaPersona WHERE IdPersona = '$Id' AND DNI = '$DNI'";
                $stmt = oci_parse($conn, $plsql);     
    
                // Ejecutar la consulta
                $flag1 = oci_execute($stmt);
                //si no devuelve nada, es que no existe
                if(!oci_fetch_array($stmt, OCI_ASSOC+OCI_RETURN_NULLS))
                {
                    throw new OCIException('El Id o DNI no son correctos',499);
                }

                $plsql = "BEGIN PaqueteGlobal.ActualizarCuotaSocio('$Id', '$Cuota'); END;";  
                
                $stmt = oci_parse($conn, $plsql);

                // Ejecutar la consulta
                $flag2 = oci_execute($stmt);

                if(!$flag2)
                {
                    throw new OCIException('La persona no es socio',502);
                }

                $resultado = "<div id=\"Resultado\"><p> El registro ha sido efectuado, a principio de mes se cobrará la Cuota </p></div>";
                echo $resultado;
            }
            catch(OCIException $e)
            {
                if($e->getCode() === 502)
                {
                    $resultado = "<div id=\"Resultado\"><p>Error: La persona no es socio</p></div>";
                    echo $resultado;
                }
                else if($e->getCode() === 499)
                {
                    $resultado = "<div id=\"Resultado\"><p>Error: El Id o DNI no son correctos</p></div>";
                    echo $resultado;
                }
                else
                {
                    $resultado = "<div id=\"Resultado\"><p>Error: No se ha podido realizar la adopción</p></div>";
                    echo $resultado;
                }
            }
            // Liberar recursos
            oci_free_statement($stmt);
            oci_close($conn);
        }
    }
    ?>



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