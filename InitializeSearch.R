
InitializeSearch = function (nx,ny,nz,xsiz,ysiz,zsiz,
                             MAXCTX,MAXCTY,MAXCTZ,MAXCTXY,
                             radius,angles,sanis,imult){
  
#Establecer una búsqueda de nodos cercanos en orden de cercanía.
  
  # Configurar la matriz de rotación para calcular distancias 
  # anisotrópicas para la búsqueda de datos de condicionamiento
  
    # Definición de los parámetros
  
  rotmat = SetRotMat(imult,angles,sanis)
 
  radsqd = radius[1]*radius[1]
  
  #Size of the data search neighborhood
  
  nctx = min( (MAXCTX-1)/2, (nx-1) )
  ncty = min( (MAXCTY-1)/2, (ny-1) )
  nctz = min( (MAXCTZ-1)/2, (nz-1) )
    
   # Configure la tabla de distancias a lo desconocido y realice un seguimiento de 
   # las compensaciones de nodo que se encuentran dentro del radio de búsqueda:
  nlsearch = 0
  for (i in -nctx:nctx){
    xx = i*xsiz
    ic = nctx + 1 +i
    for(j in -ncty:ncty){
      yy = j*ysiz
      jc = ncty + 1 + j
      for (k in -nctz:nctz){
        zz = k*zsiz
        kc = nctz + 1 + k
        
        #Calcula la distancia anisotrópica:
        
        hsqd = 0
        for(n in 1:3){
          cont = rotmat[n,1]*xx+rotmat[n,2]*yy+rotmat[n,3]*zz
          hsqd = hsqd+cont*cont
        }
        if (hsqd <= radsqd){
          nlsearch = nlsearch + 1
          tmp[nlsearch] = hsqd
          ordercd[nlsearch] = (kc-1)*MAXCTXY+(jc-1)*MAXCTX+ic
        }
      }
    }
  }
  
  return(list(nlsearch,ixnode,iynode,iznode))
  
  
}
