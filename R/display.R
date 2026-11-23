#' Display all palettes
#'
#' @param type Filter by palette type: `"all"`, `"sequential"`, or `"qualitative"`.
#'
#' @return Invisibly returns the names of displayed palettes.
#' @export
display_all <- function(type = c("all", "sequential", "qualitative")) {
  type <- match.arg(type)
  
  # Filter palette names by type
  if (type == "all") {
    pal_names <- names(tool_palettes)
  } else {
    pal_names <- names(tool_palettes)[sapply(tool_palettes, function(p) p$type == type)]
  }
  
  # Save par settings
  old_par <- par(no.readonly = TRUE)
  on.exit(par(old_par), add = TRUE)
  
  n <- length(pal_names)
  if (n == 0) {
    return(invisible(character(0)))
  }
  
  # Layout: one row per palette
  par(mfrow = c(n, 1), mar = c(2, 4, 2, 1))
  
  for (name in pal_names) {
    pal <- tool_palettes[[name]]
    n_colors <- length(pal$colors)
    
    # Set up the plot region
    plot(NULL, xlim = c(0.5, n_colors + 0.5), ylim = c(0, 1),
         axes = FALSE, xlab = "", ylab = "")
    
    # Draw swatch using rect()
    for (i in seq_len(n_colors)) {
      rect(xleft = i - 0.5, ybottom = 0,
           xright = i + 0.5, ytop = 1,
           col = pal$colors[i])
    }
    
    # Add label on left
    mtext(paste0(sQuote(name), " (", pal$type, ")"), side = 2, line = 1,
          at = 0.5, cex = 0.9)
  }
  
  invisible(pal_names)
}
