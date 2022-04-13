{
    Definir un programa que genere un archivo con registros de longitud fija conteniendo
    información de asistentes a un congreso a partir de la información obtenida por
    teclado. Se deberá almacenar la siguiente información: nro de asistente, apellido y
    nombre, email, teléfono y D.N.I. Implementar un procedimiento que, a partir del
    archivo de datos generado, elimine de forma lógica todos los asistentes con nro de
    asistente inferior a 1000.
    Para ello se podrá utilizar algún carácter especial situándolo delante de algún campo
    String a su elección.  Ejemplo:  ‘@Saldaño’
}

program ejercicio2;
const
    valor_corte = 1000;
type
    asistente = record
        nro: integer;
        apellido: string[25];
        nombre: string[25];
        email: string[25];
        telefono: integer;
        dni: string[10];
    end;

    maestro = file of asistente;

    procedure leer_asistente(var reg_m: asistente);
    begin
        write('Ingrese numero del asistente: ');
        readln(reg_m.nro);
        if(reg_m.nro <> -1) then begin
            write('Ingrese nombre del asistente: ');
            readln(reg_m.nombre);
            write('Ingrese apellido del asistente: ');
            readln(reg_m.apellido);
            write('Ingrese email del asistente: ');
            readln(reg_m.email);
            write('Ingrese telefono del asistente: ');
            readln(reg_m.telefono);
            write('Ingrese dni del asistente: ');
            readln(reg_m.dni);
        end;
    end;


    procedure crear_archivo_maestro(var m:maestro);
    var
        reg_m: asistente;
    begin
        rewrite(m);
        leer_asistente(reg_m);
        while(reg_m.nro <> -1) do begin
            write(m,reg_m);
            leer_asistente(reg_m);
        end;
        close(m); 
    end;

    procedure eliminar_asistente(var m: maestro);
    var
        reg_m: asistente;
    begin
        reset(m);
        while not eof(m) do begin
            read(m, reg_m);
            if(reg_m.nro < valor_corte) then 
                reg_m.dni := '@' + reg_m.dni;
                seek(m,filepos(m) - 1);
                write(m,reg_m);
        end;
        close(m);
    end;


    procedure imprimir_asistente(reg_m: asistente);
    begin
        writeln('');
        writeln('Numero del asistente: ', reg_m.nro);
        writeln('Apellido del asistente: ', reg_m.apellido);
        writeln('Nombre del asistente: ', reg_m.nombre);
        writeln('Email del asistente: ', reg_m.email);
        writeln('Telefono del asistente: ', reg_m.telefono);
        writeln('Dni del asistente: ', reg_m.dni);
        writeln('');
    end;

    procedure imprimir_maestro(var m:maestro);
    var
        reg_m: asistente;
    begin
        reset(m);
        while not eof(m) do begin
            read(m, reg_m);
            imprimir_asistente(reg_m);
        end;
        close(m);
    end;


    procedure imprimir_maestro_eliminados(var m:maestro);
    var
        reg_m: asistente;
    begin
        reset(m);
        while not eof(m) do begin
            read(m, reg_m);
            if (pos('@@@@@',reg_m.dni) = 0) then
                imprimir_asistente(reg_m);
        end;
        close(m);
    end;

var
    m: maestro;
begin
    // Assign(m,'maestro');
    // crear_archivo_maestro(m);
    eliminar_asistente(m);
    writeln('Con eliminados: ');
    imprimir_maestro(m);
    writeln('Sin eliminados: ');
    imprimir_maestro_eliminados(m);
end.