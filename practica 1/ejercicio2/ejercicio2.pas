{Realizar un algoritmo, que utilizando el archivo de números enteros no ordenados
creados en el ejercicio 1, informe por pantalla cantidad de números menores a 1500 y
el promedio de los números ingresados. El nombre del archivo a procesar debe ser
proporcionado por el usuario una única vez. Además, el algoritmo deberá listar el
contenido del archivo en pantalla.}

program ejercicio2;

type
	archivo = file of integer;


procedure imprimir2(var arch:archivo);
var
	nro:integer;
begin
	reset(arch);
	while not eof(arch)do begin;
		read(arch,nro);
		writeln('El numero es: ',nro);
	end;
	close(arch);
end;


procedure imprimir(var arch:archivo);
var
	nro: integer;
	cant: integer;
	suma: real;
	promedio: real;
begin
	cant:=0;
	suma:= 0;
	reset(arch);
	while not eof(arch)do begin;
		read(arch,nro);
		if(nro < 1500) then begin
			cant:= cant + 1;
		end;
		suma:= nro + suma;
	end;
	promedio:= suma / FileSize(arch);
	writeln('El promedio es: ',promedio:2:2);
	writeln('La cantidad de numeros es: ',cant);
	close(arch);
end;

var
	archivo_ejercicio1: archivo;
	ruta_acceso: string;
begin
	write('Ingrese una ruta de acceso: ');
	read(ruta_acceso);
	Assign(archivo_ejercicio1,ruta_acceso);
	imprimir2(archivo_ejercicio1);
	imprimir(archivo_ejercicio1);
end.
