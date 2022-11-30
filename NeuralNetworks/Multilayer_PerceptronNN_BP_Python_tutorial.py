# -*- coding: utf-8 -*-
# We will randomly define initial values for connection weights, and also randomly select
#   which training data that we will use for a given run.
import random

# We want to use the exp function (e to the x); it's part of our transfer function definition
from math import exp

# Biting the bullet and starting to use NumPy for arrays
import numpy as np

# debug near line 583 - deltas did not get the mirror image fix


####################################################################################################
####################################################################################################
#
# This is a tutorial program, designed for those who are learning Python, and specifically using 
#   Python for neural networks applications
#
# SPECIAL NOTE re/ Python code structure: 
# Python uses a 'main' module, which is typically located at the end of the code. 
# There is a short line after that which actual RUNS the 'main' module. 
# All supporting tasks are defined as various procedures and functions. They are stored higher in 
#   the code. 
# Typically, the most general and global procedures and functions are at the bottom of the code, and
#   the more detail-specific ones are at the top. 
# Thus, if you want to understand a piece of code, you might want to read from bottom-to-top (or
#    from more general-to-specific), instead of top-to-bottom (detailed-specific-to-general).
#
# Notice that control (e.g., nesting) is defined by spacing. 
# You can define the number of spaces for a tab, but you have to be consistent. 
# Notice that once a procedure is defined, every command within it must be tabbed in.  
#
####################################################################################################
####################################################################################################


####################################################################################################
####################################################################################################
#
# Procedure to welcome the user and identify the code
#
####################################################################################################
####################################################################################################

# This procedure is called from the 'main' program.
# Notice that it has an empty parameter list. 
# Procedures require a parameter list, but it can be empty. 

def welcome ():


    print
    print ('******************************************************************************')
    print
    print ('Welcome to the Multilayer Perceptron Neural Network')
    print ('  trained using the backpropagation method.')
    print ('Version 0.2, 01/10/2017, A.J. Maren')
    print ('For comments, questions, or bug-fixes, contact: alianna.maren@northwestern.edu')
    print
    print ('******************************************************************************')
    print
    return()

# The above 'return()' statement takes us back to the 'main' module. There have been no parameters
#   defined in this procedure, there is nothing new to return, so the list is still empty.         

####################################################################################################
####################################################################################################
#
# A collection of worker-functions, designed to do specific small tasks
#
####################################################################################################
####################################################################################################

   
#------------------------------------------------------#    

# Compute neuron activation using sigmoid transfer function
def computeTransferFnctn(summedNeuronInput, alpha):
    activation = 1.0 / (1.0 + exp(-alpha*summedNeuronInput)) 
    return activation   

#------------------------------------------------------# 
    
# Compute derivative of transfer function
def computeTransferFnctnDeriv(NeuronOutput, alpha):
    return alpha*NeuronOutput*(1.0 -NeuronOutput)     



####################################################################################################
####################################################################################################
#
# Procedure to obtain the neural network size specifications
#
####################################################################################################
####################################################################################################

def obtainNeuralNetworkSizeSpecs ():

# This procedure operates as a function, as it returns a single value (which really is a list of 
#    three values). It is called directly from 'main.'
#        
# This procedure allows the user to specify the size of the input (I), hidden (H), 
#    and output (O) layers.  
# These values will be stored in a list, the arraySizeList. 
# This list will be used to specify the sizes of two different weight arrays:
#   - wWeights; the Input-to-Hidden array, and
#   - vWeights; the Hidden-to-Output array. 
# However, even though we're calling this procedure, we will still hard-code the array sizes for now. 

#    print 'Define the numbers of input, hidden, and output nodes' 
          
#    x = input('Enter the number of input nodes here: ')
#    numInputNodes = int(x)
#    print 'The number of input nodes you have entered is', numInputNodes 
#    print 'Thank you; the number of input nodes that will be used is temporarilly hard-coded to 2.' 
#    print #to get a line space between requests
                
#    x = input('Enter the number of hidden nodes here: ')
    # Notice that we are re-using the variable x; it can be reused because it is just catching the 
    #    user's input and then the real variable of interest is defined using it. 
    # Notice that by specifying 'int(x)', we make sure that whatever we catch from the user is 
    #    stored as an integer, not as a float or a string variable.     
#    numHiddenNodes = int(x)
#    print 'The number of hidden nodes you have entered is', numInputNodes 
#    print 'Thank you; the number of hidden nodes that will be used is temporarilly hard-coded to 2.' 
#    print #to get a line space between requests   
        
#    x = input('Enter the number of output nodes here: ')
#    numOutputNodes = int(x)
#    print 'The number of output nodes you have entered is', numInputNodes 
#    print 'Thank you; the number of output nodes that will be used is temporarilly hard-coded to 2.' 
#    print #to get a line space between requests    

    numInputNodes = 2
    numHiddenNodes = 2
    numOutputNodes = 2   
    print (' ')
    print ('This network is set up to run the X-OR problem.')
    print ('The numbers of nodes in the input, hidden, and output layers have been set to 2 each.' )
            
# We create a list containing the crucial SIZES for the connection weight arrays                
    arraySizeList = (numInputNodes, numHiddenNodes, numOutputNodes)
    
# We return this list to the calling procedure, 'main'.       
    return (arraySizeList)  



####################################################################################################
####################################################################################################
#
# Function to initialize a specific connection weight with a randomly-generated number between 0 & 1
#
####################################################################################################
####################################################################################################

def InitializeWeight ():

    randomNum = random.random()
    weight=1-2*randomNum
#    print weight
           
    return (weight)  



####################################################################################################
####################################################################################################
#
# Procedure to initialize the connection weight arrays
#
####################################################################################################
####################################################################################################

def initializeWeightArray (weightArraySizeList, debugInitializeOff):

# This procedure is also called directly from 'main.'
#        
# This procedure takes in the two parameters, the number of nodes on the bottom (of any two layers), 
#   and the number of nodes in the layer just above it. 
#   It will use these two sizes to create a weight array.
# The weights will initially be given assigned values here, so that we can trace the creation and 
#   transfer of this array back to the 'main' procedure. 
# Later, we will randomly define initial weight values.   
# These values will be stored in an array, the weightArray. 
# This procedure is being called as a function; the returned value is the new connection weight matrix. 
# Right now, for simplicity and test purposes, the weightArray is set to a single value. 

# Note my variable-naming convention: 
#    - If it is an array, I call it variableNameArray
#    - If it is a list, I call it variableNameList
#    - It's a lot like calling your dog Roger "rogerDog"
#        and your cat Fluffy "fluffyCat"
#        but until we're better at telling cats from dogs, this helps. 
    
#    print
#    print 'Inside initializeWWeightArray' 
    
    numBottomNodes = weightArraySizeList[0]
    numUpperNodes = weightArraySizeList[1]
            
#    print 'The number of lower nodes is', numBottomNodes 
#    print 'The number of upper nodes is', numUpperNodes  
#    print ' ' #to get a line space
                  

# Initialize the weight variables with random weights
    wt00=InitializeWeight ()
    wt01=InitializeWeight ()
    wt10=InitializeWeight ()
    wt11=InitializeWeight ()    
    weightArray=np.array([[wt00,wt10],[wt01,wt11]])
    
# Debug mode: if debug is set to False, then we DO NOT do the prints
    if not debugInitializeOff:
# Print the weights
        print (' ')
        print ('  Inside initializeWeightArray')
        print ('    The weights just initialized are: ')
        print ('      weight00 = %.4f,' % wt00)
        print ('      weight01 = %.4f,' % wt01)
        print ('      weight10 = %.4f,' % wt10)
        print ('      weight11 = %.4f,' % wt11)


# The weight array is set up so that it lists the rows, and within the rows, the columns
#    wt00   wt10
#    wt10   wt11

# The sum of weighted terms should be carried out as follows: 
#   [wt 00  wt10] * [node0] = wt00*node0 + wt10*node1 = sum-weighted-nodes-to-higher-node0       
#   [wt 10  wt11] * [node1] = wt10*node0 + wt11*node1 = sum-weighted-nodes-to-higher-node1

# Notice that the weight positions are being labeled according to how Python numbers elements in an array
#    ... so the first one is in position [0,0].

# Notice that the position of the weights in the weightArray is not as would be expected:
#  Row 0, Col 1: wt00 = weight connecting 0th lower-level node to 0th upper-level node = weightArray [0,0]
#  Row 0, Col 1: wt10 = weight connecting 1st lower-level node to 0th upper-level node = weightArray [0,1]
#  Row 0, Col 1: wt01 = weight connecting 0th lower-level node to 1st upper-level node = weightArray [1,0]
#  Row 0, Col 1: wt11 = weight connecting 1st lower-level node to 1st upper-level node = weightArray [1,1]
# Notice that wt01 & wt10 are reversed from what we'd expect 

# Debug mode: if debug is set to False, then we DO NOT do the prints
    if not debugInitializeOff:
# Print the entire weights array. 
        print (' ')
        print ('    The weight Array just established is: ', weightArray)
        print (' ' )
        print ('    Within this array: ' )
        print ('      weight00 = %.4f    weight10 = %.4f' % (weightArray[0,0], weightArray[0,1]))
        print ('      weight01 = %.4f    weight11 = %.4f' % (weightArray[1,0], weightArray[1,1])  )  
        print ('  Returning to calling procedure'    )    
    
# We return the array to the calling procedure, 'main'.       
    return (weightArray)  




#------------------------------------------------------# 

# Just a few notes to myself ... on array numbering an printing ... 

# To print a specific element in the weight array; 
#   recall that Python arrays start with
#   numbering the first element as 0-position;
#   so index for an array with two elements goes from 0..1

