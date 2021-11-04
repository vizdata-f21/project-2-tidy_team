Project Work
================

## Load Data

``` r
# air pollution data
death_rates_total_air_pollution_csv <- read_csv(here("data", "death-rates-total-air-pollution.csv"))
death_rates_from_air_pollution_csv <- read_csv(here("data", "death-rates-from-air-pollution.csv"))
share_deaths_air_pollution_csv <- read_csv(here("data", "share-deaths-air-pollution.csv"))
number_deaths_by_risk_factor_csv <- read_csv(here("data","number-of-deaths-by-risk-factor.csv"))

# added _csv ending to eliminate need for naming later versions "clean"

# world map data 
world_map <- map_data("world") %>% as_tibble()
```

``` r
death_rates_total_air_pollution <- death_rates_total_air_pollution_csv %>%
  clean_names() %>% 
  rename(death_rate_air_pollution = 
           deaths_air_pollution_sex_both_age_age_standardized_rate)

death_rates_from_air_pollution <- death_rates_from_air_pollution_csv %>%
  clean_names() %>% 
  rename(death_rate_air_pollution = 
           deaths_air_pollution_sex_both_age_age_standardized_rate, 
       death_rate_household_pollution = deaths_household_air_pollution_from_solid_fuels_sex_both_age_age_standardized_rate, 
       death_rate_ambient_matter_pollution = deaths_ambient_particulate_matter_pollution_sex_both_age_age_standardized_rate, 
       death_rate_ozone_pollution = 
         deaths_ambient_ozone_pollution_sex_both_age_age_standardized_rate)

#this looks messy but the column names are originally super long 

share_deaths_air_pollution <- share_deaths_air_pollution_csv %>% 
  clean_names() %>% 
  rename(share_death_air_pollution = air_pollution_total_ihme_2019)

number_deaths_by_risk_factor <- number_deaths_by_risk_factor_csv %>% 
  clean_names()
```

``` r
test_df <- death_rates_total_air_pollution %>% 
  full_join(world_map, by = c("entity" = "region")) %>% 
  filter(year == 1990) #becasue this is a static version of the later product

ggplot(test_df, aes(long, lat)) + 
  geom_polygon(aes(group = group, fill = death_rate_air_pollution), color = "black") + 
  coord_map(projection = "mercator", 
            xlim = c(-180, 180)) + 
  theme_void()
```

![](Project_Work_files/figure-gfm/world%20map%20plot-1.png)<!-- -->
