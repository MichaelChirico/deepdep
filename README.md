
# deepdep <img src='images/logo.png' align="right" height="250" />

<!-- badges: start -->

[![Build
Status](https://travis-ci.org/DominikRafacz/deepdep.svg?branch=master)](https://travis-ci.org/DominikRafacz/deepdep)
[![CircleCI build
status](https://circleci.com/gh/DominikRafacz/deepdep.svg?style=svg)](https://circleci.com/gh/DominikRafacz/deepdep)
[![AppVeyor build
status](https://ci.appveyor.com/api/projects/status/github/DominikRafacz/deepdep?branch=master&svg=true)](https://ci.appveyor.com/project/DominikRafacz/deepdep)
[![Codecov test
coverage](https://codecov.io/gh/DominikRafacz/deepdep/branch/master/graph/badge.svg)](https://codecov.io/gh/DominikRafacz/deepdep?branch=master)
[![Lifecycle:
maturing](https://img.shields.io/badge/lifecycle-maturing-blue.svg)](https://www.tidyverse.org/lifecycle/#maturing)

<!-- badges: end -->

Visualise and Explore Deep Dependiences of R packages.

The `deepdep` package provides the tools for exploration of package
dependencies. Main `deepdep()` function allows to aquire deep
dependencies of any package and plot them in an elegant way. It also
adds some popularity measures for the packages e.g. in the form of
download count through the cranlogs package. Uses the CRAN metadata
database (<http://crandb.r-pkg.org>) and Bioconductor metadata
(<http://bioconductor.org>). Other data aquire functions are:
`get_dependencies()`, `get_downloads()` and `get_description()`. The
`deepdep_shiny()` function runs shiny application that helps to produce
nice **deepdep plot**.

[Cheatsheet](https://dominikrafacz.github.io/deepdep/articles/deepdep-package.html)

## Installation

``` r
# Install from CRAN: 
install.packages("deepdep")

# Install the development version from GitHub:
devtools::install_github("DominikRafacz/deepdep")
```

## Demo

``` r
library(deepdep)

dd <- deepdep("ggplot2", depth = 2)

head(dd)
```

    ##    origin     name  version    type
    ## 1 ggplot2   digest     <NA> Imports
    ## 2 ggplot2   gtable >= 0.1.1 Imports
    ## 3 ggplot2 lazyeval     <NA> Imports
    ## 4 ggplot2     MASS     <NA> Imports
    ## 5 ggplot2     mgcv     <NA> Imports
    ## 6 ggplot2 reshape2     <NA> Imports

``` r
plot_dependencies(dd, "circular")
```

<img src="README_files/figure-gfm/unnamed-chunk-2-1.png" style="display: block; margin: auto;" />

``` r
plot_dependencies("bayes4psy", show_version = TRUE,
                  dependency_type = c("Depends", "Imports", "Suggests", "LinkingTo"))
```

<img src="README_files/figure-gfm/unnamed-chunk-3-1.png" style="display: block; margin: auto;" />

``` r
dd_xgboost <- deepdep("xgboost", dependency_type = "Imports", downloads = TRUE)

head(dd_xgboost)
```

    ##    origin       name  version    type last_day last_week last_month last_quarter last_half grand_total
    ## 1 xgboost     Matrix >= 1.1-0 Imports     3019     20416      71951       286778    512873     4519559
    ## 2 xgboost data.table >= 1.9.6 Imports    18209    124046     414359      1612428   3220026    15729449
    ## 3 xgboost   magrittr   >= 1.5 Imports   142632    948345    4123117     11920228  21746128    39676585
    ## 4 xgboost    stringi >= 0.5.2 Imports    32340    227984     673806      2125319   4081476    23078784

``` r
plot_downloads(dd_xgboost)
```

<img src="README_files/figure-gfm/unnamed-chunk-4-1.png" style="display: block; margin: auto;" />

``` r
plot_dependencies(dd_xgboost, "tree", show_version = TRUE)
```

<img src="README_files/figure-gfm/unnamed-chunk-4-2.png" style="display: block; margin: auto;" />
<!------------------------

This package was made during `1120-DS000-ISP-0500`[Advanced Programming in R](https://github.com/mini-pw/2020Z-ProgramowanieWR) course at Warsaw University of Technology.-->
