# Forward Surgical Team Operating Room Scheduling Problem

"""
This Python code formulates and solves the FST OR Scheduling Problem for
MASCAL events using Integer Linear Programming with Gurobi Python.
"""

# Import the necessary Python packages
import copy
from gurobipy import *

# Define the matrix of sequence-dependent surgery setup times (5 CAT-A)
sm = [[0,20,15,8,6],
      [15,0,18,9,28],
      [24,23,0,13,13],
      [15,27,8,0,14],
      [8,17,24,15,0]]
      
# Define the matrix of sequence-dependent surgery setup times (10 CAT-A)
md = [[0,9,12,26,11,24,12,13,17,15],
      [24,0,28,23,22,5,7,18,9,23],
      [19,30,0,30,15,22,25,15,28,15],
      [18,10,27,0,28,12,16,19,22,7],
      [5,16,11,7,0,25,27,30,23,15],
      [7,26,6,17,6,0,28,10,13,28],
      [23,26,20,20,24,30,0,16,18,27],
      [23,20,22,8,18,10,14,0,14,12],
      [7,13,9,19,29,27,18,23,0,30],
      [16,10,11,11,28,26,6,11,12,0]]

# Define the matrix of sequence-dependent surgery setup times (15 CAT-A)       
lg = [[0,15,27,7,19,7,22,26,29,6,5,18,30,11,25],
      [24,0,9,23,21,15,25,8,8,9,16,26,22,8,16],
      [22,5,0,28,14,22,30,7,22,26,8,5,25,22,14],
      [6,20,13,0,23,17,5,17,11,15,30,30,26,21,26],
      [27,18,19,17,0,29,18,26,12,22,16,17,14,24,10],
      [8,29,21,8,14,0,6,27,25,14,22,13,14,7,9],
      [24,24,5,25,16,27,0,24,8,24,12,15,26,29,28],
      [16,23,10,13,6,9,15,0,14,12,9,21,14,17,23],
      [5,23,26,18,21,12,28,29,0,8,6,27,23,11,10],
      [18,18,17,7,7,8,12,13,28,0,20,5,27,25,29],
      [10,18,28,26,24,15,17,21,25,25,0,30,16,15,20],
      [28,15,17,6,28,30,17,23,14,22,6,0,27,19,28],
      [10,19,27,25,17,28,18,25,8,25,13,17,0,7,28],
      [12,10,25,26,22,7,20,18,16,25,19,24,19,0,16],
      [11,28,13,22,10,21,23,24,19,23,19,16,19,19,0]]
  
# Apply ILP to the N CAT-A patient instance.
# Sub-schedule elimination based on tsp.py example on Gurobi website
# Copyright 2013, Gurobi Optimization, Inc

# Get the instance data
N = input("Enter the number of CAT-A patients (5, 10 or 15): ")
n = int(copy.deepcopy(N))
if n == 5:
    instance = copy.deepcopy(sm)
elif n == 10:
    instance = copy.deepcopy(md)
else: instance = copy.deepcopy(lg)

# Callback function - use lazy constraints to eliminate sub-schedules
def subschedelim(model, where):
    if where == GRB.callback.MIPSOL:
        selected = []
        # make a list of edges selected in the solution
        for i in range(n):
            sol = model.cbGetSolution([model._vars[i,j] for j in range(n)])
            selected += [(i,j) for j in range(n) if sol[j] > 0.5]
        # find the shortest cycle in the selected edge list
        tour = subsched(selected)
        if len(tour) < n:
            # add a subschedule elimination constraint
            expr = 0
            for i in range(len(tour)):
                for j in range(i+1, len(tour)):
                    expr += model._vars[tour[i], tour[j]]
            expr += model._vars[tour[len(tour)-1], tour[0]]
            model.cbLazy(expr <= len(tour)-1)
            
# Given a list of edges, finds the shortest sub-schedule
def subsched(edges):
    visited = [False]*n
    cycles = []
    lengths = []
    selected2 = [[] for i in range(n)]
    for x,y in edges:
        selected2[x].append(y)
    while True:
        current = visited.index(False)
        thiscycle = [current]
        while True:
            visited[current] = True
            neighbors = [x for x in selected2[current] if not visited[x]]
            if len(neighbors) == 0:
                break
            current = neighbors[0]
            thiscycle.append(current)
        cycles.append(thiscycle)
        lengths.append(len(thiscycle))
        if sum(lengths) == n:
            break
    return cycles[lengths.index(min(lengths))]

m = Model()

# Create variables
vars = {}
for i in range(n):
    for j in range(n):
        vars[i,j] = m.addVar(obj=instance[i][j], vtype=GRB.BINARY, name='['+str(i)+','+str(j)+']')
m.update()

# Add degree-2 constraint and forbid single node 'self' loops
for i in range(n):
    m.addConstr(quicksum(vars[i,j] for j in range(n)) == 1)
    vars[i,i].ub = 0
for j in range(n):
    m.addConstr(quicksum(vars[i,j] for i in range(n)) == 1)
    
m.update()

# Optimize ILP Model
m._vars = vars
m.params.OutputFlag = 0         # turn off the optimization results on screen
m.params.LazyConstraints = 1    # turn on to use lazy callbacks
m.optimize(subschedelim)        # add sub-schedule elimination constraints, if needed
solution = m.getAttr('x', vars)
selected = [(i,j) for i in range(n) for j in range(n) if solution[i,j] > 0.5]
assert len(subsched(selected)) == n

# Print the results        
print ("")
print ("")
print ("Integer Linear Programming Results")   
print ("Total Surgical Setup Time (min)  = ", int(m.objVal))
print ("Edges Selected in Optimal Solution = ", selected)