RelocateData = function(nd,x,y,z,vr,nx,ny,nz,xmn,ymn,zmn,xsiz,ysiz,zsiz,
                        simim,frozsim){
  
  for (id in 1:nd){
    ix = getindx(nx,xmn,xsiz,x[id])
    iy = getindx(ny,ymn,ysiz,y[id])
    iz = getindx(nz,zmn,zsiz,z[id])
    xx = xmn+(ix-1)*xsiz
    yy = ymn+(iy-1)*ysiz
    zz = zmn+(iz-1)*zsiz
    test = abs(xx-x[id])+abs(yy-y[id])+abs(zz-z[id])
    
    if (simim[ix,iy,iz]>0){
      id2 = simim[ix,iy,iz]
      test2 = abs(xx-x[id2])+abs(yy-y[id2])+abs(zz-z[id2])
      if (test<test2){
        simim[ix,iy,iz] = id
      } 
      
    } else{
      simim[ix,iy,iz] = id
    } #final de else
    
  } #final del for
  
  #nodcut=numeric(ncut)
  #vertnodcut=matrix(0, nrow = nz, ncol = ncut)
  
  for (iz in 1:nz){
    for (iy in 1:ny){
      for (ix in 1:nx){
        id = simim[ix,iy,iz]            
        if (id > 0){
          simim[ix,iy,iz] = vr[id]
          #nodcut[simim[ix,iy,iz]] = nodcut[simim[ix,iy,iz]]+1
          #if (ivertprop == 1){
          #  vertnodcut[iz,simim[ix,iy,iz]] = vertnodcut[iz,simim[ix,iy,iz]] + 1
          #}
        }
      }
    }
  }
  
  frozsim[simim>=0] = 2
  
  return(list(simim = simim, frozsim = frozsim))
}
