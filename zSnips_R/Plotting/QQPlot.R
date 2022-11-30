




par(mfrow = c(1,2))

qqnorm(food[food[,7]== "M",8], 
       ylab = "Sample Quantiles of Ratio for Metro Areas",
       main = "Q-Q Plot of Ratio for Metro Areas", 
       col = "red")

food[,7]=='M'
food[food[,7]=="M",8]

qqline(food[food[,7]== "M",8], 
       col = "green")

qqnorm(food[food[,7]== "NM",8], 
       lab = "Sample Quantiles of Ratio for Not-Metro Areas",
       main = "Q-Q Plot of Ratio for Non-Metro Areas", col = "red")
       
food[,7]=='NM'
food[food[,7]=="NM",8]

qqline(food[food[,7]== "NM",8], 
       col = "green")

par(mfrow = c(1,1))


#----------------------------------------------------------
#----------------------------------------------------------
# GGPLOT
#----------------------------------------------------------
#----------------------------------------------------------
#----------------------------------------------------------
# EXAMPLE: LOOP THROUGH ALL VARIABLES
qqf = function(q) {
  Q = list()
  colNames3 = names(feat_eda[5:23])
  for (k in colNames3){
         q = ggplot(aes_string(sample = k), 
                    feat_eda) + 
         stat_qq() + 
         stat_qq_line() + 
         ylab(k)
         Q = c(Q, list(q))
  }
       return(list(plots=Q, num=length(vars)))
}
QPlots = qqf(q)

#call each graph in 3x3 groups (can't figure out how to make do.call go to next page)
do.call(grid.arrange, c(QPlots$plots[1:7], ncol=3, nrow=3))
do.call(grid.arrange, c(QPlots$plots[8:14], ncol=3, nrow=3))
do.call(grid.arrange, c(QPlots$plots[15:19], ncol=3, nrow=3))

#----------------------------------------------------------
# EXAMPLE: LOOP THROUGH ALL CATEGORICAL VARS
#QQPlot by city

qqf = function(q) {
  Q = list()
  colNames3 = names(feat_eda[5:23])
  for (k in colNames3){
         q = ggplot(aes_string(sample = k, 
                               color="city"),
                    feat_eda, ) + 
         stat_qq() + 
         stat_qq_line() + 
         ylab(k)
         Q = c(Q, list(q))
  }
       return(list(plots=Q, num=length(vars)))
}
QPlots = qqf(q)

#call each graph in 3x3 groups (can't figure out how to make do.call go to next page)
do.call(grid.arrange, c(QPlots$plots[1:7], ncol=3, nrow=3))
do.call(grid.arrange, c(QPlots$plots[8:14], ncol=3, nrow=3))
do.call(grid.arrange, c(QPlots$plots[15:19], ncol=3, nrow=3))