# The following prints out the weight connecting the first input node
#   to the second hidden weight
#    print wWeightsArray[0,1]



####################################################################################################
####################################################################################################
#
# Function to initialize the bias weight arrays
#
####################################################################################################
####################################################################################################

def initializeBiasWeightArray (weightArray1DSize):

# This procedure is also called directly from 'main.'
#        
# This procedure takes in the two parameters, the number of nodes on the bottom (of any two layers), 
#   and the number of nodes in the layer just above it. 
#   It will use these two sizes to create a weight array.
# The weights will initially be given assigned values here, so that we can trace the creation and 
#   transfer of this array back to the 'main' procedure. 
# Later, we will randomly define initial weight values.   
# These values will be stored in an array, the weightArray. 
# This procedure is being called as a function; the returned value is the new connection weight matrix. 
# Right now, for simplicity and test purposes, the weightArray is set to a single value. 

# Note my variable-naming convention: 
#    - If it is an array, I call it variableNameArray
#    - If it is a list, I call it variableNameList
#    - It's a lot like calling your dog Roger "rogerDog"
#        and your cat Fluffy "fluffyCat"
#        but until we're better at telling cats from dogs, this helps. 
    
#    print
#    print 'Inside initializeWWeightArray' 

# This will be more useful when we move to array operations; right now, it is a placeholder step        
    numBiasNodes = weightArray1DSize
            
#    print 'The number of lower nodes is', numBottomNodes 
#    print 'The number of upper nodes is', numUpperNodes  
#    print ' ' #to get a line space
                  

# Initialize the weight variables with random weights
    biasWeight0=InitializeWeight ()
    biasWeight1=InitializeWeight ()
      
    biasWeightArray=np.array([biasWeight0,biasWeight1])

# Notice that the weight positions are being labeled according to how Python numbers elements in a 1-D array
#    ... so the first one is in position [0].

# Print the entire weights array. 
#    print weightArray
    
# We return the array to the calling procedure, 'main'.       
    return (biasWeightArray)  



####################################################################################################
####################################################################################################
#
# Function to obtain a randomly-selected training data set list, which will contain the two input 
#   values (each either 0 or 1), and two output values (see list below), and a third value which is 
#   the number of the training data set, in the range of (0..3). (There are a total of four training 
#   data sets.) 
#
####################################################################################################
####################################################################################################

def obtainRandomXORTrainingValues ():

   
    # The training data list will have four values for the X-OR problem:
    #   - First two valuea will be the two inputs (0 or 1 for each)
    #   - Second two values will be the two outputs (0 or 1 for each)
    # There are only four combinations of 0 and 1 for the input data
    # Thus there are four choices for training data, which we'll select on random basis
    
    # The fifth element in the list is the NUMBER of the training set; setNumber = 1..3
    # The setNumber is used to assign the Summed Squared Error (SSE) with the appropriate
    #   training set
    # This is because we need ALL the SSE's to get below a certain minimum before we stop
    #   training the network
    
    trainingDataSetNum = random.randint(1, 4)
    if trainingDataSetNum >1.1: # The selection is for training lists between 2 & 4
        if trainingDataSetNum > 2.1: # The selection is for training lists between 3 & 4
            if trainingDataSetNum > 3.1: # The selection is for training list 4
                trainingDataList = (1,1,0,1,3) # training data list 4 selected
            else: trainingDataList = (1,0,1,0,2) # training data list 3 selected   
        else: trainingDataList = (0,1,1,0,1) # training data list 2 selected     
    else: trainingDataList = (0,0,0,1,0) # training data list 1 selected 
           
    return (trainingDataList)  


    
####################################################################################################
####################################################################################################
#
# Compute neuron activation - this is the summed weighted inputs after passing through transfer fnctn
#
####################################################################################################
####################################################################################################

def computeSingleNeuronActivation(alpha, wt0, wt1, input0, input1, bias, debugComputeSingleNeuronActivationOff):
    
# Obtain the inputs into the neuron; this is the sum of weights times inputs
    summedNeuronInput = wt0*input0+wt1*input1+bias

# Pass the summedNeuronActivation and the transfer function parameter alpha into the transfer function
    activation = computeTransferFnctn(summedNeuronInput, alpha)

    if not debugComputeSingleNeuronActivationOff:        
        print (' ')
        print ('  In computeSingleNeuronActivation with input0, input 1 given as: ', input0, ', ', input1)
        print ('    The summed neuron input is %.4f' % summedNeuronInput   )
        print ('    The activation (applied transfer function) for that neuron is %.4f' % activation)   
    return activation;
   
    
            
####################################################################################################
####################################################################################################
#
# Perform a single feedforward pass
#
####################################################################################################
####################################################################################################


def ComputeSingleFeedforwardPass (alpha, inputDataList, wWeightArray, vWeightArray, 
biasHiddenWeightArray, biasOutputWeightArray, debugComputeSingleFeedforwardPassOff):

# Some prints to verify that the input data and the weight arrays have been transferred:
#    print 'In ComputeSingleFeedforwardPass'
    input0 = inputDataList[0]
    input1 = inputDataList[1]      
#    print 'The inputs transferred in are: '
#    print 'Input0 = ', input0
#    print 'Input1 = ', input1     
#    print
#    print 'The initial weights for this neural network are:'
#    print '     Input-to-Hidden             Hidden-to-Output'
#    print 'w(0,0) = %.3f   w(0,1) = %.3f         v(0,0) = %.3f   v(0,1) = %.3f' % (wWeightArray[0,0], 
#    wWeightArray[0,1], vWeightArray[0,0], vWeightArray [0,1])
#    print 'w(1,0) = %.3f   w(1,1) = %.3f         v(1,0) = %.3f   v(1,1) = %.3f' % (wWeightArray[1,0], 
#    wWeightArray[1,1], vWeightArray[1,0], vWeightArray [1,1])   
#    actualOutputList = (0,0) 

# Recall from InitializeWeightArray: 
# Notice that the position of the weights in the weightArray is not as would be expected:
#  Row 0, Col 1: wt00 = weight connecting 0th lower-level node to 0th upper-level node = weightArray [0,0]
#  Row 0, Col 1: wt10 = weight connecting 1st lower-level node to 0th upper-level node = weightArray [0,1]
#  Row 0, Col 1: wt01 = weight connecting 0th lower-level node to 1st upper-level node = weightArray [1,0]
#  Row 0, Col 1: wt11 = weight connecting 1st lower-level node to 1st upper-level node = weightArray [1,1]
# Notice that wt01 & wt10 are reversed from what we'd expect 
    
            
# Assign the input-to-hidden weights to specific variables
    wWt00 = wWeightArray[0,0]
    wWt10 = wWeightArray[0,1]
    wWt01 = wWeightArray[1,0]       
    wWt11 = wWeightArray[1,1]
    
# Assign the hidden-to-output weights to specific variables
    vWt00 = vWeightArray[0,0]
    vWt10 = vWeightArray[0,1]
    vWt01 = vWeightArray[1,0]       
    vWt11 = vWeightArray[1,1]    
    
    biasHidden0 = biasHiddenWeightArray[0]
    biasHidden1 = biasHiddenWeightArray[1]
    biasOutput0 = biasOutputWeightArray[0]
    biasOutput1 = biasOutputWeightArray[1]
    
# Obtain the activations of the hidden nodes  
    if not debugComputeSingleFeedforwardPassOff:
        debugComputeSingleNeuronActivationOff = False
    else: 
        debugComputeSingleNeuronActivationOff = True
        
    if not debugComputeSingleNeuronActivationOff:
        print (' ')
        print ('  For hiddenActivation0 from input0, input1 = ', input0, ', ', input1)
    hiddenActivation0 = computeSingleNeuronActivation(alpha, wWt00, wWt10, input0, input1, biasHidden0,
    debugComputeSingleNeuronActivationOff)
    if not debugComputeSingleNeuronActivationOff:
        print (' ')
        print ('  For hiddenActivation1 from input0, input1 = ', input0, ', ', input1  )  
    hiddenActivation1 = computeSingleNeuronActivation(alpha, wWt01, wWt11, input0, input1, biasHidden1,
    debugComputeSingleNeuronActivationOff)
    if not debugComputeSingleFeedforwardPassOff: 
        print (' ')
        print ('  In computeSingleFeedforwardPass: ')
        print ('  Input node values: ', input0, ', ', input1)
        print ('  The activations for the hidden nodes are:')
        print ('    Hidden0 = %.4f' % hiddenActivation0, 'Hidden1 = %.4f' % hiddenActivation1)


# Obtain the activations of the output nodes    
    outputActivation0 = computeSingleNeuronActivation(alpha, vWt00, vWt10, hiddenActivation0, 
    hiddenActivation1, biasOutput0, debugComputeSingleNeuronActivationOff)
    outputActivation1 = computeSingleNeuronActivation(alpha, vWt01, vWt11, hiddenActivation0, 
    hiddenActivation1, biasOutput1, debugComputeSingleNeuronActivationOff)
    if not debugComputeSingleFeedforwardPassOff: 
        print (' ')
        print ('  Computing the output neuron activations' )
        print (' '        )
        print ('  Back in ComputeSingleFeedforwardPass (for hidden-to-output computations)')
        print ('  The activations for the output nodes are:')
        print ('    Output0 = %.4f' % outputActivation0, 'Output1 = %.4f' % outputActivation1)


               
    actualAllNodesOutputList = (hiddenActivation0, hiddenActivation1, outputActivation0, outputActivation1)
                                                                                                
    return (actualAllNodesOutputList);
  


