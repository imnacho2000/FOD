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
        head:integer;
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

    procedure compactar_maestro(var m:maestro);
    var
        reg_m: prendas;
        reg_aux: prendas;
        m_aux: maestro;
    begin
        assign(m_aux,'maestro_aux');
        rewrite(m_aux);
        reset(m);
        leer_maestro(m,reg_m);
        while (reg_m.cod <> 9999) do begin
            reg_aux:= reg_m;
            while (reg_aux.cod = reg_m.cod) do begin
                if(reg_aux.stock > 0 ) then
                    write(m_aux,reg_m);
                leer_maestro(m,reg_m);
            end;  
        end;
        Close(m);
        close(m_aux);
        Erase(m);
        Rename(m_aux,'maestro');
    end;

var
    m:maestro;
begin
    Assign(m,'maestro');
    crear_maestro(m);
end.