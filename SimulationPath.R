SimulationPath = function(simim, frozsim, patterns, npdb, ncoarsest, orderpath,
                          ixnode, iynode, iznode, nltemplate, nx, ny, nz, 
                          innerPatch, seedpattern, w1, w2, w3, dbtol){
  
  
# Definiendo parametros
  ncoarse = ncoarsest[1]
  nxcoarse = ncoarsest[2]
  nxycoarse = ncoarsest[5]
  nxyzcoarse = ncoarsest[6]
 
  
# Loop sobre todos los nodos de la multiple grid en cuestion
  for (ind in 1:nxyzcoarse) {
    jz = 1 + floor((orderpath[ind]-1)/nxycoarse)
    jy = 1 + floor((orderpath[ind]-(jz-1)*nxycoarse-1)/nxcoarse)
    jx = orderpath[ind]-(jz-1)*nxycoarse-(jy-1)*nxcoarse
    ix = (jx-1)*ncoarse+1
    iy = (jy-1)*ncoarse+1
    iz = (jz-1)*ncoarse+1


    if(frozsim[ix,iy,iz] != -99){
      next
      
    }

# Obteniendo el dato de eventos condicionante
    results = getDataEvent(simim,frozsim,ix,iy,iz,ixnode,iynode,iznode,nltemplate,nx,ny,nz)
    dataevent = results$dataevent
    datafroze = results$datafroze
    
    #View(simim)
    
# Asignando pesos de acuerdo al tipo de dato: dato bruto, previamente simulados e otros.
    weightevent = AssignWeight(datafroze,nltemplate,w1,w2,w3)
    
# Calculando el patron mas similar atraves de la distancia
    results = similarPattern(dataevent, weightevent, patterns, npdb, nltemplate, 
                             seedpattern, dbtol, typedist)
    pattern = results$pattern
    rindx   = results$rindx
    seedpattern = results$seedpattern
  
   
    results = pastePattern(simim,frozsim,ix,iy,iz,ixnode,iynode,iznode,nltemplate,nx,ny,nz,
                           pattern,dataevent,datafroze,innerPatch)
    simim = results$simim
    frozsim = results$frozsim
    

  }
  
  rsimim = matrix(simim, nx*ny,1)
 xloc  = rep(seq(1,101), 101)
 yloc  = rep(seq(1,101), each = 101)
 data  = data.frame(x = xloc, y = yloc, v = rsimim)
 g = ggplot(data) + geom_tile(aes(x, y, fill = v)) +theme_classic()+
   scale_fill_distiller(palette = "Greys")
 print(g)
 
  
  return(simim)
  
}