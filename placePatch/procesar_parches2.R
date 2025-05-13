# ============================
# 1. Carga de librerías
# ============================
require(geomorph)      # Análisis de morfometría geométrica
require(Morpho)        # Manipulación de modelos 3D
require(rgl)           # Visualización 3D
require(tidyverse)     # Manipulación y análisis de datos

# ============================
# 2. Funciones auxiliares
# ============================

# Función para guardar un plot 3D como imagen PNG
guardar_plot_3D <- function(mesh, puntos, plot_path) {
  message("Generando plot en: ", plot_path)
  open3d()
  wire3d(mesh, col = "cyan")
  spheres3d(puntos, col = "red")
  rgl.snapshot(plot_path, fmt = "png")
  rgl.close()
  message("Plot guardado en: ", plot_path)
}

# Función para crear carpetas si no existen
crear_carpeta <- function(ruta) {
  if (!dir.exists(ruta)) {
    dir.create(ruta, recursive = TRUE)
    message("Carpeta creada: ", ruta)
  }
}

# ============================
# 3. Función principal
# ============================
procesar_parches <- function(
  atlas_ply,          # Ruta al .ply del espécimen base
  atlas_land_tps,     # Ruta al .tps de landmarks fijos del atlas
  atlas_parche_tps,   # Ruta al .tps de semilandmarks
  targets_ply,        # Vector de rutas .ply de especímenes objetivo
  targets_land_tps,   # Vector de rutas .tps de landmarks fijos
  inflate = 5,        # Factor de "inflado" por defecto
  output_dir = "output/" # Carpeta de salida
) {
  # Crear estructura de carpetas
  crear_carpeta(file.path(output_dir, "plots"))
  crear_carpeta(file.path(output_dir, "tps"))
  
  # Leer el atlas
  message("Cargando atlas...")
  atlas_mesh <- ply2mesh(atlas_ply)
  atlas_land <- readland.tps(atlas_land_tps)[,,1]
  atlas_patch <- readland.tps(atlas_parche_tps)[,,1]
  
  # Crear el atlas
  message("Creando atlas...")
  atlas <- createAtlas(
    atlas_mesh,
    landmarks = atlas_land,
    patch = atlas_patch
  )
  message("Atlas creado con éxito")
  
  # Inicializar dataframe para el resumen
  resumen <- tibble(
    specimen = character(),
    archivo_ply = character(),
    archivo_tps = character(),
    n_landmarks = integer(),
    n_semilandmarks = integer(),
    ruta_plot = character()
  )
  
  # Procesar cada espécimen objetivo
  for (i in seq_along(targets_ply)) {
    message("\nProcesando espécimen ", i, " de ", length(targets_ply))
    
    # Leer el modelo 3D y landmarks del target
    target_mesh <- ply2mesh(targets_ply[i])
    target_land <- readland.tps(targets_land_tps[i])[,,1]
    
    # Obtener el nombre base del archivo
    base_name <- tools::file_path_sans_ext(basename(targets_ply[i]))
    message("Procesando: ", base_name)
    
    # Proyectar el parche
    message("Proyectando parche...")
    target_patch <- placePatch(
      atlas,
      target_land,
      prefix = base_name,
      path = "./",
      fileext = ".ply",
      inflate = inflate
    )
    
    # Guardar plot
    plot_path <- file.path(output_dir, "plots", paste0(base_name, "_plot.png"))
    guardar_plot_3D(target_mesh, target_patch, plot_path)
    
    # Convertir a array y guardar TPS
    total_pts <- nrow(target_patch)
    target_array <- arrayspecs(target_patch, total_pts, 3)
    tps_path <- file.path(output_dir, "tps", paste0(base_name, "_patch.tps"))
    writeland.tps(target_array, tps_path, scale = NULL)
    
    # Agregar al resumen
    resumen <- resumen %>%
      add_row(
        specimen = base_name,
        archivo_ply = targets_ply[i],
        archivo_tps = tps_path,
        n_landmarks = nrow(target_land),
        n_semilandmarks = total_pts,
        ruta_plot = plot_path
      )
  }
  
  # Exportar resumen
  resumen_path <- file.path(output_dir, "resumen.csv")
  write_csv(resumen, resumen_path)
  message("\nResumen guardado en: ", resumen_path)
}

# ============================
# 4. Ejemplo de uso
# ============================
procesar_parches(
  atlas_ply = "Carterodon_sulcidens_MZUSP34767_Css.ply",
  atlas_land_tps = "Carterodon_sulcidens.tps",
  atlas_parche_tps = "parche.tps",
  targets_ply = c(
    "Clyomys_laticeps_MN68168_Css.ply",
    "Myocastor_coypus_MN83526_Css.ply"
  ),
  targets_land_tps = c(
    "Clyomys_laticeps.tps",
    "Myocastor_coypus.tps"
  ),
  inflate = 5,
  output_dir = "output/"
)
