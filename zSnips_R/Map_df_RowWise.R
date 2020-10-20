lpkgs = c('dplyr', 'purrr')

for(pkg in lpkgs) {
  
  if (!require(pkg, character.only = TRUE)) {
    install.packages(pkg)
    library(pkg, character.only = TRUE)
  }
}

## 2 df's: need each row in dfVisits to be 'assigned' to each site in dfSite

dfSubject = data.frame(Subject = c('1001', '1002', '1003', '1004'))
dfVisits = data.frame(Visits = c('Scr', 'BL', 'D1', 'D2', 'W1', 'W2', 'W3'))

## so it would look like the following dataframe:
##  Site  Visit
##  1001  Scr
##  1001  BL
##  1001  D1
##  1002  Scr
##  1002  BL
##  1002  D1
## etc...


testMap3 = purrr::map2_df(dfSubject, t(dfVisits), function(x, y){
  data.frame(Subject = x, Visit = y)
  }) %>%
  dplyr::arrange(Subject)
