## Resubmission
This is a resubmission to CRAN. In this version I have:
* Included cran-comments.md to .Rbuildignore
* I did not address the spelling checks for mstSIB and DIF in the DESCRIPTION file, because these are technical terms.

## Test environments
* local Windows 10 x64 (build 18363), R version 4.0.0 (2020-04-24), x86_64-w64-mingw32/x64 (64-bit)
* OS X (on travis-ci), release
* linux xenial (on travis-ci), oldrel, release, devel
* windows (on AppVeyor), release

## R CMD check results
0 errors | 0 warnings | 0 note

- New submission
- DIF is the common abbreviation for Differential Item Functioning.
- mstSIB is the name of a method for DIF detection.
- There was an error under the oldrel version with linux xenial because a dependency was not available.

## Downstream dependencies

There are currently no downstream dependencies.