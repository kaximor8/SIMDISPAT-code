# Esta funcion permite crear de forma simples un template bidimensional o tridimensional
coordTeamplate = function(nxtr, nytr, nztr, inxtr, inytr, inztr){
  
# Parametros:
  # nxtr, nytr, nztr: dimensiones del template
  
# Creando valores del meshgrid
  nxT = floor((nxtr-1)/2)
  nyT = floor((nytr-1)/2)
  nzT = floor((nztr-1)/2)

# Creando matrix
  coord = matrix(nrow = (2*nxT+1)*(2*nyT+1)*(2*nzT+1), ncol = 3)


# Creando Sequencia
  anxtr = rep(seq(-nxT, nxT), (2*nyT+1))
  anytr = rep(seq(-nyT, nyT), each = (2*nxT+1))
  anztr = rep(seq(-nzT, nzT), each = (2*nxT+1)*(2*nyT+1))
  
 
# 
  coord[,1] = anxtr
  coord[,2] = anytr
  coord[,3] = anztr

# Creando Sequencia para el InnerPatch
  iseq = seq(1, nxtr*nytr*nztr)

# Creando Array
  m = array(iseq, dim = c(nxtr, nytr, nztr))
  
# template InnerPatch
  InnerPatch = rep(0, nxtr*nytr*nztr)
  middleIdx = (nxtr+1)/2
  middleIdy = (nytr+1)/2
  middleIdz = (nztr+1)/2
  boundaryX = (inxtr-1)/2
  boundaryY = (inytr-1)/2
  boundaryZ = (inztr-1)/2
  
 
# creando secuencia interna
  wx = seq(middleIdx-boundaryX, middleIdx+boundaryX)
  wy = seq(middleIdy-boundaryY, middleIdy+boundaryY)
  wz = seq(middleIdz-boundaryZ, middleIdz+boundaryZ)

  index = matrix(m[wx,wy,wz], nrow = 1)
  InnerPatch[index] = 1
  
# Retornando valores de interes
  
  return(list(coord = coord, InnerPatch = InnerPatch))
  
  
}