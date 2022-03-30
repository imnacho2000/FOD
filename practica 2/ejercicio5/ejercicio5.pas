{
    A partir de un siniestro ocurrido se perdieron las actas de nacimiento y fallecimientos de
    toda la provincia de buenos aires de los últimos diez años. En pos de recuperar dicha
    información, se deberá procesar 2 archivos por cada una de las 50 delegaciones distribuidas
    en la provincia, un archivo de nacimientos y otro de fallecimientos y crear el archivo maestro
    reuniendo dicha información.
    Los archivos detalles con nacimientos, contendrán la siguiente información: nro partida
    nacimiento, nombre, apellido, dirección detallada(calle,nro, piso, depto, ciudad), matrícula
    del médico, nombre y apellido de la madre, DNI madre, nombre y apellido del padre, DNI del
    padre.
    En cambio los 50 archivos de fallecimientos tendrán: nro partida nacimiento, DNI, nombre y
    apellido del fallecido, matrícula del médico que firma el deceso, fecha y hora del deceso y
    lugar.
    Realizar un programa que cree el archivo maestro a partir de toda la información los
    archivos. Se debe almacenar en el maestro: nro partida nacimiento, nombre, apellido,
    dirección detallada(calle,nro, piso, depto, ciudad), matrícula del médico, nombre y apellido
    de la madre, DNI madre, nombre y apellido del padre, DNI del padre y si falleció, además
    matrícula del médico que firma el deceso, fecha y hora del deceso y lugar. Se deberá,
    además, listar en un archivo de texto la información recolectada de cada persona.
    Nota: Todos los archivos están ordenados por nro partida de nacimiento que es única.
    Tenga en cuenta que no necesariamente va a fallecer en el distrito donde nació la persona y
    además puede no haber fallecido.

}

program ejercicio5;
const
    valorCorte = 9999;
    delegaciones = 3;
