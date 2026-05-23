program ej2;
type
	mesa = record
		codigoLoc, nroMesa, cantVotos: integer;
	end;
	
	localidad = record
		codLocalidad, totalVotos: integer;
	end;

	archivo_mesa = file of mesa;
	archivo_localidad = file of localidad;
	
procedure informar(var mes: archivo_mesa; var loc: archivo_localidad);
var
	regL: localidad;
	regM: mesa;
	totalVotos: integer;
	flag: boolean;
begin
	reset(mes);
	reset(loc);
	totalVotos:= 0;
	while(not EOF(mes))do begin
		read(mes, regM);
		flag:= false;
		seek(loc, 0);
		
		while(not EOF(loc) and (not flag))do begin
			read(loc, regL);
			if(regL.codLocalidad = regM.codigoLoc)then begin
				flag:= true;
				regL.totalVotos:= regL.totalVotos + regM.cantVotos;
				totalVotos := totalVotos + regM.cantVotos;
				seek(loc, filepos(loc)-1);
				write(loc, regL);
			end;
		end;
		
		{ CASO NUEVO: Si la localidad no existía en nuestro archivo auxiliar }
		if (not flag) then begin
			regL.codLocalidad := regM.codigoLoc;
			regL.totalVotos := regM.cantVotos;
			
			{ Nos paramos al final del archivo auxiliar y lo agregamos }
			seek(loc, fileSize(loc));
			write(loc, regL);
		end;
	end;
	
	seek(loc, 0);
	while(not EOF(loc))do begin
		read(loc, regL);
		writeln(regL.codLocalidad, '          ', regL.totalVotos);
	end;
	writeln('Total general de votos: ', totalVotos);
	close(mes);
	close(loc);
end;

VAR
	mes: archivo_mesa;
	loc: archivo_localidad;
BEGIN
	assign(mes, 'mesa.dat');
	assign(loc, 'localidad.dat');
	rewrite(mes);
	rewrite(loc);
	informar(mes, loc);
END.

