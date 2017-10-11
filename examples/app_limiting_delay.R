library(shiny)
library(ggplot2)
library(vertica.dplyr)
source("global.R", local = FALSE)

tbl(vertica, "mpk_pos") -> mpk_pos
mpk_pos %>% distinct(lineno) %>% arrange(lineno) %>% collect -> lines

server <- function(input, output, session) {
  output$plot <- renderPlot({
        mpk_pos %>%
          mutate(day=date_part("ISODOW", minsnapshottime),
                 hour=date_part("hour", minsnapshottime),
                 delay=delay/1000/60) %>%
          filter(lineno==input$lineno, day==input$day) %>%
          group_by(day,lineno,hour) %>%
          summarise(avg=mean(delay)) %>% collect -> hist_data
    ggplot(hist_data, aes(x=hour,y=avg)) + geom_bar(stat="identity")
  })
}

ui <- navbarPage(
  "Vertica and Shiny demo",
  tabPanel("Plot",
           sidebarLayout(
             sidebarPanel(
               selectInput("lineno", label = "Linia:", choices=lines),
               selectInput("day", label = "Dzień:", choices=seq(1,7))
             ),
             mainPanel(plotOutput("plot"))
           ) 
  )
)


shinyApp(ui,server)
