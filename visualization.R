library(geomorph)
library(here)

#Funcion para visualizar un modelo 3D en formato PLY
mesh <-read.ply("data/3D/BH_PG_14NOG1.ply", ShowSpecimen = TRUE)


library(SlicerMorphR)

lmks<- read.markups.json ("samplelm.mrk.json")

#ademas de leerlo necesito armar un array, donde las dimensiones van a ser:
#numero de landmarks, 3 (por x,y,z) y F siendo F el numero de archivos. 

# myLMs = array (dim = c(53,3,62))
# for (i in 1:62)  myLMs [,,i] = read.markups.json (files[i)])  # i read each file