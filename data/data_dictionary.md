# Data Dictionary 

## World Pollution Data:

Source: [Kaggle](https://www.kaggle.com/pavan9065/air-pollution?select=death-rates-from-air-pollution.csv)


### death-rates-from-air-pollution:

|Variable         |Description |
|:----------------|:-----------|
|entity           | Country |
|code             | Code of country  |
|year             | Year of measurement |
|death_rate_air_pollution | Death rate from air pollution | 
|death_rate_household_pollution | Death rate from household pollution | 
|death_rate_ambient_matter_pollution | Death rate from ambient matter pollution | 
|death_rate_ozone_pollution | Death rate from ozone pollution | 

According to [Our World in Data](https://ourworldindata.org/air-pollution), 
"Death rates are measured as the number of deaths per 100,000 population from 
both outdoor and indoor air pollution. Rates are
age-standardized, meaning they assume a constant age structure of the 
population to allow for comparisons between countries and over time."

### number_deaths_by_riskfactor:

|Variable         |Description |
|:----------------|:-----------|
|entity           | Country |
|code             | Code of country  |
|year             | Year of measurement |
|unsafe_water_source |Total annual number of deaths from unsafe water source | 
|unsafe_sanitation | Total annual number of deaths from unsafe sanitation|  
|no_access_to_handwashing_facility | Total annual number of deaths from no access to handwashing facility| 
|household_air_pollution_from_solid_fuels | Total annual number of deaths from household air pollution from solid fuels | 
|non_exclusive_breastfeeding | Total annual number of deaths from non exclusive breastfeeding| 
|discontinued_breastfeeding | Total annual number of deaths from discontinued breastfeeding| 
|child_wasting | Total annual number of deaths from child wasting| 
|child_stunting |Total annual number of deaths from child stunting| 
|low_birth_weight_for_gestation | Total annual number of deaths from low birth weight for gestation| 
|secondhand_smoke | Total annual number of deaths from secondhand smoke| 
|alcohol_use | Total annual number of deaths from alcohol use| 
|diet_low_in_fruits | Total annual number of deaths from diet low in fruits |  
|diet_low_in_vegetables | Total annual number of deaths from diet low in vegetables| 
|unsafe_sex | Total annual number of deaths from unsafe sex| 
|low_physical_activity | Total annual number of deaths from low physical activity| 
|high_fasting_plasma_glucose | Total annual number of deaths from high fasting plasma glucose| 
|high_total_cholesterol | Total annual number of deaths from high total cholesterol| 
|high_systolic_blood_pressure | Total annual number of deaths from high systolic blood pressure | 
|smoking | Total annual number of deaths from smoking| 
|iron_deficiency | Total annual number of deaths from iron deficiency| 
|vitamin_a_deficiency | Total annual number of deaths from vitamin a deficiency| 
|low_bone_mineral_density | Total annual number of deaths from low bone mineral density| 
|air_pollution | Total annual number of deaths from air pollution| 
|outdoor_air_pollution | Total annual number of deaths from outdoor air pollution| 
|diet_high_in_sodium | Total annual number of deaths from diet high in sodium| 
|diet_low_in_whole_grains | Total annual number of deaths from diet low in whole grains | 
|diet_low_in_nuts_and_seeds | Total annual number of deaths from diet low in nuts and seeds|

## World Map Data: 

Source: Maps Package

### world_map
|Variable         |Description |
|:----------------|:-----------|
|long           | Longitude |
|lat             | Latitude |
|group            |Group Code |
|order | Order to connect polygons| 
|region | Region Name| 
|subregion | Subregion Name | 

## Pollution Data 

Source: [Our World in Data](https://ourworldindata.org/grapher/population?time=1899..latest&country=AFG~Africa~ALB~DZA~ASM~AND~AGO~AIA~ATG~ARM~ABW~ARG~Asia~AUS~AUT~AZE~BHS~BHR~BGD)



|Variable         |Description |
|:----------------|:-----------|
|entity           | Entity name |
|code |           | Code for entity | 
|year             | Year data was collected |
|population_historical_estimates    | Estimated population size in the designated year |

## RDS Files We Created For Visualizations: 

## compressed_final_data.rds

|Variable         |Description |
|:----------------|:-----------|
|long           | Longitude |
|lat             | Latitude |
|group            |Group Code |
|order | Order to connect polygons| 
|region | Region Name| 
|subregion | Subregion Name | 
|year | Year | 
|death_rate_air_pollution | Death rate for air pollution (age standardized)| 
|death_rate_household_pollution | Death rate for household pollution (age standardized)| 
|death_rate_ambient_matter_pollution  | Death rate for ambient matter pollution (age standardized) | 
|death_rate_ozone_polluton | Death rate for ozone polluton (age standardized) | 
|unsafe_water_source_rate | Death rate for unsafe water source| 
|unsafe_sanitation_rate | Death rate for unsafe sanitation| 
|no_access_to_handwashing_station_rate | Death rate for no access to handwashing station| 
|household_air_pollution_from_solid_fules_rate | Death rate for household air pollution from solid fuels| 
|non_exclusive_breastfeeding_rate | Death rate for non exclusive breastfeeding| 
|discontinued_breastfeeding_rate | Death rate for discontinued breastfeeding | 
|child_wasting_rate| Death rate for child wasting| 
|child_stunting_rate| Death rate for child stunting| 
|low_birth_rate_for_gestation_rate | Death rate for low birth rate for gestation | 
|secondhand_smoke_rate | Death rate for second hand smoke| 
|alcohol_use_rate | Death rate for alcoholuse| 
|drug_use_rate | Death rate for drug use| 
|diet_low_in_fruits_rate | Death rate for diet low in fruits| 
|diet_low_in_vegtables_rate | Death rate for diet low in vegtables| 
|unsafe_sex_rate | Death rate for unsafe sex| 
|low_physical_activity_rate | Death rate for low physical activity| 
|high_fasting_plasma_glucose_rate | Death rate for high fasting plasma glucose| 
|high_total_cholesterol_rate | Death rate for high total cholesterol| 
|high_body_mass_index_rate | Death rate for high body mass index| 
|high_systolic_blood_pressure_rate | Death rate for high systolic blood pressure| 
|smoking_rate | Death rate for smoking| 
|iron_deficiency_rate | Death rate for iron deficiency| 
|vitamin_a_deficiency_rate | Death rate for vitamin a deficiency| 
|low_bone_mineral_density_rate | Death rate for  low bone mineral density| 
|air_pollution_rate | Death rate for| air pollution 
|outdoor_air_pollution_rate |  Death rate for outdoor air pollution| 
|diet_high_in_sodium_rate | Death rate for diet high in sodium| 
|diet_low_in_whole_grains_rate | Death rate for diet low in whole grains| 
|diet_low_in_nuts_and_seeds_rate | Death rate for diet low in nuts and seeds| 

## air_pollution_regions.rds

|Variable         |Description |
|:----------------|:-----------|
|entity           | Region name |
|year             | Year data was collected |
|air_pollution    | Number of deaths attributed to air pollution |
|outdoor_air_pollution | Number of deaths attributed to outdoor air pollution | 

## substance_use_regions.rds

|Variable         |Description |
|:----------------|:-----------|
|entity           | Region name |
|year             | Year data was collected |
|secondhand_smoke    | Number of deaths attributed to secondhand smoke |
|alcohol_use | Number of deaths attributed to alcohol use | 
|drug_use | Number of deaths attributed to drug use | 
|smoking | Number of deaths attributed to smoking | 


## sanitation_regions.rds 

|Variable         |Description |
|:----------------|:-----------|
|entity           | Region name |
|year             | Year data was collected |
|unsafe_water_source    | Number of deaths attributed to unsafe water source |
|unsafe_sanitation | Number of deaths attributed to unsafe sanitation | 
|no_access_to_handwashing_facility | Number of deaths attributed to no access to handwashing facility | 
