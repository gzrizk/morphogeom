## TP 1

El trabajo práctico de la semana 1 corresponde al desarrollo de los siguientes contenidos del Tema 1. Obtención de datos:
•	Adquisición de datos morfométricos en 3 dimensiones: técnicas manuales, automáticas y semi-automáticas.
•	Discusión de criterios para la elección de variables morfométricas.

Objetivos de aprendizaje
•	Aprender a manipular archivos de landmarks y de superficies 3D (.ply) usando RStudio
•	Definir landmarks sobre estructuras anatómicas 
•	Digitalizar landmarks sobre superficies 3D utilizando 3DSlicer.

Actividades
A partir del conjunto de imágenes 3D de cráneos de roedores suministradas: 
1.	Definir landmarks que describan la región facial y el neurocráneo basándose en trabajos previos (al menos 25 landmarks, incluyendo puntos de curvas y/o superficies).
2.	Digitalizar los puntos definidos sobre superficies 3D en la muestra de imágenes en formato .ply de 5 roedores en 3D Slicer (https://www.slicer.org/). 
3.	Construir un archivo que contenga todas las coordenadas de puntos digitalizadas de los 5 especímenes incluidos en la muestra en formato .tps. Luego, cargar los puntos en R.
4.	Abrir en R uno de los modelos 3D en formato .ply para su visualización. Sumar las coordenadas de puntos digitalizadas en ese caso a la visualización.  

Recursos y funciones
•	Imágenes 3D en formato .ply de 5 roedores (Mus musculus). 
A continuación, enumeramos y describimos brevemente funciones que pueden utilizarse para realizar las actividades:

## Cargar los paquetes a utilizar.
library(package)

## Cargar el archivo de puntos digitalizados en formato .tps. (Punto 3)
readland.tps(file=".tps")

## Abrir el modelo 3D .ply (Morpho). (Punto 4)
ply2mesh(".ply")

## Visualizar el modelo 3D. (Punto 4)
plot3d(modelo)

## Visualizar los puntos digitalizados en el modelo 3D (geomorph). (Punto 4)
plotspec(modelo, puntos)
