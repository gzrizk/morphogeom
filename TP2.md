## TP2

Trabajo Práctico Semana 2. Variables de forma y tamaño.

El trabajo práctico de la semana 2 corresponde al desarrollo de los siguientes contenidos del Tema 2. Variables de forma y tamaño:
•	Obtención de las variables de forma: Superposición Procrustes Generalizada de landmarks y alineamiento de semilandmarks. 
•	Imputación de datos faltantes.

Objetivo de aprendizaje
•	Obtener variables de tamaño a partir de coordenadas 3D de landmarks y semilandmarks.
•	Obtener variables de forma a partir de las mismas coordenadas de landmarks y semilandmarks.
•	Explorar opciones de imputación de datos perdidos para bases de datos en los que algún/os especímenes tengan falta de información sobre la posición de algún/os landmarks y/o semilandmarks.

Actividades
1)	A partir del conjunto de landmarks y semilandmarks digitalizado en la Semana 1, realizar una Superposición de Procrustes Generalizada que incluya el deslizamiento de semilandmarks. Realizar este procedimiento utilizando ambos métodos de deslizamiento de semilandmarks: bending energy y mínimos cuadrados. Extraer y exportar el tamaño centroide, las coordenadas de forma o superpuestas y la forma consenso. 
2)	Plotear las coordenadas de forma y la forma consenso. 
3)	Sobre la base de datos digitalizada en la Semana 1 construir tres bases alternativas que simulen datos faltantes:
a)	En uno de los especímenes, quitar la información relativa a 5 landmarks (tipo 1 y 2).
b)	En dos de los especímenes, quitar la información relativa a 5 landmarks (tipo 1 y 2).
c)	En uno de los especímenes, quitar la información relativa a una curva o superficie digitalizada completa.
4)	Imputar los datos perdidos en las tres alternativas construidas en el punto 3 usando ambos métodos: regresión y TPS.
5)	Repetir los puntos 1 y 2 con las tres bases alternativas con datos imputados y comparar el ploteo de la forma promedio y las coordenadas de forma.

Principales funciones a utilizar
##Realizar la Superposición Procrustes Generalizada:
procSym (dataarray, ….)

## En caso de querer realizar el deslizamiento de semilandmarks por fuera de la función procSym y luego con esta función superponer una base de datos con los puntos ya digitalizados. Especialmente útil si pusieron puntos de superficie:
slider3D (dataarray,…)

## Imputar datos faltantes:
estimate.missing (A, method = c("TPS", "Reg"))
fixLMtps(data, …)

## Para plotear los puntos:
plot(data)
