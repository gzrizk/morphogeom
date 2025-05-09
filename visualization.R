library(geomorph)
library(Morpho)
library(here)
library(Rvcg)
library(rgl)
library(abind)
library(jsonlite)


# ----------------------------
# CONFIGURACIÓN DE DIRECTORIOS
# ----------------------------
base_dir <- "C:/Users/Usuario/OneDrive/morphogeom/data"
model_dir <- file.path(base_dir, "models")
lm_dir <- file.path(base_dir, "landmarks")
curve_dir <- file.path(base_dir, "semilandmarks")
surface_dir <- file.path(base_dir, "superficies")


mesh <-ply2mesh("data/models/Mus1.ply")

plot3d(mesh)





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