


library(MASS)
parcoord(iris[1:4], col=iris$Species)


library(lattice)
parallelplot(~iris[1:4] | Species, data=iris)
