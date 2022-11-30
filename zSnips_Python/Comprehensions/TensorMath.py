
#----------------------------------------------------------
# ADDITION

# The element-wise addition of two tensors with the same dimensions 
# results in a new tensor with the same dimensions where each scalar 
# value is the element-wise addition of the scalars in the parent tensors

from numpy import array
A = array([
  [[1,2,3],    [4,5,6],    [7,8,9]],
  [[11,12,13], [14,15,16], [17,18,19]],
  [[21,22,23], [24,25,26], [27,28,29]],
  ])
B = array([
  [[1,2,3],    [4,5,6],    [7,8,9]],
  [[11,12,13], [14,15,16], [17,18,19]],
  [[21,22,23], [24,25,26], [27,28,29]],
  ])
C = A + B

print(C)


#----------------------------------------------------------
# SUBTRACTION

# The element-wise subtraction of one tensor from another tensor with the 
# same dimensions results in a new tensor with the same dimensions where 
# each scalar value is the element-wise subtraction of the scalars in the 
# parent tensors.

from numpy import array
A = array([
  [[1,2,3],    [4,5,6],    [7,8,9]],
  [[11,12,13], [14,15,16], [17,18,19]],
  [[21,22,23], [24,25,26], [27,28,29]],
  ])

B = array([
  [[1,2,3],    [4,5,6],    [7,8,9]],
  [[11,12,13], [14,15,16], [17,18,19]],
  [[21,22,23], [24,25,26], [27,28,29]],
  ])
C = A - B

print(C)


#----------------------------------------------------------
# TENSOR HADAMARD PRODUCT

# The element-wise multiplication of one tensor from another tensor with 
# the same dimensions results in a new tensor with the same dimensions 
# where each scalar value is the element-wise multiplication of the scalars 
# in the parent tensors.

# As with matrices, the operation is referred to as the Hadamard Product to 
# differentiate it from tensor multiplication. Here, we will use the “o” operator 
# to indicate the Hadamard product operation between tensors.

from numpy import array
A = array([
  [[1,2,3],    [4,5,6],    [7,8,9]],
  [[11,12,13], [14,15,16], [17,18,19]],
  [[21,22,23], [24,25,26], [27,28,29]],
  ])

B = array([
  [[1,2,3],    [4,5,6],    [7,8,9]],
  [[11,12,13], [14,15,16], [17,18,19]],
  [[21,22,23], [24,25,26], [27,28,29]],
  ])

C = A * B
print(C)


#----------------------------------------------------------
# TENSOR DIVISION

# The element-wise division of one tensor from another tensor with the same 
# dimensions results in a new tensor with the same dimensions where each 
# scalar value is the element-wise division of the scalars in the parent 
# tensors.

from numpy import array
A = array([
  [[1,2,3],    [4,5,6],    [7,8,9]],
  [[11,12,13], [14,15,16], [17,18,19]],
  [[21,22,23], [24,25,26], [27,28,29]],
  ])

B = array([
  [[1,2,3],    [4,5,6],    [7,8,9]],
  [[11,12,13], [14,15,16], [17,18,19]],
  [[21,22,23], [24,25,26], [27,28,29]],
  ])

C = A / B

print(C)


#----------------------------------------------------------
# TENSOR PRODUCT

The tensor product operator is often denoted as a circle with a 
# small x in the middle. We will denote it here as “(x)”.

# Given a tensor A with q dimensions and tensor B with r dimensions, 
# the product of these tensors will be a new tensor with the order of 
# q + r or, said another way, q + r dimensions.

The tensor product is not limited to tensors, but can also be performed 
# on matrices and vectors, which can be a good place to practice in 
# order to develop the intuition for higher dimensions.

rom numpy import array
from numpy import tensordot

A = array([1,2])

B = array([3,4])

C = tensordot(A, B, axes=0)

print(C)
