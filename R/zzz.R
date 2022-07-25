.onLoad <- function(libname, pkgname) {
  shiny::addResourcePath(
    "www",
    system.file(
      "www",
      package = "leftBehindAreas"
    )
  )
}

.onUnload <- function(libname, pkgname) {
   shiny::removeResourcePath("www")
}