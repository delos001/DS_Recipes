

## 2 df's: need each row in dfVisits to be 'assigned' to each site in dfSite

dfSite = data.frame(Site = c('1001', '1002', '1003', '1004'))
dfVisits = data.frame(Visits = c('Scr', 'BL', 'D1'))

## so it would look like the following dataframe:
##  Site  Visit
##  1001  Scr
##  1001  BL
##  1001  D1
##  1002  Scr
##  1002  BL
##  1002  D1
## etc...

lpkgs = c('dplyr', 'purrr')

for(pkg in lpkgs) {
  
  if (!require(pkg, character.only = TRUE)) {
    install.packages(pkg)
    library(pkg, character.only = TRUE)
  }
}

## solution:
testMap2 = purrr::map2_df(dfSite, dfVisits, function(x, y){
  data.frame(dfSite = x, dfVisits = y )
}) %>%
  dplyr::arrange(dfSite)
