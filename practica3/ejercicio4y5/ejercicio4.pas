{
    Las bajas se realizan apilando registros borrados y las altas reutilizando registros
    borrados. El registro 0 se usa como cabecera de la pila de registros borrados: el
    número 0 en el campo código implica que no hay registros borrados y -N indica que el
    próximo registro a reutilizar es el N, siendo éste un número relativo de registro válido.
    a. Implemente el siguiente módulo:
        Abre el archivo y agrega una flor, recibida como parámetro
        manteniendo la política descripta anteriormente

        procedure agregarFlor (var a: tArchFlores ; nombre: string;
        codigo:integer);

    b. Liste el contenido del archivo omitiendo las flores eliminadas. Modifique lo que
    considere necesario para obtener el listado

}

program ejercicio4;

type
    flor = record
        nombre: string[25];
        cod: integer;
    end;
    maestro = file of flor;

    procedure leer_flor(var reg_m: flor);
    begin
        write('Ingrese codigo de flor: ');
        readln(reg_m.cod);
        if(reg_m.cod <> -1) then begin
            write('Ingrese nombre de flor: ');
            readln(reg_m.nombre);
        end;
    end;

    procedure crear_archivo(var m : maestro);
    var
        reg_m: flor;
    begin
        reg_m.cod := 0;
        rewrite(m);
        write(m,reg_m);
        leer_flor(reg_m);
        while (reg_m.cod <> - 1) do begin
            write(m, reg_m);
            leer_flor(reg_m);
        end;
        close(m);    
    end;

    procedure agregarFlor (var m: maestro ; nombre: string; codigo:integer);
    var
        reg_m: flor;
        reg_registrar: flor;
    begin
        reg_registrar.nombre:= nombre;
        reg_registrar.cod := codigo;
        reset(m);
        read(m, reg_m);
        if(reg_m.cod > 0) then begin
            seek(m,Abs(reg_m.cod));
            read(m,reg_m);
            seek(m, filepos(m)-1);
            write(m,reg_registrar);
            seek(m,0);
            write(m,reg_m);
        end
        else begin
            seek(m,filesize(m));
            write(m,reg_registrar);
        end;
        close(m);
    end;


    procedure listar_contenido(var a:maestro);
    var
        reg_m: flor;
    begin
        reset(a);
        while not eof(a) do begin
            read(a, reg_m);
            if(reg_m.cod > 0) then 
                write('Codigo de flor: ', reg_m.cod, ' Nombre de flor: ', reg_m.nombre,#10);
        end;
        close(a);
    end;

    procedure eliminarFlor (var m: maestro; flores:flor);
    var
        head:integer;
        reg_m: flor;
    begin
        reset(m);
        read(m,reg_m);
        head:= reg_m.cod;
        while not eof(m) and (reg_m.cod <> flores.cod) do 
            read(m,reg_m);
        if reg_m.cod = flores.cod then begin
            reg_m.cod := head;
            head := ((filepos(m) - 1) * -1);
            seek(m,filepos(m)-1);
            write(m, reg_m);
            seek(m,0);
            reg_m.cod := head;
            write(m,reg_m);
        end
        else
            writeln('El codigo de la novlea, ',flores.cod,' no se encuentra en el archivo');
        close(m);
    end;
var
    m: maestro;
    cod:integer;
    nombre: string[25];
    flor_eliminar: flor;
begin 
    Assign(m,'maestro');
    // crear_archivo(m);
    // agregarFlor(m,'Clavel',2);
    // agregarFlor(m,'Rosas',8);
    // agregarFlor(m,'Marquidias',4);
    listar_contenido(m);
    writeln('Ingrese codigo de flor: ');
    readln(cod);
    writeln('Ingrese nombre de flor: ');
    readln(nombre);
    flor_eliminar.cod:= cod;
    flor_eliminar.nombre:= nombre;
    eliminarFlor(m, flor_eliminar);
end.