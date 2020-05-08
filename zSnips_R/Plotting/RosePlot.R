


```{r echo=FALSE, results = 'asis'}
ggplot(stSUBJp,aes(x = Status,
		   fill = Status)) +
geom_bar(color = 'black',
	 size = 0.1,
	 width = 1) +
scale_fill_brewer(palette = 'Reds',
		  direction = -1) +
ggtitle("Subject Status Count") +
coord_polar() +
geom_text(aes(label = ..count..), stat = 'count')
```
