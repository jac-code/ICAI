function validar()
{
    var fecha = document.getElementById('fecha').value;
    var edad = document.getElementById('edad').value;
    var genero = document.getElementById('genero').value;
    var residencia = document.getElementById('residencia').value;
    var pfeiffer = document.getElementById('pfeiffer').value;
    var patologia = document.getElementById('patologia').value;
    var informacion = document.getElementById('informacion').value;

    var res = true;

    if(fecha.length==0 || edad.length==0 || genero.length==0 ||  residencia.length==0 || pfeiffer.length==0 || patologia.length==0 || informacion.length==0)
    {
        alert('Rellene todos los campos');
        res = false;
    }
    else
    {
        error.innerHTML = "";
    }

    if(isNaN(parseInt(edad)))
    {
        alert('La edad debe ser un número');
    }

    return res;
}