library(shiny)
library(leaflet)

lba <- function() {
  ui <- fluidPage(
    "Hello, world!"
  )
  server <- function(input, output, session) {
  }
  shinyApp(ui, server)
}