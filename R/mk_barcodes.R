#' Make barcodes for protist growth assays
#'
#' @param file Destination path where PDF of barcodes will be saved.
#' @param experiment Experiment name, used as the prefix for the barcode text.
#' @param resident Two-letter species code for the resident species.
#' @param invader Two-letter species code for the invader species. Use NULL if trial is for a single species.
#' @param reps A numeric vector or replicate ids. If a single number, the function will produce a sequence from 1 through the supplied value.
#' @param byrow Logical. Whether to fill the page row-wise (TRUE, default) or column-wise (FALSE).
#' @param skip_row Number of rows to skip. Useful when a label sheet is partially used.
#' @param skip_col Number of columns to skip. Useful when a label sheet is partially used.
#' @param sep Separator character used between barcode text chunks.
#' @param rm_experiment Logical. Toggles on/off the suppression of 'experiment' in the human-readable text next to the barcode. Does not affect the text embedded in the barcode.
#' @param template Template used to format PDF pages. See Details for available options.
#'
#' @details
#' The 'template' option allows users to specify a layout and spacing that corresponds to
#' the sticky labels on which barcodes are printed. Currently supported labels are:
#' - "SL582" (SheetLabels.com) 0.9375"x0.5" labels on 8.5"x11" pages
#'
#' @return Writes a PDF file to the supplied path.
#' @export
#'
#' @examples
#' mk_barcodes(file = "ABxCD_barcodes.pdf", experiment = "competition", resident = "AB", invader = "CD", reps = 3:6)
#'
mk_barcodes <- function(file = "barcodes.pdf",
                        experiment = "Pairwise-Assay",
                        resident, invader = NULL,
                        reps = 6,
                        byrow = TRUE, skip_row = 0L, skip_col = 0L,
                        sep = "-", rm_experiment = TRUE,
                        template = "SL582"){
  # check valid arguments
  if(grepl(" ", experiment)) warning("Space character in `experiment` may cause parsing problems.")
  if(!grepl("^[A-Z]{2}$", resident)) stop("Resident species code should be 2 capital letters.")
  if(!is.null(invader) && !grepl("^[A-Z]{2}$", invader)) stop("Invader species code should be 2 capital letters.")
  if(!is.numeric(reps)) stop("`reps` must be a numeric vector or a single number.")
  if(!is.null(invader) && resident == invader) stop("Single species assays should set `invader = NULL`")
  if(template != "SL582") stop("Only SheetLabels SL582 template is currently supported.")
  if(skip_row > 16) stop("All rows skipped. Reduce 'skip_row'.")
  if(skip_col > 6) stop("All columns skipped. Reduce 'skip_col'.")
  if(byrow == FALSE & (skip_row + skip_col) > 0L) {
    byrow <- TRUE
    warning("Rows and columns cannot be skipped when filling column-wise. Setting byrow = TRUE.")
  }
  # set reps
  if(length(reps) == 1L) reps <- 1:reps
  # make labels
  spp <- ifelse(is.null(invader), resident, paste0(resident, "x", invader))
  strings <- paste(experiment, spp, sep = sep)
  alt_text <- paste0(spp, reps)
  labels <- data.frame(label = paste0(strings, reps),
                       ind_string = strings,
                       ind_number = reps)
  # page setup
  # [reserved for future template options]
  # write labels
  suppressWarnings(baRcodeR::custom_create_PDF(Labels = labels, name = file, type = "matrix",
                                               Fsz = 9, Across = byrow,
                                               ERows = skip_row, ECols = skip_col,
                                               trunc = FALSE,
                                               numrow = 17, numcol = 7,
                                               page_width = 8.5, page_height = 11,
                                               width_margin = 0.3, height_margin = 0.5,
                                               label_width = 0.9375,
                                               label_height = 0.5 + (10-(17*0.5))/(16*2),
                                               x_space = 0, y_space = 0.5,
                                               alt_text = alt_text,
                                               replace_label = rm_experiment,
                                               denote = ""))
  message(paste("Barcodes printed to", file))
}
