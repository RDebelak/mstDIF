pkgname <- "mstDIF"
source(file.path(R.home("share"), "R", "examples-header.R"))
options(warn = 1)
options(pager = "console")
base::assign(".ExTimings", "mstDIF-Ex.timings", pos = 'CheckExEnv')
base::cat("name\tuser\tsystem\telapsed\n", file=base::get(".ExTimings", pos = 'CheckExEnv'))
base::assign(".format_ptime",
function(x) {
  if(!is.na(x[4L])) x[1L] <- x[1L] + x[4L]
  if(!is.na(x[5L])) x[2L] <- x[2L] + x[5L]
  options(OutDec = '.')
  format(x[1L:3L], digits = 7L)
},
pos = 'CheckExEnv')

### * </HEADER>
library('mstDIF')

base::assign(".oldSearch", base::search(), pos = 'CheckExEnv')
base::assign(".old_wd", base::getwd(), pos = 'CheckExEnv')
cleanEx()
nameEx("bootstrap_sctest")
### * bootstrap_sctest

flush(stderr()); flush(stdout())

base::assign(".ptime", proc.time(), pos = "CheckExEnv")
### Name: bootstrap_sctest
### Title: A score-based DIF test using the parametric bootstrap approach.
### Aliases: bootstrap_sctest

### ** Examples

data("toydata")
resp <- toydata$resp
group_categ <- toydata$group_categ
it <- toydata$it
discr <- it[,1]
diff <- it[,2]
## No test: 
bootstrap_sctest(resp = resp, DIF_covariate = group_categ, a = discr, b = diff, 
decorrelate = FALSE)
## End(No test)




base::assign(".dptime", (proc.time() - get(".ptime", pos = "CheckExEnv")), pos = "CheckExEnv")
base::cat("bootstrap_sctest", base::get(".format_ptime", pos = 'CheckExEnv')(get(".dptime", pos = "CheckExEnv")), "\n", file=base::get(".ExTimings", pos = 'CheckExEnv'), append=TRUE, sep="\t")
cleanEx()
nameEx("log_reg")
### * log_reg

flush(stderr()); flush(stdout())

base::assign(".ptime", proc.time(), pos = "CheckExEnv")
### Name: log_reg
### Title: A logistic regression DIF test for MSTs
### Aliases: log_reg

### ** Examples

data("toydata")
resp <- toydata$resp
group_categ <- toydata$group_categ
theta_est <- toydata$theta_est
log_reg(resp, DIF_covariate = factor(group_categ), theta = theta_est)





base::assign(".dptime", (proc.time() - get(".ptime", pos = "CheckExEnv")), pos = "CheckExEnv")
base::cat("log_reg", base::get(".format_ptime", pos = 'CheckExEnv')(get(".dptime", pos = "CheckExEnv")), "\n", file=base::get(".ExTimings", pos = 'CheckExEnv'), append=TRUE, sep="\t")
cleanEx()
nameEx("mstDIF")
### * mstDIF

flush(stderr()); flush(stdout())

base::assign(".ptime", proc.time(), pos = "CheckExEnv")
### Name: mstDIF
### Title: A general function to detect differential item functioning (DIF)
###   in multistage tests (MSTs)
### Aliases: mstDIF mstDIF.default mstDIF.AllModelClass mstDIF.dRm

### ** Examples

data("toydata")
resp <- toydata$resp
group_categ <- toydata$group_categ
theta_est <- toydata$theta_est
see_est <- toydata$see_est

res1 <- mstDIF(resp, DIF_covariate = factor(group_categ), method = "logreg",
theta = theta_est)

res2 <- mstDIF(resp, DIF_covariate = factor(group_categ), method = "mstsib",
theta = theta_est, see = see_est)

summary(res1)
summary(res2)




base::assign(".dptime", (proc.time() - get(".ptime", pos = "CheckExEnv")), pos = "CheckExEnv")
base::cat("mstDIF", base::get(".format_ptime", pos = 'CheckExEnv')(get(".dptime", pos = "CheckExEnv")), "\n", file=base::get(".ExTimings", pos = 'CheckExEnv'), append=TRUE, sep="\t")
cleanEx()
nameEx("mstSIB")
### * mstSIB

flush(stderr()); flush(stdout())

base::assign(".ptime", proc.time(), pos = "CheckExEnv")
### Name: mstSIB
### Title: The mstSIB test for MSTs
### Aliases: mstSIB

### ** Examples

data("toydata")
resp <- toydata$resp
group_categ <- toydata$group_categ
theta_est <- toydata$theta_est
see_est <- toydata$see_est
mstSIB(resp = as.data.frame(resp), theta = theta_est,
DIF_covariate = group_categ, see = see_est)




base::assign(".dptime", (proc.time() - get(".ptime", pos = "CheckExEnv")), pos = "CheckExEnv")
base::cat("mstSIB", base::get(".format_ptime", pos = 'CheckExEnv')(get(".dptime", pos = "CheckExEnv")), "\n", file=base::get(".ExTimings", pos = 'CheckExEnv'), append=TRUE, sep="\t")
cleanEx()
nameEx("permutation_sctest")
### * permutation_sctest

flush(stderr()); flush(stdout())

base::assign(".ptime", proc.time(), pos = "CheckExEnv")
### Name: permutation_sctest
### Title: A score-based DIF test using the permutation approach.
### Aliases: permutation_sctest

### ** Examples

data("toydata")
resp <- toydata$resp
group_categ <- toydata$group_categ
it <- toydata$it
discr <- it[,1]
diff <- it[,2]
## No test: 
permutation_sctest(resp = resp, DIF_covariate = group_categ, a = discr, b = diff, 
decorrelate = FALSE)
## End(No test)




base::assign(".dptime", (proc.time() - get(".ptime", pos = "CheckExEnv")), pos = "CheckExEnv")
base::cat("permutation_sctest", base::get(".format_ptime", pos = 'CheckExEnv')(get(".dptime", pos = "CheckExEnv")), "\n", file=base::get(".ExTimings", pos = 'CheckExEnv'), append=TRUE, sep="\t")
### * <FOOTER>
###
cleanEx()
options(digits = 7L)
base::cat("Time elapsed: ", proc.time() - base::get("ptime", pos = 'CheckExEnv'),"\n")
grDevices::dev.off()
###
### Local variables: ***
### mode: outline-minor ***
### outline-regexp: "\\(> \\)?### [*]+" ***
### End: ***
quit('no')
