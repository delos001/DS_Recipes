
#------------------------------------------------------------------
# GRID ARRANGE EXAMPLE
Library(gridExtra)
grid.arrange(
ggplot(mydata,aes(x=mydata$CLASS,y=mydata$VOLUMEc))+
    geom_boxplot(outlier.color='red',
                 outlier.shape =1, outlier.size=3,
                 notch=TRUE)+
  ylab('Volume (cm^3)')+xlab('Class'),

ggplot(mydata,aes(x=mydata$CLASS,y=mydata$WHOLE))+
  geom_boxplot(outlier.color='red',
               outlier.shape =1, outlier.size=3,
               notch=TRUE)+
    ylab('Whole (g)') + xlab('Class'),
nrow=1,top='Volume and Whole Distribution Grouped by Class')




#------------------------------------------------------------------
# FACET WRAP EXAMPLE
``{r echo=FALSE}
ggplot(stSUBJp, aes(x = SEX, fill = SEX)) +
  geom_bar(alpha = 0.7) +
  facet_wrap(~SiteGroup, ncol = 2, scales = 'free_y') +
  #facet_grid(~SiteGroup)
  #facet_grid(SiteGroup~.)
  #scale_fill_viridis_d() + 
  geom_text(aes(label = ..count..),
            stat = 'count',
            size = 3,
            position = position_stack(vjust = 0.5)) +
  ggtitle("Sex by Country") +
  labs(y = 'Frequency',
       x = 'Sex') +
  theme_gray()
```


#------------------------------------------------------------------
# FACET WRAP EXAMPLE 2
```{r echo=FALSE}
ggplot(stSUBJp, aes(x = AGE)) +
  geom_histogram(binwidth = 5,  color = "black", fill = "light blue") +
  facet_wrap(~SiteGroup, ncol = 2) +
  #facet_grid(~SiteGroup)
  #facet_grid(SiteGroup~.)
  geom_vline(data = stSUBJg, aes(xintercept = Age_av, color = 'global'),
             linetype = 'dashed', size = .75) +
  geom_vline(data = stSUBJc, aes(xintercept = Age_av, color = 'country'),
             linetype = 'dashed', size = .5) +
  scale_color_manual(name = 'Av Age', 
                     values = c(global = 'green', country = 'red')) + 
  ggtitle("Age Distribution by Country") +
  labs(y = 'Frequency',
       x = 'Age (binwidth = 5)') +
  theme_gray()
```


#------------------------------------------------------------------
# FACET WRAP EXAMPLE 3
# with geom lines
```{r echo=FALSE}
ggplot(stAEp,aes(y = AEperMOS,x = Site,fill = SiteGroup)) +
	geom_boxplot(outlier.colour = 'red',
	             outlier.shape = 6,
	             notch = FALSE,notchwidth = 0.1,
	             varwidth = TRUE) +
  facet_wrap(~SiteGroup, ncol = 3, scales = 'free') +
	geom_hline(aes(yintercept = AEperMOS_g, color = 'Global'), 
	           linetype = 'dashed',
	           data = stAEg) +
  scale_color_manual(name = 'Average', 
                   values = c('red')) + 
  ggtitle(label = "AE per Month on Study") +
  theme_gray() +
  theme(axis.text.x = element_text(angle = 90, hjust = 0.5))
