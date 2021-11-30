# Load packages ----------------------------------------------------------------

library(shiny)
library(shinythemes)
library(shinyBS)
library(ggiraph)
library(tidyverse)
library(here)
#library(janitor)
library(maps)
library(scales)
library(plotly)
library(readr)
library(mapproj)

# Load pre-cleaned data --------------------------------------------------------

total_joined <- read_rds(here("data", "compressed_final_data.rds"))

substance_use_regions <- read_rds(
  here("data", "substance_use_regions.rds"))

sanitation_regions <- read_rds(
  here("data", "sanitation_regions.rds"))

diet_regions <- read_rds(
  here("data", "diet_regions.rds"))

health_regions <- read_rds(
  here("data", "health_regions.rds"))

post_natal_care_regions <- read_rds(
  here("data", "post_natal_care_regions.rds"))

# Define choices & random selection --------------------------------------------

# substance
regions_choices_substance <- substance_use_regions %>%
  distinct(entity) %>%
  arrange(entity) %>%
  pull(entity)

selected_regions_choices_substance <- sample(regions_choices_substance, 3)

# diet
regions_choices_diet <- diet_regions %>%
  distinct(entity) %>%
  arrange(entity) %>%
  pull(entity)

selected_regions_choices_diet <- sample(regions_choices_diet, 3)

# sanitation
regions_choices_sanitation <- sanitation_regions %>%
  distinct(entity) %>%
  arrange(entity) %>%
  pull(entity)

selected_regions_choices_sanitation <- sample(regions_choices_sanitation, 3)

# health
regions_choices_health <- health_regions %>%
  distinct(entity) %>%
  arrange(entity) %>%
  pull(entity)

selected_regions_choices_health <- sample(regions_choices_health, 3)

# post natal care
regions_choices_post_natal_care <- post_natal_care_regions %>%
  distinct(entity) %>%
  arrange(entity) %>%
  pull(entity)

selected_regions_choices_post_natal_care <-
  sample(regions_choices_post_natal_care, 3)

# Define UI --------------------------------------------------------------------

ui <- fluidPage(
  theme = shinytheme("cosmo"),
  titlePanel("Deaths By Risk Factors"),

  # air pollution
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
               # trying to make plot_click show country name and death rate
               # output code on line: 373
               mainPanel(
                 plotlyOutput(outputId = "plot_air"),
                 #,
                 #click = "plot_click"),
                 #verbatimTextOutput("info_air"),
                 # sliderInput(
                 #   inputId = "selected_year_air",
                 #   label = "Select year",
                 #   min = 1990,
                 #   value = 1990,
                 #   max = 2017,
                 #   width = "100%",
                 #   animate = TRUE,
                 #   sep = ""
                 # )
               )
             )
    ),
    # substance
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
    ),
    # diet
    tabPanel("Diet",
             sidebarLayout(
               sidebarPanel(
                 selectInput(
                   inputId = "risk_factor_diet",
                   label = "Type of Diet",
                   choices = c(
                     "Low in Fruits" = "diet_low_in_fruits_rate",
                     "Low in Vegetables" = "diet_low_in_vegetables_rate",
                     "High in Sodium" = "diet_high_in_sodium_rate",
                     "Low in Whole Grains" =
                       "diet_low_in_whole_grains_rate",
                     "Low in Nuts and Seeds" =
                       "diet_low_in_nuts_and_seeds_rate"
                   )
                 ),
                 checkboxGroupInput(inputId = "entity",
                                    label = "Select up to 8 regions:",
                                    choices = regions_choices_diet,
                                    selected = selected_regions_choices_diet
                 )
               ),
               mainPanel(
                 plotlyOutput(outputId = "plot_diet"),
                 plotOutput(outputId = "plot_diet_line")
               )
             )
    ),
    # sanitation
    tabPanel("Sanitation",
             sidebarLayout(
               sidebarPanel(
                 selectInput(
                   inputId = "risk_factor_sanitation",
                   label = "Type of Sanitation",
                   choices = c(
                     "Unsafe Water Source" = "unsafe_water_source_rate",
                     "Unsafe Sanitation" = "unsafe_sanitation_rate",
                     "No Hand Wash" =
                       "no_access_to_handwash_facility_rate"
                   )
                 ),
                 checkboxGroupInput(inputId = "entity",
                                    label = "Select up to 8 regions:",
                                    choices = regions_choices_sanitation,
                                    selected =
                                      selected_regions_choices_sanitation
                 )
               ),
               mainPanel(
                 plotlyOutput(outputId = "plot_sanitation"),
                 plotOutput(outputId = "plot_sanitation_line")
               )
             )
    ),
    # health
    tabPanel("Health",
             sidebarLayout(
               sidebarPanel(
                 selectInput(
                   inputId = "risk_factor_health",
                   label = "Type of Health",
                   choices = c(
                     "Low Physical Activity" =
                       "low_physical_activity_rate",
                     "High Glucose" = "high_fasting_plasma_glucose_rate",
                     "High Cholesterol" = "high_total_cholesterol_rate",
                     "High Body Mass Index" = "high_body_mass_index_rate",
                     "High Blood Pressure" =
                       "high_systolic_blood_pressure_rate",
                     "Iron Deficiency" = "iron_deficiency_rate",
                     "Vitamin A Defficiency" = "vitamin_a_deficiency_rate",
                     "Low Bone Mineral Density" =
                       "low_bone_mineral_density_rate"
                   )
                 ),
                 checkboxGroupInput(inputId = "entity",
                                    label = "Select up to 8 regions:",
                                    choices = regions_choices_health,
                                    selected = selected_regions_choices_health
                 )
               ),
               mainPanel(
                 plotlyOutput(outputId = "plot_health"),
                 plotOutput(outputId = "plot_health_line")
               )
             )
    ),
    # post natal care
    tabPanel("Post-Natal Care",
             sidebarLayout(
               sidebarPanel(
                 selectInput(
                   inputId = "risk_factor_post_natal_care",
                   label = "Type of Post-Natal Care",
                   choices = c(
                     "Nonexclusive Breastfeeding" =
                       "non_exclusive_breastfeeding_rate",
                     "Discontinued Breastfeeding" =
                       "discontinued_breastfeeding_rate",
                     "Child Wasting" = "child_wasting_rate",
                     "Child Stunting" = "child_stunting_rate",
                     "Low Birth Weight" =
                       "low_birth_weight_for_gestation_rate"
                   )
                 ),
                 checkboxGroupInput(inputId = "entity",
                                    label = "Select up to 8 regions:",
                                    choices = regions_choices_post_natal_care,
                                    selected =
                                      selected_regions_choices_post_natal_care
                 )
               ),
               mainPanel(
                 plotlyOutput(outputId = "plot_post_natal_care"),
                 plotOutput(outputId = "plot_post_natal_care_line")
               )
             )
    )
  )
)


