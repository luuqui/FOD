program ej3;
type
	empleado = record
		nro,edad,dni: integer;
		apellido, nombre: string;
	end;
	
	archivo_emp = file of empleado;

procedure crearArchivo(var arc_log: archivo_emp; nom:string);
	procedure preguntas(var e: empleado);
	begin
		writeln('Ingrese nro de empleado: '); readln(e.nro);
		writeln('Ingrese edad: '); readln(e.edad);
		writeln('Ingrese dni: '); readln(e.dni);
		writeln('Ingrese apellido: '); readln(e.apellido);
		writeln('Ingrese nombre: '); readln(e.nombre);
	end;
var
	e: empleado;
begin
	assign(arc_log, nom);
	rewrite(arc_log);
	preguntas(e);
	while(e.apellido <> 'fin') do begin
		write(arc_log, e);
		preguntas(e);
	end;
	close(arc_log);
end;

procedure mostrar(e: empleado);
begin
	writeln('Nro de empleado: ', e.nro);
	writeln('Dni: ', e.dni);
	writeln('Nombre: ', e.nombre);
	writeln('Apellido: ', e.apellido);
	writeln('Edad: ', e.edad);
end;

procedure listarPorNombre(var arc_log: archivo_emp);
var
	cadena: string;
	e: empleado;
begin
	writeln('Ingrese nombre o apellido a buscar: ');
	readln(cadena);
	while not eof (arc_log) do begin
		read(arc_log, e);
		if(e.apellido = cadena) or (e.nombre = cadena)then
			mostrar(e);
	end;
	seek(arc_log, 0);
end;

procedure listar(var arc_log: archivo_emp);
var
	e: empleado;
begin
	while not eof (arc_log) do begin
		read(arc_log, e);
		mostrar(e);
	end;
	seek(arc_log, 0);
end;

procedure listarEdad(var arc_log: archivo_emp);
var
	e: empleado;
begin
	while not eof (arc_log) do begin
		read(arc_log, e);
		if(e.edad > 70)then
			mostrar(e);
	end;
	seek(arc_log, 0);
end;

procedure abrirArchivo(var arc_log: archivo_emp; nom:string);
var
	opc: integer;
begin
	repeat
		writeln('Seleccione: ');
		writeln('1 - Listar con nombre y apellido determinado');
		writeln('2 - Listar empleados');
		writeln('3 - Listar empleados mayores de 70 anios');
		writeln('0 - Cerrar');
		readln(opc);
		case opc of
			1: listarPorNombre(arc_log);
			2: listar(arc_log);
			3: listarEdad(arc_log);
			0: ;
			else writeln('Ingrese una opcion valida');
		end;
	until (opc=0)
end;

VAR
	arc_log: archivo_emp;
	opc: integer;
	nom:string;
BEGIN
	repeat
		writeln('Ingrese nombre del archivo a crear - abrir: '); 
		readln(nom);
		writeln('Seleccione abrir o crear un archivo.');
		writeln('1 - Crear');
		writeln('2 - Abrir');
		writeln('0 - Cerrar');
		readln(opc);
		case opc of
			0: ;
			1: crearArchivo(arc_log, nom);
			2: begin 
				assign(arc_log,nom);
				reset(arc_log);
				abrirArchivo(arc_log, nom);
				close(arc_log);
				end;
		else writeln('Ingrese una opcion correcta');
		end;
	until (opc=0)
END.

