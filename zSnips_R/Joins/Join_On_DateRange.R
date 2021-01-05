
## Joining on range of dates
##   In this snippet, 3 diff methods for date joining
##      1: data.table
##      2: sqldf
##      3: fuzz join



##------------------------------------------------------------------------------
## Data.table date range join
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



##------------------------------------------------------------------------------
## sqldf date range join
##    left and right join and also a full outer join which isn't complete



library(sqldf)

A <- data.frame(beginning = 
                  as.Date(c('2010-01-15', '2010-01-24', '2010-01-15', 
                            '2010-01-24', '2010-01-15')), 
                ending = 
                  as.Date(c('2010-01-22','2010-01-28','2010-01-22',
                            '2010-01-28', '2010-01-22')),
                name = c('001','001','002','002', '005'))

B <- data.frame(aDate = 
                  as.Date(c('2010-01-23', '2010-01-26', '2010-01-17', 
                            '2010-01-27', '2010-01-23')),
                name = c('001','001','002','002', '003'),
                other = c('a', 'b', 'c', 'd', 'e'))

## join A on B where aDate is between the beginning and ending dates in A
sqldatejoin = sqldf('select * from B
                    left outer join A
                    on B.aDate between A.beginning and A.ending')

sqldatejoin

## same but reverse the tables.  Notice the difference in outputs
sqldatejoin2 = sqldf('select * from A
                    left outer join B
                    on B.aDate between A.beginning and A.ending')

sqldatejoin2



##  Example of full outer join ****Need to look up the sql joins*****
##  performing full outer join requires extra steps:
##     https://stackoverflow.com/questions/16964799/how-can-i-perform-full-outer-joins-of-large-data-sets-in-r
dat1 <- data.frame(x = 1:5,y = letters[1:5])
dat2 <- data.frame(w = 3:8,z = letters[3:8])

sqldf("select * from dat1 left outer join dat2 on dat1.x = dat2.w UNION 
      select * from dat2 left outer join dat1 on dat1.x = dat2.w")


## using same sample data as above:
## note: this isn't final output.  Union mixes up columns  **NEED TO FIX
sqldatejoin3 = sqldf('select * from A 
                     left outer join B 
                     on B.aDate between A.beginning and A.ending UNION 
                     select * from B 
                     left outer join A 
                     on B.aDate between A.beginning and A.ending')

