program ej2;
type
	producto = record
		codigo, stock: integer;
		nombre, descripcion: string;
		precio: real;
	end;
	
	archivo_producto = file of producto;

procedure crearArchivo(var mae: archivo_producto);
var
	p: producto;
begin
	rewrite(mae); { Creamos el archivo nuevo en el disco (borra si existía uno viejo) }
	
	writeln('--- CARGA DE PRODUCTOS ---');
	write('Ingrese el codigo del producto (0 para terminar): ');
	readln(p.codigo);
	
	while (p.codigo <> 0) do begin
		write('Ingrese el nombre: ');
		readln(p.nombre);
		write('Ingrese la descripcion: ');
		readln(p.descripcion);
		write('Ingrese el precio: ');
		readln(p.precio);
		write('Ingrese el stock disponible: ');
		readln(p.stock);
		
		write(mae, p); { Guardamos el registro en el archivo binario }
		
		writeln('-----------------------------------');
		write('Ingrese el codigo del siguiente producto (0 para terminar): ');
		readln(p.codigo);
	end;
	
	close(mae);
	writeln('Archivo maestro creado con exito.');
end;
	
procedure bajas(var mae: archivo_producto);
var
	p: producto;
begin
	reset(mae);
	while(not EOF(mae))do begin
		read(mae, p);
		if(p.stock = 0)then begin
			p.nombre := '*'+p.nombre;
			seek(mae, filepos(mae)-1);
			write(mae, p);
		end;
	end;
	close(mae);
end;

VAR
	mae: archivo_producto;
BEGIN
	assign(mae, 'mae.dat');
	crearArchivo(mae);
	bajas(mae);
END.

