
SetRotMat = function (imult,angles,sanis){

#Convers the input angles to three angles which make more mathematical sense:
  
#Definition of the parameters
sang1 = angles[1]
sang2 = angles[2]
sang3 = angles[3]
sanis1 = sanis[1]
sanis2 = sanis[2]
deg2rad = pi/180
EPSILON = 1.0e-20

if(sang1[imult] >= 0 && sang1[imult] < 270){
  alpha = (90-sang1[imult])*deg2rad
  }else{
    alpha = (450-sang1[imult])*deg2rad
  }
  
beta = -1*sang2[imult]*deg2rad
theta = sang3[imult]*deg2rad
  


#Get the required sines and cosines:
  
sina = sin(alpha)
sinb = sin(beta)
sint = sin(theta)
cosa = cos(alpha)
cosb = cos(beta)
cost = cos(theta)

#Construir la matriz de rotación en la memoria requerida:
afac1 = 1/max(sanis1[imult],EPSILON)
afac2 = 1/max(sanis2[imult],EPSILON)
rotmat = matrix(0,nrow =3, ncol = 3)
rotmat[1,1] = cosb*cosa
rotmat[1,2] = cosb*sina
rotmat[1,3] = -sinb
rotmat[2,1] = afac1*(-cost*sina + sint*sinb*cosa)
rotmat[2,2] = afac1*(cost*cosa + sint*sinb*cosa)
rotmat[2,3] = afac1*(sint*cosb)
rotmat[3,1] = afac2*(sint*sina + cost*sinb*cosa)
rotmat[3,2] = afac2*(-sint*cosa + cost*sinb*sina)
rotmat[3,3] = afac2*(cost*cosb)
  
return(rotmat)

}

