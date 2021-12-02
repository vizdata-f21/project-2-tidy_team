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

air_pollution_regions <- read_rds(
  here("data", "air_pollution_regions.rds"))

substance_use_regions <- read_rds(
  here("data", "substance_use_regions.rds"))

sanitation_regions <- read_rds(
  here("data", "sanitation_regions.rds"))


# Define choices & random selection for regions lineplots -----------------------

# air pollution
regions_choices_air_pollution <- air_pollution_regions %>%
  distinct(entity) %>%
  arrange(entity) %>%
  pull(entity)

# substance
regions_choices_substance <- substance_use_regions %>%
  distinct(entity) %>%
  arrange(entity) %>%
  pull(entity)

# sanitation
regions_choices_sanitation <- sanitation_regions %>%
  distinct(entity) %>%
  arrange(entity) %>%
  pull(entity)

# Make Okabe-Ito Palette for Line Plot

cbPalette <- c("#0072B2", "#D55E00", "#CC79A7")

# Define UI --------------------------------------------------------------------

ui <- fluidPage(
  # set theme for shiny app
  theme = shinytheme("cosmo"),
  # make title for shiny app
  titlePanel(strong("Global Deaths By Risk Factors")),
  # air pollution tab
  tabsetPanel(
    tabPanel("Air Pollution",
             sidebarLayout(
               sidebarPanel(
                 selectInput(
                   inputId = "air_pollution_type",
                   label = "Select Type of Air Pollution for Map",
                   choices = c(
                     "Household Pollution Death Rate" =
                       "death_rate_household_pollution",
                     "Ambient Matter Pollution Death Rate" =
                       "death_rate_ambient_matter_pollution",
                     "Ozone Pollution Death Rate" =
                       "death_rate_ozone_pollution",
                     "Air Pollution Death Rate (Total)" = "death_rate_air_pollution"
                   )
                 ),
                 selectInput(
                   inputId = "air_pollution_line",
                   label = "Select Type of Air Pollution for Line Plot",
                   choices = c(
                     "Air Pollution" = "air_pollution",
                     "Outdoor Air Pollution" = "outdoor_air_pollution")
                 ),
                 checkboxGroupInput(inputId = "entity_air",
                                    label = "Select Up to 3 Regions for Line Plot",
                                    choices = regions_choices_substance
                 ),
               ),
               mainPanel(
                 fluidPage(
                 verticalLayout(
                 h3(strong("Death Rate of Selected Air Pollution Type by Country", align = "left")),
                 h4("As measured by the number of deaths per 100,000 people (Age-standardized)", align = "left"),
                 plotlyOutput(outputId = "plot_air"),
                 br(), br(), br(), br(), br(), br(), br(), br(),
                 br(), br(), br(), br(),
                 h3(strong("Number of Deaths from Selected Air Pollution Type by Region", align = "left")),
                 h4("As measured by the raw number of deaths", align = "left"),
                 plotOutput(outputId = "plot_air_pollution_line"))
               )
             )
             )
    ),
    # substance tab
    tabPanel("Substance Use",
             sidebarLayout(
               sidebarPanel(
                 selectInput(
                   inputId = "risk_factor_substance_map",
                   label = "Select Type of Substance for Map",
                   choices = c(
                     "Secondhand Smoking" = "secondhand_smoke_rate",
                     "Alcohol Use" = "alcohol_use_rate",
                     "Drug Use" = "drug_use_rate",
                     "Smoking" = "smoking_rate"
                   )
                 ),
                 selectInput(
                   inputId = "risk_factor_substance_line",
                   label = "Select Type of Substance for Line Plot",
                   choices = c(
                     "Secondhand Smoking" = "secondhand_smoke",
                     "Alcohol Use" = "alcohol_use",
                     "Drug Use" = "drug_use",
                     "Smoking" = "smoking"
                   )
                 ),
                 checkboxGroupInput(inputId = "entity_sub",
                                    label = "Select Up to 3 Regions for Line Plot",
                                    choices = regions_choices_substance
               )),
               mainPanel(fluidPage(
                 verticalLayout(
                 h3(strong("Death Rate of Selected Substance Type by Country", align = "left")),
                 h4("As measured by the number of deaths per 100,000 people", align = "left"),
                 plotlyOutput(outputId = "plot_substance"),
                 br(), br(), br(), br(), br(), br(), br(), br(),
                 br(), br(), br(), br(),
                 h3(strong("Number of Deaths from Selected Substance Type by Region", align = "left")),
                 h4("As measured by the raw number of deaths", align = "left"),
                 plotOutput(outputId = "plot_substance_line"))
               ))
             )
    ),

     # sanitation tab
    tabPanel("Sanitation",
             sidebarLayout(
               sidebarPanel(
                 selectInput(
                   inputId = "risk_factor_sanitation_map",
                   label = "Select Type of Sanitation Issue for Map",
                   choices = c(
                     "Unsafe Water Source" = "unsafe_water_source_rate",
                     "Unsafe Sanitation" = "unsafe_sanitation_rate",
                     "No Hand Wash" =
                       "no_access_to_handwashing_facility_rate"
                   )
                 ),
                 selectInput(
                   inputId = "risk_factor_sanitation_line",
                   label = "Select Type of Sanitation Issue for Line Plot",
                   choices = c(
                     "Unsafe Water Source" = "unsafe_water_source",
                     "Unsafe Sanitation" = "unsafe_sanitation",
                     "No Hand Wash" =
                       "no_access_to_handwashing_facility"
                   )
                 ),
                 checkboxGroupInput(inputId = "entity_san",
                                    label = "Select Up to 3 Regions for Line Plot",
                                    choices = regions_choices_sanitation
                 )
               ),
               mainPanel(fluidPage(
                 verticalLayout(
                 h3(strong("Death Rate of Selected Sanitation Issue by Country", align = "left")),
                 h4("As measured by the number of deaths per 100,000 people", align = "left"),
                 plotlyOutput(outputId = "plot_sanitation"),
                 br(), br(), br(), br(), br(), br(), br(), br(),
                 br(), br(), br(), br(),
                 h3(strong("Number of Deaths from Selected Sanitation Issue by Region", align = "left")),
                 h4("As measured by the raw number of deaths", align = "left"),
                 plotOutput(outputId = "plot_sanitation_line")))
               )
             )
    ),
      tabPanel("Trends and Analysis",
               mainPanel(p("This is where our trends + analysis will go.")
  )
)
)
)


