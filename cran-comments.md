## Resubmission
This is a submission of a new version to CRAN that corrects minor text errors in the previous package version and also includes a reference to a publication that evaluates the implemented tests.

## Test environments
* local Windows 10 x64 (build 19045.2251), R version 4.2.2 (2022-10-31 ucrt), x86_64-w64-mingw32/x64 (64-bit)
* Windows Server 2008 (64-bit), 2x Intel Xeon E5-2670, 8 cores each, 2.6 GHz, 32Gb RAM, R version 4.1.3 (on win builder)
* Windows Server 2022, 2x Intel Xeon E5-2680 v4, 14 cores each, 2.4 GHz, 64Gb RAM., R version 4.2.1 (on win builder)
* Windows Server 2022, 2x Intel Xeon E5-2680 v4, 14 cores each, 2.4 GHz, 64Gb RAM., R-devel 4.3.0 (on win builder)
* Fedora Linux, R-devel, clang, gfortran (on R-hub)
* Ubuntu Linux 20.04.1 LTS, R-release, GCC (on R-hub)
* Windows Server 2022, R-devel, 64 bit (on R-hub)
* macOS 11.5.2 (20G95), R-release (on macOS builder)


## R CMD check results
0 errors | 0 warnings | 0 notes

- Comments on possible misspellings: DIF is the common abbreviation for Differential Item Functioning.
- SIBTEST is the name of a method for DIF detection.
- Only on Fedora Linux, R-devel, clang, gfortran the following NOTE is given: Skipping checking HTML validation: no command 'tidy' found. This note does not seem critical, and HTML version of the manual is able to be validated on the other tested systems.

## Downstream dependencies
There are currently no downstream dependencies.
