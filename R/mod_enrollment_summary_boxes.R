#' enrollment_summary_boxes UI Function
#'
#' @description A shiny Module.
#'
#' @param   id   ID to link the UI and server for this module.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList

mod_enrollment_summary_boxes_ui <- function(id) {
  ns <- NS(id)
  shiny::fluidRow(
    # Current headcount
    shiny::column(
      bslib::value_box(
        title = "Headcount",
        value = shiny::textOutput(ns("headcount"), container = shiny::h2)
      ),
      width = 6
    ),
    # Percent difference to last year
    shiny::column(
      bslib::value_box(
        title = "Percent difference in headcount",
        value = shiny::textOutput(ns("percent_diff"), container = shiny::h2)
      ),
      width = 6
    )
  )
}

#' enrollment_summary_boxes Server Functions
#'
#' @param   id   ID to link the server and UI components of this module
#' @param   df   The daily-enrollment data-frame.
#'
#' @importFrom   rlang   .data .env
#' @noRd

mod_enrollment_summary_boxes_server <- function(id, df) {
  shiny::moduleServer(id, function(input, output, session) {
    ns <- session$ns

    headcount <- shiny::reactive({
      max_academic_year <- max(unique(df[["academic_year"]]))
      message(max_academic_year)

      headcount_df <- df %>%
        dplyr::filter(.data[["academic_year"]] == .env[["max_academic_year"]]) %>%
        dplyr::summarise(headcount = dplyr::n_distinct(.data[["student_id"]]))

      headcount_df[["headcount"]]
    })

    output$headcount <- shiny::renderText(headcount())
    output$percent_diff <- shiny::renderText(+12.5)
  })
}

#' An example shiny app to demonstrate the enrollment-summary-boxes module
#'
#' @param   df   A daily-enrollment data-frame. Must have `student_id` and `academic_year` columns.
#' @noRd

mod_enrollment_summary_boxes_app <- function(df) {
  id <- "abc"

  ui <- shiny::tagList(
    shiny::tags$head(
      golem_add_external_resources()
    ),
    shiny::navbarPage(
      theme = litera_theme(),
      mod_enrollment_summary_boxes_ui(id)
    )
  )
  server <- function(input, output, session) {
    mod_enrollment_summary_boxes_server(id, df)
  }
  shinyApp(ui, server)
}

## To be copied in the UI
# mod_enrollment_summary_boxes_ui("enrollment_summary_boxes_1")

## To be copied in the server
# mod_enrollment_summary_boxes_server("enrollment_summary_boxes_1")