####################################################################################################
####################################################################################################
#
# Determine initial Summed Squared Error (SSE) and Total Summed Squared Error (TotalSSE) as an
#   array, SSE_Array (SSE[0], SSE[1], SSE[2], SSE[3], Total_SSE), return array to calling procedure
# Note: This function returns the SSE_Array
# Note: This function USES computeSingleFeedforwardPass
#
####################################################################################################
####################################################################################################

def computeSSE_Values (alpha, SSE_InitialArray, wWeightArray, vWeightArray, biasHiddenWeightArray, 
biasOutputWeightArray, debugSSE_InitialComputationOff): 

    if not debugSSE_InitialComputationOff:
        debugComputeSingleFeedforwardPassOff = False
    else: 
        debugComputeSingleFeedforwardPassOff = True
              
# Compute a single feed-forward pass and obtain the Actual Outputs for zeroth data set
    inputDataList = (0, 0)           
    actualAllNodesOutputList = ComputeSingleFeedforwardPass (alpha, inputDataList, wWeightArray, vWeightArray,
    biasHiddenWeightArray, biasOutputWeightArray, debugComputeSingleFeedforwardPassOff)        
    actualOutput0 = actualAllNodesOutputList [2]
    actualOutput1 = actualAllNodesOutputList [3] 
    error0 = 0.0 - actualOutput0
    error1 = 1.0 - actualOutput1
    SSE_InitialArray[0] = error0**2 + error1**2

# debug print for function:
    if not debugSSE_InitialComputationOff:
        print (' ')
        print ('  In computeSSE_Values' )

# debug print for (0,0):
    if not debugSSE_InitialComputationOff: 
        input0 = inputDataList [0]
        input1 = inputDataList [1]
        print (' ')
        print ('  Actual Node Outputs for (0,0) training set:')
        print ('     input0 = ', input0, '   input1 = ', input1)
        print ('     actualOutput0 = %.4f   actualOutput1 = %.4f' %(actualOutput0, actualOutput1))
        print ('     error0 =        %.4f   error1 =        %.4f' %(error0, error1))
        print ('  Initial SSE for (0,0) = %.4f' % SSE_InitialArray[0])

# Compute a single feed-forward pass and obtain the Actual Outputs for first data set
    inputDataList = (0, 1)           
    actualAllNodesOutputList = ComputeSingleFeedforwardPass (alpha, inputDataList, wWeightArray, vWeightArray,
    biasHiddenWeightArray, biasOutputWeightArray, debugComputeSingleFeedforwardPassOff)        
    actualOutput0 = actualAllNodesOutputList [2]
    actualOutput1 = actualAllNodesOutputList [3] 
    error0 = 1.0 - actualOutput0
    error1 = 0.0 - actualOutput1
    SSE_InitialArray[1] = error0**2 + error1**2

# debug print for (0,1):
    if not debugSSE_InitialComputationOff: 
        input0 = inputDataList [0]
        input1 = inputDataList [1]
        print (' ')
        print ('  Actual Node Outputs for (0,1) training set:')
        print ('     input0 = ', input0, '   input1 = ', input1)
        print ('     actualOutput0 = %.4f   actualOutput1 = %.4f' %(actualOutput0, actualOutput1))
        print ('     error0 =        %.4f   error1 =        %.4f' %(error0, error1))
        print ('  Initial SSE for (0,1) = %.4f' % SSE_InitialArray[1])
        
                                                        
# Compute a single feed-forward pass and obtain the Actual Outputs for second data set
    inputDataList = (1, 0)           
    actualAllNodesOutputList = ComputeSingleFeedforwardPass (alpha, inputDataList, wWeightArray, vWeightArray, 
    biasHiddenWeightArray, biasOutputWeightArray, debugComputeSingleFeedforwardPassOff)        
    actualOutput0 = actualAllNodesOutputList [2]
    actualOutput1 = actualAllNodesOutputList [3] 
    error0 = 1.0 - actualOutput0
    error1 = 0.0 - actualOutput1
    SSE_InitialArray[2] = error0**2 + error1**2
    
# debug print for (1,0):
    if not debugSSE_InitialComputationOff: 
        input0 = inputDataList [0]
        input1 = inputDataList [1]
        print (' ')
        print ('  Actual Node Outputs for (1,0) training set:')
        print ('     input0 = ', input0, '   input1 = ', input1)
        print ('     actualOutput0 = %.4f   actualOutput1 = %.4f' %(actualOutput0, actualOutput1))
        print ('     error0 =        %.4f   error1 =        %.4f' %(error0, error1))
        print ('  Initial SSE for (1,0) = %.4f' % SSE_InitialArray[2]    )
        
# Compute a single feed-forward pass and obtain the Actual Outputs for third data set
    inputDataList = (1, 1)           
    actualAllNodesOutputList = ComputeSingleFeedforwardPass (alpha, inputDataList, wWeightArray, vWeightArray,
    biasHiddenWeightArray, biasOutputWeightArray, debugComputeSingleFeedforwardPassOff)        
    actualOutput0 = actualAllNodesOutputList [2]
    actualOutput1 = actualAllNodesOutputList [3] 
    error0 = 0.0 - actualOutput0
    error1 = 1.0 - actualOutput1
    SSE_InitialArray[3] = error0**2 + error1**2

# debug print for (1,1):
    if not debugSSE_InitialComputationOff: 
        input0 = inputDataList [0]
        input1 = inputDataList [1]
        print (' ')
        print ('  Actual Node Outputs for (1,1) training set:')
        print ('     input0 = ', input0, '   input1 = ', input1)
        print ('     actualOutput0 = %.4f   actualOutput1 = %.4f' %(actualOutput0, actualOutput1))
        print ('     error0 =        %.4f   error1 =        %.4f' %(error0, error1))
        print ('  Initial SSE for (1,1) = %.4f' % SSE_InitialArray[3]  )
    
# Initialize an array of SSE values
    SSE_InitialTotal = SSE_InitialArray[0] + SSE_InitialArray[1] +SSE_InitialArray[2] + SSE_InitialArray[3]                                                 

# debug print for SSE_InitialTotal:
    if not debugSSE_InitialComputationOff: 
        print (' ')
        print ('  The initial total of the SSEs is %.4f' %SSE_InitialTotal)

    SSE_InitialArray[4] = SSE_InitialTotal
    
    return SSE_InitialArray

####################################################################################################
#**************************************************************************************************#
####################################################################################################
#
#   Backpropagation Section
#
####################################################################################################
#**************************************************************************************************#
####################################################################################################

    
            
####################################################################################################
#
# Optional Debug and Code-Trace Print: Backpropagate the hidden-to-output connection weights
#
####################################################################################################

def PrintAndTraceBackpropagateOutputToHidden (alpha, eta, errorList, 
actualAllNodesOutputList, transFuncDerivList, deltaVWtArray, vWeightArray, newVWeightArray):

    hiddenNode0 = actualAllNodesOutputList[0]
    hiddenNode1 = actualAllNodesOutputList[1]
    outputNode0 = actualAllNodesOutputList[2]    
    outputNode1 = actualAllNodesOutputList[3]
    transFuncDeriv0 = transFuncDerivList[0]
    transFuncDeriv1 = transFuncDerivList[1]
#  Pre Debug: These variables did not get the mirror image fix
#    deltaVWt00 = deltaVWtArray[0,0]
#    deltaVWt01 = deltaVWtArray[0,1]
#    deltaVWt10 = deltaVWtArray[1,0]
#    deltaVWt11 = deltaVWtArray[1,1]

#  New code: 
    deltaVWt00 = deltaVWtArray[0,0]
    deltaVWt01 = deltaVWtArray[1,0]
    deltaVWt10 = deltaVWtArray[0,1]
    deltaVWt11 = deltaVWtArray[1,1]    
    
    error0 = errorList[0]
    error1 = errorList[1]                 
        
    print (' ')
    print ('In Print and Trace for Backpropagation: Hidden to Output Weights')
    print ('  Assuming alpha = 1')
    print (' ')
    print ('  The hidden node activations are:')
    print ('    Hidden node 0: ', '  %.4f' % hiddenNode0, '  Hidden node 1: ', '  %.4f' % hiddenNode1  ) 
    print (' ')
    print ('  The output node activations are:')
    print ('    Output node 0: ', '  %.3f' % outputNode0, '   Output node 1: ', '  %.3f' % outputNode1)      
    print (' ' )
    print ('  The transfer function derivatives are: ')
    print ('    Deriv-F(0): ', '     %.3f' % transFuncDeriv0, '   Deriv-F(1): ', '     %.3f' % transFuncDeriv1)

    print (' ' )
    print ('The computed values for the deltas are: ')
    print ('                eta  *  error  *   trFncDeriv *   hidden')
    print ('  deltaVWt00 = ',' %.2f' % eta, '* %.4f' % error0, ' * %.4f' % transFuncDeriv0, '  * %.4f' % hiddenNode0)
    print ('  deltaVWt01 = ',' %.2f' % eta, '* %.4f' % error1, ' * %.4f' % transFuncDeriv1, '  * %.4f' % hiddenNode0 )                      
    print ('  deltaVWt10 = ',' %.2f' % eta, '* %.4f' % error0, ' * %.4f' % transFuncDeriv0, '  * %.4f' % hiddenNode1)
    print ('  deltaVWt11 = ',' %.2f' % eta, '* %.4f' % error1, ' * %.4f' % transFuncDeriv1, '  * %.4f' % hiddenNode1)
    print (' ')
    print ('Values for the hidden-to-output connection weights:')
    print ('           Old:     New:      eta*Delta:')
    print ('[0,0]:   %.4f' % vWeightArray[0,0], '  %.4f' % newVWeightArray[0,0], '  %.4f' % deltaVWtArray[0,0])
    print ('[0,1]:   %.4f' % vWeightArray[1,0], '  %.4f' % newVWeightArray[1,0], '  %.4f' % deltaVWtArray[1,0])
    print ('[1,0]:   %.4f' % vWeightArray[0,1], '  %.4f' % newVWeightArray[0,1], '  %.4f' % deltaVWtArray[0,1])
    print ('[1,1]:   %.4f' % vWeightArray[1,1], '  %.4f' % newVWeightArray[1,1], '  %.4f' % deltaVWtArray[1,1] )   


            
