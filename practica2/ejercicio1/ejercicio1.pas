{ 

    Una empresa posee un archivo con información de los ingresos percibidos por diferentes
    empleados en concepto de comisión, de cada uno de ellos se conoce: código de empleado,
    nombre y monto de la comisión. La información del archivo se encuentra ordenada por
    código de empleado y cada empleado puede aparecer más de una vez en el archivo de
    comisiones.
    Realice un procedimiento que reciba el archivo anteriormente descripto y lo compacte. En
    consecuencia, deberá generar un nuevo archivo en el cual, cada empleado aparezca una
    única vez con el valor total de sus comisiones.
    NOTA: No se conoce a priori la cantidad de empleados. Además, el archivo debe ser
    recorrido una única vez.

}

program ejercicio1;
const
    corte = 9999;
type
    empleados = record
        cod_emp : integer;
        nombre : String;
        monto_com : real;
    end;
    // Como el detalle debe tener el mismo corte de control utilizo el cod_emp y un monto diario para actualizar //
    empleados_m = file of empleados;
    
    procedure leer(var maestro: empleados_m; var empleados: empleados);
    begin
        if not eof(maestro) then
            read(maestro,empleados)
        else 
            empleados.cod_emp := corte;
    end;

    // procedure cargar_empleados(var e:empleados);
    // begin
    //     write('Ingrese codigo de empleado: ');
    //     readln(e.cod_emp);
    //     if(e.cod_emp <> -1) then begin
    //         write('Ingrese nombre de empleado: ');
    //         readln(e.nombre);
    //         write('Ingrese comision: ');
    //         readln(e.monto_com);
    //     end;
    // end;

    // procedure crearArchivo(var archivo_empleados: empleados_m);
    // var
    //     e: empleados;
    // begin
    //     rewrite(archivo_empleados);
    //     cargar_empleados(e);
    //     while(e.cod_emp <> -1) do begin
    //         write(archivo_empleados,e);
    //         cargar_empleados(e);
    //     end;
    //     close(archivo_empleados);
    // end;


    procedure imprimirE(e: empleados);
    begin
        writeln('');
        writeln('Codigo de empleado: ', e.cod_emp);
        writeln('Nombre: ', e.nombre);
        writeln('Monto: ', e.monto_com:2:2);
    end;
    procedure imprimir(var arch: empleados_m);
    var
        e:empleados;
    begin
        reset(arch);
        while not eof(arch) do begin
            read(arch, e);
            imprimirE(e)
        end;
        close(arch);
    end;
    // En compactar recibo por parametro el maestro y el archivo nuevo.//
    procedure compactar(var maestro: empleados_m; var compacto: empleados_m);
    var
        actual_empleado:empleados;
        empleado:empleados;
    begin
        reset(maestro);
        rewrite(compacto);
        // Leo el archivo de empleados //
        leer(maestro,empleado);
        while(empleado.cod_emp <> corte) do begin
            // A mi registro actual le paso los datos del registro que lei en el archivo de empleados //
            actual_empleado.cod_emp := empleado.cod_emp;
            actual_empleado.nombre := empleado.nombre;
            actual_empleado.monto_com := 0;
            // Mientras el actual sea igual al codigo del registro que voy leyendo en el archivo de empleado, le sumo la comision //
            while(actual_empleado.cod_emp = empleado.cod_emp) do begin
                actual_empleado.monto_com := actual_empleado.monto_com + empleado.monto_com;
                // Leo para ver si son iguales en caso que no, escribo y le asigno al empleado actual los datos correspondientes//
                leer(maestro,empleado);
            end;
            // Una vez finalizada la suma y la busqueda escribo en el nuevo archivo el registro de empelado completamente. //
            write(compacto,actual_empleado);
        end;
        close(maestro);
        close(compacto);
    end;

var
    compacto : empleados_m;
    maestro : empleados_m;
begin
    Assign(maestro,'empleados');
    // crearArchivo(maestro);
    Assign(compacto,'compacto');
    writeln('Archivo antes de compactar: ');
    imprimir(maestro);
    compactar(maestro,compacto);
    writeln('Archivo despues de compactar: ');
    imprimir(compacto);
end.