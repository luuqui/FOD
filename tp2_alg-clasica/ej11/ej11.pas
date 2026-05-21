program ej11;
const
	valorAlto = 'ZZZZ';
type
	categoria_rango = 1..15;
	empleado = record
		departamento, division: string[20];
		numeroEmpleado, horasExtras: integer;
		categoria: categoria_rango;
	end;
	
	archivo_empleado = file of empleado;
	vector_horas = array [1..15]of real;
	
procedure cargarVector(var horas: vector_horas; var cat: Text);
var
	monto: real;
	nroCat: integer;
begin
	reset(cat);
	while(not EOF(cat))do begin
		readln(cat, nroCat, monto);
		horas[nroCat] := monto;
	end;
	close(cat);
end;

procedure leer(var mae: archivo_empleado; var dato: empleado);
begin
	if(not EOF(mae))then
		read(mae, dato)
	else
		dato.departamento := valorAlto;
end;

procedure informar(horas: vector_horas; var mae: archivo_empleado);
var
	regM: empleado;
	depActual, divActual: string[20];
	nroEmpleadoActual, totalHorasDep, totalHorasDiv, horasEmp: integer;
	montoTotalDep, montoTotalDiv, montoEmp: real;
begin
	reset(mae);
	leer(mae, regM);
	while(regM.departamento <> valorAlto)do begin
		depActual:= regM.departamento;
		writeln('Departamento: ', depActual);
		montoTotalDep:= 0;
		totalHorasDep:= 0;
		while(depActual = regM.departamento)do begin
			divActual:= regM.division;
			totalHorasDiv:= 0;
			montoTotalDiv:= 0;
			writeln('Division: ', divActual);
			writeln('        Numero de Empleado    Total de Hs    Importe a cobrar');
			while(depActual = regM.departamento)and(divActual = regM.division)do begin
				nroEmpleadoActual:= regM.numeroEmpleado;
				horasEmp:= 0;
				montoEmp:= 0;			
				while(depActual = regM.departamento)and (divActual = regM.division) and(nroEmpleadoActual = regM.numeroEmpleado)do begin
					horasEmp:= horasEmp + regM.horasExtras;
					montoEmp:= montoEmp + horas[regM.categoria] * regM.horasExtras;
					leer(mae, regM);
				end;
				writeln('        ', nroEmpleadoActual:-20, horasEmp:-15, montoEmp:2:2);
				totalHorasDiv:= totalHorasDiv + horasEmp;
				montoTotalDiv:= montoTotalDiv + montoEmp
			end;
			writeln('Total de horas division: ', totalHorasDiv);
			writeln('Monto total por division: ', montoTotalDiv);
			writeln;
			totalHorasDep:= totalHorasDep + totalHorasDiv; 
			montoTotalDep:= montoTotalDep + montoTotalDiv;
		end;
		writeln('Total horas departamento: ', totalHorasDep);
		writeln('Monto total departamento: ', montoTotalDep);
		writeln;
	end;
	close(mae);
end;

VAR
	maestro: archivo_empleado;
	horas: vector_horas;
	categorias: Text;
BEGIN
	assign(maestro, 'archivo_empleado.dat');
	assign(categorias, 'valorHoras.txt');
	cargarVector(horas, categorias);
	informar(horas, maestro);
END.