####################################################################################################
#
# Optional Debug and Code-Trace Print: Backpropagate the input-to-hidden connection weights
#
####################################################################################################

def PrintAndTraceBackpropagateHiddenToInput (alpha, eta, inputDataList, errorList, 
actualAllNodesOutputList, transFuncDerivHiddenList, transFuncDerivOutputList, deltaWWtArray, vWeightArray, wWeightArray, 
newWWeightArray, biasWeightArray):

    inputNode0 = inputDataList[0]
    inputNode1 = inputDataList[1]    
    hiddenNode0 = actualAllNodesOutputList[0]
    hiddenNode1 = actualAllNodesOutputList[1]
    outputNode0 = actualAllNodesOutputList[2]    
    outputNode1 = actualAllNodesOutputList[3]
    transFuncDerivHidden0 = transFuncDerivHiddenList[0]
    transFuncDerivHidden1 = transFuncDerivHiddenList[1]
    transFuncDerivOutput0 = transFuncDerivOutputList[0]
    transFuncDerivOutput1 = transFuncDerivOutputList[1]    
            
#  Pre Debug: These variables did not get the mirror image fix
#    deltaVWt00 = deltaVWtArray[0,0]
#    deltaVWt01 = deltaVWtArray[0,1]
#    deltaVWt10 = deltaVWtArray[1,0]
#    deltaVWt11 = deltaVWtArray[1,1]

#  New code: 
    wWt00 = wWeightArray[0,0]
    wWt01 = wWeightArray[1,0]
    wWt10 = wWeightArray[0,1]       
    wWt11 = wWeightArray[1,1]
    
    deltaWWt00 = deltaWWtArray[0,0]
    deltaWWt01 = deltaWWtArray[1,0]
    deltaWWt10 = deltaWWtArray[0,1]
    deltaWWt11 = deltaWWtArray[1,1] 
    
    vWt00 = vWeightArray[0,0]
    vWt01 = vWeightArray[1,0]
    vWt10 = vWeightArray[0,1]
    vWt11 = vWeightArray[1,1]                
    
    error0 = errorList[0]
    error1 = errorList[1]

    errorTimesTransD0 = error0*transFuncDerivOutput0
    errorTimesTransD1 = error1*transFuncDerivOutput1    
            
    biasHidden0 = biasWeightArray[0,0]
    biasHidden1 = biasWeightArray[0,1]                                      

    partialSSE_w_Wwt00 = -transFuncDerivHidden0*inputNode0*(vWt00*error0 + vWt01*error1)                                                             
    partialSSE_w_Wwt01 = -transFuncDerivHidden1*inputNode0*(vWt10*error0 + vWt11*error1)
    partialSSE_w_Wwt10 = -transFuncDerivHidden0*inputNode1*(vWt00*error0 + vWt01*error1)
    partialSSE_w_Wwt11 = -transFuncDerivHidden1*inputNode1*(vWt10*error0 + vWt11*error1)
    
    sumTermH0 = vWt00*error0+vWt01*error1
    sumTermH1 = vWt10*error0+vWt11*error1
                                                                                                                                                                                                                                                                                                                                                                                                                                      
                   
                                
    print (' ')
    print ('In Print and Trace for Backpropagation: Input to Hidden Weights')
    print ('  Assuming alpha = 1')
    print (' ')
    print ('  The hidden node activations are:')
    print ('    Hidden node 0: ', '  %.4f' % hiddenNode0, '  Hidden node 1: ', '  %.4f' % hiddenNode1 )  
    print (' ')
    print ('  The output node activations are:')
    print ('    Output node 0: ', '  %.3f' % outputNode0, '   Output node 1: ', '  %.3f' % outputNode1 )      
    print (' ' )
    print ('  The transfer function derivatives at the hidden nodes are: ')
    print ('    Deriv-F(0): ', '     %.3f' % transFuncDeriv0, '   Deriv-F(1): ', '     %.3f' % transFuncDeriv1)

    print (' ' )
    print ('The computed values for the deltas are: ')
    print ('                eta  *  error  *   trFncDeriv *   input    * SumTerm for given H')
    print ('  deltaWWt00 = ',' %.2f' % eta, '* %.4f' % error0, ' * %.4f' % transFuncDerivHidden0, '  * %.4f' % inputNode0, '  * %.4f' % sumTermH0)
    print ('  deltaWWt01 = ',' %.2f' % eta, '* %.4f' % error1, ' * %.4f' % transFuncDerivHidden1, '  * %.4f' % inputNode0, '  * %.4f' % sumTermH1 )                      
    print ('  deltaWWt10 = ',' %.2f' % eta, '* %.4f' % error0, ' * %.4f' % transFuncDerivHidden0, '  * %.4f' % inputNode1, '  * %.4f' % sumTermH0)
    print ('  deltaWWt11 = ',' %.2f' % eta, '* %.4f' % error1, ' * %.4f' % transFuncDerivHidden1, '  * %.4f' % inputNode1, '  * %.4f' % sumTermH1)
    print (' ')
    print ('Values for the input-to-hidden connection weights:')
    print ('           Old:     New:      eta*Delta:')
    print ('[0,0]:   %.4f' % wWeightArray[0,0], '  %.4f' % newWWeightArray[0,0], '  %.4f' % deltaWWtArray[0,0])
    print ('[0,1]:   %.4f' % wWeightArray[1,0], '  %.4f' % newWWeightArray[1,0], '  %.4f' % deltaWWtArray[1,0])
    print ('[1,0]:   %.4f' % wWeightArray[0,1], '  %.4f' % newWWeightArray[0,1], '  %.4f' % deltaWWtArray[0,1])
    print ('[1,1]:   %.4f' % wWeightArray[1,1], '  %.4f' % newWWeightArray[1,1], '  %.4f' % deltaWWtArray[1,1] )   

     
         
            
####################################################################################################
####################################################################################################
#
# Backpropagate weight changes onto the hidden-to-output connection weights
#
####################################################################################################
####################################################################################################


def BackpropagateOutputToHidden (alpha, eta, errorList, actualAllNodesOutputList, vWeightArray):

# The first step here applies a backpropagation-based weight change to the hidden-to-output wts v. 
# Core equation for the first part of backpropagation: 
# d(SSE)/dv(h,o) = -alpha*Error*F(1-F)*Hidden(h)
# where:
# -- SSE = sum of squared errors, and only the error associated with a given output node counts
# -- v(h,o) is the connection weight v between the hidden node h and the output node o
# -- alpha is the scaling term within the transfer function, often set to 1
# ---- (this is included in transfFuncDeriv) 
# -- Error = Error(o) or error at the output node o; = Desired(o) - Actual(o)
# -- F = transfer function, here using the sigmoid transfer function
# -- Hidden(h) = the output of hidden node h. 

# Note that the training rate parameter is assigned in main; Greek letter "eta," looks like n, 
#   scales amount of change to connection weight

# Unpack the errorList and the vWeightArray

# We will DECREMENT the connection weight v by a small amount proportional to the derivative eqn
#   of the SSE w/r/t the weight v. 
# This means, since there is a minus sign in that derivative, that we will add a small amount. 
# (Decrementing is -, applied to a (-), which yields a positive.)

# For the actual derivation of this equation with MATCHING VARIABLE NAMES (easy to understand), 
#   please consult: Brain-Based Computing, by AJ Maren (under development, Jan., 2017). Chpt. X. 
#   (Meaning: exact chapter is still TBD.) 
# For the latest updates, etc., please visit: www.aliannajmaren.com

# Unpack the errorList and the vWeightArray
    error0 = errorList[0]
    error1 = errorList[1]
    
    vWt00 = vWeightArray[0,0]
    vWt01 = vWeightArray[1,0]
    vWt10 = vWeightArray[0,1]       
    vWt11 = vWeightArray[1,1]  
    
    hiddenNode0 = actualAllNodesOutputList[0]
    hiddenNode1 = actualAllNodesOutputList[1]
    outputNode0 = actualAllNodesOutputList[2]    
    outputNode1 = actualAllNodesOutputList[3]  
        
    transFuncDeriv0 = computeTransferFnctnDeriv(outputNode0, alpha) 
    transFuncDeriv1 = computeTransferFnctnDeriv(outputNode1, alpha)
    transFuncDerivList = (transFuncDeriv0, transFuncDeriv1) 

# Note: the parameter 'alpha' in the transfer function shows up in the transfer function derivative
#   and so is not included explicitly in these equations 

