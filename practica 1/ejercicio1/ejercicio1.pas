{Realizar un algoritmo que cree un archivo de números enteros no ordenados y permita
incorporar datos al archivo. Los números son ingresados desde teclado. El nombre del
archivo debe ser proporcionado por el usuario desde teclado. La carga finaliza cuando
se ingrese el número 30000, que no debe incorporarse al archivo}



program ejercicio1;
type
	arch = file of integer;
var 
	archivo : arch;
	archivo_fisico : string;
	nro : integer;
begin
	write('Ingrese nombre de archivo: ');
	read(archivo_fisico);
	Assign(archivo, archivo_fisico);
	rewrite(archivo);
	write('Ingrese un numero: ');
	read(nro);
	while (nro <> 30000) do begin
		Write(archivo,nro);
		write('Ingrese un numero: ');
		read(nro);
	end;
	imprimir(archivo);
	close(archivo);
end.
