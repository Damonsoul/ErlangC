
# ErlangC

This package provides a set of functions to solve Erlang-C model.

## Installation

You can install the development version of ErlangC from
[GitHub](https://github.com/) with:

``` r
# install.packages("pak")
pak::pak("Damonsoul/ErlangC")
```

## Example

the example below shows how to calculate Erlang-C metrics.

``` r
library(ErlangC)
erlang_c(100, lubridate::duration(30, "minutes"), lubridate::duration(180, "seconds"), lubridate::duration(20, "seconds"), 14)
#> $traffic_intensity
#> [1] 10
#> 
#> $wait_probability
#> [1] 0.1741319
#> 
#> $service_level
#> [1] 0.88835
#> 
#> $average_speed_of_answer
#> [1] "7.83593701177724s"
#> 
#> $immediate_answer_probability
#> [1] 0.8258681
#> 
#> $occupancy
#> [1] 0.7142857
```

The example below shows how to calculate the number of agents required
for an Erlang-C model.

``` r
calculate_agents(
  call_count = 100,
  call_period = lubridate::duration(30, "minutes"),
  avg_handle_time = lubridate::duration(180, "seconds"),
  target_anser_time = lubridate::duration(20, "seconds"),
  require_service_level = 0.8,
  max_occupancy = 0.85,
  shrinkage = 0.3,
  max_agents = 200
)
#> $traffic_intensity
#> [1] 10
#> 
#> $wait_probability
#> [1] 0.1741319
#> 
#> $service_level
#> [1] 0.88835
#> 
#> $average_speed_of_answer
#> [1] "7.83593701177724s"
#> 
#> $immediate_answer_probability
#> [1] 0.8258681
#> 
#> $occupancy
#> [1] 0.7142857
#> 
#> $agents
#> [1] 14
#> 
#> $process
#>      traffic_intensity wait_probability service_level
#> [1,] 10                0.6821182        0.3896138    
#> [2,] 10                0.4493882        0.640158     
#> [3,] 10                0.2852705        0.7955948    
#> [4,] 10                0.1741319        0.88835      
#>      average_speed_of_answer          immediate_answer_probability occupancy
#> [1,] 122.78127684408s (~2.05 minutes) 0.3178818                    0.9090909
#> [2,] 40.4449401868444s                0.5506118                    0.8333333
#> [3,] 17.1162271821896s                0.7147295                    0.7692308
#> [4,] 7.83593701177724s                0.8258681                    0.7142857
#>      agents
#> [1,] 11    
#> [2,] 12    
#> [3,] 13    
#> [4,] 14    
#> 
#> $agents_shrinked
#> [1] 20
```

the example below shows how to use the Shiny app for Erlang-C metrics.

``` r
erlang_c_app()
```

![](./man/figures/README-ShinyApp.jpg)
