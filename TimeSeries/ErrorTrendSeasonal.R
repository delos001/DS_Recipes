

# NOTE: this cannot handle frequency >24 (need to use stlf)


ets(y, model="ZZZ", damped=NULL, alpha=NULL, beta=NULL,
    gamma=NULL, phi=NULL, additive.only=FALSE, lambda=NULL,
    lower=c(rep(0.0001,3), 0.8), upper=c(rep(0.9999,3),0.98),
    opt.crit=c("lik","amse","mse","sigma","mae"), nmse=3,
    bounds=c("both","usual","admissible"),
    ic=c("aicc","aic","bic"), restrict=TRUE)



























flu_stlf_forecast = forecast(flu_stlf, h=ifelse(flu_stlf$m>1, 2*flu_stlf$m, 10), 
                             level=c(80,95), fan=FALSE, simulate=FALSE,
                             bootstrap="FALSE", npaths=5000, PI=TRUE,
                             lambda=flu_stlf$lambda)


















fit <- ets(flu_stlf, model="ANN")
plot(forecast(fit, h=3), ylab="Oil (millions of tones)")
fit$par

summary(fit)