server <- function(input, output) {

  output$selected_regions <- reactive({
    paste("You've selected", length(input$entity), "regions.")
  })
  substance_use_regions_filtered <- reactive({
    substance_use_regions %>%
      filter(entity %in% input$entity)
  })

  # air pollution
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
                   fill = input$risk_factor_substance,
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

  output$plot_substance_line <- renderPlot({
    #validate(
      #need(length(input$entity) <= 9, "Please select a maxiumum of 8 regions")
    #)
    ggplot(data = substance_use_regions_filtered()) +
      geom_line(aes_string(group = input$entity, # used to be "entity"
                           color = input$entity, # used to be "entity"
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

  # diet
  output$plot_diet <- renderPlotly({
    diet_plotly <- (total_joined %>%
      ggplot(aes(long, lat)) +
      geom_polygon(
        aes_string(group = "group",
                   fill = input$risk_factor_diet,
                   label = "region",
                   frame = "year"),
        color = "white", size = 0.3
      ) +
      coord_map(
        projection = "mercator",
        xlim = c(-180, 180)
      ) +
      scale_fill_viridis_c(
        trans = "log10",
        option = "plasma",
        direction = -1,
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

    ggplotly(p = diet_plotly) %>%
      animation_opts(frame = 27)
  })


  diet_regions_filtered <- ({reactive({
    diet_regions %>%
      filter(entity %in% input$entity)
  })
  })
  output$plot_diet_line <- renderPlot({
    validate(
      need(length(input$entity) <= 8, "Please select a maxiumum of 8 regions")
    )
    ggplot(data = diet_regions_filtered()) +
      geom_line(aes_string(group = "entity",
                           color = "entity",
                           x = "year",
                           y = input$risk_factor_diet), size = 1) +
      theme_gray(base_size = 16) +
      theme(legend.position = "bottom",
            panel.grid.minor.x = element_blank()) +
      scale_y_continuous(labels = comma) +
      scale_x_continuous(breaks = seq(from = 1990, to = 2017, by = 3),
                         limits = c(1990, 2017)) +
      scale_color_viridis_d(option = "plasma", begin = 0.1) +
      labs(
        x = "Year",
        y = "Number of Deaths",
        color = "Regions",
        title = paste("Number of Deaths by", input$risk_factor_diet))
  })

  # sanitation
  output$plot_sanitation <- renderPlotly({
    sanitation_plotly <- (total_joined %>%
      ggplot(aes(long, lat)) +
      geom_polygon(
        aes_string(group = "group",
                   fill = input$risk_factor_sanitation,
                   label = "region",
                   frame = "year"),
        color = "white",
        size = 0.3
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
  sanitation_regions_filtered <- ({reactive({
    sanitation_regions %>%
      filter(entity %in% input$entity)
  })
  })
  output$plot_sanitation_line <- renderPlot({
    validate(
      need(length(input$entity) <= 8, "Please select a maxiumum of 8 regions")
    )
    ggplot(data = sanitation_regions_filtered()) +
      geom_line(aes_string(group = "entity",
                           color = "entity",
                           x = "year",
                           y = input$risk_factor_sanitation), size = 1) +
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
        title = paste("Number of Deaths by", input$risk_factor_sanitation))
  })

  # health map
  output$plot_health <- renderPlotly({
    health_plotly <- (total_joined %>%
      ggplot(aes(long, lat)) +
      geom_polygon(
        aes_string(group = "group",
                   fill = input$risk_factor_health,
                   label = "region",
                   frame = "year"),
        color = "white", size = 0.3
      ) +
      coord_map(
        projection = "mercator",
        xlim = c(-180, 180)
      ) +
      scale_fill_viridis_c(
        trans = "log10",
        option = "cividis",
        direction = -1,
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
    ggplotly(p = health_plotly) %>%
      animation_opts(frame = 27)

  })

  # health line plot

  health_regions_filtered <- ({reactive({
    health_regions %>%
      filter(entity %in% input$entity)
  })
  })
  output$plot_health_line <- renderPlot({
    #validate(
      #need(length(input$entity) <= 8, "Please select a maximum of 8 regions")
    #)
    ggplot(data = health_regions_filtered()) +
      geom_line(aes_string(group = input$entity,
                           color = input$entity,
                           x = "year",
                           y = input$risk_factor_health), size = 1) +
      theme_gray(base_size = 16) +
      theme(legend.position = "bottom",
            panel.grid.minor.x = element_blank()) +
      scale_y_continuous(labels = comma) +
      scale_x_continuous(breaks = seq(from = 1990, to = 2017, by = 3),
                         limits = c(1990, 2017)) +
      scale_color_viridis_d(
        option = "cividis",
        begin = 0.1) +
      labs(
        x = "Year",
        y = "Number of Deaths",
        color = "Regions",
        title = paste("Number of Deaths by", input$risk_factor_health))
  })

  # post natal care map

  output$plot_post_natal_care <- renderPlotly({
    post_natal_care_plotly <- (total_joined %>%
      ggplot(aes(long, lat)) +
      geom_polygon(
        aes_string(group = "group",
                   fill = input$risk_factor_post_natal_care,
                   label = "region",
                   frame = "year"),
        color = "white", size = 0.3
      ) +
      coord_map(
        projection = "mercator",
        xlim = c(-180, 180)
      ) +
      scale_fill_viridis_c(
        trans = "log10",
        option = "mako",
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
    ggplotly(p = post_natal_care_plotly) %>%
      animation_opts(frame = 27)
  })

  # post natal care line plot
  post_natal_care_regions_filtered <- ({reactive({
    post_natal_care_regions %>%
      filter(entity %in% input$entity)
  })
  })
  output$plot_post_natal_care_line <- renderPlot({
    validate(
      need(length(input$entity) <= 8, "Please select a maxiumum of 8 regions")
    )
    ggplot(data = post_natal_care_regions_filtered()) +
      geom_line(aes_string(group = "entity",
                           color = "entity",
                           x = "year",
                           y = input$risk_factor_post_natal_care), size = 1) +
      theme_gray(base_size = 16) +
      theme(legend.position = "bottom",
            panel.grid.minor.x = element_blank()) +
      scale_y_continuous(labels = comma) +
      scale_x_continuous(breaks = seq(from = 1990, to = 2017, by = 3),
                         limits = c(1990, 2017)) +
      scale_color_viridis_d(option = "mako", begin = 0.1) +
      labs(
        x = "Year",
        y = "Number of Deaths",
        color = "Regions",
        title = paste("Number of Deaths by", input$risk_factor_post_natal_care))
  })
}

# summary info: caption = "Source: Our World in Data"

# Run the application
shinyApp(ui = ui, server = server)
