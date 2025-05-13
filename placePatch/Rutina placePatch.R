require(geomorph)
require(Morpho)

#cargar el ply
carte<-ply2mesh("Carterodon_sulcidens_MZUSP34767_Css.ply")

#cargar el archivos de puntos y hacer un objeto del tipo array con los landmarks del especimen que corresponde al ply
cartland<-readland.tps("Carterodon_sulcidens.tps", specID = "ID")
cartland<-cartland[,,1]
class(cartland)

#cargar los archivos del parche
cartpat<-readland.tps("parche.tps")
cartpat<-cartpat[,,1]
class(cartpat)

#crear un atlas que se necesita en la función placePatch y plotearlo
cartatlas<-createAtlas(carte, landmarks = cartland, patch = cartpat, corrCurves = NULL, patchCurves = NULL, keep.fix = NULL)
plotAtlas(cartatlas)

######


#cargar el target en el que se van a poner los parches.

clyo<-ply2mesh("Clyomys_laticeps_MN68168_Css.ply")

#implementar la función placePathc. Project semi-landmarks from a predefined atlas onto all specimen in a sample
clyopat<-placePatch(cartatlas, clyoland, prefix = "Clyomys_laticeps_MN68168_Css", path = "./", fileext = ".ply", inflate = 5)

wire3d(clyo, col = "cyan")
spheres3d(clyopat) #acá plotea los puntos resultados de proyectar los smlksd del parche.

#Construye un array con los puntos resultado de proyectarlos, indicándole la cant de puntos y las dimensiones.
clyoarray<-arrayspecs(clyopat, 77, 3)
class(clyoarray)

writeland.tps(clyoarray, "Clyomys_laticeps_MN68168_Css patch.tps", scale = NULL)











#######
myoland<-readland.tps("Myocastor_coypus.tps", specID = "ID")
myoland<-myoland[,,1]

myo<-ply2mesh("Myocastor_coypus_MN83526_Css.ply")

myopat<-placePatch(cartatlas, myoland, prefix = "Myocastor_coypus_MN83526_Css", path = "./", fileext = ".ply", inflate = 7)
wire3d(myo, col = "cyan")
spheres3d(myopat, col = "red")
myoarray<-arrayspecs(myopat, 77, 3)
class(myoarray)
writeland.tps(myoarray, "Myocastor_coypus_MN83526_Css patch.tps", scale = NULL)


