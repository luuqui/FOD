program ej7;
const
	valorAlto = 9999;
type
	maestro = record
		codigoAlumno, cursadasAprobadas, finalesAprobados: integer;
		nombre, apellido: string[20];
	end;
	
	detalleCursadas = record
		codigoAlumno, codigoMateria, anioCursada: integer;
		resultado: string[10];
	end;
	
	detalleFinales = record
		codigoAlumno, codigoMateria, fechaExamen: integer;
		nota: real;
	end;
	
	archivoCursadas = file of detalleCursadas;
	archivoFinales = file of detalleFinales;
	archivoMaestro = file of maestro;
	
procedure leerFinal(var archivo: archivoFinales; var dato: detalleFinales);
begin
	if(not EOF(archivo))then
		read(archivo, dato)
	else
		dato.codigoAlumno:= valorAlto;
end;

procedure leerCursada(var archivo: archivoCursadas; var dato: detalleCursadas);
begin
	if(not EOF(archivo))then
		read(archivo, dato)
	else
		dato.codigoAlumno:= valorAlto;
end;


procedure actualizar(var mae: archivoMaestro; var finales: archivoFinales; var cursadas: archivoCursadas);
var
	regM: maestro;
	regCursada: detalleCursadas;
	regFinales: detalleFinales;
	codActual, cantidadCursadasAprobadas, cantidadFinalesAprobados: integer;
begin
	assign(mae, 'maestro.data');
	reset(mae);
	if(not EOF(mae))then read(mae, regM);
	
	assign(finales, 'finales.data');
	reset(finales);
	leerFinal(finales, regFinales);
	
	assign(cursadas, 'cursadas.data');
	reset(cursadas);
	leerCursada(cursadas, regCursada);
	
	while((regCursada.codigoAlumno <> valorAlto) or (regFinales.codigoAlumno <> valorAlto))do begin
		if(regCursada.codigoAlumno < regFinales.codigoAlumno)then
			codActual:= regCursada.codigoAlumno
		else
			codActual := regFinales.codigoAlumno;
		
		cantidadCursadasAprobadas := 0;
		cantidadFinalesAprobados := 0;
			
		while(codActual = regCursada.codigoAlumno)do begin
			if(regCursada.resultado = 'aprobado')then 
				cantidadCursadasAprobadas := cantidadCursadasAprobadas + 1;
			leerCursada(cursadas, regCursada);
		end;
		
		while(codActual = regFinales.codigoAlumno) do begin
			if(regFinales.nota >= 4)then
				cantidadFinalesAprobados:= cantidadFinalesAprobados + 1;
			leerFinal(finales, regFinales);
		end;
		
		while(not EOF(mae) and (regM.codigoAlumno < codActual))do
			read(mae, regM);
			
		regM.cursadasAprobadas:= regM.cursadasAprobadas + cantidadCursadasAprobadas;
		regM.finalesAprobados := regM.finalesAprobados + cantidadFinalesAprobados;
		
		seek(mae, filepos(mae)-1);
		
		write(mae, regM);
		
		if(not EOF(mae))then
			read(mae, regM)
	end;
	close(mae);
	close(cursadas);
	close(finales);
end;

VAR
	mae: archivoMaestro;
	finales: archivoFinales;
	cursadas: archivoCursadas;
BEGIN
	actualizar(mae,finales,cursadas);
END.

