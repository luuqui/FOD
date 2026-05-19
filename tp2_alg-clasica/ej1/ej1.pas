program ej1;
const
	valorAlto = 9999;
type
	empleado = record
		cod: integer;
		nombre: string;
		montoCom: real;
	end;
	
	empleado_compacto = record
		codigo: integer;
		nombre: string[50];
		montoTotal: real;
	end;
	
	arc_comisiones = file of empleado;
	arc_compacto = file of empleado_compacto;
	
procedure leer(var archivo: arc_comisiones; var dato: empleado);
begin
	if(not EOF(archivo))then
		read(archivo, dato)
	else
		dato.cod:= valorAlto;
end;
	
procedure compactarComisiones(var arc_ori: arc_comisiones; var arc_nue: arc_compacto);
var
	reg_orig: empleado;
	reg_nue: empleado_compacto;
	cod_actual: integer;
	total_comision: real;
begin
	reset(arc_ori);
	rewrite(arc_nue);
	leer(arc_ori, reg_orig);
	while(reg_orig.cod <> valorAlto)do begin
		cod_actual := reg_orig.cod;
		reg_nue.nombre := reg_orig.nombre;
		total_comision := 0;
		while(reg_orig.cod = cod_actual)do begin
			total_comision:= total_comision + reg_orig.montoCom;
			leer(arc_ori, reg_orig);
		end;
		reg_nue.codigo:= cod_actual;
		reg_nue.montoTotal:= total_comision;
		write(arc_nue, reg_nue); 
	end;
	close(arc_ori);
	close(arc_nue);
end;

VAR
	archivo_origen: arc_comisiones;
	archivo_resultado: arc_compacto;
BEGIN
	assign(archivo_origen, 'comisiones_sucias.dat');
	assign(archivo_resultado, 'comisiones_compactadas.dat');
	compactarComisiones(archivo_origen, archivo_resultado);
END.

