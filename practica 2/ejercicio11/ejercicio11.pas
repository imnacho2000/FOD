{
    A partir de información sobre la alfabetización en la Argentina, se necesita actualizar un
    archivo que contiene los siguientes datos: nombre de provincia, cantidad de personas
    alfabetizadas y total de encuestados. Se reciben dos archivos detalle provenientes de dos
    agencias de censo diferentes, dichos archivos contienen: nombre de la provincia, código de
    localidad, cantidad de alfabetizados y cantidad de encuestados. Se pide realizar los módulos
    necesarios para actualizar el archivo maestro a partir de los dos archivos detalle.
    NOTA: Los archivos están ordenados por nombre de provincia y en los archivos detalle
    pueden venir 0, 1 ó más registros por cada provincia.
}

program ejercicio11;
const
    valorCorte = '9999';
    cantDetalles = 2;
type
    archM = record
        nombre_provincia : string[25];
        cantidad_personas : integer;
        total_encuestados : integer;
    end;

    archD = record
        nombre_provincia : string[25];
        codigo_localidad : integer;
        cantidad_alfabetizados : integer;
        cantidad_encuestados : integer;
    end;
    
    archivo_maestro = file of archM;
    archivo_detalle = file of archD;

    arreglo_detalles = array[1..cantDetalles] of archivo_detalle;
    arreglo_archivoD = array[1..cantDetalles] of archD;

    procedure cargarProvincia(var rM: archM);
    begin
        write('Ingrese nombre de provincia: ');
        readln(rM.nombre_provincia);
        if(rM.nombre_provincia <> '') then begin
            write('Ingrese cantidad de personas alfabetizadas: ');
            readln(rM.cantidad_personas);
            write('Ingrese total encuestados: ');
            readln(rM.total_encuestados);
        end;
    end;

    procedure crearArchivoMaestro(var arch: archivo_maestro);
    var
        rM: archM;
    begin
        rewrite(arch);
        cargarProvincia(rM);
        while(rM.nombre_provincia <> '') do begin
            write(arch,rM);
            cargarProvincia(rM);
        end;
        close(arch);
    end;

    procedure leer(var arch: archivo_detalle; var rM: archD);
    begin
        if not eof(arch) then 
            read(arch,rM)
        else
            rM.nombre_provincia := valorCorte;
    end;

    procedure cargarArchDetalle(var rD:archD);
    begin
        write('Ingrese nombre de provincia: ');
        readln(rD.nombre_provincia);
        if(rD.nombre_provincia <> '') then begin
            write('Ingrese codigo de localidad: ');
            readln(rD.codigo_localidad);
            write('Ingrese cantidad de alfabetizados: ');
            readln(rD.cantidad_alfabetizados);
            write('Ingrese cantidd de encuestados: ');
            readln(rD.cantidad_encuestados);
        end;
    end;

    procedure crearArchDetalles(var arregloD : arreglo_detalles);
    var
        rD: archD;
        i: integer;
        i_str: string;
    begin
        for i:= 1 to cantDetalles do begin
            Str(i,i_str);
            assign(arregloD[i], 'Detalle ' + i_str);
            rewrite(arregloD[i]);
            cargarArchDetalle(rD);
            while (rD.nombre_provincia <> '') do begin
                write(arregloD[i],rD);
                cargarArchDetalle(rD);
            end;
            close(arregloD[I]);
        end;
    end;

    procedure minimo(var arregloD: arreglo_detalles ; var arregloAux: arreglo_archivoD; var rD: archD);
    var
        minPos: integer;
        i:integer;
    begin
        rD.nombre_provincia := valorCorte;
        for i:= 1 to cantDetalles do begin
            if (arregloAux[i].nombre_provincia <  rD.nombre_provincia) then  begin
                 rD := arregloAux[i];
                 minPos:= i
            end;
        end;
        if(rD.nombre_provincia <> valorCorte) then
            leer(arregloD[minPos],arregloAux[minPos]);
    end;

    procedure actualizar_maestro(var maestro: archivo_maestro; var detalles: arreglo_detalles);
    var
        vaux: arreglo_archivoD;
        min: archD;
        i:integer;
        i_str:string;
        rM: archM;
    begin
        reset(maestro);
        for i:=1 to cantDetalles do begin
            Str(i,i_str);
            Assign(detalles[i],'Detalle '+i_str);
            reset(detalles[i]);
            leer(detalles[i],vaux[i]);
        end;
        minimo(detalles, vaux, min);
        while(min.nombre_provincia <> valorCorte)do begin
            
            read(maestro,rM); 
            while (rM.nombre_provincia <> min.nombre_provincia) do begin
                read(maestro,rM);
            end;

            while (rM.nombre_provincia = min.nombre_provincia) do begin
                rM.cantidad_personas := rM.cantidad_personas +  min.cantidad_alfabetizados;
                rM.total_encuestados :=  rM.total_encuestados + min.cantidad_encuestados;
                minimo(detalles, vaux, min);
            end;

            seek(maestro,filepos(maestro) - 1);
            write(maestro,rM);
        end;
        for i:=1 to cantDetalles do begin
            close(detalles[i]);
        end;
        close(maestro);
    end;

    procedure leerM(var rM: archM);
    begin
        writeln(' ');
        writeln('Nombre de provincia: ', rM.nombre_provincia);
        writeln('Cantidad de personas alfabetizadas: ', rM.cantidad_personas);
        writeln('Total encuestados: ', rM.total_encuestados);
        writeln(' ');
    end;

    procedure imprimirM(var archivoM: archivo_maestro);
    var
        rM: archM;
    begin
        reset(archivoM);
        while not eof(archivoM) do begin
            read(archivoM, rM);
            leerM(rM);
        end;
        close(archivoM);
    end;

var
    archivoM : archivo_maestro;
    arregloDetalles : arreglo_detalles;
begin
    Assign(archivoM,'maestro');
    // crearArchivoMaestro(archivoM);
    // crearArchDetalles(arregloDetalles);
    actualizar_maestro(archivoM,arregloDetalles);
    imprimirM(archivoM);
end.