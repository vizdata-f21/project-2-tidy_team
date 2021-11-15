#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

# library(shiny)
#
# # Define UI for application that draws a histogram
# ui <- fluidPage()
#
# # Define server logic required to draw a histogram
# server <- function(input, output) {}
#
# # Run the application
# shinyApp(ui = ui, server = server)

library(shiny)
library(rgdal)

ui<- fluidPage(
  titlePanel("Air pollution deaths"),
  # sliderInput(inputId = "date", "Date:",
  #             min = as.Date("1990"), max = as.Date("2017"),

  # plot leaflet object (map)
  leafletOutput(outputId = "distPlot", width = "700px", height = "300px"),

  sidebarLayout(
    sidebarPanel(
      selectInput("air_pollution_type", h4("Type of Air pollution"), choices
                  = list("Ambient Particular Matter","Household Solid Fuels",
                         "Ambient Ozone", "Total"),
                  selected = "Ambient Particular Matter"),
      selectInput("other_risk_factors", h4("Other Risk Factors"),
                  choices = list("Unsafe water Source", "Unsafe Sanitation",
                                 "No Access to hand wash",
                                 "Non exclusive breast feeding"),
                  selected = "Unsafe water Source")),

    # Main Panel: plot the selected values
    # mainPanel (
    #   plotOutput(outputId = "Plotcountry", width = "500px",
    #              height = "300px")
    )
  )
  #End: the second Block


shinyApp(ui = ui, server = server)