# The equation for the actual dependence of the Summed Squared Error on a given hidden-to-output weight v(h,o) is:
#   partial(SSE)/partial(v(h,o)) = -alpha*E(o)*F(o)*[1-F(o)]*H(h)
# The transfer function derivative (transFuncDeriv) returned from computeTransferFnctnDeriv is given as:
#   transFuncDeriv =  alpha*NeuronOutput*(1.0 -NeuronOutput)
# Therefore, we can write the equation for the partial(SSE)/partial(v(h,o)) as
#   partial(SSE)/partial(v(h,o)) = E(o)*transFuncDeriv*H(h)
#   The parameter alpha is included in transFuncDeriv

    partialSSE_w_Vwt00 = -error0*transFuncDeriv0*hiddenNode0                                                             
    partialSSE_w_Vwt01 = -error1*transFuncDeriv1*hiddenNode0
    partialSSE_w_Vwt10 = -error0*transFuncDeriv0*hiddenNode1
    partialSSE_w_Vwt11 = -error1*transFuncDeriv1*hiddenNode1                                                                                                                                                                                                                                                                 
                                                                                                                                                                                                                                                
    deltaVWt00 = -eta*partialSSE_w_Vwt00
    deltaVWt01 = -eta*partialSSE_w_Vwt01        
    deltaVWt10 = -eta*partialSSE_w_Vwt10
    deltaVWt11 = -eta*partialSSE_w_Vwt11 
    deltaVWtArray = np.array([[deltaVWt00, deltaVWt10],[deltaVWt01, deltaVWt11]])

    vWt00 = vWt00+deltaVWt00
    vWt01 = vWt01+deltaVWt01
    vWt10 = vWt10+deltaVWt10
    vWt11 = vWt11+deltaVWt11 
    
    newVWeightArray = np.array([[vWt00, vWt10], [vWt01, vWt11]])

    PrintAndTraceBackpropagateOutputToHidden (alpha, eta, errorList, actualAllNodesOutputList, 
    transFuncDerivList, deltaVWtArray, vWeightArray, newVWeightArray)    
                                                                                                                                            
    return (newVWeightArray);     

            
####################################################################################################
####################################################################################################
#
# Backpropagate weight changes onto the bias-to-output connection weights
#
####################################################################################################
####################################################################################################


def BackpropagateBiasOutputWeights (alpha, eta, errorList, actualAllNodesOutputList, 
biasOutputWeightArray):

# The first step here applies a backpropagation-based weight change to the hidden-to-output wts v. 
# Core equation for the first part of backpropagation: 
# d(SSE)/dv(h,o) = -alpha*Error*F(1-F)*Hidden(h)
# where:
# -- SSE = sum of squared errors, and only the error associated with a given output node counts
# -- v(h,o) is the connection weight v between the hidden node h and the output node o
# -- alpha is the scaling term within the transfer function, often set to 1
# ---- (this is included in transfFuncDeriv) 
# -- Error = Error(o) or error at the output node o; = Desired(o) - Actual(o)
# -- F = transfer function, here using the sigmoid transfer function
# -- Hidden(h) = the output of hidden node h. 

# Note that the training rate parameter is assigned in main; Greek letter "eta," looks like n, 
#   scales amount of change to connection weight

# We will DECREMENT the connection weight biasOutput by a small amount proportional to the derivative eqn
#   of the SSE w/r/t the weight biasOutput(o). 
# This means, since there is a minus sign in that derivative, that we will add a small amount. 
# (Decrementing is -, applied to a (-), which yields a positive.)

# For the actual derivation of this equation with MATCHING VARIABLE NAMES (easy to understand), 
#   please consult: Brain-Based Computing, by AJ Maren (under development, Jan., 2017). Chpt. X. 
#   (Meaning: exact chapter is still TBD.) 
# For the latest updates, etc., please visit: www.aliannajmaren.com

# Unpack the errorList 
    error0 = errorList[0]
    error1 = errorList[1]

# Unpack the biasOutputWeightArray, we will only be modifying the biasOutput terms   
    biasOutputWt0 = biasOutputWeightArray[0]
    biasOutputWt1 = biasOutputWeightArray[1]
    
# Unpack the outputNodes  
    outputNode0 = actualAllNodesOutputList[2]    
    outputNode1 = actualAllNodesOutputList[3]  
    
# Compute the transfer function derivatives as a function of the output nodes.
# Note: As this is being done after the call to the backpropagation on the hidden-to-output weights,
#   the transfer function derivative computed there could have been used here; the calculations are
#   being redone here only to maintain module independence              
    transFuncDeriv0 = computeTransferFnctnDeriv(outputNode0, alpha) 
    transFuncDeriv1 = computeTransferFnctnDeriv(outputNode1, alpha)
# This is actually an unnecessary step; we're not passing the list back. 
    transFuncDerivList = (transFuncDeriv0, transFuncDeriv1) 

# Note: the parameter 'alpha' in the transfer function shows up in the transfer function derivative
#   and so is not included explicitly in these equations 

# The equation for the actual dependence of the Summed Squared Error on a given bias-to-output 
#   weight biasOutput(o) is:
#   partial(SSE)/partial(biasOutput(o)) = -alpha*E(o)*F(o)*[1-F(o)]*1, as '1' is the input from the bias.
# The transfer function derivative (transFuncDeriv) returned from computeTransferFnctnDeriv is given as:
#   transFuncDeriv =  alpha*NeuronOutput*(1.0 -NeuronOutput), as with the hidden-to-output weights.
# Therefore, we can write the equation for the partial(SSE)/partial(biasOutput(o)) as
#   partial(SSE)/partial(biasOutput(o)) = E(o)*transFuncDeriv
#   The parameter alpha is included in transFuncDeriv

    
    partialSSE_w_BiasOutput0 = -error0*transFuncDeriv0
    partialSSE_w_BiasOutput1 = -error1*transFuncDeriv1    
                                                                                                                                                                                                                                                                
    deltaBiasOutput0 = -eta*partialSSE_w_BiasOutput0
    deltaBiasOutput1 = -eta*partialSSE_w_BiasOutput1

    biasOutputWt0 = biasOutputWt0+deltaBiasOutput0
    biasOutputWt1 = biasOutputWt1+deltaBiasOutput1 

# Note that only the bias weights for the output nodes have been changed.         
    newBiasOutputWeightArray = np.array([biasOutputWt0, biasOutputWt1])

#    A new procedure to debug trace this function has not been written yet. 
#    PrintAndTraceBackpropagateOutputToHidden (alpha, eta, errorList, actualAllNodesOutputList, 
#    transFuncDerivList, deltaVWtArray, vWeightArray, newVWeightArray)    
                                                                                                                                            
    return (newBiasOutputWeightArray);     



####################################################################################################
####################################################################################################
#
# Backpropagate weight changes onto the input-to-hidden connection weights
#
####################################################################################################
####################################################################################################


def BackpropagateHiddenToInput (alpha, eta, errorList, actualAllNodesOutputList, inputDataList, 
vWeightArray, wWeightArray, biasHiddenWeightArray, biasOutputWeightArray):

# The first step here applies a backpropagation-based weight change to the input-to-hidden wts w. 
# Core equation for the second part of backpropagation: 
# d(SSE)/dw(i,h) = -eta*alpha*F(h)(1-F(h))*Input(i)*sum(v(h,o)*Error(o))
# where:
# -- SSE = sum of squared errors, and only the error associated with a given output node counts
# -- w(i,h) is the connection weight w between the input node i and the hidden node h
# -- v(h,o) is the connection weight v between the hidden node h and the output node o
# -- alpha is the scaling term within the transfer function, often set to 1 
# ---- (this is included in transfFuncDeriv) 
# -- Error = Error(o) or error at the output node o; = Desired(o) - Actual(o)
# -- F = transfer function, here using the sigmoid transfer function
# ---- NOTE: in this second step, the transfer function is applied to the output of the hidden node,
# ------ so that F = F(h)
# -- Hidden(h) = the output of hidden node h (used in computing the derivative of the transfer function). 
# -- Input(i) = the input at node i.

# Note that the training rate parameter is assigned in main; Greek letter "eta," looks like n, 
#   scales amount of change to connection weight

# Unpack the errorList and the vWeightArray

# We will DECREMENT the connection weight v by a small amount proportional to the derivative eqn
#   of the SSE w/r/t the weight w. 
# This means, since there is a minus sign in that derivative, that we will add a small amount. 
# (Decrementing is -, applied to a (-), which yields a positive.)

# For the actual derivation of this equation with MATCHING VARIABLE NAMES (easy to understand), 
#   please consult: Brain-Based Computing, by AJ Maren (under development, Jan., 2017). Chpt. X. 
#   (Meaning: exact chapter is still TBD.) 
# For the latest updates, etc., please visit: www.aliannajmaren.com

# Note that the training rate parameter is assigned in main; Greek letter "eta," looks like n, 
#   scales amount of change to connection weight

# Unpack the errorList and the vWeightArray
    error0 = errorList[0]
    error1 = errorList[1]
    
    vWt00 = vWeightArray[0,0]
    vWt01 = vWeightArray[1,0]
    vWt10 = vWeightArray[0,1]       
    vWt11 = vWeightArray[1,1]  
    
    wWt00 = wWeightArray[0,0]
    wWt01 = wWeightArray[1,0]
    wWt10 = wWeightArray[0,1]       
    wWt11 = wWeightArray[1,1] 
    
    inputNode0 = inputDataList[0] 
    inputNode1 = inputDataList[1]         
    hiddenNode0 = actualAllNodesOutputList[0]
    hiddenNode1 = actualAllNodesOutputList[1]
    outputNode0 = actualAllNodesOutputList[2]    
    outputNode1 = actualAllNodesOutputList[3]
    
# For the second step in backpropagation (computing deltas on the input-to-hidden weights)
#   we need the transfer function derivative is applied to the output at the hidden node        
    transFuncDerivHidden0 = computeTransferFnctnDeriv(hiddenNode0, alpha) 
    transFuncDerivHidden1 = computeTransferFnctnDeriv(hiddenNode1, alpha)
    transFuncDerivHiddenList = (transFuncDerivHidden0, transFuncDerivHidden1) 
    