# Define Server ----------------------------------------------------------------
server <- function(input, output) {

  # air pollution map
  output$plot_air <- renderPlotly({
    air_plotly <- (total_joined %>%
                     ggplot(aes(long, lat)) +
                     geom_polygon(
                       aes_string(
                         group = "group",
                         fill = input$air_pollution_type,
                         label = "region",
                         frame = "year"),
                       color = "white",
                       size = 0.1
                     ) +
                     coord_map(
                       projection = "mercator",
                       xlim = c(-180, 180),
                       clip = "off"
                       ) +
                     scale_fill_viridis_c(
                       limits = c(0, 350),
                       begin = 0.3,
                       option = "turbo",
                       # turbo pallet coordinates with AQI colors:
                       # (https://webcam.srs.fs.fed.us/test/AQI.shtml)
                       name = "Death Rate",
                       labels = label_number(big.mark = ","),
                       na.value = "lightgray"
                     ) +
                     theme_void() +
                     theme(
                       text = element_text(color = "black"),
                       legend.direction = "vertical",
                       legend.position = "left",
                       legend.key.height = unit(2, "cm"),
                       plot.background = element_rect(fill = "white", color = "white")
                     ))

    ggplotly(p = air_plotly, width = 900, height = 600) %>%
      animation_opts(frame = 27) %>%
      layout(yaxis = list(showline= F),
             xaxis = list(showline= F))    # removing axis lines: https://plotly.com/r/axes/

  })


  # interactivity for air pollution line plot

  # this prints a sentence
  output$selected_regions_air <- reactive({
    paste("You've selected", length(input$entity_air), "regions.")
  })

  air_pollution_regions_filtered <- reactive({
    air_pollution_regions %>%
      filter(entity %in% input$entity_air)
  })

  # air pollution line plot

  output$plot_air_pollution_line <- renderPlot({
    validate(
      need(length(input$entity_air) <= 3, "Please select a maximum of 3 regions.")
    )
    ggplot(data = air_pollution_regions_filtered(),
           aes_string(x = "year",
                      y = input$air_pollution_line,
                      group = "entity",
                      color = "entity")) +
      geom_line(size = 1) +
      theme_minimal(base_size = 16) +
      theme(legend.position = "bottom",
            aspect.ratio = 0.4,
            axis.ticks.x = element_blank(),
            axis.ticks.y = element_blank(),
            panel.grid.minor.x = element_blank(),
            panel.grid.minor.y = element_blank(),
            text = element_text(family = "mono")) +
      scale_y_continuous(labels = comma) +
      scale_x_continuous(breaks = seq(from = 1990, to = 2017, by = 3),
                         limits = c(1990, 2017),
                         expand = c(0, 0)) +
      scale_color_manual(values = cbPalette) +
      labs(
        x = "Year",
        y = "Number of Deaths",
        color = "Regions",
        title = paste("Selected:", input$air_pollution_line))
  })


  # substance
  output$plot_substance <- renderPlotly({
    substance_plotly <- (total_joined %>%
                           ggplot(aes(long, lat)) +
                           geom_polygon(
                             aes_string(group = "group",
                                        fill = input$risk_factor_substance_map,
                                        label = "region",
                                        frame = "year"),
                             color = "white",
                             size = 0.1
                           ) +
                           coord_map(
                             projection = "mercator",
                             xlim = c(-180, 180),
                             clip = "off"
                           ) +
                           scale_fill_viridis_c(
                             trans = "log10",
                             option = "inferno",
                             direction = -1,
                             begin = 0.2,
                             end = 0.9,
                             name = "Log of Death Rate",
                             labels = label_number(big.mark = ","),
                             na.value = "lightgray"
                           ) +
                           theme_void() +
                           theme(
                             text = element_text(color = "black"),
                             legend.direction = "vertical",
                             legend.position = "left",
                             legend.key.height = unit(2, "cm"),
                             plot.background = element_rect(fill = "white", color = "white"),
                             plot.title = element_blank(),
                             plot.subtitle = element_blank()))

    ggplotly(p = substance_plotly, width = 900, height = 600) %>%
      animation_opts(frame = 27) %>%
      layout(yaxis = list(showline= F),
             xaxis = list(showline= F)) # removing axis lines: https://plotly.com/r/axes/

  })

  # interactivity for substance line plot

  output$selected_regions_sub <- reactive({
    paste("You've selected", length(input$entity_sub), "regions.")
  })

  substance_use_regions_filtered <- reactive({
    substance_use_regions %>%
      filter(entity %in% input$entity_sub)
  })

  # substance line plot

  output$plot_substance_line <- renderPlot({
    validate(
      need(length(input$entity_sub) <= 3, "Please select a maximum of 3 regions.")
    )
    ggplot(data = substance_use_regions_filtered(),
           aes_string(x = "year",
                      y = input$risk_factor_substance_line,
                      group = "entity",
                      color = "entity")) +
      geom_line(size = 1) +
      theme_minimal(base_size = 16) +
      theme(legend.position = "bottom",
            aspect.ratio = 0.4,
            axis.ticks.x = element_blank(),
            axis.ticks.y = element_blank(),
            panel.grid.minor.x = element_blank(),
            panel.grid.minor.y = element_blank(),
            text = element_text(family = "mono")) +
      scale_y_continuous(labels = comma) +
      scale_x_continuous(breaks = seq(from = 1990, to = 2017, by = 3),
                         limits = c(1990, 2017),
                         expand = c(0, 0)) +
      scale_color_manual(values = cbPalette) +
      labs(
        x = "Year",
        y = "Number of Deaths",
        color = "Regions",
        title = paste("Selected:", input$risk_factor_substance_line))
  })


  # sanitation map
  output$plot_sanitation <- renderPlotly({
    sanitation_plotly <- (total_joined %>%
                            ggplot(aes(long, lat)) +
                            geom_polygon(
                              aes_string(group = "group",
                                         fill = input$risk_factor_sanitation_map,
                                         label = "region",
                                         frame = "year"),
                              color = "white",
                              size = 0.1
                            ) +
                            coord_map(
                              projection = "mercator",
                              xlim = c(-180, 180),
                              clip = "off"
                            ) +
                            scale_fill_viridis_c(
                              trans = "log10",
                              option = "magma",
                              direction = -1,
                              end = 0.9,
                              name = "Log of Death Rate",
                              labels = label_number(big.mark = ","),
                              na.value = "lightgray"
                            ) +
                            theme_void() +
                            theme(
                              text = element_text(color = "black"),
                              legend.direction = "vertical",
                              legend.position = "left",
                              legend.key.height = unit(2, "cm"),
                              plot.background = element_rect(fill = "white", color = "white"),
                              plot.title = element_blank(),
                              plot.subtitle = element_blank()
                            ))

    ggplotly(p = sanitation_plotly, width = 900, height = 600) %>%
      animation_opts(frame = 27) %>%
      layout(yaxis = list(showline= F),
             xaxis = list(showline= F)) # removing axis lines: https://plotly.com/r/axes/

  })

  # sanitation line plot

  # interactivity for sanitation line plot
  output$selected_regions_san <- reactive({
    paste("You've selected", length(input$entity_san), "regions.")
  })

  sanitation_regions_filtered <- ({reactive({
    sanitation_regions %>%
      filter(entity %in% input$entity_san)
  })
  })

  output$plot_sanitation_line <- renderPlot({
    validate(
      need(length(input$entity_san) <= 3, "Please select a maxiumum of 3 regions")
    )
    ggplot(data = sanitation_regions_filtered()) +
      geom_line(aes_string(group = "entity",
                           color = "entity",
                           x = "year",
                           y = input$risk_factor_sanitation_line), size = 1) +
      theme_minimal(base_size = 16) +
      theme(legend.position = "bottom",
            aspect.ratio = 0.4,
            axis.ticks.x = element_blank(),
            axis.ticks.y = element_blank(),
            panel.grid.minor.x = element_blank(),
            panel.grid.minor.y = element_blank(),
            text = element_text(family = "mono")) +
      scale_y_continuous(labels = comma) +
      scale_x_continuous(breaks = seq(from = 1990, to = 2017, by = 3),
                         limits = c(1990, 2017)) +
      scale_color_manual(values = cbPalette) +
      labs(
        x = "Year",
        y = "Number of Deaths",
        color = "Regions",
        title = paste("Selected:", input$risk_factor_sanitation_line))
  })
}

# summary info: caption = "Source: Our World in Data"

# Run the application
shinyApp(ui = ui, server = server)
