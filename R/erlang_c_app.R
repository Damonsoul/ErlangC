#' Shiny App for Erlang C Calculator
#'
#' This function creates a Shiny app for calculating Erlang C metrics.
#'
#' @param language Character. The language to use for translations (default: "en").
#'
#' @return A Shiny app object.
#' @export
erlang_c_app <- function(language = "en") {
  # Define translations
  translate <- function(key) {
    ErlangC::translations[ErlangC::translations$key == key, language]
  }

  # UI
  ui <- bslib::page_sidebar(
    title = translate("calculator"),
    sidebar = bslib::sidebar(
      shiny::numericInput("call_count", translate("call_count"), value = 100, min = 1),
      shiny::numericInput("period_minutes", translate("call_period"), value = 30, min = 1),
      shiny::numericInput("handle_time_seconds", translate("handle_time"), value = 180, min = 1),
      shiny::numericInput("answer_time_seconds", translate("answer_time"), value = 20, min = 1),
      shiny::numericInput("service_level", translate("service_level"), value = 0.8, min = 0, max = 1, step = 0.05),
      shiny::numericInput("occupancy", translate("occupancy"), value = 0.85, min = 0, max = 1, step = 0.05),
      shiny::numericInput("shrinkage", translate("shrinkage"), value = 0.3, min = 0, max = 1, step = 0.05),
      shiny::numericInput("max_agents", translate("max_agents"), value = 200, min = 1),
      shiny::actionButton("calculate", translate("calculate"), class = "btn-primary")
    ),
    bslib::layout_columns(
      bslib::value_box(
        title = translate("traffic_intensity"),
        value = shiny::textOutput("traffic_intensity"),
        showcase = bsicons::bs_icon("arrow-down-up")
      ),
      bslib::value_box(
        title = translate("required_agents"),
        value = shiny::textOutput("agents"),
        showcase = bsicons::bs_icon("people-fill"),
      ),
      bslib::value_box(
        title = translate("required_agents_shrinkage"),
        value = shiny::textOutput("agents_shrinkage"),
        showcase = bsicons::bs_icon("people")
      ),
      bslib::value_box(
        title = translate("service_level_achieved"),
        value = shiny::textOutput("service_level_achieved"),
        showcase = bsicons::bs_icon("graph-up")
      ),
      bslib::value_box(
        title = translate("occupancy_achieved"),
        value = shiny::textOutput("occupancy_achieved"),
        showcase = bsicons::bs_icon("percent")
      )
    ),
    bslib::card(
      bslib::card_header(translate("calculation_process")),
      DT::DTOutput("process_table"),
      full_screen = TRUE
    )
  )

  # Server
  server <- function(input, output, session) {
    results <- shiny::eventReactive(input$calculate, {
      # Convert inputs to appropriate formats
      call_period <- lubridate::duration(input$period_minutes, "minutes")
      avg_handle_time <- lubridate::duration(input$handle_time_seconds, "seconds")
      target_answer_time <- lubridate::duration(input$answer_time_seconds, "seconds")

      # Calculate results
      ErlangC::calculate_agents(
        call_count = input$call_count,
        call_period = call_period,
        avg_handle_time = avg_handle_time,
        target_anser_time = target_answer_time,
        require_service_level = input$service_level,
        max_occupancy = input$occupancy,
        shrinkage = input$shrinkage,
        max_agents = input$max_agents
      )
    })

    output$agents <- shiny::renderText({
      round(results()$agents, 0)
    })

    output$agents_shrinkage <- shiny::renderText({
      ceiling(results()$agents_shrinked)
    })

    output$service_level_achieved <- shiny::renderText({
      sprintf("%.1f%%", results()$service_level * 100)
    })

    output$occupancy_achieved <- shiny::renderText({
      sprintf("%.1f%%", results()$occupancy * 100)
    })

    output$traffic_intensity <- shiny::renderText({
      ceiling(results()$traffic_intensity)
    })

    output$process_table <- DT::renderDT({
      process_df <- data.frame(results()$process)

      process_df <- process_df |> tidyr::unnest(cols = colnames(process_df))

      process_df$traffic_intensity <- NULL
      colnames(process_df) <- c(
        translate("wait_probability"), translate("service_level"),
        translate("average_speed_of_answer"), translate("immediate_answer_probability"), translate("occupancy"), translate("required_agents")
      )

      DT::datatable(
        process_df,
        options = list(pageLength = 5, dom = "tp"),
        rownames = FALSE
      ) |>
        DT::formatPercentage(c(translate("service_level"), translate("occupancy"), translate("wait_probability"), translate("immediate_answer_probability")), 2) |>
        DT::formatRound(
          translate("average_speed_of_answer"), 2
        ) |>
        DT::formatStyle(
          translate("service_level"),
          backgroundColor = DT::styleInterval(
            shiny::isolate(input$service_level),
            c("orange", "green")
          )
        ) |>
        DT::formatStyle(
          translate("occupancy"),
          backgroundColor = DT::styleInterval(
            shiny::isolate(input$occupancy),
            c("green", "orange")
          )
        )
    })
  }

  shiny::shinyApp(ui, server)
}
