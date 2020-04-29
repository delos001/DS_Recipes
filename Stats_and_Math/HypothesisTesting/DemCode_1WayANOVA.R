# Predict 401 Demonstration of Calculations using R for Week 8 

#----------------------------------------------------------------------------
#---------------------------------------------------------------------------- 
# This program will address problems taken from Business Statistics Chapter 11.

# The first illustration will use the data from Table 11.2 page 419.  These data
# deal with valve openings produced by four operators.  The concern is whether
# the operators produced different openings on average.  A one-way analysis of
# variance will be used to answer this question.

# The data have been converted to a comma delimited file to be read into R.

machine <- read.csv(file.path("operator.csv"), sep=",")
str(machine)

# It is apparent the operator variable has to be converted to a factor since
# it is a categorical (nominal) variable.

machine$operator <- factor(machine$operator)
str(machine)

boxplot(yield ~ operator, machine, col = "red", main = "Boxplots by Operator" )

# These data are being used in Business Statistics for a one-way analysis of
# variance.  In R, this can be accomplished using the aov() function. The output
# is placed in an object "res" to be used by other functions such as summary().

# To use aov(), it is necessary to specify a formula similarly to boxplot().  
# Summary provides the analysis of variance table with F value and p-value.

res <- aov(yield ~ operator, data = machine)
summary(res)

# The analysis of variance results show a statistically significant p-value.  The
# test statistic is the F-test value which produces a very small p-value.  This
# can be visualized using a plot of the critical region.

f.upper <- qf(0.95, 3, 20, lower.tail = TRUE)
cord.x <- c(f.upper, seq(f.upper, 15, 0.01), 6)
cord.y <- c(0, df(seq(f.upper, 15, 0.01), 3, 20), 0)
curve(df(x,3,20),xlim=c(0,6),main=" F Density", ylab = "density")
polygon(cord.x,cord.y,col="skyblue")
legend("right", legend = c("critical region >= 3.10"))

#-------------------------------------------------------------------------------
# Figure 11.6 in Business Statistics shows the one-way anova table.  To obtain 
# information also shown in this figure, two different approaches will be shown 
# in this program.  First, base R will be used with user-defined R functions.  
# Then ggplot2 and plyr will be used to show the efficiency of these approaches.

# The first calculates a confidence interval using a pooled variance. Using a 
# pooled variance increases the degrees of freedom and power of the procedure.

# The pooled variance can be computed by extracting the residuals.

sigma <- sum(resid(res)^2)/(20)
sqrt(sigma)  # Pooled standard deviation

# t.interval is a user-defined function that produces a confidence interval.  The
# subset of data for which the confidence interval is computed is submitted as
# the argument x.  sigma and df refer to the pooled results.

t.interval <- function(x,sigma,df,alpha){
  # sigma is assumed to be a pooled variance as used by Business Statistics.
  t.lower <- qt(alpha, df, lower.tail = TRUE)
  t.upper <- qt(1-alpha, df, lower.tail = TRUE)
  n <- length(x)
  lower <- mean(x)+t.lower*sqrt(sigma/n)
  upper <- mean(x)+t.upper*sqrt(sigma/n)
  interval <- c(lower, upper)
  interval
}

# To produce a comparable table, the values for each operator will be extracted,
# and confidence intervals computed for each subset.  All the necessary statistics
# for the display are combined and the result placed in display.  The results
# match what is shown in Figure 11.6 with the exception of the graphics.

x1 <- (machine[machine$operator == "1", 2])
x2 <- (machine[machine$operator == "2", 2])
x3 <- (machine[machine$operator == "3", 2])
x4 <- (machine[machine$operator == "4", 2])

Operator_1 <- c(length(x1), mean(x1), sd(x1), t.interval(x1, sigma, 20, 0.05))
Operator_2 <- c(length(x2), mean(x2), sd(x2), t.interval(x2, sigma, 20, 0.05))
Operator_3 <- c(length(x3), mean(x3), sd(x3), t.interval(x3, sigma, 20, 0.05))
Operator_4 <- c(length(x4), mean(x4), sd(x4), t.interval(x4, sigma, 20, 0.05))

display <- rbind(Operator_1, Operator_2, Operator_3, Operator_4)
colnames(display) <- c("N", "Mean", "StDev", "Lower", "Upper")

display

# In addition a plot showing the confidence intervals may be generated with
# another user-defined function "ciPlot" written by Todd Peterson.

ciPlot <- function(object) {
  # Todd Peterson supplied this function.
  # object is assumed to be display defined earlier.
  plot(c(object[, 4], object[, 5]),
       rep.int(nrow(object):1L, 2L), type = "n", axes = FALSE,
       xlab = "", ylab = "", main = NULL)
  axis(1)
  axis(2, at = nrow(object):1L,
       labels = row.names(object),
       srt = 0)
  abline(h = nrow(object):1L, lty = 1, lwd = 0.5, col = "lightgray")
  abline(v = object[1, 2], lty = 2, lwd = 0.5)
  segments(object[1:4, 4], nrow(object):1L,
           object[1:4, 5])
  segments(as.vector(c(object[, 4], object[, 5])),
           rep.int(nrow(object):1L - 0.05, 3L),
           as.vector(c(object[, 4], object[1:4, 5])),
           rep.int(nrow(object):1L + 0.05, 3L))
  segments(as.vector(object[, 2]),
           rep.int(nrow(object):1L - 0.05, 3L),
           as.vector(object[, 2]),
           rep.int(nrow(object):1L + 0.05, 3L))
  title(main = "Mean yield, per operator",
        xlab = "Mean yield")
  box()
}

