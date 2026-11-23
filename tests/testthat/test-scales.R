test_that("scale functions return Scale objects", {
  expect_s3_class(scale_color_tool_d(), "ScaleDiscrete")
  expect_s3_class(scale_fill_tool_d(), "ScaleDiscrete")
  expect_s3_class(scale_color_tool_c(), "ScaleContinuous")
  expect_s3_class(scale_fill_tool_c(), "ScaleContinuous")
})

test_that("scales target the right aesthetics", {
  expect_equal(scale_color_tool_d()$aesthetics, "colour")
  expect_equal(scale_fill_tool_d()$aesthetics, "fill")
  expect_equal(scale_color_tool_c()$aesthetics, "colour")
  expect_equal(scale_fill_tool_c()$aesthetics, "fill")
})

test_that("scale_color_tool_d maps levels to the palette's discrete order", {
  p <- ggplot2::ggplot(ggplot2::mpg,
                       ggplot2::aes(displ, hwy, colour = class)) +
    ggplot2::geom_point() +
    scale_color_tool_d("lateralus")

  built <- ggplot2::ggplot_build(p)
  colors_used <- unique(built$data[[1]]$colour)

  expected <- as.character(tool_palette("lateralus", n = 7))
  expect_setequal(colors_used, expected)
})

test_that("direction = -1 reverses the discrete mapping", {
  pal_fwd <- scale_fill_tool_d("aenima")$palette(4)
  pal_rev <- scale_fill_tool_d("aenima", direction = -1)$palette(4)
  expect_equal(pal_rev, rev(pal_fwd))
})

test_that("scale_fill_tool_c works with faithfuld", {
  p <- ggplot2::ggplot(ggplot2::faithfuld,
                       ggplot2::aes(waiting, eruptions, fill = density)) +
    ggplot2::geom_raster() +
    scale_fill_tool_c("fear_inoculum")

  built <- ggplot2::ggplot_build(p)
  fills <- built$data[[1]]$fill
  expect_false(anyNA(fills))
  expect_true(all(grepl("^#[0-9A-F]{6}$", fills)))
})

test_that("British spelling aliases are identical", {
  expect_identical(scale_colour_tool_d, scale_color_tool_d)
  expect_identical(scale_colour_tool_c, scale_color_tool_c)
})

test_that("invalid arguments error at scale construction", {
  expect_error(scale_color_tool_d(palette = "unknown"), "Valid names:")
  expect_error(scale_fill_tool_d(palette = "unknown"), "Valid names:")
  expect_error(scale_color_tool_c(palette = "unknown"), "Valid names:")
  expect_error(scale_fill_tool_c(palette = "notapalette"), "Valid names:")
  expect_error(scale_color_tool_d(direction = 0), "'direction'")
})

test_that("discrete scale with more levels than colors errors on build", {
  df <- data.frame(x = 1:9, y = 1:9, g = letters[1:9])
  p <- ggplot2::ggplot(df, ggplot2::aes(x, y, colour = g)) +
    ggplot2::geom_point() +
    scale_color_tool_d("opiate")  # 7 colors
  expect_error(ggplot2::ggplot_build(p), "only 7 colors")
})
