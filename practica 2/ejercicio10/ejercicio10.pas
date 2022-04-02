{
    Se tiene información en un archivo de las horas extras realizadas por los empleados de
    una empresa en un mes. Para cada empleado se tiene la siguiente información:
    departamento, división, número de empleado, categoría y cantidad de horas extras
    realizadas por el empleado. Se sabe que el archivo se encuentra ordenado por
    departamento, luego por división, y por último, por número de empleados. Presentar en
    pantalla un listado con el siguiente formato:
    Departamento
    División
    Número de Empleado Total de Hs. Importe a cobrar
    ...... .......... .........
    ...... .......... .........
    Total de horas división: ____
    Monto total por división: ____
    División
    .................
    Total horas departamento: ____
    Monto total departamento: ____
    Para obtener el valor de la hora se debe cargar un arreglo desde un archivo de texto al
    iniciar el programa con el valor de la hora extra para cada categoría. La categoría varía
    de 1 a 15. En el archivo de texto debe haber una línea para cada categoría con el número
    de categoría y el valor de la hora, pero el arreglo debe ser de valores de horas, con la
    posición del valor coincidente con el número de categoría.

}

program ejercicio10;
const
    cateogorias = 15;
    valorCorte = 9999;
type
    archM = record
        departamento : integer;
        division : integer;
        numero_empleado : integer;
        categoria : integer;
        cantidad_horas_extras : integer;
    end;

    archivo_maestro = file of archM;
    arreglo_horas = array[1..cateogorias] of integer;

    procedure cargarEmpleado(var rM: archM);
    begin
        write('Ingrese codigo de Departamento: ');
        readln(rM.departamento);
        if(rM.departamento <> -1) then begin
            write('Ingrese codigo de division: ');
            readln(rM.division);
            write('Ingrese numero de empleado: ');
            readln(rM.numero_empleado);
            write('Ingrese categoria: ');
            readln(rM.categoria);
            write('Ingrese cantidad de horas extras: ');
            readln(rM.cantidad_horas_extras);
        end;
    end;

    procedure crearArchivoMaestro(var arch: archivo_maestro);
    var
        rM: archM;
    begin
        rewrite(arch);
        cargarEmpleado(rM);
        while(rM.departamento <> -1) do begin
            write(arch,rM);
            cargarEmpleado(rM);
        end;
        close(arch);
    end;

    procedure leer(var arch: archivo_maestro; var rM: archM);
    begin
        if not eof(arch) then 
            read(arch,rM)
        else
            rM.departamento := valorCorte;
    end;

    procedure cargarArregloHoras(var archivo_txt : Text; var arreglo : arreglo_horas);
    var
        pos,valor:integer;
    begin
        reset(archivo_txt);
        while not eof(archivo_txt) do begin
            readln(archivo_txt,pos,valor);
           arreglo[pos]:=valor;
        end;
        close(archivo_txt);
    end;

    procedure procesarArchvoMaestro(var arch: archivo_maestro; var arreglo : arreglo_horas ; var archivo_txt: Text);
    var
        categoria_aux,total_aux,total_horas,monto_total,monto_total_division,total_horas_division,monto_aux: integer;
        cod_depto_aux, division_aux, numero_empleado_aux: integer;
        rM : archM;
    begin
        reset(arch);
        leer(arch,rM);
        cargarArregloHoras(archivo_txt,arreglo);
        while(rM.departamento <> valorCorte) do begin
            writeln('Departamento: ', rM.departamento);
            cod_depto_aux := rM.departamento;
            total_horas:= 0;
            monto_total:= 0;
            while(cod_depto_aux = rM.departamento) do begin
                division_aux := rM.division;
                total_horas_division:= 0;
                monto_total_division:= 0;
                while(cod_depto_aux = rM.departamento) and (division_aux = rM.division) do begin
                    numero_empleado_aux:= rM.numero_empleado;
                    categoria_aux := rM.categoria;
                    writeln('Numero de empleado     Total de hs.     Importe a cobrar');
                    monto_aux := 0;
                    total_aux := 0;
                    while (cod_depto_aux = rM.departamento) and (division_aux = rM.division) and (numero_empleado_aux = rM.numero_empleado) do begin
                        writeln('         ',rM.numero_empleado,'                  ',rM.cantidad_horas_extras,'                  ',arreglo[rM.categoria]);
                        total_aux := total_aux + rM.cantidad_horas_extras;
                        leer(arch,rM);
                    end;
                    monto_aux:= monto_aux + (total_aux * arreglo[categoria_aux]);
                    monto_total_division:= monto_total_division + monto_aux;
                    total_horas_division := total_horas_division + total_aux;
                end;
                writeln('Division ',#10, rM.division);
                writeln('Total horas division: ',total_horas_division);
                writeln('Monto total por division: ', monto_total_division);
                total_horas := total_horas + total_horas_division;
                monto_total := monto_total + monto_total_division;
            end;
            writeln('Total horas departamento: ', total_horas);
            writeln('Monto total departamento: ', monto_total);
        end;
        close(arch);
    end;


var
    archivo_texto : Text;
    archivoM : archivo_maestro;
    arreglo : arreglo_horas;
begin
    Assign(archivoM,'maestro');
    Assign(archivo_texto,'valoresVector.txt');
    // crearArchivoMaestro(archivoM);
    procesarArchvoMaestro(archivoM,arreglo,archivo_texto);
end.