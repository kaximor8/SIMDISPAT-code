AssignData= function(simim,frozsim,ncoarsest,nd,x,y,z,ivrl,xmn,ymn,zmn,
                     xsiz,ysiz,zsiz){
#--------------------------------------------------------------------------
  #Esta subrutina asigna los datos de muestra originales a los nodos 
  #más cercanos de la cuadrícula múltiple que se simularán.
#--------------------------------------------------------------------------  
  
  
  if(nd==0) return(list(simim = simim, frozsim = frozsim))
  
  # Definir parametros
  vr=ivrl
  UNEST=-99
  
  # Modificacion de posicion 
  ncoarse =  ncoarsest[1]
  nxcoarse = ncoarsest[2]
  nycoarse = ncoarsest[3]
  nzcoarse = ncoarsest[4]
  
  # Definir especificaciones para la cuadrícula múltiple actual:


  xmncoarse = xmn
  ymncoarse = ymn
  zmncoarse = zmn
  xsizcoarse = xsiz*ncoarse
  ysizcoarse = ysiz*ncoarse
  zsizcoarse = zsiz*ncoarse
  simtemp=array(UNEST,dim = c(nxcoarse,nycoarse,nzcoarse))

    # Recorrer todos los datos de muestra originales
  
  for(id in 1:nd){
    
    # Calcula las coordenadas del nodo de cuadrícula de simulación más cercano
    
    ix = getindx(nxcoarse,xmncoarse,xsizcoarse,x[id])
    iy = getindx(nycoarse,ymncoarse,ysizcoarse,y[id])
    iz = getindx(nzcoarse,zmncoarse,zsizcoarse,z[id])
    xx = xmncoarse + (ix-1)*xsizcoarse
    yy = ymncoarse + (iy-1)*ysizcoarse
    zz = zmncoarse + (iz-1)*zsizcoarse
    test = abs(xx-x[id]) + abs(yy-y[id]) + abs(zz-z[id])

   # Asigne estos datos al nodo (a menos que haya datos más cercanos)
    
    if(simtemp[ix,iy,iz]>0){
      id2 = simtemp[ix,iy,iz]
      test2 = abs(xx-x[id2])+abs(yy-y[id2])+abs(zz-z[id2])
      
      if(test< test2){
        simtemp[ix,iy,iz]=id
     
        
      } #final del if(test)
      
    } else {
      simtemp[ix,iy,iz] = id
     
    }#final del else
    
 } #final del for(id)
  
  for (iz in 1:nzcoarse) {
    for (iy in 1:nycoarse) {
      for (ix in 1:nxcoarse) {
        id= simtemp[ix,iy,iz]
      
        if(id>0){
          jz = (iz-1)*ncoarse+1
          jy = (iy-1)*ncoarse+1
          jx = (ix-1)*ncoarse+1
         
           
          #if(simim[jx,jy,jz]>0){
          #  nodcut[simim[jx,jy,jz]]= nodcut[simim[jx,jy,jz]]-1
          #  if(ivertprop==1){
          #    vertnodcut[jz,simim[jx,jy,jz]] = vertnodcut[jz,simim[jx,jy,jz]] - 1
          #    
          #  } #final del if(iver)
          #  
          #} #final del if(simim)
          
          simim[jx,jy,jz] = vr[id]
          
          # Congelando valores asignados
          
          if(frozsim[jx,jy,jz]!=1){
            frozsim[jx,jy,jz] = 2  
            
          }
          
          #nodcut[simim[jx,jy,jz]] = nodcut[simim[jx,jy,jz]]+1
          #if (ivertprop==1){
          #  vertnodcut[jz,simim[jx,jy,jz]] = vertnodcut[jz,simim[jx,jy,jz]]+1
          #}
          #numcd[jx,jy,jz] = 10*UNEST
          
          
        } #final del if(id)
        
      } #final del for(ix)
      
    } #final del for(iy)
    
  } #final del for(iz)
  
  
  
  return(list(simim = simim, frozsim = frozsim))
  
}