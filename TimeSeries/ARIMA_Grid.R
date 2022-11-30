

# This example uses grid to run arima model through specified ranges

pvar = 1:3
dvar = 1:3
qvar = 1:3

OrderGrid = expand.grid(pvar, dvar, qvar)

ModFit = function(x, dat){
  m = Arima(dat, order = c(x[[1]], x[[2]], x[[3]]))
  return (m)
}

Fits = plyr::alply(OrderGrid, 1, ModFit, dat = apple)

aicc = data.frame(sapply(Fits, function(x), x$aicc))
AIC = data.frame(sapply(Fits, function(x), x$AIC))
BIC = data.frame(sapply(Fits, function(x), x$BIC))
model = data.frame(sapply(names(Fits), function(x), paste(Fits[[x]])))

names(aicc)[1] = paste('aicc')
names(AIC)[1] = paste('AIC')
names(BIC)[1] = paste('BIC')
names(model)[1] = paste('model')

perf = cbind(model, AIC, BIC, aicc)
perf
