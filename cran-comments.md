## Resubmission
This is a resubmission to CRAN. In this version I have:
* Removed an automatic test in the test1.R file that pertained to a function in the scDIFtest package: scDIFtest::scDIFtest(). This function is already tested in the scDIFtest package, and does not require testing in the mstDIF package.
* Removed strucchange from the Imports list in DESCRIPTION, since this is not necessary.
* Included the flavors r-devel-linux-x86_64-fedora-gcc, r-devel-linux-x86_64-fedora-clang and r-patched-solaris-x86,
which had led to notes or errors in checks by the CRAN team, as additional test environments.
* Since this package can only be installed with R version 4.0.0 or higher, I did not address the error with the oldrel version under OS X - it is to be expected that the package cannot be installed there.

## Test environments
* local Windows 10 x64 (build 18363), R version 4.0.2 (2020-06-22), x86_64-w64-mingw32/x64 (64-bit)
* OS X (on travis-ci), release
* linux xenial (on travis-ci), release, devel
* linux fedora gcc and clang (on R-hub), devel
* linux solaris (on R-hub), patched
* windows (on AppVeyor), release

## R CMD check results
0 errors | 0 warnings | 0 notes

- Comments on possible misspellings: DIF is the common abbreviation for Differential Item Functioning.
- SIBTEST is the name of a method for DIF detection.

## Downstream dependencies

There are currently no downstream dependencies.
