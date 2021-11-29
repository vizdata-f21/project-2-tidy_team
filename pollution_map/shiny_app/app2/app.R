# Load packages ----------------------------------------------------------------

library(shiny)
library(shinythemes)
library(shinyBS)
library(plotly)
library(ggiraph)
library(tidyverse)
library(here)
library(janitor)
library(maps)
library(scales)

# Load pre-cleaned data --------------------------------------------------------

total_joined <- read_rds(
  here("data", "compressed_final_data.rds"))

# defining choices & random selection
regions_choices <- substance_use_regions %>%
  distinct(entity) %>%
  arrange(entity) %>%
  pull(entity)

selected_regions_choices <- sample(regions_choices, 3)

# Define UI --------------------------------------------------------------------

ui <- fluidPage(
  theme = shinytheme("cosmo"),
  titlePanel("Deaths By Risk Factors"),
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
                 plotOutput(outputId = "plot_air",
                            click = "plot_click"),
                 verbatimTextOutput("info"),
                 sliderInput(
                   inputId = "selected_year",
                   label = "Select year",
                   min = 1990,
                   value = 1990,
                   max = 2017,
                   width = "100%",
                   animate = TRUE,
                   sep = ""
                 )
               )
             )
    ),
    tabPanel("Substance Use",
             sidebarLayout(
               sidebarPanel(
                 selectInput(
                   inputId = "risk_factor_substance",
                   label = "Type of Substance",
                   choices = c(
                     "Secondhand Smoking" = "secondhand_smoke",
                     "Alcohol Use" = "alcohol_use",
                     "Drug Use" = "drug_use",
                     "Smoking" = "smoking"
                   )
                 ),
                checkboxGroupInput(inputId = "entity",
                                      label = "Select up to 8 regions:",
                                      choices = regions_choices,
                                      selected = selected_regions_choices)
             ),
               mainPanel(
                 plotOutput(outputId = "plot_substance"),
                 sliderInput(
                   inputId = "selected_year",
                   label = "Select year",
                   min = 1990,
                   value = 1990,
                   max = 2017,
                   width = "100%",
                   animate = TRUE,
                   sep = ""
                 ),
                 plotOutput(outputId = "plot_substance_line")
               )
             )
    ),
    tabPanel("Diet",
             sidebarLayout(
               sidebarPanel(
                 selectInput(
                   inputId = "risk_factor_diet",
                   label = "Type of Diet",
                   choices = c(
                     "Low in Fruits" = "diet_low_in_fruits",
                     "Low in Vegetables" = "diet_low_in_vegetables",
                     "High in Sodium" = "diet_high_in_sodium",
                     "Low in Whole Grains" =
                       "diet_low_in_whole_grains",
                     "Low in Nuts and Seeds" =
                       "diet_low_in_nuts_and_seeds"
                   )
                 ),
                 checkboxGroupInput(inputId = "entity",
                                       label = "Select up to 8 regions:",
                                       choices = regions_choices,
                                       selected = selected_regions_choices)

               ),
               mainPanel(
                 plotOutput(outputId = "plot_diet"),
                 sliderInput(
                   inputId = "selected_year",
                   label = "Select year",
                   min = 1990,
                   value = 1990,
                   max = 2017,
                   width = "100%",
                   animate = TRUE,
                   sep = ""
                 ),
                 plotOutput("diet_plot")

               )
             )
    ),
    tabPanel("Sanitation",
             sidebarLayout(
               sidebarPanel(
                 selectInput(
                   inputId = "risk_factor_sanitation",
                   label = "Type of Sanitation",
                   choices = c(
                     "Unsafe Water Source" = "unsafe_water_source",
                     "Unsafe Sanitation" = "unsafe_sanitation",
                     "No Hand Wash" =
                       "no_access_to_handwash_facility"
                   )
                 ),
                 checkboxGroupInput(inputId = "entity",
                                    label = "Select up to 8 regions:",
                                    choices = regions_choices,
                                    selected = selected_regions_choices)
               ),
               mainPanel(
                 plotOutput(outputId = "plot_sanitation"),
                 sliderInput(
                   inputId = "selected_year",
                   label = "Select year",
                   min = 1990,
                   value = 1990,
                   max = 2017,
                   width = "100%",
                   animate = TRUE,
                   sep = ""
                 )
               )
             )
    ),
    tabPanel("Health",
             sidebarLayout(
               sidebarPanel(
                 selectInput(
                   inputId = "risk_factor_health",
                   label = "Type of Health",
                   choices = c(
                     "Low Physical Activity" =
                       "low_physical_activity",
                     "High Glucose" = "high_fasting_plasma_glucose",
                     "High Cholesterol" = "high_total_cholesterol",
                     "High Body Mass Index" =
                       "high_body_mass_index",
                     "High Blood Pressure" =
                       "high_systolic_blood_pressure",
                     "Iron Deficiency" = "iron_deficiency",
                     "Vitamin A Defficiency" =
                       "vitamin_a_deficiency",
                     "Low Bone Mineral Density" =
                       "low_bone_mineral_density"
                   )
                 ),
                 checkboxGroupInput(inputId = "entity",
                                    label = "Select up to 8 regions:",
                                    choices = regions_choices,
                                    selected = selected_regions_choices)
               ),
               mainPanel(
                 plotOutput(outputId = "plot_health"),
                 sliderInput(
                   inputId = "selected_year",
                   label = "Select year",
                   min = 1990,
                   value = 1990,
                   max = 2017,
                   width = "100%",
                   animate = TRUE,
                   sep = ""
                 )
               )
             )
    ),
    tabPanel("Post-Natal Care",
             sidebarLayout(
               sidebarPanel(
                 selectInput(
                   inputId = "risk_factor_natal",
                   label = "Type of Post-Natal Care",
                   choices = c(
                     "Nonexclusive Breastfeeding" =
                       "non_exclusive_breastfeeding",
                     "Discontinued Breastfeeding" =
                       "discontinued_breastfeeding",
                     "Child Wasting" = "child_wasting",
                     "Child Stunting" = "child_stunting",
                     "Low Birth Weight" =
                       "low_birth_weight_for_gestation"
                   )
                 ),
                 checkboxGroupInput(inputId = "entity",
                                    label = "Select up to 8 regions:",
                                    choices = regions_choices,
                                    selected = selected_regions_choices)
               ),
               mainPanel(
                 plotOutput(outputId = "plot_natal"),
                 sliderInput(
                   inputId = "selected_year",
                   label = "Select year",
                   min = 1990,
                   value = 1990,
                   max = 2017,
                   width = "100%",
                   animate = TRUE,
                   sep = ""
                 )
               )
             )
    )
  )
)


