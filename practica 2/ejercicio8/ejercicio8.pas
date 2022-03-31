{
    Se cuenta con un archivo que posee información de las ventas que realiza una empresa a
    los diferentes clientes. Se necesita obtener un reporte con las ventas organizadas por
    cliente. Para ello, se deberá informar por pantalla: los datos personales del cliente, el total
    mensual (mes por mes cuánto compró) y finalmente el monto total comprado en el año por el
    cliente.
    Además, al finalizar el reporte, se debe informar el monto total de ventas obtenido por la
    empresa.
    El formato del archivo maestro está dado por: cliente (cod cliente, nombre y apellido), año,
    mes, día y monto de la venta.
    El orden del archivo está dado por: cod cliente, año y mes.
    Nota: tenga en cuenta que puede haber meses en los que los clientes no realizaron
    compras.

}
program ejercicio8;
const
    valorCorte = 9999;
type
    clientes = record
        cod : integer;
        nombreyape : string[50];
    end;
    
    archM = record
        cliente: clientes;
        anio : integer;
        mes : 1..12;
        dia : 1..31;
        monto : real;
    end;

    archivo_maestro = file of archM;

    procedure cargarCliente(var rM: archM);
    begin
        write('Ingrese codigo de cliente: ');
        readln(rM.cliente.cod);
        if(rM.cliente.cod <> -1) then begin
            write('Ingrese nombre y apellido del cliente: ');
            readln(rM.cliente.nombreyape);
            write('Ingrese año: ');
            readln(rM.anio);
            write('Ingrese mes: ');
            readln(rM.mes);
            write('Ingrese mes: ');
            readln(rM.dia);
            write('Ingrese monto: ');
            readln(rM.monto);
        end;
    end;

    procedure crearArchivoMaestro(var arch: archivo_maestro);
    var
        rM: archM;
    begin
        rewrite(arch);
        cargarCliente(rM);
        while(rM.cliente.cod <> -1) do begin
            write(arch,rM);
            cargarCliente(rM);
        end;
        close(arch);
    end;

    procedure leer(var arch: archivo_maestro; var rM: archM);
    begin
        if not eof(arch) then
            read(arch,rM)
        else
            rM.cliente.cod := valorCorte;
    end;

    procedure crearReporte(var arch: archivo_maestro);
    var
        rM: archM;
        total_ano,total_gen,monto_mensual: real;
        anio_aux,cod_aux: integer;
        mes: 1..12;
    begin
        reset(arch);
        leer(arch,rM);
        total_gen := 0;
        while(rM.cliente.cod <> valorCorte) do begin
            writeln('Codigo de cliente: ', rM.cliente.cod);
            writeln('Nombre y apellido: ', rM.cliente.nombreyape);
            cod_aux := rM.cliente.cod;
            while(rM.cliente.cod = cod_aux)  do begin
                writeln('Año: ', rM.anio);
                anio_aux := rM.anio;
                total_ano := 0;
                while(rM.cliente.cod = cod_aux) and (rM.anio = anio_aux) do begin
                    writeln('Mes: ', rM.mes);
                    monto_mensual := 0;
                    mes := rM.mes;
                    while(rM.cliente.cod = cod_aux) and (rM.anio = anio_aux) and (rM.mes = mes)do begin
                        monto_mensual := monto_mensual + rM.monto;
                        leer(arch,rM);
                    end;
                    writeln('Monto mensual: ',monto_mensual:2:2);
                    total_ano := total_ano + monto_mensual;
                end;
                writeln('Gastado por ano del cliente: ', total_ano:2:2);
            end;
            total_gen := total_gen + total_ano;
        end;
        writeln('Ganancias de la empresa: ',total_gen:2:2);  
        close(arch);
    end;

var
    archivoM: archivo_maestro; 
begin
    Assign(archivoM,'maestro');
    // crearArchivoMaestro(archivoM);
    crearReporte(archivoM);
end.