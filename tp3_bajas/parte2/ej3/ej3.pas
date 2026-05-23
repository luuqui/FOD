program ej3;
type
	log = record
		codUsuario, tiempoSesion: integer;
		fecha: string;
	end;
	
	logMaestro = record
		codUsuario, tiempoTotal: integer;
		fecha: string;
	end;
	
	archivoMaestro = file of logMaestro;
	archivoDetalle = file of log;
	
	vec = array [1..5]of archivoDetalle;
	vecR = array [1..5]of log;
	
procedure informar(var mae: archivoMaestro; var vect: vec);
var
	i: integer;
	regD: log;
	regM: logMaestro;
	flag: boolean;
begin
	reset(mae);
	for i:= 1 to 5 do begin
		reset(vect[i]);
		while(not EOF(vect[i])) do begin
			read(vect[i], regD);
			flag:= false;
			seek(mae, 0);
			while(not EOF(mae)and(not flag))do begin
				read(mae, regM);
				if(regM.codUsuario = regD.codUsuario)then begin
					flag:= true;
					regM.tiempoTotal := regM.tiempoTotal + regD.tiempoSesion;
					seek(mae, filepos(mae)-1);
					write(mae, regM);
				end;
			end;
			if(not flag)then begin
				regM.codUsuario := regD.codUsuario;
				regM.tiempoTotal := regD.tiempoSesion;
				regM.fecha := regD.fecha;
				seek(mae, fileSize(mae));
				write(mae, regM);
			end;
		end;
		close(vect[i]);
	end;
	close(mae);
end;

VAR
	mae: archivoMaestro;
	vect: vec;
	aux: string;
	i: integer;
BEGIN
	assign(mae, 'mae.dat');
	rewrite(mae);
	for i:= 1 to 5 do begin
		Str(i, aux);
		assign(vect[i], 'det'+aux);
	end;
	informar(mae, vect);
END.

