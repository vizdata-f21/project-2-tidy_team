# Load packages -----------------------------------------------------

library(shiny)
library(tidyverse)
library(spData) # For getting spatial data
library(sf) # For preserving spatial data
library(here)
library(janitor)
library(maps)
library(scales)

# Load data ---------------------------------------------------------

# air pollution data
death_rates_from_air_pollution_csv <- read_csv(
    here("data", "death-rates-from-air-pollution.csv"), show_col_types = FALSE)

number_deaths_by_risk_factor_csv <- read_csv(
    here("data", "number-of-deaths-by-risk-factor.csv"), show_col_types = FALSE)

# gdp data
gdp_by_country_csv <- read_csv(
    here("data", "gdp-data.csv"), show_col_types = FALSE)

# NOTE: added _csv ending to eliminate need for naming later versions "clean"

# world map data
world_map_data <- map_data("world") %>%
    as_tibble()
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
# noticeable ones include: Cote d'ivorie, Congo, Dem. Rep of Congo, Czechnia, French Guiana

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
        TRUE ~ entity
    ))


# joining air pollution to world_map_data
total_joined <- world_map_data %>%
    left_join(air_pollution_joined, by = c("region" = "entity"))

# Define UI ---------------------------------------------------------

ui <- fluidPage(

    titlePanel("Air Pollution Deaths"),

    sidebarLayout(
        sidebarPanel(
            sliderInput("bins",
                        "Year",
                        min = 1990,
                        max = 2017,
                        value = 1990))),
    mainPanel(
             tabsetPanel(
                 type = "tabs",
                 tabPanel("Air Pollution", plotOutput(outputId = "plot"),
                     conditionalPanel(
                         condition = "input.industry.length <= 8",
                         sliderInput(
                             inputId = "ylim",
                             label = "Select year",
                             min = 1990,
                             value = 1990,
                             max = 2017,
                             width = "100%"),
                         plotOutput(outputId = "plot"))))))


server <- function(input, output) {
    output$plot <- renderPlot({
        ggplot(total_joined, aes(long, lat)) +
            geom_polygon(aes(group = group, fill = death_rate_air_pollution),
                         color = "black", size = 0.3) +
            coord_map(projection = "mercator",
                      xlim = c(-180, 180)) +
            scale_fill_viridis_c(option = "turbo",
                                 # turbo pallet coordinates with AQI colors (https://webcam.srs.fs.fed.us/test/AQI.shtml)
                                 name = "Total death rate",
                                 labels = label_number(big.mark = ","),
                                 na.value = "white"
            ) +
            theme_void() +
            theme(
                text = element_text(color = "black"),
                legend.position = "bottom",
                legend.key.width = unit(2, "cm"),
                legend.key.height = unit(0.3, "cm"),
                plot.background = element_rect(fill = "lightgray", color = "lightgray"),
                plot.title = element_text(hjust = 0.5),
                plot.subtitle = element_text(hjust = 0.5)
            ) +
            labs(
                title = "Total Death Rate from Air Pollution",
                subtitle = "By country, from 1970 to 2017",
                caption = "Source: Our World in Data"
            )
    }
    )
}

# Run the application
shinyApp(ui = ui, server = server)
