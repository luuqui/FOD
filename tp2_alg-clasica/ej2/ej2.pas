program ej2;
const
	valorAlto = 9999;
type
	producto = record
		codigo, stockActual, stockMinimo: integer;
		nombreComercial: string[50];
		precio: real;
	end;
	
	venta = record
		codigo, unidadesVendidas: integer;
	end;
	
	archivo_producto = file of producto;
	archivo_venta = file of venta;
	
procedure leer(var detalle: archivo_venta; var dato: venta);
begin
	if(not EOF(detalle))then
		read(detalle, dato)
	else
		dato.codigo := valorAlto;
end;

procedure verificarMin(regM: producto; var stockTxt: Text);
begin
	if(regM.stockActual < regM.stockMinimo)then
		writeln(stockTxt, regM.codigo,' ', regM.precio:0:2,' ',regM.stockActual,' ',regM.nombreComercial);
end;
	
procedure actualizar(var maestro: archivo_producto; var detalle: archivo_venta; var stockTxt: Text);
var
	regM: producto;
	regD: venta;
	codActual, totVendidos: integer;
begin
	reset(detalle);
	reset(maestro);
	rewrite(stockTxt);
	read(maestro, regM);
	leer(detalle, regD);
	while(regD.codigo <> valorAlto)do begin
		codActual := regD.codigo;
		totVendidos:= 0;
		while(regD.codigo = codActual)do begin
			totVendidos:= totVendidos + regD.unidadesVendidas;
			leer(detalle, regD);
		end;
		while(regM.codigo <> codActual)do begin 
			verificarMin(regM, stockTxt); //verifico los productos anteriores al codigo buscado
			read(maestro, regM);
		end;
		regM.stockActual := regM.stockActual - totVendidos;
		verificarMin(regM, stockTxt); //verifico los productos con el codigo, ya que en el anterior while no entra
		seek(maestro, filepos(maestro)-1);
		write(maestro, regM);
		if(not EOF(maestro))then
			read(maestro, regM);
	end;
	
	while(not EOF(maestro))do begin //aca verificamos los min's restantes (productos sin ventas)
		verificarMin(regM, stockTxt);
		read(maestro, regM);
	end;
	verificarMin(regM, stockTxt); //verificamos el ultimo
	
	close(maestro);
	close(detalle);
	close(stockTxt);
end;
	
VAR
	maestro: archivo_producto;
	detalle: archivo_venta;
	stock_txt: Text;
BEGIN
	assign(maestro, 'productos.dat');
	assign(detalle, 'ventas.dat');
	assign(stock_txt, 'stock_minimo.txt');
	actualizar(maestro, detalle, stock_txt);
END.

