#' sunburst_diagram UI Function
#'
#' To be copied in the UI
#' mod_sunburst_diagram_ui("sunburst_diagram_1")
#'
#' To be copied in the server
#' mod_sunburst_diagram_server("sunburst_diagram_1")
#'
#' @description A shiny Module.
#'
#' @param   id   Internal parameters for {shiny}.
#' @param   title,subtitle   Title and subtitle for the page/module.
#'
#' @export
#'
#' @importFrom shiny NS tagList

mod_sunburst_diagram_ui <- function(id, title, subtitle = NULL) {
  ns <- NS(id)

  tagList(
    shiny::h2(title),
    shiny::p(subtitle),
    shiny::fluidRow(
      shiny::column(
        width = 6,
        utVizSunburst::sunburstOutput(ns("sunburst"))
      ),
      shiny::column(
        width = 6,
        reactable::reactableOutput(ns("table"))
      )
    )
  )
}

#' sunburst_diagram Server Functions
#'
#' To be copied in the UI
#' mod_sunburst_diagram_ui("sunburst_diagram_1")
#'
#' To be copied in the server
#' mod_sunburst_diagram_server("sunburst_diagram_1")
#'
#' @param   id   Identifier to link server and UI for the module.
#' @param   df   A data-frame.
#' @param   step_cols   Which columns of the data-frame should define the rings in the sunburst
#'   diagram.
#'
#' @export

mod_sunburst_diagram_server <- function(id,
                                        df,
                                        step_cols = c(
                                          "entity_category_1", "entity_category_2",
                                          "entity_category_3", "entity_outcome"
                                        )) {
  shiny::moduleServer(id, function(input, output, session) {
    ns <- session$ns

    # Sunburst diagram requires all step columns to be of type character
    df[step_cols] <- lapply(df[step_cols], as.character)

    mouseover_handler <- utVizSunburst::get_shiny_input_handler(
      inputId = ns("sunburst_sector_data"),
      type = "path_data"
    )
    output$sunburst <- utVizSunburst::renderSunburst({
      utVizSunburst::sunburst(
        df,
        palette = colors_8(),
        steps = step_cols,
        mouseover_handler = mouseover_handler
      )
    })

    reactive_sector_data <- shiny::eventReactive(input$sunburst_sector_data, {
      input$sunburst_sector_data
    })

    output$table <- reactable::renderReactable({
      reactable::reactable(
        reactive_sector_data(),
        columns = list(color = reactable::colDef(style = function(value) {
          list(background = value, color = "transparent")
        }))
      )
    })
  })
}
