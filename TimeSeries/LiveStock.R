#_________________________________________________________________________
#Part 2

#Data set 1: Total Animals and Livestock USA

animals = read.csv(file.path("USATotalAnimals.csv"), sep=",", header=TRUE)
head(animals)
animals_sort = animals[order(animals$Time),]
head(animals_sort)

animals_sort = animals_sort[,2]
head(animals_sort)

plot.ts(animals_sort)

animals_ts = ts(animals_sort, start=1909)
plot.ts(animals_ts, main="US Livestock Total 1909-2016")

fit_animals_0.2 = ses(animals_ts, alpha=0.2, initial="simple", h=20)
fit_animals_0.8 = ses(animals_ts, alpha=0.8, initial="simple", h=20)

lines(ma(animals_ts, 5), col="red")
lines(fitted(fit_animals_0.2), col="green")
lines(fitted(fit_animals_0.8), col="blue")
legend("topleft", lty = 1, col = c("black", "red", "green", "blue"),
       c("data", "MA 5", "SES 0.2", "SES 0.8"), pch=1)

nsdiffs(animals_ts)
ndiffs(animals_ts)

acf(animals_ts)
pacf(animals_ts)

animals_arima1 = auto.arima(animals_ts)
animals_arima1
plot(forecast(animals_arima1, h=5), ylab="Livestock Totals USA")
lines(fitted(animals_arima1), col="dark red")
lines(ma(animals_ts, 5), col="green")
lines(fitted(fit_animals_0.8), col="blue")
legend("topleft", lty = 1, col = c("black", "dark red", "blue"),
       c("data", "Arima5,1,0", "SES 0.8"), pch=1)



