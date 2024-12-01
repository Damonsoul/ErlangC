#' Calculate Required Number of Agents
#' This function calculates the required number of agents to achieve a specified service level and occupancy.
#' @param call_count Numeric. The total number of incoming calls.
#' @param call_period Duration. The time period over which calls are counted.
#' @param avg_handle_time Duration. The average time taken to handle a call.
#' @param target_anser_time Duration. The targeted time to answer a call.
#' @param require_service_level Numeric. The required service level.
#' @param max_occupancy Numeric. The maximum allowed occupancy level .
#' @param shrinkage Numeric. The shrinkage factor to account for non-productive time .
#' @param max_agents Integer. The maximum number of agents allowed.
#'
#' @return A list containing the calculated metrics and the number of agents required.
#' @export
#'
#' @examples
#' calculate_agents(
#'   call_count = 100,
#'   call_period = lubridate::duration(30, "minutes"),
#'   avg_handle_time = lubridate::duration(180, "seconds"),
#'   target_anser_time = lubridate::duration(20, "seconds"),
#'   require_service_level = 0.8,
#'   max_occupancy = 0.85,
#'   shrinkage = 0.3,
#'   max_agents = 200
#' )
calculate_agents <- function(call_count, call_period, avg_handle_time, target_anser_time, require_service_level, max_occupancy, shrinkage, max_agents = NULL) {
  a <- call_count / as.numeric(call_period, "hours") * as.numeric(avg_handle_time, "minutes") / 60
  n <- a + 1
  erlang_c_0 <- erlang_c(call_count, call_period, avg_handle_time, target_anser_time, n)
  erlang_c_0$agents <- n

  l <- list()
  l[[1]] <- erlang_c_0

  while (erlang_c_0$service_level < require_service_level | erlang_c_0$occupancy > max_occupancy) {
    n <- n + 1
    erlang_c_0 <- erlang_c(call_count, call_period, avg_handle_time, target_anser_time, n)
    erlang_c_0$agents <- n
    l[[n]] <- erlang_c_0
    if (!is.null(max_agents) && n > max_agents) {
      stop("Maximum number of agents reached")
    }
  }
  erlang_c_0$process <- do.call(rbind, l)

  if (!is.null(shrinkage)) {
    erlang_c_0$agents_shrinked <- erlang_c_0$agents / (1 - shrinkage)
  }

  return(erlang_c_0)
}
