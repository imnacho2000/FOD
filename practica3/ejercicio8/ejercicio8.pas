{
    Se cuenta con un archivo con información de las diferentes distribuciones de linux
    existentes. De cada distribución se conoce: nombre, año de lanzamiento, número de
    versión del kernel, cantidad de desarrolladores y descripción. El nombre de las
    distribuciones no puede repetirse.
    
    Este archivo debe ser mantenido realizando bajas lógicas y utilizando la técnica de
    reutilización de espacio libre llamada lista invertida.
    Escriba la definición de las estructuras de datos necesarias y los siguientes
    procedimientos:
    
    ExisteDistribucion: módulo que recibe por parámetro un nombre y devuelve verdadero si
    la distribución existe en el archivo o falso en caso contrario.
    
    AltaDistribución: módulo que lee por teclado los datos de una nueva distribución y la
    agrega al archivo reutilizando espacio disponible en caso de que exista. (El control de
    unicidad lo debe realizar utilizando el módulo anterior). En caso de que la distribución que
    se quiere agregar ya exista se debe informar “ya existe la distribución”.
    
    BajaDistribución: módulo que da de baja lógicamente una distribución  cuyo nombre se
    lee por teclado. Para marcar una distribución como borrada se debe utilizar el campo
    cantidad de desarrolladores para mantener actualizada la lista invertida. Para verificar
    que la distribución a borrar exista debe utilizar el módulo ExisteDistribucion. En caso de no
    existir se debe informar “Distribución no existente”.
}

program ejercicio8;
type
    distribucion = record
        nombre: string[25];
        anio: integer;
        version: integer;
        cant: integer;
        descripcion: string[25];
    end;

    maestro = file of distribucion;

    procedure leer_distribucion(var reg_m: distribucion);
    begin
        write('Ingrese cantidad de desarrolladores: ');
        readln(reg_m.cant);
        if(reg_m.cant <> -1) then begin
            write('Ingrese de distribucion: ');
            readln(reg_m.nombre);
            write('Ingrese anio de lanzamiento: ');
            readln(reg_m.anio);
            write('Ingrese numero de version: ');
            readln(reg_m.version);
            write('Ingrese de descripcion: ');
            readln(reg_m.descripcion);
        end;
    end;

    procedure crear_archivo(var m:maestro);
    var
        reg_m:distribucion;
    begin
        rewrite(m);
        reg_m.cant := 0;
        write(m,reg_m);
        leer_distribucion(reg_m);
        while(reg_m.cant <> -1) do begin
            write(m,reg_m);
            leer_distribucion(reg_m);
        end;
        Close(m);
    end;

    function ExisteDistribucion(var m:maestro;var nombre: string):boolean;
    var
        ok: boolean;
        reg_m:distribucion;
    begin
        ok:= False;
        reset(m);
        while not eof(m) and not (ok) do begin
            read(m,reg_m);
            if(reg_m.nombre = nombre) and not (ok) then
                ok:=true;
        end;
        ExisteDistribucion:= ok;
        close(m);
    end;

    procedure AltaDistribucion(var m:maestro);
    var
        reg_m: distribucion;
        reg_reg: distribucion;
    begin
        reset(m);
        leer_distribucion(reg_reg);
        if not (ExisteDistribucion(m,reg_reg.nombre)) then begin
            if(reg_reg.cant > 0) then begin
                reset(m);
                read(m,reg_m);
                if(reg_m.cant <> 0) then begin
                    seek(m,abs(reg_m.cant));
                    read(m,reg_m);
                    seek(m, filepos(m)-1);
                    write(m,reg_reg);
                    seek(m,0);
                    write(m,reg_m);
                end;
            end
            else begin
                seek(m,filepos(m));
                write(m,reg_reg);
            end;
        end
        else
            writeln('La distribucion ', reg_reg.nombre, ' ya se encuentra en el archivo. ');
    end;

    procedure BajaDistribucion(var m: maestro);
    var
        nombre: string[25];
        reg_m: distribucion;
        head:integer;
    begin
        write('Ingrese nombre de distribucion: ');
        readln(nombre);
        if(ExisteDistribucion(m,nombre)) then begin
            reset(m);
            read(m,reg_m);
            head:= reg_m.cant;
            read(m,reg_m);
            while not eof(m) and (reg_m.nombre <> nombre) do 
                read(m,reg_m);
            reg_m.cant := head;
            head := ((filepos(m) - 1) * -1);
            seek(m,filepos(m)-1);
            write(m, reg_m);
            reg_m.cant := head;
            seek(m,0);
            write(m,reg_m);
            writeln('La distribucion ', nombre, '  se borro del archivo');
        end
        else
            writeln('La distribucion ', nombre, ' no se encuentra en el archivo');
        close(m);
    end;


    procedure imprimir_distribucion(reg_m:distribucion);
    begin
        writeln('');
        writeln('Nombre de la distribucion: ', reg_m.nombre);
        writeln('Anio de la distribucion: ', reg_m.anio);
        writeln('Version de la distribucion: ', reg_m.version);
        writeln('Cantidad de desarrolladores: ', reg_m.cant);
        writeln('Descripcion: ', reg_m.descripcion);
        writeln('');
    end;

    procedure imprimir_maestro(var m:maestro);
    var
        reg_m: distribucion;
    begin
        reset(m);
        while not eof(m) do begin
            read(m, reg_m);
            imprimir_distribucion(reg_m);
        end;
        close(m);
    end;

var
    m:maestro;
begin 
    Assign(m,'maestro');
    // crear_archivo(m);
    Writeln('Archivo maestro: ');
    imprimir_maestro(m);
    AltaDistribucion(m);
    Writeln('Post Dar Alta: ');
    imprimir_maestro(m);
    BajaDistribucion(m);
    Writeln('Post eliminacion: ');
    imprimir_maestro(m);
end.