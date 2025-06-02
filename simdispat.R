simdispat = function(data,nx,xmn,xsiz,ny,ymn,ysiz,nz,zmn,zsiz,
                  nxyz,trainfl,nxtr,nytr,nztr,ivrltr,nxytr,nxyztr,templatefl,innerPatch,
                  nmult,radius,angles,sanis,nsim,seed,nxT,nyT,nzT,
                  w1,w2,w3,typedata,typedist, dbtol,patpercent){
  

# comienzo de lectura de datos
  if(!missing(data)){
    ixl=1
    iyl=2
    izl=3
    ivr=4
    vr = data[,ivr]
  } else {
    x=numeric(0)
    y=numeric(0)
    z=numeric(0)
    ivrl=numeric(0)
    
  }
    
# Read the data if the file exists:
  nd = 0
  ivrl = 0
  if(!is.null(data)){
    nvar = dim(data)[1]
    x = matrix(0, nvar, 1)
    y = matrix(0, nvar, 1)
    z = matrix(0, nvar, 1)
    ivrl = matrix(0, nvar, 1)
    
    # Eliminando bucles inecesarios
    nd = length(data[,1])
    x  = data[,1]
    y  = data[,2]
    z  = data[,3]
    ivrl = data[,4]
    nodcut = c(sum(ivrl==0), sum(ivrl==1))
    sampdf = c(sum(ivrl==0)/nd, sum(ivrl==1)/nd) 
    
  }
  
  
  
# Estandarizando los datos/imagen de treinamento continuos o categoricos: 
# si 1 - continuos, 0 - categoricos
  if(typedata==1){
    trainim = trainim
  }else{
    #ivrl = ivrl/max(ivrl)
    #trainim = trainim-min(trainim)/(max(trainim)-min(trainim))
  }

#Read the file defining the data template if it exists:
#Read all the data locations until the end of the training file:
# nltemplate: number of data locations in the template.

  nltemplate = 0  
  nvari = max(dim(templatefl)) #Max. dimension of Templatef
  ixtemplate = numeric(nvari)
  iytemplate = numeric(nvari)
  iztemplate = numeric(nvari)
 

# Intentaremos eliminar bucles inescesarios
  ixtemplate = floor(templatefl[,1])
  iytemplate = floor(templatefl[,2])
  iztemplate = floor(templatefl[,3])

  nltemplate = length(ixtemplate)

#for (i in 1:nvari){
#  nltemplate = nltemplate+1
#  if (nltemplate > MAXNOD){
#    break
#  }
  
#  ixtemplate[nltemplate] = floor(templatefl[i,1])
#  iytemplate[nltemplate] = floor(templatefl[i,2])
#  iztemplate[nltemplate] = floor(templatefl[i,3])
  
  
#}
rea = matrix(-99,nrow = nxyz,ncol = nsim)
#--------------------------------------------------------------------------
  set.seed(seed)
  seedpath = ceiling(1e7*runif(nsim*nmult))
  seedmultp = 0
  
  for(isim in 1:nsim){
    
    simim   = array(-99,dim = c(nx,ny,nz))    # Inicializa la simulaci?n
    frozsim = array(-99, dim = c(nx,ny,nz))   # Almacenando los nodos congelados
    
    #if(length(ivrl)>1){
      #print(y)
    #  results = RelocateData(nd,x,y,z,ivrl,nx,ny,nz,xmn,ymn,zmn,
    #                         xsiz,ysiz,zsiz,simim,frozsim)
      
    #  simim = results$simim
    #  frozsim = results$frozsim
    #}

    
    
    
    imult = nmult
    while (imult > 0){
      
# Reinicializando frozsim
      #frozsim = array(-99, dim = c(nx,ny,nz))   # Inicializa los nodos congelados
      
# Coarse multiple grid:
      ncoarse = 2^(imult-1)
      nxcoarse = floor(max(1,(nx-1)/ncoarse+1))
      nycoarse = floor(max(1,(ny-1)/ncoarse+1))
      nzcoarse = floor(max(1,(nz-1)/ncoarse+1))
      nxycoarse = nxcoarse*nycoarse
      nxyzcoarse = nxycoarse*nzcoarse
     
      
# Expandiendo el template si imult>1
      ixnode = ncoarse*ixtemplate
      iynode = ncoarse*iytemplate
      iznode = ncoarse*iztemplate

     
# Construyendo la base de patrones para cada correspondiente multiple grid:  
      
      seedmultp = seedmultp + 1
      results   = PatterBase(trainim,ixnode,iynode,iznode,
                             nltemplate,nxT,nyT,nzT,ncoarse,dbtol,patpercent, seedmultp)
      patterns = results$patterns
      write.table(patterns[[1]], file = 'patrones.csv', sep = ',', row.names = F,
                  col.names = T)
      Sys.sleep(101)
      npdb     = results$npdb   # Numero de patrones en la base de datos
  #print(patterns)
  #print(npdb)
# Retribuyendo los datos muestreados a cada correspondiente multiple grid:
      ncoarsest = c(ncoarse,nxcoarse,nycoarse,nzcoarse,nxycoarse,nxyzcoarse)
      results   = AssignData(simim,frozsim,ncoarsest,nd,x,y,z,ivrl,
                             xmn,ymn,zmn,xsiz,ysiz,zsiz)
      simim   = results$simim
      frozsim = results$frozsim
      
      
# Realizando la simulacion para cada nodo dentro del camino aleatorio:
      
      # RandomPath esta realizada
      idseed = imult + (isim-1)*nmult
      set.seed(seedpath[idseed]) 
      orderpath = sample(seq(1,nxyzcoarse), size = nxyzcoarse, replace = FALSE)
    
      #print(idseed)
      #print(orderpath)
    
      # SimulationPath
      seedpattern = seedpath[idseed]
      simdispat = SimulationPath(simim, frozsim, patterns, npdb, ncoarsest, orderpath, 
                             ixnode, iynode, iznode, nltemplate, nx, ny, nz, innerPatch,
                             seedpattern, w1, w2, w3, dbtol)
      #simim = results$simim
      #frozsim = results$frozsim
      
      imult = imult - 1
        
    } # Final de While
    #Sys.sleep(5)
    rea[,isim]=matrix(simim, ncol =1) #donde inicia la (simim) simulaci?n

  } # Final del for
  
  return(rea)

} # Final de la funcion

