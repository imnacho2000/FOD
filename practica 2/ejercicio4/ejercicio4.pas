{
    Suponga que trabaja en una oficina donde está montada una LAN (red local). La misma
    fue construida sobre una topología de red que conecta 5 máquinas entre sí y todas las
    máquinas se conectan con un servidor central. Semanalmente cada máquina genera un
    archivo de logs informando las sesiones abiertas por cada usuario en cada terminal y por
    cuánto tiempo estuvo abierta. Cada archivo detalle contiene los siguientes campos:
    cod_usuario, fecha, tiempo_sesion. Debe realizar un procedimiento que reciba los archivos
    detalle y genere un archivo maestro con los siguientes datos: cod_usuario, fecha,
    tiempo_total_de_sesiones_abiertas.
    Notas:
    - Cada archivo detalle está ordenado por cod_usuario y fecha.
    - Un usuario puede iniciar más de una sesión el mismo dia en la misma o en diferentes
    máquinas.
    - El archivo maestro debe crearse en la siguiente ubicación física: /var/log.
}

program ejercicio4;
const
    corte = 9999;
    long_arrary = 5;
type
    archivoM = record
        cod_usuario : integer;
        fecha: string;
        tiempo_total_de_sesiones_abiertas : integer;
    end;
    archivoD = record
        cod_usuario: integer;
        fecha: string;
        tiempo_sesion : integer;
    end;

    archivo_maestro = file of archivoM;
    archivo_detalles = file of archivoD;

    arreglo_detalle = array [1..long_arrary] of archivo_detalles;
    arreglo_aux = array [1..long_arrary] of archivoD;

procedure imprimirDetalles(var rD: archivoD);
begin
    writeln('');
    writeln('Codigo de usuario: ', rD.cod_usuario);
    writeln('fecha: ', rD.fecha);
    writeln('tiempo de sesion: ', rD.tiempo_sesion);
    writeln('');
end;

procedure imprimirDetalle(var archDetalle: arreglo_detalle);
var
    rD: archivoD;
    indice: integer;
    str_indice : string;
Begin
    for indice:= 1 to long_arrary do begin
        Str(indice, str_indice);
        writeln('Archivo detalle numero: ' + str_indice);
        reset(archDetalle[indice]);
        while not eof(archDetalle[indice]) do begin
            read(archDetalle[indice],rD);
            imprimirDetalles(rD);
        end;
        close(archDetalle[indice]);
    end;
end;

procedure crearArchivoDetalle(var arregloDetalles: arreglo_detalle);
var
    indice: integer;
    rD: archivoD;
    str_indice : string;
begin
    writeln('Creando los archivos detalles: ');
    
    for indice:=1 to long_arrary do begin
        Str(indice, str_indice);
        assign(arregloDetalles[indice], 'Detalle '+str_indice);
        rewrite(arregloDetalles[indice]);
        write('Ingrese codigo de usuario: ');
        readln(rD.cod_usuario);
        while(rD.cod_usuario <> 0) do begin
            write('Ingrese fecha: ');
            readln(rD.fecha);
            write('Ingrese tiempo de sesion: ');
            readln(rD.tiempo_sesion);
            write(arregloDetalles[indice],rD);
            write('Ingrese codigo de usuario: ');
            readln(rD.cod_usuario);
        end;
        close(arregloDetalles[indice]);
    end;

    writeln('Fin de creacion de archivos detalles.');
end;


procedure leerArchDetalle(var archDetalle : archivo_detalles ; var registroDetalle : archivoD);
begin
    if not eof(archDetalle) then 
        read(archDetalle,registroDetalle)
    else
        registroDetalle.cod_usuario := corte;
end;


procedure minimo(var arrayDetalle: arreglo_detalle; var arrayRD: arreglo_aux ; var rD: archivoD);
var
    indice: integer;
    minCod: integer;
    minPos: integer;
begin
    minPos:= 1;
    minCod := 9999;
    for indice:= 1 to long_arrary do begin
        if(arrayRD[indice].cod_usuario <= minCod) then begin
            minCod:= arrayRD[indice].cod_usuario;
            rD := arrayRD[indice];
            minPos:= indice;
        end;
    end;
    if (rD.cod_usuario <> corte) then
        leerArchDetalle(arrayDetalle[minPos],arrayRD[minPos]);

end;


procedure crearArchMaestro(var archMaestro: archivo_maestro; var arrayAux: arreglo_aux; var arrayDetalle: arreglo_detalle ; var archDetalle: archivo_detalles);
var
    rM: archivoM;
    rD: archivoD;
    indice : integer;
    indice_str : string;
begin
    for indice:= 1 to long_arrary do begin
        Str(indice, indice_str);
        assign(arrayDetalle[indice], 'Detalle '+indice_str);
        reset(arrayDetalle[indice]);
        leerArchDetalle(arrayDetalle[indice],arrayAux[indice]);
    end;
    rewrite(archMaestro);
    minimo(arrayDetalle,arrayAux,rD);
    while(rD.cod_usuario <> corte) do begin
    
        rM.cod_usuario := rD.cod_usuario;
        rM.fecha := rD.fecha;
        rM.tiempo_total_de_sesiones_abiertas:= 0;
        
        while (rM.cod_usuario = rD.cod_usuario) do begin
            rM.tiempo_total_de_sesiones_abiertas := rM.tiempo_total_de_sesiones_abiertas + rD.tiempo_sesion; 
            rM.cod_usuario := rD.cod_usuario;
            rM.fecha := rD.fecha;
            minimo(arrayDetalle,arrayAux,rD);
        end;
        write(archMaestro,rM);
        
    end;
    
    for indice:= 1 to long_arrary do begin
        close(arrayDetalle[indice]);
    end;
    close(archMaestro);
end;


procedure imprimirMaestro(var rM: archivoM);
begin
    writeln('');
    writeln('Codigo de usuario: ', rM.cod_usuario);
    writeln('fecha: ', rM.fecha);
    writeln('tiempo total de sesiones abiertas: ', rM.tiempo_total_de_sesiones_abiertas);
    writeln('');
end;

procedure imprimirM(var archMaestro: archivo_maestro);
var
    rM: archivoM;
begin
    reset(archMaestro);
    while not eof(archMaestro) do begin
        read(archMaestro,rM);
        imprimirMaestro(rM);
    end;
    close(archMaestro);
end;

var
    archDetalle : archivo_detalles;
    archMaestro : archivo_maestro;
    arregloDetalles : arreglo_detalle;
    arrayAux: arreglo_aux;
begin
    Assign(archMaestro,'maestro');
    // crearArchivoDetalle(arregloDetalles);
    // imprimirDetalle(arregloDetalles);
    crearArchMaestro(archMaestro,arrayAux,arregloDetalles,archDetalle);
    imprimirM(archMaestro);
end.