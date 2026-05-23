program ej3;
type
	libro = record
		codigo, cantidadPaginas: integer;
		genero, autor, titulo: string;
		precio: real;
	end;
	
	archivo_libro = file of libro;
	
procedure preguntas(var l: libro);
begin
	writeln('Ingrese el codigo: ');
	readln(l.codigo);
	if(l.codigo <> -1)then begin
		write('Ingrese el titulo: ');
		readln(l.titulo);
		write('Ingrese el autor: ');
		readln(l.autor);
		write('Ingrese el genero: ');
		readln(l.genero);
		write('Ingrese la cantidad de paginas: ');
		readln(l.cantidadPaginas);
		write('Ingrese el precio: ');
		readln(l.precio);
	end;
end;

procedure crearArchivo(var mae: archivo_libro; nom:string);
var
	l: libro;
begin
	assign(mae, nom);
	rewrite(mae);
	l.codigo:= 0;
	l.cantidadPaginas:= 0;
	l.genero := '';
	l.autor:= '';
	l.precio:= 0;
	write(mae, l);
	preguntas(l);
	while(l.codigo <> -1)do begin
		write(mae, l);
		preguntas(l);
	end;
	close(mae);
end;

procedure alta(var mae: archivo_libro);
var
	l, aux: libro;
begin
	preguntas(l);
	seek(mae, 0);
	read(mae, aux);
	if(aux.codigo = 0)then begin
		seek(mae, fileSize(mae)-1);
		write(mae, l);
	end
	else
		begin
			seek(mae, aux.codigo * -1);
			read(mae, aux);
			seek(mae, filepos(mae)-1);
			write(mae, l);
			seek(mae, 0);
			write(mae, aux);
		end;
end;

procedure modf(var mae: archivo_libro);
var
	l, aux: libro;
	n: integer;
	flag: boolean;
begin
	flag:= false;
	writeln('Ingrese el codigo del libro a modificar');
	readln(n);
	seek(mae, 0);
	read(mae, l);
	while(not EOF(mae) and (not flag))do begin
		read(mae, l);
		if(l.codigo = n)and(n > 0)then begin
			flag:= true;
			aux.codigo:= l.codigo;
			writeln('Codigo encontrado. Ingrese los datos a modificar: ');
			write('Ingrese el titulo: ');
			readln(aux.titulo);
			write('Ingrese el autor: ');
			readln(aux.autor);
			write('Ingrese el genero: ');
			readln(aux.genero);
			write('Ingrese la cantidad de paginas: ');
			readln(aux.cantidadPaginas);
			write('Ingrese el precio: ');
			readln(aux.precio);
			seek(mae, filepos(mae)-1);
			write(mae, aux);
		end;
	end;
	if(not flag)then
		writeln('Codigo no encontrado');
end;

procedure delete(var mae: archivo_libro);
var
	n, cabecera, posBorrar: integer;
	aux: libro;
	flag: boolean;
begin
	flag:= false;
	writeln('Ingrese el codigo del libro a eliminar: ');
	readln(n);
	seek(mae, 0);
	read(mae, aux);
	cabecera:= aux.codigo;
	while(not EOF(mae) and (not flag))do begin
		read(mae, aux);
		if(aux.codigo = n)then begin
			flag:= true;
			posBorrar:= filepos(mae)-1;
			aux.codigo:= cabecera;
			
			seek(mae, posBorrar);
			write(mae, aux);
			
			seek(mae, 0);
			read(mae, aux);
			
			aux.codigo:= posBorrar * -1;
			
			seek(mae, 0);
			write(mae, aux);
		end;
	end;
	if(flag)then
		writeln('Libro borrado')
	else
		writeln('Codigo no encontrado');
end;

procedure exportarATxt(var mae: archivo_libro);
var
	nom: Text;
	regLib: libro;
begin
	assign(nom, 'libros.txt');
	rewrite(nom);
	seek(mae, 0);
	read(mae, regLib);
	while(not EOF(mae))do begin
		read(mae, regLib);
		if(regLib.codigo > 0)then
			writeln(nom, regLib.codigo, ' ', regLib.precio:0:2, ' ', regLib.cantidadPaginas, ' ', regLib.genero, ' ', regLib.titulo, ' ', regLib.autor);
	end;
	close(nom);
end;

procedure abrirArchivo(var mae: archivo_libro; nom: string);
var
	op: integer;
begin
	assign(mae, nom);
	reset(mae);
	repeat
		writeln('Ingrese una opcion: ');
		writeln('1. Dar de alta un libro');
		writeln('2. Modificar datos de un libro');
		writeln('3. Eliminar un libro');
		writeln('0. Salir');
		readln(op);
		case op of
			1: alta(mae);
			2: modf(mae);
			3: delete(mae);
			4: exportarATxt(mae);
			0: ;
		else writeln('Ingrese una opcion correcta');
		end;
	until (op=0);
	close(mae);
end;

VAR
	op: integer;
	nom: string;
	mae: archivo_libro;
BEGIN
	repeat
		writeln('Ingrese nombre del archivo a crear - abrir');
		readln(nom);
		writeln('Seleccione abrir o crear un archivo.');
		writeln('1 - Crear');
		writeln('2 - Abrir');
		writeln('0 - Cerrar');
		readln(op);;
		case op of
			1: crearArchivo(mae, nom);
			2: abrirArchivo(mae, nom);
			0: ;
		else writeln('Ingrese una opcion correcta');
		end;
	until (op=0)
END.

