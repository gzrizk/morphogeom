## TIENE ERRORES. REVISAR TRANQUILO. 



# Morfometría 3D con Parches Semiautomáticos

Este repositorio contiene un script en R (`procesar_parches.R`) diseñado para proyectar **semilandmarks de superficie** y **curvas** sobre múltiples especímenes 3D, utilizando un atlas de referencia.

---

## 📂 Estructura de carpetas sugerida

Organiza los archivos en las siguientes carpetas para facilitar el uso del script:

```
project-root/
├─ data/
│   ├─ atlas/
│   │   ├─ atlas_mesh.ply          # Modelo 3D del atlas
│   │   ├─ atlas_landmarks.tps     # Landmarks fijos del atlas
│   │   └─ atlas_patch.tps         # Semilandmarks del parche
│   ├─ targets/
│   │   ├─ specimen1_mesh.ply      # Modelo 3D del espécimen 1
│   │   ├─ specimen1_landmarks.tps # Landmarks fijos del espécimen 1
│   │   ├─ specimen2_mesh.ply      # Modelo 3D del espécimen 2
│   │   └─ specimen2_landmarks.tps # Landmarks fijos del espécimen 2
│
├─ output/
│   ├─ plots/                      # Capturas PNG de los especímenes procesados
│   └─ tps/                        # Archivos TPS generados
│
├─ scripts/
│   └─ procesar_parches.R          # Script principal
└─ README.md                       # Documentación
```

---

## 🚀 Instalación de dependencias

Antes de ejecutar el script, asegúrate de instalar las siguientes bibliotecas en R:

```r
install.packages(c(
  "geomorph", "Morpho", "SlicerMorphR",
  "rgl", "jsonlite", "tidyverse"
))
```

---

## ⚙️ Uso básico

### 1. Definir curvas (opcional)
Si deseas incluir curvas en el análisis, define las listas `corrCurves` y `patchCurves` en un archivo llamado `curves_definition.R` dentro de la carpeta `data/atlas/`. Por ejemplo:

```r
# data/atlas/curves_definition.R
corrCurves <- list(
  arcoOrbitario = c(5, 12),  # Índices de landmarks fijos
  suturaNasal   = c(2, 8)
)

patchCurves <- list(
  arcoOrbitario = 1:15,      # Índices de semilandmarks
  suturaNasal   = 16:30
)
```

### 2. Ejecutar el script
Carga el script y ejecuta la función `procesar_parches` con los argumentos correspondientes:

```r
source("scripts/procesar_parches.R")

procesar_parches(
  atlas_ply        = "data/atlas/atlas_mesh.ply",
  atlas_land_tps   = "data/atlas/atlas_landmarks.tps",
  atlas_parche_tps = "data/atlas/atlas_patch.tps",
  targets_ply      = list.files("data/targets/", "\\.ply$", full.names = TRUE),
  targets_land_tps = list.files("data/targets/", "_landmarks\\.tps$", full.names = TRUE),
  corrCurves       = if (file.exists("data/atlas/curves_definition.R")) source("data/atlas/curves_definition.R")$corrCurves else NULL,
  patchCurves      = if (file.exists("data/atlas/curves_definition.R")) source("data/atlas/curves_definition.R")$patchCurves else NULL,
  inflate          = 5,
  output_dir       = "output/"
)
```

---

## 📋 Salidas generadas

El script generará los siguientes archivos en la carpeta `output/`:

- **`output/plots/`**: Capturas PNG de cada espécimen con los semilandmarks proyectados.
- **`output/tps/`**: Archivos TPS con los semilandmarks proyectados.
- **`output/resumen.csv`**: Tabla resumen con los siguientes datos:
  - Nombre del espécimen
  - Ruta del archivo `.ply`
  - Ruta del archivo `.tps`
  - Número de landmarks fijos
  - Número de semilandmarks
  - Ruta del plot generado

---

## 🏷️ Buenas prácticas de nombres

Para evitar confusiones, utiliza nombres consistentes para los archivos:

- **Modelos 3D (`.ply`)**: `Genus_species_ID.ply`  
  Ejemplo: `Carterodon_sulcidens_MZUSP34767_Css.ply`

- **Landmarks fijos (`.tps`)**: `Genus_species_ID_landmarks.tps`  
  Ejemplo: `Carterodon_sulcidens_landmarks.tps`

- **Semilandmarks (`.tps`)**: `Genus_species_ID_patch.tps`  
  Ejemplo: `Carterodon_sulcidens_patch.tps`

- **Curvas (`curves_definition.R`)**: Define índices claros y consistentes para landmarks y semilandmarks.

---

## 🛠️ Notas adicionales

- Asegúrate de que los archivos `.ply` y `.tps` estén correctamente formateados y ubicados en las carpetas correspondientes.
- Si encuentras errores, verifica que las rutas de los archivos sean correctas y que las dependencias estén instaladas.

---

¡Listo! Ahora puedes procesar tus especímenes 3D de manera eficiente y reproducible.

