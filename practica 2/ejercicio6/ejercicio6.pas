{
    Se desea modelar la información necesaria para un sistema de recuentos de casos de
    covid para el ministerio de salud de la provincia de buenos aires.
    Diariamente se reciben archivos provenientes de los distintos municipios, la información
    contenida en los mismos es la siguiente: código de localidad, código cepa, cantidad casos
    activos, cantidad de casos nuevos, cantidad de casos recuperados, cantidad de casos
    fallecidos.
    El ministerio cuenta con un archivo maestro con la siguiente información: código localidad,
    nombre localidad, código cepa, nombre cepa, cantidad casos activos, cantidad casos
    nuevos, cantidad recuperados y cantidad de fallecidos.
    Se debe realizar el procedimiento que permita actualizar el maestro con los detalles
    recibidos, se reciben 10 detalles. Todos los archivos están ordenados por código de
    localidad y código de cepa.
    Para la actualización se debe proceder de la siguiente manera:
    1. Al número de fallecidos se le suman el valor de fallecidos recibido del detalle.
    2. Idem anterior para los recuperados.
    3. Los casos activos se actualizan con el valor recibido en el detalle.
    4. Idem anterior para los casos nuevos hallados.
    Realice las declaraciones necesarias, el programa principal y los procedimientos que
    requiera para la actualización solicitada e informe cantidad de localidades con más de 50
    casos activos (las localidades pueden o no haber sido actualizadas).

}
program ejercicio6;
const
    cantDetalles = 2;
    valorCorte = 9999;
type
    
    municipios = record
        codLocalidad : integer;
        codCepa : integer;
        cantActivos : integer;
        cantRecuperados : integer; 
        cantNuevos: integer;
        cantFallecidos : integer;
    end;

    archivoM = record
        codLocalidad : integer;
        nombreLocalidad : string[25];
        codigoCepa : integer;
        nombreCepa : string[25];
        cantActivos : integer;
        cantNuevos : integer;
        cantRecuperados : integer;
        cantFallecidos : integer;
        
    end;

    archivo_maestro = file of archivoM;
    archivo_detalle = file of municipios;

    arreglo_detalle = array[1..cantDetalles] of archivo_detalle;
    arreglo_aux_detalle = array[1..cantDetalles] of municipios;


procedure cargarArchMaestro(var rM: archivoM);
begin
    write('Ingrese codigo de localidad: ');
    readln(rM.codLocalidad);
    if(rM.codLocalidad <> - 1) then begin
        write('Ingrese codigo de cepa: ');
        readln(rM.codigoCepa);
        write('Ingrese nombre de cepa: ');
        readln(rM.nombreCepa);
        write('Ingrese nombre de la localidad: ');
        readln(rM.nombreLocalidad);
        write('Ingrese cantidad de casos activos: ');
        readln(rM.cantActivos);
        write('Ingrese cantidad de casos nuevos: ');
        readln(rM.cantNuevos);
        write('Ingrese cantidad de casos recuperados: ');
        readln(rM.cantRecuperados);
        write('Ingrese cantidad de fallecidos: ');
        readln(rM.cantFallecidos);
    end;
end;


procedure crearArchMaestro(var archivoM: archivo_maestro);
var     
    rM: archivoM;
begin
    rewrite(archivoM);
    cargarArchMaestro(rM);
    while(rM.codLocalidad <> -1) do begin 
        write(archivoM,rM);
        cargarArchMaestro(rM);
    end;
    close(archivoM);
end;

procedure imprimirRD(rD: municipios);
begin
    writeln(' ');
    writeln('Codigo de localidad: ', rD.codLocalidad);
    writeln('Codigo de cepa: ',rD.codCepa);
    writeln('Cantidad de Activos: ',rD.cantActivos);
    writeln('Cantidad de recuperados: ',rD.cantRecuperados);
    writeln('Cantidad de nuevos: ',rD.cantNuevos);
    writeln('Cantidad de fallecidos: ',rD.cantFallecidos);
    writeln(' ');
end;


procedure imprimirDetalle(var arregloD: arreglo_detalle);
var
    rD: municipios;
    i_str: string;
    i:integer;
begin
    for i:= 1 to cantDetalles do begin
        Str(i,i_str);
        assign(arregloD[i], 'Detalle ' + i_str);
        reset(arregloD[i]);
        writeln('Detalle ' + i_str);
        while not eof(arregloD[i]) do begin
            read(arregloD[i],rD);
            imprimirRD(rD);
        end;
        close(arregloD[i]);
    end;
end;

procedure cargarArchDetalle(var rD:municipios);
begin
    write('Ingrese codigo de localidad: ');
    readln(rD.codLocalidad);
    if(rD.codLocalidad <> -1) then begin
        write('Ingrese codigo de cepa: ');
        readln(rD.codCepa);
        write('Ingrese cantidad de casos activos: ');
        readln(rD.cantActivos);
        write('Ingrese cantidd de recuperados: ');
        readln(rD.cantRecuperados);
        write('Ingrese cantidad de fallecidos: ');
        readln(rD.cantFallecidos);
    end;
