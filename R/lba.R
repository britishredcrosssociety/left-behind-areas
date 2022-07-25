library(shiny)
library(leaflet)

lba <- function() {
  ui <- bootstrapPage(

    # - Add tags to render map fullscreen -
    tags$head(
      tags$link(href = "https://fonts.googleapis.com/css?family=Oswald", rel = "stylesheet"),
      tags$style(type = "text/css", "html, body {width:100%;height:100%; font-family: Oswald, sans-serif;}"),
      tags$style("h1 {color:#262626;}"),
      tags$style("h5 {color:#5C747A;}")
    ),

    # - Call map module -
    mapUI("map"),

    # - Title & subheading -
    absolutePanel(
      top = 10, left = 20, style = "z-index:500; text-align: lwft;",
      tags$h1("Explore Left Behind Areas"),
      tags$h5("Left-behind areas are shaded red. Local authorities are dashed lines.")
    )
  )
  server <- function(input, output, session) {
    mapServer("map")
  }
  shinyApp(ui, server)
}