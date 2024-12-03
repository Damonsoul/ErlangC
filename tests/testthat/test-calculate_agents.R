
test_that("calculate_agents shrinkage test case", {
  expect_equal(calculate_agents(100, lubridate::duration(30, "minutes"), lubridate::duration(180, "seconds"), lubridate::duration(20, "seconds"), 0.8, 0.85, 0.3, 200)$agents_shrinked, 20)
})

test_that("calculate_agents agents test case", {
  expect_equal(calculate_agents(100, lubridate::duration(30, "minutes"), lubridate::duration(180, "seconds"), lubridate::duration(20, "seconds"), 0.8, 0.85, 0.3, 200)$agents, 14)
})
