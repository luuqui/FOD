program ;
type
	libro = record
		codigo, cantidadPaginas: integer;
		genero, autor: string;
		precio: real;
	end;
	
	archivo_libro = file of libro;

procedure crearArchivo(var mae: archivo_libro);
begin
	assign(mae, 'libros.dat');
	rewrite(mae);
	
end;

VAR
	mae: archivo_libro;
BEGIN
	case 
	crearArchivo(mae);
	
END.