# We also need the transfer function derivative applied to the output at the output node
    transFuncDerivOutput0 = computeTransferFnctnDeriv(outputNode0, alpha) 
    transFuncDerivOutput1 = computeTransferFnctnDeriv(outputNode1, alpha)
    transFuncDerivOutputList = (transFuncDerivOutput0, transFuncDerivOutput1) 
    
    errorTimesTransDOutput0 = error0*transFuncDerivOutput0
    errorTimesTransDOutput1 = error1*transFuncDerivOutput1
            
               
# Note: the parameter 'alpha' in the transfer function shows up in the transfer function derivative
#   and so is not included explicitly in these equations
    partialSSE_w_Wwt00 = -transFuncDerivHidden0*inputNode0*(vWt00*errorTimesTransDOutput0 + vWt01*errorTimesTransDOutput1)                                                             
    partialSSE_w_Wwt01 = -transFuncDerivHidden1*inputNode0*(vWt10*errorTimesTransDOutput0 + vWt11*errorTimesTransDOutput1)
    partialSSE_w_Wwt10 = -transFuncDerivHidden0*inputNode1*(vWt00*errorTimesTransDOutput0 + vWt01*errorTimesTransDOutput1)
    partialSSE_w_Wwt11 = -transFuncDerivHidden1*inputNode1*(vWt10*errorTimesTransDOutput0 + vWt11*errorTimesTransDOutput1)                                                                                                    
                                                                                                                                                                                                                                                
    deltaWWt00 = -eta*partialSSE_w_Wwt00
    deltaWWt01 = -eta*partialSSE_w_Wwt01        
    deltaWWt10 = -eta*partialSSE_w_Wwt10
    deltaWWt11 = -eta*partialSSE_w_Wwt11 
    deltaWWtArray = np.array([[deltaWWt00, deltaWWt10],[deltaWWt01, deltaWWt11]])



    wWt00 = wWt00+deltaWWt00
    wWt01 = wWt01+deltaWWt01
    wWt10 = wWt10+deltaWWt10
    wWt11 = wWt11+deltaWWt11 
    
    newWWeightArray = np.array([[wWt00, wWt10], [wWt01, wWt11]])

#    PrintAndTraceBackpropagateHiddenToInput (alpha, eta, inputDataList, errorList, actualAllNodesOutputList, 
#    transFuncDerivHiddenList, transFuncDerivOutputList, deltaWWtArray, vWeightArray, wWeightArray, newWWeightArray, biasWeightArray)     
                                                                    
    return (newWWeightArray);     

            
####################################################################################################
####################################################################################################
#
# Backpropagate weight changes onto the bias-to-hidden connection weights
#
####################################################################################################
####################################################################################################


def BackpropagateBiasHiddenWeights (alpha, eta, errorList, actualAllNodesOutputList, vWeightArray, 
biasHiddenWeightArray, biasOutputWeightArray):

# The first step here applies a backpropagation-based weight change to the hidden-to-output wts v. 
# Core equation for the first part of backpropagation: 
# d(SSE)/dv(h,o) = -alpha*Error*F(1-F)*Hidden(h)
# where:
# -- SSE = sum of squared errors, and only the error associated with a given output node counts
# -- v(h,o) is the connection weight v between the hidden node h and the output node o
# -- alpha is the scaling term within the transfer function, often set to 1
# ---- (this is included in transfFuncDeriv) 
# -- Error = Error(o) or error at the output node o; = Desired(o) - Actual(o)
# -- F = transfer function, here using the sigmoid transfer function
# -- Hidden(h) = the output of hidden node h. 

# Note that the training rate parameter is assigned in main; Greek letter "eta," looks like n, 
#   scales amount of change to connection weight

# We will DECREMENT the connection weight biasOutput by a small amount proportional to the derivative eqn
#   of the SSE w/r/t the weight biasOutput(o). 
# This means, since there is a minus sign in that derivative, that we will add a small amount. 
# (Decrementing is -, applied to a (-), which yields a positive.)

# For the actual derivation of this equation with MATCHING VARIABLE NAMES (easy to understand), 
#   please consult: Brain-Based Computing, by AJ Maren (under development, Jan., 2017). Chpt. X. 
#   (Meaning: exact chapter is still TBD.) 
# For the latest updates, etc., please visit: www.aliannajmaren.com

# Unpack the errorList and vWeightArray
    error0 = errorList[0]
    error1 = errorList[1]
    
    vWt00 = vWeightArray[0,0]
    vWt01 = vWeightArray[1,0]
    vWt10 = vWeightArray[0,1]       
    vWt11 = vWeightArray[1,1]      

# Unpack the biasWeightArray, we will only be modifying the biasOutput terms, but need to have
#   all the bias weights for when we redefine the biasWeightArray
    biasHiddenWt0 = biasHiddenWeightArray[0]
    biasHiddenWt1 = biasHiddenWeightArray[1]    
    biasOutputWt0 = biasOutputWeightArray[0]
    biasOutputWt1 = biasOutputWeightArray[1]
    
# Unpack the outputNodes  
    hiddenNode0= actualAllNodesOutputList[0]
    hiddenNode1= actualAllNodesOutputList[1]
    outputNode0 = actualAllNodesOutputList[2]    
    outputNode1 = actualAllNodesOutputList[3]  
    
# Compute the transfer function derivatives as a function of the output nodes.
# Note: As this is being done after the call to the backpropagation on the hidden-to-output weights,
#   the transfer function derivative computed there could have been used here; the calculations are
#   being redone here only to maintain module independence              
    transFuncDerivOutput0 = computeTransferFnctnDeriv(outputNode0, alpha) 
    transFuncDerivOutput1 = computeTransferFnctnDeriv(outputNode1, alpha)
    transFuncDerivHidden0 = computeTransferFnctnDeriv(hiddenNode0, alpha) 
    transFuncDerivHidden1 = computeTransferFnctnDeriv(hiddenNode1, alpha)    

# This list will be used only if we call a print-and-trace debug function. 
    transFuncDerivOutputList = (transFuncDerivOutput0, transFuncDerivOutput1) 

# Note: the parameter 'alpha' in the transfer function shows up in the transfer function derivative
#   and so is not included explicitly in these equations 


# ===>>> AJM needs to double-check these equations in the comments area
# ===>>> The code should be fine. 
# The equation for the actual dependence of the Summed Squared Error on a given bias-to-output 
#   weight biasOutput(o) is:
#   partial(SSE)/partial(biasOutput(o)) = -alpha*E(o)*F(o)*[1-F(o)]*1, as '1' is the input from the bias.
# The transfer function derivative (transFuncDeriv) returned from computeTransferFnctnDeriv is given as:
#   transFuncDeriv =  alpha*NeuronOutput*(1.0 -NeuronOutput), as with the hidden-to-output weights.
# Therefore, we can write the equation for the partial(SSE)/partial(biasOutput(o)) as
#   partial(SSE)/partial(biasOutput(o)) = E(o)*transFuncDeriv
#   The parameter alpha is included in transFuncDeriv

    errorTimesTransDOutput0 = error0*transFuncDerivOutput0
    errorTimesTransDOutput1 = error1*transFuncDerivOutput1
    
    partialSSE_w_BiasHidden0 = -transFuncDerivHidden0*(errorTimesTransDOutput0*vWt00 + 
    errorTimesTransDOutput1*vWt01)
    partialSSE_w_BiasHidden1 = -transFuncDerivHidden1*(errorTimesTransDOutput0*vWt10 + 
    errorTimesTransDOutput1*vWt11)  
                                                                                                                                                                                                                                                                
    deltaBiasHidden0 = -eta*partialSSE_w_BiasHidden0
    deltaBiasHidden1 = -eta*partialSSE_w_BiasHidden1

    biasHiddenWt0 = biasHiddenWt0+deltaBiasHidden0
    biasHiddenWt1 = biasHiddenWt1+deltaBiasHidden1 

# Note that only the bias weights for the hidden nodes have been changed.         
    newBiasHiddenWeightArray = np.array([biasHiddenWt0, biasHiddenWt1])

#    A new procedure to debug trace this function has not been written yet. 
#    PrintAndTraceBackpropagateOutputToHidden (alpha, eta, errorList, actualAllNodesOutputList, 
#    transFuncDerivList, deltaVWtArray, vWeightArray, newVWeightArray)    
                                                                                                                                            
    return (newBiasHiddenWeightArray);     
            
####################################################################################################
#**************************************************************************************************#
####################################################################################################
#
# The MAIN module comprising of calls to:
#   (1) Welcome
#   (2) Obtain neural network size specifications for a three-layer network consisting of:
#       - Input layer
#       - Hidden layer
#       - Output layer (all the sizes are currently hard-coded to two nodes per layer right now)
#   (3) Initialize connection weight values
#       - w: Input-to-Hidden nodes
#       - v: Hidden-to-Output nodes
#   (4) Determine the initial Sum Squared Error (SSE) for each training pair, and also the total SSE
# 
#
####################################################################################################
#**************************************************************************************************#
####################################################################################################


def main():

####################################################################################################
# Obtain unit array size in terms of array_length (M) and layers (N)
####################################################################################################                

# This calls the procedure 'welcome,' which just prints out a welcoming message. 
# All procedures need an argument list. 
# This procedure has a list, but it is an empty list; welcome().

    welcome()
    

# Parameter definitions, to be replaced with user inputs
    alpha = 1.0             # parameter governing steepness of sigmoid transfer function
    summedInput = 1
    maxNumIterations = 5000    # temporarily set to 10 for testing
    eta = 0.5               # training rate     

# Right now, for simplicity, we're going to hard-code the numbers of layers that we have in our 
#   multilayer Perceptron (MLP) neural network. 
# We will have an input layer (I), an output layer (O), and a single hidden layer (H). 

# This defines the variable arraySizeList, which is a list. It is initially an empty list. 
# Its purpose is to store the size of the array.

    arraySizeList = list() # empty list

