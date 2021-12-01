# Load packages ----------------------------------------------------------------

library(shiny)
library(shinythemes)
library(shinyBS)
library(ggiraph)
library(tidyverse)
library(here)
library(maps)
library(scales)
library(plotly)
library(readr)
library(mapproj)

# Load pre-cleaned, compressed data --------------------------------------------------------

total_joined <- read_rds(here("data", "compressed_final_data.rds"))

substance_use_regions <- read_rds(
  here("data", "substance_use_regions.rds"))

sanitation_regions <- read_rds(
  here("data", "sanitation_regions.rds"))


# Define choices & random selection for regions lineplots -----------------------

# substance
regions_choices_substance <- substance_use_regions %>%
  distinct(entity) %>%
  arrange(entity) %>%
  pull(entity)

selected_regions_choices_substance <- sample(regions_choices_substance, 3)

# sanitation
regions_choices_sanitation <- sanitation_regions %>%
  distinct(entity) %>%
  arrange(entity) %>%
  pull(entity)

selected_regions_choices_sanitation <- sample(regions_choices_sanitation, 3)

# Define UI --------------------------------------------------------------------

ui <- fluidPage(
  # set theme for shiny app
  theme = shinytheme("cosmo"),
  # make title for shiny app
  titlePanel("Deaths By Risk Factors"),

  # air pollution tab
  tabsetPanel(
    # substance tab
    tabPanel("Substance Use",
             sidebarLayout(
               sidebarPanel(
                 selectInput(
                   inputId = "risk_factor_substance",
                   label = "Type of Substance",
                   choices = c(
                     "Secondhand Smoking" = "secondhand_smoke_rate",
                     "Alcohol Use" = "alcohol_use_rate",
                     "Drug Use" = "drug_use_rate",
                     "Smoking" = "smoking_rate"
                   )
                 ),
                 checkboxGroupInput(inputId = "entity",
                                    label = "Select up to 8 regions:",
                                    choices = regions_choices_substance,
                                    selected =
                                      selected_regions_choices_substance
                 )
               ),
               mainPanel(
                 plotlyOutput(outputId = "plot_substance"),
                 plotOutput(outputId = "plot_substance_line")
               )
             )
    )
  )
)

# Define Server ----------------------------------------------------------------
server <- function(input, output) {

  # interactivity for substance line plot

  output$selected_regions_sub <- reactive({
    paste("You've selected", length(input$entity), "regions.")
  })

  substance_use_regions_filtered <- reactive({
    substance_use_regions %>%
      filter(entity %in% input$entity)
  })

  # substance line plot

  output$plot_substance_line <- renderPlot({
    #validate(
    #need(length(input$entity) <= 8, "Please select a maximum of 8 regions")
    #)
    ggplot(data = substance_use_regions_filtered(),
           aes_string(x = "year",
                      y = input$risk_factor_substance)) +
      geom_line(aes_string(group = input$entity, # used to be "entity"
                           color = input$entity), # used to be "entity"
                size = 1) +
      theme_gray(base_size = 16) +
      theme(legend.position = "bottom",
            panel.grid.minor.x = element_blank()) +
      scale_y_continuous(labels = comma) +
      scale_x_continuous(breaks = seq(from = 1990, to = 2017, by = 3),
                         limits = c(1990, 2017)) +
      scale_color_viridis_d(option = "inferno", begin = 0.1) +
      labs(
        x = "Year",
        y = "Number of Deaths",
        color = "Regions",
        title = paste("Number of Deaths by", input$risk_factor_substance))
  })


}

# Run the application
shinyApp(ui = ui, server = server)