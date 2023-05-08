# flowcamr
Utilities for FlowCam Data

<!-- badges: start -->
[![Lifecycle: experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
[![R-CMD-check](https://github.com/DICELab-NCSU/flowcamr/actions/workflows/R-CMD-check.yml/badge.svg?branch=main)](https://github.com/DICELab-NCSU/flowcamr/actions/workflows/R-CMD-check.yml)
[![CRAN status](https://www.r-pkg.org/badges/version/flowcamr)](https://CRAN.R-project.org/package=flowcamr)
<!-- badges: end -->

This package provides tools for working with particle and imagery data produced on a [FlowCam](https://www.fluidimaging.com/products/flowcam-8000).

## Getting started
This package is currently in development, and is hosted on GitHub. To install,
```{r}
# install.packages("remotes")
remotes::install_github("DICELab-NCSU/flowcamr")
library("flowcamr")
```

## Functionality
### 1. Harvesting metadata
- `get_flowcam_meta` operates on 'Run Summaries' .csv files that have been exported from Visual Spreadsheet. Metadata are gathered across all files supplied,
summarized into a data frame, and optionally exported to a .csv summary.

## Contributing
We welcome bug reports, feature requests, and contributed code.
