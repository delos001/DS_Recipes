# Generate Random Strings and Numbers


#create sample df (for demo purposes)
a = c(1, 2, 3, 4, 5, 8, 8)
b = c(2, 3, 4, 5, 6, 8, 8)
ab = cbind(a,b)
row.names(ab) = c('a', 'b')
ab


library(stringi)

#function generates a list of random number+character strings

idGenerator <- function(n, lengthId) { 
  set.seed(123)
  idList <- stringi::stri_rand_strings(n, lengthId, pattern = "[A-Za-z0-9]") 
  
  while(any(duplicated(idList))) { 
    
    idList[which(duplicated(idList))] <- 
      stringi::stri_rand_strings(sum(duplicated(idList), 
                                     na.rm = TRUE), 
                                 lengthId, 
                                 pattern = "[A-Za-z0-9]") } 
  
  return(idList) }

# use nrow to generate enough random strings to match a df
idGenerator(nrow(ab), 10)
