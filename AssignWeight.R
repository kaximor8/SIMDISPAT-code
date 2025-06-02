AssignWeight = function(datafroze, nltemplate, w1, w2, w3){
  
# Asignando pesos a los datos brutos (0.5), inner patch (0.3) y 0.2 a los restantes
  weightevent = rep(w3, nltemplate)
  #print(datafroze)
  #Sys.sleep(10)
  weightevent[datafroze==1] = w2
  weightevent[datafroze==2] = w1

  return(weightevent)

}