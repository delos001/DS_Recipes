lpkgs = c('dplyr', 'purrr')

for(pkg in lpkgs) {
  
  if (!require(pkg, character.only = TRUE)) {
    install.packages(pkg)
    library(pkg, character.only = TRUE)
  }
}

## 2 df's: need each row in dfVisits to be 'assigned' to each site in dfSite

## sample data
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

## Solutions using purrr mapping
testMap3 = purrr::map2_df(dfSubject, t(dfVisits), function(x, y){
  data.frame(Subject = x, Visit = y)
  }) %>%
  dplyr::arrange(Subject)  


# JOIN solution 1: id as an index ----------------------------------------------
# this assigns a value one to every row inside an `id` column (essentially 
# providing the `glue` for these two data.frames to stick together with)
dfSubject$id = 1
dfVisits$id = 1

# if we full join, we get all possible combinations of 
full_join(dfVisits, dfSubject, by = "id") %>% 
  dplyr::arrange(Subject)  # we can just drop the id column as necessary


# JOIN solution 2: with sequential ids ---------------------------------------------
# here we add a sequential id, which is identical to the number of rows in the 
# data.frame
dfSubject <- dfSubject %>% 
  mutate(seq_id = row_number())

dfVisits <- dfVisits %>% 
  mutate(seq_id = row_number())


# if we full join now, we will see a data.frame with 4 rows (but a missing value
# for the un-matched Visit)

# we'll drop the id column here for clarity
dfVisits <- dfVisits %>% select(-id)
dfSubject <- dfSubject %>% select(-id)

full_join(dfVisits, dfSubject, 
          by = "seq_id") %>%  
  dplyr::arrange(Subject)

# if we inner join, we only get three rows because it only includes seq_id 
# matches that are in both tables. 
inner_join(dfVisits, dfSubject, 
          by = "seq_id") %>%  
  dplyr::arrange(Subject)