type

    archivoM = record
        nroP : integer;
        nombre: string[25];
        apellido : string[25];
        direccion : string[100];
        matricula : string[25];
        nombreM : string[25];
        apellidoM : String[25];
        dniM : string[10];
        nombreP : string[25];
        apellidoP : string[25];
        dniP : string[10];
        matriculaMedico : string[25];
        fecha : string[25];
        hora : string[5];
        lugar : string[25];      
    end;


    archivoDN = record
        nro : integer;
        nombre : string[25];
        apellido : string[25];
        direccion : string[25];
        matricula : string[25];
        nombreM : string[25];
        apellidoM : string[25];
        dniM : string[10];
        nombreP : string[25];
        apellidoP : string[25];
        dniP : string[10];
    end;

    archivoDF = record
        nro : integer;
        dni : String[10];
        nombre : String[25];
        matricula : String[25];
        fecha : String[25];
        hora : String[25];
        lugar : string[25];
    end;

    archivo_maestro = file of archivoM;
    archivo_detalle_nacimiento = file of archivoDN;
    archivo_detalle_fallecimiento = file of archivoDF;

    array_nacidos = array[1..delegaciones] of archivo_detalle_nacimiento;
    array_fallecidos = array[1..delegaciones] of archivo_detalle_fallecimiento;

    array_nacidos_aux = array [1..delegaciones] of archivoDN;
    array_fallecidos_aux = array [1..delegaciones] of archivoDF;


    procedure imprimirRDN(rDN: archivoDN);
    begin
        writeln(' ');
        writeln('Numero de partida: ',rDN.nro);
        writeln('Nombre: ',rDN.nombre);
        writeln('Apellido: ',rDN.apellido);
        writeln('Direccion: ',rDN.direccion);
        writeln('Matricula: ',rDN.matricula);
        writeln('Nombre madre: ',rDN.nombreM);
        writeln('Apellido madre: ',rDN.apellidoM);
        writeln('Dni de la madre: ',rDN.dniM);
        writeln('Nombre padre: ',rDN.nombreP);
        writeln('Apellido padre: ',rDN.apellidoP);
        writeln('Dni padre: ',rDN.dniP);
        writeln(' ');
    end;

    procedure imprimirDetalleNacimiento(var arch: array_nacidos);
    var
        i:integer;
        rDN: archivoDN;
        i_str: string;
    begin
        for i:= 1 to delegaciones do begin
            Str(i,i_str);
            Assign(arch[i],'Naci'+i_str);
            reset(arch[i]);
            writeln('Detalle numero: ' + i_str);
            while not eof(arch[i]) do begin
                read(arch[i],rDN);
                imprimirRDN(rDN);
            end;
            close(arch[i]);
        end;
    end;


    procedure cargarDetalleNacimiento(var rDN: archivoDN);
    begin
        write('Ingrese numero de partida de nacimiento: ');
        readln(rDN.nro);
        if(rDN.nro <> 0) then begin
            write('Ingrese nombre: ');
            readln(rDN.nombre);
            write('Ingrese apellido: ');
            readln(rDN.apellido);
            write('Ingrese direccion detallada: ');
            readln(rDN.direccion);
            write('Ingrese matricula: ');
            readln(rDN.matricula);
            write('Ingrese nombre de la madre: ');
            readln(rDN.nombreM);
            write('Ingrese apellido de la madre: ');
            readln(rDN.apellidoM);
            write('Ingrese dni de la madre: ');
            readln(rDN.dniM);
            write('Ingrese nombre del padre: ');
            readln(rDN.nombreP);
            write('Ingrese apellido del padre: ');
            readln(rDN.apellidoP);
            write('Ingrese dni del padre: ');
            readln(rDN.dniP);
        end;
    end;

    procedure crearArchDetalleNacimiento(var archN: array_nacidos);
    var
        i: integer;
        rDN : archivoDN;
        str_i : string;
    begin
        for i:= 1 to delegaciones do begin
            Str(i, str_i);
            assign(archN[i],'Naci'+str_i);
            rewrite(archN[i]);
            cargarDetalleNacimiento(rDN);
            while(rDN.nro <> 0) do begin
                write(archN[i],rDN);
                cargarDetalleNacimiento(rDN);
            end;
            close(archN[i]);
        end;
    end;

    
    procedure imprimirRDF(rDN: archivoDF);
    begin
        writeln(' ');
        writeln('Numero de partida: ',rDN.nro);
        writeln('Dni: ',rDN.dni);
        writeln('Nombre: ',rDN.nombre);
        writeln('Matricula: ',rDN.matricula);
        writeln('Fecha: ',rDN.fecha);
        writeln('Hora: ',rDN.hora);
        writeln('Lugar: ',rDN.lugar);
        writeln(' ');
    end;

    procedure imprimirDetalleFallecimiento(var arch: array_fallecidos);
    var
        i:integer;
        rDF: archivoDF;
        i_str: string;
    begin
        for i:= 1 to delegaciones do begin
            Str(i,i_str);
            Assign(arch[i],'Falle'+i_str);
            reset(arch[i]);
            writeln('Detalle numero: ' + i_str);
            while not eof(arch[i]) do begin
                read(arch[i],rDF);
                imprimirRDF(rDF);
            end;
            close(arch[i]);
        end;
    end;

    procedure cargarDetalleFallecimiento(var rDF: archivoDF);
    begin
        write('Ingrese numero de partida de nacimiento (Arch fallecimiento): ');
        readln(rDF.nro);
        if(rDF.nro <> 0) then begin
            write('Ingrese dni del fallecido: ');
            readln(rDF.dni);
            write('Ingrese nombre y apellido del fallecido: ');
            readln(rDF.nombre);
            write('Ingrese matricula del medico que firma el deceso: ');
            readln(rDF.matricula);
            write('Ingrese fecha del deceso: ');
            readln(rDF.fecha);
            write('Ingrese hora del deceso: ');
            readln(rDF.hora);
            write('Ingrese lugar del deceso: ');
            readln(rDF.lugar);
        end;
    end;


    procedure crearArchDetalleFallecimiento(var archF: array_fallecidos);
    var
        i : integer;
        rDF : archivoDF;
        str_i : string;
    begin
        for i:= 1 to delegaciones do begin
            Str(i, str_i);
            Assign(archF[i],'Falle'+str_i);
            rewrite(archF[i]);
            cargarDetalleFallecimiento(rDF);
            while(rDF.nro <> 0) do begin
                write(archF[i],rDF);
                cargarDetalleFallecimiento(rDF);
            end;
            close(archF[i]);
        end;
    end;

    procedure leerArchF(var archF: archivo_detalle_fallecimiento; var registro_detalle_fallecido: archivoDF);
    begin
        if not eof(archF) then
            read(archF,registro_detalle_fallecido)
        else
            registro_detalle_fallecido.nro := valorCorte; 
    end;

    procedure leerArchN(var archN: archivo_detalle_nacimiento; var registro_detalle_nacimiento: archivoDN);
    begin
        if not eof(archN) then
            read(archN,registro_detalle_nacimiento)
        else
            registro_detalle_nacimiento.nro := valorCorte; 
    end;

    procedure minimoF(var arrayF: array_fallecidos ; var arrayFAux: array_fallecidos_aux; var rDF: archivoDF);
    var
        minPos : integer;
        i : integer;
    begin
        rDF.nro := valorCorte;
        minPos := 1;
        for i := 1 to delegaciones do begin
            if(arrayFAux[i].nro < rDF.nro) then begin
                rDF := arrayFAux[i];
                minPos := i;
            end;
        end;
        if(rDF.nro <> valorCorte) then
            leerArchF(arrayF[minPos],arrayFAux[minPos]);
    end;

    procedure minimoN(var arrayN: array_nacidos ; var arrayNAux: array_nacidos_aux; var rDN: archivoDN);
    var
        minPos : integer;
        i : integer;
    begin
        rDN.nro := valorCorte;
        minPos := 1;
        for i := 1 to delegaciones do begin
            if(arrayNAux[i].nro < rDN.nro) then begin
                rDN := arrayNAux[i];
                minPos := i;
            end;
        end;
        if(rDN.nro <> valorCorte) then
            leerArchN(arrayN[minPos],arrayNAux[minPos]);
    end;

    procedure crearArchivoMaestro(var archM : archivo_maestro; var arrayF : array_fallecidos; var arrayN : array_nacidos);
    var
        rDF : archivoDF;
        rM : archivoM;
        rDN : archivoDN;
        arrayFAux : array_fallecidos_aux;
        arrayNAux : array_nacidos_aux;
        i:integer;
        i_str:string;
    begin
        rewrite(archM);
        for i:= 1 to delegaciones do begin
            Str(i,i_str);
            Assign(arrayF[i],'Falle'+i_str);
            reset(arrayF[i]);
            leerArchF(arrayF[i],arrayFAux[i]);
            Assign(arrayN[i],'Naci'+i_str);
            reset(arrayN[i]);
            leerArchN(arrayN[i],arrayNAux[i]);
        end;

        minimoF(arrayF,arrayFAux,rDF);
        minimoN(arrayN,arrayNAux,rDN);
        while(rDN.nro <> valorCorte) do begin
            rM.nroP := rDN.nro;
            rM.nombre := rDN.nombre;
            rM.apellido := rDN.apellido;
            rM.direccion := rDN.direccion;
            rM.matricula := rDN.matricula;
            rM.nombreM := rDN.nombreM;
            rM.apellido := rDN.apellidoM;
            rM.dniM := rDN.dniM;
            rM.nombreP := rDN.nombreP;
            rM.apellidoP := rDN.apellidoP;
            rM.dniP := rDN.dniP;
            if(rDN.nro = rDF.nro) then begin
                rM.matriculaMedico := rDF.matricula;
                rM.fecha := rDF.fecha;
                rM.hora := rDF.hora;
                rM.lugar := rDF.lugar;
                minimoF(arrayF,arrayFAux,rDF);
            end;
            write(archM,rM);
            minimoN(arrayN,arrayNAux,rDN);
        end;
        for i:= 1 to delegaciones do begin
            close(arrayF[i]);
            close(arrayN[i]);
        end;
        close(archM);
    end;

