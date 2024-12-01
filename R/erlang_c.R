#' Erlang C
#'
#' Calculate the performance metrics of an Erlang C model with \code{n} agents.
#'
#' @param call_count Numeric. The total number of incoming calls.
#' @param call_period Duration. The time period over which calls are counted.
#' @param avg_handle_time Duration. The average time taken to handle a call.
#' @param target_anser_time Duration. The targeted time to answer a call.
#' @param n Integer. The number of agents.
#'
#' @return A list containing the calculated metrics.
#' @export
#'
#' @examples
#' erlang_c(
#'   call_count = 100,
#'   call_period = lubridate::duration(30, "minutes"),
#'   avg_handle_time = lubridate::duration(180, "seconds"),
#'   target_anser_time = lubridate::duration(20, "seconds"),
#'   n = 14
#' )
erlang_c <- function(call_count, call_period, avg_handle_time, target_anser_time, n) {
  a <- call_count / as.numeric(call_period, "hours") * as.numeric(avg_handle_time, "minutes") / 60
  a_big <- gmp::as.bigz(a)
  n_big <- gmp::as.bigz(n)
  x <- (a_big^n_big / gmp::factorialZ(n)) * (n / (n - a))
  y <- Reduce("+", sapply(1:n - 1, function(x) a_big^x / gmp::factorialZ(x)))
  wait_probability <- as.numeric(x / (x + y))
  service_level <- 1 - (wait_probability * exp(-((n - a) * (target_anser_time / avg_handle_time))))
  average_speed_of_answer <- wait_probability * avg_handle_time / (n - a)
  immediate_answer_probability <- 1 - wait_probability
  occupancy <- a / n
  return(list(
    traffic_intensity = a,
    wait_probability = wait_probability,
    service_level = service_level,
    average_speed_of_answer = average_speed_of_answer,
    immediate_answer_probability = immediate_answer_probability,
    occupancy = occupancy
  ))
}
