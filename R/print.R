#' Print a tool palette
#'
#' Draws the palette as a swatch in the active graphics device.
#'
#' @param x A `tool_palette` object.
#' @param ... Unused.
#'
#' @return Invisibly returns `x`.
#' @export
print.tool_palette <- function(x, ...) {
  n <- length(x)
  old_par <- graphics::par(mar = c(0.5, 0.5, 2, 0.5))
  on.exit(graphics::par(old_par), add = TRUE)

  graphics::image(seq_len(n), 1, as.matrix(seq_len(n)),
                  col = unclass(x), axes = FALSE, xlab = "", ylab = "")
  graphics::title(main = attr(x, "name"))

  invisible(x)
}
