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
    <title>Panel de control</title>
    <link rel="stylesheet" type="text/css" href="../css/resultado.css">
    <link rel="stylesheet" type="text/css" href="../css/panelcontrol.css">
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
                $contrasena = $_POST['contrasena'];

                try
                {
                    $plsql = "BEGIN :n := PaqueteGlobal.EsAdmin($Id,'$contrasena'); END;";
                    $stmt = oci_parse($conn, $plsql);     
                    oci_bind_by_name($stmt, ':n', $n, 100);
                    echo $n;
                    // Ejecutar la consulta
                    $flag1 = oci_execute($stmt);

                    if($n == 0)
                    {
                        throw new OCIException('El id o contraseña son incorrectos',499);
                    } 

                    $plsql = "BEGIN :cuota := PaqueteGlobal.FSUMACUOTASMENSUALES(); END;";

                    $stmt = oci_parse($conn, $plsql);
                    oci_bind_by_name($stmt, ':cuota', $cuota, 100);
                    $flag2 = oci_execute($stmt);
                    //if $cuota is empty
                    if($cuota == null)
                    {
                        $cuota = 0;
                    }
                    
    
                    $resultado = "<div id=\"Resultado\"><p> Bienvenido al panel de control </p></div>
                                  <div id=\"Resultado\"><p> La cuota mensual actual, obtenida gracias a los socios es de $cuota € </p></div>
                                  <div class=\"TituloFormularioDiv\">     <!-- Div para el formulario -->
                                  <div class=\"TituloFormDiv\"> <!-- <Div para el formulario y titulo de la sala -->
                                      <h3 id=\"TituloSala\">Añadir administrador</h3>   <!-- Titulo de la sala -->
                                  </div>    
                                  <div class=\"FormularioDiv\">
                                      <form action=\"registraradmin.php\" method=\"POST\" id=\"formulario\" onsubmit=\"return DatosValidos()\"> <!-- ¡CUIDADO! reservado.html está puesto como algo meramente ilustrativo, hay que preguntar que poner -->
                                          <div class=\"InputDiv\">
                                              <label for=\"Id\">Id Registro:</label>
                                              <input type=\"text\" name=\"Id\" size=\"30\" id=\"Id\" required> <!-- Introducir Nombre -->
                                          </div>
                                          <div class=\"InputDiv\">
                                              <label for=\"contrasena\">Contraseña:</label>
                                              <input type=\"text\" name=\"contrasena\" size=\"30\" id=\"contrasena\" required>   <!-- Introducir Apellidos -->
                                          </div>
                                          <input type=\"submit\" name=\"Enviar\" id=\"enviar\" value=\"Añadir\" class=\"form-submit-button\">  <!-- Introducir boton de enviar -->
                                      </form>
                                  </div>
                                  <div class=\"TituloFormDiv\"> <!-- <Div para el formulario y titulo de la sala -->
                                  <h3 id=\"TituloSala\">Actualizar contraseña administrador</h3>   <!-- Titulo de la sala -->
                                  </div>    
                                  <div class=\"FormularioDiv\">
                                    <form action=\"actualizaradmin.php\" method=\"POST\" id=\"formulario\" onsubmit=\"return DatosValidos()\"> <!-- ¡CUIDADO! reservado.html está puesto como algo meramente ilustrativo, hay que preguntar que poner -->
                                      <div class=\"InputDiv\">
                                          <label for=\"Id\">Id Registro:</label>
                                          <input type=\"text\" name=\"Id\" size=\"30\" id=\"Id\" required> <!-- Introducir Nombre -->
                                      </div>
                                      <div class=\"InputDiv\">
                                          <label for=\"contrasena\">Nueva contraseña:</label>
                                          <input type=\"text\" name=\"contrasena\" size=\"30\" id=\"contrasena\" required>   <!-- Introducir Apellidos -->
                                      </div>
                                      <input type=\"submit\" name=\"Enviar\" id=\"enviar\" value=\"Actualizar\" class=\"form-submit-button\">  <!-- Introducir boton de enviar -->
                                  </form>
                              </div>
                                  <div class=\"TituloFormDiv\"> <!-- <Div para el formulario y titulo de la sala -->
                                    <h3 id=\"TituloSala\">Eliminar administrador</h3>   <!-- Titulo de la sala -->
                                  </div> 
                                  <div class=\"FormularioDiv\">
                                  <form action=\"eliminaradmin.php\" method=\"POST\" id=\"formulario\" onsubmit=\"return DatosValidos()\"> <!-- ¡CUIDADO! reservado.html está puesto como algo meramente ilustrativo, hay que preguntar que poner -->
                                      <div class=\"InputDiv\">
                                          <label for=\"Id\">Id Registro:</label>
                                          <input type=\"text\" name=\"Id\" size=\"30\" id=\"Id\" required> <!-- Introducir Nombre -->
                                      </div>
                                      <input type=\"submit\" name=\"Enviar\" id=\"enviar\" value=\"Eliminar\" class=\"form-submit-button\">  <!-- Introducir boton de enviar -->
                                  </form>
                              </div>
                                  <div id=\"Resultado\"><p> Panel de control bajo construccion, Nuevas funciones disponibles proximamente. </p></div>
                              </div>";
                    echo $resultado;
                }
                catch(OCIException $e)
                {
                    if($e->getCode() === 498)
                    {
                        $resultado = "<div id=\"Resultado\"><p>Error: No ha seleccionado ningún animal</p></div>";
                        echo $resultado;
                    }
                    else if($e->getCode() === 499)
                    {
                        $resultado = "<div id=\"Resultado\"><p>Error: El id o contraseña son incorrectos </p></div>";
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