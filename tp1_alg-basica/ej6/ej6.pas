program ej6;
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

procedure agregarCel(var arc_log: archivo_cel);
	procedure preguntas(var cel: celular);
	begin
		writeln('Ingrese codigo: ');
		readln(cel.cod);
		
		writeln('Ingrese precio: ');
		readln(cel.precio);
		
		writeln('Ingrese marca: ');
		readln(cel.marca);
		
		writeln('Ingrese stock disponible: ');
		readln(cel.stockDis);
		
		writeln('Ingrese stock minimo: ');
		readln(cel.stockMin);
		
		writeln('Ingrese descripcion: ');
		readln(cel.descripcion);
		
		writeln('Ingrese nombre: ');
		readln(cel.nombre);
		
	end;
var
	cel: celular;
	op: integer;
begin
	reset(arc_log);
	seek(arc_log, filesize(arc_log));
	repeat
		writeln('Si desea cargar un celular seleccione 1, caso contrario 0: '); readln(op);
		if op=1 then begin
					preguntas(cel);
					write(arc_log, cel);
		end;
	until op = 0;
	close(arc_log);
end;

procedure modificarStock(var arc_log: archivo_cel);
var
	cel: celular;
	stk: integer;
	nom: string;
	modificado: boolean;
begin
	reset(arc_log);
	modificado:=false;
	writeln('Ingrese el nombre del celular a modificar: '); readln(nom);
	while not eof(arc_log) and  not modificado do begin
		read(arc_log, cel);
		if(cel.nombre = nom)then begin
			writeln('Ingrese stock que desea modificar: '); readln(stk);
			cel.stockDis := stk;
			writeln('Stock modificado!');
			modificado := true;
			seek(arc_log, filepos(arc_log) - 1);
		end;
	end;
	if not modificado then
		writeln('No se encontró el celular');
	close(arc_log);
end;

procedure exp(var arc_log: archivo_cel);
var
	arc_txt: Text;
	cel: celular;
begin
	reset(arc_log);
	assign(arc_txt, 'SinStock.txt');
	rewrite(arc_txt);
	while not eof(arc_log)do begin
		read(arc_log, cel);
		if(cel.stockDis = 0)then begin
			writeln(arc_txt, cel.cod, cel.precio, cel.marca);
			writeln(arc_txt, cel.stockDis, cel.stockMin, cel.descripcion);
			writeln(arc_txt, cel.nombre);
		end;
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
		writeln('5. Agregar celulares');
		writeln('6: Modificar stock de un celular');
		writeln('7: Exportar cels con stock 0 a txt');
		writeln('0. Salir');
		writeln('Seleccione una opcion: ');
		readln(op);
		writeln;
		case op of
			1: crearArchivo(arc_log, arc_txt);
			2: listarStock(arc_log);
			3: listarDes(arc_log);
			4: exportar(arc_log);
			5: agregarCel(arc_log);
			6: modificarStock(arc_log);
			7: exp(arc_log);
		end;
		writeln;
	until op = 0;
END.

