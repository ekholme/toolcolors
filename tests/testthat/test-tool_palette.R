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
  cols <- tool_palettes$lateralus$colors
  expect_equal(p[1], cols[1])
  expect_equal(p[100], cols[length(cols)])
})

test_that("tool_palette direction = -1 reverses output", {
  p_forward <- unclass(tool_palette("undertow", n = 4))
  p_reverse <- unclass(tool_palette("undertow", n = 4, direction = -1))
  
  # rev() drops attributes, so compare values only
  expect_equal(as.character(p_reverse), rev(as.character(p_forward)))
})

test_that("tool_palette direction other than 1 or -1 errors", {
  expect_error(tool_palette("lateralus", direction = 2), "'direction' must be 1 or -1")
  expect_error(tool_palette("lateralus", direction = c(1, -1)), "'direction'")
  expect_error(tool_palette("lateralus", direction = NA), "'direction'")
})

test_that("tool_palette rejects invalid n", {
  for (bad in list(0, -1, 2.5, NA_real_, c(2, 3), "3")) {
    expect_error(tool_palette("lateralus", n = bad), "'n' must be")
  }
})

test_that("tool_palette continuous direction reverses the ramp", {
  fwd <- as.character(tool_palette("undertow", 20, type = "continuous"))
  rev <- as.character(tool_palette("undertow", 20, type = "continuous",
                                   direction = -1))
  expect_equal(rev, rev(fwd))
})

test_that("tool_palette unknown name errors with valid names in message", {
  expect_error(tool_palette("unknown"), "opiate.*undertow.*aenima")
  expect_error(tool_palette(NA_character_), "Valid names:")
  expect_error(tool_palette(c("opiate", "aenima")), "Valid names:")
  expect_error(tool_palette(1), "Valid names:")
})

test_that("tool_palette returns correct class and attributes", {
  p <- tool_palette("lateralus")
  expect_s3_class(p, "tool_palette")
  expect_type(p, "character")
  expect_equal(attr(p, "name"), "lateralus")
})

test_that("print.tool_palette works without error", {
  pdf(NULL)
  on.exit(dev.off(), add = TRUE)
  
  p <- tool_palette("undertow")  # full palette
  # Just check it runs without error and returns invisibly
  expect_invisible(result <- print(p))
  expect_identical(result, p)
})

test_that("display_all draws and returns palette names invisibly", {
  pdf(NULL)
  on.exit(dev.off(), add = TRUE)

  expect_invisible(out <- display_all())
  expect_equal(out, names(tool_palettes))

  seq_names <- display_all("sequential")
  expect_true(all(vapply(tool_palettes[seq_names],
                         function(p) p$type == "sequential", logical(1))))
})
