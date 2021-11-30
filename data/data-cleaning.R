# Load packages -----------------------------------------------------

library(tidyverse)
library(here)
library(janitor)
library(maps)
library(readxl)
library(janitor)

# Load data for pollutants ----------------------------------------------------

# air pollution data
death_rates_from_air_pollution <- read_csv(
  here("data", "death-rates-from-air-pollution.csv"),
  show_col_types = FALSE
)

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
    death_rate_air_pollution =
      deaths_air_pollution_sex_both_age_age_standardized_rate,
    death_rate_household_pollution = deaths_household_air_pollution_from_solid_fuels_sex_both_age_age_standardized_rate,
    death_rate_ambient_matter_pollution = deaths_ambient_particulate_matter_pollution_sex_both_age_age_standardized_rate,
    death_rate_ozone_pollution =
      deaths_ambient_ozone_pollution_sex_both_age_age_standardized_rate
  )

number_deaths_by_risk_factor <- number_deaths_by_risk_factor %>%
  clean_names()

# joining air pollution data together
air_pollution_joined <- death_rates_from_air_pollution %>%
  left_join(number_deaths_by_risk_factor, by = c("entity", "year", "code"))

# A series of case_when (before join) to resolve inconsistencies
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

# load filtered population data
# population data from [Our World in Data](https://ourworldindata.org/grapher/population?time=1899..latest&country=AFG~Africa~ALB~DZA~ASM~AND~AGO~AIA~ATG~ARM~ABW~ARG~Asia~AUS~AUT~AZE~BHS~BHR~BGD
# https://ourworldindata.org/grapher/population?time=1899..latest&country=AFG~Africa~ALB~DZA~ASM~AND~AGO~AIA~ATG~ARM~ABW~ARG~Asia~AUS~AUT~AZE~BHS~BHR~BGD)

population <- read_rds(
  here("data", "population_data.RData"))

population <- population %>%
  mutate(entity = case_when(
    entity == "United States" ~ "USA",
    entity == "United Kingdom" ~ "UK",
    entity == "Czechia" ~ "Czech Republic",
    entity == "Congo" ~ "Republic of Congo",
    entity == "Democratic Republic of Congo" ~ "Democratic Republic of the Congo",
    TRUE ~ entity
  ))

total_joined <- total_joined %>%
  left_join(population, by = c("region" = "entity", "year"))

total_joined <- total_joined %>%
  group_by(region, year) %>%
  mutate(unsafe_water_source_rate = unsafe_water_source / population_historical_estimates * 100000,
         unsafe_sanitation_rate = unsafe_sanitation / population_historical_estimates * 100000,
         no_access_to_handwashing_facility_rate = no_access_to_handwashing_facility / population_historical_estimates * 100000,
         household_air_pollution_from_solid_fuels_rate = household_air_pollution_from_solid_fuels / population_historical_estimates * 100000,
         non_exclusive_breastfeeding_rate = non_exclusive_breastfeeding / population_historical_estimates * 100000,
         household_air_pollution_from_solid_fuels_rate = household_air_pollution_from_solid_fuels / population_historical_estimates * 100000,
         non_exclusive_breastfeeding_rate = non_exclusive_breastfeeding / population_historical_estimates * 100000,
         discontinued_breastfeeding_rate = discontinued_breastfeeding / population_historical_estimates * 100000,
         child_wasting_rate = child_wasting / population_historical_estimates * 100000,
         child_stunting_rate = child_stunting / population_historical_estimates * 100000,
         low_birth_weight_for_gestation_rate = low_birth_weight_for_gestation / population_historical_estimates * 100000,
         secondhand_smoke_rate = secondhand_smoke / population_historical_estimates * 100000,
         alcohol_use_rate = alcohol_use / population_historical_estimates * 100000,
         drug_use_rate = drug_use / population_historical_estimates * 100000,
         diet_low_in_fruits_rate = diet_low_in_fruits / population_historical_estimates * 100000,
         diet_low_in_vegetables_rate = diet_low_in_vegetables / population_historical_estimates * 100000,
         unsafe_sex_rate = unsafe_sex/ population_historical_estimates * 100000,
         low_physical_activity_rate = low_physical_activity / population_historical_estimates * 100000,
         high_fasting_plasma_glucose_rate = high_fasting_plasma_glucose / population_historical_estimates * 100000,
         high_total_cholesterol_rate = high_total_cholesterol / population_historical_estimates * 100000,
         high_body_mass_index_rate = high_body_mass_index / population_historical_estimates * 100000,
         high_systolic_blood_pressure_rate = high_systolic_blood_pressure / population_historical_estimates * 100000,
         smoking_rate = smoking / population_historical_estimates * 100000,
         iron_deficiency_rate = iron_deficiency / population_historical_estimates * 100000,
         vitamin_a_deficiency_rate = vitamin_a_deficiency / population_historical_estimates * 100000,
         low_bone_mineral_density_rate = low_bone_mineral_density / population_historical_estimates * 100000,
         air_pollution_rate = air_pollution / population_historical_estimates * 100000,
         outdoor_air_pollution_rate = outdoor_air_pollution / population_historical_estimates * 100000,
         diet_high_in_sodium_rate = diet_high_in_sodium / population_historical_estimates * 100000,
         diet_low_in_whole_grains_rate = diet_low_in_whole_grains / population_historical_estimates * 100000,
         diet_low_in_nuts_and_seeds_rate = diet_low_in_nuts_and_seeds / population_historical_estimates * 100000)

