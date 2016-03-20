#Ruby file to convert ECCF vectors to ENU vector 
#

require 'matrix'
require 'math'

@refLamba = -114.130981
@refPhi   = 51.080609

transForm  = Matrix.build(3,3)
eccFvector = Matrix.build(3,1)
enuResult  = Matrix.build(3,1)

























def matrixUpdate(matrixData)

#(i,j) = ith row and jth col
  #
  matrixData.component(1,1) = -1 *(sin(refLamba))
  matrixData.component(2,1) = -1 *(cos(refLamba) *sin (refLamba))
  matrixData.component(3,1) =  (cos(refLamba))*(cos(refPhi))


  matrixData.component(1,2) = cos(refLamba)
  matrixData.component(2,2) = -1*(sin(refLamba) * sin(refPhi))
  matrixData.component(3,2) = sin(refLamba) * cos(refPhi)

  matrixData.component(1,3) = 0
  matrixData.component(2,3) = cos(refPhi)
  matrixData.component(3,3) = sin(refPhi)
end
