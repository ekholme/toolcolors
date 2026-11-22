# toolcolors — Implementation Plan

Color palettes and ggplot2 scales inspired by the album art of Tool.
This document is the spec for implementing the package. Work through the
steps in order; each step ends with something that can be checked.

---

## 0. Ground rules for the implementer

- This is an existing `usethis` skeleton (`DESCRIPTION`, `NAMESPACE`, `R/`,
  `tests/testthat.R`, `README.qmd`, GitHub Actions R-CMD-check). Build on it;
  do not regenerate it.
- Document everything with **roxygen2** (markdown enabled). Never hand-edit
  `NAMESPACE` or `man/`; run `devtools::document()`.
- Dependencies: `ggplot2` in **Imports**; `graphics` and `grDevices` (base) in
  Imports too. `testthat`, `knitr`, `vdiffr` (optional) in Suggests. No other
  runtime dependencies.
- Use base R for argument checking (`match.arg()`, `stop(..., call. = FALSE)`).
  Do not add `rlang`/`cli` just for messages.
- Do **not** use the deprecated `scale_name` argument of
  `ggplot2::discrete_scale()` (deprecated in ggplot2 3.5.0).
- **Never commit or ship album artwork** in the package (copyright). Cover
  images used for color extraction live only in `data-raw/covers/`, which is
  git-ignored and build-ignored.
- All exported functions accept both `color` and `colour` spellings via aliases.

---

## 1. Housekeeping

1. Update `DESCRIPTION`:
   - `Title: Color Palettes Inspired by Tool Album Art`
   - `Description: Provides color palettes and 'ggplot2' color and fill scales
     inspired by the album artwork of the band Tool. Palettes can be used as
     discrete or interpolated continuous scales.`
   - `Imports: ggplot2 (>= 3.5.0), graphics, grDevices`
   - `Suggests: testthat (>= 3.0.0), knitr`
   - `URL: https://github.com/ekholme/toolcolors`
   - `BugReports: https://github.com/ekholme/toolcolors/issues`
2. Add to `.Rbuildignore`: `^data-raw$`, `^PLAN\.md$`, `^README\.qmd$`
   (already present).
3. Add to `.gitignore`: `data-raw/covers/`.
4. Add a disclaimer to README and package docs: *"This package is not
   affiliated with or endorsed by Tool or the artists. Palettes are
   interpretations inspired by the artwork."*

---

## 2. The palettes

### 2.1 Important caveat about the hex codes

The hex codes below are a **first draft** derived from descriptions of the
artwork, not eyedropped from the images. Before release, they must be
refined with the extraction script in step 8 (run on covers the author
supplies locally) and visually checked against the art. Keep the palette
*names*, *lengths*, *types* and *structure* below stable; only the hex values
should need tweaking.

### 2.2 Palette table

Each palette has:
- `colors` — hex codes, listed in "natural" order (dark → light, or as they
  read in the art). This order is used for continuous scales.
- `order` — a priority ranking of indices into `colors`. For a discrete
  palette of size `n`, use `colors[order[seq_len(n)]]`. The first few entries
  should be the most mutually distinct colors.
- `type` — `"sequential"` or `"qualitative"`; informational, shown in docs and
  `print()`, and used to pick a sensible default in `display_all()`.

| name | album (year) | artwork notes | type |
|---|---|---|---|
| `opiate` | Opiate (1992) | Grainy black-and-white/sepia photograph | sequential |
| `undertow` | Undertow (1993) | Translucent ribcage sculpture; murky greens, bone, amber on black | qualitative |
| `aenima` | Ænima (1996) | Cold blue lenticular figure; pale flesh; rust/flame accents in the packaging | qualitative |
| `lateralus` | Lateralus (2001) | Alex Grey's transparent anatomical figure: indigo, blue veins, gold, flame orange, crimson, magenta | qualitative |
| `ten_thousand_days` | 10,000 Days (2006) | Alex Grey's many-eyed figure: plum, oxblood, ochre-gold, olive, teal | qualitative |
| `fear_inoculum` | Fear Inoculum (2019) | Eye-studded serpentine mandala: black, deep teal, turquoise, bronze, gold, rust | qualitative |

### 2.3 Draft values

```r
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
```

Stretch palettes (add later, same structure, only after extracting from the
art): `salival` (Salival, 2000), `schism` / `parabola` (music-video stills),
`opiate2` (Opiate² reissue, 2022).

### 2.4 Album metadata

Also export a small data frame `tool_albums` (in `R/palettes.R`, not
`data/`), one row per palette:

| column | example |
|---|---|
| `palette` | `"lateralus"` |
| `album` | `"Lateralus"` |
| `year` | `2001L` |
| `type` | `"qualitative"` |
| `n_colors` | `8L` |

