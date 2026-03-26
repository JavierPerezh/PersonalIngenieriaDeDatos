# Métodos para Tipos de Datos en MySQL

## 1. Métodos para Tipos Numéricos

### 1.1 Funciones Aritméticas

| Método | Descripción |
|--------|-------------|
| ABS() | Retorna el valor absoluto de un número |
| MOD() | Retorna el resto de una división |
| DIV | Retorna el cociente entero de una división |
| POW() | Retorna un número elevado a una potencia |
| SQRT() | Retorna la raíz cuadrada |
| EXP() | Retorna e elevado a la potencia indicada |
| LN() | Retorna el logaritmo natural |
| LOG10() | Retorna el logaritmo en base 10 |

### 1.2 Funciones de Redondeo

| Método | Descripción |
|--------|-------------|
| ROUND() | Redondea un número a los decimales especificados |
| CEIL() | Redondea hacia arriba al entero más cercano |
| FLOOR() | Redondea hacia abajo al entero más cercano |
| TRUNCATE() | Trunca un número a los decimales especificados |

### 1.3 Funciones de Formato

| Método | Descripción |
|--------|-------------|
| FORMAT() | Formatea un número con separadores de miles |
| LPAD() | Rellena un número con caracteres a la izquierda |
| RPAD() | Rellena un número con caracteres a la derecha |

### 1.4 Funciones de Agregación

| Método | Descripción |
|--------|-------------|
| SUM() | Retorna la suma total de valores |
| AVG() | Retorna el promedio de valores |
| COUNT() | Retorna el número de registros |
| MAX() | Retorna el valor máximo |
| MIN() | Retorna el valor mínimo |
| STDDEV() | Retorna la desviación estándar |
| VARIANCE() | Retorna la varianza |

### 1.5 Funciones de Comparación

| Método | Descripción |
|--------|-------------|
| GREATEST() | Retorna el valor más grande de una lista |
| LEAST() | Retorna el valor más pequeño de una lista |
| BETWEEN | Verifica si un valor está dentro de un rango |
| IN | Verifica si un valor está en una lista |

---

## 2. Métodos para Tipos de Caracteres

### 2.1 Funciones de Longitud y Posición

| Método | Descripción |
|--------|-------------|
| LENGTH() | Retorna la longitud en bytes |
| CHAR_LENGTH() | Retorna la longitud en caracteres |
| BIT_LENGTH() | Retorna la longitud en bits |
| LOCATE() | Retorna la posición de una subcadena |
| POSITION() | Retorna la posición de una subcadena |
| INSTR() | Retorna la posición de una subcadena |

### 2.2 Funciones de Extracción

| Método | Descripción |
|--------|-------------|
| SUBSTRING() | Extrae una porción de una cadena |
| LEFT() | Extrae caracteres desde la izquierda |
| RIGHT() | Extrae caracteres desde la derecha |
| SUBSTRING_INDEX() | Extrae antes o después de un delimitador |

### 2.3 Funciones de Transformación

| Método | Descripción |
|--------|-------------|
| UPPER() | Convierte una cadena a mayúsculas |
| LOWER() | Convierte una cadena a minúsculas |
| REVERSE() | Invierte una cadena |
| REPLACE() | Reemplaza ocurrencias de una subcadena |
| INSERT() | Reemplaza parte de una cadena |
| TRIM() | Elimina espacios al inicio y final |
| LTRIM() | Elimina espacios a la izquierda |
| RTRIM() | Elimina espacios a la derecha |
| REPEAT() | Repite una cadena cierto número de veces |

### 2.4 Funciones de Concatenación

| Método | Descripción |
|--------|-------------|
| CONCAT() | Concatena dos o más cadenas |
| CONCAT_WS() | Concatena con un separador |
| GROUP_CONCAT() | Concatena valores de un grupo |

### 2.5 Funciones de Búsqueda y Validación

| Método | Descripción |
|--------|-------------|
| LIKE | Busca patrones con comodines |
| REGEXP | Busca usando expresiones regulares |
| SOUNDEX() | Retorna representación fonética de una cadena |

### 2.6 Funciones de Formato de Cadena

| Método | Descripción |
|--------|-------------|
| LPAD() | Rellena una cadena a la izquierda |
| RPAD() | Rellena una cadena a la derecha |
| SPACE() | Retorna una cadena de espacios |

---

## 3. Revertir un DELETE en MySQL

Para revertir un DELETE en MySQL, el único método directo es usar ROLLBACK dentro de una transacción no confirmada. Si el DELETE se ejecutó con autocommit activado o después de un COMMIT, no es posible deshacerlo mediante un comando; en ese caso se debe recurrir a la restauración desde un backup. Y se realiza de la siguiente manera:

```sql
START TRANSACTION;
DELETE FROM clientes WHERE id = 10;
SELECT * FROM clientes WHERE id = 10;
ROLLBACK;
SELECT * FROM clientes WHERE id = 10;
