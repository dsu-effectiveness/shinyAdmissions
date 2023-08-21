#' enrollment UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#' @param   title   Title for the page / module.
#' @param   subtitle   Title for the page / module.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_enrollment_ui <- function(id, title, subtitle) {
  ns <- NS(id)

  tagList(
    htmltools::h2(title),
    htmltools::p(subtitle),
    # Value boxes
    mod_enrollment_summary_boxes_ui(ns("summary")),
    # Time-line chart
    mod_over_time_line_chart_ui(ns("line_chart"))
  )
}

#' enrollment Server Functions
#'
#' @param   id   A unique identifier, linking the UI to the Server.
#' @param   df   A data frame.
#' @noRd

mod_enrollment_server <- function(id, df) {
  shiny::moduleServer(id, function(input, output, session) {
    ns <- session$ns

    mod_enrollment_summary_boxes_server("summary")

    mod_over_time_line_chart_server(
      "line_chart",
      df = df,
      time_col = c("Days Until Class Start" = "days_to_class_start"),
      metric_col = c("Headcount" = "student_id"),
      metric_summarization_function = dplyr::n_distinct,
      grouping_cols = c(
        "Term" = "term_desc",
        "Season" = "season",
        "Academic Year" = "academic_year",
        "College" = "college",
        "Department" = "department",
        "Program" = "program",
        "Gender" = "gender",
        "Race/Ethnicity" = "race_ethnicity"
      ),
      filter_cols = c(
        "Term" = "term_desc",
        "Season" = "season",
        "Academic Year" = "academic_year",
        "College" = "college",
        "Department" = "department",
        "Program" = "program",
        "Gender" = "gender",
        "Race/Ethnicity" = "race_ethnicity"
      )
    )
  })
}

## To be copied in the UI
# mod_enrollment_ui("enrollment_1")

## To be copied in the server
# mod_enrollment_server("enrollment_1")
