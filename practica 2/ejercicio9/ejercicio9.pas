{
    Se necesita contabilizar los votos de las diferentes mesas electorales registradas por
    provincia y localidad. Para ello, se posee un archivo con la siguiente información: código de
    provincia, código de localidad, número de mesa y cantidad de votos en dicha mesa.
    Presentar en pantalla un listado como se muestra a continuación:
    Código de Provincia
    Código de Localidad 
    Total de Votos
    ................................ ......................
    ................................ ......................
    Total de Votos Provincia: ____
    Código de Provincia
    Código de Localidad Total de Votos
    ................................ ......................
    Total de Votos Provincia: ___
    …………………………………………………………..
    Total General de Votos: ___
    NOTA: La información se encuentra ordenada por código de provincia y código de
    localidad.

}

program ejercicio9;
const
    valorCorte = 9999;
type
    archM = record
        codigo_provincia : integer;
        codigo_localidad : integer;
        numero_mesa : integer;
        cantidad_votos : integer;
    end;

    archivo_maestro = file of archM;

    procedure cargarVotante(var rM: archM);
    begin
        write('Ingrese codigo de provincia: ');
        readln(rM.codigo_provincia);
        if(rM.codigo_provincia <> -1) then begin
            write('Ingrese codigo de localidad: ');
            readln(rM.codigo_localidad);
            write('Ingrese numero de mesa: ');
            readln(rM.numero_mesa);
            write('Ingrese cantidad de votos: ');
            readln(rM.cantidad_votos);
        end;
    end;

    procedure crearArchivoMaestro(var arch: archivo_maestro);
    var
        rM: archM;
    begin
        rewrite(arch);
        cargarVotante(rM);
        while(rM.codigo_provincia <> -1) do begin
            write(arch,rM);
            cargarVotante(rM);
        end;
        close(arch);
    end;

    procedure leer(var arch: archivo_maestro; var rM: archM);
    begin
        if not eof(arch) then
            read(arch,rM)
        else
            rM.codigo_provincia := valorCorte;
    end;

    procedure listadoVotantes(var arch: archivo_maestro);
    var
        rM: archM;
        total_general_votos,codigo_provincia_aux, codigo_localidad_aux,cantidad_votos_aux,total_votos_provincia : integer;
    begin
        reset(arch);
        leer(arch,rM);
        total_general_votos := 0;
        while(rM.codigo_provincia <> valorCorte) do begin
            writeln('Codigo de provincia: ', rM.codigo_provincia);
            codigo_provincia_aux := rM.codigo_provincia;
            total_votos_provincia:= 0;
            while(rM.codigo_provincia = codigo_provincia_aux) do begin
                write('Codigo de localidad ','        Total de votos',#10,'      ', rM.codigo_localidad);
                codigo_localidad_aux := rM.codigo_localidad;
                cantidad_votos_aux := 0;
                while(rM.codigo_provincia = codigo_provincia_aux) and 
                    (rM.codigo_localidad = codigo_localidad_aux)do begin
                    cantidad_votos_aux := cantidad_votos_aux + rM.cantidad_votos;
                    write('                          ',cantidad_votos_aux,#10);
                    leer(arch,rM);
                end;
                total_votos_provincia:= total_votos_provincia + cantidad_votos_aux;
                writeln('Total de Votos Provincia: ',total_votos_provincia);
            end;
            total_general_votos:= total_general_votos + total_votos_provincia;
        end;
        write('Total General de Votos: ',total_general_votos);
        close(arch);
    end;
var
    archivoM : archivo_maestro;
begin
    Assign(archivoM,'maestro');
    // crearArchivoMaestro(archivoM);
    listadoVotantes(archivoM);
end.