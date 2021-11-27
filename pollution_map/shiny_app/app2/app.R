# LOAD PACKAGES  ----------------------------------------------------------------

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

# LOAD PRE-CLEANED DATA --------------------------------------------------------

total_joined <- read_rds(
    here("data", "compressed_final_data.rds"))

# DEFINE UI --------------------------------------------------------------------

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
                                 "Air Pollution Death Rate" =
                                     "death_rate_air_pollution",
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
                         plotOutput(outputId = "plot",
                                    hover = "plot_hover" #,
                                    #dblclick = "plot1_dblclick", # this code should make the zoom work
                                    #brush = brushOpts(
                                     #   id = "plot1_brush",
                                      #  resetOnNew = TRUE)
                                    )
                         ),
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
                             inputId = "air_pollution_type",
                             label = "Type of Substance",
                             choices = c(
                                 "Secondhand Smoking" = "secondhand_smoke",
                                 "Alcohol Use" = "alcohol_use",
                                 "Drug Use" = "drug_use",
                                 "Smoking" = "smoking"
                             )
                         )
                     ),
                     mainPanel(
                         plotOutput(outputId = "plot2"),
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
        tabPanel("Diet",
                 sidebarLayout(
                     sidebarPanel(
                         selectInput(
                             inputId = "air_pollution_type",
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
                         )
                     ),
                     mainPanel(
                         plotOutput(outputId = "plot3"),
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
        tabPanel("Sanitation",
                 sidebarLayout(
                     sidebarPanel(
                         selectInput(
                             inputId = "air_pollution_type",
                             label = "Type of Sanitation",
                             choices = c(
                                 "Unsafe Water Source" = "unsafe_water_source",
                                 "Unsafe Sanitation" = "unsafe_sanitation",
                                 "No Hand Wash" =
                                     "no_access_to_handwash_facility"
                             )
                         )
                     ),
                     mainPanel(
                         plotOutput(outputId = "plot4"),
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
                             inputId = "air_pollution_type",
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
                         )
                     ),
                     mainPanel(
                         plotOutput(outputId = "plot5"),
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
                             inputId = "air_pollution_type",
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
                         )
                     ),
                     mainPanel(
                         plotOutput(outputId = "plot6"),
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


# SERVER -----------------------------------------------------------------------
server <- function(input, output) {
    # remaining <- reactive({
    # names(total_joined)[c("death_rate_air_pollution",
    # "death_rate_household_pollution",
    # "death_rate_ambient_matter_pollution",
    # "death_rate_ozone_pollution",
    #-match(input$air_pollution_type,
    # names(total_joined)))]
    # })

  #  ranges <- reactiveValues(x = NULL, y = NULL) # this is for the zoom

    output$plot <- renderPlot({
        total_joined %>%
            filter(year == input$selected_year) %>%
            ggplot(aes(long, lat)) +
            geom_polygon_interactive(
                aes_string(
                group = "group", fill = input$air_pollution_type),
                color = "white", size = 0.2
            ) +
            coord_map(
                projection = "mercator",
                xlim = c(-180, 180)
            ) +
            #coord_cartesian(xlim = ranges$x, ylim = ranges$y, expand = FALSE) + # for the zoom
            scale_fill_viridis_c(
                limits = c(0, 300),
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
    # When a double-click happens, check if there's a brush on the plot.
    # If so, zoom to the brush bounds; if not, reset the zoom.
   # observeEvent(input$plot1_dblclick, {
   #     brush <- input$plot1_brush
   #     if (!is.null(brush)) {
   #         ranges$x <- c(brush$xmin, brush$xmax)
   #         ranges$y <- c(brush$ymin, brush$ymax)
#
   #     } else {
   #         ranges$x <- NULL
   #         ranges$y <- NULL
   #     }
   # })

    output$info <- renderText({
            paste0("country:\n Death Rate:")
    })
    output$plot2 <- renderPlot({
        total_joined %>%
            filter(year == input$selected_year) %>%
            ggplot(aes(long, lat)) +
            geom_polygon_interactive(
                aes_string(group = "group", fill = input$air_pollution_type),
                color = "white", size = 0.2
            ) +
            coord_map(
                projection = "mercator",
                xlim = c(-180, 180)
            ) +
            scale_fill_viridis_c(
                option = "inferno",
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
    output$plot3 <- renderPlot({
        total_joined %>%
            filter(year == input$selected_year) %>%
            ggplot(aes(long, lat)) +
            geom_polygon_interactive(
                aes_string(group = "group", fill = input$air_pollution_type),
                color = "white", size = 0.3
            ) +
            coord_map(
                projection = "mercator",
                xlim = c(-180, 180)
            ) +
            scale_fill_viridis_c(
                option = "plasma",
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
    output$plot4 <- renderPlot({
        total_joined %>%
            filter(year == input$selected_year) %>%
            ggplot(aes(long, lat)) +
            geom_polygon_interactive(
                aes_string(group = "group", fill = input$air_pollution_type),
                color = "white", size = 0.3
            ) +
            coord_map(
                projection = "mercator",
                xlim = c(-180, 180)
            ) +
            scale_fill_viridis_c(
                option = "magma",
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
    output$plot5 <- renderPlot({
        total_joined %>%
            filter(year == input$selected_year) %>%
            ggplot(aes(long, lat)) +
            geom_polygon_interactive(
                aes_string(group = "group", fill = input$air_pollution_type),
                color = "white", size = 0.3
            ) +
            coord_map(
                projection = "mercator",
                xlim = c(-180, 180)
            ) +
            scale_fill_viridis_c(
                option = "cividis",
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
    output$plot6 <- renderPlot({
        total_joined %>%
            filter(year == input$selected_year) %>%
            ggplot(aes(long, lat)) +
            geom_polygon_interactive(
                aes_string(group = "group", fill = input$air_pollution_type),
                color = "white", size = 0.3
            ) +
            coord_map(
                projection = "mercator",
                xlim = c(-180, 180)
            ) +
            scale_fill_viridis_c(
                option = "mako",
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

# RUN THE APPLICATION ----------------------------------------------------------
shinyApp(ui = ui, server = server)
