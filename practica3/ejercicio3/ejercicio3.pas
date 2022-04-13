{
    Realizar un programa que genere un archivo de novelas filmadas durante el presente
    año. De cada novela se registra: código, género, nombre, duración, director y precio.
    El programa debe presentar un menú con las siguientes opciones:
    a. Crear el archivo y cargarlo a partir de datos ingresados por teclado. Se
    utiliza la técnica de lista invertida para recuperar espacio libre en el
    archivo. Para ello, durante la creación del archivo, en el primer registro del
    mismo se debe almacenar la cabecera de la lista. Es decir un registro
    ficticio, inicializando con el valor cero (0) el campo correspondiente al
    código de novela, el cual indica que no hay espacio libre dentro del
    archivo.
    b. Abrir el archivo existente y permitir su mantenimiento teniendo en cuenta el
    inciso a., se utiliza lista invertida para recuperación de espacio. En
    particular, para el campo de  ́enlace ́ de la lista, se debe especificar los
    números de registro referenciados con signo negativo, (utilice el código de
    novela como enlace).Una vez abierto el archivo, brindar operaciones para:
    i. Dar de alta una novela leyendo la información desde teclado. Para
    esta operación, en caso de ser posible, deberá recuperarse el
    espacio libre. Es decir, si en el campo correspondiente al código de
    novela del registro cabecera hay un valor negativo, por ejemplo -5,
    se debe leer el registro en la posición 5, copiarlo en la posición 0
    (actualizar la lista de espacio libre) y grabar el nuevo registro en la
    posición 5. Con el valor 0 (cero) en el registro cabecera se indica
    que no hay espacio libre.
    ii. Modificar los datos de una novela leyendo la información desde
    teclado. El  código de novela no puede ser modificado.
    iii. Eliminar una novela cuyo código es ingresado por teclado. Por
    ejemplo, si se da de baja un registro en la posición 8, en el campo
    código de novela del registro cabecera deberá figurar -8, y en el
    registro en la posición 8 debe copiarse el antiguo registro cabecera.
    c. Listar en un archivo de texto todas las novelas, incluyendo las borradas, que
    representan la lista de espacio libre. El archivo debe llamarse “novelas.txt”.
    NOTA: Tanto en la creación como en la apertura el nombre del archivo debe ser
    proporcionado por el usuario.
}

program ejercicio3;
const
    valor_alto = 9999;