`n_colors` and `type` must be computed from `tool_palettes`, not typed twice.

---

## 3. File layout

```
R/
  toolcolors-package.R   # package-level doc ("_PACKAGE"), disclaimer
  palettes.R             # tool_palettes, tool_albums (exported, documented)
  tool_palette.R         # tool_palette(), helpers
  print.R                # print.tool_palette()
  display.R              # display_all()
  scales.R               # ggplot2 scales + British-spelling aliases
tests/testthat/
  test-palettes.R
  test-tool_palette.R
  test-scales.R
data-raw/
  extract_palette.R      # dev-only color extraction (step 8)
  check_palettes.R       # dev-only CVD / contrast checks (step 8)
  covers/                # git-ignored, user-supplied images
```

---

## 4. Core function: `tool_palette()`

```r
tool_palette(name, n, type = c("discrete", "continuous"), direction = 1)
```

Behavior:
- `name`: one of `names(tool_palettes)`. Unknown names error with a message
  listing valid names.
- `n`: number of colors. Defaults to the palette length when missing.
  Must be a single positive whole number.
- `type = "discrete"`:
  - If `n > length(colors)`, error: *"Palette 'x' has only k colors; use
    type = \"continuous\" for more."*
  - Otherwise return `colors[order[seq_len(n)]]`.
- `type = "continuous"`: return
  `grDevices::colorRampPalette(colors)(n)` (natural order, not `order`).
- `direction`: `1` or `-1`; `-1` reverses the **returned** vector. Anything
  else errors.
- Return a character vector with class `c("tool_palette", "character")` and
  attribute `name` set to the palette name.
- Exported, with roxygen examples:
  `tool_palette("lateralus")`, `tool_palette("aenima", 3)`,
  `tool_palette("fear_inoculum", 50, type = "continuous")`.

## 5. `print.tool_palette()`

- Draws the swatch in the active graphics device: `graphics::image()` of
  `seq_along(x)` with `col = x`, no axes, palette name as the title
  (`graphics::rect()` + `text()` is also fine).
- Restores `par()` on exit (`old <- par(mar = ...); on.exit(par(old))`).
- Invisibly returns `x`.
- Registered as an S3 method (`@export` on the method in roxygen).

## 6. `display_all()`

```r
display_all(type = c("all", "sequential", "qualitative"))
```

- Plots every matching palette stacked vertically in one device, labeled by
  name, each at its full length.
- Restores `par()`; returns the palette names invisibly.

---

## 7. ggplot2 scales (`R/scales.R`)

Exported functions:

| function | aliases |
|---|---|
| `scale_color_tool_d()` | `scale_colour_tool_d()` |
| `scale_fill_tool_d()` | — |
| `scale_color_tool_c()` | `scale_colour_tool_c()` |
| `scale_fill_tool_c()` | — |

Signatures:

```r
scale_color_tool_d(palette = "lateralus", direction = 1, ...)
scale_color_tool_c(palette = "lateralus", direction = 1, ...)
```

`...` is passed to the underlying ggplot2 constructor (so `name`, `labels`,
`na.value`, `guide`, etc. work).

Reference implementation (follow this pattern; it avoids the deprecated
`scale_name` argument):

```r
scale_color_tool_d <- function(palette = "lateralus", direction = 1, ...) {
  check_palette_name(palette)   # internal helper, errors early
  ggplot2::discrete_scale(
    aesthetics = "colour",
    palette = function(n) {
      unclass(tool_palette(palette, n = n, type = "discrete",
                           direction = direction))
    },
    ...
  )
}

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

scale_color_tool_c <- function(palette = "lateralus", direction = 1, ...) {
  cols <- unclass(tool_palette(palette, n = 256, type = "continuous",
                               direction = direction))
  ggplot2::scale_colour_gradientn(colours = cols, ...)
}

scale_fill_tool_c <- function(palette = "lateralus", direction = 1, ...) {
  cols <- unclass(tool_palette(palette, n = 256, type = "continuous",
                               direction = direction))
  ggplot2::scale_fill_gradientn(colours = cols, ...)
}

#' @rdname scale_color_tool_d
#' @export
scale_colour_tool_d <- scale_color_tool_d

#' @rdname scale_color_tool_c
#' @export
scale_colour_tool_c <- scale_color_tool_c
```

Document `_d` color + fill together on one help page (`@rdname`), and `_c`
color + fill together on another. Each page gets a runnable example using a
built-in dataset, e.g.

