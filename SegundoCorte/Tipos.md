# Tipos de datos en MySQL y recuperación de eliminaciones

En MySQL existen distintos tipos de datos para almacenar información de tipo carácter y numérica. La elección correcta depende del tipo de dato, tamaño y uso dentro de la aplicación.

En cuanto a los datos de tipo carácter, MySQL ofrece `CHAR` y `VARCHAR`. El tipo `CHAR` tiene una longitud fija, lo que significa que siempre ocupa el mismo espacio, incluso si no se llena completamente. Esto puede hacerlo más eficiente en ciertos casos donde los datos tienen un tamaño constante. Por otro lado, `VARCHAR` es de longitud variable, por lo que solo ocupa el espacio necesario para almacenar el contenido, siendo más eficiente en almacenamiento cuando los datos varían en tamaño.

También existen tipos diseñados para almacenar grandes cantidades de texto, como `TEXT`, `MEDIUMTEXT` y `LONGTEXT`. Estos permiten guardar desde textos relativamente pequeños hasta grandes volúmenes de información. Además, MySQL incluye tipos como `ENUM`, que permite definir una lista de valores posibles, y `SET`, que permite almacenar múltiples valores de una lista predefinida.

En relación con los datos numéricos, MySQL proporciona varios tipos de enteros como `TINYINT`, `SMALLINT`, `INT` y `BIGINT`, los cuales se diferencian principalmente por la cantidad de bytes que utilizan y el rango de valores que pueden almacenar. Estos pueden configurarse como `SIGNED` o `UNSIGNED`, dependiendo de si se necesitan valores negativos.

Para números con decimales, se utilizan tipos como `DECIMAL`, `FLOAT` y `DOUBLE`. El tipo `DECIMAL` es preciso y se recomienda para valores financieros, mientras que `FLOAT` y `DOUBLE` son de punto flotante, lo que implica que pueden tener pequeñas pérdidas de precisión, pero son más eficientes para cálculos científicos.

Respecto a la eliminación de registros, sí es posible revertir un `DELETE` en MySQL utilizando transacciones y la instrucción `ROLLBACK`, pero solo bajo ciertas condiciones. Esto funciona únicamente si la tabla utiliza un motor que soporte transacciones, y si la operación se realiza dentro de una transacción que aún no ha sido confirmada con `COMMIT`.
