getDataEvent = function(simim,frozsim,ix,iy,iz,ixnode,iynode,iznode,
                        nltemplate,nx,ny,nz){
  
  
# Definiendo parametros
  dataevent = rep(-777, nltemplate)
  datafroze = rep(-777, nltemplate)
  ixh = ix + ixnode
  iyh = iy + iynode
  izh = iz + iznode


# Considerando todos los nodos proximos
  for (ind in 1:nltemplate) {
    
    if(ixh[ind]>=1 && ixh[ind]<=nx && iyh[ind]>=1 && iyh[ind]<=ny 
       && izh[ind]>=1 && izh[ind]<=nz){
      dataevent[ind] = simim[ixh[ind],iyh[ind],izh[ind]]
      datafroze[ind] = frozsim[ixh[ind],iyh[ind],izh[ind]]
    }
  }
  
  
  return(list(dataevent = dataevent, datafroze = datafroze))
}