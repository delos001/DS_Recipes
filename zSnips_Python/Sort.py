
#--------------------------------------------------------
## Iterative sorting function 
arr = [5, 19, 5, 99, 30, 3, 20, 21]

def quicksort(arr):
    if len(arr) <= 1:
        return arr
    pivot = arr[len(arr) // 2]
    left = [x for x in arr if x < pivot]
    middle = [x for x in arr if x == pivot]
    right = [x for x in arr if x > pivot]
    return quicksort(left) + middle + quicksort(right)

#print(quicksort([3,6,8,10,1,2,19,20,1,5,50,99]))
print(quicksort(arr))



#--------------------------------------------------------

Names=["jason", "michael", "delosh"]
Names.sort()  # Sorts A-Z: delosh jason michael
