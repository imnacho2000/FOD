{
    Se cuenta con un archivo con información de los casos de COVID-19 registrados en los
    diferentes hospitales de la Provincia de Buenos Aires cada día. Dicho archivo contiene:
    cod_localidad, nombre_localidad, cod_municipio, nombre_minucipio, cod_hospital,
    nombre_hospital, fecha y cantidad de casos positivos detectados.
    El archivo está ordenado por localidad, luego por municipio y luego por hospital.
    a. Escriba la definición de las estructuras de datos necesarias y un procedimiento que haga
    un listado con el siguiente formato:
    Nombre: Localidad 1
    Nombre: Municipio 1
    Nombre Hospital 1……………..Cantidad de casos Hospital 1
    ……………………..
    Nombre Hospital N…………….Cantidad de casos Hospital N
    Cantidad de casos Municipio 1
    …………………………………………………………………….
    Nombre Municipio N
    Nombre Hospital 1……………..Cantidad de casos Hospital 1
    ……………………..
    NombreHospital N…………….Cantidad de casos Hospital N
    Cantidad de casos Municipio N
    Cantidad de casos Localidad 1
    -----------------------------------------------------------------------------------------
    Nombre Localidad N
    Nombre Municipio 1
    Nombre Hospital 1……………..Cantidad de casos Hospital 1
    ……………………..
    Nombre Hospital N…………….Cantidad de casos Hospital N
    Cantidad de casos Municipio 1
    …………………………………………………………………….
    Nombre Municipio N
    Nombre Hospital 1……………..Cantidad de casos Hospital 1
    ……………………..
    Nombre Hospital N…………….Cantidad de casos Hospital N
    Cantidad de casos Municipio N
    Cantidad de casos Localidad N
    Cantidad de casos Totales en la Provincia
    b. Exportar a un archivo de texto la siguiente información nombre_localidad,
    nombre_municipio y cantidad de casos de municipio, para aquellos municipios cuya
    cantidad de casos supere los 1500. El formato del archivo de texto deberá ser el
    adecuado para recuperar la información con la menor cantidad de lecturas posibles.
    NOTA: El archivo debe recorrerse solo una vez.

}

program ejercicio18;
const
    valor_corte = 9999;
type
    fechas = record
        anio:integer;
        mes: 1..12;
        dia: 1..31;
    end;
    hospital = record
        cod_localidad : integer;
        nombre_localidad : string[25];
        cod_municipio : integer;
        nombre_municipio : string[25];
        cod_hospital : integer;
        nombre_hospital  : string[25];
        fecha : fechas;
        cantidad_positivos : integer;
    end;

    maestro = file of hospital;

procedure cargar_hospital(var reg_m: hospital);
begin
    write('Ingrese localidad: ');
    readln(reg_m.cod_localidad);
    if(reg_m.cod_localidad <> -1) then begin
        write('Ingrese nombre de localidad: ');
        readln(reg_m.nombre_localidad);
        write('Ingrese codigo de municipio: ');
        readln(reg_m.cod_municipio);
        write('Ingrese nombre de municipio: ');
        readln(reg_m.nombre_municipio);
        write('Ingrese codigo de hospital: ');
        readln(reg_m.cod_hospital);
        write('Ingrese nombre de hospital: ');
        readln(reg_m.nombre_hospital);
        write('Ingrese anio: ');
        readln(reg_m.fecha.anio);
        write('Ingrese mes: ');
        readln(reg_m.fecha.mes);
        write('Ingrese dia: ');
        readln(reg_m.fecha.dia);
        write('Ingrese cantidad de casos positivos detectados: ');
        readln(reg_m.cantidad_positivos);
    end;
end;

procedure crear_archivo_maestro(var arch: maestro);
var
    reg_m: hospital;
