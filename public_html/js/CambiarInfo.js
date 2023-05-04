function cambiarInfo() {    // Función que cambia la información de la sala según la opción seleccionada en el select
    console.log("cambiarInfo()"); // Mostramos en la consola del navegador que se ha ejecutado la función
    let opcionSeleccionada = document.getElementById("idanimal").value; // Obtenemos el valor de la opción seleccionada
    console.log(opcionSeleccionada);
    switch(opcionSeleccionada) // Comprobamos el valor de la opción seleccionada
    {
        case '-1':    // Si la opción seleccionada es la sala de estudios General Serrano
            document.getElementById("ImagenSala").src = "../images/animales.png"; // Cambiamos la imagen de la sala
            document.getElementById("inf1").innerHTML = "¡Registrate en el sistema para poder realizar acciones!"; // Cambiamos la información de la sala
            document.getElementById("inf2").innerHTML = ""; // Cambiamos la información de la sala
        break; 
        case '1':    // Si la opción seleccionada es la sala de estudios General Serrano
            document.getElementById("ImagenSala").src = "../images/gatita.jpeg"; // Cambiamos la imagen de la sala
            document.getElementById("inf1").innerHTML = "Felina, castrada, vacunada y con chip"; // Cambiamos la información de la sala
            document.getElementById("inf2").innerHTML = "Gatita juguetona y tranquila, ¡muy cariñosa!"; // Cambiamos la información de la sala
        break; 
        // Repetimos el proceso para las demás opciones
        case '2':
            document.getElementById("ImagenSala").src = "../images/gatito.jpg";
            document.getElementById("inf1").innerHTML = "Felino, castrado, vacunado y con chip";
            document.getElementById("inf2").innerHTML = "Gatito amoroso y protector, ¡muy mono!";
        break;
        case '3':
            document.getElementById("ImagenSala").src = "../images/perrita.png";
            document.getElementById("inf1").innerHTML = "Canina, castrada, vacunada y con chip";
            document.getElementById("inf2").innerHTML = "Perrita amigable y energética, ¡muy social!";
        break;
        case '4':
            document.getElementById("ImagenSala").src = "../images/perrito.jpg";
            document.getElementById("inf1").innerHTML = "Canino, castrado, vacunado y con chip";
            document.getElementById("inf2").innerHTML = "Perrito juguetón y cañero, ¡muy guapo!";
        break;
        case '5':
            document.getElementById("ImagenSala").src = "../images/ardilla.jpg";
            document.getElementById("inf1").innerHTML = "Roedor, castrado y con chip";
            document.getElementById("inf2").innerHTML = "Ardilla pequeña y energética, necesitaria vacunación";
        break;
    }
}