 UpdateTree = function(stree,trainim,ix,iy,iz,ccut,node,ncut,numbernode,nodes,ndtemp,ct){
   
   #Actualizar el arbol de busqueda
   #Esta subrutina recursiva actualiza el arbol de busqueda 'stree' para los cpdfs escaneados en la
   #ubicacion de entrenamiento (ix, iy, iz) al visitar recursivamente todas las ubicaciones de la 
   #plantilla de datos centradas en (ix, iy, iz).
   
   ixnode = node[1,]
   iynode = node[2,]
   iznode = node[3,]
   
   #Primero, calcule las coordenadas de la ubicación actualmente visitada en el template de datos
   ixh = ix+ixnode
   iyh = iy+iynode
   izh = iz+iznode
   
   ndtemp = length(ixnode)
   I= numeric(ndtemp)
   

   for (In in 1:ndtemp){
     I[In] = trainim[ixh[In],iyh[In],izh[In]] #cambie la letra (i)---- por la mayucuscula(I)
   }

   icd = length(I)
   v = rev(sort(1:icd)-1)
   ncin = ncut^((1:icd)-1)
   
   
   for (i in 0:(icd-1)){
     p = 0    
     p=sum((ncut^v[(1+i):length(v)]) * (I[1:(length(I)-i)]-1)+ ncin[1:(length(ncin)-i)])
     ind = which(nodes==p)
     #print(p)
     #print(v)
     #print(I)
     #print(ncut)
     #print(ind)
     #Sys.sleep(100)
     
     numbernode=0
     if(missing(ind)){
       numbernode = numbernode + 1
       nodes[numbernode] = p
       
       stree[numbernode,] = 0
       stree[numbernode,ccut] = stree[numbernode,ccut] + 1
       ct[numbernode,] = I
       
       
     } else {
       stree[ind,ccut] = stree[ind,ccut] + 1
     }
     
     
   }
   
   
   
   
   
   return(list(stree=stree,nodes= nodes,numbernode=numbernode,ct=ct))
 }

 