type
    novela = record
        cod: integer;
        genero: string[25];
        nombre: string[25];
        duracion: integer;
        director: string[25];
        precio: real;
    end;

    maestro = file of novela;

    procedure leer_novela(var reg_m: novela);
    begin
        write('Ingrese codigo de novela: ');
        readln(reg_m.cod);
        if(reg_m.cod <> -1) then begin
            write('Ingrese genero de novela: ');
            readln(reg_m.genero);
            write('Ingrese nombre de novela: ');
            readln(reg_m.nombre);
            write('Ingrese duracion de novela: ');
            readln(reg_m.duracion);
            write('Ingrese director de novela: ');
            readln(reg_m.director);
            write('Ingrese precio de novela: ');
            readln(reg_m.precio);
        end;
    end;

    procedure crear_archivo(var m: maestro);
    var
        reg_m: novela;
    begin
        rewrite(m);
        reg_m.cod := 0;
        write(m,reg_m);
        leer_novela(reg_m);
        while(reg_m.cod <> -1) do begin
            write(m,reg_m);
            leer_novela(reg_m);
        end;
        close(m);
    end;

    procedure dar_alta(var m: maestro);
    var
        reg_registrar: novela;
        reg_m: novela;
    begin
        leer_novela(reg_registrar);
        if(reg_registrar.cod > 0) then begin
            reset(m);
            read(m, reg_m);
            if(reg_m.cod <> 0) then begin
                seek(m,Abs(reg_m.cod));
                read(m,reg_m);
                seek(m, filepos(m)-1);
                write(m,reg_registrar);
                seek(m,0);
                write(m,reg_m);
            end;
        end
        else begin
            seek(m,filesize(m));
            write(m,reg_registrar);
        end;
        close(m);
    end;
    
    procedure modificar(var m:maestro);
    var
        cod: integer;
        reg_m: novela;
        reg_aux: novela;
    begin
        write('Ingrese codigo de novela: ');
        readln(cod);
        reset(m);
        read(m,reg_m);
        while not eof(m) and (reg_m.cod <> cod) do 
            read(m,reg_m);
        if reg_m.cod = cod then begin
            leer_novela(reg_aux);
            reg_aux.cod := reg_m.cod; 
            seek(m,filepos(m) - 1);
            write(m,reg_aux);
        end
        else
            write('El codigo de novela ', cod, ' no se encuentra en el archivo');
        close(m);
    end;


    procedure eliminar(var m: maestro);
    var
        cod: integer;
        reg_m: novela;
        head: integer;
    begin
        write('Ingrese codigo de novela: ');
        readln(cod);
        reset(m);
        read(m,reg_m);
        head:= reg_m.cod;
        while not eof(m) and (reg_m.cod <> cod) do 
            read(m,reg_m);
        if reg_m.cod = cod then begin
            reg_m.cod := head;
            head := ((filepos(m) - 1) * -1);
            seek(m,filepos(m)-1);
            write(m, reg_m);
            seek(m,0);
            reg_m.cod := head;
            write(m,reg_m);
        end
        else
            writeln('El codigo de la novlea, ',cod,' no se encuentra en el archivo');
        close(m);
    end;
   
    procedure imprimir_novela(reg_m: novela);
    begin
        writeln('');
        writeln('Codigo de la novela: ', reg_m.cod);
        writeln('Genero de la novela: ', reg_m.genero);
        writeln('Nombre de la novela: ', reg_m.nombre);
        writeln('Duracion de la novela: ', reg_m.duracion);
        writeln('Director de la novela: ', reg_m.director);
        writeln('Precio de la novela: $', reg_m.precio:2:2);
        writeln('');
    end;

    procedure imprimir_maestro(var m: maestro);
    var
        reg_m: novela;
    begin
        reset(m);
        while not eof(m) do begin
            read(m,reg_m);
            imprimir_novela(reg_m);
        end;
        close(m);
    end;

    procedure exportar_txt(var m:maestro);
    var
        arch_txt: Text;
        reg_m: novela;
    begin
        Assign(arch_txt,'novelas.txt');
        rewrite(arch_txt);
        reset(m);
        while not eof(m) do begin
            read(m,reg_m);
            write(arch_txt,'Codigo de novela: ', reg_m.cod, #10, 'Genero de novela: ', reg_m.genero, #10, 'Nombre de la novela: ', reg_m.nombre, #10, 'Duracion de la novela: ', reg_m.duracion, #10, 'Director de la novela: ', reg_m.director, #10, 'Precio de la novela: $', reg_m.precio:2:2, #10, #10);
        end;
        close(m);
        close(arch_txt);
    end;

    procedure mostrar_abrir();
    begin
        writeln('');
        writeln('----------MENU----------');
        writeln('1. Dar de alta novela');
        writeln('2. Modificar novela.');
        writeln('3. Eliminar novela.');
        writeln('4. Listar novelas.');
        writeln('5. Listar a TXT.');
        writeln('6. Imprimir archivo.');
        writeln('7. Volver atras.');
        writeln('------------------------',#10);
        write('Ingrese opcion: ');
    end;

    procedure abrir(var m:maestro);
    var
        seleccion: string;
    begin
        mostrar_abrir();
        readln(seleccion);
        case seleccion of
            '1': dar_alta(m);
            '2': modificar(m);
            '3': eliminar(m);
            '4': imprimir_maestro(m);
            '5': exportar_txt(m);
            '6': imprimir_maestro(m);
            '7': exit;
        end;
        abrir(m);
    end;
    
    
    procedure menu_inicio();
    begin
        writeln('');
        writeln('----------MENU----------');
        writeln('1. Crear archivo.');
        writeln('2. Abrir archivo.');
        writeln('3. Salir');
        writeln('------------------------',#10);
        write('Ingrese opcion: ');
    end;

    procedure inicio(var m: maestro);
    var
        seleccion: string;
    begin
        menu_inicio();
        readln(seleccion);
        Case seleccion Of 
            '1': crear_archivo(m);
            '2': abrir(m);
            '3': halt;
        end;
        inicio(m);
    end;


var
    m: maestro;
    input: string[25];
begin
    write('Ingrese nombre del archivo con el que va a trabajar: ');
    readln(input);
    Assign(m,input);
    inicio(m);
end.