```r
library(ggplot2)
ggplot(mpg, aes(displ, hwy, color = class)) +
  geom_point() +
  scale_color_tool_d("lateralus")

ggplot(faithfuld, aes(waiting, eruptions, fill = density)) +
  geom_raster() +
  scale_fill_tool_c("fear_inoculum")
```

Note: `mpg$class` has 7 levels — every palette must have ≥ 7 colors (all do)
so the examples work for any palette.

---

## 8. Dev scripts in `data-raw/` (not part of the package)

### `data-raw/extract_palette.R`

Purpose: refine the hex codes from real cover images the author places in
`data-raw/covers/` (e.g. `lateralus.jpg`).

- Uses `magick` (dev-only; do not add to DESCRIPTION).
- Function `extract_palette(path, k = 8, seed = 1)`:
  1. `magick::image_read()` → `image_scale("200")` to downsample.
  2. Convert to an RGB pixel matrix (`as.integer(image_data(img, "rgb"))`),
     reshape to an `N x 3` matrix.
  3. Optionally convert to Lab (`grDevices::convertColor(..., from = "sRGB",
     to = "Lab")`) and run `stats::kmeans(centers = k, nstart = 10)` there.
  4. Return cluster centers as hex (via `grDevices::rgb()`), sorted by
     luminance, with cluster sizes, and draw a swatch.
- At the bottom, loop over every image in `covers/` and print results so the
  author can hand-pick colors (k-means finds dominant colors; small accent
  colors like Lateralus' magenta may need a higher `k` or manual picking).

### `data-raw/check_palettes.R`

- For each palette, plot `colorspace::swatchplot(cols, cvd = TRUE)` (or
  `colorblindcheck::palette_check(cols, plot = TRUE)`) to see how it reads
  under deuteranopia/protanopia/tritanopia.
- Report the minimum pairwise ΔE (Lab distance) among the first 3, 5, and 7
  discrete colors. Use this to tune `order` so the first few colors are the
  most distinct.
- Optional: add a `colorblind_safe` field to each palette later, based on
  this check.

---

## 9. Tests (`tests/testthat/`)

`test-palettes.R`
- Every element of `tool_palettes` has `colors`, `order`, `type`.
- All colors are valid 7-char hex (`^#[0-9A-Fa-f]{6}$`).
- `order` is a permutation of `seq_along(colors)`.
- `type` ∈ `c("sequential", "qualitative")`.
- Every palette has ≥ 7 colors.
- `tool_albums` has one row per palette and matching `n_colors`.

`test-tool_palette.R`
- Default `n` returns full length.
- Discrete `n = 3` returns `colors[order[1:3]]`.
- Discrete `n > length` errors with the "continuous" hint.
- Continuous `n = 100` returns 100 colors; first/last equal the palette's
  first/last colors.
- `direction = -1` reverses output; `direction = 2` errors.
- Unknown name errors and the message contains a valid name.
- Result has class `tool_palette` and `name` attribute.
- `print()` returns invisibly (wrap in `pdf(NULL)` / `dev.off()`).

`test-scales.R`
- Each scale function returns an object inheriting from `"Scale"`.
- Building a plot with `scale_color_tool_d()` on `mpg` +
  `ggplot2::ggplot_build()` yields colors that are all in the palette.
- `scale_fill_tool_c()` builds without error on `faithfuld`.
- `scale_colour_tool_d` is identical to `scale_color_tool_d`.
- Invalid palette name errors at scale-construction time.
- Discrete scale with more levels than colors errors on build.

---

## 10. README (`README.qmd`)

Replace the template content with:
1. One-paragraph intro + disclaimer.
2. Installation (`pak::pak("ekholme/toolcolors")`).
3. `display_all()` image.
4. One section per palette: swatch (`print(tool_palette("x"))`) + a small
   example plot (alternate scatter / bar / raster examples).
5. Usage examples for `tool_palette()`, discrete scales, continuous scales,
   `direction = -1`.

Render with `devtools::build_readme()`; commit generated figures in
`man/figures/`.

---

## 11. Definition of done

- `devtools::document()` produces no warnings.
- `devtools::test()` — all pass.
- `devtools::check()` — 0 errors, 0 warnings, 0 notes (a "new submission"
  note is acceptable).
- README renders and shows every palette.
- Hex codes have been refined via `data-raw/extract_palette.R` and visually
  confirmed against the album art by the author.

---

## 12. Suggested implementation order (one commit each)

1. Housekeeping (step 1)
2. `palettes.R` + `test-palettes.R`
3. `tool_palette.R` + `print.R` + `test-tool_palette.R`
4. `display.R`
5. `scales.R` + `test-scales.R`
6. Package doc + README
7. `data-raw/` scripts, then palette refinement
