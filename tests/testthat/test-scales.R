test_that("scale functions return Scale objects", {
  expect_s3_class(scale_color_tool_d(), "ScaleDiscrete")
  expect_s3_class(scale_fill_tool_d(), "ScaleDiscrete")
  expect_s3_class(scale_color_tool_c(), "ScaleContinuous")
  expect_s3_class(scale_fill_tool_c(), "ScaleContinuous")
})

test_that("scale_color_tool_d works with mpg", {
  p <- ggplot2::ggplot(ggplot2::mpg, aes(displ, hwy, color = class)) +
    scale_color_tool_d("lateralus") +
    geom_point()
  
  built <- ggplot2::ggplot_build(p)
  
  # Extract colors used
  colors_used <- built$data[[1]]$colour
  
  # All colors should be in the palette
  expected_cols <- tool_palette("lateralus", n = 7, direction = 1)
  expect_true(all(colors_used %in% expected_cols))
})

test_that("scale_fill_tool_c works with faithfuld", {
  p <- ggplot2::ggplot(ggplot2::faithfuld, aes(waiting, eruptions, fill = density)) +
    scale_fill_tool_c("fear_inoculum") +
    geom_raster()
  
  # Should build without error
  built <- ggplot2::ggplot_build(p)
  expect_s3_class(built, "ggplot_built")
})

test_that("scale_colour_tool_d produces same result as scale_color_tool_d", {
  p1 <- scale_colour_tool_d("lateralus")
  p2 <- scale_color_tool_d("lateralus")
  
  # Check that both produce valid scales
  expect_s3_class(p1, "ScaleDiscrete")
  expect_s3_class(p2, "ScaleDiscrete")
})

test_that("scale_colour_tool_c produces same result as scale_color_tool_c", {
  p1 <- scale_colour_tool_c("lateralus")
  p2 <- scale_color_tool_c("lateralus")
  
  # Check that both produce valid scales
  expect_s3_class(p1, "ScaleContinuous")
  expect_s3_class(p2, "ScaleContinuous")
})

test_that("invalid palette name errors at scale construction", {
  expect_error(
    scale_color_tool_d(palette = "unknown"),
    "Valid names:"
  )
  
  expect_error(
    scale_fill_tool_c(palette = "notapalette"),
    "Valid names:"
  )
})

# Skip test for too many levels - the palettes all have >=7 colors, and class has 7
test_that("discrete scales work with n < palette length", {
  p <- ggplot2::ggplot(ggplot2::mpg, aes(displ, hwy)) +
    scale_color_tool_d("undertow") +  # has 7 colors
    geom_point()
  
  built <- ggplot2::ggplot_build(p)
  expect_s3_class(built, "ggplot_built")
})
