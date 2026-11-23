test_that("tool_palettes structure", {
  expect_type(tool_palettes, "list")
  expect_named(tool_palettes, c("opiate", "undertow", "aenima", "lateralus", "ten_thousand_days", "fear_inoculum"))
  
  for (name in names(tool_palettes)) {
    pal <- tool_palettes[[name]]
    
    # Has required components
    expect_named(pal, c("colors", "order", "type"))
    
    # Colors are valid 7-char hex
    expect_true(all(grepl("^#[0-9A-Fa-f]{6}$", pal$colors)))
    
    # Order is a permutation of seq_along(colors)
    expect_equal(sort(pal$order), as.integer(seq_along(pal$colors)))
    
    # Type is valid
    expect_true(pal$type %in% c("sequential", "qualitative"))
    
    # Each palette has at least 7 colors
    expect_gte(length(pal$colors), 7)
  }
})

test_that("tool_albums structure", {
  expect_type(tool_albums, "list")
  expect_equal(nrow(tool_albums), length(tool_palettes))
  expect_named(tool_albums, c("palette", "album", "year", "type", "n_colors"))
  
  # Check n_colors matches palettes
  for (i in seq_len(nrow(tool_albums))) {
    name <- tool_albums$palette[i]
    expected_n <- length(tool_palettes[[name]]$colors)
    expect_equal(tool_albums$n_colors[i], expected_n)
  }
})

test_that("tool_albums has correct metadata", {
  # Verify some specific values
  expect_true(any(tool_albums$palette == "lateralus"))
  lateralus_row <- tool_albums[tool_albums$palette == "lateralus", ]
  expect_equal(lateralus_row$album, "Lateralus")
  expect_equal(lateralus_row$year, 2001L)
})
