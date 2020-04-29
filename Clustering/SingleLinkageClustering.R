

# A type of hierarchal clustering linkage
# look for smallest difference
# https://www.youtube.com/watch?v=RdT7bhm1M3E

plot(hclust(as.dist(illustration.data),
            'complete'), col = 4)


cutree(hclust(as.dist(illustration.data),
              'complete'), 2)

  
  
## NEED TO FIND FULL EXAMPLE
