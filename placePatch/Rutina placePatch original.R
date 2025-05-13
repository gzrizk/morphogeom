require(geomorph) # Cargar la biblioteca geomorph para análisis de morfometría geométrica
require(Morpho)   # Cargar la biblioteca Morpho para manipulación de modelos 3D

# Cargar el modelo 3D del espécimen base
carte <- ply2mesh("Carterodon_sulcidens_MZUSP34767_Css.ply")

# Cargar los landmarks del espécimen base desde un archivo .tps
cartland <- readland.tps("Carterodon_sulcidens.tps", specID = "ID")
cartland <- cartland[,,1] # Seleccionar el primer espécimen
class(cartland) # Verificar la clase del objeto

# Cargar los landmarks del parche desde un archivo .tps
cartpat <- readland.tps("parche.tps")
cartpat <- cartpat[,,1] # Seleccionar el primer espécimen
class(cartpat) # Verificar la clase del objeto

# Crear un atlas combinando el modelo 3D, landmarks y el parche
cartatlas <- createAtlas(carte, landmarks = cartland, patch = cartpat, corrCurves = NULL, patchCurves = NULL, keep.fix = NULL)
plotAtlas(cartatlas) # Visualizar el atlas creado

# Cargar el modelo 3D del espécimen objetivo
clyo <- ply2mesh("Clyomys_laticeps_MN68168_Css.ply")

# Cargar los landmarks del espécimen objetivo desde un archivo .tps
clyoland <- readland.tps("Clyomys_laticeps.tps", specID = "ID") # Cargar landmarks del espécimen objetivo
clyoland <- clyoland[,,1] # Seleccionar el primer espécimen

# Proyectar el parche desde el atlas al espécimen objetivo
clyopat <- placePatch(cartatlas, clyoland, prefix = "Clyomys_laticeps_MN68168_Css", path = "./", fileext = ".ply", inflate = 5)

# Visualizar el modelo 3D del espécimen objetivo
wire3d(clyo, col = "cyan")
# Visualizar los landmarks proyectados
spheres3d(clyopat) 

# Convertir los landmarks proyectados en un array con dimensiones específicas
clyoarray <- arrayspecs(clyopat, 77, 3)
class(clyoarray) # Verificar la clase del objeto

# Guardar los landmarks proyectados en un archivo .tps
writeland.tps(clyoarray, "Clyomys_laticeps_MN68168_Css patch.tps", scale = NULL)

# Repetir el proceso para otro espécimen
myoland <- readland.tps("Myocastor_coypus.tps", specID = "ID") # Cargar landmarks del segundo espécimen
myoland <- myoland[,,1] # Seleccionar el primer espécimen

myo <- ply2mesh("Myocastor_coypus_MN83526_Css.ply") # Cargar el modelo 3D del segundo espécimen

# Proyectar el parche desde el atlas al segundo espécimen
myopat <- placePatch(cartatlas, myoland, prefix = "Myocastor_coypus_MN83526_Css", path = "./", fileext = ".ply", inflate = 7)

# Visualizar el modelo 3D del segundo espécimen
wire3d(myo, col = "cyan")
# Visualizar los landmarks proyectados en el segundo espécimen
spheres3d(myopat, col = "red")

# Convertir los landmarks proyectados en un array con dimensiones específicas
myoarray <- arrayspecs(myopat, 77, 3)
class(myoarray) # Verificar la clase del objeto

# Guardar los landmarks proyectados del segundo espécimen en un archivo .tps
writeland.tps(myoarray, "Myocastor_coypus_MN83526_Css patch.tps", scale = NULL)


