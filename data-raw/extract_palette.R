# Dev-only: extract candidate palette colors from album cover images.
#
# Place cover images in data-raw/covers/ (git-ignored; never commit artwork),
# named after the palette, e.g. data-raw/covers/lateralus.jpg.
#
# Pixels are read through the ImageMagick command-line tool (`magick`), so no
# extra R packages are needed. Run from the package root:
#   Rscript data-raw/extract_palette.R

read_pixels <- function(path, size = 200) {
  magick <- Sys.which("magick")
  if (!nzchar(magick)) stop("ImageMagick `magick` CLI not found on PATH")
  args <- c(shQuote(path), "-alpha", "off", "-colorspace", "sRGB",
            "-resize", paste0(size, "x", size, "!"), "-depth", "8")
  tmp <- tempfile(fileext = ".rgb")
  on.exit(unlink(tmp), add = TRUE)
  status <- system2(magick, c(args, paste0("rgb:", tmp)))
  if (!identical(status, 0L)) stop("magick failed on ", path)
  bytes <- readBin(tmp, "raw", n = file.size(tmp))
  matrix(as.integer(bytes), ncol = 3, byrow = TRUE) / 255
}

# `min_chroma` > 0 keeps only saturated pixels (Lab chroma above the cutoff),
# which surfaces small accent colors that k-means otherwise averages away.
extract_palette <- function(path, k = 8, seed = 1, plot = TRUE,
                            min_chroma = 0) {
  px <- read_pixels(path)
  lab <- grDevices::convertColor(px, from = "sRGB", to = "Lab")
  if (min_chroma > 0) {
    lab <- lab[sqrt(lab[, 2]^2 + lab[, 3]^2) >= min_chroma, , drop = FALSE]
  }
  set.seed(seed)
  km <- stats::kmeans(lab, centers = k, nstart = 10, iter.max = 100,
                       algorithm = "MacQueen")
  rgb_centers <- grDevices::convertColor(km$centers, from = "Lab", to = "sRGB")
  rgb_centers <- pmin(pmax(rgb_centers, 0), 1)
  out <- data.frame(
    hex = grDevices::rgb(rgb_centers),
    L = round(km$centers[, 1], 1),
    share = round(as.numeric(table(factor(km$cluster, levels = seq_len(k)))) /
                    nrow(lab), 3)
  )
  out <- out[order(out$L), ]
  rownames(out) <- NULL
  if (plot) {
    graphics::barplot(rep(1, k), col = out$hex, border = NA, axes = FALSE,
                      names.arg = out$hex, las = 2, cex.names = 0.7,
                      main = basename(path))
  }
  out
}

if (sys.nframe() == 0L) {
  covers <- list.files("data-raw/covers", pattern = "\\.(jpe?g|png)$",
                       full.names = TRUE, ignore.case = TRUE)
  if (length(covers) == 0) stop("No cover images in data-raw/covers/")
  for (path in covers) {
    cat("\n==", basename(path), "==\n")
    cat("-- all pixels\n")
    print(extract_palette(path, k = 10, plot = FALSE))
    cat("-- saturated pixels only (chroma >= 25)\n")
    print(tryCatch(extract_palette(path, k = 8, plot = FALSE, min_chroma = 25),
                   error = function(e) "too few saturated pixels"))
  }
}
