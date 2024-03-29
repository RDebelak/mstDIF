# A Collection of Statistical Tests for DIF Detection in Multistage Tests

This R package provides a collection of methods for the detection of differential item functioning (DIF) in the psychometric analysis of multistage tests. The provided methods entail logistic regression, mstSIB, and various score-based tests. These tests are partly wrappers for functions that are provided by other packages, such as the `sctest` function from the `strucchange` package and the estimation functions from the `mirt` package. The provided tests check the presence of DIF on the level of the individual items. 

## Installation

The package version available on CRAN can be installed via:

```
install.packages("mstDIF")
```

The package version available on GitHub can be installed using the `devtools`-package:

```
install.packages("devtools")
devtools::install_github("RDebelak/mstDIF")
```
