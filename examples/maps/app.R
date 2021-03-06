library(shiny)
library(leaflet)
library(ggplot2)
library(vertica.dplyr)
source("global.R", local = FALSE)


tbl(vertica, "mpk_pos") -> mpk_pos
mpk_pos %>% distinct(lineno) %>% arrange(lineno) %>% collect -> lines
getStops <- function(){
tbl(vertica, "stops") %>% collect 
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
    getStops() %>% leaflet() %>% addTiles() %>% setView(17,51,10) %>%
      addMarkers(clusterOptions=markerClusterOptions())
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
           leafletOutput("map",height = 800)
  )
)


shinyApp(ui,server)

