#' Test that text conforms to expected FlowCam 'Run Summaries' file format
#' @noRd
#' @param x A character vector, resulting from `readLines()`.
#' @return Logical.
#' @author William Petry <wpetry@@ncsu.edu>
is_valid_fc_meta <- function(x) {
  len <- identical(length(x), 61L)
  header <- grepl("Run Summaries", x[1])
  vis <- any(sapply(x, function(x) grepl("VisualSpreadsheet", x)))
  return(all(len, header, vis))
}

#' Harvest FlowCam 'Run Summaries' meta-data from a single file
#' @description Harvests meta-data from a FlowCam 'Run Summaries' file. Typically,
#'  this won't be called by the user directly. Instead, `get_flowcam_meta()` sould be used
#'  instead.
#' @param x A character vector, resulting from `readLines()`.
#' @return A data frame containing harvested meta-data.
#' @author William Petry <wpetry@@ncsu.edu>
#' @importFrom lubridate ymd
#' @export harvest_fc_meta
harvest_fc_meta <- function(x) {
  Run_name <- gsub("^Name: ", "", x[[3]])
  Date <- lubridate::ymd(regmatches(x[[28]],
                                    regexpr("202[0-9]-[0-9]+-[0-9]+", x[[28]])))
  Time <- regmatches(x[[28]],
                            regexpr("[0-9]{2}:[0-9]{2}:[0-9]{2}", x[[28]]))
  Efficiency <- as.numeric(regmatches(x[[14]],
                                      regexpr("[0-9\\.]+", x[[14]])))
  Fluid_Imaged_mL <- as.numeric(regmatches(x[[13]],
                                           regexpr("[0-9\\.]+", x[[13]])))
  N_particles <- as.integer(regmatches(x[[15]],
                                       regexpr("[0-9]+", x[[15]])))
  out <- data.frame(Run_name = Run_name, Date = Date, Time = Time,
                    Efficiency = Efficiency, Fluid_Imaged_mL = Fluid_Imaged_mL,
                    N_particles = N_particles)
  return(out)
}

#' Harvest FlowCam 'Run Summaries' meta-data from from one or more files
#' @description Harvests meta-data from one or more FlowCam 'Run Summaries' file. Typically,
#'  this won't be called by the user directly. Instead, `get_flowcam_meta()` sould be used
#'  instead.
#' @param x Path to a single FlowCam 'Run Summaries' file or a directory containing multiple
#'  such files.
#' @param output Path to output .csv file. Defaults to NULL, which will not write a file.
#' @return A data frame summarizing the metadata from the supplied file(s), optionally also
#'  writing a .csv file.
#' @importFrom utils write.csv
#' @export get_flowcam_meta
get_flowcam_meta <- function(x, output = NULL) {
  if (dir.exists(x)) {
    files <- list.files(path = x, pattern = "\\.csv$", full.names = TRUE)
    if (identical(length(files), 0L)) {
      stop("Directory supplied to x does not contain any .csv files")
    }
    dat <- lapply(files, readLines)
    # check that file is in expected format
    valid <- sapply(dat, is_valid_fc_meta)
    # subset imported files to only valid FlowCam metadata files
    dat <- dat[which(valid)]
    outs <- lapply(dat, harvest_fc_meta)
    out <- do.call(rbind, outs)
  } else if (file.exists(x)) {
    dat <- readLines(x)
    # check valid
    if (!is_valid_fc_meta(dat)) {
      stop("x is not a valid FlowCam metadata file")
    }
    out <- harvest_fc_meta(dat)
  } else {
    stop("x must be a file or directory")
  }
  if (!is.null(output)) {
    utils::write.csv(out, file = output, row.names = FALSE)
  }
  return(out)
}
