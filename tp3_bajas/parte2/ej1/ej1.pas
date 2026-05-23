program ej1;
type
	producto = record
		codigo, stockActual, stockMinimo: integer;
		nombre: string;
		precio: real;
	end;
	
	venta = record
		codigo, cantVendida: integer;
	end;
	
	archivo_maestro = file of producto;
	archivo_detalle = file of venta;	
	
procedure actualizarMaestro(var mae: archivo_maestro; var det: archivo_detalle);
var
	regP: producto;
	regV: venta;
	flag: boolean;
begin
	reset(mae);
	reset(det);
	while(not EOF(det))do begin
		read(det, regV);
		flag:= false;
		seek(mae, 0); //importantisimo
		while(not EOF(mae)and(not flag))do begin
			read(mae, regP);
			if(regV.codigo = regP.codigo)then begin
				flag:= true;
				regP.stockActual := regP.stockActual - regV.cantVendida;
				seek(mae, filepos(mae)-1);
				write(mae, regP);
			end;
		end;
	end;
	close(mae);
	close(det);
end;

VAR
	mae: archivo_maestro;
	det: archivo_detalle;
BEGIN
	actualizarMaestro(mae, det)
END.

