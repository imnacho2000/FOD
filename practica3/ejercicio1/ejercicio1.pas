
{
Agregar al menú del programa del ejercicio 3, opciones para:
  a. Añadir una o más empleados al final del archivo con sus datos ingresados por
  teclado.
  b. Modificar edad a una o más empleados.
  c. Exportar el contenido del archivo a un archivo de texto llamado
  “todos_empleados.txt”.
  d. Exportar a un archivo de texto llamado: “faltaDNIEmpleado.txt”, los empleados
  que no tengan cargado el DNI (DNI en 00).
  NOTA: Las búsquedas deben realizarse por número de empleado.
}

Program ejercicio1;
const
    valor_alto = 9999;
Type 
  empleado = Record
    num: integer;
    apellido: string[25];
    nombre: string[25];
    edad: integer;
    dni: string[10];
  End;
  arch_emp = file Of empleado;



Procedure cargarEmpleado(Var e:empleado);
Begin
  write('Ingrese apellido del empleado: ');
  readln(e.apellido);
  If (e.apellido <> 'fin') Then
    Begin
      write('Ingrese nombre del empleado: ');
      readln(e.nombre);
      write('Ingrese edad del empleado: ');
      readln(e.edad);
      write('Ingrese dni del empleado: ');
      readln(e.dni);
      write('Ingrese num del empleado: ');
      readln(e.num);
    End;
End;


Procedure menu2();
Begin
  writeln('-----------MENU------------');
  writeln('1.Listar en pantalla los datos de empleados que tengan un nombre o apellido determinado.');
  writeln('2.Listar en pantalla los empleados de a uno por línea.');
  writeln('3.Listar en pantalla empleados mayores de 70 años, próximos a jubilarse.');
  writeln('4.Aniadir empeleados.');
  writeln('5.Modificar edad a un o varios empleados.');
  writeln('6.Exportar el contenido del archivo a un archivo de texto llamado “todos_empleados.txt”.');
  writeln('7.Exportar a un archivo de texto llamado: “faltaDNIEmpleado.txt”, los empleados que no tengan cargado el DNI (DNI en 00).');
  writeln('8.Eliminar empleado');
  writeln('9.Volver atras.');
  write('Ingrese una opcion: ');
End;

