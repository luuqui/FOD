program ej18;
const
	valorAlto = 9999;
type
	covid = record
		codigoLocalidad, codigoMunicipio, codigoHospital, casosPositivos: integer;
		nombreLocalidad, nombreMunicipio, nombreHospital, fecha: string;
	end;
	
	archivo_maestro = file of covid;
	
procedure leer(var mae: archivo_maestro; var dato: covid);
begin
	if(not EOF(mae))then
		read(mae, dato)
	else
		dato.codigoLocalidad:= valorAlto;
end;

procedure casosMunicipio(cant: integer; var arc: Text; localidad, municipio: string);
begin
	if(cant > 1500)then begin
		writeln(arc, localidad);
		writeln(arc, municipio);
		writeln(arc, cant);
	end;
end;

procedure informar(var mae: archivo_maestro);
var
	regM: covid;
	codLocalidadActual, codMunicipioActual, codHospitalActual,
	cantCasosMunicipio, cantCasosLocalidad, cantCasosHospital, cantTotalProv: integer;
	nomLoc, nomMuni, nomHospitalActual:string;
	arcTxt: Text;
begin
	assign(arcTxt, 'arc.txt');
	rewrite(arcTxt);
	reset(mae);
	leer(mae, regM);
	cantTotalProv:= 0;
	while(regM.codigoLocalidad <> valorAlto)do begin
		codLocalidadActual := regM.codigoLocalidad;
		nomLoc := regM.nombreLocalidad;
		cantCasosLocalidad:= 0;
		writeln('LOCALIDAD: ', nomLoc);
		while(codLocalidadActual = regM.codigoLocalidad)do begin
			codMunicipioActual:= regM.codigoMunicipio;
			nomMuni := regM.nombreMunicipio;
			cantCasosMunicipio := 0;
			while(codLocalidadActual = regM.codigoLocalidad)and(codMunicipioActual = regM.codigoMunicipio)do begin
				codHospitalActual := regM.codigoHospital;
				nomHospitalActual := regM.nombreHospital;
				cantCasosHospital:= 0;
				while(codLocalidadActual = regM.codigoLocalidad)and(codMunicipioActual = regM.codigoMunicipio)and(codHospitalActual = regM.codigoHospital)do begin
					cantCasosHospital:= cantCasosHospital + regM.casosPositivos;
					leer(mae, regM);
				end;
				writeln('    Hospital: ', nomHospitalActual, ' ........ Cantidad de casos: ', cantCasosHospital);
				cantCasosMunicipio:= cantCasosMunicipio + cantCasosHospital;
			end;
			writeln('  Total Municipio ', nomMuni, ': ', cantCasosMunicipio);
			casosMunicipio(cantCasosMunicipio,arcTxt, nomLoc, nomMuni);
			cantCasosLocalidad:= cantCasosLocalidad + cantCasosMunicipio;
		end;
		writeln('Total Localidad ', nomLoc, ': ', cantCasosLocalidad);
		writeln('--------------------------------------------------');
		cantTotalProv:= cantTotalProv + cantCasosLocalidad;
	end;
	writeln('Cantidad de casos totales en la Provincia: ', cantTotalProv);
	close(mae);
	close(arcTxt);
end;
	
VAR
	mae: archivo_maestro;
BEGIN
	assign(mae, 'covid.dat');
	informar(mae);
END.

