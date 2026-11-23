#' Tool color and fill scales for ggplot2
#'
#' @description
#' Discrete scales (`_d`) sample colors using the palette's `order` vector.
#' Continuous scales (`_c`) interpolate between colors in natural order.
#'
#' Discrete scales error if the data have more levels than the palette has
#' colors; use a continuous scale or fewer levels in that case.
#'
#' @param palette Palette name (one of `names(tool_palettes)`).
#' @param direction `1` (forward) or `-1` (reverse).
#' @param ... Additional arguments passed to the underlying ggplot2 scale function
#'   (`name`, `labels`, `na.value`, `guide`, etc.).
#'
#' @return A ggplot2 scale object.
#'
#' @examples
#' library(ggplot2)
#' ggplot(mpg, aes(displ, hwy, color = class)) +
#'   geom_point() +
#'   scale_color_tool_d("lateralus")
#'
#' ggplot(faithfuld, aes(waiting, eruptions, fill = density)) +
#'   geom_raster() +
#'   scale_fill_tool_c("fear_inoculum")
#'
#' @name tool_scales
NULL

tool_discrete_pal <- function(palette, direction) {
  check_palette_name(palette)
  check_direction(direction)
  n_max <- length(tool_palettes[[palette]]$colors)
  function(n) {
    if (n > n_max) {
      stop("Palette '", palette, "' has only ", n_max,
           " colors but the data have ", n, " levels.", call. = FALSE)
    }
    as.character(tool_palette(palette, n = n, type = "discrete",
                              direction = direction))
  }
}

tool_continuous_cols <- function(palette, direction) {
  as.character(tool_palette(palette, n = 256, type = "continuous",
                            direction = direction))
}

#' @rdname tool_scales
#' @export
scale_color_tool_d <- function(palette = "lateralus", direction = 1, ...) {
  ggplot2::discrete_scale(
    aesthetics = "colour",
    palette = tool_discrete_pal(palette, direction),
    ...
  )
}

#' @rdname tool_scales
#' @export
scale_fill_tool_d <- function(palette = "lateralus", direction = 1, ...) {
  ggplot2::discrete_scale(
    aesthetics = "fill",
    palette = tool_discrete_pal(palette, direction),
    ...
  )
}

#' @rdname tool_scales
#' @export
scale_color_tool_c <- function(palette = "lateralus", direction = 1, ...) {
  ggplot2::scale_colour_gradientn(
    colours = tool_continuous_cols(palette, direction), ...
  )
}

#' @rdname tool_scales
#' @export
scale_fill_tool_c <- function(palette = "lateralus", direction = 1, ...) {
  ggplot2::scale_fill_gradientn(
    colours = tool_continuous_cols(palette, direction), ...
  )
}

#' @rdname tool_scales
#' @export
scale_colour_tool_d <- scale_color_tool_d

#' @rdname tool_scales
#' @export
scale_colour_tool_c <- scale_color_tool_c
