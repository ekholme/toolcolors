#' Tool color and fill scales for ggplot2
#'
#' @description
#' Discrete scales (`_d`) sample colors using the palette's `order` vector.
#' Continuous scales (`_c`) interpolate between colors in natural order.
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


check_palette_name <- function(name) {
  if (!name %in% names(tool_palettes)) {
    valid_names <- paste(sQuote(names(tool_palettes)), collapse = ", ")
    stop("Unknown palette '",
         name, "'. Valid names: ",
         valid_names, call. = FALSE)
  }
}


#' @rdname tool_scales
#' @export
scale_color_tool_d <- function(palette = "lateralus", direction = 1, ...) {
  check_palette_name(palette)
  
  ggplot2::discrete_scale(
    aesthetics = "colour",
    palette = function(n) {
      unclass(tool_palette(palette, n = n, type = "discrete",
                           direction = direction))
    },
    ...
  )
}

#' @rdname tool_scales
#' @export
scale_fill_tool_d <- function(palette = "lateralus", direction = 1, ...) {
  check_palette_name(palette)
  
  ggplot2::discrete_scale(
    aesthetics = "fill",
    palette = function(n) {
      unclass(tool_palette(palette, n = n, type = "discrete",
                           direction = direction))
    },
    ...
  )
}

#' @rdname tool_scales
#' @export
scale_color_tool_c <- function(palette = "lateralus", direction = 1, ...) {
  cols <- unclass(tool_palette(palette, n = 256, type = "continuous",
                               direction = direction))
  ggplot2::scale_colour_gradientn(colours = cols, ...)
}

#' @rdname tool_scales
#' @export
scale_fill_tool_c <- function(palette = "lateralus", direction = 1, ...) {
  cols <- unclass(tool_palette(palette, n = 256, type = "continuous",
                               direction = direction))
  ggplot2::scale_fill_gradientn(colours = cols, ...)
}

# British spelling aliases

#' @title Tool color and fill scales for ggplot2 (British spelling)
#' @param palette Palette name (one of `names(tool_palettes)`).
#' @param direction `1` (forward) or `-1` (reverse).
#' @param ... Additional arguments passed to the underlying ggplot2 scale function.
#' @export
scale_colour_tool_d <- function(palette = "lateralus", direction = 1, ...) {
  check_palette_name(palette)
  
  ggplot2::discrete_scale(
    aesthetics = "colour",
    palette = function(n) {
      unclass(tool_palette(palette, n = n, type = "discrete",
                           direction = direction))
    },
    ...
  )
}

#' @title Tool color and fill scales for ggplot2 (British spelling)
#' @param palette Palette name (one of `names(tool_palettes)`).
#' @param direction `1` (forward) or `-1` (reverse).
#' @param ... Additional arguments passed to the underlying ggplot2 scale function.
#' @export
scale_colour_tool_c <- function(palette = "lateralus", direction = 1, ...) {
  cols <- unclass(tool_palette(palette, n = 256, type = "continuous",
                               direction = direction))
  ggplot2::scale_colour_gradientn(colours = cols, ...)
}
