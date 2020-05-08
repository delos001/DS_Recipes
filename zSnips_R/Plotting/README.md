## Add-ins
- install.packages('ggThemeAssist')
- devtools::install_github('cardiomoon/editData')
- devtools::install_github('cardiomoon/ggplotAssist')

## Basic Info

```
Specs for multigraph pages

Specify column or row numbers
par(mfrow=c(2,2))
par(mcol=c(2,2))

Other options:
mar=c(4.5, 4.5, 1,1), 
oma=c(0,0,4,0))
```

## Base R Plotting
|Syntax|Description|
|---|---|
|hist(x)|histogram|
|boxplot(x)|boxplot|
|plot(x,y)|scatter plot|
|pairs(x)|scatter plot matrix|
|barplot(x)|bar graph|
|pie(x)|pie chart|


## Base R Legend Example
```
legend("topleft",   # position
	lty=1,   # type
	col=c("red", "blue", "green"),
       # legend contents
       # 'expression' tells R to use alpha symbol
       c("orig data", 
	        expression(alpha==0.2), 
	        expression(alpha==0.5), 
	        expression(alpha==0.8)),
       pch=1)  # size
```
