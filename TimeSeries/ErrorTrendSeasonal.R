

# NOTE: this cannot handle frequency >24 (need to use stlf: 
#       Seasonal and Trend decomposition using Loess Forecasting)
# ETS parameters
# Model: A three-letter code indicating the model to be estimated 
#       using the ETS classification and notation. The possible 
#       inputs are “N” for none, “A” for additive, “M” for 
#       multiplicative, or “Z” for automatic selection. If any of 
#       the inputs is left as “Z” then this component is selected 
#       according to the information criterion chosen. The default 
#       value of ZZZ ensures that all components are selected using 
#       the information criterion.
# Damped: If damped=TRUE, then a damped trend will be used (either 
#       Ad or Md). If damped=FALSE, then a non-damped trend will used. 
#       If damped=NULL (the default), then either a damped or a non-damped 
#       trend will be selected according to the information criterion chosen.
# alpha, beta, gamma, phi: The values of the smoothing parameters can be 
#       specified using these arguments. If they are set to NULL (the 
#       default setting for each of them), the parameters are estimated.
# additive.only: Only models with additive components will be considered 
#       if additive.only=TRUE. Otherwise all models will be considered.
# lambda: Box-Cox transformation parameter. It will be ignored if 
#       lambda=NULL (the default value). Otherwise, the time series 
#       will be transformed before the model is estimated. When lambda 
#       is not NULL, additive.only is set to TRUE.
# lower, upper: Lower and upper bounds for the parameter estimates αα, 
#       β∗β∗, γ∗γ∗ and ϕϕ.
# opt.crit: The optimization criterion to be used for estimation. The 
#       default setting is maximum likelihood estimation, used when 
#       opt.crit=lik.
# bounds: This specifies the constraints to be used on the parameters. 
#       The traditional constraints are set using bounds="usual" and the 
#       admissible constraints are set using bounds="admissible". The 
#       default (bounds="both") requires the parameters to satisfy both 
#       sets of constraints.
# ic: The information criterion to be used in selecting models, set by 
#       default to aicc.
# restrict: If restrict=TRUE (the default), the models that cause numerical 
#       difficulties are not considered in model selection.

ets(y, model="ZZZ", 
    damped=NULL, 
    alpha=NULL, 
    beta=NULL,
    gamma=NULL, 
    phi=NULL, 
    additive.only=FALSE, 
    lambda=NULL,
    lower=c(rep(0.0001,3), 0.8), 
    upper=c(rep(0.9999,3),0.98),
    opt.crit=c("lik","amse","mse","sigma","mae"), 
    nmse=3,
    bounds=c("both","usual","admissible"),
    ic=c("aicc","aic","bic"), 
    restrict=TRUE)


# Forcast parameters
# object: The object returned by the ets() function.
# h:  The forecast horizon — the number of periods to be forecast.
# level: The confidence level for the prediction intervals.
# fan: If fan=TRUE, level=seq(50,99,by=1). This is suitable for 
#       fan plots.
# simulate: If simulate=TRUE, prediction intervals are produced 
#       by simulation rather than using algebraic formulae. 
#       Simulation will be used even if simulate=FALSE if there are 
#       no algebraic formulae available for the particular model.
# bootstrap: If bootstrap=TRUE and simulate=TRUE, then the simulated 
#       prediction intervals use re-sampled errors rather than 
#       normally distributed errors.
# npaths: The number of sample paths used in computing simulated 
#       prediction intervals.
# PI: If PI=TRUE, then prediction intervals are produced; otherwise 
#       only point forecasts are calculated. If PI=FALSE, then level, 
#       fan, simulate, bootstrap and npaths are all ignored.
# lambda: The Box-Cox transformation parameter. This is ignored if 
#       lambda=NULL. Otherwise, forecasts are back-transformed via 
#       an inverse Box-Cox transformation.


# this is to forecast based on ETS output above
# NOTE: for the h value, you can just put how far out you want 
#       to forecast rather than this code which produces an 
#       error for this particular data
flu_stlf_forecast = forecast(flu_stlf, 
                             h = ifelse(flu_stlf$m > 1, 
                                        2*flu_stlf$m, 10), 
                             level=c(80,95), 
                             fan=FALSE, 
                             simulate=FALSE,
                             bootstrap="FALSE", 
                             npaths=5000, 
                             PI=TRUE,
                             lambda=flu_stlf$lambda)

fit <- ets(flu_stlf, model="ANN")
plot(forecast(fit, h=3), 
     ylab="Oil (millions of tones)")

fit$par

summary(fit)
