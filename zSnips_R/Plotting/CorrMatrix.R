
#----------------------------------------------------------
# SIMPLE EXAMPLE
# example to plot variables against a specified variable.  
# This loops through and procudes 3x3 matrix so they are easier to read
#----------------------------------------------------------
#plot correlation plots for dep vs. indep variables
par(mfrow = c(3,3))
par(mar = c(5,6,4,1) + .1)
for (i in colNames1){
  plot(feat_eda$total_cases, 
       feat_eda[,c(i)], 
       ylab=i, 
       col=feat_eda$city)
  legend("bottomright", 
         legend=levels(feat_eda$city), 
         col = 1:length(feat_eda$city), 
         pch = 1)
}
par(mfrow = c(1,1))
cor_mat = data.frame(round(cor(feat_eda[,9:27]),2))


#----------------------------------------------------------
# HEAT MAPP CORR MATRIX WITH ONLY TOP OR BOTTOM OF MATRIX
# http://www.sthda.com/english/wiki/ggplot2-quick-correlation-matrix-heatmap-r-software-and-data-visualization
#----------------------------------------------------------
library(reshape2) 
library(ggplot2)

#to use ggplot heat map, first create corr matrix

cont_cols = c(2, 13:24) #define the continuous columns

cormat = round(cor(data1[, cont_cols]), 2) 

melted_cormat = melt(cormat) #use reshape to 'melt' the cor matrix

# this gives you matrix but has redundant top and bottom
ggplot(data = melted_cormat, 
       aes(x=Var1, 
           y=Var2, 
           fill=value)) + 
geom_tile()

# Function to get lower triangle of the correlation matrix
get_lower_tri <- function(cormat){
  cormat[upper.tri(cormat)] <- NA
  return(cormat)
}

# Function to get upper triangle of the correlation matrix
get_upper_tri <- function(cormat){
  cormat[lower.tri(cormat)]<- NA
  return(cormat)
}

# using function defined above, get upper triangle
# to get the lower (or upper) triangle
lower_tri <- get_lower_tri(cormat)

#repeat process to build heat map like above, but with lower matrix
melted_cormat = melt(lower_tri, na.rm = TRUE) #melt the upper matrix

ggplot(data=melted_cormat, 
       aes(Var2, 
           Var1, 
           fill=value)) +
      geom_tile(color = 'white') + 
      scale_fill_gradient2(low = 'blue', 
                           high='red', 
                           mid='white',
                           midpoint=0, 
                           limit=c(-1,1), 
                           space='Lab',
                           name = "Pearson\nCorrelation") +
theme_minimal() + 
theme(axis.text.x = element_text(angle = 45, 
                                 vjust=1, 
                                 size=12, 
                                 hjust = 1)) +
coord_fixed()
