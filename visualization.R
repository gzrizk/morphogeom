library(geomorph)
library(Morpho)
library(here)
library(Rvcg)
library(rgl)
library(abind)
library(jsonlite)
library(SlicerMorphR)


# ----------------------------
# CONFIGURACIÓN DE DIRECTORIOS

# ----------------------------
# 1. Establecer directorio base 
base_dir <- here("data")  # Ruta a "morphogeom/data"

# 2. Construir subdirectorios
model_dir <- here(base_dir, "models")
lm_dir <- here(base_dir, "landmarks")
curves_dir<- here(base_dir,"curves")
suraces_dir<-here(base_dir,"surfaces")


## Cargamos los modelos

model_mus2 <- ply2mesh("data/models/Mus2.ply")

model_mus3 <- ply2mesh("data/models/Mus3.ply")

model_mus4 <- ply2mesh("data/models/Mus4.ply")

model_mus5 <- ply2mesh("data/models/Mus5.ply")

## Ploteamos modelos con la funcion #plot3d

plot3d(model_mus2) # Ejemplo

## Leemos las coordenadas de los landmarks:

lmksMus2 <- read.markups.json("data/landmarks/Mus2_LM.json")

lmksMus3 <- read.markups.json("data/landmarks/Mus3_LM.json")

lmksMus4 <- read.markups.json("data/landmarks/Mus4_LM.json")

lmksMus5 <- read.markups.json("data/landmarks/Mus5_LM.json")

## Leemos las coordenadas de las curvas:

zigoLMus2 <- read.markups.json("data/curves/Mus2_ZigoLeft.json")
zigoRMus2 <- read.markups.json("data/curves/Mus2_ZigoRight.json")

zigoLMus3 <- read.markups.json("data/curves/Mus3_ZigoLeft.json")
zigoRMus3 <- read.markups.json("data/curves/Mus3_ZigoRight.json")


zigoLMus4 <- read.markups.json("data/curves/Mus4_ZigoLeft.json")
zigoRMus4 <- read.markups.json("data/curves/Mus4_ZigoRight.json")

zigoLMus5 <- read.markups.json("data/curves/Mus5_ZigoLeft.json")
zigoRMus5 <- read.markups.json("data/curves/Mus5_ZigoRight.json")

## Leemos las coordenadas de las superficies: 

surfaceMus2 <-read.markups.json("data/surfaces/Mus2_S.json")
surfaceMus3 <-read.markups.json("data/surfaces/Mus3_S.json")
surfaceMus4 <-read.markups.json("data/surfaces/Mus4_S.json")
surfaceMus5 <-read.markups.json("data/surfaces/Mus5_S.json")






#Plotear un especimen

plotspec(
  spec = model_mus2,        # Malla 3D del modelo (mesh/shape)
  digitspec = lmksMus2,     # Matriz con coordenadas de landmarks
  fixed = 10,               # Numero de landmarks fijos
  fixed.pt.col = "green",   # Color landmarks fijos: verde
  fixed.pt.size = 10,       # Tamaño landmarks fijos: 10
  mesh.ptsize = 0.5,        # Tamaño puntos de la malla: 0.5 (pequeño)
  centered = FALSE          # Los landmarks NO están centrados con la malla
  )





# # ----------------------------
# # LECTURA Y ORGANIZACIÓN DE DATOS
# # ----------------------------
# process_landmarks <- function(specimen, paths, include = c("landmarks", "curves", "surfaces")) {
#   # Crear una lista de componentes según los argumentos
#   components <- list()
  
#   if ("landmarks" %in% include) {
#     components$fixed <- file.path(paths$landmarks, paste0(specimen, "_LM.json"))
#   }
#   if ("curves" %in% include) {
#     components$curve1 <- file.path(paths$curves, paste0(specimen, "_ZigoLeft.json"))
#     components$curve2 <- file.path(paths$curves, paste0(specimen, "_ZigoRight.json"))
#   }
#   if ("surfaces" %in% include) {
#     components$surface <- file.path(paths$surfaces, paste0(specimen, "_SL.json"))
#   }
  
#   # Leer y combinar manteniendo el orden
#   landmark_data <- lapply(components, function(f) {
#     if (file.exists(f)) {
#       # Usar la función read.markups.json del paquete SlicerMorphR
#       read.markups.json(f)$lmks
#     } else {
#       NULL
#     }
#   })
  
#   combined <- do.call(rbind, landmark_data)
  
#   # Forzar orden consistente por posición de fila
#   rownames(combined) <- paste0("LM-", 1:nrow(combined))
#   combined
# }

# # ----------------------------
# # FUNCIÓN PRINCIPAL
# # ----------------------------
# create_gm_dataset <- function(base_dir = "directorio/data/coords") {
#   paths <- setup_paths(base_dir)
  
#   # 1. Leer modelos 3D
#   ply_files <- list.files(paths$models, pattern = "\\.PLY$", full.names = TRUE)
#   specimens <- get_specimens(ply_files)
#   meshes <- setNames(lapply(ply_files, vcgPlyRead), specimens)
  
#   # 2. Procesar landmarks
#   landmark_list <- lapply(specimens, process_landmarks, paths)
  
#   # 3. Crear array 3D
#   landmark_array <- abind(landmark_list, along = 3)
#   dimnames(landmark_array)[[3]] <- specimens
  
#   # 4. Verificaciones
#   check_landmark_consistency(landmark_list, specimens)
  
#   list(meshes = meshes, landmarks = landmark_array)
# }

# # ----------------------------
# # VERIFICACIONES
# # ----------------------------
# check_landmark_consistency <- function(landmark_list, specimens) {
#   n_landmarks <- sapply(landmark_list, nrow)
  
#   if(length(unique(n_landmarks)) > 1) {
#     stop(paste("Inconsistencia en número de landmarks entre especímenes:",
#               paste(n_landmarks, collapse = ", ")))
#   }
  
#   message(paste("✓ Dataset creado con éxito:",
#                length(specimens), "especímenes,",
#                n_landmarks[1], "landmarks por espécimen"))
# }

# # ----------------------------
# # VISUALIZACIÓN
# # ----------------------------
# visualize_specimen <- function(mesh, landmarks, specimen) {
#   open3d()
#   shade3d(mesh, color = "gray90", alpha = 0.6)
#   spheres3d(landmarks, color = "red", radius = 0.3)
#   title3d(sub = specimen)
#   axes3d()
# }

# # ----------------------------
# # EJECUCIÓN
# # ----------------------------
# # Ejemplo de uso:
# gm_data <- create_gm_dataset()

# # Visualizar todos los especímenes
# lapply(names(gm_data$meshes), function(s) {
#   visualize_specimen(
#     mesh = gm_data$meshes[[s]],
#     landmarks = gm_data$landmarks[,,s],
#     specimen = s
#   )
# })