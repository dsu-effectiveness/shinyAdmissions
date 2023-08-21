#' enrollment_summary_boxes UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
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
#' @noRd
mod_enrollment_summary_boxes_server <- function(id) {
  shiny::moduleServer(id, function(input, output, session) {
    ns <- session$ns

    output$headcount <- shiny::renderText(12345)
    output$percent_diff <- shiny::renderText(+12.5)
  })
}

#' An example shiny app to demonstrate the enrollment-summary-boxes module
#'
#' @noRd

mod_enrollment_summary_boxes_app <- function(id = "abc") {
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
    mod_enrollment_summary_boxes_server(id)
  }
  shinyApp(ui, server)
}

## To be copied in the UI
# mod_enrollment_summary_boxes_ui("enrollment_summary_boxes_1")

## To be copied in the server
# mod_enrollment_summary_boxes_server("enrollment_summary_boxes_1")
