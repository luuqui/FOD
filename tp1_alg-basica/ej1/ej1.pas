program ej1;

type
    archivo = file of integer;
var
   arc_logico: archivo;
   nro: integer;
   arc_fisico: string[6];
BEGIN
     write( 'Ingrese el nombre del archivo:' );
     read( arc_fisico );
     assign( arc_logico, arc_fisico );
     rewrite( arc_logico );
     write ('Ingrese un nro a agregar: ');
     read(nro);
     while nro <> 30000 do begin
		write( arc_logico, nro );
		 write ('Ingrese un nro a agregar: ');
		read(nro);
     end;
     close( arc_logico );
END.

