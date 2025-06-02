ScanTemplate = function(trainim, nxtr, nytr, nztr, ix, iy, iz, 
                        ixnode, iynode, iznode, nltemplate){
  
# Definicion de coordenadas
  ixh = ix + ixnode
  iyh = iy + iynode
  izh = iz + iznode

  
# Comprobar si esta completo el template dentro de la imagen
  sixh = sum((ixh>=1 & ixh<=nxtr))
  siyh = sum((iyh>=1 & iyh<=nytr))
  sizh = sum((izh>=1 & izh<=nztr))
  
# Iniciando el contador
  cont = 0
  pattern = 0
  
  if(sixh==nltemplate & siyh==nltemplate & sizh==nltemplate){
    cont = nltemplate
    nbh = ixh + (iyh-1)*nxtr + (izh-1)*nxtr*nytr
    pattern = trainim[nbh]
    
   
   
  }
 
  return(list(cont = cont, pattern = pattern))
  
}
  
