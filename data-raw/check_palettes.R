# Dev-only: check how distinct each palette's discrete colors are.
#
# Reports the minimum pairwise CIE76 delta-E (Lab distance) among the first
# 3, 5 and 7 colors of each palette's discrete `order`. Low values (< ~10)
# mean two colors are hard to tell apart. If `colorspace` is installed, also
# draws swatches under simulated color-vision deficiencies.
#
# Run from the package root:  Rscript data-raw/check_palettes.R

devtools::load_all(quiet = TRUE)

min_delta_e <- function(cols) {
  lab <- grDevices::convertColor(t(grDevices::col2rgb(cols)) / 255,
                                 from = "sRGB", to = "Lab")
  min(stats::dist(lab))
}

report <- do.call(rbind, lapply(names(tool_palettes), function(name) {
  pal <- tool_palettes[[name]]
  ns <- c(3, 5, 7)
  data.frame(
    palette = name,
    type = pal$type,
    t(vapply(ns, function(n) {
      round(min_delta_e(tool_palette(name, n)), 1)
    }, numeric(1), USE.NAMES = FALSE)) |>
      `colnames<-`(paste0("min_dE_first_", ns))
  )
}))
print(report, row.names = FALSE)

if (requireNamespace("colorspace", quietly = TRUE) && interactive()) {
  for (name in names(tool_palettes)) {
    colorspace::swatchplot(unclass(tool_palette(name)), cvd = TRUE)
    title(name)
  }
}
