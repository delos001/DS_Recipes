
# The “while” loop tells R that we want to conduct a task while a condition is true. 
# The format is simple: 
while (a condition is true){ 
	…paramater that must be met
	…program statements… 
}


#----------------------------------------------------------
# BASIC EXAMPLE
y <- 1
while(y <= 5) {
	print(factorial(y))
	y <- y + 1
}

# [1] 1
# [1] 2
# [1] 6
# [1] 24
# [1] 120

#----------------------------------------------------------
# BASIC EXAMPLE 2
# sets k to increase incrementally until its no longer > 10
sum <- 0
k <- 1
while(k <= 10){
	sum <- sum + k
	k <- k + 1
}
sum
