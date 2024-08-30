## Resubmission
This is a submission of a new version to CRAN that addresses error messages found in the automatic tests on Debian Linux, Fedora Linux and Windows. The error messages were caused by differences between the results of this R package and the R package strucchange. After a brief correspondence with strucchange's maintainer, we made the automated tests less strict. 

## Test environments
* local Windows 10 x64 (19045.4780), R version 4.4.1 (2024-06-14 ucrt), x86_64-w64-mingw32/x64 (64-bit)
* Windows Server 2022 x64 (build 20348), R version 4.4.1 (2024-06-14 ucrt), x86_64-w64-mingw32 (on win builder)
* Windows Server 2022 x64 (build 20348), R version 4.3.3 (2024-02-29 ucrt), x86_64-w64-mingw32 (on win builder)
* Fedora Linux 40, R-devel (2024-08-28 r87070)(on R-hub)
* Ubuntu Linux 22.04.4 LTS, R-devel (2024-08-28 r87070) (on R-hub)
* r-devel-macosx-arm64|4.4.0|macosx|macOS 13.3.1 (22E261)|Mac mini|Apple M1||en_US.UTF-8|macOS 11.3|clang-1403.0.22.14.1|GNU Fortran (GCC) 12.2.0 (on macOS builder)


## R CMD check results
0 errors | 0 warnings | 0 notes

- Comments on possible misspellings: DIF is the common abbreviation for Differential Item Functioning.
- SIBTEST is the name of a method for DIF detection.

## Downstream dependencies
There are currently no downstream dependencies.
