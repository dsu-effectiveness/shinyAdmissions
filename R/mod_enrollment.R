#' enrollment UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_enrollment_ui <- function(id) {
  ns <- NS(id)
  tagList(
    mod_over_time_line_chart_ui(ns("line_chart"))
  )
}

#' enrollment Server Functions
#'
#' @noRd
mod_enrollment_server <- function(id, df) {
  shiny::moduleServer(id, function(input, output, session) {
    ns <- session$ns

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
      ),
      module_title = "Daily Enrollment"
    )
  })
}

## To be copied in the UI
# mod_enrollment_ui("enrollment_1")

## To be copied in the server
# mod_enrollment_server("enrollment_1")
