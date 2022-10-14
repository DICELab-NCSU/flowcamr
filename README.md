# flowcamr
Utilities for FlowCam Data

This package provides tools for working with particle and imagery data produced on a [FlowCam](https://www.fluidimaging.com/products/flowcam-8000).

## Getting started
This package is currently in development, and is hosted on GitHub. To install,
```{r}
# install.packages("remotes")
remotes::install_github("DICELab-NCSU/flowcamr")
library(flowcamr")
```

## Functionality
### 1. Harvesting metadata
- `get_flowcam_meta` operates on 'Run Summaries' .csv files that have been exported from Visual Spreadsheet. Metadata are gathered across all files supplied,
summarized into a data frame, and optionally exported to a .csv summary.

## Contributing
We welcome bug reports, feature requests, and contributed code.
