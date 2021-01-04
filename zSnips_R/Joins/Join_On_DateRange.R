

library(data.table)

X <- data.table(beginning = 
                  as.Date(c('2010-01-15', '2010-01-24', '2010-01-15', 
                            '2010-01-24', '2010-01-15')), 
                ending = 
                  as.Date(c('2010-01-22','2010-01-28','2010-01-22',
                            '2010-01-28', '2010-01-22')),
                name = c('001','001','002','002', '003'))

Y <- data.table(aDate = 
                  as.Date(c('2010-01-23', '2010-01-26', '2010-01-17', 
                            '2010-01-27', '2010-01-23')),
                name = c('001','001','002','002', '003'),
                other = c('a', 'b', 'c', 'd', 'e'))



##  X = left, Y = right:  this is Left Join (reverse for Right)
## Use Y[!X, on = .(name, foo, etc)] for antijoin
testjoin = Y[X,  
              .(name, ## chose columns to keep (i.colName gets cols from X)
                beginning, ending, 
                other, 
                Y$aDate), 
              nomatch = NA,  ## use nomatch = 0 for inner join
              on = .(name, aDate >= beginning, aDate <= ending)]

testjoin


