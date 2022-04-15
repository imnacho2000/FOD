{
    Se cuenta con un archivo que almacena información sobre especies de aves en
    vía de extinción, para ello se almacena: código, nombre de la especie, familia de ave,
    descripción y zona geográfica. El archivo no está ordenado por ningún criterio. Realice
    un programa que elimine especies de aves, para ello se recibe por teclado las especies a
    eliminar. Deberá realizar todas las declaraciones necesarias, implementar todos los
    procedimientos que requiera y una alternativa para borrar los registros. Para ello deberá
    implementar dos procedimientos, uno que marque los registros a borrar y posteriormente
    otro procedimiento que compacte el archivo, quitando los registros marcados. Para
    quitar los registros se deberá copiar el último registro del archivo en la posición del registro
    a borrar y luego eliminar del archivo el último registro de forma tal de evitar registros
    duplicados.
    Nota: Las bajas deben finalizar al recibir el código 500000
}

program ejercicio7;
const
    valor_alto = 500000;
type
    ave = record
        cod: integer;
        nombre: string[25];
        familia: string[25];
        descripcion: string[25];
        zona: string[25];
    end;

    maestro = file of ave;

    procedure leer_ave(var reg_m: ave);
    begin
        write('Ingrese codigo: ');
        readln(reg_m.cod);
        if(reg_m.cod <> -1) then begin
            write('Ingrese nombre de ave: ');
            readln(reg_m.nombre);
            write('Ingrese familia de ave: ');
            readln(reg_m.familia);
            write('Ingrese descripcion de ave: ');
            readln(reg_m.descripcion);
            write('Ingrese zona geográfica de ave: ');
            readln(reg_m.zona);
        end;
    end;

    procedure crear_maestro(var m:maestro);
    var
        reg_m: ave;
    begin
        rewrite(m);
        leer_ave(reg_m);
        while(reg_m.cod <> -1) do begin
            write(m,reg_m);
            leer_ave(reg_m);
        end;
        Close(m);
    end;

    procedure eliminar(var m:maestro);
    var
        reg_m: ave;
        especie:string[25];
    begin
        writeln('Ingrese especie de ave a eliminar: ');
        readln(especie);
        while(especie <> '50000') do begin
            reset(m);
            read(m,reg_m);
            while not eof(m) and (reg_m.nombre <> especie) do 
                read(m, reg_m);
            if(reg_m.nombre = especie) then begin
                reg_m.nombre := '@' + reg_m.nombre;
                Seek(m, filepos(m)-1);
                write(m,reg_m);
            end
            else
                writeln('El nombre de la ave, ',especie,' no se encuentra en el archivo');
            writeln('Ingrese especie de ave a eliminar: ');
            readln(especie);
            seek(m,0);
        end;
    end;

    procedure compactar(var m:maestro; pos:integer ; var cont: integer);
    var
        reg: ave;
        last_pos: integer;
    begin
        last_pos := filesize(m) - 1;
        seek(m,(last_pos - cont));
        read(m, reg);
        seek(m,pos);
        write(m,reg);
        cont:= cont + 1;
    end;

    procedure compactar_maestro(var m:maestro);
    var
       reg_m: ave;
       cont: integer;
    begin
        cont:= 0;
        reset(m);
        while (filepos(m) <> filesize(m) - cont) do begin
            read(m, reg_m);
            if (pos('@',reg_m.nombre) <> 0 ) then begin
                compactar(m,(filepos(m) - 1),cont);
                seek(m, filepos(m)-1);
            end;
        end;
        seek(m, (filesize(m)-cont));
        truncate(m);
        close(m)
    end;


    procedure imprimir_ave(reg_m: ave);
    begin
        writeln('');
        writeln('Codigo de ave: ', reg_m.cod);
        writeln('Nombre de especie de ave: ', reg_m.nombre);
        writeln('Familia de ave: ', reg_m.familia);
        writeln('Descripcion de ave: ', reg_m.descripcion);
        writeln('Zona geográfica de ave: ', reg_m.zona);
        writeln('');
    end;

    procedure imprimir(var m:maestro);
    var
        reg_m: ave;
    begin
        reset(m);
        while not eof(m) do begin
            read(m, reg_m);
            imprimir_ave(reg_m);
        end;
        close(m);
    end;

var
    m:maestro;
begin
    Assign(m,'maestro');
    // crear_maestro(m);
    writeln('Antes de eliminar: ');
    imprimir(m);
    eliminar(m);
    writeln('Despues de eliminar: ');
    compactar_maestro(m);
    imprimir(m);
end.