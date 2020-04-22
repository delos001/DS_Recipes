
## Leave One Out vs Cross Validation
```
Which is better, LOOCV or K-fold CV?
LOOCV is more computationally intensive than K-fold CV
From the perspective of bias reduction, LOOCV is preferred to K-fold CV (when K < n)
However, LOOCV has higher variance than K-fold CV (when K < n)
Thus, we see the bias-variance trade-off between the two resampling methods


When y is a categorical value, rather than use MSE to quantify test error, 
we instead use the number of misclassified observations:

We use CV as follows: 
Divide data into K folds; hold-out one part and fit using the remaining data 
(compute error rate on hold-out data); repeat K times.
CV Error Rate: average over the K errors we have computed
```
