getindx= function(n,min,siz,loc){

  index = fix( (loc-min)/siz + 1.5 )
  
  if (index < 1){
    index = 1
  }else if (index > n){
    index = n
  } else {
    index = index
  }     
  return( index)
} # final de getindx
