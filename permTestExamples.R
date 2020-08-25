#This script is used to generate the simulation results for the proposed permutatio test implementation 
# applied to teh examples from section 4.1 of the paper Evaluating Fairness Using Permutation Tests

B = 1000; 
iterations = 10000
sampleSize = 2000

pVal = 0;
for (it in 1:iterations) {
  x = runif(sampleSize, 1e-5, 1)
  errors = (1/(x)^2)*rnorm(sampleSize)
  varEst = sum((errors-mean(errors))^2*(x-mean(x))^2)/(sum((errors-mean(errors))^2)*sum((x-mean(x))^2))
  ts = cor(x, errors)/sqrt(varEst)                  
  tempP = 0;
  for (b in 1:B){
    resampledErrors = sample(errors, sampleSize, replace = FALSE)
    varEst = sum((resampledErrors-mean(resampledErrors))^2*(x-mean(x))^2)/(sum((resampledErrors-mean(resampledErrors))^2)*sum((x-mean(x))^2))
    permStat = cor(x, resampledErrors)/sqrt(varEst)
    tempP = tempP + (abs(permStat)> abs(ts))/B
  }
  pVal = pVal + (tempP<.05)
}
print("Rejection probability for uncorrelatedness example:")
print(pVal/iterations)

pVal = 0;
for (it in 1:iterations) {
  x = rexp(sampleSize, rate = 1) + 1
  errors = (1/(x)^2)*rnorm(sampleSize)
  varEst = sum((errors-mean(errors))^2*(x-mean(x))^2)/(sum((errors-mean(errors))^2)*sum((x-mean(x))^2))
  ts = cor(x, errors)/sqrt(varEst)                  
  tempP = 0;
  for (b in 1:B){
    resampledErrors = sample(errors, sampleSize, replace = FALSE)
    varEst = sum((resampledErrors-mean(resampledErrors))^2*(x-mean(x))^2)/(sum((resampledErrors-mean(resampledErrors))^2)*sum((x-mean(x))^2))
    permStat = cor(x, resampledErrors)/sqrt(varEst)
    tempP = tempP + (abs(permStat)> abs(ts))/B
  }
  pVal = pVal + (tempP<.05)
}

print("Rejection probability for independence example:")
print(pVal/iterations)

