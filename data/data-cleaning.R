# Load packages -----------------------------------------------------

library(tidyverse)
library(here)
library(janitor)
library(maps)

# Load data ---------------------------------------------------------

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
    region == "Eswatini" ~ "Swaziland",
    TRUE ~ region
  ))

# clean air pollution data

air_pollution_joined <- air_pollution_joined %>%
  mutate(entity = case_when(
    entity == "United States" ~ "USA",
    entity == "United Kingdom" ~ "UK",
    entity == "Czechia" ~ "Czech Republic",
    entity == "Congo" ~ "Republic of Congo",
    entity == "Democratic Republic of Congo" ~ "Democratic Republic of the Congo",
    TRUE ~ entity
  ))


# joining air pollution to world_map_data
total_joined <- world_map_data %>%
  left_join(air_pollution_joined, by = c("region" = "entity"))

write_rds(total_joined, "data/compressed_final_data.rds", "gz")


