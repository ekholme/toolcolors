#' Tool Album Color Palettes
#'
#' A named list of color palettes inspired by Tool album artwork.
#'
#' Each palette contains:
#' * `colors` - hex codes, listed in natural order (dark to light)
#' * `order` - priority ranking of indices for discrete sampling
#' * `type` - either "sequential" or "qualitative"
#'
#' @format A named list with 6 elements: `opiate`, `undertow`, `aenima`,
#'   `lateralus`, `ten_thousand_days`, and `fear_inoculum`.
#'
#' @examples
#' tool_palettes$lateralus
#' print(tool_palette("lateralus"))
#' @export
tool_palettes <- list(
  opiate = list(
    colors = c("#0D0D0D", "#2B2724", "#4A433D", "#6E655C",
               "#968B7F", "#BDB3A6", "#E4DDD2"),
    order  = c(1, 7, 4, 2, 6, 3, 5),
    type   = "sequential"
  ),
  undertow = list(
    colors = c("#101614", "#24332E", "#3F5A50", "#6F8C7A",
               "#A9B89A", "#D8CFA3", "#C98F3B"),
    order  = c(3, 7, 6, 1, 4, 5, 2),
    type   = "qualitative"
  ),
  aenima = list(
    colors = c("#0B1A2E", "#1F3B5C", "#3A6B8C", "#7FA7B8",
               "#D9D4C7", "#C4622D", "#7A2E1C"),
    order  = c(2, 6, 4, 7, 5, 1, 3),
    type   = "qualitative"
  ),
  lateralus = list(
    colors = c("#0A0A12", "#2A1B5E", "#1F6FB2", "#E8A33D",
               "#E0602A", "#B8213A", "#D94F8C", "#F3E3C3"),
    order  = c(3, 4, 6, 2, 5, 7, 8, 1),
    type   = "qualitative"
  ),
  ten_thousand_days = list(
    colors = c("#1A0F1E", "#4B1D3F", "#8C1C2B", "#C2562B",
               "#D9A441", "#5E7D4A", "#2F5D62"),
    order  = c(3, 5, 7, 2, 6, 4, 1),
    type   = "qualitative"
  ),
  fear_inoculum = list(
    colors = c("#050608", "#0E3B43", "#1E7A7A", "#5FC1B5",
               "#B8862F", "#E2B857", "#8E2A1E"),
    order  = c(3, 6, 7, 2, 4, 5, 1),
    type   = "qualitative"
  )
)

#' Tool Album Metadata
#'
#' A data frame with information about each palette.
#'
#' @format A data.frame with 6 rows and 5 columns:
#' * `palette` - the palette name (character)
#' * `album` - album title (character)
#' * `year` - release year (integer)
#' * `type` - "sequential" or "qualitative" (character)
#' * `n_colors` - number of colors in the palette (integer)
#'
#' @examples
#' tool_albums
#' @export
tool_albums <- do.call(rbind, lapply(names(tool_palettes), function(name) {
  pal <- tool_palettes[[name]]
  data.frame(
    palette = name,
    album = switch(name,
      opiate = "Opiate",
      undertow = "Undertow",
      aenima = "\u00c6nima",
      lateralus = "Lateralus",
      ten_thousand_days = "10,000 Days",
      fear_inoculum = "Fear Inoculum"
    ),
    year = switch(name,
      opiate = 1992L,
      undertow = 1993L,
      aenima = 1996L,
      lateralus = 2001L,
      ten_thousand_days = 2006L,
      fear_inoculum = 2019L
    ),
    type = pal$type,
    n_colors = length(pal$colors),
    stringsAsFactors = FALSE
  )
}))
