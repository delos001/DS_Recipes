# A type of hierarchal clustering linkage
# get average (not min or max distances)


plot(hclust(as.dist(illustration.data),
            'complete'), col = 4)


cutree(hclust(as.dist(illustration.data),
              'complete'), 2)

  
  
## NEED TO FIND FULL EXAMPLE
