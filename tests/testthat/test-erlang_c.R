test_that("elang_c test immediate_answer_probability case", {
  expect_equal(erlang_c(100, lubridate::duration(30, "minutes"), lubridate::duration(180, "seconds"), lubridate::duration(20, "seconds"), 14)$immediate_answer_probability, 0.82586807)
})

test_that("elang_c test occupancy case", {
  expect_equal(erlang_c(100, lubridate::duration(30, "minutes"), lubridate::duration(180, "seconds"), lubridate::duration(20, "seconds"), 14)$occupancy, 0.71428571)
})


test_that("elang_c test service_level case", {
  expect_equal(erlang_c(100, lubridate::duration(30, "minutes"), lubridate::duration(180, "seconds"), lubridate::duration(20, "seconds"), 14)$service_level, 0.88835002)
})



test_that("elang_c test traffic_intensity case", {
  expect_equal(erlang_c(100, lubridate::duration(30, "minutes"), lubridate::duration(180, "seconds"), lubridate::duration(20, "seconds"), 14)$traffic_intensity, 10)
})
