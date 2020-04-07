## General
Assume a data set has a BINARY Target Variable: 0 or 1

- Linear (OLS) Regression cannot be used to predict this target because:
    Errors won’t be normally distributed
- Probability value from OLS regression can take on values > 100% or < 0%
- Even if the Predicted value is truncated, the predictions are usually not good

#### Binomial distribution concerns replication of Bernoulli sequence of trials
- Bernoulli trials only have 2 outcomes:
- 0 if unsuccessful, 1 if sucessful
- Binomial distribution Is concerned with how many successes in n trials
- Probabilities must add up to 1
  
- Probability mass function: determines how distributions appear

#### Multinomial trial outcomes (instead of 2 with binomial)
- probabilities must still add up to 1
- multinomial distribution mass function

#### Negative Binomial used where mean <> variance
- what is the probability I need to approach 20 people (n) to obtain 10 signatures (r) if the probability of getting a signature is 0.6
- extradispersion:
    + overdispersion: mean is much less than variance
    + underdispersed distribution: mean exceeds the variance
- negative binomial preferred with overdispersion
- number of sucessess is fixed and number of trials varies (this is opposite concept of binomial regression)

#### Poisson: count variables often follow this distribution
- example: children per household usually peaks around 2 or 3, and 
    + probability of having larger numbers of kids gets lower as number of kids increases, ie: the right tail drops off quickly to the right
- This is special type of negative binomial
    + where mean equals the variance  
    + if mean doesn't equal variance, use Negative binomial distribution

---

## Logistic Tutorials

- Insurance (SAS example)
  + https://www.youtube.com/watch?v=xZCJU5s6jHM&feature=youtu.be
  + https://www.youtube.com/watch?v=d6m7S80bRuo&feature=youtu.be
  
- Insurance (SAS Enterprise Miner example)
  + https://www.youtube.com/watch?v=WT8t4MD57rk&feature=youtu.be

- HELOC (SAS example)
  + https://www.youtube.com/watch?v=H1oWHC5l7As&feature=youtu.be
  + https://www.youtube.com/watch?v=Tb4yFL2p0k8&feature=youtu.be
  + https://www.youtube.com/watch?v=ClV41ay883E&feature=youtu.be

---

## Logistic Tutorials (Poisson, Negative Binomial, Zero Inflated Poisson)

- Wine (SAS example)
  + https://www.youtube.com/watch?v=qJAJ8lTSAww&feature=youtu.be
  + https://www.youtube.com/watch?v=NW05GwdOFF8&feature=youtu.be
  + https://www.youtube.com/watch?v=daXnR5LsVW0&feature=youtu.be
  
  
