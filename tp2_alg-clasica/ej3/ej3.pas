program ej3;
const
	valorAlto = 'ZZZ';
type
	datos = record
		nombreProvincia: string [20];
		cantidadAlfabetizados, totalEncuestados: integer;
	end;
	
	agencia = record
		nombreProvincia: string[20];
		codigoLocalidad, cantidadAlfabetizados, totalEncuestados: integer;
	end;
	
	archivoMaestro = file of datos;
	archivoDetalle = file of agencia;
	
procedure leer(var archivo: archivoDetalle; var dato: agencia);
begin
	if(not EOF(archivo))then
		read(archivo, dato)
	else
		dato.nombreProvincia := valorAlto;
end;

procedure minimo(var det1, det2: archivoDetalle; var regD1, regD2, min: agencia);
begin
	if(regD1.nombreProvincia <= regD2.nombreProvincia)then begin
		min:= regD1;
		leer(det1, regD1);
	end
	else begin
		min:= regD2;
		leer(det2, regD2);
	end;
end;

procedure desarrollar(var maestro: archivoMaestro; var det1, det2: archivoDetalle);
var
	provinciaActual: string[20];
	alfabetizadosTotal, encuestadosTotal: integer;
	regM: datos;
	regD1, regD2, min: agencia;
begin
	reset(maestro);
	reset(det1);
	reset(det2);
	read(maestro, regM);
	leer(det1, regD1);
	leer(det2, regD2);
	minimo(det1, det2, regD1, regD2, min);
	while(min.nombreProvincia <> valorAlto)do begin
	
		provinciaActual:= min.nombreProvincia;
		alfabetizadosTotal:= 0;
		encuestadosTotal:= 0;
		
		while(min.nombreProvincia = provinciaActual)do begin
			alfabetizadosTotal:= alfabetizadosTotal + min.cantidadAlfabetizados;
			encuestadosTotal:= encuestadosTotal + min.totalEncuestados;
			minimo(det1, det2, regD1, regD2, min);
		end;
		
		while(regM.nombreProvincia <> provinciaActual)do
			read(maestro, regM);
		
		regM.cantidadAlfabetizados := regM.cantidadAlfabetizados + alfabetizadosTotal;
		regM.totalEncuestados := regM.totalEncuestados + encuestadosTotal;
		
		seek(maestro, filepos(maestro)-1);
		write(maestro, regM);
		
		if(not EOF(maestro))then
			read(maestro, regM);
	end;
	close(maestro);
	close(det1);
	close(det2);
end;
	
VAR
	maestro: archivoMaestro;
	det1, det2: archivoDetalle;
BEGIN
	assign(maestro, 'archivoMaestro.dat');
	assign(det1, 'detalle.dat');
	assign(det2, 'detalle2.dat');
	desarrollar(maestro, det1, det2);
END.