Procedure menu();
Begin
  writeln('-----------MENU------------');
  writeln('1.Crear archivo' + #10 +
        '2.Abrir archivo' + #10 + '3.Salir');
  writeln('---------------------------');
  writeln('Ingrese una opcion: ');
End;

Procedure imprimir(e:empleado);
Begin
  write('Nombre: ' + e.nombre + #10 + 'Apellido: ' + e.apellido + #10 + 'Dni: '
        , e.dni , #10 , 'Edad: ' , e.edad , #10 , 'Numero de empleado: ' , e.num
        , #10);
End;

Procedure listado(Var arch:arch_emp);

Var 
  e: empleado;
Begin
  reset(arch);
  While Not eof(arch) Do
    Begin
      read(arch,e);
      imprimir(e);
      writeln();
    End;
  close(arch);
End;

Procedure listadoEmpleadoMayores(Var arch:arch_emp);

Var 
  e: empleado;
Begin
  reset(arch);
  While Not eof(arch) Do
    Begin
      read(arch,e);
      If (e.edad > 70) Then
        imprimir(e);
    End;
  close(arch)
End;

Procedure buscarIgual(Var arch:arch_emp);

Var 
  e: empleado;
  nombre: string;
Begin
  reset(arch);
  write('Ingrese nombre o apellido: ');
  readln(nombre);
  While Not eof(arch) Do
    Begin
      read(arch,e);
      If ((e.nombre = nombre) Or (e.apellido = nombre)) Then
        imprimir(e);
    End;
  close(arch);
End;

procedure modificarEdad(var arch:arch_emp);
var
  e:empleado;
  nro: integer;
  edad: integer;
  ok: boolean;
begin
  ok := false;
  reset(arch);
  write('Ingrese numero del empleado a modificar: ');
  readln(nro);
  while not(nro = -1) do begin
    while not (eof(arch)) do begin
      read(arch,e);
      if(e.num = nro) then begin
        writeln('Empleado encontrado.');
        imprimir(e);
        write('ingrese la edad para modificarlo: ');
        readln(edad);
        e.edad := edad;
        seek(arch,filepos(arch)-1);
        write(arch,e);
        ok:= true;
      end
    end;
    if not (ok) then
      writeln('El empleado no se econtro');
    write('Ingrese numero del empleado a modificar: ');
    readln(nro);
    seek(arch,0);
    ok:= False;
  end;
  close(arch);
end;

procedure exportarV1(var arch:arch_emp);
var
  e:empleado;
  archivo_guardar: Text;
Begin
  reset(arch);
  assign(archivo_guardar,'todos_empleados.txt');
  Rewrite(archivo_guardar);
  while not eof(arch) do begin
    read(arch,e);
    write(archivo_guardar, 'Apellido: '+ e.apellido + ' Nombre: '+ e.nombre+ ' Numero de empleado: ', e.num ,' Edad: ',e.edad,' Dni: '+ e.dni,' ', #10);
  end;
  close(arch);
  close(archivo_guardar);
end;

procedure exportarV2(var arch:arch_emp);
var
  e:empleado;
  archivo_guardar: Text;
begin
  reset(arch);
  assign(archivo_guardar,'faltaDNIEmpleado.txt');
  Rewrite(archivo_guardar);
  while not eof(arch) do begin
    read(arch,e);
    if(e.dni = '00') then
      write(archivo_guardar, 'Apellido: '+ e.apellido + ' Nombre: '+ e.nombre+ ' Numero de empleado: ', e.num ,' Edad: ',e.edad,' Dni: '+ e.dni,' ', #10);
  end;
  close(arch);
  close(archivo_guardar);
end;

Procedure crear(Var arch: arch_emp);
Var 
  e: empleado;
Begin
  Rewrite(arch);
  cargarEmpleado(e);
  While (e.apellido <> 'fin') Do
    Begin
      Write(arch,e);
      cargarEmpleado(e);
    End;
  close(arch);
End;

Procedure aniadir(Var arch: arch_emp);

Var 
  e: empleado;
Begin
  reset(arch);
  cargarEmpleado(e);
  seek(arch,FileSize(arch));
  While (e.apellido <> 'fin') Do
    Begin
      write(arch,e);
      cargarEmpleado(e);
    End;
  Close(arch);
End;

procedure leer_archivo(var arch: arch_emp ; var reg_act: empleado);
begin
    if not eof(arch) then
        read(arch,reg_act)
    else
        reg_act.num := valor_alto;
end;

procedure eliminar_empleado(var arch:arch_emp);
var
    reg_ult: empleado;
    num: integer;
    reg_act: empleado;
begin
    write('Ingrese un numero de empleado a eliminar: ');
    readln(num);
    reset(arch);
    seek(arch,FileSize(arch) - 1);
    read(arch,reg_ult);
    seek(arch,0);
    if(reg_ult.num <> num) then begin
        leer_archivo(arch,reg_act);
        while (reg_act.num <> valor_alto) and (reg_act.num <> num) do 
            leer_archivo(arch,reg_act);
        if(reg_act.num <> valor_alto) then begin
            seek(arch,filepos(arch) - 1);
            write(arch,reg_ult);
            seek(arch,FileSize(arch) - 1);
            truncate(arch);
            writeln('El empleado ', num,' se elimno exitosamente.');
        end
        else
            writeln('El empleado ', num,' no se encuentra en el archivo');
    end
    else begin
        writeln('El empleado ', num,' se elimno exitosamente.');
        seek(arch,FileSize(arch) - 1);
        truncate(arch);
    end;
    close(arch);
end;

Procedure abrir(Var arch: arch_emp);
Var 
  seleccion: char;
Begin
  menu2();
  readln(seleccion);
  Case seleccion Of 
    '1': buscarIgual(arch);
    '2': listado(arch);
    '3': listadoEmpleadoMayores(arch);
    '4': aniadir(arch);
    '5': modificarEdad(arch);
    '6': exportarV1(arch);
    '7': exportarV2(arch);
    '8': eliminar_empleado(arch);
    '9': exit;
    else begin
      write('Ingrese una opcion valida.');
      abrir(arch);
    end;
  End;
  abrir(arch);
End;

Procedure MostrarMenu(Var arch: arch_emp);

Var 
  seleccion: char;
Begin
  menu();
  readln(seleccion);
  Case seleccion Of 
    '1': crear(arch);
    '2': abrir(arch);
    '3': halt;
    else begin
      write('Ingrese una opcion valida.');
      MostrarMenu(arch);
    end;
  end;
  MostrarMenu(arch);
End;

Var 
  archivo : arch_emp;
  nombre: string;
Begin
  write('Ingrese nombre del archivo binario con el que va a trabjar: ');
  readln(nombre);
  Assign(archivo,nombre);
  MostrarMenu(archivo);
End.
