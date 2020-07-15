## Resubmission
This is a resubmission to CRAN. In this version I have:
* Shortened the title of the package to less than 65 characters.
* Removed title case from the Description text.
* Explained acronyms like DIF and SIBTEST in the Description text.
* Included more details about the functionality of the package, similar to the difR package (which has a similar functionality).
* I did not include references for the theoretical background, because these are unpublished yet. I plan to include them after publication.
* I added small examples to all Rd files on R functions.
* I did not address the spelling notes for SIBTEST and DIF in the DESCRIPTION file, because these are technical terms.

## Test environments
* local Windows 10 x64 (build 18363), R version 4.0.2 (2020-06-22), x86_64-w64-mingw32/x64 (64-bit)
* OS X (on travis-ci), release
* linux xenial (on travis-ci), release, devel
* windows (on AppVeyor), release

## R CMD check results
0 errors | 0 warnings | 0 notes

- This is the first resubmission.
- Comments on possible misspellings: DIF is the common abbreviation for Differential Item Functioning.
- SIBTEST is the name of a method for DIF detection.

## Downstream dependencies

There are currently no downstream dependencies.