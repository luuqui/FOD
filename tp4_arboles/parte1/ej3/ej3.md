### a. ¿Cómo se organizan los elementos (claves) de un árbol B+? ¿Qué hay en los internos y qué en las hojas?

El árbol B+ divide el mapa del archivo en dos zonas estrictas:

- **En los nodos internos (y la raíz):** Se encuentra el **Conjunto Índice**. Estos nodos solo contienen **copias de las claves** que sirven como "carteles de señalización" o fronteras de búsqueda. No contienen datos de alumnos ni NRR reales. Su única función es guiar al algoritmo sobre qué camino tomar.

- **En los nodos hojas:** Se encuentra el **Conjunto Secuencia**. Las hojas contienen **absolutamente todas las claves** del archivo, acompañadas por el dato real (o el NRR hacia el archivo maestro). Ningún alumno se queda afuera de las hojas.

### b. ¿Qué característica distintiva presentan los nodos hojas de un árbol B+? ¿Por qué?

La característica distintiva fundamental es que **todas las hojas están conectadas consecutivamente entre sí mediante un enlace físico (puntero/NRR al hermano derecho)**, formando una **Lista Enlazada**.

**¿Por qué están diseñadas así?** Para permitir un **recorrido secuencial rápido**. Gracias a este enlace, si querés leer todo el archivo ordenado de menor a mayor, no tenés que andar subiendo y bajando por el árbol; simplemente vas a la primera hoja (el extremo izquierdo) y caminás de corrido hacia la derecha a través de los bloques del disco secundario, leyendo los registros de manera lineal y continua.

C)

    
    type
     alumno = record
     nombre_apellido: string[50];
     dni: longint;
     legajo: integer;
     anio_ingreso: integer;
     end;
    
    { Usamos un registro con variante para diferenciar Hoja de Nodo Interno }
    TNodo = record
        cant_claves: integer;
        case es_hoja: boolean of
            true: (
                { El conjunto secuencia: claves y sus datos asociados }
                claves_hoja: array[1..M-1] of longint;
                datos: array[1..M-1] of alumno; { O un NRR si fuera índice separado }
                sig_hoja: integer { El NRR al hermano derecho (característica distintiva) }
            );
            false: (
                { El conjunto índice: solo carteles y punteros a hijos }
                claves_interno: array[1..M-1] of longint;
                hijos: array[1..M] of integer { NRR a otros nodos }
            );
    end;
    
    arbolBPlus = file of TNodo;

### d. Búsqueda de un DNI específico en B+ vs Árbol B común

- **El proceso en B+:** El algoritmo lee la raíz y compara el DNI. Avanza de nivel en nivel guiándose por las claves del nodo interno. **Nunca se detiene a mitad de camino.** Aunque el DNI buscado coincida exactamente con un número de un nodo interno, el algoritmo ignora el acierto inmediato y sigue bajando obligatoriamente hasta alcanzar el **nodo hoja** en el último nivel. Allí es donde realmente lee el dato.

- **La diferencia con el Árbol B:** En el Árbol B común, la búsqueda puede terminar "antes" (un éxito temprano) si la clave justo se encuentra en la raíz o en un nodo interno. En el Árbol B+, la búsqueda de un dato puntual **siempre, sin excepción, viaja hasta el fondo del árbol (gasta tantas lecturas de disco como niveles de altura tenga la estructura)**.

### e. Búsqueda por rango (DNI entre 40.000.000 y 45.000.000) en B+ y su ventaja

- **El proceso en B+:** 1. El sistema hace una única búsqueda tradicional bajando desde la raíz para localizar dónde se encuentra el piso del rango (`40000000`) en las hojas.
  
  2. Una vez posicionado en esa hoja, el sistema empieza a leer los alumnos ordenados hacia la derecha usando el puntero `sig_hoja`.
  3. Pasa de un bloque hoja al siguiente en el disco de manera horizontal hasta toparse con un DNI mayor a `45000000`. Ahí frena.

- **La ventaja descomunal sobre el Árbol B:** En el Árbol B común, para avanzar al siguiente DNI había que volver a subir de forma recursiva a los nodos padres y volver a bajar (un efecto "yoyo" ineficiente en disco). En el Árbol B+, **no se vuelve a subir nunca al conjunto índice**. El recorrido por el rango se hace de forma lineal, minimizando los accesos a disco (I/O) de manera drástica.

### f. Pros y contras de tener los datos en las hojas para acceder secuencialmente

- **PROS (Ventajas):**
  
  - **Recorrido lineal óptimo:** El acceso por rangos o el procesamiento de todo el archivo ordenado es ultra veloz porque se comporta como una simple lista enlazada de bloques físicos.
  
  - **Búsquedas uniformes:** Al estar todo abajo, cualquier búsqueda de un dato puntual tarda exactamente lo mismo (mismo número de lecturas de disco), garantizando tiempos de respuesta predecibles para el sistema de bases de datos.

- **CONTRAS (Desventajas):**
  
  - **Claves duplicadas (Desperdicio de espacio):** El árbol se ve obligado a tener claves repetidas: la clave real obligatoriamente está en la hoja, y además puede existir una copia exacta arriba en el conjunto índice sirviendo de cartel.
  
  - **Sin éxitos tempranos:** No existe la posibilidad de encontrar un dato en la raíz en la primera lectura de disco, obligando a que toda consulta individual, por más simple que sea, tenga que pagar el costo de descender hasta el último nivel.


