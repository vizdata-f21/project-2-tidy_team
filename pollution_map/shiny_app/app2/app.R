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
                plotOutput(outputId = "plot"),
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
                 )
        )
    )
    #     tabPanel(
    #         "Other Risk Factors",
    #         mainPanel(
    #             plotOutput(outputId = "plot2"),
    #         sliderInput(
    #             inputId = "selected_year",
    #             label = "Select year",
    #             min = 1990,
    #             value = 1990,
    #             max = 2017,
    #             width = "100%",
    #             animate = TRUE,
    #             sep = ""
    #         )
    #         ),
    #         sidebarLayout(
    #             sidebarPanel(
    #                 selectInput(
    #                     inputId = "number_deaths_by_risk_factor",
    #                     label = "Type of Risk Factor",
    #                     choices = c(
    #                          "Unsafe Water Source" = "unsafe_water_source",
    #                          "Unsafe Sanitation" = "unsafe_sanitation",
    #                          "No Hand Wash" = "no_access_to_handwash_facility",
    #                          "Nonexclusive Breastfeeding" =
    #                              "non_exclusive_breastfeeding",
    #                          "Discontinued Breastfeeding" =
    #                              "discontinued_breastfeeding",
    #                          "Child Wasting" = "child_wasting",
    #                          "Child Stunting" = "child_stunting",
    #                          "Low Birth Weight" =
    #                              "low_birth_weight_for_gestation",
    #
    #
    #                          "Unsafe Sex" = "unsafe_sex",
    #                          "Low Physical Activity" = "low_physical_activity",
    #                          "High Glucose" = "high_fasting_plasma_glucose",
    #                          "High Cholesterol" = "high_total_cholesterol",
    #                          "High Body Mass Index" = "high_body_mass_index",
    #                          "High Blood Pressure" =
    #                              "high_systolic_blood_pressure",

    #                          "Iron Deficiency" = "iron_deficiency",
    #                          "Vitamin A Defficiency" = "vitamin_a_deficiency",
    #                          "Low Bone Mineral Density" =
    #                              "low_bone_mineral_density",

    #                          )
    #                      )
    #                  )
    #              )
    #     )
    # )


server <- function(input, output) {
    # remaining <- reactive({
    # names(total_joined)[c("death_rate_air_pollution",
    # "death_rate_household_pollution",
    # "death_rate_ambient_matter_pollution",
    # "death_rate_ozone_pollution",
    #-match(input$air_pollution_type,
    # names(total_joined)))]
    # })
    output$plot <- renderPlot({
        total_joined %>%
            filter(year == input$selected_year) %>%
            ggplot(aes(long, lat)) +
            geom_polygon_interactive(
                aes_string(
                group = "group", fill = input$air_pollution_type),
                color = "black", size = 0.3
            ) +
            coord_map(
                projection = "mercator",
                xlim = c(-180, 180)
            ) +
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
       # plotly(output$plot, tooltip = c("group"))
        # how to display this info?
    })
    output$plot2 <- renderPlot({
        total_joined %>%
            filter(year == input$selected_year) %>%
            ggplot(aes(long, lat)) +
            geom_polygon_interactive(
                aes_string(group = "group", fill = input$air_pollution_type),
                color = "black", size = 0.3
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
                color = "black", size = 0.3
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
        # plotly(output$plot, tooltip = c("group"))
        # how to display this info?
    })
    }

# summary info: caption = "Source: Our World in Data"

# Run the application
shinyApp(ui = ui, server = server)
