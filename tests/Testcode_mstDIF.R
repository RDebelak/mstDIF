### Testcode
library(mstDIF)
library(Rsctest)
library(scDIFtest)
library(eRm)
library(mirt)

### Generate beta, theta, see and response matrix
set.seed(1635)
i <- 30
p <- 500
beta <- rnorm(i)
theta <- rnorm(p)
group <- as.character(rep(1:2, each=p/2))

resp <- sim.rasch(persons = theta, items = beta)
colnames(resp) <- paste0("item_", seq_len(ncol(resp)))

### For checking: Calculate raw scores. Are there perfect scores?
sum_resp <- apply(resp, 1, sum)

### Estimation of person parameters and standard estimation errors
RM <- RM(resp)
ppar <- person.parameter(RM)
theta_est <- ppar$theta.table$`Person Parameter`
see <- rep(NA, length(theta))
see[-ppar$pers.ex] <- ppar$se.theta[[1]]
if(length(ppar$pers.ex) == 0) see <- ppar$se.theta[[1]]

### Test 1: log_reg function
test1 <- log_reg(resp, group, theta_est)

### Test 2: mstSIB function
### (Respondents with perfect scores are excluded because eRm provides no estimates for them)
test2 <- mstSIB(resp = resp, DIF_covariate = group,
                theta = theta_est, see = see)


### Test 3: Score-based permutation tests (calculation with decorrelate = F is somewhat stabler)
test3 <- permutation_sctest(resp = resp, DIF_covariate = group,
                            a = rep(1,times = i), b = beta, decorrelate = F)

### Test 4: Score-based bootstrap tests (calculation with decorrelate = F is somewhat stabler)
test4 <- bootstrap_sctest(resp = resp, DIF_covariate = group,
                          b = beta, decorrelate = FALSE, theta = theta_est)

### Test 5: Analytical score-based test - needs a mirt object
mirt_obj <- multipleGroup(data = resp, model=1, itemtype = "2PL", group = group,
                       invariance = c("free_means","free_var","slopes","intercepts"))
test5 <- scDIFtest(object = mirt_obj, DIF_covariate = group)

### Test 6: mstDIF function with logreg option
test6 <- mstDIF(resp = resp, DIF_covariate = group, method = "logreg",
                theta = theta_est)

test6
summary(test6)
summary(test6, ordered = FALSE)
summary(test6, DIF_type = "all")
summary(test6, DIF_type = c("overall", "uniform"))


### Test 7: mstDIF function with mstSIB option
test7 <- mstDIF(resp = resp, DIF_covariate = group,
                method = "mstsib",
                theta = theta_est, see = see)
test7
summary(test7)
summary(test7, ordered = FALSE)
summary(test7, DIF_type = "all")
summary(test7, DIF_type = c("overall", "uniform"))

### Test 8: mstDIF function with bootstrap option
test8 <- mstDIF(resp = resp, DIF_covariate = group, method = "bootstrap",
                a = rep(1,times = i), b = beta, decorrelate = FALSE, theta = theta_est, nSamples = 100)

test8
summary(test8)
summary(test8, ordered = FALSE)
summary(test8, DIF_type = "all")
summary(test8, DIF_type = c("overall", "uniform"))

### Test 9: mstDIF function with permutation option
test9 <- mstDIF(resp = resp,  metho = "permutation", DIF_covariate = group,
                b = beta, decorrelate = FALSE,
                theta = theta_est)

test9
summary(test9)
summary(test9, ordered = FALSE)
summary(test9, DIF_type = "all")
summary(test9, DIF_type = c("overall", "uniform"))


### Test 10: mstDIF function with analytical option
test10 <- mstDIF(mirt_obj, DIF_covariate = group, method = "analytical")

test10
summary(test10)
summary(test10, ordered = FALSE)
summary(test10, DIF_type = "all")
summary(test10, DIF_type = c("overall", "uniform"))


###
test11 <- mstDIF(mirt_obj, DIF_covariate = group, method = "logreg", theta_method = "EAP")
test11

test12 <- mstDIF(mirt_obj, DIF_covariate = group, method = "permutation", theta_method = "EAP", nSamples = 500)
test12

# test13 <- mstDIF(resp, DIF_covariate = group, method = "analytical")

test14 <- mstDIF(RM, DIF_covariate = group, method = "logreg")
test14

test15 <- mstDIF(RM, DIF_covariate = group, method = "permutation", nSamples = 500)
test15

test15b <- mstDIF(RM, DIF_covariate = group, method = "bootstrap", nSamples = 50)
test15b

test16 <- mstDIF(RM, DIF_covariate = group, method = "mstsib")
test16

# test17 <- mstDIF(RM, DIF_covariate = group, method = "analytical")

