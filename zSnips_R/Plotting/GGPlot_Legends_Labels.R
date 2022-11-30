

#------------------------------------------------------------------------
# WRAP TEXT IN LEGEND BY STRING LENGTH
ggplot(stIPCOMP_COMB1,
       aes(x = SDRGREAS, 
	   fill = str_wrap(EXTRT, 20))) +
	geom_bar() + 
  ggtitle(label = "Count of IP Stop by Reason") +
  labs(y = 'Count',
       x = "",
       fill = "EXTRT") + 

 theme(legend.key.height = unit(1, "cm")) # specify height of each legend element




#------------------------------------------------------------------------
# WRAP TEXT IN LEGEND BY STRING LENGTH EXAMPLE 2
```{r echo=FALSE}
stIPCOMP_COMB1 = stIPCOMP_COMB %>% 
filter(SDRGYN == "No")
ggplot(stIPCOMP_COMB1,aes(x = Site, 
			  fill = str_wrap(SDRGREAS, 20))) +
	geom_bar() + 
  ggtitle(label = "Count of IP Stop Reason by Site") +
  labs(y = 'Count',
       x = "", 
       fill = 'Site') + 
  geom_text(aes(label = ..count..),
            stat = 'count',
            size = 3,
            position = position_stack(vjust = 0.5)) +
  theme_gray() +
  theme(legend.key.height = unit(1, "cm"),  
	axis.text.x = element_text(angle = 45, 
				   hjust = 1))
```



#------------------------------------------------------------------------
#------------------------------------------------------------------------
# LABELS
#------------------------------------------------------------------------
#------------------------------------------------------------------------

#------------------------------------------------------------------------
# WRAP TEXT IN AXIS LABELS WITH FUNCTION
```{r echo=FALSE}
stIPCOMP_COMB1 = stIPCOMP_COMB %>% 
filter(SDRGYN == "No")
ggplot(stIPCOMP_COMB1,aes(x = Site, 
			  fill = str_wrap(EXTRT, 20))) +
	geom_bar() + 
  ggtitle(label = "Count of IP Stop by Site") +
  labs(y = 'Count',
       x = "",
       fill = "EXTRT") + 
  scale_x_discrete(labels = function(x) lapply(strwrap(x, 
						       width = 10, 
						       simplify = FALSE), 
					       paste, 
					       collapse = "\n")) +
  geom_text(aes(label = ..count..),
            stat = 'count',
            size = 3,
            position = position_stack(vjust = 0.5)) +
  
  theme(legend.key.height = unit(1, "cm"), 
        axis.text.x = element_text(angle = 45, 
				   hjust = 1))
		   
		   
#------------------------------------------------------------------------
# WRAP TEXT IN AXIS LABELS WITH FUNCTION EXAMPLE 2		   
```{r echo=FALSE}
stIPACCT2_TAF2 = stIPACCT2_TAF %>% 
		   filter(Compliance < 70)
ggplot(stIPACCT2_TAF2,aes(x = Site,
			  fill = SiteGroup)) +
	geom_bar() +
    ggtitle(label = "Patient Count: TAF Compliance <70 (IPDuration >30d)") +
  labs(y = 'Count',
       x = "Site",
       fill = "SiteGroup") + 
  scale_x_discrete(labels = function(x) lapply(strwrap(x, 						       
						       width = 10,
						       simplify = FALSE),
					       paste, 
					       collapse = "\n")) +
  geom_text(aes(label = ..count..),
            stat = 'count',
            size = 3,
            position = position_stack(vjust = 0.5)) +
  
  theme(legend.key.height = unit(1, "cm"), 
        axis.text.x = element_text(angle = 45, 
				   hjust = 1))
```
		   
		
