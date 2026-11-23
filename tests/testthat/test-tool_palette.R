test_that("tool_palette returns full palette by default", {
  p <- tool_palette("lateralus")
  expect_length(p, 8)
  # Compare values ignoring class and attributes
  expect_equal(as.character(p), unclass(tool_palettes$lateralus$colors[tool_palettes$lateralus$order]))
})

test_that("tool_palette discrete n = 3", {
  p <- tool_palette("lateralus", n = 3)
  expect_length(p, 3)
  expected <- unclass(tool_palettes$lateralus$colors[tool_palettes$lateralus$order][1:3])
  expect_equal(as.character(p), expected)
})

test_that("tool_palette discrete n > length errors", {
  expect_error(
    tool_palette("opiate", n = 10),
    "only 7 colors.*continuous",
    ignore.case = TRUE
  )
})

test_that("tool_palette continuous returns interpolated colors", {
  p <- tool_palette("lateralus", n = 100, type = "continuous")
  expect_length(p, 100)
  
  # First and last should match palette ends (natural order for continuous)
  first_match <- isTRUE(all.equal(p[1], tool_palettes$lateralus$colors[1]))
  last_match <- isTRUE(all.equal(p[100], tool_palettes$lateralus$colors[length(tool_palettes$lateralus$colors)]))
  expect_true(first_match && last_match)
})

test_that("tool_palette direction = -1 reverses output", {
  p_forward <- unclass(tool_palette("undertow", n = 4))
  p_reverse <- unclass(tool_palette("undertow", n = 4, direction = -1))
  
  # rev() drops attributes, so compare values only
  expect_equal(as.character(p_reverse), rev(as.character(p_forward)))
})

test_that("tool_palette direction other than 1 or -1 errors", {
  expect_error(tool_palette("lateralus", direction = 2), "'direction' must be 1 or -1")
})

test_that("tool_palette unknown name errors with valid names in message", {
  expect_error(
    tool_palette("unknown"),
    "opiate.*undertow.*aenima",
    ignore.case = FALSE
  )
})

test_that("tool_palette returns correct class and attributes", {
  p <- tool_palette("lateralus")
  expect_s3_class(p, "tool_palette")
  expect_s3_class(p, "character")
  expect_equal(attr(p, "name"), "lateralus")
})

test_that("print.tool_palette works without error", {
  pdf(NULL)
  on.exit(dev.off(), add = TRUE)
  
  p <- tool_palette("undertow")  # full palette
  # Just check it runs without error and returns invisibly
  result <- print(p)
  expect_identical(result, invisible(p))
})