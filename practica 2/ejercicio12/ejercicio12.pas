{
    La empresa de software ‘X’ posee un servidor web donde se encuentra alojado el sitio de
    la organización. En dicho servidor, se almacenan en un archivo todos los accesos que se
    realizan al sitio.
    La información que se almacena en el archivo es la siguiente: año, mes, dia, idUsuario y
    tiempo de acceso al sitio de la organización. El archivo se encuentra ordenado por los
    siguientes criterios: año, mes, dia e idUsuario.
    Se debe realizar un procedimiento que genere un informe en pantalla, para ello se indicará
    el año calendario sobre el cual debe realizar el informe. El mismo debe respetar el formato
    mostrado a continuación:
    Año : ---
    Mes:-- 1
    día:-- 1
    idUsuario 1   Tiempo Total de acceso en el dia 1 mes 1
    --------
    idusuario N    Tiempo total de acceso en el dia 1 mes 1
    Tiempo total acceso dia 1 mes 1
    -------------
    día N
    idUsuario 1   Tiempo Total de acceso en el dia N mes 1
    --------
    idusuario N    Tiempo total de acceso en el dia N mes 1
    Tiempo total acceso dia N mes 1
    Total tiempo de acceso mes 1
    ------
    Mes 12
    día 1
    idUsuario 1   Tiempo Total de acceso en el dia 1 mes 12
    --------
    idusuario N    Tiempo total de acceso en el dia 1 mes 12
    Tiempo total acceso dia 1 mes 12
    -------------
    día N
    idUsuario 1   Tiempo Total de acceso en el dia N mes 12
    --------
    idusuario N    Tiempo total de acceso en el dia N mes 12
    Tiempo total acceso dia N mes 12
    Total tiempo de acceso mes 12
    Total tiempo de acceso año
    Se deberá tener en cuenta las siguientes aclaraciones:
    - El año sobre el cual realizará el informe de accesos debe leerse desde teclado.
    - El año puede no existir en el archivo, en tal caso, debe informarse en pantalla “año
    no encontrado”.
    - Debe definir las estructuras de datos necesarias.
    - El recorrido del archivo debe realizarse una única vez procesando sólo la información
    necesaria.

}

program ejercicio12;
const
    valorCorte = 9999;
type
    archM = record
        anio : integer;
        mes : 1..12;
        dia : 1..31;
        idUsuario : integer;
        tiempo_acceso : integer;
    end;

    archivo_maestro = file of archM;

    procedure cargarAcceso(var rM: archM);
    begin
        write('Ingrese anio: ');
        readln(rM.anio);
        if(rM.anio <> -1) then begin
            write('Ingrese mes: ');
            readln(rM.mes);
            write('Ingrese dia: ');
            readln(rM.dia);
            write('Ingrese id de usuario: ');
            readln(rM.idUsuario);
            write('Ingrese tiempo de acceso: ');
            readln(rM.tiempo_acceso);
        end;
    end;

    procedure crearArchivoMaestro(var arch: archivo_maestro);
    var
        rM: archM;
    begin
        rewrite(arch);
        cargarAcceso(rM);
        while(rM.anio <> -1) do begin
            write(arch,rM);
            cargarAcceso(rM);
        end;
        close(arch);
    end;

    function esta(anio : integer ; var arch : archivo_maestro): boolean;
    var
        rM: archM;
        ok : boolean;
    begin
        reset(arch);    
        while not eof(arch) do begin
            read(arch,rM);
            if(rM.anio = anio) then
                ok:= True
            else
                ok:= False;
        end;
        esta:=ok;
    end;

    procedure leer(var arch: archivo_maestro; var rM: archM);
    begin
        if not eof(arch) then
            read(arch,rM)
        else
            rM.anio := valorCorte;
    end;

    procedure procesarArchivoMaestro(var arch: archivo_maestro ; anio: integer);
    var
        rM: archM;
        mes_aux, dia_aux, id_usuario_aux: integer;
        total_acceso_dia, total_anio, total_mes:integer;
    begin
        reset(arch);
        leer(arch,rM);
        while (rM.anio <> valorCorte) do begin
            while(rM.anio <> anio ) do begin
                leer(arch,rM);
            end;
            writeln('Anio: ', anio);
            total_anio := 0;
            while (anio = rM.anio) do begin
                mes_aux:= rM.mes;
                writeln('Mes: ', mes_aux);
                total_mes := 0;
                while (anio = rM.anio) and (mes_aux = rM.mes) do begin
                    dia_aux := rM.dia;
                    writeln('Dia: ', dia_aux);
                    total_acceso_dia:= 0;
                    while (anio = rM.anio) and (mes_aux = rM.mes) and (dia_aux = rM.dia) do begin
                        id_usuario_aux := rM.idUsuario;
                        write('idUsuario ',id_usuario_aux);
                        while (anio = rM.anio) and (mes_aux = rM.mes) and (dia_aux = rM.dia) and (id_usuario_aux = rM.idUsuario) do begin
                            total_acceso_dia := total_acceso_dia + rM.tiempo_acceso;
                            write('   Tiempo total de acceso en el dia ', dia_aux, ' mes ', mes_aux,#10);
                            writeln(rM.tiempo_acceso);
                            leer(arch,rM);
                        end;
                    end;
                    //Aca calculo el mes.
                    total_mes := total_mes + total_acceso_dia;
                    writeln('Total tiempo de acceso mes ', mes_aux);
                    writeln(total_mes);
                end;
                //Aca calculo el anio.
                total_anio:= total_anio + total_mes;
            end;
            writeln('Total tiempo de acceso anio');
            writeln(total_anio);
            // Informo al anio.
        end;
    end;

var
    archivoM : archivo_maestro;
    anio : integer;
begin
    Assign(archivoM,'maestro');
    // crearArchivoMaestro(archivoM);
    write('Ingrese el anio donde desea hacer el informe: ');
    readln(anio);
    if(esta(anio,archivoM)) then
        procesarArchivoMaestro(archivoM, anio)
    else
        write('El anio ', anio, ' no se encuentra en el archivo.');
end.