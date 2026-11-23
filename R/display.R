#' Display all palettes
#'
#' Plots every matching palette, stacked vertically and labeled by name.
#'
#' @param type Filter by palette type: `"all"`, `"sequential"`, or `"qualitative"`.
#'
#' @return Invisibly returns the names of displayed palettes.
#'
#' @examples
#' display_all()
#' display_all("sequential")
#' @export
display_all <- function(type = c("all", "sequential", "qualitative")) {
  type <- match.arg(type)

  pal_names <- names(tool_palettes)
  if (type != "all") {
    is_type <- vapply(tool_palettes, function(p) p$type == type, logical(1))
    pal_names <- pal_names[is_type]
  }

  n <- length(pal_names)
  if (n == 0) {
    return(invisible(character(0)))
  }

  old_par <- graphics::par(mfrow = c(n, 1), mar = c(0.3, 0.5, 1.5, 0.5))
  on.exit(graphics::par(old_par), add = TRUE)

  for (name in pal_names) {
    pal <- tool_palettes[[name]]
    n_colors <- length(pal$colors)

    graphics::plot.new()
    graphics::plot.window(xlim = c(0, n_colors), ylim = c(0, 1),
                          xaxs = "i", yaxs = "i")
    graphics::rect(xleft = seq_len(n_colors) - 1, ybottom = 0,
                   xright = seq_len(n_colors), ytop = 1,
                   col = pal$colors, border = NA)
    graphics::title(main = paste0(name, " (", pal$type, ")"),
                    adj = 0, cex.main = 1, font.main = 1)
  }

  invisible(pal_names)
}
