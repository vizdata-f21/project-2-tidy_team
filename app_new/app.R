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

# sanitation
regions_choices_sanitation <- sanitation_regions %>%
  distinct(entity) %>%
  arrange(entity) %>%
  pull(entity)

# Define UI --------------------------------------------------------------------

ui <- fluidPage(
  # set theme for shiny app
  theme = shinytheme("cosmo"),
  # make title for shiny app
  titlePanel("Deaths By Risk Factors"),
  # air pollution tab
  tabsetPanel(
    tabPanel("Air Pollution",
             sidebarLayout(
               sidebarPanel(
                 selectInput(
                   inputId = "air_pollution_type",
                   label = "Type of Air Pollution",
                   choices = c(
                     "Air Pollution Death Rate" = "death_rate_air_pollution",
                     "Household Pollution Death Rate" =
                       "death_rate_household_pollution",
                     "Ambient Matter Pollution Death Rate" =
                       "death_rate_ambient_matter_pollution",
                     "Ozone Pollution Death Rate" =
                       "death_rate_ozone_pollution"
                   )
                 )
               ),
               mainPanel(
                 plotlyOutput(outputId = "plot_air")
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
                 checkboxGroupInput(inputId = "entity",
                                    label = "Select Up to 3 Regions",
                                    choices = regions_choices_substance
               )),
               mainPanel(fluidRow(
                 plotlyOutput(outputId = "plot_substance"),
                 plotOutput(outputId = "plot_substance_line")
               ))
             )
    ),

     # sanitation tab
    tabPanel("Sanitation",
             sidebarLayout(
               sidebarPanel(
                 selectInput(
                   inputId = "risk_factor_sanitation_map",
                   label = "Type of Sanitation",
                   choices = c(
                     "Unsafe Water Source" = "unsafe_water_source_rate",
                     "Unsafe Sanitation" = "unsafe_sanitation_rate",
                     "No Hand Wash" =
                       "no_access_to_handwashing_facility_rate"
                   )
                 ),
                 selectInput(
                   inputId = "risk_factor_sanitation_line",
                   label = "Type of Sanitation",
                   choices = c(
                     "Unsafe Water Source" = "unsafe_water_source",
                     "Unsafe Sanitation" = "unsafe_sanitation",
                     "No Hand Wash" =
                       "no_access_to_handwashing_facility"
                   )
                 ),
                 checkboxGroupInput(inputId = "entity",
                                    label = "Select Up to 3 Regions",
                                    choices = regions_choices_sanitation
                 )
               ),
               mainPanel(
                 plotlyOutput(outputId = "plot_sanitation"),
                 plotOutput(outputId = "plot_sanitation_line")
               )
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
                       xlim = c(-180, 180)
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
                       plot.background = element_rect(fill = "white", color = "white"),
                       plot.title = element_blank(),
                       plot.subtitle = element_blank()
                     ))

    ggplotly(p = air_plotly) %>%
      animation_opts(frame = 27)

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
                             xlim = c(-180, 180)
                           ) +
                           scale_fill_viridis_c(
                             trans = "log10",
                             option = "inferno",
                             direction = -1,
                             begin = 0.2,
                             end = 0.9,
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
                             plot.background = element_rect(fill = "white", color = "white"),
                             plot.title = element_blank(),
                             plot.subtitle = element_blank()
                           ))

    ggplotly(p = substance_plotly) %>%
      animation_opts(frame = 27)

  })

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
    validate(
      need(length(input$entity) <= 3, "Please select a maximum of 3 regions.")
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
            panel.grid.minor.y = element_blank()) +
      scale_y_continuous(labels = comma) +
      scale_x_continuous(breaks = seq(from = 1990, to = 2017, by = 3),
                         limits = c(1990, 2017),
                         expand = c(0, 0)) +
      scale_color_viridis_d() +
      labs(
        x = "Year",
        y = "Number of Deaths",
        color = "Regions",
        title = paste("Number of Deaths by", input$risk_factor_substance_line))
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
                              xlim = c(-180, 180)
                            ) +
                            scale_fill_viridis_c(
                              trans = "log10",
                              option = "magma",
                              direction = -1,
                              end = 0.9,
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
                              plot.background = element_rect(fill = "white", color = "white"),
                              plot.title = element_blank(),
                              plot.subtitle = element_blank()
                            ))

    ggplotly(p = sanitation_plotly) %>%
      animation_opts(frame = 27)
  })

  # sanitation line plot

  # interactivity for sanitation line plot
  output$selected_regions_san <- reactive({
    paste("You've selected", length(input$entity), "regions.")
  })

  sanitation_regions_filtered <- ({reactive({
    sanitation_regions %>%
      filter(entity %in% input$entity)
  })
  })

  output$plot_sanitation_line <- renderPlot({
    validate(
      need(length(input$entity) <= 3, "Please select a maxiumum of 3 regions")
    )
    ggplot(data = sanitation_regions_filtered()) +
      geom_line(aes_string(group = "entity",
                           color = "entity",
                           x = "year",
                           y = input$risk_factor_sanitation_line), size = 1) +
      theme_gray(base_size = 16) +
      theme(legend.position = "bottom",
            panel.grid.minor.x = element_blank()) +
      scale_y_continuous(labels = comma) +
      scale_x_continuous(breaks = seq(from = 1990, to = 2017, by = 3),
                         limits = c(1990, 2017)) +
      scale_color_viridis_d(option = "magma", begin = 0.1) +
      labs(
        x = "Year",
        y = "Number of Deaths",
        color = "Regions",
        title = paste("Number of Deaths by", input$risk_factor_sanitation_line))
  })
}

# summary info: caption = "Source: Our World in Data"

# Run the application
shinyApp(ui = ui, server = server)
