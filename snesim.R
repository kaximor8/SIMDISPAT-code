snesim = function(data,nx,xmn,xsiz,ny,ymn,ysiz,nz,zmn,zsiz,
                  nxyz,trainfl,nxtr,nytr,nztr,ivrltr,nxytr,nxyztr,templatefl,innerPatch,
                  nmult,radius,angles,sanis,nsim,seed,nxT,nyT,nzT,
                  w1,w2,w3,typedata,typedist, dbtol,patpercent){
  
# comienzo de la funcion snesim.
    #----------------------------------------------------------------------
    #Maximun number of categories (classes of values)
    #MAXCUT = 2
    
    #Maximun dimensions of the simulation grid
    #MAXX = 300; MAXY = 300; MAXZ = 20
    
    #Maximun dimensions of the training image
    #MAXXTR = 250; MAXYTR = 250; MAXZTR = 20
    
    #Maximun dimensions of the data search neighborhood (odd numbers)
    #MAXCTX = 71; MAXCTY = 71; MAXCTZ = 21
    
    #-----------------------------------------------------------------------
    #MAXXY = MAXX*MAXY; MAXXYTR = MAXXTR*MAXYTR
    #MAXXYZ = MAXXY*MAXZ
    #MAXXYZTR = MAXXYTR*MAXZTR
    #MAXCTXY = MAXCTX*MAXCTY
    #MAXCTXYZ = MAXCTXY*MAXCTZ
    #-----------------------------------------------------------------------
    # Maximun number of original sample data
    #MAXDAT = 100000
    
    #Maximun number of conditioning nodes
    #MAXNOD = 100
    
    #Maximun number of multiple grids
    #MAXMULT = 5
    
    #Minimun correction factor in the servosystem (if used)
    #MINCOR = 1.0
    
    #-----------------------------------------------------------------------
    #EPSILON = 1.0E-20; UNEST = -99
    
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
  
  #for(i in 1:nvar){
  #  nd = nd + 1
  #  if(nd > MAXDAT) break;
    
  #  for(icut in 1:ncut){
  #    if(vr[i]==thres[icut]){
  #      nodcut[icut]= nodcut[icut]+1
  #      ivrl[nd]=icut
  #    }
  #  }
    
  #  x[nd] = xmn
  #  y[nd] = ymn
  #  z[nd] = zmn
  #  if (ixl > 0){ 
  #    x[nd] = data[i,ixl]
  #  }
  #  if (iyl>0){
  #    y[nd]= data[i,iyl]
      
  #  }
  #  if (izl>0){
  #    z[nd]= data[i,izl]
  #  }
  #} # final del for nvar
  
  #print(nodcut)
  #print(nd)

  #sampdf = matrix(0,1,ncut)
  #if (nd > 0){
  #  sampdf = (nodcut[1:ncut])/nd
  #}

# Read the training images if the files exist:
  ntr = 0
  nvari = dim(trainfl)[1]
  ntr = nvari
#  trpdf = numeric(ncut)
  trainim = array(ivrltr, dim=c(nxtr,nytr,nztr)) #Genera una variable indexada 250?250x1
  
#  for(i in 1:nvari){
#    ntr = ntr+1
#    if (ntr > nxyztr){
#      break
#    }
#    
#    iz = 1 + floor((ntr-1)/nxytr)
#    iy = 1 + floor((ntr-(iz-1)*nxytr-1 )/nxtr)
#    ix = ntr-(iz-1)*nxytr-(iy-1)*nxtr
#    
#    for (icut in  1:ncut){
#      if (ivrltr[i] == thres[icut]) {               
#        trainim[ix,iy,iz] = icut-1
#        trpdf[icut] = trpdf[icut]+1
#      }
#    }
#  }

#Calculate the correction parameter of the servosystem:

#  trpdf = trpdf/nxyztr
#  if (iservo==1)   {                                                         
#    servocor = max((max(100*abs(trpdf-pdf))/MINCOR)^servo,1.5)
#  }else{
#    servocor = 0
#  }
  
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
      simim = SimulationPath(simim, frozsim, patterns, npdb, ncoarsest, orderpath, 
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

