# Load packages

library(tidyverse)
library(here)
library(janitor)
library(maps)
library(readxl)
library(styler)

# Load data for risk factors

# air pollution data
death_rates_from_air_pollution <- read_csv(
  here("data", "death-rates-from-air-pollution.csv"),
  show_col_types = FALSE
)

# other risk factors data
number_deaths_by_risk_factor <- read_csv(
  here("data", "number-of-deaths-by-risk-factor.csv"),
  show_col_types = FALSE
)

# load world map data
world_map_data <- map_data("world") %>%
  as_tibble()

# renaming variables to clean them up
death_rates_from_air_pollution <- death_rates_from_air_pollution %>%
  clean_names() %>%
  rename(
    death_rate_air_pollution = deaths_air_pollution_sex_both_age_age_standardized_rate,
    death_rate_household_pollution = deaths_household_air_pollution_from_solid_fuels_sex_both_age_age_standardized_rate,
    death_rate_ambient_matter_pollution = deaths_ambient_particulate_matter_pollution_sex_both_age_age_standardized_rate,
    death_rate_ozone_pollution = deaths_ambient_ozone_pollution_sex_both_age_age_standardized_rate
  )

number_deaths_by_risk_factor <- number_deaths_by_risk_factor %>%
  clean_names()

# joining air pollution and other risk factors data together
air_pollution_joined <- death_rates_from_air_pollution %>%
  left_join(number_deaths_by_risk_factor, by = c("entity", "year", "code"))

# A series of case_when (before join) to resolve inconsistencies

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

# joining air pollution joined with risk factors to world_map_data
total_joined <- world_map_data %>%
  left_join(air_pollution_joined, by = c("region" = "entity"))

# load and clean selected population data from Our World in Data
population <- read_rds(
  here("data", "population_data.RData")
)

population <- population %>%
  mutate(entity = case_when(
    entity == "United States" ~ "USA",
    entity == "United Kingdom" ~ "UK",
    entity == "Czechia" ~ "Czech Republic",
    entity == "Congo" ~ "Republic of Congo",
    entity == "Democratic Republic of Congo" ~ "Democratic Republic of the Congo",
    TRUE ~ entity
  ))

# join population data to risk factors and map data
total_joined <- total_joined %>%
  left_join(population, by = c("region" = "entity", "year"))

# calculating death rates
total_joined <- total_joined %>%
  group_by(region, year) %>%
  mutate(
    unsafe_water_source_rate = unsafe_water_source / population_historical_estimates * 100000,
    unsafe_sanitation_rate = unsafe_sanitation / population_historical_estimates * 100000,
    no_access_to_handwashing_facility_rate = no_access_to_handwashing_facility / population_historical_estimates * 100000,
    household_air_pollution_from_solid_fuels_rate = household_air_pollution_from_solid_fuels / population_historical_estimates * 100000,
    secondhand_smoke_rate = secondhand_smoke / population_historical_estimates * 100000,
    alcohol_use_rate = alcohol_use / population_historical_estimates * 100000,
    drug_use_rate = drug_use / population_historical_estimates * 100000,
    smoking_rate = smoking / population_historical_estimates * 100000,
    air_pollution_rate = air_pollution / population_historical_estimates * 100000,
    outdoor_air_pollution_rate = outdoor_air_pollution / population_historical_estimates * 100000
  )

# removing variables no longer needed since rate variables created
total_joined <- total_joined %>%
  select(
    -code.x,
    -drug_use,
    -unsafe_water_source,
    -unsafe_sanitation,
    -no_access_to_handwashing_facility,
    -household_air_pollution_from_solid_fuels,
    -non_exclusive_breastfeeding,
    -discontinued_breastfeeding,
    -child_wasting,
    -child_stunting,
    -low_birth_weight_for_gestation,
    -secondhand_smoke,
    -alcohol_use,
    -diet_low_in_fruits,
    -diet_low_in_vegetables,
    -unsafe_sex,
    -low_physical_activity,
    -high_fasting_plasma_glucose,
    -high_total_cholesterol,
    -high_body_mass_index,
    -high_systolic_blood_pressure,
    -smoking,
    -iron_deficiency,
    -vitamin_a_deficiency,
    -low_bone_mineral_density,
    -air_pollution,
    -outdoor_air_pollution,
    -diet_high_in_sodium,
    -diet_low_in_whole_grains,
    -diet_low_in_nuts_and_seeds,
    -code.y,
    -population_historical_estimates,
    -high_body_mass_index
  )

# filtering for every 3 years
total_joined <- total_joined %>%
  filter(year == 1990 |
    year == 1993 |
    year == 1996 |
    year == 1999 |
    year == 2002 |
    year == 2005 |
    year == 2008 |
    year == 2011 |
    year == 2015)

# write rds file for total joined

write_rds(total_joined, file = here("death_risk_factors", "data", "compressed_final_data.rds"), "gz")

# for regions line plot

# filter for regions
regions <- air_pollution_joined %>%
  filter(entity == "Central Asia" |
    entity == "Central Europe" |
    entity == "Central Latin America" |
    entity == "Central Sub-Saharan Africa" |
    entity == "East Asia " |
    entity == "Eastern Europe" |
    entity == "Eastern Sub-Saharan Africa" |
    entity == "Latin America and Caribbean" |
    entity == "North Africa and Middle East" |
    entity == "North America" |
    entity == "South Asia" |
    entity == "Southeast Asia" |
    entity == "Southern Latin America" |
    entity == "Southern Sub-Saharan Africa" |
    entity == "Sub-Saharan Africa" |
    entity == "Tropical Latin America" |
    entity == "Western Europe" |
    entity == "Western Sub-Saharan Africa")

# re-level factors
regions$entity <- factor(regions$entity,
  levels = c(
    "Central Asia",
    "East Asia ",
    "South Asia",
    "Southeast Asia",
    "Central Europe",
    "Eastern Europe",
    "Western Europe",
    "Sub-Saharan Africa",
    "Central Sub-Saharan Africa",
    "Southern Sub-Saharan Africa",
    "Western Sub-Saharan Africa",
    "Eastern Sub-Saharan Africa",
    "North Africa and Middle East",
    "North America",
    "Latin America and Caribbean",
    "Central Latin America",
    "Southern Latin America",
    "Tropical Latin America"
  )
)

regions <- regions %>%
  mutate(entity = as.character(entity))


# make data sets for risk factors via region line plots

air_pollution_regions <- regions %>%
  select(
    entity,
    year,
    air_pollution,
    outdoor_air_pollution
  )

write_rds(air_pollution_regions, file = here("death_risk_factors", "data", "air_pollution_regions.rds"), "gz")

substance_use_regions <- regions %>%
  select(
    entity,
    year,
    secondhand_smoke,
    alcohol_use,
    drug_use,
    smoking
  )

write_rds(substance_use_regions, file = here("death_risk_factors", "data", "substance_use_regions.rds"), "gz")

sanitation_regions <- regions %>%
  select(
    entity,
    year,
    unsafe_water_source,
    unsafe_sanitation,
    no_access_to_handwashing_facility
  )

write_rds(sanitation_regions, file = here("death_risk_factors", "data", "sanitation_regions.rds"), "gz")