# Invoking ciPlot() generates a comparable display as in MiniTab.

ciPlot(display)

#===============================================================================
# The next steps involve using ggplot2 to produce a comparable plot of intervals.  
# plyr provides a powerful capability with the ddply() function.  The following
# statements accomplish what was shown previously using base R.

require(ggplot2)
require(plyr)

op.yield <- ddply(machine, "operator", summarize, N=NROW(yield), 
      Mean = mean(yield), StDev = sd(yield), 
      Lower=Mean - qt(0.95, df=20)*sqrt(sigma/N),
      Upper=Mean + qt(0.95, df=20)*sqrt(sigma/N))
op.yield <- subset(op.yield, select = c(N, Mean, StDev, Lower, Upper))
rownames(op.yield) <- c("Operator_1", "Operator_2", "Operator_3", "Operator_4")
op.yield

# This matches the table produced earlier. Similar confidence intervals follow.

ggplot(op.yield, aes(x = Mean, y = rev(row.names(display)))) + geom_point()+
  geom_errorbarh(aes(xmin=Lower, xmax=Upper), height=.3) +
  ggtitle("Confidence Intervals for Mean Values") +
  scale_y_discrete(labels = rev(row.names(display))) + labs(y = "")

#===============================================================================
# Additonally, the TukeyHSD() gives simultaneous comparisons for each pair of operators.
# These results duplicate what is shown in Table 11.9 of Business Statistics.
# The TukeyHSD() in R will make adjustments for unequal sample sizes as discussed
# for the Tukey-Kramer Procedure in Business Statistics.

intervals <- TukeyHSD(res, conf.level = 0.95)
intervals
plot(intervals)

# R also provides diagnostic information which can be plotted.

plot(res)

#===============================================================================
# The next problem will deal with a randomized block design.  The data are tire
# wear data located in Section 11.4 of Business Statistics.  The concern is to 
# determine differences in tire wear as a function of speed.  A RCBD is used to 
# remove (account) for differences caused by suppliers.  These differences are
# not of interest in this study.

wear <- read.csv(file.path("c:/Rdata/", "supplier_rcbd.csv"), sep=",")
str(wear)
wear$supplier <- factor(wear$supplier)
wear$speed <- factor(wear$speed)
str(wear)

# The data can be displayed in different ways using aggregate().

aggregate(output ~ supplier + speed, data = wear, mean)

aggregate(output ~ supplier, data = wear, mean)
aggregate(output ~ speed, data = wear, mean)

# Using ggplot2, a display can be made of the data illustrating why a RCBD is
# valuable for removing the effect of different suppliers.

require(ggplot2)

display <- aggregate(output ~ supplier + speed, data = wear, mean)
ggplot(data = display, aes(x = speed, y = output, group = supplier, 
             colour = supplier))+ geom_line()+ geom_point(size = 3)+ 
  ggtitle("Plot showing Tire Wear as Function of Speed by Supplier")

# For this analysis of variance, both supplier and speed must be included.

res <- aov(output ~ supplier + speed, data = wear)
summary(res)

intervals <- TukeyHSD(res, "speed", conf.level = 0.95)
intervals
plot(intervals)

#===============================================================================
# The two-way analysis of variance allows for interactions.  The data for this
# section is from Business Statistics Section 11.5.

# These data are the result of a survey of CEOs who were asked to rate how important
# the availability of profitable investment opportunities is to deciding whether to 
# award a dividend to stockholders or to invest the cash elsewhere.  The analysis
# in this example focuses on two factors which may come into play in influencing this
# decision: where their company's stock is traded and how stockholders are
# informed of dividends.

stock <- read.csv(file.path("c:/Rdata/", "stock.csv"), sep=",")
str(stock)

mean(stock$result)
xw  <- aggregate(result ~ where, data = stock, mean)
xw
xh  <- aggregate(result ~ how, data = stock, mean)
xh
xwh <- aggregate(result ~ where + how, data = stock, mean)
xwh

ggplot(data = xwh, aes(x = where, y = result, group = how, colour = how))+
  geom_line()+ geom_point(size = 3)+ ggtitle("Plot of Average Importance")

# For a two-way analysis of variance, an interaction term can be used.

res <- aov(result ~ how + where + where*how, data = stock)
summary(res)

res <- aov(result ~ how + where, data = stock)
summary(res)

intervals <- TukeyHSD(res, c("where"), conf.level = 0.95)
intervals
plot(intervals)

plot(res)

#===============================================================================