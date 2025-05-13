library(SlicerMorphR)
library(stringr)

# ---- CONFIGURACIÓN ----
data_path <- "data/landmarks"
prefixes <- c(LM = "LM_", CRV = "CRV", SURF = "SURF")

# ---- FUNCIÓN: obtener ID de individuo ----
obtener_id <- function(nombre_archivo) {
  str_remove(basename(nombre_archivo), "^(LM_|CRV[0-9]*_|SURF_)?") %>% 
    str_remove("\\.json$")
}

# ---- FUNCIÓN: clasificar archivos por tipo e ID ----
clasificar_por_individuo <- function(path) {
  archivos <- list.files(path, pattern = "\\.json$", full.names = TRUE)
  info <- data.frame(
    archivo = archivos,
    tipo = case_when(
      grepl("^LM_", basename(archivos)) ~ "LM",
      grepl("^CRV[0-9]*_", basename(archivos)) ~ "CRV",
      grepl("^SURF_", basename(archivos)) ~ "SURF",
      TRUE ~ "OTRO"
    ),
    id = sapply(archivos, obtener_id),
    stringsAsFactors = FALSE
  )
  split(info, info$id)
}

# ---- PROCESAR TODOS LOS INDIVIDUOS ----
individuos <- clasificar_por_individuo(data_path)
n_ind <- length(individuos)

# Vamos a construir un array vacío y una tabla de índices
coords_list <- list()
index_table <- data.frame(ID=character(), Tipo=character(), Elemento=character(), From=integer(), To=integer(), stringsAsFactors = FALSE)

for (i in seq_along(individuos)) {
  indiv <- individuos[[i]]
  ID <- unique(indiv$id)
  bloques <- list()
  fila_inicial <- 1
  
  # 1. Leer LM
  archivo_lm <- indiv$archivo[indiv$tipo == "LM"]
  if (length(archivo_lm) != 1) stop(paste("Debe haber un único LM para", ID))
  lm <- read.markups.json(archivo_lm)
  bloques[["LM"]] <- lm
  fila_final <- nrow(lm)
  index_table <- rbind(index_table, data.frame(ID=ID, Tipo="LM", Elemento="LM", From=fila_inicial, To=fila_final))
  fila_inicial <- fila_final + 1
  
  # 2. Leer CRVs
  crv_files <- indiv$archivo[indiv$tipo == "CRV"]
  if (length(crv_files) > 0) {
    for (j in seq_along(crv_files)) {
      crv <- read.markups.json(crv_files[j])
      nombre <- paste0("CRV", j)
      bloques[[nombre]] <- crv
      fila_final <- fila_inicial + nrow(crv) - 1
      index_table <- rbind(index_table, data.frame(ID=ID, Tipo="CRV", Elemento=nombre, From=fila_inicial, To=fila_final))
      fila_inicial <- fila_final + 1
    }
  }

  # 3. Leer SURFs
  surf_files <- indiv$archivo[indiv$tipo == "SURF"]
  if (length(surf_files) > 0) {
    for (j in seq_along(surf_files)) {
      surf <- read.markups.json(surf_files[j])
      nombre <- paste0("SURF", j)
      bloques[[nombre]] <- surf
      fila_final <- fila_inicial + nrow(surf) - 1
      index_table <- rbind(index_table, data.frame(ID=ID, Tipo="SURF", Elemento=nombre, From=fila_inicial, To=fila_final))
      fila_inicial <- fila_final + 1
    }
  }

  # Combinar bloques
  indiv_coords <- do.call(rbind, bloques)
  coords_list[[ID]] <- indiv_coords
}

# ---- CREAR ARRAY FINAL ----
n_landmarks_tot <- nrow(coords_list[[1]])
coords_array <- array(dim = c(n_landmarks_tot, 3, n_ind))
for (i in seq_along(coords_list)) {
  coords_array[,,i] <- coords_list[[i]]
}

# ---- GUARDAR .TPS ----
writeland.tps(coords_array, file = "output/misLandmarks_FULL.tps")

# ---- GUARDAR INFO DE BLOQUES ----
write.csv(index_table, file = "output/index_coordenadas.csv", row.names = FALSE)

cat("Exportado con éxito: .tps y archivo de índices.\n")
