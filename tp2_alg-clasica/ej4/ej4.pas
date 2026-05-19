program ej4;
const
	valorAlto = 9999;
	dimF = 30;
type
	producto = record
		codigo, stockDisponible, stockMinimo: integer;
		nombre, descripcion: string [50];
		precio: real;
	end;
	
	detalle = record
		codigo, cantidadVendida: integer;
	end;
	
	archivoMaestro = file of producto;
	archivoDetalle = file of detalle;
	
	vectorDetalles = array [1..dimF] of archivoDetalle; 
	vectorRegistros = array [1..dimF] of detalle;
	
procedure leer(var archivo: archivoDetalle; var dato: detalle);
begin
	if(not EOF(archivo))then
		read(archivo, dato)
	else
		dato.codigo:= valorAlto;
end;

procedure minimo(var detalles: vectorDetalles; var registros: vectorRegistros; var min: detalle);
var
	i, indice_min:integer;
begin
	indice_min := 1; //asumimos que el cod mas chico de todos está en la suc 1
	for i:= 2 to dimF do begin
		if(registros[i].codigo < registros[indice_min].codigo)then
			indice_min := i;
	end;
	min := registros[indice_min];
	
	leer(detalles[indice_min], registros[indice_min]);
end;

procedure verificarStockMin(reg: producto; var arc: Text);
begin
	if(reg.stockDisponible < reg.stockMinimo)then
		writeln(arc, reg.precio:0:2, ' | Stock: ', reg.stockDisponible, ' | ', reg.nombre, ' - ', reg.descripcion);
end;
	
procedure actualizar(var maestro: archivoMaestro; var detalles: vectorDetalles; var arcTxt: Text);
var
	regM: producto;
	min: detalle;
	codigoActual,i, cantidadTotal: integer;
	v_regD: vectorRegistros;
begin
	reset(maestro);
	rewrite(arcTxt);
	read(maestro, regM);
	for i:= 1 to dimF do begin
		reset(detalles[i]);
		leer(detalles[i], v_regD[i]);
	end;
	minimo(detalles, v_regD, min);
	while(min.codigo <> valorAlto)do begin
	
		codigoActual := min.codigo;
		cantidadTotal := 0;
		
		while(codigoActual = min.codigo)do begin
			cantidadTotal := cantidadTotal + min.cantidadVendida;
			minimo(detalles, v_regD, min);
		end;
		
		while(regM.codigo <> codigoActual)do begin
			verificarStockMin(regM,arcTxt);
			read(maestro, regM);
		end;
		
		regM.stockDisponible:= regM.stockDisponible - cantidadTotal;
		verificarStockMin(regM,arcTxt);
		
		seek(maestro, filepos(maestro)-1);
		write(maestro, regM);
		
		if(not EOF(maestro))then
			read(maestro, regM);
	end;
	
	while(not EOF(maestro))do begin
		verificarStockMin(regM,arcTxt);
		read(maestro, regM);
	end;
	verificarStockMin(regM,arcTxt);
	
	close(maestro);
	for i:= 1 to dimF do
		close(detalles[i]);
	close(arcTxt);
end;

VAR
	maestro: archivoMaestro;
	detalles: vectorDetalles;
	archivoTxt: Text;
	i: integer;
	aux: string;
BEGIN
	assign(maestro, 'maestro.dat');
	assign(archivoTxt, 'stockMin.txt');
	for i:= 1 to dimF do begin
		Str(i, aux);
		assign(detalles[i],'suc'+aux);
	end;
	actualizar(maestro, detalles, archivoTxt);
END.

