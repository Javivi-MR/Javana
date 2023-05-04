// funcion de jQuery para seleccionar fecha atraves de un calendario 
$( function() {
    $( "#Fecha" ).datepicker({
      numberOfMonths: 1,  // Muestra un mes en el calendario
      showButtonPanel: true,  
      minDate: 1, // Establece la fecha mínima como mañana
      //cambiar formato de fecha a dd/mm/yy
      dateFormat: 'dd/mm/yy'
    });
  
    // Evita que se escriba en el campo de fecha
    $('#Fecha').on('keydown', function(event) { 
      event.preventDefault();
    });
  });