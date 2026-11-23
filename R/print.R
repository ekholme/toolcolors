#' Print a tool palette
#'
#' @param x A `tool_palette` object.
#' @param ... Unused.
#'
#' @return Invisibly returns `x`.
#' @export
print.tool_palette <- function(x, ...) {
  # Save par settings
  old_par <- par(no.readonly = TRUE)
  
  on.exit(par(old_par), add = TRUE)
  
  # Set margins for swatch + title
  n <- length(x)
  par(mar = c(2, 1, 3, 1))
  
  # Draw the swatch - image needs z to be matrix with dims c(nrow, ncol) = c(1, n)
  # y-axis: c(bottom, top) = c(0.5, 1.5) for a single row
  z <- t(matrix(seq_len(n), nrow = 1, ncol = n))
  image(seq_along(x), c(0.5, 1.5), z,
        col = x, axes = FALSE, xlab = "", ylab = "")
  
  # Add palette name as title
  pal_name <- attr(x, "name")
  text(mean(seq_along(x)), 1.5, labels = paste0("Palette: ", sQuote(pal_name)),
       cex = 1.2)
  
  invisible(x)
}
