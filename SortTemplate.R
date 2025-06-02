SortTemplate = function(nltemplate,ixtemplate,iytemplate,iztemplate,angles,sanis){
#----------------------------------------------------------------------------------  
  
  #Ordenar ubicaciones de los datos del template,
  #Esta subrutina ordena las ubicaciones del template de los datos 
  #(utilizada para construir los árboles de búsqueda) de acuerdo con 
  #la distancia anisotrópica correspondiente a la elipse de búsqueda. 
  #Por lo tanto, los datos de condicionamiento se buscan más adelante 
  #en orden de cercanía según esa distancia.
#----------------------------------------------------------------------------------
  
  rotmat = SetRotMat(1,angles,sanis)
  tpm = numeric(nltemplate)
  for (ind in 1:nltemplate){
    xx = ixtemplate[ind]
    yy = iytemplate[ind]
    zz = iztemplate[ind]
  
    hsqd = 0
    for (n in 1:3){
      cont = rotmat[n,1]*xx+rotmat[n,2]*yy+rotmat[n,3]*zz
      hsqd = hsqd+cont*cont
    }
    tpm[ind] = hsqd
  }
  
  tm=sort(tpm,index.return=TRUE)
  tmp=tm$x; I=tm$ix

  ixtemplate = ixtemplate[I]
  iytemplate = iytemplate[I]
  iztemplate = iztemplate[I]
  
  return(list(ixtemplate = ixtemplate,iytemplate = iytemplate,iztemplate = iztemplate))
}
