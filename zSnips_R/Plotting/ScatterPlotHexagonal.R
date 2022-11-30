

#----------------------------------------------------------
# EXAMPLE
# https://ggplot2.tidyverse.org/reference/geom_hex.html

d <- ggplot(diamonds, aes(carat, price))
d + geom_hex()
d + geom_hex(bins = 10)
d + geom_hex(binwidth = c(1, 1000))  # specify bin width: changes hexago shape/size
d + geom_hex(binwidth = c(.1, 500))




#----------------------------------------------------------
# EXAMPLE 2
ggplot(df, (aes(x=x, y=y)))+
	stat_binhex(color='white') +
	theme_bw() +
	scale_fill_gradient(low = 'white', high = 'black') +
labs(x = 'Xlabel', y = 'Ylabel')
