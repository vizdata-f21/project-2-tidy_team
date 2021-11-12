# Data Dictionary 

## World Pollution Data:

Source: [Kaggle](https://www.kaggle.com/pavan9065/air-pollution?select=death-rates-from-air-pollution.csv)
  
### death-rates-total-air-pollution:

|Variable         |Description |
|:----------------|:-----------|
|entity           | Country |
|code             | Code of country  |
|year             | Year of measurement |
|death_rate_air_pollution | Death rate from air pollution | 

According to [Our World in Data](https://ourworldindata.org/air-pollution), 
"Death rates are measured as the number of deaths per 100,000 population from 
both outdoor and indoor air pollution. Rates are
age-standardized, meaning they assume a constant age structure of the 
population to allow for comparisons between countries and over time."

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

## GDP per Capita Data:

Source: [The World Bank](https://data.worldbank.org/indicator/NY.GDP.PCAP.CD?end=2017&start=1990)

### gdp_by_country:

|Variable         |Description |
|:----------------|:-----------|
|country_name | Country |
|country_code | Code of Country |
|x1990 | The year 1990 |
|x1991 | The year 1991 |
|x1992 | The year 1992 |
|x1993 | The year 1993 |
|x1994 | The year 1994 |
|x1995 | The year 1995 |
|x1996 | The year 1996 |
|x1997 | The year 1997 |
|x1998 | The year 1998 |
|x1999 | The year 1999 |
|x2000 | The year 2000 |
|x2001 | The year 2001 |
|x2002 | The year 2002 |
|x2003 | The year 2003 |
|x2004 | The year 2004 |
|x2005 | The year 2005 |
|x2006 | The year 2006 |
|x2007 | The year 2007 |
|x2008 | The year 2008 |
|x2009 | The year 2009 |
|x2010 | The year 2010 |
|x2011 | The year 2011 |
|x2012 | The year 2012 |
|x2013 | The year 2013 |
|x2014 | The year 2014 |
|x2015 | The year 2015 |
|x2016 | The year 2016 |
|x2017 | The year 2017 |


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
