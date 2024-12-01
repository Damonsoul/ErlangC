# > calculate_agents(
#   +   call_count = 100,
#   +   call_period = lubridate::duration(30, "minutes"),
#   +   avg_handle_time = lubridate::duration(180, "seconds"),
#   +   target_anser_time = lubridate::duration(20, "seconds"),
#   +   require_service_level = 0.8,
#   +   max_occupancy = 0.85,
#   +   shrinkage = 0.3,
#   +   max_agents = 200
#   + )
#   $traffic_intensity
#   [1] 10

#   $wait_probability
#   [1] 0.1741319

#   $service_level
#   [1] 0.88835

#   $average_speed_of_answer
#   [1] "7.83593701177724s"

#   $immediate_answer_probability
#   [1] 0.8258681

#   $occupancy
#   [1] 0.7142857

#   $agents
#   [1] 14

#   $process
#        traffic_intensity wait_probability service_level average_speed_of_answer
#   [1,] 10                0.6821182        0.3896138     122.78127684408s (~2.05 minutes)
#   [2,] 10                0.4493882        0.640158      40.4449401868444s
#   [3,] 10                0.2852705        0.7955948     17.1162271821896s
#   [4,] 10                0.1741319        0.88835       7.83593701177724s
#        immediate_answer_probability occupancy agents
#   [1,] 0.3178818                    0.9090909 11
#   [2,] 0.5506118                    0.8333333 12
#   [3,] 0.7147295                    0.7692308 13
#   [4,] 0.8258681                    0.7142857 14

#   $agents_shrinked
#   [1] 20
test_that("calculate_agents shrinkage test case", {
  expect_equal(calculate_agents(100, lubridate::duration(30, "minutes"), lubridate::duration(180, "seconds"), lubridate::duration(20, "seconds"), 0.8, 0.85, 0.3, 200)$agents_shrinked, 20)
})

test_that("calculate_agents agents test case", {
  expect_equal(calculate_agents(100, lubridate::duration(30, "minutes"), lubridate::duration(180, "seconds"), lubridate::duration(20, "seconds"), 0.8, 0.85, 0.3, 200)$agents, 14)
})
