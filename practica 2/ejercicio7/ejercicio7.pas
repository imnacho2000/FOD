{
    El encargado de ventas de un negocio de productos de limpieza desea administrar el
    stock de los productos que vende. Para ello, genera un archivo maestro donde figuran todos
    los productos que comercializa. De cada producto se maneja la siguiente información:
    código de producto, nombre comercial, precio de venta, stock actual y stock mínimo.
    Diariamente se genera un archivo detalle donde se registran todas las ventas de productos
    realizadas. De cada venta se registran: código de producto y cantidad de unidades vendidas.
    Se pide realizar un programa con opciones para:
    a. Actualizar el archivo maestro con el archivo detalle, sabiendo que:
    ● Ambos archivos están ordenados por código de producto.
    ● Cada registro del maestro puede ser actualizado por 0, 1 ó más registros del
    archivo detalle.
    ● El archivo detalle sólo contiene registros que están en el archivo maestro.
    b. Listar en un archivo de texto llamado “stock_minimo.txt” aquellos productos cuyo
    stock actual esté por debajo del stock mínimo permitido.
}

program ejercicio7;
const
    valorCorte = 9999;
type
    archM = record
        codigo_producto : integer;
        nombre_comercial : string[25];
        precio_venta : real;
        stock_actual : integer;
        stock_minimo : integer;
    end;

    archD = record
        codigo_producto : integer;
        cantidad_vendida : integer;
    end;

    archivo_maestro = file of archM;
    archivo_detalle = file of archD;

    procedure cargarProducto(var rM: archM);
    begin
        write('Ingrese codigo de producto: ');
        readln(rM.codigo_producto);
        if(rM.codigo_producto <> -1) then begin
            write('Ingrese nombre comercial: ');
            readln(rM.nombre_comercial);
            write('Ingrese precio de venta: ');
            readln(rM.precio_venta);
            write('Ingrese stock actual: ');
            readln(rM.stock_actual);
            write('Ingrese stock minimo: ');
            readln(rM.stock_minimo);
        end;
    end;

    procedure crearArchivoMaestro(var arch: archivo_maestro);
    var
        rM: archM;
    begin
        rewrite(arch);
        cargarProducto(rM);
        while(rM.codigo_producto <> -1) do begin
            write(arch,rM);
            cargarProducto(rM);
        end;
        close(arch);
    end;

    procedure cargarVentaDiaria(var rD:archD);
    begin
        write('Ingrese codigo de producto: ');
        readln(rD.codigo_producto);
        if(rD.codigo_producto <> -1) then begin
            write('Ingrese cantidad vendida: ');
            readln(rD.cantidad_vendida);
        end;
    end;

    procedure crearArchivoDetalle(var arch: archivo_detalle);
    var
        rD: archD;
    begin
        rewrite(arch);
        cargarVentaDiaria(rD);
        while(rD.codigo_producto <> -1) do begin
            write(arch,rD);
            cargarVentaDiaria(rD);
        end;
        close(arch);
    end;
    
    procedure leer(var archD: archivo_detalle; var rD: archD);
    begin
        if not eof(archD) then 
            read(archD,rD)
        else
            rD.codigo_producto := valorCorte;
    end;

    procedure actualizarMaestro(var arch: archivo_maestro ; var archD: archivo_detalle);
    var
        rM: archM;
        rD: archD;
    begin
        reset(arch);
        reset(archD);
        leer(archD,rD);
        while(rD.codigo_producto <> valorCorte) do begin
            read(arch,rM);

            while (rD.codigo_producto <> rM.codigo_producto) do begin
                read(arch,rM);
            end;
            
            while(rD.codigo_producto = rM.codigo_producto) do begin
                rM.stock_actual := rM.stock_actual - rD.cantidad_vendida;
                leer(archD,rD);
            end;

            seek(arch,filepos(arch)-1);
            write(arch,rM);
        end;
        close(arch);
        close(archD);
    end;

    procedure listarATxt(var arch: archivo_maestro ; var archivo_txt: Text);
    var
        rM: archM;
    begin
        reset(arch);
        rewrite(archivo_txt);
        while not eof(arch) do begin
            read(arch,rM);
            if(rM.stock_actual < rM.stock_minimo) then
                write(archivo_txt,'Codigo de producto: ',rM.codigo_producto, ' Precio de venta: $', rM.precio_venta:2:2, ' Stock actual: ', rM.stock_actual, ' Stock minimo: ', rM.stock_minimo, ' Nombre comercial: "', rM.nombre_comercial,'" ' + #10);
        end;
        close(arch);
        close(archivo_txt);
    end;

var
    archivoM : archivo_maestro;
    archivoD : archivo_detalle;
    archivo_txt : Text;
begin
    Assign(archivoM,'maestro');
    Assign(archivoD,'Detalle');
    Assign(archivo_txt,'stock_minimo.txt');
    // crearArchivoMaestro(archivoM);
    // crearArchivoDetalle(archivoD);
    actualizarMaestro(archivoM,archivoD);
    listarATxt(archivoM,archivo_txt);
end.