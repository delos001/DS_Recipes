# IN THIS SCRIPT:
# CUT



#----------------------------------------------------------
# cut indentifies which interval each data point will fall into
cells <- seq(from = 0.0, to = 3.5, by = 0.5)
center <- seq(from = 0.25, to = 3.25, by =  0.5)
class <- cut(mag, cells, include.lowest=TRUE, right = FALSE)
