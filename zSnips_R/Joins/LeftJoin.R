

library(dplyr)
 DF2 <- DF2 %<%
   left_join(DF1, 
             DF2[,c('cola', 
                    'colb',
                    'Client')],
             by = "Client")




stCOVCX = clCOVCX %>%
  select(KeyColumnName., OtherColumns) %>% 
  left_join(stSVsiteno[,c(1:3)], 
            by = c('KeyColumnName' = 'Site_fix'))