procedure crearArchivoTxt(var archM: archivo_maestro);
var
    rM:archivoM;
    archivo_txt: Text;
begin
    Assign(archivo_txt,'informacion-de-pacientes');
    rewrite(archivo_txt);
    reset(archM);
    while not eof(archM) do begin
        read(archM,rM);
        write(archivo_txt,'Numero de partida de nacimiento: ', rM.nroP, ', Nombre: ', rM.nombre, ', Apellido: ', rM.apellido, ', Direccion: ', rM.direccion, ', Matricula del medico: ', rM.matricula, ', Nombre de la madre: ', rM.nombreM, ', Apellido de la madre: ', rM.apellidoM, ', Dni de la madre: ', rM.dniM, ', Nombre del padre: ', rM.nombreP, ', Apellido del padre: ', rM.apellidoP, ', Dni del padre: ', rM.dniP, #10);
        if(rM.matriculaMedico <> '') then 
            write(archivo_txt, ', Matricula del medico que firma el deceso: ',rM.matriculaMedico, ', Fecha: ',rM.fecha, ', Hora: ',rM.hora, ', Lugar: ', rM.lugar);
        writeln(archivo_txt, ' ');
    end;
    close(archM);
    close(archivo_txt);
end;


var
    maestro: archivo_maestro;
    arrayF: array_fallecidos;
    arrayN: array_nacidos;
begin
    Assign(maestro,'maestro');
    // crearArchDetalleNacimiento(arrayN);
    // crearArchDetalleFallecimiento(arrayF);
    writeln('Detalles nacimientos: ');
    imprimirDetalleNacimiento(arrayN);
    writeln('---------------------------');
    writeln('Detalles Fallecimientos: ');
    imprimirDetalleFallecimiento(arrayF);
    writeln('---------------------------');
    crearArchivoMaestro(maestro,arrayF,arrayN);
    crearArchivoTxt(maestro);
end.