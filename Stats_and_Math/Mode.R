

mode<-function(a){
     b<-as.factor(a)
     freq<-summary(b)
     mode<-names(freq)[freq[names(freq)]==max(freq)]
     as.numeric(mode)
}
mode(y)
