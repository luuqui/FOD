program ej3;
type
	empleado = record
		nro,edad,dni: integer;
		apellido, nombre: string;
	end;
	
	archivo_emp = file of empleado;
	
	carga = Text;
	
procedure preguntas(var e: empleado);
begin
	writeln('Ingrese nro de empleado: '); readln(e.nro);
	writeln('Ingrese edad: '); readln(e.edad);
	writeln('Ingrese dni: '); readln(e.dni);
	writeln('Ingrese apellido: '); readln(e.apellido);
	writeln('Ingrese nombre: '); readln(e.nombre);
end;

procedure crearArchivo(var arc_log: archivo_emp; nom:string);
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
	seek(arc_log, 0);
	writeln('Ingrese nombre o apellido a buscar: ');
	readln(cadena);
	while not eof (arc_log) do begin
		read(arc_log, e);
		if(e.apellido = cadena) or (e.nombre = cadena)then
			mostrar(e);
	end;
end;

procedure listar(var arc_log: archivo_emp);
var
	e: empleado;
begin
	seek(arc_log, 0);
	while not eof (arc_log) do begin
		read(arc_log, e);
		mostrar(e);
	end;
end;

procedure listarEdad(var arc_log: archivo_emp);
var
	e: empleado;
begin
	seek(arc_log, 0);
	while not eof (arc_log) do begin
		read(arc_log, e);
		if(e.edad > 70)then
			mostrar(e);
	end;
end;

procedure agregarEmpleado(var arc_log: archivo_emp);
	function existeNro(var arc_log: archivo_emp; e:empleado):boolean;
	var
		emp: empleado;
	begin
		seek(arc_log, 0);
		existeNro:= false;
		while not eof(arc_log) and (not existeNro) do begin
			read(arc_log, emp);
			if(emp.nro = e.nro)then
				existeNro:= true;
		end;
	end;
var
	e: empleado;
begin
	seek(arc_log, 0);
	preguntas(e);
	while e.apellido <> 'fin' do begin
		if (not existeNro(arc_log, e))then begin
			seek(arc_log, filesize(arc_log));
			write(arc_log, e);
			writeln('Empleado agregado')
		end
		else
			writeln('Ya existe empleado con ese nro');
		preguntas(e);
	end;
end;

procedure modificarEdad(var arc_log: archivo_emp);
var
	edad, nro: integer;
	e: empleado;
	existe: boolean;
begin
	seek(arc_log, 0);
	existe:= false;
	writeln('Ingrese nro de empleado: ');
	readln(nro);
	while not eof and (not existe) do begin
		read(arc_log, e);
		if(e.nro = nro)then begin
			existe:= true;
			writeln('Ingrese nueva edad: ');
			readln(edad);
			e.edad:= edad;
			seek(arc_log, filepos(arc_log)-1);
			write(arc_log, e);
		end;
	end;
end;

procedure exportarTodos(var arc_log: archivo_emp);
var
	nom: string;
	arc_txt: carga;
	emp: empleado;
begin
	seek(arc_log, 0);
	writeln('Ingrese nombre del archivo de texto: ');
	readln(nom);
	assign(arc_txt, nom);
	rewrite(arc_txt);
	while not eof(arc_log) do begin
		read(arc_log, emp);
		writeln(arc_txt, emp.nro,' ', emp.dni,' ', emp.nombre,' ',emp.apellido,
			' ',emp.edad);
	end;
	close(arc_txt);
end;

procedure exportarDni(var arc_log: archivo_emp);
var
	emp: empleado;
	arc_txt: carga;
begin
	seek(arc_log, 0);
	assign(arc_txt, 'faltaDNIEmpleado.txt');
	rewrite(arc_txt);
	while not eof(arc_log)do begin
		read(arc_log, emp);
		if(emp.dni = 0)then
			writeln(arc_txt, emp.nro,' ', emp.dni,' ', emp.nombre,' ',emp.apellido,
			' ',emp.edad);
	end;
	close(arc_txt);
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
		writeln('4 - Agregar empleados');
		writeln('5 - Modificar edad de un empleado');
		writeln('6 - Exportar contenido a un archivo de texto');
		writeln('7 - Exportar empleados con dni 0 a texto');
		writeln('0 - Cerrar');
		readln(opc);
		case opc of
			1: listarPorNombre(arc_log);
			2: listar(arc_log);
			3: listarEdad(arc_log);
			4: agregarEmpleado(arc_log);
			5: modificarEdad(arc_log);
			6: exportarTodos(arc_log);
			7: exportarDni(arc_log);
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

