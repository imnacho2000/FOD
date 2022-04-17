{Suponga que trabaja en una oficina donde está montada una LAN (red local). La misma
fue construida sobre una topología de red que conecta 5 máquinas entre sí y todas las
máquinas se conectan con un servidor central. Semanalmente cada máquina genera un
archivo de logs informando las sesiones abiertas por cada usuario en cada terminal y por
cuánto tiempo estuvo abierta. Cada archivo detalle contiene los siguientes campos:
cod_usuario, fecha, tiempo_sesion. Debe realizar un procedimiento que reciba los archivos
detalle y genere un archivo maestro con los siguientes datos: cod_usuario, fecha,
tiempo_total_de_sesiones_abiertas.
Notas:
- Cada archivo detalle está ordenado por cod_usuario y fecha.
- Un usuario puede iniciar más de una sesión el mismo día en la misma o en diferentes
máquinas.
- El archivo maestro debe crearse en la siguiente ubicación física:  /var/log.}

program ejer4;
//maquinas

const 
    cant_detalles = 2;
    valor_alto = 9999;
type

    campos_detalle = record
        cod: integer;
        fecha: longint;
        tiempo: integer;
    end;


    campo_maestro = record
        cod:integer;
        fecha:longint;
        tiempo_total:integer;
    end;

    archivo_maestro = file of campo_maestro;
    archivo_detalle = file of campos_detalle;

    vector_maquina = array[1..cant_detalles] of archivo_detalle;
    vector_registro = array [1..cant_detalles] of campos_detalle;


////////////////////////////////////////////////////////////////////

procedure crear_detalle(var v: vector_maquina );
    procedure cargar_detalle(var d:campos_detalle);
    begin
        write('Ingrese un codigo ');
        readln(d.cod);
        if (d.cod <> 0 ) then begin 
            write('Ingrese la fecha ');
            readln(d.fecha);
            write('Ingrese el tiempo que estuvo abierta su sesion');
            readln(d.tiempo);
         end;
    end;
var
    v_d:campos_detalle;
    i:integer;
    i_Str:string; //necesaria para convertir int a string
begin
    for i := 1 to cant_detalles do begin     
        Str(i, i_Str); // convierte lo que esta en i, en una variable string en i_STR
        assign(v[i], 'detalle'+i_Str); 
        rewrite(v[i]);
        cargar_detalle(v_d);      
        while (v_d.cod <> 0) do begin
            write(v[i], v_d);
            cargar_detalle(v_d);
        end;
        close(v[i]);
    end;
end; 

////////////////////////////////////////////////////////////////////


   
procedure leer(var arch:archivo_detalle; var r:campos_detalle);
begin
    if(not eof(arch))then
        read(arch, r)
    else
        r.cod := valor_alto;
end;

procedure minimo(var v_act: vector_registro; var vector_de_archivos: vector_maquina; var min:campos_detalle );
var
    i: integer;
    min_pos: integer;
begin
    min_pos:=1;
    min.cod:=valor_alto;
    for i:=1 to cant_detalles do begin
        if(v_act[i].cod < min.cod) and (v_act[i].fecha < min.fecha)then begin
            min:= v_act[i];
            min_pos:= i;
        end;
    end;
    if(min.cod <> valor_alto)then
        leer(vector_de_archivos[min_pos], v_act[min_pos]);
end;


procedure actualizar_maestro(var m: archivo_maestro; var vector_de_archivos: vector_maquina);
var 
    v_registro: vector_registro;
    min: campos_detalle;
    i: integer;
    reg_m:campo_maestro;
    i_str: string;
begin
    for i:= 1 to cant_detalles do begin
        Str(i,i_str);
        Assign(vector_de_archivos[i],'detalle'+i_str);
        reset(vector_de_archivos[i]);
        leer(vector_de_archivos[i], v_registro[i]);
    end;
    rewrite(m);
    minimo(v_registro, vector_de_archivos, min);
    while (min.cod <> valor_alto) do begin
        reg_m.cod := min.cod;
        reg_m.tiempo_total:= 0;
        reg_m.fecha := min.fecha;
        while(min.cod = reg_m.cod) and (min.fecha = reg_m.fecha) do begin
            reg_m.tiempo_total := reg_m.tiempo_total + min.tiempo;
            reg_m.fecha := min.fecha;
            minimo(v_registro, vector_de_archivos, min);
        end;
        write(m,reg_m);
    end;
    for i:= 1 to cant_detalles do begin
        close(vector_de_archivos[i]);
    end;
    close(m);
end;

procedure print(var reg_m: campo_maestro);
begin
    writeln('');
    writeln('Codigo: ', reg_m.cod);
    writeln('fecha: ', reg_m.fecha);
    writeln('tiempo: ',reg_m.tiempo_total);
    writeln('');
end;


procedure imprimirM(var arch: archivo_maestro);
var
    reg_m:campo_maestro;
begin
    reset(arch);
    while not eof(arch) do begin
        read(arch,reg_m);
        print(reg_m);
    end;
    close(arch);
end;

var 
    m:archivo_maestro;
    v:vector_maquina;
Begin
    assign(m,'Maestro');
    // crear_detalle(v);
    actualizar_maestro(m,v);
    imprimirM(m);
end.