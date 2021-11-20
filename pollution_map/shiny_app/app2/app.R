# Load packages ----------------------------------------------------------------

library(shiny)
library(shinyBS)
library(plotly)
library(tidyverse)
library(here)
library(janitor)
library(maps)
library(scales)

# Load data --------------------------------------------------------------------

# air pollution data
death_rates_from_air_pollution_csv <- read_csv(
    here("data", "death-rates-from-air-pollution.csv"),
    show_col_types = FALSE
)

number_deaths_by_risk_factor_csv <- read_csv(
    here("data", "number-of-deaths-by-risk-factor.csv"),
    show_col_types = FALSE
)

# gdp data
gdp_by_country_csv <- read_csv(
    here("data", "gdp-data.csv"),
    show_col_types = FALSE
)

# NOTE: added _csv ending to eliminate need for naming later versions "clean"

# world map data
world_map_data <- map_data("world") %>%
    as_tibble()

# renaming variables to clean them up

death_rates_from_air_pollution <- death_rates_from_air_pollution_csv %>%
    clean_names() %>%
    rename(
        death_rate_air_pollution =
            deaths_air_pollution_sex_both_age_age_standardized_rate,
        death_rate_household_pollution = deaths_household_air_pollution_from_solid_fuels_sex_both_age_age_standardized_rate,
        death_rate_ambient_matter_pollution = deaths_ambient_particulate_matter_pollution_sex_both_age_age_standardized_rate,
        death_rate_ozone_pollution =
            deaths_ambient_ozone_pollution_sex_both_age_age_standardized_rate
    )

number_deaths_by_risk_factor <- number_deaths_by_risk_factor_csv %>%
    clean_names()

gdp_by_country <- gdp_by_country_csv %>%
    clean_names() %>%
    pivot_wider()

# joining air pollution data together
air_pollution_joined <- death_rates_from_air_pollution %>%
    left_join(number_deaths_by_risk_factor, by = c("entity", "year", "code"))

# Next Step: Do a series of case_when (before join) to resolve inconsistencies
# noticeable ones include: French Guiana (but there might just not be data on this)

# clean world_map_data
world_map_data <- world_map_data %>%
    mutate(region = case_when(
        region == "Ivory Coast" ~ "Cote d'Ivoire",
        TRUE ~ region
    ))

# clean air pollution data

air_pollution_joined <- air_pollution_joined %>%
    mutate(entity = case_when(
        entity == "United States" ~ "USA",
        entity == "United Kingdom" ~ "UK",
        entity == "Czechia" ~ "Czech Republic",
        entity == "Congo" ~ "Republic of Congo",
        entity == "Democratic Republic of Congo" ~
            "Democratic Republic of the Congo",
        TRUE ~ entity
    ))


# joining air pollution to world_map_data
total_joined <- world_map_data %>%
    left_join(air_pollution_joined, by = c("region" = "entity"))

# Define UI --------------------------------------------------------------------

ui <- fluidPage(
    titlePanel("Air Pollution Deaths"),
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
                    "Ozone Pollution Death Rate" = "death_rate_ozone_pollution"
                )
            )
        ),
        mainPanel(
            tabsetPanel(
                type = "tabs",
                tabPanel(
                    "Air Pollution", plotOutput(outputId = "plot"),
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
                ),
                tabPanel(
                    "Tab 2"
                )
            )
        )
    )
)
    # tabPanel("Other Risk Factors",
    #          sidebarLayout(
    #              sidebarPanel(
    #                  selectInput(
    #                      inputId = "number_deaths_by_risk_factor",
    #                      label = "Type of Risk Factor",
    #                      choices = c(
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
    #                          "Secondhand Smoking" = "secondhand_smoke",
    #                          "Alcohol Use" = "alcohol_use",
    #                          "Drug Use" = "drug_use",
    #                          "Diet Low in Fruits" = "diet_low_in_fruits",
    #                          "Diet Low in Vegetables" =
    #                              "diet_low_in_vegetables",
    #                          "Unsafe Sex" = "unsafe_sex",
    #                          "Low Physical Activity" = "low_physical_activity",
    #                          "High Glucose" = "high_fasting_plasma_glucose",
    #                          "High Cholesterol" = "high_total_cholesterol",
    #                          "High Body Mass Index" = "high_body_mass_index",
    #                          "High Blood Pressure" =
    #                              "high_systolic_blood_pressure",
    #                          "Smoking" = "smoking",
    #                          "Iron Deficiency" = "iron_deficiency",
    #                          "Vitamin A Defficiency" = "vitamin_a_deficiency",
    #                          "Low Bone Mineral Density" =
    #                              "low_bone_mineral_density",
    #                          "Diet High in Sodium" = "diet_high_in_sodium",
    #                          "Diet Low in Whole Grains" =
    #                              "diet_low_in_whole_grains",
    #                          "Diet Low in Nuts and Seeds" =
    #                              "diet_low_in_nuts_and_seeds"
    #                          )
    #                      )
    #                  )
    #              ),
    #          mainPanel(
    #              plotOutput(outputId = "plot2"),
    #              sliderInput(
    #                  inputId = "selected_year",
    #                  label = "Select year",
    #                  min = 1990,
    #                  value = 1990,
    #                  max = 2017,
    #                  width = "100%",
    #                  animate = TRUE,
    #                  sep = ""
    #                  )
    #              )
    #          )
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
        # plotly(output$plot, tooltip = c("group"))
        # how to display this info?
    })
    }

# summary info: caption = "Source: Our World in Data"

# Run the application
shinyApp(ui = ui, server = server)
