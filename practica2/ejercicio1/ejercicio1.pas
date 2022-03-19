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
    empleados_detalles = record
        cod_emp : integer;
        monto_diario : real;
    end;
    empleados_m = file of empleados;
    empleados_d = file of empleados_detalles;
    
    procedure leer(var detalle: empleados_d; var empleados_detalles: empleados_detalles);
    begin
        if not eof(detalle) then
            read(detalle,empleados_detalles)
        else 
            empleados_detalles.cod_emp := corte;
    end;

    // En compactar recibo por parametro el maestro y el detalle //
    procedure compactar(var maestro: empleados_m; var detalle:empleados_d);
    var
        // Declaro eM como registro del maestro y eD como registro del detalle //
        eM:empleados;
        eD:empleados_detalles;
    begin
        // Abro tanto al maestro como el detalle//
        reset(maestro);
        reset(detalle);
        // Leo el archivo del detalle, saco el codigo y mientras el codigo del detalle sea distinto al corte//
        leer(detalle,eD);
        while(eD.cod_emp <> corte) do begin
            // Leo el registro del archivo del maestro//
            read(maestro,eM);
            // Mientras el codigo sea distinto del archivo maestro al del detalle, leo hasta que sean iguales//
            while(eM.cod_emp <> eD.cod_emp) do 
                read(maestro,eM);
            // Cuando son iguales hago un while hasta que sean distintos, es decir, trato de buscar todas las ocurriencias para ese mismo codigo //
            while(eD.cod_emp = eM.cod_emp) do begin
                // Voy sumando los montos diarios al monto del maestro //
                eM.monto_com := eM.monto_com + eD.monto_diario;
                // Leo el detalle //
                leer(detalle,eD);
            end;
            // Me posiciono al registro anterior, en el archivo maestro, y escribo (actualizo) el registro en esa posicion//
            seek(maestro,filepos(maestro) - 1);
            write(maestro,eM);
        end;
        close(maestro);
        close(detalle);
    end;

var
    detalle : empleados_d;
    maestro : empleados_m;
begin
    Assign(maestro,'maestro');
    Assign(detalle,'detalle');
    compactar(maestro,detalle);
end.