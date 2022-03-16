



{	Realizar un programa que presente un menú con opciones para:
		a. Crear un archivo de registros no ordenados de empleados y completarlo con
		datos ingresados desde teclado. De cada empleado se registra: número de
		empleado, apellido, nombre, edad y DNI. Algunos empleados se ingresan con
		DNI 00. La carga finaliza cuando se ingresa el String ‘fin’ como apellido.
		b. Abrir el archivo anteriormente generado y
		i. Listar en pantalla los datos de empleados que tengan un nombre o apellido
		determinado.
		ii. Listar en pantalla los empleados de a uno por línea.
		iii. Listar en pantalla empleados mayores de 70 años, próximos a jubilarse.
		NOTA: El nombre del archivo a crear o utilizar debe ser proporcionado por el usuario una
		única vez.
}

Program ejercicio3;

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
  write('Ingrese una opcion: ' + #10 
      + '1.Listar en pantalla los datos de empleados que tengan un nombre o apellido determinado.' + #10
      + '2.Listar en pantalla los empleados de a uno por línea.' + #10
      + '3.Listar en pantalla empleados mayores de 70 años, próximos a jubilarse.' + #10 
      + '4.Volver atras.' + #10 
      + ': ');
End;

Procedure menu();
Begin
  write('Ingrese una opcion: ' + #10 
      + '1.Crear archivo' + #10 
      + '2.Abrir archivo' + #10 
      + '3.Salir' + #10 
      + ': ');
End;

Procedure imprimir(e:empleado);
Begin
  write('Nombre: ' + e.nombre + #10
       + 'Apellido: ' + e.apellido + #10 
       + 'Dni: ' , e.dni , #10
       , 'Edad: ' , e.edad , #10 
       , 'Numero de empleado: ' , e.num, #10);
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
  close(arch);
End;

Procedure buscarIgual(Var arch:arch_emp);

Var 
  e: empleado;
  nombre: string;
  ok: boolean;
Begin
  ok:= False;
  reset(arch);
  write('Ingrese nombre o apellido: ');
  readln(nombre);
  While Not eof(arch) Do
    Begin
      read(arch,e);
      If ((e.nombre = nombre) Or (e.apellido = nombre)) Then
        imprimir(e);
        ok:= True;
  End;
  if not(ok) then
    writeln('El empleado no se encontro');
  close(arch);
End;

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
    '4': exit;
    else begin
      write('Ingrese una opcion valida');
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
      writeln('Ingrese una opcion valida.');
      MostrarMenu(arch);
    end;
  End;
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
