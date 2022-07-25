mapUI <- function(id) {
  leafletOutput(
    NS(id, "map"),
    width = "100%",
    height = "100%"
  )
}

mapServer <- function(id) {
  moduleServer(id, function(input, output, session) {
    output$map <-
      renderLeaflet({
        leaflet(options = leafletOptions(zoomControl = FALSE)) |>
          setView(lat = 52.75, lng = -2.0, zoom = 6) |>
          addProviderTiles(
            providers$CartoDB.Positron,
            options = providerTileOptions(minZoom = 6)
          ) |>
          setMaxBounds(-12, 49, 3.0, 61) |>
          htmlwidgets::onRender(
            "function(el, x) {
            L.control.zoom({position:'topright'}).addTo(this);
             }"
          ) |>
          addPolygons(
            data = boundaries_lba,
            label = ~lba_name,
            weight = 0.7,
            opacity = 0.5,
            color = "#D0021B",
            dashArray = "0.1",
            fillOpacity = 0.5,
            highlight = highlightOptions(
              weight = 5,
              color = "#D0021B",
              dashArray = "",
              fillOpacity = 0.5,
              bringToFront = TRUE
            )
          ) |>
          addPolygons(
            data = boundaries_ltla21,
            fill = FALSE,
            weight = 0.3,
            color = "#5C747A",
            dashArray = 2
          )
      })
  })
}

mapTest <- function() {
  ui <- bootstrapPage(
    tags$head(
      tags$style(type = "text/css", "html, body {width:100%;height:100%;}")
    ),
    mapUI("test")
  )
  server <- function(input, output, session) {
    mapServer("test")
  }
  shinyApp(ui, server)
}