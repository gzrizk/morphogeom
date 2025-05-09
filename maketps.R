# Este es un script super cabeza, que funciona para hacer el archivo tps con los landmarks. 


#Armar un array a partir del archivo de puntos salido de 3DSlicer .json
#Cargar el paquete SlicerMorphR
library("SlicerMorphR")

#Cargar archivo .json Sirve para saber el numero de landmarks medio cabeza
lmks <- read.markups.json("data/landmarks/Mus2_LM.json") # leer archivo individual
lmks

# # leer lista de archivos json con coordenadas de una carpeta
# files <- list.files(pattern = "data/landmarks/json")


# Especificar la ruta correcta a tu carpeta de landmarks
files <- list.files(
  path = "data/landmarks",   # Ruta a tu carpeta
  pattern = "\\.json$",      # Patr??n para filtrar solo archivos .json
  full.names = TRUE          # Incluir la ruta completa (ej: "data/landmarks/archivo1.json")
)



n_ind <- length(files) # cuantos individuos?

nrow(lmks) # cuantos landmarks?

#Armar un array con los landmarks del conjunto de archivos
myLMs = array(dim=c(10, 3, n_ind)) # create an array of 53 lmks, 3 dimensions, 3 files
for (i in 1:n_ind) myLMs[,,i] = read.markups.json(files[i]) # i read each file

myLMs

writeland.tps(myLMs, file="misLands.tps")