# write rds file for total joined

write_rds(total_joined, here("data", "compressed_final_data.rds"), "gz")

# for regions line plot

# filter for regions
regions <- air_pollution_joined %>%
  filter(entity == "Central Asia" |
           entity == "Central Europe" |
           entity == "Central Latin America"|
           entity == "Central Sub-Saharan Africa" |
           entity == "East Asia "|
           entity == "Eastern Europe"|
           entity == "Eastern Sub-Saharan Africa"|
           entity == "Latin America and Caribbean"|
           entity == "North Africa and Middle East"|
           entity == "North America"|
           entity == "South Asia"|
           entity == "Southeast Asia"|
           entity == "Southern Latin America"|
           entity == "Southern Sub-Saharan Africa"|
           entity == "Sub-Saharan Africa"|
           entity == "Tropical Latin America"|
           entity == "Western Europe"|
           entity == "Western Sub-Saharan Africa")

# relevel factors
regions$entity <- factor(regions$entity,
                         levels = c("Central Asia",
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
                                    "Tropical Latin America"))

# make datasets for risk factors via region line plots

substance_use_regions <- regions %>%
  select(entity, code, year,
         secondhand_smoke,
         alcohol_use,
         drug_use,
         smoking)

write_rds(substance_use_regions, "data/substance_use_regions.rds", "gz")


diet_regions <- regions %>%
  select(entity, code, year,
         diet_low_in_fruits,
         diet_low_in_vegetables,
         diet_low_in_nuts_and_seeds,
         diet_low_in_whole_grains,
         diet_high_in_sodium)

write_rds(diet_regions, "data/diet_regions.rds", "gz")

sanitation_regions <- regions %>%
  select(entity, code, year,
         unsafe_water_source,
         unsafe_sanitation,
         no_access_to_handwashing_facility)

write_rds(sanitation_regions, "data/sanitation_regions.rds", "gz")

health_regions <- regions %>%
  select(entity, code, year,
         low_physical_activity,
         high_fasting_plasma_glucose,
         high_total_cholesterol,
         high_body_mass_index,
         high_systolic_blood_pressure,
         iron_deficiency,
         vitamin_a_deficiency,
         low_bone_mineral_density)

write_rds(health_regions, "data/health_regions.rds", "gz")

post_natal_care_regions <- regions %>%
  select(entity, code, year,
         non_exclusive_breastfeeding,
         discontinued_breastfeeding,
         child_wasting,
         child_stunting,
         low_birth_weight_for_gestation)

write_rds(post_natal_care_regions, "data/post_natal_care_regions.rds", "gz")