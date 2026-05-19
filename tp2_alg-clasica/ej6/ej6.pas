program ej6;
const
	dimF = 10;
	valorAlto = 9999;
type
	maestro = record
		codigoLocalidad, codigoCepa, 
		cantidadActivos, cantidadNuevos, 
		cantidadRecuperados, cantidadFallecidos: integer;
		nombreLocalidad, nombreCepa: string [20];
	end;
	
	detalle = record
		codigoLocalidad, codigoCepa, cantidadActivos,
		cantidadNuevos, cantidadRecuperados, cantidadFallecidos: integer;
	end;
	
	archivoMaestro = file of maestro;
	archivoDetalle = file of detalle;
	
	vectorDetalles = array [1..dimF] of archivoDetalle;
	vectorRegistros = array [1..dimF] of detalle;

procedure leer(var archivo: archivoDetalle; var dato: detalle);
begin
	if(not EOF(archivo))then
		read(archivo, dato)
	else
		dato.codigoLocalidad:= valorAlto;
end;

procedure minimo(var detalles: vectorDetalles; var regD: vectorRegistros; var min: detalle);
var
	indice_min, i: integer;
begin
	indice_min:= 1;
	for i:= 2 to dimF do begin
		if(regD[i].codigoLocalidad < regD[indice_min].codigoLocalidad)then
			indice_min := i
		else if(regD[i].codigoLocalidad = regD[indice_min].codigoLocalidad)and
			(regD[i].codigoCepa < regD[indice_min].codigoCepa)then
				indice_min:= i;
	end;
	min:= regD[indice_min];
	leer(detalles[indice_min], regD[indice_min]);
end;

procedure informarMasCincuenta(var mae: archivoMaestro);
var
	totalLocalidades, localidadActual, sumaActivos: integer;
	regM: maestro;
begin
	reset(mae);
	totalLocalidades:= 0;
	if(not EOF(mae))then read(mae, regM);
	
	while(not EOF(mae))do begin
		localidadActual:= regM.codigoLocalidad;
		sumaActivos:= 0;
		while(not EOF(mae))and(localidadActual = regM.codigoLocalidad)do begin
			sumaActivos:= sumaActivos + regM.cantidadActivos;
			read(mae, regM);
		end;
		
		if(sumaActivos > 50)then totalLocalidades:= totalLocalidades + 1;
		
	end;
	
	writeln(totalLocalidades);
	close(mae);
end;
	
procedure actualizar(var mae: archivoMaestro; var detalles: vectorDetalles);
var
	min: detalle;
	regM:  maestro;
	regD: vectorRegistros;
	aux: string;
	codLocalidadActual, codCepaActual, sumaFallecidos, 
	sumaRecuperados, sumaActivos, sumaNuevos, i: integer;
begin
	assign(mae, 'maestro.dat');
	reset(mae);
	read(mae, regM);
	for i:= 1 to dimF do begin
		Str(i, aux);
		assign(detalles[i], 'detalle'+aux+'.dat');
		reset(detalles[i]);
		leer(detalles[i], regD[i]);
	end;
	minimo(detalles, regD, min);
	while(min.codigoLocalidad <> valorAlto)do begin
		codLocalidadActual := min.codigoLocalidad;
		codCepaActual := min.codigoCepa;
		sumaFallecidos:= 0;
		sumaRecuperados:= 0;
		sumaActivos:= 0;
		sumaNuevos:= 0;
		
		while(codLocalidadActual = min.codigoLocalidad)and(codCepaActual = min.codigoCepa)do begin
			sumaFallecidos:= sumaFallecidos + min.cantidadFallecidos;
			sumaRecuperados:= sumaRecuperados + min.cantidadRecuperados;
			sumaActivos:= sumaActivos + min.cantidadActivos;
			sumaNuevos:= sumaNuevos + min.cantidadNuevos;
			minimo(detalles, regD, min);
		end;
		
		while((regM.codigoLocalidad < codLocalidadActual)or(regM.codigoLocalidad = codLocalidadActual)) and 
			(regM.codigoCepa < codCepaActual) do
			read(mae, regM);
			
		regM.cantidadFallecidos:= regM.cantidadFallecidos + sumaFallecidos;
		regM.cantidadRecuperados:= regM.cantidadRecuperados + sumaRecuperados;
		regM.cantidadActivos:= sumaActivos;
		regM.cantidadNuevos := sumaNuevos;
		
		seek(mae, filepos(mae)-1);
		write(mae, regM);
		
		if(not EOF(mae))then
			read(mae, regM);
	end;
	close(mae);
	for i:= 1 to dimF do
		close(detalles[i]);
end;
	
VAR
	mae: archivoMaestro;
	detalles: vectorDetalles;
BEGIN
	actualizar(mae, detalles);
	informarMasCincuenta(mae);
END.

