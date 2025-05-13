library(geomorph)
library(Morpho)
library(Rvcg)
library(rgl)
dataset <- readland.tps(
  file = "MusDataset.tps",
)

# Slides Semilandmarks along curves and surfaces in 3D
# by minimising bending energy of a thin-plate spline deformation.


# Definir las dos curvas de semilandmarks (puntos 11-25 y 26-40)
curva1 <- 11:30
curva2 <- 31:70
curvas <- list(curva1, curva2)


# Realizar Procrustes + deslizamiento (usando bending energy)
procrustes_BE <- procSym(
  dataarray = dataset,
  outlines = curvas,     # Semilandmarks en curvas
  scale = F,          # Scaling
  reflect = TRUE,        # Permitir reflexiones
  iterations = 0,        # Iterar hasta convergencia
  bending = TRUE,        # Minimizar bending energy (para curvas)
  tol = 1e-05            # Tolerancia para convergencia
)
  

# Realizar Procrustes + deslizamiento (Usando Procrustes distance)
procrustes_PD <- procSym(
  dataarray = dataset,
  outlines = curvas,     # Semilandmarks en curvas
  scale = F,          # Scaling
  reflect = TRUE,        # Permitir reflexiones
  iterations = 0,        # Iterar hasta convergencia
  bending = F,           # Minimizar bending energy (para curvas)
  tol = 1e-05            # Tolerancia para convergencia
)


## Resultados Bending Energy

centroid_size_BE <- procrustes_BE$size ## Tamaño del centroide 

shape_coords_BE <- procrustes_BE$orpdata ## Coordenadas de forma

meanshape_BE <- procrustes_BE$mshape #Forma consenso BE


## Resultados Proc Distances


centroid_size_PD <- procrustes_PD$size ## Tamaño del centroide 

shape_coords_PD <- procrustes_PD$orpdata ## Coordenadas de forma

meanshape_PD <- procrustes_PD$mshape ## Forma consenso PD



# Exportar todo REVISAR
write.csv(centroid_size_BE, "centroid_size_BE.csv")
write.csv(centroid_size_PD, "centroid_size_PD.csv")


write.csv(shape_coords_BE, "shape_coords_BE.csv")
write.csv(shape_coords_PD, "shape_coords_PD.csv")


write.csv(meanshape_BE, "consensus_BE.csv")
write.csv(meanshape_PD, "consensus_PD.csv")


## Plot Shape Coordinates

x1BE <- shape_coords_BE[,,1][,1] # Ej: Shape coords en X del individuo 1
y1BE <- shape_coords_BE[,,1][,2] # Shape coords en Y del individuo 1   
z1BE <- shape_coords_BE[,,1][,3] # Shape coords en Z del individuo 1  


x1PD <- shape_coords_PD[,,1][,1] # Ej: Shape coords en X del individuo 1
y1PD <- shape_coords_PD[,,1][,2] # Shape coords en Y del individuo 1   
z1PD <- shape_coords_PD[,,1][,3] # Shape coords en Z del individuo 1  


## Coordenadas de la forma consenso PD 

x1MeanPD <- meanshape_PD[,1] # Ej: Mean Shape coords en X del individuo 1
y1MeanPD <- meanshape_PD[,2] # Mean Shape coords en Y del individuo 1   
z1MeanPD <- meanshape_PD[,3] # Mean Shape coords en Z del individuo 1  


xMeanBE <- meanshape_BE [,1] # Ej: Mean Shape coords X
yMeanBE <- meanshape_BE [,2] # Mean Shape coords en Y 
zMeanBE <- meanshape_BE[,3] # Mean Shape coords en Z 


# Coordenadas Originales (Antes del Procrustes)
points3d(dataset[,,1], col = "gray", size = 10)

# Shape coordinates Bending Energy

plot3d(x1BE, y1BE, z1BE, col = "blue", size = 1, type = "s")

# Shape coordinates  Procrustes Distance

plot3d(x1PD, y1PD, z1PD, col = "red", size = 1, type = "s")

# Shape coordinates Consensus Shape PD

plot3d(x1MeanPD,y1MeanPD,z1MeanPD, col = "green", size = 1, type ="s")

# Shape coordinates Consensus Shape BE
plot3d(x1MeanBE,y1MeanBE,z1MeanBE, col = "green", size = 1, type ="s")

########################################################################
###########################MISSING DATA#################################
########################################################################







# Copia del dataset original
dataset_missing1 <- dataset
dataset_missing2 <- dataset
dataset_missing3 <- dataset

# DATASET_1 1 especimen con 5 NA 

dataset_missing1[1:5, , 1] <- NA

# DATASET_2 2 Especimenes con 5 NA cada uno

dataset_missing2[1:5, , 2:3] <- NA

# DATASET_3 Un especimen le falta una curva 

dataset_missing3[11:40,,4] <- NA

# Estimate missing landmarks 
# fixLMtps is based on a weighted nearest-neighbor interpolation 
# combined with a thin-plate spline (TPS) deformation

out_MD1 <- fixLMtps(dataset_missing1)

out_MD2 <- fixLMtps(dataset_missing2)

out_MD3 <- fixLMtps(dataset_missing3)

## Curva reconstruida para el MD 3


## Median Shape 
xMshape_MD3 <- out_MD3$mshape [ ,1]
yMshape_MD3 <- out_MD3$mshape [ ,2]
zMshape_MD3 <- out_MD3$mshape [ ,3]

plot3d(xMshape_MD3,yMshape_MD3,zMshape_MD3, col = "cyan", size = 1, type = "s")


## Comparamos forma "real" con forma reconstruida 

#Shape coordinates individuo 4 le falta un arco zigomatico
x4PD <- shape_coords_PD[,,1][,1] # Ej: Shape coords en X del individuo 4
y4PD <- shape_coords_PD[,,1][,2] # Shape coords en Y del individuo 4   
z4PD <- shape_coords_PD[,,1][,3] # Shape coords en Z del individuo 4  

##Shape coordinates individuo 4 reconstruido
x4MD3 <- out_MD3$out[,,4][,1]
yMD3  <- out_MD3$out[,,4][,2]
zMD3  <- out_MD3$out[,,4][,3]

open3d()

plot3d(x4PD,y4PD,z4PD, col = "black", size = 1, type = "s")

plot3d(x4MD3, yMD3, zMD3, col = "blue", size = 1, type = "s")

###############################################################
### Estimamos missing data usando geomorph "Reg" ##############

# No se puede porque hay mucho missing data para hacer una regresion.

# Vamos a hacer un dataset con menos missing data

dataset_missing4 <- dataset

# DATASET_1 1 especimen con 2 NA 

dataset_missing4[1, , 1] <- NA


estimate.missing(dataset_missing4, method = "Reg")

# Tampoco pude con un solo NA