begin
    writeln('CREACION DE MAESTRO: ');
    rewrite(arch);
    cargar_hospital(reg_m);
    while(reg_m.cod_localidad <> -1) do begin
        write(arch,reg_m);
        cargar_hospital(reg_m);
    end;
    close(arch);
end;

procedure leer(var arch: maestro; var reg_m: hospital);
begin
    if not eof(arch) then
        read(arch, reg_m)
    else
        reg_m.cod_localidad := valor_corte;
end;

procedure procesar_maestro(var arch:maestro; var archivo_txt: Text);
var
    reg_m : hospital;
    
    cod_localidad_aux, cod_municipio_aux, cod_hospital_aux: integer;
    
    nombre_localidad_aux, nombre_municipio_aux, nombre_hospital_aux: string[25];

    total_provincia, total_municipio,total_casos, total_localidad: integer;
begin
    rewrite(archivo_txt);
    reset(arch);
    leer(arch,reg_m);
    total_provincia := 0;
    while(reg_m.cod_localidad <> valor_corte) do begin
        cod_localidad_aux := reg_m.cod_localidad;
        nombre_localidad_aux := reg_m.nombre_localidad;
        writeln('Nombre: ', nombre_localidad_aux, ' Localidad ', cod_localidad_aux);
        total_localidad := 0;
        
        while ( cod_localidad_aux = reg_m.cod_localidad) do begin
            
            nombre_municipio_aux := reg_m.nombre_municipio;
            cod_municipio_aux := reg_m.cod_municipio;
            writeln('Nombre: ', nombre_municipio_aux, ' Municipio ', cod_municipio_aux);
            total_municipio := 0;
            
            while (cod_localidad_aux = reg_m.cod_localidad) and (cod_municipio_aux = reg_m.cod_municipio) do begin   
                cod_hospital_aux := reg_m.cod_hospital;
                nombre_hospital_aux := reg_m.nombre_hospital;
                writeln('Nombre: ', nombre_hospital_aux,' Hospital ', cod_hospital_aux);
                total_casos := 0;
                
                while (cod_localidad_aux = reg_m.cod_localidad) and (cod_municipio_aux = reg_m.cod_municipio) and (cod_hospital_aux = reg_m.cod_hospital) do begin
                    total_casos := total_casos + reg_m.cantidad_positivos;
                    write('Cantidad de casos Hospital  ', cod_hospital_aux, #10);
                    writeln(reg_m.cantidad_positivos);
                    leer(arch, reg_m);
                end;
                
                if(total_casos > 1500) then
                    write(archivo_txt,' nombre localidad: ', nombre_localidad_aux, ' nombre municipio: ', nombre_municipio_aux, ' cantidad de casos municipio: ', total_casos);

                total_municipio := total_municipio + total_casos;
            end;
            writeln('Cantidad de casos municipio: ', total_municipio);
            total_localidad := total_localidad + total_municipio;
        end;
        writeln('Cantdad de casos localidad: ', total_localidad);
        total_provincia := total_provincia + total_localidad;
    end;
    writeln('Cantidad de casos Totales en la Provincia: ', total_provincia);
    close(arch);
    close(archivo_txt);
end;

procedure imprimirMaestro(var rM: hospital);
begin
    writeln('');
    writeln('Codigo de localidad: ', rM.cod_localidad);
    writeln('Codigo de municipio: ', rM.cod_municipio);
    writeln('COdigo de hospital: ', rM.cod_hospital);
    writeln('');
end;

procedure imprimirM(var archMaestro: maestro);
var
    rM: hospital;
begin
    reset(archMaestro);
    while not eof(archMaestro) do begin
        read(archMaestro,rM);
        imprimirMaestro(rM);
    end;
    close(archMaestro);
end;


var
    m: maestro;
    archivo_txt: Text;
begin
    Assign(m,'maestro');
    Assign(archivo_txt,'exportar');
    crear_archivo_maestro(m);
    procesar_maestro(m,archivo_txt);
    imprimirM(m);
end.