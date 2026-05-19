program ej5;
const
	dimF = 5;
	valorAlto = 9999;
type
	logsDetalle = record
		codigo, tiempoSesion: integer;
		fecha: string[10];
	end;
	
	logsMaestro = record
		codigo, tiempoTotal: integer;
		fecha: string[10];
	end;
	
	archivoDetalle = file of logsDetalle;
	archivoMaestro = file of logsMaestro;
	
	vectorDetalle = array [1..dimF] of archivoDetalle;
	vectorRegistro = array [1..dimF] of logsDetalle;

procedure leer(var archivo: archivoDetalle; var dato: logsDetalle);
begin
	if(not EOF(archivo))then
		read(archivo, dato)
	else
		dato.codigo := 9999;
end;

procedure minimo(var detalles: vectorDetalle; regD: vectorRegistro; var min: logsDetalle);
var
	indice_min, i: integer;
begin
	indice_min:= 1;
	for i:= 2 to dimF do begin
		if(regD[i].codigo < regD[indice_min].codigo)then
			indice_min := i
		else if(regD[i].codigo = regD[indice_min].codigo) and (regD[i].fecha < regD[indice_min].fecha)then
			indice_min := i;
	end;
	
	min := regD[indice_min];
	leer(detalles[indice_min], regD[indice_min]);
end;

procedure crearMaestro(var maestro: archivoMaestro; var detalles: vectorDetalle);
var
	i, codActual, sumaTiempo: integer;
	aux: string;
	fechaActual: string;
	regM: logsMaestro;
	regD: vectorRegistro;
	min: logsDetalle;
begin
	assign(maestro, '/var/log/maestro.dat');
	rewrite(maestro);
	for i:= 1 to dimF do begin
		Str(i, aux);
		assign(detalles[i], 'maquina'+aux);
		reset(detalles[i]);
		leer(detalles[i], regD[i]);
	end;
	
	minimo(detalles, regD, min);
	
	while(min.codigo <> valorAlto)do begin
		codActual := min.codigo;
		fechaActual := min.fecha;
		sumaTiempo:= 0;
		while(codActual = min.codigo) and (fechaActual = min.fecha)do begin
			sumaTiempo := sumaTiempo + min.tiempoSesion;
			minimo(detalles, regD, min);
		end;
		regM.codigo:= codActual;
		regM.tiempoTotal := sumaTiempo;
		regM.fecha := fechaActual;
		
		write(maestro, regM);
	end;
	close(maestro);
	for i:= 1 to dimF do
		close(detalles[i]);
end;

VAR
	maestro: archivoMaestro;
	detalles: vectorDetalle;
BEGIN
	crearMaestro(maestro, detalles);
END.