# Notice that I'm using the same variable name, 'arraySizeList' both here in main and in the 
#    called procedure, 'obtainNeuralNetworkSizeSpecs.' 
# I don't have to use the same name; the procedure returns a list and I'm assigning it HERE 
#    to the list named arraySizeList in THIS 'main' procedure. 
# I could use different names. 
# I'm keeping the same name so that it is easier for us to connect what happens in the called procedure
#    'obtainNeuralNetworkSizeSpecs' with this procedure, 'main.' 
       
    arraySizeList = obtainNeuralNetworkSizeSpecs ()
# Unpack the list; ascribe the various elements of the list to the sizes of different network layers    
    inputArrayLength = arraySizeList[0]
    hiddenArrayLength = arraySizeList [1]
    outputArrayLength = arraySizeList [2]

# I have all sorts of debug statements left in this, so you can trace the code moving into and out of
#   various procedures and functions.    
            
#    print 'Flow-of-control trace: Back in main'
#    print 'I = number of nodes in input layer is', inputArrayLength
#    print 'H = number of nodes in hidden layer is', hiddenArrayLength         
#    print 'O = number of nodes in output layer is', outputArrayLength                             


# Initialize the training list
# Note: The training list has, in order, the two input nodes, the two output nodes (this is a two-output
#   version of the X-OR problem), and the data set number (0..3), meaning that each data set is numbered. 
#   This helps in going through the entire data set once the initial weights are established to get a 
#   total sum (across all data sets) of the Summed Squared Error, or SSE.
    trainingDataList = (0,0,0,0,0)
           

####################################################################################################
# Initialize the weight arrays for two sets of weights; w: input-to-hidden, and v: hidden-to-output
####################################################################################################                

#
# The wWeightArray is for Input-to-Hidden
# The vWeightArray is for Hidden-to-Output

    wWeightArraySizeList = (inputArrayLength, hiddenArrayLength)
    vWeightArraySizeList = (hiddenArrayLength, outputArrayLength)
    biasHiddenWeightArraySize = hiddenArrayLength
    biasOutputWeightArraySize = outputArrayLength      
    


    
    

# The node-to-node connection weights are stored in a 2-D array    

# Debug parameter for examining results within initializeWeightArray is currently set to False
    debugCallInitializeOff = True
    debugInitializeOff = True
    if not debugCallInitializeOff:
        print (' ')
        print ('Calling initializeWeightArray for input-to-hidden weights')
    wWeightArray = initializeWeightArray (wWeightArraySizeList, debugInitializeOff)
    if not debugCallInitializeOff:
        print (' ')
        print ('Calling initializeWeightArray for hidden-to-output weights' )   
    vWeightArray = initializeWeightArray (vWeightArraySizeList, debugInitializeOff)


# The bias weights are stored in a 1-D array         
    biasHiddenWeightArray = initializeBiasWeightArray (biasHiddenWeightArraySize)
    biasOutputWeightArray = initializeBiasWeightArray (biasOutputWeightArraySize) 


    initialWWeightArray = wWeightArray[:]
    initialVWeightArray = vWeightArray[:]
    initialBiasHiddenWeightArray = biasHiddenWeightArray[:]   
    initialBiasOutputWeightArray = biasOutputWeightArray[:] 
    
    print
    print ('The initial weights for this neural network are:')
    print ('       Input-to-Hidden                            Hidden-to-Output')
    print ('  w(0,0) = %.4f   w(1,0) = %.4f         v(0,0) = %.4f   v(1,0) = %.4f' % (initialWWeightArray[0,0], 
    initialWWeightArray[0,1], initialVWeightArray[0,0], initialVWeightArray[0,1]))
    print ('  w(0,1) = %.4f   w(1,1) = %.4f         v(0,1) = %.4f   v(1,1) = %.4f' % (initialWWeightArray[1,0], 
    initialWWeightArray[1,1], initialVWeightArray[1,0], initialVWeightArray[1,1]) )
    print (' ')
    print ('       Bias at Hidden Layer                          Bias at Output Layer')
    print ('       b(hidden,0) = %.4f                           b(output,0) = %.4f' % (biasHiddenWeightArray[0],
    biasOutputWeightArray[0] )  )                
    print ('       b(hidden,1) = %.4f                           b(output,1) = %.4f' % (biasHiddenWeightArray[1],
    biasOutputWeightArray[1] )  )
  
    epsilon = 0.2
    iteration = 0
    SSE_InitialTotal = 0.0


####################################################################################################
# Next step - Get an initial value for the Total Summed Squared Error (Total_SSE)
#   The function will return an array of SSE values, SSE_Array[0] ... SSE_Array[3] are the initial SSEs
#   for training sets 0..3; SSE_Array[4] is the sum of the SSEs. 
####################################################################################################                
        
                        
# Initialize an array of SSE values
# The first four SSE values are the SSE's for specific input/output pairs; 
#   the fifth is the sum of all the SSE's.
    SSE_InitialArray = [0,0,0,0,0]
    
# Before starting the training run, compute the initial SSE Total 
#   (sum across SSEs for each training data set) 
    debugSSE_InitialComputationOff = True

    SSE_InitialArray = computeSSE_Values (alpha, SSE_InitialArray, wWeightArray, vWeightArray, 
    biasHiddenWeightArray, biasOutputWeightArray, debugSSE_InitialComputationOff)    

# Start the SSE_Array at the same values as the Initial SSE Array
    SSE_Array = SSE_InitialArray[:] 
    SSE_InitialTotal = SSE_Array[4] 
    
# Optionally, print a summary of the initial SSE Total (sum across SSEs for each training data set) 
#   and the specific SSE values 
# Set a local debug print parameter 
    debugSSE_InitialComputationReportOff = True    

    if not debugSSE_InitialComputationReportOff:
        print (' ')
        print ('In main, SSE computations completed, Total of all SSEs = %.4f' % SSE_Array[4])
        print ('  For input nodes (0,0), SSE_Array[0] = %.4f' % SSE_Array[0]   )                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            
        print ('  For input nodes (0,1), SSE_Array[1] = %.4f' % SSE_Array[1] )
        print ('  For input nodes (1,0), SSE_Array[2] = %.4f' % SSE_Array[2] )
        print ('  For input nodes (1,1), SSE_Array[3] = %.4f' % SSE_Array[3] )
    
    while iteration < maxNumIterations: 
           

####################################################################################################
# Next step - Obtain a single set of input values for the X-OR problem; two integers - can be 0 or 1
####################################################################################################                

# Randomly select one of four training sets; the inputs will be randomly assigned to 0 or 1
        trainingDataList = obtainRandomXORTrainingValues () 
        input0 = trainingDataList[0]
        input1 = trainingDataList[1] 
        desiredOutput0 = trainingDataList[2]
        desiredOutput1 = trainingDataList[3]
        setNumber = trainingDataList[4]       
        print (' ')
        print ('Randomly selecting XOR inputs for XOR, identifying desired outputs for this training pass:')
        print ('          Input0 = ', input0,         '            Input1 = ', input1   )
        print (' Desired Output0 = ', desiredOutput0, '   Desired Output1 = ', desiredOutput1   ) 
        print (' ')
         

####################################################################################################
# Compute a single feed-forward pass
####################################################################################################                
 
# Initialize the error list
        errorList = (0,0)
    
# Initialize the actualOutput list
        actualAllNodesOutputList = (0,0,0,0)     

# Create the inputData list      
        inputDataList = (input0, input1)         
    
# Compute a single feed-forward pass and obtain the Actual Outputs
        debugComputeSingleFeedforwardPassOff = True
        actualAllNodesOutputList = ComputeSingleFeedforwardPass (alpha, inputDataList, 
        wWeightArray, vWeightArray, biasHiddenWeightArray, biasOutputWeightArray,debugComputeSingleFeedforwardPassOff)

# Assign the hidden and output values to specific different variables
        actualHiddenOutput0 = actualAllNodesOutputList [0] 
        actualHiddenOutput1 = actualAllNodesOutputList [1] 
        actualOutput0 = actualAllNodesOutputList [2]
        actualOutput1 = actualAllNodesOutputList [3] 
    
# Determine the error between actual and desired outputs

        error0 = desiredOutput0 - actualOutput0
        error1 = desiredOutput1 - actualOutput1
        errorList = (error0, error1)
    
# Compute the Summed Squared Error, or SSE
        SSEInitial = error0**2 + error1**2
        
                            
        debugMainComputeForwardPassOutputsOff = True
        
# Debug print the actual outputs from the two output neurons
        if not debugMainComputeForwardPassOutputsOff:
            print (' ')
            print ('In main; have just completed a feedfoward pass with training set inputs', input0, input1)
            print ('  The activations (actual outputs) for the two hidden neurons are:')
            print ('    actualHiddenOutput0 = %.4f' % actualHiddenOutput0)
            print ('    actualHiddenOutput1 = %.4f' % actualHiddenOutput1  )  
            print ('  The activations (actual outputs) for the two output neurons are:')
            print ('    actualOutput0 = %.4f' % actualOutput0)
            print ('    actualOutput1 = %.4f' % actualOutput1 )
            print ('  Initial SSE (before backpropagation) = %.6f' % SSEInitial)
            print ('  Corresponding SSE (from initial SSE determination) = %.6f' % SSE_Array[setNumber])     
  
