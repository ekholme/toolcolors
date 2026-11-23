#' Tool Album Color Palettes
#'
#' A named list of color palettes inspired by Tool album artwork.
#'
#' Each palette contains:
#' * `colors` - hex codes, listed in natural order (dark to light, or as
#'   they read in the art); used for continuous scales
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
  # Black field, maroon stone border, purple/green/magenta figure,
  # orange-red logo, white lettering.
  opiate = list(
    colors = c("#140F08", "#54242F", "#743978", "#477F3A",
               "#B51E87", "#EF3104", "#E2E0DF"),
    order  = c(6, 4, 5, 7, 3, 2, 1),
    type   = "qualitative"
  ),
  # Near-black ground into the glowing red ribcage sculpture.
  undertow = list(
    colors = c("#161415", "#3B1E1F", "#5A2427", "#7F2B2E",
               "#A23135", "#CB393C", "#F23F44"),
    order  = c(1, 7, 4, 2, 6, 3, 5),
    type   = "sequential"
  ),
  # Black-blue field, slate-teal faces, cold blue-white glow.
  aenima = list(
    colors = c("#04030E", "#1A1E2A", "#394450", "#5C757B",
               "#92A8B2", "#D5E0F2", "#FFFFFF"),
    order  = c(1, 6, 4, 2, 7, 3, 5),
    type   = "sequential"
  ),
  # Black logo, deep and mid muscle red, violet veins, gold and green flames,
  # periwinkle and lavender glow.
  lateralus = list(
    colors = c("#0D0C0C", "#502223", "#9D4847", "#806797",
               "#968045", "#9CAE6B", "#A5A5C8", "#D3C3DC"),
    order  = c(3, 5, 4, 6, 1, 8, 2, 7),
    type   = "qualitative"
  ),
  # The near-monochrome charcoal face on the cover.
  ten_thousand_days = list(
    colors = c("#020206", "#0E0E18", "#1A1A24", "#262835",
               "#323440", "#40424E", "#515460"),
    order  = c(1, 7, 4, 2, 6, 3, 5),
    type   = "sequential"
  ),
  # Black void, navy and electric-blue scales, icy highlights, gold logo.
  fear_inoculum = list(
    colors = c("#08080C", "#1B355A", "#155DAF", "#5296DF",
               "#DCE1F7", "#A5843C", "#D1B05E"),
    order  = c(3, 7, 1, 5, 2, 4, 6),
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
