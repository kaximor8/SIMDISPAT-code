pastePattern = function(simim,frozsim,ix,iy,iz,ixnode,iynode,iznode,nltemplate,nx,ny,nz,
                        pattern,dataevent,datafroze,innerPatch){
  
# Reemplazando los indices con sus ya simulados puntos

  #pattern[datafroze==1] = dataevent[datafroze==1]
  #pattern[datafroze==2] = dataevent[datafroze==2]
  
  
# Considerando todos los nodos proximos
  for (ind in 1:nltemplate) {

    ixh = ix + ixnode[ind]
    iyh = iy + iynode[ind]
    izh = iz + iznode[ind]
    
    if(ixh>=1 && ixh<=nx && iyh>=1 && iyh<=ny && izh>=1 && izh<=nz){
      
      if(datafroze[ind]<1){
        simim[ixh,iyh,izh] = pattern[ind]
        
       # print(pattern)
       # print(simim[ixh,iyh,izh])
        
        #frozsim[ixh,iyh,izh] = 1
        
        if(innerPatch[ind]==1){
          frozsim[ixh,iyh,izh] = 1
          
          #print(frozsim)
          #print(frozsim[ixh,iyh,izh])
        }
        
      }
      
      
    }
  }
  
  return(list(simim = simim, frozsim = frozsim))
  
}