{
    Una cadena de tiendas de indumentaria posee un archivo maestro no ordenado
    con la información correspondiente a las prendas que se encuentran a la venta. De
    cada prenda se registra: cod_prenda, descripción, colores, tipo_prenda, stock y
    precio_unitario. Ante un eventual cambio de temporada, se deben actualizar las prendas
    a la venta. Para ello reciben un archivo conteniendo: cod_prenda de las prendas que
    quedarán obsoletas. Deberá implementar un procedimiento que reciba ambos archivos
    y realice la baja lógica de las prendas, para ello deberá modificar el stock de la prenda
    correspondiente a valor negativo.
    Por último, una vez finalizadas las bajas lógicas, deberá efectivizar las mismas
    compactando el archivo. Para ello se deberá utilizar una estructura auxiliar, renombrando
    el archivo original al finalizar el proceso.. Solo deben quedar en el archivo las prendas
    que no fueron borradas, una vez realizadas todas las bajas físicas.
}

program ejercicio6;
type
    prendas = record
        cod: integer;
        descripcion: string[25];
        colores: string[25];
        tipo_prenda: string[25];
        stock: integer;
        precio: real;
    end;

    prendas_diarias = record
        cod:integer;
    end;

    maestro = file of prendas;
    detalle = file of prendas_diarias;

    procedure leer_prenda(var reg_m: prendas);
    begin
        write('Ingrese codigo de prenda: ');
        readln(reg_m.cod);
        if(reg_m.cod <> -1) then begin
            write('Ingrese descripcion de prenda: ');
            readln(reg_m.descripcion);
            write('Ingrese colores de prenda: ');
            readln(reg_m.colores);
            write('Ingrese tipo de prenda: ');
            readln(reg_m.tipo_prenda);
            write('Ingrese stock de prenda: ');
            readln(reg_m.stock);
            write('Ingrese precio de prenda: ');
            readln(reg_m.precio);
        end;
    end;
    
    procedure crear_archivo_maestro(var m: maestro);
    var
        reg_m: prendas;
    begin   
        rewrite(m);
        leer_prenda(reg_m);
        while (reg_m.cod <> -1) do begin
            write(m,reg_m);
            leer_prenda(reg_m);
        end;
        close(m);
    end;

    procedure crear_detalle(var d: detalle);
    var
        reg_d: prendas_diarias;
    begin
        rewrite(d);
        write('Ingrese codigo de prenda: ');
        readln(reg_d.cod);
        while(reg_d.cod <> -1) do begin
            write(d,reg_d);
            write('Ingrese codigo de prenda: ');
            readln(reg_d.cod);
        end;
        close(d);
    end;

    procedure leer_detalle(var d:detalle; var reg_d: prendas_diarias);
    begin
        if not eof(d) then
            read(d,reg_d)
        else
            reg_d.cod := 9999;
    end;

    procedure compactar(var m: maestro; var d:detalle);
    var
        reg_m: prendas;
        reg_d: prendas_diarias;
    begin
        reset(m);
        reset(d);
        leer_detalle(d,reg_d);
        while(reg_d.cod <> 9999) do begin
            read(m,reg_m);
            
            while not eof(m) and (reg_m.cod <> reg_d.cod) do 
                read(m, reg_m);
            
            while (reg_m.cod = reg_d.cod) do begin
                reg_m.stock := reg_m.stock * -1;
                leer_detalle(d,reg_d);
            end;
            seek(m, filepos(m) - 1);
            write(m,reg_m);
        end;
        close(m);
        close(d);
    end;

    procedure leer_maestro(var m:maestro; var reg_m: prendas);
    begin
        if not eof(m) then
            read(m,reg_m)
        else
            reg_m.cod:= 9999;
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
        Erase(m);
        close(m_aux);
        Rename(m_aux,'maestro');
    end;

    procedure imprimir_prenda(reg_m: prendas);
    begin
        writeln('');
        writeln('Codigo de prenda: ', reg_m.cod);
        writeln('Stock de prenda: ', reg_m.stock);
        writeln('');
    end;
    
    procedure imprimir_maestro(var m:maestro);
    var
        reg_m: prendas;
    begin
        Reset(m);
        while not eof(m) do begin
            read(m,reg_m);
            imprimir_prenda(reg_m);
        end;
        Close(m);
    end;

var
    m:maestro;
    d:detalle;
begin
    Assign(m,'maestro');
    Assign(d,'detalle');
    crear_archivo_maestro(m);
    writeln('Antes de compactar: ');
    imprimir_maestro(m);
    // crear_detalle(d);
    compactar(m,d);
    writeln('Despues de compactar: ');
    imprimir_maestro(m);
    compactar_maestro(m);
    writeln('Archivo sin eliminados: ');
    imprimir_maestro(m);
end.