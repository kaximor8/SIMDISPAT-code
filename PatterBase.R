PatterBase = function(trainim,ixnode,iynode,iznode,nltemplate,
                   nxT,nyT,nzT,ncoarse,dbtol,patpercent,seedmultp){


# Definiendo parametros
  nxtr = dim(trainim)[1] 
  nytr = dim(trainim)[2] 
  nztr = dim(trainim)[3]
  nxTc = (nxT - 1)*ncoarse
  nyTc = (nyT - 1)*ncoarse
  nzTc = (nzT - 1)*ncoarse
  imdx = ((nxT-1)*ncoarse)/2
  imdy = ((nyT-1)*ncoarse)/2
  imdz = ((nzT-1)*ncoarse)/2

  
# Coordenadas centrales de cada patron dentro de la imagen de entrenamiento
  xsc = rep(seq(1+imdx, nxtr-imdx), (nytr - nyTc)*(nztr - nzTc))
  ysc = rep(seq(1+imdy, nytr-imdy), each = (nxtr - nxTc)*(nztr - nzTc))
  zsc = rep(seq(1+imdz, nztr-imdz), each = (nxtr - nxTc)*(nytr - nyTc))
  cpatterns = matrix(c(xsc,ysc,zsc), ncol = 3)


# Numero de patrones
  ntpatterns = (nxtr - nxTc)*(nytr - nyTc)*(nztr - nzTc)
 
#print(ntpatterns)
 
# Muestreo aleatorio simples sobre la imagen de entrenamiento
  set.seed(seedmultp)
  idp = sample(1:ntpatterns, size = floor(ntpatterns*patpercent), replace = F)
  ntpatterns = floor(ntpatterns*patpercent)
  
    #patterns  = matrix(NA, nrow = ntpatterns, ncol = nltemplate)
  npatterns = 0
  cpatterns = cpatterns[idp,]

  
# Loop sobre los nodos centrales de cada patron de la TI
  npatterns = length(idp)
  patterns  = matrix(NA, nrow = npatterns, ncol = nltemplate)
  count = 0
 
  
  for (ip in 1:npatterns) {
    ix = cpatterns[ip,1]
    iy = cpatterns[ip,2]
    iz = cpatterns[ip,3]
    #print(ix)
    #print(cpatterns)
    results = ScanTemplate(trainim, nxtr, nytr, nztr, ix, iy, iz,
                           ixnode, iynode, iznode, nltemplate)
   
    
    if(results$cont==nltemplate && count<=ntpatterns){
      count = count + 1
     
      
# Salida de la funcion
      if(count>ntpatterns) next
      
# Definicion de la base de patrones
      patterns[count,] = results$pattern
    
    }
    
  }
  

  #print(count)
  #print(ntpatterns)
  #Sys.sleep(101)
  
# Particionando la base de patrones
  patternsbase = list()
  
  psequence = c(seq(0,length(patterns[,1])-0.5, dbtol), length(patterns[,1]))
  
 
  for (i in 1:(length(psequence)-1)) {
    index = seq(psequence[i]+1,psequence[i+1])
    patternsbase[[i]] = matrix(patterns[index,], nrow = length(index))
   # print( patternsbase[[i]] )
  }
 
 #write.table(patterns, file = "datapatterns.csv", sep = ";", row.names = T, col.names = F)
 #Sys.sleep(101)
  return(list(patterns = patternsbase, npdb = ntpatterns))
  
}
