disDistance = function(dataevent, weightevent, patterns, seedpattern, typedist){
  
# Definiendo parametros
  index = dataevent>=0
  #print(index)
  set.seed(seedpattern)
  
  #print(index)
  #reducePatterns = matrix(nrow = length(patterns[,1]), ncol = length(index))
  
# reduciendo la dimensionalidad
  reduceDataevent   = dataevent[index]
  weightevent = weightevent[index]
  ncol  = length(reduceDataevent)
  
  #print( weightevent)
  #print(ncol )
  
# Aplicando la distancia Manhattan a cada particion de la base de patrones 
  dmanhattan = lapply(patterns, function(x){
    pdim = dim(x)
    idv  = sample(1:pdim[1], replace= FALSE)
    if(typedist == 0){
    dif = abs(matrix(rep(reduceDataevent, pdim[1]), nrow = pdim[1], byrow = T) - x[,index])
    dif = rowSums(matrix(rep(weightevent, pdim[1]), nrow = pdim[1], byrow = T) * dif)
    }else if (typedist==1){
      dif = (matrix(rep(reduceDataevent, pdim[1]), nrow = pdim[1], byrow = T) - x[,index])^2
      dif = sqrt(rowSums(matrix(rep(weightevent, pdim[1]), nrow = pdim[1], byrow = T) * dif)) 
    }
    
    c(which.min(dif), min(dif[idv]))
  })

  #print(dmanhattan)
  dmanhattan = matrix(unlist(dmanhattan), ncol = 2, byrow = T)
  idlist = which.min(dmanhattan[,2])
  mlist  = dmanhattan[idlist,1]
 
  
  return(list(idlist = idlist, mlist = mlist))
  
}