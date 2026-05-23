program ej7;
type
	novela = record
		cod: integer;
		genero, nombre: string;
		precio: real;
	end;
	
	arc_nov = file of novela;

procedure cargar(var arc_log: arc_nov; var arc_txt: Text);
var
	n: novela;
begin
	reset(arc_txt);
	rewrite(arc_log);
	while not eof(arc_txt) do begin
		readln(arc_txt, n.cod, n.precio, n.genero);
		readln(arc_txt, n.nombre);
		write(arc_log, n);
	end;
	close(arc_log);
	close(arc_txt);
end;


procedure preguntas(var n:novela);
begin
    writeln('Ingrese el codigo de la novela: ');
    readln(n.cod);

    writeln('Ingrese el nombre de la novela: ');
    readln(n.nombre);

    writeln('Ingrese el genero de la novela: ');
    readln(n.genero);

    writeln('Ingrese el precio de la novela: ');
    readln(n.precio);
end;

procedure insertar(var arc_log: arc_nov);
var
	n: novela;
begin
	preguntas(n);
	reset(arc_log);
	seek(arc_log, filesize(arc_log));
	write(arc_log, n);
	close(arc_log);
end;

procedure modificar(var arc_log: arc_nov);
var
	cod, op: integer;
	nov: novela;
	encontre: boolean;
begin
	encontre:= false;
	writeln('Ingrese el codigo de la novela a modificar: '); readln(cod);
	reset(arc_log);
	while not eof(arc_log) and  (not encontre) do begin
		read(arc_log, nov);
		if nov.cod = cod then begin
			encontre:= true;
			writeln('Novela encontrada: ');
            writeln('Nombre: ', nov.nombre);
            writeln('Genero: ', nov.genero);
            writeln('Precio: ', nov.precio);

            writeln('Que desea modificar?');
            writeln('1. Nombre');
            writeln('2. Genero');
            writeln('3. Precio');
            readln(op);
            
            case op of
				1: begin
					writeln('Ingrese el nuevo nombre: '); 
					readln(nov.nombre);
				   end;
				2: begin
					writeln('Ingrese el nuevo genero: ');
					readln(nov.genero);
				   end;
				3: begin
					writeln('Ingrese el nuevo precio: ');
					readln(nov.precio);
				   end;
			end;
			seek(arc_log, filepos(arc_log) - 1);
			write(arc_log, nov);
			writeln('Archivo modificado correctamente');
		end;
	end;
	if not encontre then
		writeln('Novela no existente');
	close(arc_log);
end;

VAR
	arc_txt: Text;
	arc_log: arc_nov;
	nom: string;
	op:integer;
BEGIN
	assign(arc_txt, 'novelas.txt');
	writeln('Ingrese el nombre del archivo a crear: '); readln(nom);
	assign(arc_log, nom);
	cargar(arc_log,arc_txt);
	repeat
		writeln('Si desea modificar un archivo seleccione 1');
		writeln('Si desea insertar un archivo seleccione 2');
		writeln('Si desea cerrar seleccione 0');
		readln(op);
		case op of
			1: modificar(arc_log);
			2: insertar(arc_log);
			0: ;
		end;
	until op = 0;
END.

