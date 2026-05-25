program ej1;
const
	M = 8;
type
	alumno = record
		nombre_apellido: string;
		dni, legajo, anioIngreso : integer;
	end;
	
	TNodo = record
		cant_datos: integer;
		datos: array [1..M-1] of alumno;
		hijos: array [1..M] of integer;
	end;
	
	arbolB = file of TNodo;
	
VAR
	archivo_alumno: arbolB;
BEGIN
END.

{
b)
n = 512bytes
a = 64 bytes
b = 4 bytes
c = 4 bytes

512 = (M-1) * 64 + M * 4 + 4 = 64M - 64 + 4M + 4 = 68M - 60
512 = 68M - 60
512 + 60 = 68M
572 = 68M
572 / 68 = M
M = 8,41 = 8

c)Qué impacto tiene sobre el valor de M organizar el archivo con toda la información en el árbol B?
Explicación: El impacto es que $M$ se vuelve muy chico. Como el registro del alumno incluye campos pesados (como el nombre y apellido que ocupan muchos bytes), 
cada elemento del array datos consume mucho espacio.  Consecuencia en el archivo: Al entrar pocas claves por nodo (solo 7), 
el árbol se ve obligado a dividirse más seguido (hacer overflows) y crecer hacia arriba (mayor altura). Esto perjudica el rendimiento, 
ya que para buscar un alumno tendremos que leer más nodos del disco.

d)¿Qué dato seleccionaría como clave de identificación? ¿Hay más de una opción?Selección: El campo ideal es el DNI o el Legajo.  
Justificación: Las claves en un Árbol B deben ser únicas por cada registro (no puede haber dos alumnos con el mismo DNI o legajo). 
Sí, hay más de una opción (DNI y Legajo sirven por igual). Elegiremos el DNI para el resto del análisis

e) Proceso de búsqueda de un alumno por DNI (Mejor y peor caso)El proceso: El algoritmo empieza leyendo el nodo raíz en memoria RAM. 
Compara el DNI buscado con el array de alumnos ordenados. Si lo encuentra, termina. Si no está y el DNI buscado es menor al de un registro, viaja al NRR indicado por el 
hijo izquierdo de esa posición; si es mayor, va al hijo derecho. Esto se repite recursivamente bajando por los niveles del árbol.  
Mejor caso (1 lectura de nodo) : Ocurre cuando el alumno buscado está justo en el nodo raíz. Abrimos el archivo, leemos el primer bloque y el dato ya está ahí.  
Peor caso : Ocurre cuando el alumno está en un nodo hoja en el último nivel del árbol o directamente no existe en el archivo. 
El sistema tendrá que leer un nodo por cada nivel del árbol hasta llegar al fondo. Si el árbol tiene altura $H$, requerirá $H$ lecturas de disco.  

f) ¿Qué ocurre si desea buscar un alumno por un criterio diferente (ej. por Nombre)?Explicación: El Árbol B está físicamente construido y ordenado en disco bajo la lógica 
de la clave elegida (el DNI). Si querés buscar por "Nombre", el orden estructural del árbol deja de servir por completo.  
Peor caso (Lecturas necesarias): Al no poder usar los enlaces de los hijos para descartar caminos, te ves obligado a realizar una búsqueda 
secuencial exhaustiva (un escaneo completo). Tendrás que leer absolutamente todos los nodos del archivo en disco, uno por uno, para verificar si el alumno está adentro. 
Es lo menos eficiente posible en organización de datos.
}