# Perform first part of the backpropagation of weight changes    
        newVWeightArray = BackpropagateOutputToHidden (alpha, eta, errorList, actualAllNodesOutputList, 
        vWeightArray)

        newBiasOutputWeightArray = BackpropagateBiasOutputWeights (alpha, eta, errorList, actualAllNodesOutputList, 
        biasOutputWeightArray)
        newBiasOutputWeight0 = newBiasOutputWeightArray[0]
        newBiasOutputWeight1 = newBiasOutputWeightArray[1]
        
        newWWeightArray = BackpropagateHiddenToInput (alpha, eta, errorList, actualAllNodesOutputList, 
        inputDataList, vWeightArray, wWeightArray, biasHiddenWeightArray, biasOutputWeightArray)

        newBiasHiddenWeightArray = BackpropagateBiasHiddenWeights (alpha, eta, errorList, actualAllNodesOutputList, 
        vWeightArray, biasHiddenWeightArray, biasOutputWeightArray)
        newBiasHiddenWeight0 = newBiasHiddenWeightArray[0]
        newBiasHiddenWeight1 = newBiasHiddenWeightArray[1]        
        
        newBiasWeightArray = [[newBiasOutputWeight0, newBiasOutputWeight1], [newBiasHiddenWeight0, newBiasHiddenWeight1]] 

# Debug prints on the weight arrays
        debugWeightArrayOff = False
        if not debugWeightArrayOff:
            print (' ')
            print ('    The weights before backpropagation are:')
            print ('         Input-to-Hidden                           Hidden-to-Output')
            print ('    w(0,0) = %.3f   w(1,0) = %.3f         v(0,0) = %.3f   v(1,0) = %.3f' % (wWeightArray[0,0], 
            wWeightArray[0,1], vWeightArray[0,0], vWeightArray[0,1]))
            print ('    w(0,1) = %.3f   w(1,1) = %.3f         v(0,1) = %.3f   v(1,1) = %.3f' % (wWeightArray[1,0], 
            wWeightArray[1,1], vWeightArray[1,0], vWeightArray[1,1])    )         
            print (' ')
            print ('    The weights after backpropagation are:')
            print ('         Input-to-Hidden                           Hidden-to-Output')
            print ('    w(0,0) = %.3f   w(1,0) = %.3f         v(0,0) = %.3f   v(1,0) = %.3f' % (newWWeightArray[0,0], 
            newWWeightArray[0,1], newVWeightArray[0,0], newVWeightArray[0,1]))
            print ('    w(0,1) = %.3f   w(1,1) = %.3f         v(0,1) = %.3f   v(1,1) = %.3f' % (newWWeightArray[1,0], 
            newWWeightArray[1,1], newVWeightArray[1,0], newVWeightArray[1,1]))
            
      
            
# Assign the old hidden-to-output weight array to be the same as what was returned from the BP weight update
        vWeightArray = newVWeightArray[:]
    
# Assign the old input-to-hidden weight array to be the same as what was returned from the BP weight update
        wWeightArray = newWWeightArray[:]
    
# Run the computeSingleFeedforwardPass again, to compare the results after just adjusting the hidden-to-output weights
        newAllNodesOutputList = ComputeSingleFeedforwardPass (alpha, inputDataList, wWeightArray, vWeightArray,
        biasHiddenWeightArray, biasOutputWeightArray, debugComputeSingleFeedforwardPassOff)         
        newOutput0 = newAllNodesOutputList [2]
        newOutput1 = newAllNodesOutputList [3] 

# Determine the new error between actual and desired outputs
        newError0 = desiredOutput0 - newOutput0
        newError1 = desiredOutput1 - newOutput1
        newErrorList = (newError0, newError1)

# Compute the new Summed Squared Error, or SSE
        SSE0 = newError0**2
        SSE1 = newError1**2
        newSSE = SSE0 + SSE1

# Print the Summed Squared Error  

# Debug print the actual outputs from the two output neurons
        if not debugMainComputeForwardPassOutputsOff:
            print (' ')
            print ('In main; have just completed a single step of backpropagation with inputs', input0, input1)
            print ('    The new SSE (after backpropagation) = %.6f' % newSSE)
            print ('    Error(0) = %.4f,   Error(1) = %.4f' %(NewError0, NewError1))
            print ('    SSE(0) =   %.4f,   SSE(1) =   %.4f' % (SSE0, SSE1))
            deltaSSE = SSEInitial - newSSE
            print ('  The difference in initial and the resulting SSEs is: %.4f' % deltaSSE )
            if deltaSSE >0:
                print (' ')
                print ('   The training has resulted in improving the total SSEs')  
                      
# Assign the SSE to the SSE for the appropriate training set
        SSE_Array[setNumber] = newSSE

# Obtain the previous SSE Total from the SSE array
        previousSSE_Total = SSE_Array[4]
        print (' ' )
        print ('  The previous SSE Total was %.4f' % previousSSE_Total)

# Compute the new sum of SSEs (across all the different training sets)
#   ... this will be different because we've changed one of the SSE's
        newSSE_Total = SSE_Array[0] + SSE_Array[1] +SSE_Array[2] + SSE_Array[3]
        print ('  The new SSE Total was %.4f' % newSSE_Total)
        print ('    For node 0: Desired Output = ',desiredOutput0,  ' New Output = %.4f' % newOutput0 )
        print ('    For node 1: Desired Output = ',desiredOutput1,  ' New Output = %.4f' % newOutput1  )
        print ('    Error(0) = %.4f,   Error(1) = %.4f' %(newError0, newError1))
        print ('    SSE0(0) =   %.4f,   SSE(1) =   %.4f' % (SSE0, SSE1)    )            
# Assign the new SSE to the final place in the SSE array
        SSE_Array[4] = newSSE_Total
        deltaSSE = previousSSE_Total - newSSE_Total
        print ('  Delta in the SSEs is %.4f' % deltaSSE )
        if deltaSSE > 0:
            print ('SSE improvement')
        else: print ('NO improvement'  )   
                
                         
# Assign the new errors to the error list             
        errorList = newErrorList[:]
        
        
        print (' ')
        print ('Iteration number ', iteration)
        iteration = iteration + 1

        if newSSE_Total < epsilon:

            
            break
    print ('Out of while loop'  )   

    debugEndingSSEComparisonOff = False
    if not debugEndingSSEComparisonOff:
        SSE_Array[4] = newSSE_Total
        deltaSSE = previousSSE_Total - newSSE_Total
        print ('  Initial Total SSE = %.4f'  % SSE_InitialTotal)
        print ('  Final Total SSE = %.4f'  % newSSE_Total)
        finalDeltaSSE = SSE_InitialTotal - newSSE_Total
        print ('  Delta in the SSEs is %.4f' % finalDeltaSSE )
        if finalDeltaSSE > 0:
            print ('SSE total improvement')
        else: print ('NO improvement in total SSE' )

#    print ' '
#    print 'The initial weights for this neural network are:'
#    print '     Input-to-Hidden                       Hidden-to-Output'
#    print 'w(0,0) = %.3f   w(0,1) = %.3f         v(0,0) = %.3f   v(0,1) = %.3f' % (initialWWeightArray[0,0], 
#    initialWWeightArray[0,1], initialVWeightArray[0,0], initialVWeightArray[0,1])
#    print 'w(1,0) = %.3f   w(1,1) = %.3f         v(1,0) = %.3f   v(1,1) = %.3f' % (initialWWeightArray[1,0], 
#    initialWWeightArray[1,1], initialVWeightArray[1,0], initialVWeightArray[1,1])        

                                                                                    
#    print ' '
#    print 'The final weights for this neural network are:'
#    print '     Input-to-Hidden                       Hidden-to-Output'
#    print 'w(0,0) = %.3f   w(0,1) = %.3f         v(0,0) = %.3f   v(0,1) = %.3f' % (wWeightArray[0,0], 
#    wWeightArray[0,1], vWeightArray[0,0], vWeightArray[0,1])
#    print 'w(1,0) = %.3f   w(1,1) = %.3f         v(1,0) = %.3f   v(1,1) = %.3f' % (wWeightArray[1,0], 
#    wWeightArray[1,1], vWeightArray[1,0], vWeightArray[1,1])        
                                                                                    
   
# Print the SSE's at the beginning of training
#    print ' '
#    print 'The SSE values at the beginning of training were: '
#    print '  SSE_Initial[0] = %.4f' % SSE_InitialArray[0]
#    print '  SSE_Initial[1] = %.4f' % SSE_InitialArray[1]
#    print '  SSE_Initial[2] = %.4f' % SSE_InitialArray[2]
#    print '  SSE_Initial[3] = %.4f' % SSE_InitialArray[3]    
#    print ' '
#    print 'The total of the SSE values at the beginning of training is %.4f' % SSE_InitialTotal 


# Print the SSE's at the end of training
#    print ' '
#    print 'The SSE values at the end of training were: '
#    print '  SSE[0] = %.4f' % SSE_Array[0]
#    print '  SSE[1] = %.4f' % SSE_Array[1]
#    print '  SSE[2] = %.4f' % SSE_Array[2]
#    print '  SSE[3] = %.4f' % SSE_Array[3]    
#    print ' '
#    print 'The total of the SSE values at the end of training is %.4f' % SSE_Array[4]                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        
# Print comparison of previous and new outputs             
#    print ' ' 
#    print 'Values for the new outputs compared with previous, given only a partial backpropagation training:'
#    print '     Old:', '   ', 'New:', '   ', 'nu*Delta:'
#    print 'Output 0:  Desired = ', desiredOutput0, 'Old actual =  %.4f' % actualOutput0, 'Newactual  %.4f' % newOutput0
#    print 'Output 1:  Desired = ', desiredOutput1, 'Old actual =  %.4f' % actualOutput1, 'Newactual  %.4f' % newOutput1                                                                         
                                                            
                     
####################################################################################################
# Conclude specification of the MAIN procedure
####################################################################################################                
    
if __name__ == "__main__": main()

####################################################################################################
# End program
#################################################################################################### 