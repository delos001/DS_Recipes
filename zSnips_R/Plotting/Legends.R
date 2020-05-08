


hist(df2$RATIOc,
     include.lowest=TRUE, right=TRUE,
     main='Histogram of Ratio: Shuck to Volume',
     xlab='Ratio (g/cm^3)',
     ylab='Frequency',
     col='light green',
     xlim=c(min(df2$RATIOc) - 0.05,
            max(df2$RATIOc) + 0.05))
abline(v=mean(df2$RATIOc), col='red', lwd=3, lty=3)
abline(v=median(df2$RATIOc), col='yellow', lwd=3, lty=3)
legend(0.2,275,
       legend=c(sprintf('red=mean:%s',
                        round(mean(df2$RATIOc), 3)),
                sprintf('yellow=median:%s',
                        round(median(df2$RATIOc), 3))))
