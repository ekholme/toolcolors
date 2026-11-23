

<!-- README.md is generated from README.qmd. Please edit that file -->

# toolcolors

<!-- badges: start -->

[![R-CMD-check](https://github.com/ekholme/toolcolors/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/ekholme/toolcolors/actions/workflows/R-CMD-check.yaml)
<!-- badges: end -->

This package provides color palettes and `ggplot2` color and fill scales
inspired by the album artwork of Tool.

**Disclaimer:** This package is not affiliated with or endorsed by Tool
or the artists. Palettes are interpretations inspired by the artwork.

## Installation

You can install the development version of toolcolors from
[GitHub](https://github.com/) with:

``` r
# install.packages("pak")
pak::pak("ekholme/toolcolors")
```

## Example palettes

See all palettes at once:

``` r
library(toolcolors)
display_all()
```

<img src="man/figures/README-unnamed-chunk-2-1.png"
style="width:100.0%" />

Or display individual palettes:

``` r
print(tool_palette("lateralus"))
```

<img src="man/figures/README-unnamed-chunk-3-1.png"
style="width:100.0%" />

``` r
print(tool_palette("fear_inoculum"))
```

<img src="man/figures/README-unnamed-chunk-3-2.png"
style="width:100.0%" />

## Usage

### Discrete scales

``` r
library(ggplot2)
ggplot(mpg, aes(displ, hwy, color = class)) +
  geom_point() +
  scale_color_tool_d("lateralus")
```

<img src="man/figures/README-unnamed-chunk-4-1.png"
style="width:100.0%" />

### Continuous scales

``` r
ggplot(faithfuld, aes(waiting, eruptions, fill = density)) +
  geom_raster() +
  scale_fill_tool_c("fear_inoculum")
```

<img src="man/figures/README-unnamed-chunk-5-1.png"
style="width:100.0%" />

### Reverse direction

``` r
print(tool_palette("undertow", direction = -1))
```

<img src="man/figures/README-unnamed-chunk-6-1.png"
style="width:100.0%" />
