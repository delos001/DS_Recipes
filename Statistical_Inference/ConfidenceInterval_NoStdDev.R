


data.set <- c(16.4,17.1,17.0,15.6,16.2,14.8,16.0,15.6,17.3,17.4,15.6,15.7,17.2,
              16.6,16.0,15.3,15.4,16.0,15.8,17.2,14.6,15.5,14.9,16.7,16.3)

mean(data.set)  # gets point estimate for the population (from the sample)

t.test(data.set, alternative = c("two.sided"), mu = 0, conf.level = 0.99)