server <- function(input, output) {
  # remaining <- reactive({
  # names(total_joined)[c("death_rate_air_pollution",
  # "death_rate_household_pollution",
  # "death_rate_ambient_matter_pollution",
  # "death_rate_ozone_pollution",
  #-match(input$air_pollution_type,
  # names(total_joined)))]
  # })
  output$selected_regions <- reactive({
    paste("You've selected", length(input$entity), "regions.")
  })

  substance_use_regions_filtered <- reactive({
    substance_use_regions %>%
      filter(entity %in% input$entity)
  })
  output$plot_air <- renderPlot({
    total_joined %>%
      filter(year == input$selected_year) %>%
      ggplot(aes(long, lat)) +
      geom_polygon_interactive(
        aes_string(
          group = "group", fill = input$air_pollution_type),
        color = "white", size = 0.1
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
        name = "Death rate",
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
      )
  })
  output$info <- renderText({
    paste0("Country:", input$plot_click$entity)
  })
  output$plot_substance <- renderPlot({
    total_joined %>%
      filter(year == input$selected_year) %>%
      ggplot(aes(long, lat)) +
      geom_polygon_interactive(
        aes_string(group = "group", fill = input$risk_factor_substance),
        color = "white", size = 0.1
      ) +
      coord_map(
        projection = "mercator",
        xlim = c(-180, 180)
      ) +
      scale_fill_viridis_c(
        option = "inferno",
        direction = -1,
        begin = 0.2,
        end = 0.9,
        name = "Death rate",
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
      )
  })
output$plot_substance_line <- renderPlot({
    validate(
      need(length(input$entity) <= 8, "Please select a maxiumum of 8 regions")
    )
    ggplot(data = substance_use_regions_filtered()) +
      geom_line(aes_string(group = "entity",
                           color = "entity",
                           x = "year",
                           y = input$risk_factor_substance), size = 1) +
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
  output$plot_diet <- renderPlot({
    total_joined %>%
      filter(year == input$selected_year) %>%
      ggplot(aes(long, lat)) +
      geom_polygon_interactive(
        aes_string(group = "group", fill = input$risk_factor_diet),
        color = "white", size = 0.3
      ) +
      coord_map(
        projection = "mercator",
        xlim = c(-180, 180)
      ) +
      scale_fill_viridis_c(
        option = "plasma",
        direction = -1,
        name = "Death rate",
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
      )
  })

  output$plot_sanitation <- renderPlot({
    total_joined %>%
      filter(year == input$selected_year) %>%
      ggplot(aes(long, lat)) +
      geom_polygon_interactive(
        aes_string(group = "group", fill = input$risk_factor_sanitation),
        color = "white", size = 0.3
      ) +
      coord_map(
        projection = "mercator",
        xlim = c(-180, 180)
      ) +
      scale_fill_viridis_c(
        option = "magma",
        direction = -1,
        end = 0.9,
        name = "Death rate",
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
      )
  })
  output$plot_health <- renderPlot({
    total_joined %>%
      filter(year == input$selected_year) %>%
      ggplot(aes(long, lat)) +
      geom_polygon_interactive(
        aes_string(group = "group", fill = input$risk_factor_health),
        color = "white", size = 0.3
      ) +
      coord_map(
        projection = "mercator",
        xlim = c(-180, 180)
      ) +
      scale_fill_viridis_c(
        option = "cividis",
        direction = -1,
        name = "Death rate",
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
      )
  })
  output$plot_natal <- renderPlot({
    total_joined %>%
      filter(year == input$selected_year) %>%
      ggplot(aes(long, lat)) +
      geom_polygon_interactive(
        aes_string(group = "group", fill = input$risk_factor_natal),
        color = "white", size = 0.3
      ) +
      coord_map(
        projection = "mercator",
        xlim = c(-180, 180)
      ) +
      scale_fill_viridis_c(
        option = "mako",
        direction = -1,
        end = 0.9,
        name = "Death rate",
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
      )
  })
}

# summary info: caption = "Source: Our World in Data"

# Run the application
shinyApp(ui = ui, server = server)
