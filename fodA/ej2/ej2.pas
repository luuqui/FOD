program ej2;
type
    archivo = file of integer;
 
procedure generarArchivo(var arc_logico: archivo);
var
	arc_fisico: string[6];
begin
	write( 'Ingrese el nombre del archivo:' );
	read( arc_fisico );
	assign( arc_logico, arc_fisico );
	rewrite( arc_logico );
 end;

procedure cargarArchivo(var arc_logico: archivo);
var
	nro: integer;
begin
     write ('Ingrese un nro a agregar: ');
     read(nro);
     while nro <> 30000 do begin
		 write( arc_logico, nro );
		 write ('Ingrese un nro a agregar: ');
		 read(nro);
     end;	
     close(arc_logico);
end;

procedure maxYpromedio(var arc_logico: archivo);

	function menorA(nro: integer): Boolean;
	begin
		menorA:= (nro < 15000);
	end;
var
	cant, nro, cantP: integer;
	promedio, suma: real;
begin
	cant:= 0;
	cantP:= 0;
	suma:= 0;
	reset(arc_logico);
	while not eof(arc_logico)do begin
		read(arc_logico, nro);
		if(menorA(nro))then
			cant:= cant + 1;
		cantP:= cantP + 1;
		suma:= suma + nro;
	end;
	writeln('Cantidad de nros menores a 15mil: ', cant);
	if cantP <> 0 then
		promedio:= suma / cantP
	else
		promedio:= 0;
	writeln('Promedio: ', promedio:0:2);
	close(arc_logico);
end;

var
   arc_logico: archivo;
BEGIN
	 generarArchivo(arc_logico);
	 cargarArchivo(arc_logico);
	 maxYpromedio(arc_logico);
END.
