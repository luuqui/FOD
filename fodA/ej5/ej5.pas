program ej5;

type

	celular = record
		cod, stockMin, stockDis: integer;
		nombre, descripcion, marca: string;
		precio: real;
	end;
	
	archivo_cel = file of celular;
	
procedure crearArchivo(var arc_log: archivo_cel; var arc_txt: Text);
var
	cel: celular;
	nom: string;
begin
	writeln('Ingrese nombre del archivo: '); readln(nom);
	assign(arc_log, nom);
	rewrite(arc_log);
	reset(arc_txt);
	while not eof(arc_txt)do begin
		readln(arc_txt, cel.cod, cel.precio, cel.marca);
		readln(arc_txt, cel.stockDis, cel.stockMin, cel.descripcion);
		readln(arc_txt, cel.nombre);
		write(arc_log, cel);
	end;
	close(arc_log);
	close(arc_txt);
end;

procedure mostrar(cel: celular);
begin
	writeln('Codigo: ', cel.cod);
	writeln('Nombre: ', cel.nombre);
	writeln('Descripcion: ', cel.descripcion);
	writeln('Marca: ', cel.marca);
	writeln('Precio: ', cel.precio);
	writeln('Stock minimo: ', cel.stockMin);
	writeln('Stock disponible: ', cel.stockDis);
end;

procedure listarStock(var arc_log: archivo_cel);
var
	cel: celular;
begin
	reset(arc_log);
	while not eof(arc_log) do begin
		read(arc_log, cel);
		if(cel.stockDis < cel.stockMin)then
			mostrar(cel);
	end;
	close(arc_log);
end;

procedure listarDes(var arc_log: archivo_cel);
var
	cadena: string;
	cel: celular;
begin
	reset(arc_log);
	writeln('Ingrese descripcion: '); readln(cadena);
	while not eof(arc_log)do begin
		read(arc_log, cel);
		if(cel.descripcion = cadena)then
			mostrar(cel);
	end;
	close(arc_log);
end;

procedure exportar(var arc_log: archivo_cel);
var
	cel: celular;
	arc_txt: Text;
begin
	assign(arc_txt,'celulares.txt');
	rewrite(arc_txt);
	reset(arc_log);
	while not eof(arc_log)do begin
		read(arc_log, cel);
		writeln(arc_txt, cel.cod,' ',cel.precio,' ',cel.marca);
		writeln(arc_txt, cel.stockDis,' ',cel.stockMin,' ',cel.descripcion);
		writeln(arc_txt, cel.nombre);
	end;
	close(arc_log);
	close(arc_txt);
end;

var
	arc_log: archivo_cel;
	arc_txt: Text;
	op:integer;
BEGIN
	assign(arc_txt, 'celulares.txt');
	repeat
		writeln('----- MENU -----');
		writeln('1. Crear archivo de celulares');
		writeln('2. Listar celulares con stock bajo');
		writeln('3. Buscar por descripcion');
		writeln('4. Exportar a archivo de texto');
		writeln('0. Salir');
		writeln('Seleccione una opcion: ');
		readln(op);
		writeln;
		case op of
			1: crearArchivo(arc_log, arc_txt);
			2: listarStock(arc_log);
			3: listarDes(arc_log);
			4: exportar(arc_log);
		end;
		writeln;
	until op = 0;
END.