end;

procedure crearArchDetalles(var arregloD : arreglo_detalle);
var
    rD: municipios;
    i: integer;
    i_str: string;
begin
    for i:= 1 to cantDetalles do begin
        Str(i,i_str);
        assign(arregloD[i], 'Detalle ' + i_str);
        rewrite(arregloD[i]);
        cargarArchDetalle(rD);
        while (rD.codLocalidad <> -1) do begin
            write(arregloD[i],rD);
            cargarArchDetalle(rD);
        end;
        close(arregloD[I]);
    end;
end;

procedure leer(var arregloD: archivo_detalle ; var arregloAux:municipios);
begin
    if not eof(arregloD) then
        read(arregloD,arregloAux)
    else
        arregloAux.codLocalidad := valorCorte;
end;

procedure minimo(var arregloD: arreglo_detalle ; var arregloAux: arreglo_aux_detalle; var rD: municipios);
var
    minPos: integer;
    i:integer;
begin
    rD.codLocalidad := valorCorte;
    rD.codCepa := valorCorte;
    minPos:= 1;
    for i:= 1 to cantDetalles do begin
        if (arregloAux[i].codLocalidad <  rD.codLocalidad) then  
            if (arregloAux[i].codCepa < rD.codCepa) then begin
                rD := arregloAux[i];
                minPos:= i
            end;
    end;
    if(rD.codLocalidad <> valorCorte) then
        leer(arregloD[minPos],arregloAux[minPos]);
end;

procedure actualizar_maestro(var maestro: archivo_maestro; var detalles: arreglo_detalle);
var
    vaux: arreglo_aux_detalle;
    min: municipios;
    i:integer;
    i_str:string;
    rM: archivoM;
    rMAux: archivoM;
begin
    reset(maestro);
    for i:=1 to cantDetalles do begin
        Str(i,i_str);
        Assign(detalles[i],'Detalle '+i_str);
        reset(detalles[i]);
        leer(detalles[i],vaux[i]);
    end;
    minimo(detalles, vaux, min);
    while(min.codLocalidad <> valorCorte)do begin
        //Asigno a mi auxiliar los codigos que saque del minimo
        rMAux.codLocalidad:= min.codLocalidad;
        rMAux.codigoCepa := min.codCepa;
        
        //Mientras mi auxiliar sea el mismo que leo del minimo del detalle
        while ((rMAux.codLocalidad = min.codLocalidad) and (rMAux.codigoCepa = min.codCepa)) do begin
            rMAux.cantActivos := rMAux.cantActivos +  min.cantActivos;
            rMAux.cantFallecidos :=  rMAux.cantFallecidos + min.cantFallecidos;
            rMAux.cantRecuperados :=  rMAux.cantRecuperados + min.cantRecuperados;
            rMAux.cantNuevos := rMAux.cantNuevos + min.cantNuevos;
            minimo(detalles, vaux, min);
        
        end;

        //Leo el archivo maestro y leo hasta que sean iguales, cuando sean iguales le sumo todo al registro maestro
        read(maestro,rM);      
        while (rMAux.codLocalidad <> rM.codLocalidad) and (rMAux.codigoCepa <> rM.codigoCepa) do begin
            read(maestro,rM);
        end;

        rM.cantActivos := rM.cantActivos +  rMAux.cantActivos;
        rM.cantFallecidos :=  rM.cantFallecidos + rMAux.cantFallecidos;
        rM.cantRecuperados :=  rM.cantRecuperados + rMAux.cantRecuperados;
        rM.cantNuevos := rM.cantNuevos + rMAux.cantNuevos;

        seek(maestro,filepos(maestro) - 1);
        write(maestro,rM);
    end;
    for i:=1 to cantDetalles do begin
        close(detalles[i]);
    end;
    close(maestro);
end;

procedure leerM(var rM: archivoM);
begin
    writeln(' ');
    writeln('Codigo de localidad: ', rM.codLocalidad);
    writeln('Nombre de localidad: ', rM.nombreLocalidad);
    writeln('Codigo de cepa: ', rM.codigoCepa);
    writeln('Cantidad de casos activos: ', rM.cantActivos);
    writeln('Cantidad de casos nuevos: ', rM.cantNuevos);
    writeln('Cantidad de casos recuperados: ', rM.cantRecuperados);
    writeln('Cantidad de fallecidos: ', rM.cantFallecidos);
    writeln(' ');
end;

procedure imprimirM(var archivoM: archivo_maestro);
var
    rM: archivoM;
begin
    reset(archivoM);
    while not eof(archivoM) do begin
        read(archivoM, rM);
        leerM(rM);
    end;
    close(archivoM);
end;

var
    arrayD: arreglo_detalle;
    maestro: archivo_maestro;
begin
    assign(maestro, 'maestro');
    // crearArchMaestro(maestro);
    // crearArchDetalles(arrayD);
    imprimirDetalle(arrayD);
    actualizar_maestro(maestro, arrayD);
    writeln('Archivo Maestro: ');
    imprimirM(maestro);
end.