library(shiny)
library(leaflet)
library(ggplot2)
library(memoise)
library(vertica.dplyr)
source("global.R", local = FALSE)


tbl(vertica, "mpk_pos") -> mpk_pos
mpk_pos %>% distinct(lineno) %>% arrange(lineno) %>% collect -> lines

tbl(vertica,"stops") %>% collect -> stops

showStopDetails <- function(stopno_arg, lat,long){
  gsub("\"","",stopno_arg) -> stopno_arg
  print(stopno_arg)
  mpk_pos %>% filter(stopno==stopno_arg) %>%group_by(lineno) %>% tally %>% 
    filter(n>1000) %>% arrange(lineno) %>% collect -> lines
  print(lines)
  lines_str <- paste(lines$lineno, collapse = ",")
  tagList(
    tags$h3(stopno_arg),
    tags$br(),
    paste0("Linie na przystanku:\n", strwrap(lines_str,width=10))
  ) %>% as.character ->content
  leafletProxy("map") %>% addPopups(long,lat,content, layerId = stopno_arg)
}

server <- function(input, output, session) {
  output$plot <- renderPlot({
        mpk_pos %>%
          mutate(day=date_part("ISODOW", minsnapshottime),
                 hour=date_part("hour", minsnapshottime),
                 delay=delay/1000/60) %>%
          filter(abs(delay) < 180, abs(delay) < input$delay) %>%
          filter(lineno==input$lineno, day==input$day) %>%
          group_by(day,lineno,hour) %>%
          summarise(avg=mean(delay)) %>% collect -> hist_data
    ggplot(hist_data, aes(x=hour,y=avg)) + geom_bar(stat="identity")
  })
  output$map <- renderLeaflet({
    leaflet(data=stops) %>% addTiles() %>%
      fitBounds(min(stops$long), min(stops$lat), max(stops$long), max(stops$lat)) %>% 
      addMarkers(layerId=~stopno, clusterOptions = markerClusterOptions())
  })
  observe({
    leafletProxy("map") %>% clearPopups()
    event <- input$map_marker_click
    if (is.null(event))
      return()
    
    isolate({
      showStopDetails(event$id, event$lat, event$lng)
    })
  })
}

ui <- navbarPage(
  "Vertica and Shiny demo",
  tabPanel("Histograms",
           sidebarLayout(
             sidebarPanel(
               selectInput("lineno", label = "Linia:", choices=lines),
               selectInput("day", label = "Dzień:", choices=seq(1,7)),
               sliderInput("delay",label = "Maksymalne opóźnienie:", min = 0, max=180, value=180)
             ),
             mainPanel(plotOutput("plot"))
           )
  ),
  tabPanel("Map",
           leafletOutput("map",height = 800, width = "100%")
  )
)


shinyApp(ui,server)

