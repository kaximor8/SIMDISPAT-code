library(matlab)

#Leer datos del archivo de texto "data.txt" en la matriz A=================
data=as.matrix(read.table('./Datos_muestreados/categoric.dat',comment.char='%', sep = ",", header = T))
#data = c()
#outlf=as.matrix(read.table('snesim.out',comment.char='%'))

typedata = 0           # tipo de datos 0-categoricos, 1-continuos
typedist = 0           # si la distancia escogida es Manhattan es = 0; si es Euclidiana = 1
seed = 689558

nsim = 2

#Especificacion de la malla X

nx = 101
xmn = 0
xsiz = 1

#Especificacion de la malla Y
ny = 101
ymn = 0
ysiz = 1

#Especificacion de la malla Z
nz = 1
zmn = 0
zsiz = 1

nxy = nx*ny
nxyz = nxy*nz


#templatefl=as.matrix(read.table('template48.dat',comment.char='%')) modificado 
source("coordTemplate.R")
nxT = 19
nyT = 19
nzT = 1
inxT = 9
inyT = 9
inzT = 1
results = coordTeamplate(nxT,nyT,nzT,inxT,inyT,inzT)
templatefl = results$coord
innerPatch = results$InnerPatch
#print(innerPatch)
#print(templatefl)

nmult = 1

trainfl=as.matrix(read.table('./Images/categorical.dat',comment.char='%'))
#trainfl = trainfl[,2]
nxtr = 101; nytr = 101
nztr = 1
nxytr = nxtr*nytr
nxyztr = nxytr*nztr
ivrltr = trainfl


# Especificando los pesos para cada tipo de nodo: w1 - muestreado, 
# w2 - simulado o pasado e w3 - otros.
w1 = 0.7
w2 = 0.2
w3 = 0.1

# Tolerancia de particion de base de datos e porcentaje de la base de datos
dbtol = 1000000
patpercent = 0.999

# Parametros de busqueda del variograma! Una posible Opcion.

radius = 10                                    
radius1 = 10                                    
radius2 = 1    
sang1 = 0                                      
sang2 = 0
sang3 = 0
angles = c(sang1,sang2,sang2)
sanis1 = radius1/radius
sanis2 = radius2/radius
sanis = c(sanis1,sanis2)

# Lectura de funciones
source(".\\simdispat.R")
source(".\\RelocateData.R")
source(".\\getindx.R")
source(".\\setRotMat.R")
source(".\\InitializeSearch.R")
source(".\\SortTemplate.R")
source(".\\PatterBase.R")
source(".\\scanTemplate.R")
source(".\\SimulationPath.R")
source(".\\AssignData.R")
source(".\\getDataEvent.R")
source(".\\AssignWeight.R")
source(".\\similarPattern.R")
source(".\\disDistance.R")
source(".\\pastePattern.R")

# Multiplas realizacoes
results = 
  simdispat(data,nx,xmn,xsiz,ny,ymn,ysiz,nz,zmn,zsiz,
         nxyz,trainfl,nxtr,nytr,nztr,ivrltr,nxytr,nxyztr,templatefl,innerPatch,
         nmult,radius,angles,sanis,nsim,seed,nxT,nyT,nzT,w1,w2,w3,
         typedata,typedist, dbtol,patpercent)


