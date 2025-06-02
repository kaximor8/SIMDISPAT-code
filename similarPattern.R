similarPattern = function(dataevent, weightevent, patterns, npdb, nltemplate,
                          seedpattern, dbtol, typedist){
  
# Chequenado si existe cualquier dato de evento condicional o no y encuentre
# el patron para ser pegado o pasado a la grid a ser simulado
  dif = sum(dataevent>=0)
  pattern = rep(0, length(dataevent))
  rindx = 1
  

# Si dif: 0-non dataevent, nltemplate-total dataevent, > 0 < nltemplate algunos
  if(dif==0){
    seedpattern = seedpattern + 1
    set.seed(seedpattern)
    
# No hay datos condicionantes en el dataevent, 
# entonces seleccione uno de forma aleatoria
    randidx = sample(seq(1, npdb), 1)

   #print(randidx)
# Busqueda del indice en la lista de patrones
    psequence = c(seq(0, npdb-0.5, dbtol), npdb)

    for (i in 1:(length(psequence)-1))   {
     # print(i)
      if(psequence[i+1]>=randidx & psequence[i]<randidx) break
      #print( psequence[i+1])
    }
    
# Recalculando el index
    randidx = randidx - (i-1)* dbtol
    pattern = patterns[[i]][randidx,]
    rindx = 1
    #print(randidx)
  
  }else if(dif==nltemplate){
# dataevent contiene todos los datos condicionantes
    seedpattern = seedpattern + 1
    results = disDistance(dataevent, weightevent, patterns, seedpattern, typedist)
    pattern    = patterns[[results$idlist]][results$mlist, ]
    
  }else{
# dataevent: contiene alguno de los datos condicionantes
    #seedpattern = seedpattern + 1
    results = disDistance(dataevent, weightevent, patterns, seedpattern, typedist)
    pattern    = patterns[[results$idlist]][results$mlist, ]
    
  }
  
# retornando el patron mas similar
 
  return(list(pattern = pattern, rindx = rindx, seedpattern = seedpattern))
  
}