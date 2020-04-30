

# use this if you have frequency greater than 24

flu_stlf = stlf(flu_ts, h = 52, s.window = "periodic", t.window = NULL,
                robust = FALSE, lambda = NULL, biasadj = FALSE)

plot(flu_stlf)
plot(forecast(flu_stlf, h=3), ylab="Oil (millions of tones)")
fit$par

summary(flu_stlf)
