#' Tool Palette
#'
#' Return a color palette from the tool_palettes collection.
#'
#' @param name Palette name (one of `names(tool_palettes)`).
#' @param n Number of colors to return. Defaults to full palette length.
#' @param type `"discrete"` or `"continuous"`.
#'   Discrete returns a subset using the palette's order; continuous
#'   interpolates between colors.
#' @param direction `1` (forward) or `-1` (reverse).
#'
#' @return A character vector of hex codes with class `c("tool_palette", "character")`
#'   and attribute `"name"` set to the palette name.
#'
#' @examples
#' tool_palette("lateralus")
#' tool_palette("aenima", 3)
#' tool_palette("fear_inoculum", 50, type = "continuous")
#'
#' # Reverse direction
#' print(tool_palette("undertow", direction = -1))
#'
#' @export
tool_palette <- function(name, n = NULL, type = c("discrete", "continuous"),
                         direction = 1) {
  type <- match.arg(type)
  
  # Check palette name
  if (!name %in% names(tool_palettes)) {
    valid_names <- paste(sQuote(names(tool_palettes)), collapse = ", ")
    stop("Unknown palette '",
         name, "'. Valid names: ",
         valid_names, call. = FALSE)
  }
  
  pal <- tool_palettes[[name]]
  
  # Set n
  if (is.null(n)) {
    n <- length(pal$colors)
  }
  
  # Validate n
  if (!is.numeric(n) || length(n) != 1 || n < 1 || floor(n) != n) {
    stop("'n' must be a single positive whole number", call. = FALSE)
  }
  
  # Validate direction
  if (direction != 1 && direction != -1) {
    stop("'direction' must be 1 or -1", call. = FALSE)
  }
  
  # Get colors based on type
  if (type == "discrete") {
    if (n > length(pal$colors)) {
      stop("Palette '", name, "' has only ",
           length(pal$colors), " colors; use type = \"continuous\" for more.",
           call. = FALSE)
    }
    cols <- pal$colors[pal$order[seq_len(n)]]
  } else {
    # Continuous: interpolate in natural order
    ramp <- grDevices::colorRampPalette(pal$colors)
    cols <- ramp(n)
  }
  
  # Apply direction
  if (direction == -1) {
    cols <- rev(cols)
  }
  
  # Set class and attribute
  structure(cols, class = c("tool_palette", "character"), name = name)
}
