# Boxplots and normal distribution

set.seed(1237)

size <- seq(from = 10, to = 100, by = 5)

result <- numeric(0)
result.ex <- numeric(0)

for (n in size){
percent <- numeric(0)
percent.ex <- numeric(0)

for (k in 1:10000){
  x <- rnorm(n, mean = 0, sd = 1)
  q1 <- quantile(x, probs = 0.25)
  q3 <- quantile(x, probs = 0.75)
  iqr <- q3 - q1
  t1 <- q1 - 1.5*iqr
  t3 <- q3 + 1.5*iqr
  below <- sum(x <= t1)
  above <- sum(x >= t3)
  percent[k] <- 100*(below + above)/n
  below.ex <- sum(x < (t1 - 1.5*iqr))
  above.ex <- sum(x > (t3 + 1.5*iqr))
  percent.ex[k] <- 100*(below.ex + above.ex)/n            
}

result <- c(result, mean(percent))
result.ex <- c(result.ex, mean(percent.ex))
}
summary(result)
summary(result.ex)

plot(size, result, ylim = c(0, 5), col = "blue", pch = 16, type = "b",xlab = c("Sample Size"),
     ylab = ("Average Percent of Observations Determined as Outliers"),
     main = c("Outlier Detection for Normal Distribution Using Boxplot Rule"))
points(size, result.ex, col = "red", pch = 16, type = "b")
abline(h = 0.6975744, col = "blue")
abline(h = 0.0, col = "red")
legend(x = 60, y = 5, c("Standard normal distribution used.","10,000 iterations",
                        "Average Percent Detection Reported"))
legend(x = 60,y = 4,c("Blue more than 1.5 times IQR distant", 
                      "Red more than 3.0 times IQR distant"))

qnorm(p=c(.25,.75),0,1)
l1 <- -0.6745 - 1.5*2*0.6745
l3 <- abs(l1)

200.0*pnorm(l3,0,1,lower.tail=FALSE)

cord.x <- c(-0.6745, seq(-0.6745, 0.6745, 0.01), 0.6745)
cord.y <- c(0, dnorm(seq(-0.6745, 0.6745, 0.01),0,1), 0)
cord.xx <- c(-3.0, seq(-3.0, l1, 0.01), l1)
cord.yy <- c(0, dnorm(seq(-3.0, l1, 0.01),0,1), 0)
cord.zz <- c(l3, seq(l3, +3.0, 0.01), +3.0)
cord.ww <- c(0, dnorm(seq(l3, +3.0, 0.01),0,1), 0)
curve(dnorm(x,0,1),xlim=c(-3,3),main="Standard Normal Density -- Relationship to Boxplot",
      ylab = "Density", xlab = "X", ylim = c(0,0.5))
polygon(cord.x,cord.y,col="skyblue")
polygon(cord.xx,cord.yy,col="red")
polygon(cord.zz,cord.ww,col="red")
legend(x = -1.5, y = 0.5, c("blue region constitutes 50% of the area",
                            "red regions fall outside 1.5 times IQR distant",
                            "area of red regions is 0.698 percent or 0.00698"))


